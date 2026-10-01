from services.approvals.advance_helpers import normalize_source, get_cash_composition_for_error
from services.core.storage_service import allowed_file
import json
import os
import uuid
from datetime import datetime, timezone
from fastapi import APIRouter, Depends, Header, Request
from fastapi.responses import JSONResponse
from starlette.concurrency import run_in_threadpool
from starlette.datastructures import UploadFile as StarletteUploadFile
from config import Config
from core.security import get_current_user
import shutil
from models import Advance, BankAccount, BankTransaction, OverrideLog, Settlement, User, db



settlements_disbursement_router = APIRouter(prefix="/api/settlements", tags=["settlements"])


async def _read_payload(request: Request):
    content_type = request.headers.get("content-type", "")
    if "multipart/form-data" in content_type or "application/x-www-form-urlencoded" in content_type:
        form = await request.form()
        data = {key: value for key, value in form.items() if not isinstance(value, StarletteUploadFile)}
        files = {}
        for key in form.keys():
            uploaded = [value for value in form.getlist(key) if isinstance(value, StarletteUploadFile)]
            if uploaded:
                files[key] = uploaded
        return data, files
    if "application/json" in content_type:
        try:
            payload = await request.json()
            return (payload if isinstance(payload, dict) else {}), {}
        except (ValueError, TypeError):
            return {}, {}
    return {}, {}



@settlements_disbursement_router.post("/{settlement_id}/save-disbursement")
async def save_disbursement(settlement_id: int, request: Request, user: User = Depends(get_current_user)):
    data, files = await _read_payload(request)
    return await run_in_threadpool(_save_disbursement, settlement_id, user, data, files)

def _save_disbursement(settlement_id, user, data, files):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = Settlement.query.get_or_404(settlement_id)

    if settlement.status not in ("draft", "rejected", "submitted", "approved"):
        return JSONResponse(content={"error": "Tabel ini hanya bisa diubah saat pengajuan belum selesai (Completed)."}, status_code=400)

    # Set modified flag
    settlement.modified_t2 = True
    settlement.is_disbursement_approved = False

    if "bank_id" in data:
        settlement.bank_id = data["bank_id"]
    if "disbursement_source" in data:
        settlement.disbursement_source = normalize_source(data["disbursement_source"])
        settlement.bank_id = None
    if "disbursement_source_id" in data and data["disbursement_source_id"]:
        try:
            b_id = int(data["disbursement_source_id"])
            bank = BankAccount.query.get(b_id)
            if not bank:
                return JSONResponse(content={"error": "Sumber dana (disbursement) tidak valid."}, status_code=400)
            settlement.disbursement_source_id = b_id
        except ValueError:
            pass
    if "admin_fee" in data:
        settlement.admin_fee = float(data["admin_fee"])
    if "disbursement_comment" in data:
        settlement.disbursement_comment = (
            str(data["disbursement_comment"]).strip() or None
        )
    if "disbursement_date" in data and data["disbursement_date"]:
        try:
            settlement.disbursement_date = datetime.fromisoformat(data["disbursement_date"].replace('Z', '+00:00')).date()
        except ValueError:
            pass
    if "disbursed_amount" in data:
        settlement.disbursed_amount = float(data["disbursed_amount"])
        # Use approved_amount instead of total_amount for calculating returns.
        # This ensures that items not approved must be returned.
        current_approved = settlement.approved_amount

        # Logic Kembalian (Tabel 3): Hanya ada jika Uang Kantor > Total Pengeluaran Approved
        # Selisih = Disbursed - Approved
        diff = (settlement.disbursed_amount or 0.0) - current_approved

        if diff <= 0.01:  # Uang pas atau kurang (reimbursement)
            settlement.returned_amount = 0.0
            settlement.return_source = "-"
            settlement.return_description = None
            settlement.return_evidence_path = None
            settlement.return_evidence_filename = None
            settlement.return_status = "pending"
            settlement.is_return_approved = False
            settlement.modified_t3 = False
        else:
            settlement.returned_amount = diff
            # Rule 2: Refresh Sumber Dana, Deskripsi, dan Amount pada Tabel 3
            if not settlement.return_source or settlement.return_source == "-":
                settlement.return_source = settlement.disbursement_source
                settlement.return_source_id = settlement.disbursement_source_id

            if settlement.settlement_type == "batch":
                pass # settlement.return_description = settlement.title
            else:
                settlement.return_description = (
                    settlement.expenses[0].description
                    if settlement.expenses
                    else settlement.title
                )

    # Handle Evidence (Merging Existing + New)
    existing_paths = []
    existing_filenames = []

    if "existing_disbursement_evidence_paths" in data:
        try:
            existing_paths = json.loads(data["existing_disbursement_evidence_paths"])
        except Exception:
            existing_paths = []

    if "existing_disbursement_evidence_filenames" in data:
        try:
            existing_filenames = json.loads(
                data["existing_disbursement_evidence_filenames"]
            )
        except Exception:
            existing_filenames = []

    new_paths = []
    new_filenames = []
    if "evidence" in files:
        files = files.get("evidence", [])
        for file in files:
            if file and file.filename and allowed_file(file.filename):
                ext = file.filename.rsplit(".", 1)[1].lower()
                unique_name = f"{uuid.uuid4().hex}.{ext}"
                now = datetime.now()
                year_month = f"{now.year}/{now.month:02d}"
                upload_dir = os.path.join(
                    Config.UPLOAD_FOLDER, "receipts", year_month
                )
                os.makedirs(upload_dir, exist_ok=True)
                with open(os.path.join(upload_dir, unique_name), "wb") as destination:
                    shutil.copyfileobj(file.file, destination)
                new_paths.append(f"receipts/{year_month}/{unique_name}")
                new_filenames.append(file.filename)

    final_paths = existing_paths + new_paths
    final_filenames = existing_filenames + new_filenames

    settlement.disbursement_evidence_path = (
        "|".join(final_paths) if final_paths else None
    )
    settlement.disbursement_evidence_filename = (
        "|".join(final_filenames) if final_filenames else None
    )

    db.session.commit()
    db.session.refresh(settlement)
    return JSONResponse(content=
        {
            "message": "Data pengiriman berhasil disimpan",
            "settlement": settlement.to_dict(),
        }
    , status_code=200)

