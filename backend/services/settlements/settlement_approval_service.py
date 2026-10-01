from services.approvals.settlement_helpers import _sync_advance_after_settlement, rollback_settlement_transactions
import json
import os
from datetime import datetime, timezone
from config import Config
from fastapi.responses import JSONResponse
from models import BankTransaction, Notification, Settlement, User, db, Advance, BankAccount, OverrideLog
from services.core.notification_events import (
    notify_settlement_approved_final,
    notify_settlement_approved_item,
    notify_settlement_rejected,
    notify_settlement_submitted,
)
from utils.parsing_helper import (
    _has_unchecked_checklist,
    _has_unchecked_return_checklist,
    _merge_rejection_notes,
)
from services.balance.balance_service import calculate_user_running_balance, calculate_user_available_budget
from utils.workflow_helper import log_workflow, update_document_stage

def _calculate_settlement_per_bank_netting(settlement):
    """
    Calculates per-bank kasbon deductions and reimbursement/shortfall for a settlement.
    Returns:
        dict: {
            'disbursed_amount': float, # Table 2 reimbursement
            'netting_deduction': float, # Total kasbon deduction
            'per_bank_deductions': dict, # {bank_name: amount_deducted}
            'usage_reimbursement': float,
            'total_shortfall': float,
        }
    """
    from services.balance.user_balance_service import get_all_users_balance_breakdown
    all_balances = get_all_users_balance_breakdown(settlement.company)
    user_bal_data = all_balances.get(str(settlement.user_id), {})
    breakdown = user_bal_data.get("breakdown", [])

    usage_reimbursement = 0.0
    usage_per_bank = {}

    for e in settlement.expenses:
        st = (e.status or "").lower()
        if st in ("rejected", "cancelled"):
            continue
        amt = float(e.idr_amount or 0.0)
        src = (e.source or "").strip()
        if not src or src in ("-", "null", "reimbursement", "Reimbursement"):
            usage_reimbursement += amt
        else:
            src_lower = src.lower()
            usage_per_bank[src_lower] = usage_per_bank.get(src_lower, 0.0) + amt

    total_shortfall = 0.0
    total_deduction = 0.0
    per_bank_deductions = {}

    for bank_key, used_amt in usage_per_bank.items():
        avail = 0.0
        matched_real_name = bank_key.capitalize()
        for b in breakdown:
            b_name = (b.get("bank_name") or "").strip()
            b_name_lower = b_name.lower()
            if bank_key == b_name_lower or bank_key in b_name_lower or b_name_lower in bank_key:
                avail = float(b.get("balance") or 0.0)
                matched_real_name = b_name
                break

        if used_amt > avail:
            shortfall = used_amt - avail
            deduct = avail
        else:
            shortfall = 0.0
            deduct = used_amt

        total_shortfall += shortfall
        total_deduction += deduct
        if deduct > 0.01:
            per_bank_deductions[matched_real_name] = deduct

    disbursed_amt = usage_reimbursement + total_shortfall
    return {
        "disbursed_amount": disbursed_amt,
        "netting_deduction": total_deduction,
        "per_bank_deductions": per_bank_deductions,
        "usage_reimbursement": usage_reimbursement,
        "total_shortfall": total_shortfall,
    }


