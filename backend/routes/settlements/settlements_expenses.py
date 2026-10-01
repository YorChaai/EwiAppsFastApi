import json
from datetime import datetime

from fastapi import APIRouter, Depends, Request
from fastapi.responses import JSONResponse
from starlette.concurrency import run_in_threadpool
from starlette.datastructures import UploadFile as StarletteUploadFile

from core.security import get_current_user
from models import Expense, User, db
from utils.parsing_helper import _has_unchecked_checklist

settlements_expenses_router = APIRouter(prefix="/api/settlements", tags=["settlements"])


async def _read_payload(request: Request) -> tuple[dict, bool]:
    content_type = request.headers.get("content-type", "")
    if "application/json" in content_type:
        try:
            payload = await request.json()
            return (payload if isinstance(payload, dict) else {}), False
        except (ValueError, TypeError):
            return {}, False
    if "application/x-www-form-urlencoded" in content_type or "multipart/form-data" in content_type:
        form = await request.form()
        return dict(form), any(isinstance(value, StarletteUploadFile) for _, value in form.multi_items())
    return {}, False


@settlements_expenses_router.put("/expenses/{expense_id}")
async def update_expense(
    expense_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data, has_files = await _read_payload(request)
    return await run_in_threadpool(_update_expense, expense_id, user, data, has_files)


def _update_expense(expense_id: int, user: User, data: dict, has_files: bool):
    expense = Expense.query.get_or_404(expense_id)
    settlement = expense.settlement
    is_manager = user.role in ["manager", "super_manager"]

    is_submitted = settlement.status in ("submitted", "pending")
    is_rejected = settlement.status == "rejected"
    checklist_fields = {"notes", "status", "checked"}
    is_updating_checklist = bool(data) and set(data.keys()).issubset(checklist_fields) and not has_files

    if is_submitted and not is_updating_checklist:
        return JSONResponse(
            {"error": "saat disubmit tidak bisa mengubah rincian data. Silakan Move to Draft terlebih dahulu."},
            status_code=400,
        )

    if is_rejected and not is_updating_checklist:
        restricted_fields = {
            "category_id", "description", "amount", "date", "source", "currency", "currency_exchange"
        }
        if restricted_fields.intersection(data):
            return JSONResponse(
                {"error": "saat rejected hanya bisa update checklist komentar."},
                status_code=400,
            )

    if "category_ids" in data or "category_id" in data:
        cat_ids = data.get("category_ids")
        if not isinstance(cat_ids, list):
            try:
                cat_ids = json.loads(cat_ids)
            except Exception:
                cat_ids = [int(data["category_id"])] if "category_id" in data else []

        if cat_ids:
            from models import Category

            new_categories = Category.query.filter(Category.id.in_(cat_ids)).all()
            if len(new_categories) != len(cat_ids):
                return JSONResponse({"error": "Salah satu kategori tidak ditemukan"}, status_code=404)

            parent_ids = {category.parent_id for category in new_categories}
            if len(parent_ids) > 1:
                return JSONResponse(
                    {"error": "Semua sub-kategori harus di bawah kategori utama yang sama"},
                    status_code=400,
                )

            expense.category_id = cat_ids[0]
            expense.subcategories = new_categories

    if "description" in data:
        expense.description = str(data["description"]).strip()
    if "amount" in data:
        try:
            amount = float(data["amount"])
            if amount <= 0:
                raise ValueError
            expense.amount = amount
        except (ValueError, TypeError):
            return JSONResponse({"error": "Nominal harus angka positif"}, status_code=400)
    if "date" in data:
        try:
            expense.date = datetime.strptime(data["date"], "%Y-%m-%d").date()
        except (ValueError, TypeError):
            pass
    if "source" in data:
        expense.source = str(data["source"]).strip() or None
    if "currency" in data:
        expense.currency = (data["currency"] or "IDR").strip().upper()
    if "currency_exchange" in data:
        try:
            exchange_rate = float(data["currency_exchange"])
            expense.currency_exchange = exchange_rate if exchange_rate > 0 else 1.0
        except (ValueError, TypeError):
            expense.currency_exchange = 1.0

    if not is_updating_checklist:
        expense.status = "rejected" if _has_unchecked_checklist(expense) else "pending"
        settlement.modified_t1 = True

    if "notes" in data:
        expense.notes = data["notes"]
    if is_updating_checklist and "status" in data and is_manager:
        expense.status = data["status"]

    db.session.commit()
    return JSONResponse(
        {
            "expense": expense.to_dict(),
            "settlement": settlement.to_dict(include_expenses=True),
        },
        status_code=200,
    )