@settlements_disbursement_router.post("/{settlement_id}/save-return")
async def save_return(settlement_id: int, request: Request, user: User = Depends(get_current_user)):
    data, files = await _read_payload(request)
    return await run_in_threadpool(_save_return, settlement_id, user, data, files)

def _save_return(settlement_id, user, data, files):
    user_id = user.id
    settlement = Settlement.query.get_or_404(settlement_id)

    if user.role not in ["manager", "super_manager"] and settlement.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    if settlement.status not in ("draft", "rejected"):
        return JSONResponse(content={"error": "Tabel ini hanya bisa diubah dalam mode Draft."}, status_code=400)

    # Set modified flag
    settlement.modified_t3 = True
    settlement.is_return_approved = False
    settlement.return_status = "pending"

    if settlement.return_status == "submitted" and user.role not in [
        "manager",
        "super_manager",
    ]:
        return JSONResponse(content=
            {"error": "Data sedang disubmit, tidak bisa diubah. Tunggu review manager."}
        , status_code=400)
    if "returned_amount" in data:
        settlement.returned_amount = float(data["returned_amount"])
    if "return_source" in data:
        settlement.return_source = normalize_source(data["return_source"])
    if "return_source_id" in data and data["return_source_id"]:
        try:
            r_id = int(data["return_source_id"])
            bank = BankAccount.query.get(r_id)
            if not bank:
                return JSONResponse(content={"error": "Bank tujuan pengembalian tidak valid."}, status_code=400)
            settlement.return_source_id = r_id
        except ValueError:
            pass
    if "return_description" in data:
        settlement.return_description = str(data["return_description"]).strip() or None

    if settlement.returned_amount and (
        not settlement.return_source or settlement.return_source == "-"
    ):
        settlement.return_source = normalize_source(settlement.disbursement_source)

    if not settlement.returned_amount:
        settlement.return_source = "-"

    # Reset status ke pending jika sedang rejected atau submitted (saat ditarik kembali/diedit)
    if settlement.return_status in ("rejected", "submitted"):
        settlement.return_status = "pending"

    # Handle Evidence (Merging Existing + New)
    existing_paths = []
    existing_filenames = []

    if "existing_return_evidence_paths" in data:
        try:
            existing_paths = json.loads(data["existing_return_evidence_paths"])
        except Exception:
            existing_paths = []

    if "existing_return_evidence_filenames" in data:
        try:
            existing_filenames = json.loads(data["existing_return_evidence_filenames"])
        except Exception:
            existing_filenames = []

    new_paths = []
    new_filenames = []
    if "return_evidence" in files:
        files = files.get("return_evidence", [])
        for file in files:
            if file and file.filename and allowed_file(file.filename):
                ext = file.filename.rsplit(".", 1)[1].lower()
                unique_name = f"{uuid.uuid4().hex}.{ext}"
                now = datetime.now()
                year_month = f"{now.year}/{now.month:02d}"
                upload_dir = os.path.join(
                    Config.UPLOAD_FOLDER, "receipts", year_month
                )
                os.makedirs(upload_dir, exist_ok=True)
                with open(os.path.join(upload_dir, unique_name), "wb") as destination:
                    shutil.copyfileobj(file.file, destination)
                new_paths.append(f"receipts/{year_month}/{unique_name}")
                new_filenames.append(file.filename)

    final_paths = existing_paths + new_paths
    final_filenames = existing_filenames + new_filenames

    settlement.return_evidence_path = "|".join(final_paths) if final_paths else None
    settlement.return_evidence_filename = (
        "|".join(final_filenames) if final_filenames else None
    )

    db.session.commit()
    db.session.refresh(settlement)
    return JSONResponse(content=
        {
            "message": "Data pengembalian berhasil disimpan",
            "settlement": settlement.to_dict(),
        }
    , status_code=200)