def process_submit_settlement(settlement_id, user_id):
    user = User.query.get(user_id)
    settlement = Settlement.query.get_or_404(settlement_id)

    user = User.query.get(user_id)
    is_manager = user.role in ["manager", "super_manager"]
    if not is_manager and settlement.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    if settlement.status not in ("draft", "rejected"):
        return JSONResponse(content={"error": "Settlement sudah disubmit"}, status_code=400)
    if len(settlement.expenses) == 0:
        return JSONResponse(content={"error": "Tambahkan minimal 1 expense"}, status_code=400)
    unresolved_expense = next(
        (
            expense
            for expense in settlement.expenses
            if _has_unchecked_checklist(expense)
        ),
        None,
    )
    if unresolved_expense is not None:
        unresolved_description = unresolved_expense.description
        return JSONResponse(content=
            {
                "error": f'Expense "{unresolved_description}" masih memiliki komentar revisi yang belum dicentang.'
            }
        , status_code=400)

    # Simpan status lama untuk gating
    was_draft_or_rejected = settlement.status in ("draft", "rejected")

    settlement.status = "submitted"
    settlement.submitted_at = datetime.now(timezone.utc)
    for expense in settlement.expenses:
        if expense.status not in ("approved", "completed"):
            expense.status = "submitted"
    _sync_advance_after_settlement(settlement)

    # ✅ AUTO-SYNC Table 2 & 3: Refresh data dari Tabel 1
    current_total = sum((e.idr_amount or 0) for e in settlement.expenses)

    # Rule 1: Jika Tabel 2 tidak dimodifikasi, hitung sesuai per-bank kasbon
    if not settlement.modified_t2:
        netting_res = _calculate_settlement_per_bank_netting(settlement)
            
        # In a running balance (Plafon) system, unused Kasbon is NOT automatically returned.
        # Only preserve returned_amount if the user explicitly modified Table 3.
        if not getattr(settlement, 'modified_t3', False):
            settlement.returned_amount = 0.0
            
        settlement.disbursed_amount = netting_res["disbursed_amount"]
        settlement.netting_deduction = netting_res["netting_deduction"]

        # Sync deskripsi juga untuk konsistensi saat submit
        if settlement.settlement_type == "batch":
            pass # settlement.disbursement_comment = settlement.title
            pass # settlement.return_description = settlement.title
        else:
            if settlement.expenses:
                pass # settlement.disbursement_comment = settlement.expenses[0].description
                pass # settlement.return_description = settlement.expenses[0].description

    # Table 3 completeness check (NO LONGER MANDATORY FOR SUBMISSION)
    if (settlement.returned_amount or 0) > 0.01:
        if settlement.return_status in ("pending", "rejected"):
            # Validasi checklist jika pernah ditolak
            if (
                settlement.return_status == "rejected"
                and _has_unchecked_return_checklist(settlement)
            ):
                return JSONResponse(content=
                    {
                        "error": "Tabel Pengembalian Dana masih memiliki komentar revisi yang belum dicentang."
                    }
                , status_code=400)

            # Only set to submitted if data is complete
            if (
                settlement.return_source
                and settlement.return_source != "-"
                and settlement.return_evidence_path
            ):
                settlement.return_status = "submitted"
            else:
                # Keep as pending if incomplete
                settlement.return_status = "pending"
    # Identify modified parts
    modified_parts = []
    if settlement.modified_t1:
        modified_parts.append("Tabel 1 (Rincian)")
    if settlement.modified_t2:
        modified_parts.append("Tabel 2 (Pengiriman)")
    if settlement.modified_t3:
        modified_parts.append("Tabel 3 (Pengembalian)")

    # ✅ FINAL Gating for Table 3 Verification Buttons:
    # Jika data Tabel 3 belum lengkap, paksa statusnya ke 'pending' agar tombol centang/silang tidak muncul.
    if (settlement.returned_amount or 0) > 0:
        if (
            not settlement.return_source
            or settlement.return_source == "-"
            or not settlement.return_evidence_path
        ):
            settlement.return_status = "pending"

    parts_str = ", ".join(modified_parts) if modified_parts else "Update Header/Lainnya"

    # Reset tracking flags
    settlement.modified_t1 = False
    settlement.modified_t2 = False
    settlement.modified_t3 = False

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="settlement",
        document_id=settlement.id,
        from_status="draft" if was_draft_or_rejected else settlement.status,
        to_status="submitted",
        action="submit",
        user_id=user_id,
        comment=parts_str,
    )
    update_document_stage(settlement, "t1_pending")

    db.session.commit()

    # Notify manager & staff
    notify_settlement_submitted(settlement, user, parts_str)

    return JSONResponse(content={"settlement": settlement.to_dict(include_expenses=True)}, status_code=200)


