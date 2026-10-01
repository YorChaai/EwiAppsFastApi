import json
import os
import uuid
from datetime import datetime

from config import Config
from fastapi.responses import JSONResponse
import shutil
from models import Advance, AdvanceItem, BankAccount, Category, db
from utils.storage import delete_evidence_file
from services.approvals.advance_helpers import get_cash_composition_for_error, _editable_revision_no, _items_for_revision
from utils.parsing_helper import _has_unchecked_checklist, allowed_file

class AdvanceItemsService:
    @staticmethod
    def add_advance_item(advance_id, user, data, files):
        user_id = user.id
        advance = Advance.query.get_or_404(advance_id)
        is_manager = user.role in ["manager", "super_manager"]
    
        if not is_manager and advance.user_id != user_id:
            return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    
        editable_revision_no = _editable_revision_no(advance)
        if editable_revision_no is None:
            return JSONResponse(content={"error": "Kasbon saat ini tidak dalam mode edit"}, status_code=400)
    
        # Set modified flag
        advance.modified_t1 = True
    
        # Support both category_id (legacy) and category_ids (list)
        category_id = data.get("category_id")
        category_ids_raw = data.get("category_ids")
        category_ids = []
        if category_ids_raw:
            try:
                category_ids = json.loads(category_ids_raw)
            except Exception:
                pass
        if not category_ids and category_id:
            category_ids = [int(category_id)]
    
        description = data.get("description", "").strip()
        estimated_amount = data.get("estimated_amount")
        date_str = data.get("date")
        source = data.get("source", "").strip() or None
        currency = data.get("currency", "IDR").strip().upper() or "IDR"
        currency_exchange_str = data.get("currency_exchange", "1")
    
        if not all([category_ids, description, estimated_amount]):
            return JSONResponse(content=
                {"error": "Semua field wajib diisi (termasuk sub-kategori)"}
            , status_code=400)
    
        # Validasi kategori: semua harus di bawah parent yang sama
        categories = Category.query.filter(Category.id.in_(category_ids)).all()
        if len(categories) != len(category_ids):
            return JSONResponse(content={"error": "Salah satu kategori tidak ditemukan"}, status_code=404)
    
        parent_ids = {c.parent_id for c in categories}
        if len(parent_ids) > 1:
            return JSONResponse(content=
                {
                    "error": "Semua sub-kategori harus berada di bawah kategori utama yang sama"
                }
            , status_code=400)
    
        primary_category_id = category_ids[0]
    
        try:
            estimated_amount = float(estimated_amount)
        except (ValueError, TypeError):
            return JSONResponse(content={"error": "Jumlah harus berupa angka"}, status_code=400)
    
        try:
            currency_exchange = float(currency_exchange_str)
            if currency_exchange <= 0:
                currency_exchange = 1.0
        except (ValueError, TypeError):
            currency_exchange = 1.0
    
        # Validasi nominal (ekuivalen Rupiah) tidak boleh berada di antara -100 dan 100 (harus <= -100 atau >= 100)
        idr_equivalent = estimated_amount * currency_exchange
        if abs(idr_equivalent) < 100:
            return JSONResponse(content=
                {
                    "error": "Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100"
                }
            , status_code=400)
    
        if advance.advance_type == "single":
            revision_items = _items_for_revision(advance, editable_revision_no or 0)
            if revision_items:
                return JSONResponse(content={"error": "Kasbon single hanya boleh memiliki 1 item"}, status_code=400)
    
        item_date = None
        if date_str:
            try:
                item_date = datetime.strptime(date_str, "%Y-%m-%d").date()
            except ValueError:
                pass
    
        evidence_paths = []
        evidence_filenames = []
    
        if "evidence" in files:
            uploads = files.get("evidence", [])
            for file in uploads:
                if file and file.filename and allowed_file(file.filename):
                    ext = file.filename.rsplit(".", 1)[1].lower()
                    unique_name = f"{uuid.uuid4().hex}.{ext}"
                    now = datetime.now()
                    year_month = f"{now.year}/{now.month:02d}"
                    upload_dir = os.path.join(
                        Config.UPLOAD_FOLDER,
                        "receipts",
                        year_month,
                    )
                    os.makedirs(upload_dir, exist_ok=True)
                    with open(os.path.join(upload_dir, unique_name), "wb") as destination:
                        shutil.copyfileobj(file.file, destination)
                    evidence_paths.append(f"receipts/{year_month}/{unique_name}")
                    evidence_filenames.append(file.filename)
    
        evidence_path = "|".join(evidence_paths) if evidence_paths else None
        evidence_filename = "|".join(evidence_filenames) if evidence_filenames else None
    
        item = AdvanceItem(
            advance_id=advance.id,
            category_id=primary_category_id,
            description=description,
            estimated_amount=estimated_amount,
            revision_no=editable_revision_no or 0,
            evidence_path=evidence_path,
            evidence_filename=evidence_filename,
            date=item_date,
            source=source,
            currency=currency,
            currency_exchange=currency_exchange,
            company=advance.company,
        )
        if categories:
            item.subcategories = categories
        db.session.add(item)
    
        # Auto-sync title for single type
        if advance.advance_type == "single":
            advance.title = item.description
    
        # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
        if not advance.modified_t2:
            db.session.commit()
            db.session.refresh(advance)
            advance.disbursed_amount = advance.total_amount
            if advance.advance_type == "batch":
                pass # advance.disbursement_comment = advance.title
                pass # advance.return_description = advance.title
            else:
                pass # advance.disbursement_comment = item.description
                pass # advance.return_description = item.description
    
        db.session.commit()
        return JSONResponse(content=
            {"item": item.to_dict(), "advance": advance.to_dict(include_items=True)}
        , status_code=201)

    @staticmethod
    def update_advance_item(item_id, user, data, files):
        user_id = user.id
        item = AdvanceItem.query.get_or_404(item_id)
        advance = item.advance
        is_manager = user.role in ["manager", "super_manager"]
    
        if not is_manager and advance.user_id != user_id:
            return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    
        editable_revision_no = _editable_revision_no(advance)
    
        # Data has already been parsed by the FastAPI route.
    
        # edit rules:
        # - draft: full edit
        # - submitted: view only (except for checklist/status updates by manager)
        # - rejected: checklist items only
        is_submitted = advance.status == "submitted"
        is_rejected = advance.status == "rejected"
    
        # Fields allowed during submitted/rejected status for checklist purposes
        checklist_fields = {"notes", "status", "checked"}
        is_updating_checklist = (
            bool(data) and set(data.keys()).issubset(checklist_fields) and not files
        )
    
        # Enforce draft mode for non-checklist updates (for both Staff and Manager)
        if not is_updating_checklist:
            if (
                editable_revision_no is None
                or (item.revision_no or 0) != editable_revision_no
            ):
                return JSONResponse(content=
                    {
                        "error": "Item ini sudah terkunci. Masuk ke mode Draft untuk mengedit."
                    }
                , status_code=400)
            # Set modified flag
            advance.modified_t1 = True
    
        if is_submitted and not is_updating_checklist:
            return JSONResponse(content=
                {
                    "error": "saat disubmit tidak bisa mengubah rincian data. Silakan Move to Draft terlebih dahulu."
                }
            , status_code=400)
    
        if "category_ids" in data or "category_id" in data:
            cat_ids = data.get("category_ids")
            if not isinstance(cat_ids, list):
                try:
                    cat_ids = json.loads(cat_ids)
                except Exception:
                    cat_ids = [int(data["category_id"])] if "category_id" in data else []
    
            if cat_ids:
                new_cats = Category.query.filter(Category.id.in_(cat_ids)).all()
                if len(new_cats) != len(cat_ids):
                    return JSONResponse(content={"error": "Salah satu kategori tidak ditemukan"}, status_code=404)
    
                # Validasi parent sama
                p_ids = {c.parent_id for c in new_cats}
                if len(p_ids) > 1:
                    return JSONResponse(content=
                        {
                            "error": "Semua sub-kategori harus berada di bawah kategori utama yang sama"
                        }
                    , status_code=400)
    
                item.category_id = cat_ids[0]
                item.subcategories = new_cats
        if "description" in data:
            item.description = data["description"].strip()
        if "estimated_amount" in data:
            try:
                item.estimated_amount = float(data["estimated_amount"])
            except (ValueError, TypeError):
                return JSONResponse(content={"error": "Jumlah harus berupa angka"}, status_code=400)
        if "date" in data:
            date_str = data["date"]
            if date_str:
                try:
                    item.date = datetime.strptime(date_str, "%Y-%m-%d").date()
                except ValueError:
                    pass
            else:
                item.date = None
        if "source" in data:
            item.source = data["source"].strip() or None
        if "currency" in data:
            item.currency = (data["currency"] or "IDR").strip().upper()
        if "currency_exchange" in data:
            try:
                ex = float(data["currency_exchange"])
                item.currency_exchange = ex if ex > 0 else 1.0
            except (ValueError, TypeError):
                item.currency_exchange = 1.0
    
        # Validasi nominal (ekuivalen Rupiah) tidak boleh berada di antara -100 dan 100 (harus <= -100 atau >= 100)
        idr_equivalent = item.estimated_amount * (
            item.currency_exchange if item.currency_exchange else 1
        )
        if not is_updating_checklist and abs(idr_equivalent) < 100:
            return JSONResponse(content=
                {
                    "error": "Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100"
                }
            , status_code=400)
        if not is_updating_checklist:
            if _has_unchecked_checklist(item):
                item.status = "rejected"
            else:
                item.status = "pending"
    
            # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
            if not advance.modified_t2:
                db.session.commit()
                db.session.refresh(advance)
                advance.disbursed_amount = advance.total_amount
                if advance.advance_type == "batch":
                    pass # advance.disbursement_comment = advance.title
                    pass # advance.return_description = advance.title
                else:
                    pass # advance.disbursement_comment = item.description
                    pass # advance.return_description = item.description
    
        if "notes" in data:
            item.notes = data["notes"]
    
        # Status hanya boleh diubah via checklist update (centang/silang manager),
        # bukan dari edit item biasa agar tidak bypass reset ke "pending".
        # Tambahan: Hanya manager/super_manager yang boleh mengubah status secara manual.
        if is_updating_checklist and "status" in data and is_manager:
            if data["status"] == "approved" and item.status != "approved":
                from services.balance.balance_service import calculate_bank_real_balance
    
                req_name = advance.requester.full_name if advance.requester else "Karyawan"
                advance_banks = BankAccount.query.filter(
                    BankAccount.account_type == "advance",
                    BankAccount.user_id == advance.user_id,
                    BankAccount.company == advance.company,
                ).all()
    
                if not advance_banks:
                    return JSONResponse(content=
                        {
                            "error": f"Akun Bank Advance untuk {req_name} tidak ditemukan. Silakan buat akun bank dengan tipe 'advance' dan nama mengandung '{req_name}'."
                        }
                    , status_code=422)
    
                # Hitung total yang sudah di-approve di advance ini
                already_approved = sum(
                    (i.idr_amount or 0)
                    for i in advance.items
                    if i.status == "approved" and i.id != item.id
                )
                item_amount = item.estimated_amount * (
                    item.currency_exchange if item.currency_exchange else 1
                )
                needed = already_approved + item_amount
    
                available = sum(calculate_bank_real_balance(b.id) for b in advance_banks)
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
    
            item.status = data["status"]
    
        # Handle evidence file upload (jika ada file baru)
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
    
        # Jika frontend tidak mengirim existing_paths (misal client lama),
        # maka kita asumsikan behavior lama (replace all jika ada file baru).
        # Namun jika dikirim (meskipun list kosong []), kita ikuti list tsb (bisa jadi user hapus semua).
    
        # Clean up deleted files (files in database but not in existing_paths)
        if "existing_evidence_paths" in data and item.evidence_path:
            old_paths = item.evidence_path.split("|")
            for op in old_paths:
                if op not in existing_paths:
                    delete_evidence_file(op)
    
        new_paths = []
        new_filenames = []
    
        if "evidence" in files:
            uploads = files.get("evidence", [])
    
            for file in uploads:
                if file and file.filename and allowed_file(file.filename):
                    # Only delete existing files once if we have at least one valid new file
                    # AND if existing_evidence_paths was NOT provided (legacy behavior)
                    if (
                        "existing_evidence_paths" not in data
                        and not new_paths
                        and item.evidence_path
                    ):
                        delete_evidence_file(item.evidence_path)
    
                    ext = file.filename.rsplit(".", 1)[1].lower()
                    unique_name = f"{uuid.uuid4().hex}.{ext}"
                    now = datetime.now()
                    year_month = f"{now.year}/{now.month:02d}"
                    upload_dir = os.path.join(
                        Config.UPLOAD_FOLDER,
                        "receipts",
                        year_month,
                    )
                    os.makedirs(upload_dir, exist_ok=True)
                    with open(os.path.join(upload_dir, unique_name), "wb") as destination:
                        shutil.copyfileobj(file.file, destination)
                    new_paths.append(f"receipts/{year_month}/{unique_name}")
                    new_filenames.append(file.filename)
    
        if new_paths or "existing_evidence_paths" in data:
            final_paths = existing_paths + new_paths
            final_filenames = existing_filenames + new_filenames
    
            item.evidence_path = "|".join(final_paths) if final_paths else None
            item.evidence_filename = "|".join(final_filenames) if final_filenames else None
    
        db.session.commit()
    
        # Auto-sync title for single type
        if advance.advance_type == "single":
            # Check if this is the first item or just always sync the edited item to title
            # For simplicity and since 'single' usually has one main meaningful item per revision,
            # we sync the current edited item's description if it's single.
            advance.title = item.description
            db.session.commit()
    
        return JSONResponse(content=
            {"item": item.to_dict(), "advance": advance.to_dict(include_items=True)}
        , status_code=200)

    @staticmethod
    def delete_advance_item(item_id, user):
        user_id = user.id
        item = AdvanceItem.query.get_or_404(item_id)
        advance = item.advance
        is_manager = user.role in ["manager", "super_manager"]
    
        if not is_manager and advance.user_id != user_id:
            return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    
        if advance.settlements:
            return JSONResponse(content={"error": "Item tidak bisa dihapus karena Kasbon ini sudah dipakai oleh Settlement. Hapus atau tarik Settlement terkait ke draft terlebih dahulu."}, status_code=400)
    
        editable_revision_no = _editable_revision_no(advance)
        if not is_manager:
            if (
                editable_revision_no is None
                or (item.revision_no or 0) != editable_revision_no
            ):
                return JSONResponse(content=
                    {"error": "Item ini sudah terkunci dan tidak bisa dihapus"}
                , status_code=400)
    
        # Cek apakah penghapusan akan membuat saldo virtual minus (Dompet Gabungan)
        contributes_to_balance = advance.status in ("approved", "completed") and (
            advance.is_disbursement_approved or advance.status == "completed"
        )
        if contributes_to_balance:
            is_advance_bank = False
            if advance.bank_id:
                from models import BankAccount
                b = BankAccount.query.get(advance.bank_id)
                if b and b.account_type == "advance":
                    is_advance_bank = True
    
            if is_advance_bank:
                from services.balance.balance_service import calculate_user_running_balance
                current_hutang = calculate_user_running_balance(
                    advance.user_id, advance.company
                )
                # Item idr_amount is what contributes to the approved_amount dynamically
                contribution_reduction = item.idr_amount or 0
    
                simulated_hutang = current_hutang - contribution_reduction
                if simulated_hutang < -0.01:
                    return JSONResponse(content=
                        {"error": "Item tidak bisa dihapus! Saldo Virtual (Plafon) tidak mencukupi karena sudah terpakai oleh Settlement. Hapus atau kembalikan Settlement terkait ke draft terlebih dahulu."}
                    , status_code=400)
    
        delete_evidence_file(item.evidence_path)
    
        db.session.delete(item)
    
        # Rule 1: Auto-sync Tabel 2 jika belum dimodifikasi manual
        if not advance.modified_t2:
            db.session.commit()
            db.session.refresh(advance)
            advance.disbursed_amount = advance.total_amount
    
        # Recalculate Table 3 (Returned Amount)
        if advance.disbursed_amount is not None:
            current_approved = advance.approved_amount
            diff = advance.disbursed_amount - current_approved
            if diff > 0.01:
                advance.returned_amount = diff
            else:
                advance.returned_amount = 0.0
    
        db.session.commit()
        return JSONResponse(content=
            {"message": "Item dihapus", "advance": advance.to_dict(include_items=True)}
        , status_code=200)

    @staticmethod
    def bulk_delete_advance_items(user, data, company):
        user_id = user.id
        item_ids = data.get("item_ids", [])
    
        if not item_ids:
            return JSONResponse(content={"error": "Daftar ID item kosong"}, status_code=400)
    
        items = (
            AdvanceItem.query.filter(AdvanceItem.company == company)
            .filter(AdvanceItem.id.in_(item_ids))
            .all()
        )
        count = 0
    
        # Cek apakah penghapusan massal ini akan membuat saldo virtual minus (Dompet Gabungan)
        reductions = {}
        for item in items:
            adv = item.advance
            contributes_to_balance = adv.status in ("approved", "completed") and (
                adv.is_disbursement_approved or adv.status == "completed"
            )
            if contributes_to_balance:
                reductions[adv.id] = reductions.get(adv.id, 0) + (item.idr_amount or 0)
    
        for adv_id, total_reduction in reductions.items():
            adv = Advance.query.get(adv_id)
            is_advance_bank = False
            if adv.bank_id:
                from models import BankAccount
                b = BankAccount.query.get(adv.bank_id)
                if b and b.account_type == "advance":
                    is_advance_bank = True
            
            if is_advance_bank and total_reduction > 0:
                from services.balance.balance_service import calculate_user_running_balance
                current_hutang = calculate_user_running_balance(adv.user_id, adv.company)
                simulated_hutang = current_hutang - total_reduction
                if simulated_hutang < -0.01:
                    return JSONResponse(content=
                        {"error": "Item tidak bisa dihapus! Saldo Virtual (Plafon) tidak mencukupi karena sudah terpakai oleh Settlement. Hapus atau kembalikan Settlement terkait ke draft terlebih dahulu."}
                    , status_code=400)
    
        affected_advances = set()
        for item in items:
            advance = item.advance
            can_delete = False
            if user.role in ["manager", "super_manager"]:
                can_delete = True
            else:
                status_val = "revision" if item.advance.status == "revision" else "draft"
                if advance.user_id == user_id and advance.status in (
                    "draft",
                    "rejected",
                    "revision",
                ):
                    can_delete = True
    
            if can_delete:
                affected_advances.add(advance)
                delete_evidence_file(item.evidence_path)
    
                db.session.delete(item)
                count += 1
    
        for advance in affected_advances:
            # Recalculate Table 3 (Returned Amount)
            if advance.disbursed_amount is not None:
                current_approved = advance.approved_amount
                diff = advance.disbursed_amount - current_approved
                if diff > 0.01:
                    advance.returned_amount = diff
                else:
                    advance.returned_amount = 0.0
    
        db.session.commit()
        return JSONResponse(content={"message": f"{count} item berhasil dihapus"}, status_code=200)

    @staticmethod
    def update_advance_items_bulk(advance_id, user, data, company):
        # Finance or Manager can update source
        if user.role not in ["manager", "super_manager"] and user.role != "finance":
            return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    
        advance = Advance.query.get_or_404(advance_id)
        item_ids = data.get("item_ids", [])
        updates = data.get("updates", {})
    
        if not item_ids:
            return JSONResponse(content={"error": "Pilih minimal satu item"}, status_code=400)
    
        items = (
            AdvanceItem.query.filter(AdvanceItem.company == company)
            .filter(AdvanceItem.id.in_(item_ids), AdvanceItem.advance_id == advance_id)
            .all()
        )
    
        for item in items:
            if "source" in updates:
                item.source = updates["source"]
            if "status" in updates:
                item.status = updates["status"]
    
        # Recalculate Table 3 (Returned Amount)
        if advance.disbursed_amount is not None:
            current_approved = advance.approved_amount
            diff = advance.disbursed_amount - current_approved
            if diff > 0.01:
                advance.returned_amount = diff
            else:
                advance.returned_amount = 0.0
    
        db.session.commit()
        return JSONResponse(content=
            {
                "message": f"{len(items)} item berhasil diperbarui",
                "advance": advance.to_dict(include_items=True),
            }
        , status_code=200)

