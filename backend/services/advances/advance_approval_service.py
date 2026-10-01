from services.approvals.advance_helpers import get_cash_composition_for_error, normalize_source, _advance_view_status_filter, _editable_revision_no, _items_for_revision, _next_revision_no, _status_after_approval
import json
import os
from datetime import datetime, timezone
from fastapi.responses import JSONResponse
from models import BankTransaction, Notification, Settlement, User, db, Advance, AdvanceItem, BankAccount, OverrideLog
from services.core.notification_events import (
    notify_advance_approved_final,
    notify_advance_item_approved,
    notify_advance_item_rejected,
    notify_advance_rejected_final,
    notify_advance_revision_started,
    notify_advance_submitted,
)
from utils.parsing_helper import (
    _has_unchecked_checklist,
    _has_unchecked_return_checklist,
    _merge_rejection_notes,
)
from services.balance.balance_service import calculate_user_running_balance, calculate_user_available_budget
from utils.workflow_helper import log_workflow, update_document_stage

def process_start_revision(advance_id, user_id, request_data=None):
    user_id = user_id
    advance = Advance.query.get_or_404(advance_id)

    user = User.query.get(user_id)
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and advance.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    if advance.status != "approved":
        return JSONResponse(content=
            {"error": "Revisi hanya bisa dibuat dari kasbon yang sudah disetujui"}
        , status_code=400)
    if advance.active_revision_no:
        return JSONResponse(content={"error": "Masih ada revisi yang belum selesai"}, status_code=400)

    advance.active_revision_no = _next_revision_no(advance)
    advance.status = "revision"
    db.session.commit()

    # Notify managers about revision

    notify_advance_revision_started(advance, User.query.get(user_id))

    return JSONResponse(content={"advance": advance.to_dict(include_items=True)}, status_code=200)