def process_approve_settlement(settlement_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = Settlement.query.get_or_404(settlement_id)
    if settlement.status != "submitted":
        return JSONResponse(content={"error": "Hanya settlement submitted yang bisa diapprove"}, status_code=400)

    # Pastikan SEMUA item sudah diapprove oleh manager secara individu
    for expense in settlement.expenses:
        if expense.status not in ["approved", "completed"]:
            return JSONResponse(content=
                {
                    "error": f'Gagal approve: Item "{expense.description}" masih berstatus {expense.status}. '
                    "Semua item harus disetujui (Approved) secara individu terlebih dahulu."
                }
            , status_code=400)

    # ✅ FIX: Lock the user record to prevent race conditions during auto-netting calculation
    locked_user = User.query.with_for_update().get(settlement.user_id)

    # Handle Override Nominal
    data = request_data or {}
    override_amount = data.get("approved_amount")
    override_notes = data.get("override_notes")

    if override_amount is not None:
        try:
            override_amount = float(override_amount)
            original_amount = sum(
                (e.idr_amount or 0)
                for e in settlement.expenses
                if e.status == "approved"
            )
            if abs(original_amount - override_amount) > 0.01:
                settlement.approved_amount_override = override_amount
                # Write to OverrideLog
                from models import OverrideLog

                log = OverrideLog(
                    item_id=settlement.id,
                    item_type="settlement",
                    changed_by=user.id,
                    original_amount=original_amount,
                    revised_amount=override_amount,
                    notes=override_notes or "Revisi nominal oleh Manager",
                )
                db.session.add(log)
        except (ValueError, TypeError):
            pass

    # Status akan diset di akhir berdasarkan kebutuhan Tabel 2

    # Rule 1 & 3: Refresh data Tabel 2 & Tabel 3 dari Tabel 1
    if settlement.settlement_type == "batch":
        desc_val = settlement.title
    else:
        desc_val = (
            settlement.expenses[0].description
            if settlement.expenses
            else settlement.title
        )

    pass # settlement.disbursement_comment = desc_val
    pass # settlement.return_description = desc_val

    # ─── Kalkulasi net_disbursed & returned_amount ────────────────────────
    netting_res = _calculate_settlement_per_bank_netting(settlement)
    net_disbursed = netting_res["disbursed_amount"]
    netting_deduction = netting_res["netting_deduction"]
    settlement.netting_deduction = netting_deduction
    returned_amount = 0.0

    needs_t2 = net_disbursed > 0.01
    needs_t3 = False

    # Reset semua flag T2 & T3 terlebih dahulu
    settlement.modified_t2 = False
    settlement.is_disbursement_approved = False
    settlement.modified_t3 = False
    settlement.is_return_approved = False

    if not needs_t2 and not needs_t3:
        # T2 & T3 TIDAK diperlukan — kasbon menutup semua atau tidak ada pengeluaran reimbursement
        settlement.disbursed_amount = 0.0
        settlement.is_disbursement_approved = True
        settlement.returned_amount = 0.0
        settlement.is_return_approved = True
        if not settlement.disbursement_source or settlement.disbursement_source == "-":
            settlement.disbursement_source = "Lain-lainnya"
        settlement.status = "approved"

    elif needs_t2:
        # T2 DIPERLUKAN — perusahaan harus bayar selisih reimbursement ke pegawai
        settlement.disbursed_amount = net_disbursed
        settlement.is_disbursement_approved = False
        settlement.returned_amount = 0.0
        settlement.is_return_approved = True
        settlement.status = "submitted"

    elif needs_t3:
        # T3 DIPERLUKAN — pegawai harus kembalikan selisih ke perusahaan
        settlement.disbursed_amount = 0.0
        settlement.is_disbursement_approved = True
        settlement.returned_amount = returned_amount
        settlement.is_return_approved = False
        settlement.status = "submitted"

    # Hapus notifikasi deadline yang sudah tidak relevan
    Notification.query.filter_by(
        target_type="settlement",
        target_id=settlement.id,
        action_type="deadline_warning",
    ).delete()
    _sync_advance_after_settlement(settlement)

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="settlement",
        document_id=settlement.id,
        from_status="submitted",
        to_status=settlement.status,
        action="approve_t1",
        user_id=user.id,
    )
    update_document_stage(settlement, "t2_pending")

    db.session.commit()

    # Notify staff
    notify_settlement_approved_item(settlement, user)

    return JSONResponse(content={"settlement": settlement.to_dict(include_expenses=True)}, status_code=200)


