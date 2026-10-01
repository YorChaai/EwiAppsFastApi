import json
import os
import shutil
import uuid
from datetime import datetime
from typing import Any


from models import Category, Expense, Settlement, User, db
from fastapi import APIRouter, Body, Depends, Header, Request
from fastapi.responses import FileResponse, JSONResponse
from core.security import get_current_user
from config import Config
from utils.parsing_helper import allowed_file, _parse_category_ids
from services.core.notification_events import (
    notify_expense_approved,
    notify_expense_rejected,
)
from utils.storage import delete_evidence_file

expenses_router = APIRouter(prefix="/api/expenses", tags=["Expenses"])


async def _form_payload(request: Request):
    """Read JSON or multipart payloads through FastAPI's request interface."""
    if "application/json" in request.headers.get("content-type", ""):
        try:
            data = await request.json()
        except (ValueError, UnicodeDecodeError):
            data = {}
        return None, data if isinstance(data, dict) else {}, False
    form = await request.form()
    data = dict(form)
    has_files = any(hasattr(value, "filename") for value in form.values())
    return form, data, has_files


def _form_int(form, key):
    try:
        return int(form.get(key)) if form and form.get(key) not in (None, "") else None
    except (TypeError, ValueError):
        return None


def _form_float(form, key):
    try:
        return float(form.get(key)) if form and form.get(key) not in (None, "") else None
    except (TypeError, ValueError):
        return None


def _optional_int(value):
    try:
        return int(value) if value not in (None, "") else None
    except (TypeError, ValueError):
        return None

def _optional_float(value):
    try:
        return float(value) if value not in (None, "") else None
    except (TypeError, ValueError):
        return None


def _save_upload(upload, destination):
    os.makedirs(os.path.dirname(destination), exist_ok=True)
    with open(destination, "wb") as target:
        shutil.copyfileobj(upload.file, target)


def _evidence_response(upload_root, filename):
    from pathlib import Path
    from fastapi import HTTPException

    root = Path(upload_root).resolve()
    path = (root / filename).resolve()
    if root not in path.parents or not path.is_file():
        raise HTTPException(status_code=404, detail="File tidak ditemukan")
    return FileResponse(path)