def process_submit_advance(advance_id, user_id, request_data=None):
    user_id = user_id
    user = User.query.get(user_id)
    advance = Advance.query.get_or_404(advance_id)

    user = User.query.get(user_id)
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and advance.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    if advance.status in ("draft", "rejected", "revision"):
        revision_no = 0
        next_status = "submitted"
    else:
        return JSONResponse(content={"error": "Kasbon saat ini tidak bisa disubmit"}, status_code=400)

    revision_items = _items_for_revision(advance, revision_no)
    if len(revision_items) == 0:
        return JSONResponse(content={"error": "Tambahkan minimal 1 item pengeluaran"}, status_code=400)
    unresolved_item = next(
        (item for item in revision_items if _has_unchecked_checklist(item)),
        None,
    )
    if unresolved_item:
        return JSONResponse(content=
            {
                "error": f'Item "{unresolved_item.description}" masih memiliki komentar revisi yang belum dicentang.'
            }
        , status_code=400)

    # Simpan status lama untuk gating
    was_draft_or_rejected = advance.status in (
        "draft",
        "rejected",
        "revision",
    )

    advance.status = next_status
    for item in revision_items:
        if item.status not in ("approved", "completed"):
            item.status = "submitted"

    # ✅ AUTO-SYNC Table 2 & 3: Refresh data dari Tabel 1
    current_total = sum((item.idr_amount or 0) for item in advance.items)

    # Rule 1: Jika Tabel 2 tidak dimodifikasi, paksa mengikuti total item (Uang Pas)
    if not advance.modified_t2:
        advance.disbursed_amount = current_total

        # Sync deskripsi juga untuk konsistensi saat submit
        if advance.advance_type == "batch":
            pass # advance.disbursement_comment = advance.title
            pass # advance.return_description = advance.title
        else:
            revision_items = _items_for_revision(advance, revision_no)
            if revision_items:
                pass # advance.disbursement_comment = revision_items[0].description
                pass # advance.return_description = revision_items[0].description

    disbursed_amt = advance.disbursed_amount or 0.0
    diff = disbursed_amt - current_total

    # Rule 1: Kolom Amount pada Tabel 3 tidak perlu diperbarui otomatis dari T1
    # Tapi kita tetap hitung returned_amount jika ini adalah pengajuan baru atau T2 berubah.
    # Namun, karena user minta T3 Amount tidak update dari T1, kita biarkan logic diff ini
    # hanya jika T2 juga berubah atau ini submit pertama kali.

    if diff <= 0.01:
        advance.returned_amount = 0.0
        # Cleanup only if it's not a return, ensure Table 3 is ignored
        advance.return_source = "-"
        advance.return_status = "pending"
        advance.is_return_approved = False
    else:
        advance.returned_amount = diff

    # Table 3 completeness check (NO LONGER MANDATORY FOR SUBMISSION)
    if (advance.returned_amount or 0) > 0:
        if advance.return_status in ("pending", "rejected"):
            # Validasi checklist jika pernah ditolak
            if advance.return_status == "rejected" and _has_unchecked_return_checklist(
                advance
            ):
                return JSONResponse(content=
                    {
                        "error": "Tabel Pengembalian Dana masih memiliki komentar revisi yang belum dicentang."
                    }
                , status_code=400)

            # Only set to submitted if data is complete
            if (
                advance.return_source
                and advance.return_source != "-"
                and advance.return_evidence_path
            ):
                advance.return_status = "submitted"
            else:
                # Keep as pending if incomplete
                advance.return_status = "pending"

    # Identify which tables were modified for notification
    modified_parts = []
    if advance.modified_t1:
        modified_parts.append("Tabel 1 (Rincian)")
    if advance.modified_t2:
        modified_parts.append("Tabel 2 (Pengiriman)")
    if advance.modified_t3:
        modified_parts.append("Tabel 3 (Pengembalian)")

    # ✅ FINAL Gating for Table 3 Verification Buttons:
    # Jika data Tabel 3 belum lengkap, paksa statusnya ke 'pending' agar tombol centang/silang tidak muncul.
    if (advance.returned_amount or 0) > 0:
        if (
            not advance.return_source
            or advance.return_source == "-"
            or not advance.return_evidence_path
        ):
            advance.return_status = "pending"

    parts_str = ", ".join(modified_parts) if modified_parts else "Update Header/Lainnya"

    # Reset tracking flags after successful submission
    advance.modified_t1 = False
    advance.modified_t2 = False
    advance.modified_t3 = False

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="advance",
        document_id=advance.id,
        from_status="draft" if was_draft_or_rejected else advance.status,
        to_status=next_status,
        action="submit",
        user_id=user_id,
        comment=parts_str,
    )
    update_document_stage(advance, "t1_pending")

    db.session.commit()

    # Notify managers
    notify_advance_submitted(advance, user, parts_str)

    return JSONResponse(content={"advance": advance.to_dict(include_items=True)}, status_code=200)


