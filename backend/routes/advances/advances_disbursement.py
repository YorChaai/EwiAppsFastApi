from services.approvals.advance_helpers import get_cash_composition_for_error, normalize_source
from services.core.storage_service import allowed_file
import json
import os
import uuid
from datetime import datetime

from fastapi import APIRouter, Depends, Request
from fastapi.responses import JSONResponse
from starlette.concurrency import run_in_threadpool
from starlette.datastructures import UploadFile as StarletteUploadFile
from config import Config
from core.security import get_current_user
import shutil

advances_disbursement_router = APIRouter(prefix="/api/advances", tags=["advances"])


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


from models import (
    Advance,
    BankAccount,
    User,
    db,
)



@advances_disbursement_router.post("/{advance_id}/save-disbursement")
async def save_disbursement(advance_id: int, request: Request, user: User = Depends(get_current_user)):
    data, files = await _read_payload(request)
    return await run_in_threadpool(_save_disbursement, advance_id, user, data, files)

def _save_disbursement(advance_id, user, data, files):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    advance = Advance.query.get_or_404(advance_id)

    if advance.status not in (
        "draft",
        "revision",
        "rejected",
        "rejected",
    ):
        return JSONResponse(content=
            {"error": "Tabel ini hanya bisa diubah dalam mode Draft atau Revisi."}
        , status_code=400)

    # Set modified flag
    advance.modified_t2 = True
    advance.is_disbursement_approved = False

    if "bank_id" in data:
        advance.bank_id = data["bank_id"]
    if "disbursement_source" in data:
        advance.disbursement_source = normalize_source(data["disbursement_source"])
        advance.bank_id = None
    if "disbursement_source_id" in data and data["disbursement_source_id"]:
        try:
            b_id = int(data["disbursement_source_id"])
            bank = BankAccount.query.get(b_id)
            if not bank:
                return JSONResponse(content={"error": "Sumber dana (disbursement) tidak valid."}, status_code=400)
            advance.disbursement_source_id = b_id
        except ValueError:
            pass
    if "admin_fee" in data:
        advance.admin_fee = float(data["admin_fee"])
    if "disbursement_comment" in data:
        advance.disbursement_comment = str(data["disbursement_comment"]).strip() or None
    if "disbursed_amount" in data:
        advance.disbursed_amount = float(data["disbursed_amount"])

        # Calculate currently approved amount for the active revision
        # This includes items already approved in previous revisions PLUS items approved in this revision
        # Actually, Advance has an 'approved_amount' property in models.py
        current_approved = advance.approved_amount

        # Logic Kembalian (Tabel 3): Hanya ada jika Uang Kantor > Total Pengeluaran Approved
        # Selisih = Disbursed - Approved
        diff = (advance.disbursed_amount or 0.0) - current_approved

        if diff <= 0.01:  # Uang pas atau kurang (reimbursement)
            advance.returned_amount = 0.0
            advance.return_source = "-"
            advance.return_description = None
            advance.return_evidence_path = None
            advance.return_evidence_filename = None
            advance.return_status = "pending"
            advance.is_return_approved = False
            advance.modified_t3 = False
        else:
            advance.returned_amount = diff
            # Rule 2: Refresh Sumber Dana, Deskripsi, dan Amount pada Tabel 3
            if not advance.return_source or advance.return_source == "-":
                advance.return_source = advance.disbursement_source
                advance.return_source_id = advance.disbursement_source_id

            if advance.advance_type == "batch":
                pass # advance.return_description = advance.title
            else:
                advance.return_description = (
                    advance.items[0].description if advance.items else advance.title
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

    advance.disbursement_evidence_path = "|".join(final_paths) if final_paths else None
    advance.disbursement_evidence_filename = (
        "|".join(final_filenames) if final_filenames else None
    )

    db.session.commit()
    db.session.refresh(advance)
    return JSONResponse(content=
        {"message": "Data pengiriman berhasil disimpan", "advance": advance.to_dict()}
    , status_code=200)

@advances_disbursement_router.post("/{advance_id}/save-return")
async def save_return(advance_id: int, request: Request, user: User = Depends(get_current_user)):
    data, files = await _read_payload(request)
    return await run_in_threadpool(_save_return, advance_id, user, data, files)

def _save_return(advance_id, user, data, files):
    user_id = user.id
    advance = Advance.query.get_or_404(advance_id)

    if user.role not in ["manager", "super_manager"] and advance.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    if advance.status not in (
        "draft",
        "revision",
        "rejected",
        "rejected",
    ):
        return JSONResponse(content=
            {"error": "Tabel ini hanya bisa diubah dalam mode Draft atau Revisi."}
        , status_code=400)

    # Set modified flag
    advance.modified_t3 = True
    advance.is_return_approved = False
    advance.return_status = "pending"

    if advance.return_status == "submitted" and user.role not in [
        "manager",
        "super_manager",
    ]:
        return JSONResponse(content=
            {"error": "Data sedang disubmit, tidak bisa diubah. Tunggu review manager."}
        , status_code=400)

    if "returned_amount" in data:
        advance.returned_amount = float(data["returned_amount"])
    if "return_source" in data:
        advance.return_source = normalize_source(data["return_source"])
    if "return_source_id" in data and data["return_source_id"]:
        try:
            r_id = int(data["return_source_id"])
            bank = BankAccount.query.get(r_id)
            if not bank:
                return JSONResponse(content={"error": "Bank tujuan pengembalian tidak valid."}, status_code=400)
            advance.return_source_id = r_id
        except ValueError:
            pass
    if "return_description" in data:
        advance.return_description = str(data["return_description"]).strip() or None

    if advance.returned_amount and (
        not advance.return_source or advance.return_source == "-"
    ):
        advance.return_source = normalize_source(advance.disbursement_source)

    if not advance.returned_amount:
        advance.return_source = "-"

    # Reset status ke pending jika sedang rejected atau submitted (saat ditarik kembali/diedit)
    if advance.return_status in ("rejected", "submitted"):
        advance.return_status = "pending"

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

    advance.return_evidence_path = "|".join(final_paths) if final_paths else None
    advance.return_evidence_filename = (
        "|".join(final_filenames) if final_filenames else None
    )

    db.session.commit()
    db.session.refresh(advance)
    return JSONResponse(content=
        {"message": "Data pengembalian berhasil disimpan", "advance": advance.to_dict()}
    , status_code=200)

@advances_disbursement_router.post("/{advance_id}/approve-disbursement")
def approve_disbursement(advance_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)

    advance = Advance.query.get_or_404(advance_id)
    if (
        not (advance.disbursement_source or "").strip()
        or advance.disbursement_source == "-"
    ):
        return JSONResponse(content={"error": "Pilih Sumber Dana terlebih dahulu"}, status_code=400)

    # ── VALIDASI SALDO (TANPA BUAT TRANSAKSI) ──────────────────────────────
    from models import BankAccount
    from services.balance.balance_service import (
        calculate_bank_composition,
    )

    disburse_amount = advance.disbursed_amount or advance.approved_amount or 0.0
    req_name = advance.requester.full_name if advance.requester else "Karyawan"

    # 1. Identifikasi bank utama yang dipilih di Tabel 2
    source_bank_name = (advance.disbursement_source or "").strip()
    
    # Ambil SEMUA main bank
    all_main_banks = BankAccount.query.filter(
        BankAccount.company == advance.company,
        BankAccount.account_type != "advance",
    ).all()
    
    # Utamakan exact match (case insensitive)
    main_bank = next((b for b in all_main_banks if b.name.strip().lower() == source_bank_name.lower()), None)
    if not main_bank:
        main_bank = next((b for b in all_main_banks if source_bank_name.lower() in b.name.strip().lower()), None)

    # 2. Cari semua bank advance milik user ini
    advance_banks = BankAccount.query.filter(
        BankAccount.account_type == "advance",
        BankAccount.user_id == advance.user_id,
        BankAccount.company == advance.company,
    ).all()

    # 3. Hitung berapa saldo dari bank yang dipilih tersebut yang ada di akun advance
    specific_available = 0.0
    best_adv_bank_id = None
    if main_bank and advance_banks:
        all_main_bank_ids = [b.id for b in all_main_banks]
        for adv_b in advance_banks:
            # Cek komposisi khusus untuk bank yang dipilih, wajib menyertakan semua main_bank_ids
            comp = calculate_bank_composition(adv_b.id, all_main_bank_ids)
            avail = comp.get(main_bank.id, 0.0)
            specific_available += avail
            
            # Find the best match for this main bank
            if not best_adv_bank_id:
                best_adv_bank_id = adv_b.id
            else:
                best_bank_name = BankAccount.query.get(best_adv_bank_id).name.lower()
                if main_bank.name.lower() in adv_b.name.lower():
                    best_adv_bank_id = adv_b.id
                elif avail > 0 and main_bank.name.lower() not in best_bank_name:
                    best_adv_bank_id = adv_b.id

    # Jika bank tidak ditemukan di daftar MAIN_BANKS, atau saldo spesifik kurang
    if disburse_amount > specific_available:
        return JSONResponse(content=
                {
                    "error": f"Gagal approve: Saldo {source_bank_name} Anda di akun Advance tidak mencukupi untuk pencairan Rp {disburse_amount:,.0f}.",
                    "insufficient_advance_balance": True,
                    "needed": disburse_amount,
                    "available": specific_available,
                    "shortfall": disburse_amount - specific_available,
                    "user_id": advance.user_id,
                    "user_name": f"{req_name} ({source_bank_name})",  # Mengubah label di UI agar muncul "Tersedia (BCA)"
                    "cash_composition": get_cash_composition_for_error(advance),
                }
            , status_code=422)
    # ─────────────────────────────────────────────────────────────────────────

    advance.is_disbursement_approved = True

    # Rule: Jika semua T1 sudah approved, ubah status dokumen menjadi "approved"
    # ✅ FIX: Update the advance's bank_id to the Plafon bank
    if best_adv_bank_id:
        advance.bank_id = best_adv_bank_id
        
    if main_bank:
        advance.disbursement_source_id = main_bank.id

    # Cek & record jika Admin Fee di-override:
    all_t1_approved = all(
        i.status in ("approved", "completed", "in_settlement") for i in advance.items
    )
    if all_t1_approved:
        advance.status = "approved"

    # Rule 2: Refresh Sumber Dana, Deskripsi, dan Amount pada Tabel 3 saat Approve Tabel 2
    if advance.returned_amount and advance.returned_amount > 0.01:
        if not advance.return_source or advance.return_source == "-":
            advance.return_source = advance.disbursement_source

        if advance.advance_type == "batch":
            pass # advance.return_description = advance.title
        else:
            advance.return_description = (
                advance.items[0].description if advance.items else advance.title
            )

    # Log workflow
    from utils.workflow_helper import log_workflow, update_document_stage

    log_workflow(
        document_type="advance",
        document_id=advance.id,
        from_status=advance.status,
        to_status=advance.status,
        action="approve_t2",
        user_id=user.id,
    )

    # Determine next stage
    update_document_stage(advance, "final_pending")

    db.session.commit()
    return JSONResponse(content=
        {
            "message": "Tabel Pengiriman Dana telah disetujui. Dana telah dicairkan.",
            "advance": advance.to_dict(),
        }
    , status_code=200)