@settlements_disbursement_router.post("/{settlement_id}/approve-disbursement")
def approve_disbursement(settlement_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    settlement = Settlement.query.get_or_404(settlement_id)
    if (
        not (settlement.disbursement_source or "").strip()
        or settlement.disbursement_source == "-"
    ):
        return JSONResponse(content={"error": "Pilih Sumber Dana terlebih dahulu"}, status_code=400)

    settlement.is_disbursement_approved = True

    # Rule: Jika semua T1 sudah approved, ubah status dokumen menjadi "approved"
    all_t1_approved = all(i.status in ("approved", "completed", "in_settlement") for i in settlement.expenses)
    if all_t1_approved:
        settlement.status = "approved"

    # Rule 2: Refresh Sumber Dana, Deskripsi, dan Amount pada Tabel 3 saat Approve Tabel 2
    if settlement.returned_amount and settlement.returned_amount > 0.01:
        if not settlement.return_source or settlement.return_source == "-":
            settlement.return_source = settlement.disbursement_source

        if settlement.settlement_type == "batch":
            pass # settlement.return_description = settlement.title
        else:
            settlement.return_description = (
                settlement.expenses[0].description
                if settlement.expenses
                else settlement.title
            )

    # Log workflow
    # ── VALIDASI SALDO (JIKA ADA NOMINAL YANG HARUS DIBAYARKAN) ─────────────────
    disburse_amount = settlement.disbursed_amount or 0.0
    if disburse_amount > 0.01:
        from models import BankAccount
        from services.balance.balance_service import calculate_bank_composition

        req_name = settlement.creator.full_name if settlement.creator else "Karyawan"
        source_bank_name = (settlement.disbursement_source or "").strip()
        
        # Ambil SEMUA main bank
        all_main_banks = BankAccount.query.filter(
            BankAccount.company == settlement.company,
            BankAccount.account_type != "advance",
        ).all()
        
        # Utamakan exact match (case insensitive)
        main_bank = next((b for b in all_main_banks if b.name.strip().lower() == source_bank_name.lower()), None)
        if not main_bank:
            main_bank = next((b for b in all_main_banks if source_bank_name.lower() in b.name.strip().lower()), None)

        if not main_bank:
            return JSONResponse(content={"error": f"Bank sumber {source_bank_name} tidak valid atau tidak ditemukan."}, status_code=400)

        # 2. Cari semua bank advance milik user ini
        advance_banks = BankAccount.query.filter(
            BankAccount.account_type == "advance",
            BankAccount.user_id == settlement.user_id,
            BankAccount.company == settlement.company,
        ).all()

        if advance_banks:
            # Cek saldo specific di akun advance user
            specific_available = 0.0
            all_main_bank_ids = [b.id for b in all_main_banks]
            for adv_b in advance_banks:
                comp = calculate_bank_composition(adv_b.id, all_main_bank_ids)
                avail = comp.get(main_bank.id, 0.0)
                specific_available += avail

            if disburse_amount > specific_available:
                return JSONResponse(content=
                        {
                            "error": f"Gagal approve: Saldo {source_bank_name} Anda di akun Advance tidak mencukupi untuk pencairan Rp {disburse_amount:,.0f}.",
                            "insufficient_advance_balance": True,
                            "needed": disburse_amount,
                            "available": specific_available,
                            "shortfall": disburse_amount - specific_available,
                            "user_id": settlement.user_id,
                            "user_name": f"{req_name} ({source_bank_name})",
                        }
                    , status_code=422)
        else:
            # Jika user tidak memiliki akun advance, cek Saldo Real Bank
            from services.balance.balance_service import calculate_bank_real_balance
            main_bank_balance = calculate_bank_real_balance(main_bank.id)

            if disburse_amount > main_bank_balance:
                return JSONResponse(content=
                        {
                            "error": f"Gagal approve: Saldo Real Bank {main_bank.name} tidak mencukupi untuk pencairan Rp {disburse_amount:,.0f}.",
                            "insufficient_advance_balance": False,
                            "needed": disburse_amount,
                            "available": main_bank_balance,
                            "shortfall": disburse_amount - main_bank_balance,
                        }
                    , status_code=422)
    # --------------------------

    if main_bank:
        settlement.disbursement_source_id = main_bank.id

    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="settlement",
        document_id=settlement.id,
        from_status=settlement.status,
        to_status=settlement.status,
        action="approve_t2",
        user_id=user.id,
    )

    # Determine next stage
    update_document_stage(settlement, "final_pending")

    db.session.commit()
    return JSONResponse(content=
        {
            "message": "Tabel Pengiriman Dana telah disetujui",
            "settlement": settlement.to_dict(),
        }
    , status_code=200)