def process_approve_advance(advance_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    advance = Advance.query.get_or_404(advance_id)
    if advance.status not in ("submitted", "submitted"):
        return JSONResponse(content={"error": "Kasbon ini tidak sedang menunggu approval"}, status_code=400)

    # Support both JSON and Form data
    data = request_data or {}
    notes = data.get("notes", "").strip()

    # Handle Override Nominal
    override_amount = data.get("approved_amount")
    override_notes = data.get("override_notes")

    if override_amount is not None:
        try:
            override_amount = float(override_amount)
            original_amount = advance.approved_amount
            if abs(original_amount - override_amount) > 0.01:
                advance.approved_amount_override = override_amount
                # Write to OverrideLog
                from models import OverrideLog

                log = OverrideLog(
                    item_id=advance.id,
                    item_type="advance",
                    changed_by=user.id,
                    original_amount=original_amount,
                    revised_amount=override_amount,
                    notes=override_notes or "Revisi nominal oleh Manager",
                )
                db.session.add(log)
        except (ValueError, TypeError):
            pass

    if advance.status != "submitted":
        return JSONResponse(content={"error": "Kasbon tidak sedang menunggu approval"}, status_code=400)

    revision_no = 0
    items = _items_for_revision(advance, revision_no)
    for itm in items:
        if itm.status != "approved":
            return JSONResponse(content=
                {
                    "error": f'Gagal approve: Item "{itm.description}" belum disetujui. '
                    "Semua item harus disetujui (Approved) secara individu terlebih dahulu."
                }
            , status_code=400)

    # ── Cek saldo bank mencukupi ──────────────────────────────
    from services.balance.balance_service import calculate_user_available_budget

    req_name = advance.requester.full_name if advance.requester else "Karyawan"
    needed = advance.approved_amount
    available = calculate_user_available_budget(advance.user_id, advance.company)

    if available < needed:
        return JSONResponse(content=
            {
                "error": f"Total Saldo Bank Advance {req_name} tidak mencukupi. Dibutuhkan Rp {needed:,.0f}, tersedia Rp {available:,.0f}.",
                "insufficient_advance_balance": True,
                "needed": needed,
                "available": available,
                "shortfall": needed - available,
                "user_id": advance.user_id,
                "user_name": req_name,
                "cash_composition": get_cash_composition_for_error(advance),
            }
        , status_code=422)
    # ──────────────────────────────────────────────────────────────────

    advance.approved_revision_no = advance.active_revision_no or 0
    advance.active_revision_no = None
    advance.status = _status_after_approval(advance)
    if advance.status == "approved":
        advance.disbursed_amount = advance.total_amount
        advance.modified_t2 = False
        advance.is_disbursement_approved = False
        if advance.advance_type == "single" and advance.items:
            pass # advance.disbursement_comment = advance.items[0].description
        elif advance.advance_type == "batch":
            pass # advance.disbursement_comment = advance.title

    # Immediate cleanup for Advance deadline notification
    Notification.query.filter_by(
        target_type="advance", target_id=advance.id, action_type="deadline_warning"
    ).delete()

    if notes:
        advance.notes = _merge_rejection_notes(advance.notes or "", notes)

    advance.approved_at = datetime.now(timezone.utc)

    # Rule 1 & 3: Refresh data Tabel 2 & Tabel 3 dari Tabel 1
    # Ambil deskripsi terbaru
    if advance.advance_type == "batch":
        desc_val = advance.title
    else:
        # Untuk single, ambil rincian item pertama
        current_items = _items_for_revision(advance, advance.approved_revision_no or 0)
        desc_val = current_items[0].description if current_items else advance.title

    pass # advance.disbursement_comment = desc_val
    pass # advance.return_description = desc_val

    # Amount Tabel 2: Ambil ulang nilai Amount dari Tabel 1 (Rule 1)
    # Gunakan approved_amount property yang sudah menghitung total dari semua revision yang disetujui
    advance.disbursed_amount = advance.approved_amount

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="advance",
        document_id=advance.id,
        from_status="submitted",
        to_status=advance.status,
        action="approve_t1",
        user_id=user.id,
    )
    update_document_stage(advance, "t2_pending")

    db.session.commit()

    # Notify staff
    notify_advance_approved_final(advance, user)

    return JSONResponse(content={"advance": advance.to_dict(include_items=True)}, status_code=200)