def process_complete_settlement(settlement_id, user_id):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = Settlement.query.get_or_404(settlement_id)
    # Hanya terima dari status 'approved' (backend sudah menjamin approved kalau T2 tidak perlu)
    if settlement.status not in ("approved", "completed"):
        return JSONResponse(content=
            {
                "error": "Hanya settlement approved yang bisa di-complete."
            }
        , status_code=400)

    for expense in settlement.expenses:
        if expense.status == "rejected":
            return JSONResponse(content=
                {
                    "error": "Settlement dengan item rejected tidak bisa masuk completed view"
                }
            , status_code=400)
        if expense.status == "pending":
            return JSONResponse(content=
                {"error": "Masih ada item pending, approve settlement terlebih dulu"}
            , status_code=400)

    if settlement.completed_at is None:
        settlement.completed_at = datetime.now(timezone.utc)

    if (settlement.disbursed_amount or 0.0) <= 0.01:
        if settlement.disbursement_evidence_path:
            file_path = os.path.join(Config.UPLOAD_FOLDER, settlement.disbursement_evidence_path)
            if os.path.exists(file_path):
                try:
                    os.remove(file_path)
                except Exception:
                    pass
        settlement.disbursed_amount = 0.0
        settlement.disbursement_source = None
        settlement.disbursement_comment = None
        settlement.disbursement_evidence_path = None
        settlement.disbursement_evidence_filename = None
        settlement.bank_id = None
        settlement.admin_fee = 0.0
        settlement.is_disbursement_approved = True
        settlement.modified_t2 = False

    if (settlement.returned_amount or 0.0) <= 0.01:
        if settlement.return_evidence_path:
            file_path = os.path.join(Config.UPLOAD_FOLDER, settlement.return_evidence_path)
            if os.path.exists(file_path):
                try:
                    os.remove(file_path)
                except Exception:
                    pass
        settlement.returned_amount = 0.0
        settlement.return_source = None
        settlement.return_description = None
        settlement.return_evidence_path = None
        settlement.return_evidence_filename = None
        settlement.is_return_approved = True
        settlement.return_status = "approved"
        settlement.return_notes = None
        settlement.modified_t3 = False

    settlement.status = "completed"
    for e in settlement.expenses:
        if e.status == "approved":
            e.status = "completed"
    _sync_advance_after_settlement(settlement)
    db.session.commit()
    return JSONResponse(content={"settlement": settlement.to_dict(include_expenses=True)}, status_code=200)


def process_reject_all_expenses(settlement_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = Settlement.query.get_or_404(settlement_id)
    if settlement.status not in ("submitted", "approved"):
        return JSONResponse(content=
            {"error": "Hanya settlement submitted/approved yang bisa diproses"}
        , status_code=400)

    data = request_data or {}
    rejection_notes = str(data.get("notes", "")).strip()
    if not rejection_notes:
        return JSONResponse(content={"error": "Alasan penolakan wajib diisi"}, status_code=400)

    for expense in settlement.expenses:
        if expense.status in ("pending", "approved"):
            expense.status = "rejected"
            expense.notes = _merge_rejection_notes(
                expense.notes or "", rejection_notes
            )

    settlement.status = "draft"
    Notification.query.filter_by(
        target_type="settlement",
        target_id=settlement.id,
        action_type="deadline_warning",
    ).delete()
    _sync_advance_after_settlement(settlement)

    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="settlement",
        document_id=settlement.id,
        from_status="submitted",
        to_status="draft",
        action="reject",
        user_id=user.id,
        comment=rejection_notes,
    )
    update_document_stage(settlement, "draft")

    db.session.commit()
    notify_settlement_rejected(settlement, user, rejection_notes)

    return JSONResponse(content={"settlement": settlement.to_dict(include_expenses=True)}, status_code=200)