@settlements_disbursement_router.post("/standalone_return")
async def standalone_return(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    data, files = await _read_payload(request)
    return await run_in_threadpool(
        _standalone_return, user, company or "EWI Foundation", data, files
    )

def _standalone_return(user, company, data, files):
    user_id = user.id
    amount = float(data.get("amount", 0))
    source = data.get("source", "-")
    description = data.get("description", "Pengembalian Dana Mandiri (Standalone)")
    report_year = int(data.get("report_year", datetime.now().year))

    if amount <= 0:
        return JSONResponse(content={"error": "Nominal pengembalian harus lebih dari 0"}, status_code=400)

    advance_id = data.get("advance_id")
    target_adv = None
    if advance_id and str(advance_id).isdigit():
        target_adv = Advance.query.get(int(advance_id))

    # Create a settlement document for this return
    settlement = Settlement(
        title=f"Standalone Return - {user.full_name}",
        description=description,
        user_id=user_id,
        advance_id=target_adv.id if target_adv else None,
        document_date=datetime.now(timezone.utc).date(),
        settlement_type="single",
        status="completed",  # Completed langsung karena ini pengembalian mandiri
        report_year=report_year,
        company=company,
        returned_amount=amount,
        return_source=source,
        return_description=description,
        is_return_approved=True,
        return_status="approved",
        is_disbursement_approved=True,
        current_stage="completed",
    )

    if target_adv:
        target_adv.returned_amount = (target_adv.returned_amount or 0.0) + amount
        target_adv.is_return_approved = True
        if (target_adv.approved_amount or 0.0) - target_adv.returned_amount <= 0.01:
            target_adv.status = 'completed'

    # Handle Evidence
    if "evidence" in files:
        file = files["evidence"][0]
        if file and file.filename and allowed_file(file.filename):
            ext = file.filename.rsplit(".", 1)[1].lower()
            unique_name = f"return_{uuid.uuid4().hex}.{ext}"
            now = datetime.now()
            year_month = f"{now.year}/{now.month:02d}"
            upload_dir = os.path.join(
                Config.UPLOAD_FOLDER, "receipts", year_month
            )
            os.makedirs(upload_dir, exist_ok=True)
            with open(os.path.join(upload_dir, unique_name), "wb") as destination:
                    shutil.copyfileobj(file.file, destination)
            settlement.return_evidence_path = f"receipts/{year_month}/{unique_name}"
            settlement.return_evidence_filename = file.filename

    db.session.add(settlement)
    db.session.flush() # Flush to get settlement.id

    from services.balance.balance_service import calculate_user_available_budget, calculate_user_running_balance
    current_plafon = calculate_user_available_budget(user_id, company)
    current_hutang = calculate_user_running_balance(user_id, company)
    req_name = user.full_name

    # ── Buat BankTransaction: Tambah saldo bank tujuan (refund) & kurangi debt virtual ───

    if amount > 0 and source and source != "-":
        bank = BankAccount.query.filter(
            BankAccount.name.ilike(f"%{source}%"),
            BankAccount.company == company,
        ).first()

        if bank:
            settlement.return_source_id = bank.id

        txn = BankTransaction(
            bank_id=bank.id if bank else None,
            date=datetime.now(timezone.utc).date(),
            description=f"Pengembalian Dana - {req_name}: {description} (Ref: #{settlement.id})",
            amount_idr=amount,
            transaction_type="income",
            group_name="Pengembalian Dana",
            report_year=report_year,
            company=company,
        )
        db.session.add(txn)

        # Kembalikan plafon virtual manager sebesar nominal yang direfund
        adv_bank = BankAccount.query.filter(
            BankAccount.account_type == "advance",
            BankAccount.user_id == user_id,
            BankAccount.company == company,
        ).first()

        if adv_bank:
            adv_txn = BankTransaction(
                bank_id=adv_bank.id,
                date=datetime.now(timezone.utc).date(),
                description=f"Pengembalian Dana (Plafon Virtual) - {req_name}\n{description} (Ref: #{settlement.id})",
                amount_idr=amount,
                transaction_type="income",
                group_name="Pengembalian Dana",
                report_year=report_year,
                company=company,
            )
            db.session.add(adv_txn)

            # Dummy Advance HANYA dibuat jika user memilih "Semua Kasbon" (tidak ada target_adv spesifik)
            if not target_adv:
                dummy_adv = Advance(
                    title=f"Pengembalian Dana Mandiri (Ref: #{settlement.id})",
                    description=f"Dipotong otomatis dari pengembalian dana sebesar Rp {amount:,.2f}",
                    user_id=user_id,
                    status="completed",
                    advance_type="single",
                    company=company,
                    report_year=report_year,
                    bank_id=adv_bank.id,
                    disbursed_amount=-amount,
                    returned_amount=0.0,
                    approved_amount_override=-amount,
                    is_disbursement_approved=True,
                )
                db.session.add(dummy_adv)

            # --- Logbook ---
            from services.balance.user_balance_service import get_all_users_balance_breakdown
            all_bk = get_all_users_balance_breakdown(company).get(str(user_id), {})
            current_hutang = all_bk.get("active_advance_balance", 0.0)
            target_bank_name = bank.name if bank else (source if source != "-" else "Mandiri")
            bank_item = next((b for b in all_bk.get("breakdown", []) if b["bank_name"].lower() == target_bank_name.lower()), None)
            bank_hutang = bank_item["balance"] if bank_item else 0.0

            log_payload = {
                "type": "return",
                "source_bank": target_bank_name,
                "recipient_name": req_name,
                "amount": amount,
                "starting_balance": current_plafon,
                "revised_amount": current_plafon + amount,
                "hutang": current_hutang,
                "hutang_bank": bank_hutang,
                "hutang_bank_name": target_bank_name,
                "reason": "Pengembalian Dana Mandiri (Standalone)",
                "document_name": settlement.title,
                "performer": req_name,
                "target_bank": target_bank_name,
            }
            log_entry = OverrideLog(
                item_id=settlement.id,
                item_type="settlement",
                changed_by=user_id,
                original_amount=current_plafon,
                revised_amount=current_plafon + amount,
                notes="JSON:" + json.dumps(log_payload),
            )
            db.session.add(log_entry)

    db.session.commit()

    return JSONResponse(content=
        {
            "message": "Pengembalian dana berhasil dicatat dan disetujui otomatis.",
            "settlement": settlement.to_dict(),
        }
    , status_code=201)