@expenses_router.post("")
def create_expense(payload: tuple = Depends(_form_payload), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    form, data, has_files = payload
    user_id = int(current_user.id)

    settlement_id = _form_int(form, "settlement_id") if form else _optional_int(data.get("settlement_id"))
    category_ids = _parse_category_ids(
        (form.get("category_ids") or form.get("category_id") or form) if form else data
    )

    description = str(data.get("description", "")).strip()
    amount = _form_float(form, "amount") if form else _optional_float(data.get("amount"))
    date_str = data.get("date", "")
    source = str(data.get("source", "")).strip() or None
    currency = str(data.get("currency", "IDR")).strip()
    currency_exchange = (_form_float(form, "currency_exchange") if form else _optional_float(data.get("currency_exchange"))) or 1

    if not all([settlement_id, category_ids, description, amount, date_str]):
        return JSONResponse(content={'error': 'Semua field wajib diisi (termasuk sub-kategori)'}, status_code=400)

    # Validasi nominal (ekuivalen Rupiah) tidak boleh berada di antara -100 dan 100 (harus <= -100 atau >= 100)
    idr_equivalent = amount * (currency_exchange if currency_exchange else 1)
    if abs(idr_equivalent) < 100:
        return JSONResponse(content={'error': 'Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100'}, status_code=400)

    settlement = Settlement.query.filter_by(id=settlement_id, company=company).first()
    if not settlement:
        return JSONResponse(content={'error': 'Settlement tidak ditemukan atau tidak dapat diakses'}, status_code=404)
    if settlement.user_id != user_id:
        return JSONResponse(content={'error': 'Akses ditolak'}, status_code=403)
    if settlement.status not in ("draft", "rejected"):
        return JSONResponse(content={'error': 'Settlement sudah terkunci. Masuk ke mode Draft untuk mengedit.'}, status_code=400)

    # Set modified flag
    settlement.modified_t1 = True
    settlement.modified_t2 = False
    settlement.modified_t3 = False
    settlement.is_disbursement_approved = False
    settlement.is_return_approved = False
    settlement.return_status = "pending"

    # single settlement hanya boleh 1 expense
    if settlement.settlement_type == "single" and len(settlement.expenses) >= 1:
        return JSONResponse(content={'error': 'Settlement sendiri hanya boleh memiliki 1 expense'}, status_code=400)

    # Validasi kategori: semua harus di bawah parent yang sama
    categories = Category.query.filter(
        Category.id.in_(category_ids), Category.company == company
    ).all()
    if len(categories) != len(category_ids):
        return JSONResponse(content={'error': 'Salah satu kategori tidak ditemukan'}, status_code=404)

    parent_ids = {c.parent_id for c in categories}
    if len(parent_ids) > 1:
        return JSONResponse(content={'error': 'Semua sub-kategori harus berada di bawah kategori utama yang sama'}, status_code=400)
    if None in parent_ids:
        # Jika salah satu kategori adalah parent, pastikan dia sendirian atau logic lain
        # Tapi biasanya user pilih sub-kategori (yang punya parent)
        pass

    # Gunakan ID pertama sebagai legacy category_id
    primary_category_id = category_ids[0]

    try:
        expense_date = datetime.strptime(date_str, "%Y-%m-%d").date()
        # Jika settlement punya report_year, paksa tahun expense mengikuti report_year
        if settlement.report_year and expense_date.year != settlement.report_year:
            expense_date = expense_date.replace(year=settlement.report_year)
    except ValueError:
        return JSONResponse(content={'error': 'Format tanggal: YYYY-MM-DD'}, status_code=400)

    evidence_paths = []
    evidence_filenames = []

    if has_files:
        files = form.getlist("evidence") if form is not None else []
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
                _save_upload(file, os.path.join(upload_dir, unique_name))
                evidence_paths.append(f"receipts/{year_month}/{unique_name}")
                evidence_filenames.append(file.filename)

    evidence_path = "|".join(evidence_paths) if evidence_paths else None
    evidence_filename = "|".join(evidence_filenames) if evidence_filenames else None

    expense = Expense(
        settlement_id=settlement_id,
        category_id=primary_category_id,
        description=description,
        amount=amount,
        date=expense_date,
        source=source,
        currency=currency,
        currency_exchange=currency_exchange,
        evidence_path=evidence_path,
        evidence_filename=evidence_filename,
        status="pending",
        company=company,
    )
    if categories:
        expense.subcategories = categories
    db.session.add(expense)

    # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
    if not settlement.modified_t2:
        settlement.disbursed_amount = settlement.total_amount
        if settlement.settlement_type == "batch":
            pass # settlement.disbursement_comment = settlement.title
            pass # settlement.return_description = settlement.title
        else:
            pass # settlement.disbursement_comment = expense.description
            pass # settlement.return_description = expense.description

    db.session.commit()

    return JSONResponse(content={'expense': expense.to_dict()}, status_code=201)


@expenses_router.put("/{expense_id}")
def update_expense(expense_id: int, payload: tuple = Depends(_form_payload), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    form, data, has_files = payload
    user_id = int(current_user.id)
    user = User.query.get(user_id)
    expense = Expense.query.filter_by(id=expense_id, company=company).first_or_404()
    settlement = expense.settlement
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and settlement.user_id != user_id:
        return JSONResponse(content={'error': 'Akses ditolak'}, status_code=403)

    # data handling: support both json and form-data
    data = data

    # Identify if updating checklist
    checklist_fields = {"notes", "status", "checked"}
    is_updating_checklist = (
        bool(data) and set(data.keys()).issubset(checklist_fields) and not has_files
    )

    # edit rules:
    # - draft: full edit
    # - submitted: view only (except for checklist/status updates by manager)
    if not is_updating_checklist:
        if settlement.status not in ("draft", "rejected"):
            return JSONResponse(content={'error': 'Expense sudah terkunci. Masuk ke mode Draft untuk mengedit.'}, status_code=400)
        # Set modified flag for Table 1
        settlement.modified_t1 = True
        expense.status = "pending"

        # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
        if not settlement.modified_t2:
            # Commit changes to ensure total_amount calculation is fresh
            db.session.commit()
            db.session.refresh(settlement)
            settlement.disbursed_amount = settlement.total_amount
            if settlement.settlement_type == "batch":
                pass # settlement.disbursement_comment = settlement.title
                pass # settlement.return_description = settlement.title
            else:
                # Use current expense description if it's single or just for refresh
                pass # settlement.disbursement_comment = expense.description
                pass # settlement.return_description = expense.description

        # We NO LONGER auto-reset modified_t2/t3 here because it interferes with
        # manual adjustments in Table 2 while fixing Table 1.
        # The user can manually re-sync using the "Sesuai Sisa" button if needed.

    if settlement.status == "submitted" and not is_updating_checklist:
        return JSONResponse(content={'error': 'saat disubmit hanya bisa melihat, tidak bisa mengubah data utama'}, status_code=400)

    data_keys = set(data.keys())

    if "category_ids" in data or "category_id" in data:
        cat_ids = _parse_category_ids(data)

        if cat_ids:
            new_cats = Category.query.filter(Category.id.in_(cat_ids)).all()
            if len(new_cats) != len(cat_ids):
                return JSONResponse(content={'error': 'Salah satu kategori tidak ditemukan'}, status_code=404)

            # Validasi parent sama
            p_ids = {c.parent_id for c in new_cats}
            if len(p_ids) > 1:
                return JSONResponse(content={'error': 'Semua sub-kategori harus berada di bawah kategori utama yang sama'}, status_code=400)

            expense.category_id = cat_ids[0]
            expense.subcategories = new_cats
    if "description" in data:
        expense.description = str(data["description"]).strip()
    if "amount" in data:
        expense.amount = float(data["amount"])
    if "date" in data:
        try:
            expense.date = datetime.strptime(str(data["date"]), "%Y-%m-%d").date()
        except (ValueError, TypeError):
            return JSONResponse(content={'error': 'format tanggal harus YYYY-MM-DD'}, status_code=400)
    if "source" in data:
        expense.source = str(data["source"]).strip() or None
    if "currency" in data:
        expense.currency = str(data["currency"]).strip().upper()
    if "currency_exchange" in data:
        expense.currency_exchange = float(data["currency_exchange"] or 1)

    # Validasi nominal (ekuivalen Rupiah) tidak boleh berada di antara -100 dan 100 (harus <= -100 atau >= 100)
    idr_equivalent = expense.amount * (
        expense.currency_exchange if expense.currency_exchange else 1
    )
    if abs(idr_equivalent) < 100:
        return JSONResponse(content={'error': 'Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100'}, status_code=400)

    existing_paths = []
    existing_filenames = []
    if "existing_evidence_paths" in data:
        try:
            existing_paths = json.loads(data["existing_evidence_paths"])
        except Exception:
            existing_paths = []
    if "existing_evidence_filenames" in data:
        try:
            existing_filenames = json.loads(data["existing_evidence_filenames"])
        except Exception:
            existing_filenames = []

    # Clean up deleted files
    if "existing_evidence_paths" in data and expense.evidence_path:
        old_paths = expense.evidence_path.split("|")
        for op in old_paths:
            if op not in existing_paths:
                delete_evidence_file(op)

    new_paths = []
    new_filenames = []
    if has_files:
        file_list = form.getlist("evidence") if form is not None else []

        for file in file_list:
            if file and file.filename and allowed_file(file.filename):
                # Legacy behavior if existing_evidence_paths not provided
                if (
                    "existing_evidence_paths" not in data
                    and not new_paths
                    and expense.evidence_path
                ):
                    delete_evidence_file(expense.evidence_path)

                ext = file.filename.rsplit(".", 1)[1].lower()
                unique_name = f"{uuid.uuid4().hex}.{ext}"
                now = datetime.now()
                year_month = f"{now.year}/{now.month:02d}"
                upload_dir = os.path.join(
                    Config.UPLOAD_FOLDER, "receipts", year_month
                )
                os.makedirs(upload_dir, exist_ok=True)
                _save_upload(file, os.path.join(upload_dir, unique_name))
                new_paths.append(f"receipts/{year_month}/{unique_name}")
                new_filenames.append(file.filename)

    if new_paths or "existing_evidence_paths" in data:
        final_paths = existing_paths + new_paths
        final_filenames = existing_filenames + new_filenames
        expense.evidence_path = "|".join(final_paths) if final_paths else None
        expense.evidence_filename = (
            "|".join(final_filenames) if final_filenames else None
        )

    if not is_updating_checklist:
        expense.status = "pending"

    if "notes" in data:
        expense.notes = data["notes"]

    # Status hanya boleh diubah via checklist update (centang/silang manager),
    # bukan dari edit item biasa agar tidak bypass reset ke "pending".
    # Tambahan: Hanya manager/super_manager yang boleh mengubah status secara manual.
    if is_updating_checklist and "status" in data and is_manager:
        expense.status = data["status"]

    db.session.commit()
    return JSONResponse(content={'expense': expense.to_dict()}, status_code=200)


@expenses_router.post("/bulk-delete")
def bulk_delete_expenses(data: dict = Body(default={}), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user_id = int(current_user.id)
    user = User.query.get(user_id)
    data = data or {}
    expense_ids = data.get("expense_ids", [])

    if not expense_ids:
        return JSONResponse(content={'error': 'Daftar ID expense kosong'}, status_code=400)

    expenses = (
        Expense.query.filter(Expense.company == company)
        .filter(Expense.id.in_(expense_ids))
        .all()
    )
    count = 0

    for expense in expenses:
        settlement = expense.settlement
        # Ijin: Pemilik draft/rejected ATAU manager
        can_delete = False
        if user.role in ["manager", "super_manager"]:
            can_delete = True
        else:
            if settlement.user_id == user_id and settlement.status in (
                "draft",
                "rejected",
            ):
                can_delete = True

        if can_delete:
            # hapus evidence file
            delete_evidence_file(expense.evidence_path)

            db.session.delete(expense)
            count += 1

    db.session.commit()
    return JSONResponse(content={'message': f'{count} expense berhasil dihapus'}, status_code=200)


@expenses_router.delete("/{expense_id}")
def delete_expense(expense_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user_id = int(current_user.id)
    user = User.query.get(user_id)
    expense = Expense.query.filter_by(id=expense_id, company=company).first_or_404()
    settlement = expense.settlement
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and settlement.user_id != user_id:
        return JSONResponse(content={'error': 'Akses ditolak'}, status_code=403)

    if settlement.status not in ("draft", "rejected"):
        return JSONResponse(content={'error': 'Settlement sudah terkunci. Masuk ke mode Draft untuk menghapus.'}, status_code=400)

    # Set modified flag
    settlement.modified_t1 = True
    settlement.modified_t2 = False
    settlement.modified_t3 = False
    settlement.is_disbursement_approved = False
    settlement.is_return_approved = False
    settlement.return_status = "pending"

    delete_evidence_file(expense.evidence_path)

    db.session.delete(expense)

    # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
    if not settlement.modified_t2:
        # Commit to ensure recalculation of total_amount
        db.session.commit()
        db.session.refresh(settlement)
        settlement.disbursed_amount = settlement.total_amount

    db.session.commit()
    return JSONResponse(content={'message': 'Expense dihapus'}, status_code=200)


@expenses_router.post("/{expense_id}/approve")
def approve_expense(expense_id: int, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak'}, status_code=403)

    expense = Expense.query.get_or_404(expense_id)
    settlement = expense.settlement

    if settlement.status != "submitted":
        return JSONResponse(content={'error': 'Settlement belum disubmit'}, status_code=400)

    # Cek apakah kategori sudah diapprove
    if expense.category.status == "pending":
        return JSONResponse(content={'error': f'Kategori "{expense.category.name}" belum disetujui. Silakan approve kategori terlebih dahulu.', 'category_id': expense.category_id, 'reason': 'category_unapproved'}, status_code=400)

    # Cek parent jika ada
    if expense.category.parent and expense.category.parent.status == "pending":
        return JSONResponse(content={'error': f'Induk kategori "{expense.category.parent.name}" belum disetujui. Silakan approve kategori induk terlebih dahulu.', 'category_id': expense.category.parent_id, 'reason': 'category_unapproved'}, status_code=400)

    # Cek subcategories
    for sub in expense.subcategories:
        if sub.status == "pending":
            return JSONResponse(content={'error': f'Sub-Kategori "{sub.name}" belum disetujui oleh Admin. Harap ACC di menu Pengaturan Kategori terlebih dahulu.', 'category_id': sub.id, 'reason': 'category_unapproved'}, status_code=400)

    expense.status = "approved"

    # Recalculate Table 3 (Returned Amount)
    if settlement.disbursed_amount is not None:
        current_approved = sum(
            (e.idr_amount or 0) for e in settlement.expenses if e.status == "approved"
        )
        diff = settlement.disbursed_amount - current_approved
        if diff > 0.01:
            settlement.returned_amount = diff
        else:
            settlement.returned_amount = 0.0

    db.session.commit()

    # Notify staff about expense approval
    notify_expense_approved(expense, user)

    return JSONResponse(content={'expense': expense.to_dict()}, status_code=200)




@expenses_router.post("/{expense_id}/reject")
def reject_expense(expense_id: int, data: dict = Body(default={}), current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    user = User.query.get(int(current_user.id))
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={'error': 'Akses ditolak'}, status_code=403)

    expense = Expense.query.get_or_404(expense_id)
    settlement = expense.settlement

    if settlement.status != "submitted":
        return JSONResponse(content={'error': 'Settlement belum disubmit'}, status_code=400)

    data = data or {}
    notes = data.get("notes", "")

    if not notes:
        return JSONResponse(content={'error': 'Alasan penolakan wajib diisi'}, status_code=400)

    expense.status = "rejected"
    expense.notes = _merge_rejection_notes(expense.notes or "", notes)

    # Recalculate Table 3 (Returned Amount)
    if settlement.disbursed_amount is not None:
        current_approved = sum(
            (e.idr_amount or 0) for e in settlement.expenses if e.status == "approved"
        )
        diff = settlement.disbursed_amount - current_approved
        if diff > 0.01:
            settlement.returned_amount = diff
        else:
            settlement.returned_amount = 0.0

    db.session.commit()

    # Notify staff about expense rejection
    notify_expense_rejected(expense, user)

    return JSONResponse(content={'expense': expense.to_dict()}, status_code=200)


@expenses_router.get("/evidence/{filename:path}")
def serve_evidence(filename: str, current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    upload_dir = Config.UPLOAD_FOLDER
    return _evidence_response(upload_dir, filename)


@expenses_router.get("/categories")
def list_categories(current_user: User = Depends(get_current_user), company: str = Header(default="EWI Foundation", alias="X-Company")):
    # Allow all statuses for selection, ordered by manual sort_order
    categories = (
        Category.query.filter_by(parent_id=None).order_by(Category.sort_order).all()
    )
    return JSONResponse(content={'categories': [c.to_dict(include_children=True) for c in categories]}, status_code=200)