def process_final_approve_settlement(settlement_id, user_id, request_data=None):
    user = db.session.get(User, user_id)
    if not user or user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = db.session.get(Settlement, settlement_id)
    if not settlement:
        return JSONResponse(content={"error": "Settlement tidak ditemukan"}, status_code=404)

    locked_user = db.session.query(User).with_for_update().get(settlement.user_id)

    from services.balance.balance_service import calculate_user_available_budget

    starting_budget = calculate_user_available_budget(
        settlement.user_id, settlement.company
    )
    current_log_balance = starting_budget

    # Auto-approve stage 1 if still submitted
    if settlement.status == "submitted":
        for expense in settlement.expenses:
            if expense.status not in ["approved", "completed"]:
                return JSONResponse(content=
                    {
                        "error": f'Gagal approve: Item "{expense.description}" masih berstatus {expense.status}. '
                        "Semua item harus disetujui (Approved) secara individu terlebih dahulu."
                    }
                , status_code=400)

        data = request_data or {}
        override_amount = data.get("approved_amount")
        override_notes = data.get("override_notes")

        if override_amount is not None:
            try:
                override_amount = float(override_amount)
                original_amount = sum(
                    (e.idr_amount or 0)
                    for e in settlement.expenses
                    if e.status == "approved"
                )
                if abs(original_amount - override_amount) > 0.01:
                    settlement.approved_amount_override = override_amount
                    from models import OverrideLog

                    log = OverrideLog(
                        item_id=settlement.id,
                        item_type="settlement",
                        changed_by=user.id,
                        original_amount=original_amount,
                        revised_amount=override_amount,
                        notes=override_notes or "Revisi nominal oleh Manager",
                    )
                    db.session.add(log)
            except (ValueError, TypeError):
                pass

        settlement.status = "approved"

        if settlement.settlement_type == "batch":
            desc_val = settlement.title
        else:
            desc_val = (
                settlement.expenses[0].description
                if settlement.expenses
                else settlement.title
            )

        pass # settlement.disbursement_comment = desc_val
        pass # settlement.return_description = desc_val

        # Hitung kalkulasi per bank
        netting_res = _calculate_settlement_per_bank_netting(settlement)
        netting_deduction = netting_res["netting_deduction"]
        disbursed_amount = netting_res["disbursed_amount"]
        settlement.netting_deduction = netting_deduction

        if not settlement.modified_t2:
            settlement.disbursed_amount = disbursed_amount

        if not getattr(settlement, 'modified_t3', False):
            settlement.returned_amount = 0.0

        if netting_deduction > 0.01:
            if (settlement.disbursed_amount or 0.0) <= 0.01:
                settlement.is_disbursement_approved = True
                if not settlement.disbursement_source or settlement.disbursement_source == "-":
                    settlement.disbursement_source = "Lain-lainnya"

    if settlement.status not in ("approved", "completed"):
        return JSONResponse(content=
            {
                "error": "Settlement harus disetujui manager (Table 1) sebelum final approve"
            }
        , status_code=400)

    # Auto-approve Table 2 if it's implicitly hidden (fully netted / Case 1 & 3)
    if (settlement.disbursed_amount or 0.0) <= 0.01:
        settlement.is_disbursement_approved = True
        if not settlement.disbursement_source:
            settlement.disbursement_source = "Lain-lainnya"
        
        # Bersihkan data ghost T2
        settlement.admin_fee = 0.0
        settlement.disbursement_evidence_path = None
        settlement.disbursement_evidence_filename = None
        settlement.disbursement_comment = None
        settlement.bank_id = None
        settlement.modified_t2 = False

    # Bersihkan data ghost T3 jika tersembunyi
    if (settlement.returned_amount or 0.0) <= 0.01:
        settlement.return_source = None
        settlement.return_description = None
        settlement.return_evidence_path = None
        settlement.return_evidence_filename = None
        settlement.is_return_approved = True
        settlement.return_status = "approved"
        settlement.return_notes = None
        settlement.modified_t3 = False

    if not settlement.is_disbursement_approved:
        return JSONResponse(content={"error": "Tabel Pengiriman Dana belum disetujui"}, status_code=400)

    # Logic Pemotongan Otomatis Langsung ke Bank Kasbon 1-to-1 (Mengurangi Hutang)
    from models import Advance, BankAccount, OverrideLog

    netting_res = _calculate_settlement_per_bank_netting(settlement)
    per_bank_deductions = netting_res.get("per_bank_deductions", {})
    total_deducted = netting_res.get("netting_deduction", 0.0)

    allocations = []
    if total_deducted > 0.01:
        req_name = settlement.creator.full_name if settlement.creator else "Karyawan"
        target_adv_bank = BankAccount.query.filter(
            BankAccount.account_type == "advance",
            BankAccount.user_id == settlement.user_id,
            BankAccount.company == settlement.company,
        ).first()

        bank_id = target_adv_bank.id if target_adv_bank else None
        
        from services.balance.user_balance_service import get_all_users_balance_breakdown
        all_bk = get_all_users_balance_breakdown(settlement.company).get(str(settlement.user_id), {})
        bk_list = all_bk.get("breakdown", [])

        if per_bank_deductions:
            for b_name, ded_amt in per_bank_deductions.items():
                bank_item = next((b for b in bk_list if b["bank_name"].lower() == b_name.lower()), None)
                start_h = bank_item["balance"] if bank_item else ded_amt
                rem_h = max(0.0, start_h - ded_amt)
                allocations.append({
                    "bank_id": bank_id,
                    "bank_name": b_name,
                    "deduction": ded_amt,
                    "starting_hutang": start_h,
                    "remaining_hutang": rem_h,
                })
                other_adv = Advance(
                    title=f"Penyelesaian Kasbon: {settlement.title} (Ref: #{settlement.id})",
                    description=f"Dipotong otomatis dari {b_name} sebesar Rp {ded_amt:,.2f} untuk Settlement #{settlement.id}",
                    user_id=settlement.user_id,
                    status="completed",
                    advance_type="single",
                    company=settlement.company,
                    report_year=datetime.now().year,
                    bank_id=bank_id,
                    disbursement_source=b_name,
                    disbursed_amount=-ded_amt,
                    returned_amount=0.0,
                    approved_amount_override=-ded_amt,
                    is_disbursement_approved=True,
                )
                db.session.add(other_adv)
        else:
            bank_name = target_adv_bank.name if target_adv_bank else "Plafon Virtual"
            allocations.append({"bank_id": bank_id, "bank_name": bank_name, "deduction": total_deducted})
            other_adv = Advance(
                title=f"Penyelesaian Kasbon: {settlement.title} (Ref: #{settlement.id})",
                description=f"Dipotong otomatis dari {bank_name} sebesar Rp {total_deducted:,.2f} untuk Settlement #{settlement.id}",
                user_id=settlement.user_id,
                status="completed",
                advance_type="single",
                company=settlement.company,
                report_year=datetime.now().year,
                bank_id=bank_id,
                disbursement_source=bank_name,
                disbursed_amount=-total_deducted,
                returned_amount=0.0,
                approved_amount_override=-total_deducted,
                is_disbursement_approved=True,
            )
            db.session.add(other_adv)

    # Finalize
    settlement.status = "completed"
    for e in settlement.expenses:
        if e.status == "approved":
            e.status = "completed"
    settlement.completed_at = datetime.now(timezone.utc)

    from models import BankAccount, OverrideLog

    req_name = settlement.creator.full_name if settlement.creator else "Karyawan"
    net_cash_disbursed = settlement.disbursed_amount or 0.0
    display_bank_name = "Plafon Virtual (Lain-lainnya)"

    # Always define doc_name and reason_label for the unified log
    doc_name = (
        settlement.title
        if settlement.settlement_type == "batch"
        else (
            settlement.expenses[0].description
            if settlement.expenses
            else settlement.title
        )
    )
    reason_label = f"Penyelesaian Settlement ({'Batch' if settlement.settlement_type == 'batch' else 'Single'})"

    # ==========================================
    # 1. VIRTUAL BANK (PLAFON) - LOOKUP ONLY (NO EXPENSE HERE)
    # ==========================================
    # CATATAN: Saldo Virtual Bank (Plafon) TIDAK dikurangi lagi di sini.
    # Pengurangan sudah terjadi saat Kasbon dicairkan (final_approve_advance).
    # Membuat BankTransaction expense lagi di sini akan menyebabkan double deduction:
    #   - Kasbon dicairkan   → Virtual Bank -Rp100k ✅
    #   - Settlement selesai → Virtual Bank -Rp100k lagi ❌ (sebelumnya ada bug di sini)
    # Pemotongan hutang karyawan sudah ditangani oleh dummy Advance (negative approved_amount_override)
    # yang dibuat di bagian atas fungsi ini.
    target_adv_bank = BankAccount.query.filter(
        BankAccount.account_type == "advance",
        BankAccount.user_id == settlement.user_id,
        BankAccount.company == settlement.company,
    ).first()

    # ==========================================
    # 2. MAIN BANK & VIRTUAL BANK - REIMBURSEMENT
    # ==========================================
    if net_cash_disbursed > 0.01:
        source_bank_name = (settlement.disbursement_source or "").strip()
        display_bank_name = source_bank_name or "Plafon Virtual"
        
        # Cari bank utama
        main_bank = None
        if source_bank_name:
            all_main_banks = BankAccount.query.filter(
                BankAccount.company == settlement.company,
                BankAccount.account_type != "advance",
            ).all()
            main_bank = next((b for b in all_main_banks if b.name.strip().lower() == source_bank_name.lower()), None)
            if not main_bank:
                main_bank = next((b for b in all_main_banks if source_bank_name.lower() in b.name.strip().lower()), None)
        
        # a. Expense dari Bank Utama (Uang keluar dari perusahaan)
        if main_bank:
            main_txn = BankTransaction(
                bank_id=main_bank.id,
                date=datetime.now(timezone.utc).date(),
                description=f"Pencairan Reimbursement Settlement - {req_name}\\n{doc_name} (Ref: #{settlement.id})",
                amount_idr=net_cash_disbursed,
                transaction_type="expense",
                group_name="Pencairan Settlement",
                report_year=settlement.report_year,
                company=settlement.company,
            )
            db.session.add(main_txn)

        # b. Expense ke Virtual Bank (Plafon) untuk pemotongan jatah plafon virtual karyawan
        if target_adv_bank:
            adv_txn_expense = BankTransaction(
                bank_id=target_adv_bank.id,
                date=datetime.now(timezone.utc).date(),
                description=f"Pencairan Reimbursement Settlement (Plafon Virtual) - {req_name}\n{doc_name} (Ref: #{settlement.id})",
                amount_idr=net_cash_disbursed,
                transaction_type="expense",
                group_name="Pencairan Settlement",
                report_year=settlement.report_year,
                company=settlement.company,
            )
            db.session.add(adv_txn_expense)

    # ✅ FIX: Create UNIFIED OverrideLog for Settlement
    # The user wants ALL settlements to appear in the Kasbon logbook history as a comprehensive record,
    # even if it's purely reimbursement and the Kasbon balance doesn't change.
    if total_deducted > 0.01 or net_cash_disbursed > 0.01:
        # Calculate final Plafon and Hutang
        final_plafon = current_log_balance - net_cash_disbursed + (settlement.returned_amount or 0.0)
        from services.balance.balance_service import calculate_user_running_balance
        current_hutang = calculate_user_running_balance(settlement.user_id, settlement.company)

        # If Hutang is 0 or less, don't include it in payload so it hides in UI
        hutang_display = current_hutang if current_hutang > 0.01 else None

        if per_bank_deductions:
            display_bank_name = ", ".join(per_bank_deductions.keys())
        elif settlement.disbursement_source and settlement.disbursement_source not in ("Lain-lainnya", "-"):
            display_bank_name = settlement.disbursement_source
        elif target_adv_bank:
            display_bank_name = target_adv_bank.name
        else:
            display_bank_name = "Bank Cash"

        log_payload = {
            "type": "settlement_combined",
            "starting_balance": current_log_balance,
            "revised_amount": final_plafon,
            "total_settlement": total_deducted + net_cash_disbursed,
            "netting_deduction": total_deducted,
            "cash_disbursed": net_cash_disbursed,
            "starting_hutang": current_hutang + total_deducted,
            "remaining_hutang": current_hutang,
            "hutang": hutang_display,
            "recipient_name": req_name,
            "manager_name": user.full_name,
            "reason": reason_label,
            "document_name": doc_name,
            "bank_name": display_bank_name,
            "allocations": allocations if allocations else [],
        }
        log_entry = OverrideLog(
            item_id=settlement.id,
            item_type="settlement",
            changed_by=user.id,
            original_amount=current_log_balance,
            revised_amount=final_plafon,
            notes="JSON:" + json.dumps(log_payload),
        )
        db.session.add(log_entry)
        current_log_balance = final_plafon

    _sync_advance_after_settlement(settlement)

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="settlement",
        document_id=settlement.id,
        from_status="approved",
        to_status="completed",
        action="final_approve",
        user_id=user.id,
    )
    update_document_stage(settlement, "completed")

    db.session.commit()

    notify_settlement_approved_final(settlement, user)

    return JSONResponse(content=
        {"message": "Settlement disetujui final", "settlement": settlement.to_dict()}
    , status_code=200)