def process_reject_advance(advance_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    advance = Advance.query.get_or_404(advance_id)
    if advance.status not in ("submitted", "submitted"):
        return JSONResponse(content={"error": "Kasbon ini tidak sedang menunggu approval"}, status_code=400)

    # Support both JSON and Form data
    data = request_data or {}
    notes = str(data.get("notes", "")).strip()
    if not notes:
        return JSONResponse(content={"error": "Alasan penolakan wajib diisi"}, status_code=400)

    if advance.status == "submitted":
        revision_no = 0
        advance.status = "draft"
    else:
        revision_no = advance.active_revision_no
        advance.status = "revision"

    if revision_no is None:
        return JSONResponse(content={"error": "Nomor revisi tidak ditemukan"}, status_code=400)

    for item in _items_for_revision(advance, revision_no):
        if item.status in ("pending", "approved"):
            item.status = "rejected"
            item.notes = _merge_rejection_notes(item.notes or "", notes)

    advance.notes = _merge_rejection_notes(advance.notes or "", notes)
    # Immediate cleanup for Advance deadline notification (back to draft)
    Notification.query.filter_by(
        target_type="advance", target_id=advance.id, action_type="deadline_warning"
    ).delete()
    db.session.commit()

    # Notify staff
    notify_advance_rejected_final(advance, user, notes)

    return JSONResponse(content={"advance": advance.to_dict(include_items=True)}, status_code=200)


def process_approve_advance_item(item_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    item = AdvanceItem.query.get_or_404(item_id)
    advance = item.advance
    if advance.status not in ("submitted", "submitted"):
        return JSONResponse(content={"error": "Kasbon ini tidak sedang menunggu approval"}, status_code=400)

    item.status = "approved"

    # Cek apakah kategori utama sudah diapprove
    if item.category.status == "pending":
        db.session.rollback()
        return JSONResponse(content=
            {
                "error": f'Kategori "{item.category.name}" belum disetujui oleh manager. Silakan setujui kategori ini terlebih dahulu.',
                "category_id": item.category_id,
                "reason": "category_unapproved",
            }
        , status_code=400)

    # Cek parent jika ada
    if item.category.parent and item.category.parent.status == "pending":
        db.session.rollback()
        return JSONResponse(content=
            {
                "error": f'Induk kategori "{item.category.parent.name}" belum disetujui. Silakan setujui kategori ini terlebih dahulu.',
                "category_id": item.category.parent_id,
                "reason": "category_unapproved",
            }
        , status_code=400)

    # Cek subcategories
    for sub in item.subcategories:
        if sub.status == "pending":
            db.session.rollback()
            return JSONResponse(content=
                {
                    "error": f'Sub-Kategori "{sub.name}" belum disetujui oleh Admin. Harap ACC di menu Pengaturan Kategori terlebih dahulu.',
                    "category_id": sub.id,
                    "reason": "category_unapproved",
                }
            , status_code=400)
    # Add balance check
    from services.balance.balance_service import calculate_user_available_budget

    already_approved = sum(
        (i.idr_amount or 0)
        for i in advance.items
        if i.status == "approved" and i.id != item.id
    )
    item_amount = item.estimated_amount * (
        item.currency_exchange if item.currency_exchange else 1
    )
    needed = already_approved + item_amount

    available = calculate_user_available_budget(advance.user_id, advance.company)
    if available < needed:
        shortfall = needed - available
        req_name = advance.requester.full_name if advance.requester else "Karyawan"
        db.session.rollback()  # rollback item.status change
        return JSONResponse(content=
            {
                "error": (
                    f"Saldo Advance {req_name} tidak mencukupi untuk menyetujui item ini. "
                    f"Dibutuhkan total Rp {needed:,.0f}, tersedia Rp {available:,.0f} "
                    f"(kekurangan Rp {shortfall:,.0f}). "
                    f"Silakan top-up saldo advance terlebih dahulu."
                ),
                "insufficient_advance_balance": True,
                "needed": needed,
                "available": available,
                "shortfall": shortfall,
                "user_id": advance.user_id,
                "user_name": req_name,
                "cash_composition": get_cash_composition_for_error(advance),
            }
        , status_code=422)
    # Recalculate Table 3 (Returned Amount)
    if advance.disbursed_amount is not None:
        current_approved = advance.approved_amount
        diff = advance.disbursed_amount - current_approved
        if diff > 0.01:
            advance.returned_amount = diff
        else:
            advance.returned_amount = 0.0

    # Sync Table 2 data when all items are fully approved
    all_approved = all(
        i.status in ("approved", "completed", "in_settlement") for i in advance.items
    )
    if all_approved:
        advance.disbursed_amount = advance.total_amount
        advance.modified_t2 = False
        advance.is_disbursement_approved = False
        if advance.advance_type == "single" and advance.items:
            pass # advance.disbursement_comment = advance.items[0].description
        elif advance.advance_type == "batch":
            pass # advance.disbursement_comment = advance.title

    db.session.commit()

    # Notify staff about item approval

    notify_advance_item_approved(advance, item, user)

    return JSONResponse(content={"item": item.to_dict()}, status_code=200)


def process_reject_advance_item(item_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    item = AdvanceItem.query.get_or_404(item_id)
    advance = item.advance
    if advance.status not in ("submitted", "submitted"):
        return JSONResponse(content={"error": "Kasbon ini tidak sedang menunggu approval"}, status_code=400)

    data = request_data or {}
    notes = data.get("notes", "").strip()
    if not notes:
        return JSONResponse(content={"error": "Alasan penolakan wajib diisi"}, status_code=400)

    item.status = "rejected"
    item.notes = _merge_rejection_notes(item.notes or "", notes)

    # Recalculate Table 3 (Returned Amount)
    if advance.disbursed_amount is not None:
        current_approved = advance.approved_amount
        diff = advance.disbursed_amount - current_approved
        if diff > 0.01:
            advance.returned_amount = diff
        else:
            advance.returned_amount = 0.0

    db.session.commit()

    # Notify staff about item rejection

    notify_advance_item_rejected(advance, item, user)

    return JSONResponse(content={"item": item.to_dict()}, status_code=200)


def process_final_approve_advance(advance_id, user_id, request_data=None):
    user = User.query.get(user_id)
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    advance = Advance.query.get_or_404(advance_id)

    # ✅ FIX: Lock the user record to prevent race conditions during concurrent final approvals
    locked_user = db.session.query(User).with_for_update().get(advance.user_id)

    if advance.status not in (
        "submitted",
        "submitted",
        "approved",
    ):
        return JSONResponse(content=
            {"error": "Kasbon ini tidak dalam status untuk final approval"}
        , status_code=400)

    # Sequential Gating Check
    # Remove auto-approval. All items must be approved individually via approve_advance_item.
    for item in advance.items:
        if item.status == "pending":
            return JSONResponse(content=
                {
                    "error": f'Gagal Final Approval: Item "{item.description}" masih berstatus pending. Semua item harus disetujui secara individu.'
                }
            , status_code=400)

    if advance.status in ("submitted", "submitted"):
        advance.status = "approved"
        # Refresh data Tabel 2 & Tabel 3 dari Tabel 1 (Rule 1 & 3)
        if advance.advance_type == "batch":
            desc_val = advance.title
        else:
            current_items = _items_for_revision(
                advance, advance.active_revision_no or 0
            )
            desc_val = current_items[0].description if current_items else advance.title

        pass # advance.disbursement_comment = desc_val
        pass # advance.return_description = desc_val
        advance.disbursed_amount = (
            advance.total_amount
        )  # Use total_amount for all items in draft/revision
        advance.approved_revision_no = (
            advance.active_revision_no or advance.approved_revision_no
        )
        advance.active_revision_no = None

        # ── Cek saldo bank mencukupi ──────────────────────────────
        from services.balance.balance_service import calculate_user_available_budget

        req_name = advance.requester.full_name if advance.requester else "Karyawan"
        needed = advance.approved_amount
        available = calculate_user_available_budget(advance.user_id, advance.company)

        if available < needed:
            return JSONResponse(content=
                {
                    "error": f"Total Saldo Bank Advance {req_name} tidak mencukupi. Dibutuhkan Rp {needed:,.0f}, tersedia Rp {available:,.0f}.",
                    "insufficient_advance_balance": True,
                    "needed": needed,
                    "available": available,
                    "shortfall": needed - available,
                    "user_id": advance.user_id,
                    "user_name": req_name,
                    "cash_composition": get_cash_composition_for_error(advance),
                }
            , status_code=422)
        # ──────────────────────────────────────────────────────────────────

    if not advance.is_disbursement_approved:
        return JSONResponse(content={"error": "Tabel Pengiriman Dana belum disetujui"}, status_code=400)

    # Removed Table 3 requirement for advances
    # if advance.returned_amount > 0 and not advance.is_return_approved:
    #     return JSONResponse({"error": "Tabel Pengembalian Dana belum disetujui"}), 400

    # Finalize
    advance.status = "completed"
    for item in advance.items:
        if item.status == "approved":
            item.status = "completed"
    advance.approved_at = datetime.now(timezone.utc)

    # ── EKSEKUSI TRANSAKSI BANK SAAT FINAL APPROVE ──────────────────────────
    from models import OverrideLog
    from services.balance.balance_service import calculate_user_available_budget

    disburse_amount = advance.disbursed_amount or advance.approved_amount or 0.0
    req_name = advance.requester.full_name if advance.requester else "Karyawan"

    # ✅ FIX: Ambil snapshot saldo awal SEBELUM ada transaksi baru ditambahkan ke session
    starting_budget = calculate_user_available_budget(advance.user_id, advance.company)

    if disburse_amount > 0.01:
        source_bank_name = (advance.disbursement_source or "").strip()

        doc_name = (
            advance.title
            if advance.advance_type == "batch"
            else (advance.items[0].description if advance.items else advance.title)
        )
        reason_label = f"Pencairan Kasbon ({'Batch' if advance.advance_type == 'batch' else 'Single'})"

        # 2. Catat Piutang (Hutang Karyawan) di Bank Virtual (Advance Bank / Plafon Karyawan)
        advance_bank = BankAccount.query.filter(
            BankAccount.account_type == "advance",
            BankAccount.user_id == advance.user_id,
            BankAccount.company == advance.company,
        ).first()

        if not advance_bank:
            # Auto-create Advance Bank if it doesn't exist
            advance_bank = BankAccount(
                name=f"Plafon {req_name}",
                account_type="advance",
                currency="IDR",
                company=advance.company,
                user_id=advance.user_id,
            )
            db.session.add(advance_bank)
            db.session.flush()  # get ID

        if advance_bank:
            advance.bank_id = (
                advance_bank.id
            )  # Wajib diset agar hutang tercatat di bank ini
            txn_adv = BankTransaction(
                bank_id=advance_bank.id,
                date=datetime.now(timezone.utc).date(),
                description=f"{reason_label} (Plafon Virtual) - {req_name}\\n{doc_name} (Ref: #{advance.id})",
                amount_idr=disburse_amount,
                transaction_type="expense",
                group_name="Pencairan Kasbon",
                report_year=advance.report_year,
                company=advance.company,
            )
            db.session.add(txn_adv)

            # B. Buat entri OverrideLog agar muncul di "Riwayat Aktivitas / Log Book" untuk akun Advance
            final_budget = starting_budget - disburse_amount
            from services.balance.user_balance_service import get_all_users_balance_breakdown

            all_bk = get_all_users_balance_breakdown(advance.company).get(str(advance.user_id), {})
            current_hutang = all_bk.get("active_advance_balance", 0.0)
            bank_item = next((b for b in all_bk.get("breakdown", []) if b["bank_name"].lower() == source_bank_name.lower()), None)
            bank_hutang = bank_item["balance"] if bank_item else 0.0

            log_payload = {
                "type": "disbursement",
                "source_bank": source_bank_name,
                "recipient_name": req_name,
                "amount": disburse_amount,
                "requested_amount": disburse_amount,
                "given_amount": disburse_amount,
                "starting_balance": starting_budget,
                "revised_amount": final_budget,
                "hutang": current_hutang,
                "hutang_bank": bank_hutang,
                "hutang_bank_name": source_bank_name,
                "reason": reason_label,
                "document_name": doc_name,
                "performer": user.full_name,
                "target_bank": advance_bank.name,
            }

            log_entry = OverrideLog(
                item_id=advance.id,  # Link ke Advance ID
                item_type="advance",
                changed_by=user.id,
                original_amount=starting_budget,
                revised_amount=final_budget,
                notes="JSON:" + json.dumps(log_payload),
            )
            db.session.add(log_entry)

    # ─────────────────────────────────────────────────────────────────────────

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="advance",
        document_id=advance.id,
        from_status="approved",
        to_status="completed",
        action="final_approve",
        user_id=user.id,
    )
    update_document_stage(advance, "completed")

    db.session.commit()
    notify_advance_approved_final(advance, user)

    return JSONResponse(content=
        {"message": "Kasbon berhasil disetujui final", "advance": advance.to_dict()}
    , status_code=200)









