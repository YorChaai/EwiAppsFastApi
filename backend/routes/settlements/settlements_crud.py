from services.approvals.settlement_helpers import _sync_advance_after_settlement, rollback_settlement_transactions
from datetime import datetime, timezone
from sqlalchemy import extract
from fastapi import APIRouter, Body, Depends, Header, Request
from fastapi.responses import JSONResponse
from core.security import get_current_user
from models import Expense, Settlement, User, db
from sqlalchemy.orm import joinedload
from starlette.concurrency import run_in_threadpool

settlements_crud_router = APIRouter(prefix="/api/settlements", tags=["settlements"])


def _query_int(request: Request, key: str):
    try:
        return int(request.query_params.get(key))
    except (TypeError, ValueError):
        return None


def _company_or_default(company: str | None) -> str:
    return company or "EWI Foundation"


@settlements_crud_router.get("")
def list_settlements(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = _company_or_default(company)

    status_filter = request.query_params.get("status")
    report_year = _query_int(request, "report_year")
    mode = request.query_params.get("mode", "report")  # 'report' or 'actual'
    search_query = request.query_params.get("search", "").strip()

    # Debug logging - DETAIL
    print("[SETTLEMENT_API] ===== REQUEST =====")
    print(f"[SETTLEMENT_API] user_id={user_id}, role={user.role}")
    print(f"[SETTLEMENT_API] status_filter={status_filter}")
    print(f"[SETTLEMENT_API] report_year={report_year}, mode={mode}")
    print(f"[SETTLEMENT_API] search_query={search_query}")

    if user.role in ["manager", "super_manager"]:
        query = Settlement.query.filter(Settlement.company == company).options(
            joinedload(Settlement.expenses)
        )
    else:
        query = (
            Settlement.query.filter(Settlement.company == company)
            .options(joinedload(Settlement.expenses))
            .filter_by(user_id=user_id)
        )

    # STATUS FILTER
    if status_filter in ("approved", "completed"):
        print("[SETTLEMENT_API] Filtering status: approved OR completed")
        query = query.filter(Settlement.status.in_(("approved", "completed")))
    elif status_filter in ("rejected", "revision"):
        # Include settlement status 'rejected' OR settlements with any rejected expense
        has_rejected_expenses = db.exists().where(
            db.and_(
                Expense.settlement_id == Settlement.id, Expense.status == "rejected"
            )
        )
        return_rejected = Settlement.return_status == "rejected"
        query = query.filter(
            db.or_(
                Settlement.status == "rejected",
                has_rejected_expenses,
                return_rejected,
            )
        )
    elif status_filter:
        print(f"[SETTLEMENT_API] Filtering status: {status_filter}")
        query = query.filter_by(status=status_filter)

    # YEAR FILTER
    if report_year is not None and report_year != 0:
        print(f"[SETTLEMENT_API] Filtering year={report_year} with mode={mode}")

        if mode == "report":
            # MURNI berdasarkan report_year
            query = query.filter(Settlement.report_year == report_year)
        else:
            # MURNI berdasarkan tahun aktual di item
            expense_match = db.exists().where(
                db.and_(
                    Expense.settlement_id == Settlement.id,
                    extract("year", Expense.date) == report_year,
                )
            )
            # Jika tidak ada item, fallback ke tahun created_at
            settlement_no_expenses = db.not_(
                db.exists().where(Expense.settlement_id == Settlement.id)
            )
            settlement_created_year_match = (
                extract("year", Settlement.created_at) == report_year
            )

            query = query.filter(
                db.or_(
                    expense_match,
                    db.and_(settlement_no_expenses, settlement_created_year_match),
                )
            ).distinct()
    else:
        print(f"[SETTLEMENT_API] NO year filter (report_year={report_year})")

    # SEARCH FILTER
    if search_query:
        like_pattern = f"%{search_query}%"
        print(f"[SETTLEMENT_API] Filtering search: {search_query}")

        parsed_date = None
        from datetime import datetime

        for fmt in [
            "%d-%m-%Y",
            "%Y-%m-%d",
            "%d/%m/%Y",
            "%d %b %Y",
            "%d-%b-%Y",
            "%d %B %Y",
            "%d-%B-%Y",
        ]:
            try:
                parsed_date = datetime.strptime(search_query, fmt).date()
                break
            except ValueError:
                pass

        or_conditions = [
            Settlement.title.ilike(like_pattern),
            Settlement.description.ilike(like_pattern),
            db.cast(Settlement.document_date, db.String).ilike(like_pattern),
            db.cast(Settlement.created_at, db.String).ilike(like_pattern),
        ]

        if parsed_date:
            or_conditions.append(Settlement.document_date == parsed_date)
            or_conditions.append(db.cast(Settlement.created_at, db.Date) == parsed_date)

        query = query.filter(db.or_(*or_conditions))

    type_filter = request.query_params.get("type")
    if type_filter and type_filter in ("single", "batch"):
        query = query.filter_by(settlement_type=type_filter)

    start_date_str = request.query_params.get("start_date")
    end_date_str = request.query_params.get("end_date")

    if start_date_str:
        try:
            start_date = datetime.strptime(
                start_date_str,
                "%Y-%m-%d",
            ).replace(tzinfo=timezone.utc)
            query = query.filter(Settlement.created_at >= start_date)
        except ValueError:
            pass

    if end_date_str:
        try:
            end_date = datetime.strptime(
                end_date_str,
                "%Y-%m-%d",
            ).replace(hour=23, minute=59, second=59, tzinfo=timezone.utc)
            query = query.filter(Settlement.created_at <= end_date)
        except ValueError:
            pass

    # Execute query
    settlements = query.order_by(Settlement.created_at.asc(), Settlement.id.asc()).all()

    singles = [s for s in settlements if s.settlement_type == "single"]
    batches = [s for s in settlements if s.settlement_type == "batch"]
    ordered = singles + batches

    # Log detail hasil
    print("[SETTLEMENT_API] ===== RESULT =====")
    print(f"[SETTLEMENT_API] Total: {len(ordered)} settlements")
    for s in ordered[:10]:  # Log first 10
        print(
            f"[SETTLEMENT_API]   - ID={s.id}, title={s.title}, status={s.status}, created_at={s.created_at}, year={s.created_at.year if s.created_at else '?'}"
        )
    if len(ordered) > 10:
        print(f"[SETTLEMENT_API]   ... and {len(ordered) - 10} more")

    return JSONResponse({"settlements": [s.to_dict() for s in ordered]}, status_code=200)

@settlements_crud_router.post("")
def create_settlement(
    data: dict = Body(default={}),
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = _company_or_default(company)

    title = data.get("title", "").strip()
    description = data.get("description", "").strip()
    settlement_type = data.get("settlement_type", "single")
    try:
        report_year = int(data.get("report_year")) if data.get("report_year") else None
    except (ValueError, TypeError):
        report_year = None

    advance_id_raw = data.get("advance_id")
    advance_id = None
    if advance_id_raw:
        try:
            advance_id = int(advance_id_raw)
            # Validasi 1-to-1 dihapus sesuai dengan fitur Dompet Gabungan
            # Settlement bebas memotong dari saldo mana pun, dan advance_id hanya untuk referensi historis opsional
        except (ValueError, TypeError):
            pass

    document_date_str = data.get("document_date")
    document_date = None
    if document_date_str:
        try:
            document_date = datetime.strptime(document_date_str, "%Y-%m-%d").date()
        except ValueError:
            pass

    if settlement_type not in ("single", "batch"):
        settlement_type = "single"

    if not title:
        return JSONResponse({"error": "Title wajib diisi"}, status_code=400)

    # Set created_at to match report_year if provided
    created_at = datetime.now(timezone.utc)
    if report_year:
        try:
            created_at = created_at.replace(year=report_year)
        except ValueError:
            created_at = created_at.replace(year=report_year, day=28)

    copy_from_advance_id = data.get("copy_from_advance_id")
    if copy_from_advance_id:
        try:
            copy_from_advance_id = int(copy_from_advance_id)
        except (ValueError, TypeError):
            copy_from_advance_id = None

    settlement = Settlement(
        title=title,
        description=description,
        user_id=user_id,
        status="draft",
        settlement_type=settlement_type,
        report_year=report_year,
        advance_id=advance_id,
        created_at=created_at,
        document_date=document_date,
        company=company,
    )
    db.session.add(settlement)
    db.session.flush()

    if copy_from_advance_id:
        from models import Advance, Expense
        advance_source = Advance.query.get(copy_from_advance_id)
        if advance_source and advance_source.user_id == user_id and advance_source.company == company:
            for item in advance_source.items:
                expense = Expense(
                    settlement_id=settlement.id,
                    category_id=item.category_id,
                    description=item.description,
                    amount=getattr(item, 'estimated_amount', 0.0) or getattr(item, 'amount', 0.0),
                    date=document_date or datetime.now(timezone.utc).date(),
                    currency=item.currency,
                    company=settlement.company
                )
                expense.subcategories = item.subcategories
                db.session.add(expense)

    db.session.commit()
    
    
    _sync_advance_after_settlement(settlement)

    return JSONResponse({"settlement": settlement.to_dict(include_expenses=True)}, status_code=201)

@settlements_crud_router.get("/{settlement_id}")
def get_settlement(
    settlement_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = _company_or_default(company)
    settlement = Settlement.query.filter_by(
        id=settlement_id, company=company
    ).first_or_404()

    if user.role not in ["manager", "super_manager"] and settlement.user_id != user_id:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    return JSONResponse({"settlement": settlement.to_dict(include_expenses=True)}, status_code=200)

@settlements_crud_router.put("/{settlement_id}")
async def update_settlement(
    settlement_id: int,
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = _company_or_default(company)
    content_type = request.headers.get("content-type", "")
    try:
        if "application/json" in content_type:
            data = await request.json()
        elif "application/x-www-form-urlencoded" in content_type or "multipart/form-data" in content_type:
            data = dict(await request.form())
        else:
            data = {}
    except (ValueError, TypeError):
        data = {}
    data = data if isinstance(data, dict) else {}
    return await run_in_threadpool(_update_settlement, settlement_id, user_id, user, company, data)


def _update_settlement(settlement_id, user_id, user, company, data):
    settlement = Settlement.query.filter_by(
        id=settlement_id, company=company
    ).first_or_404()

    is_manager = user.role in ["manager", "super_manager"]
    if not is_manager and settlement.user_id != user_id:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    # Enforce draft mode for everyone
    if settlement.status not in ("draft", "rejected"):
        return JSONResponse(
            {"error": "Settlement sudah terkunci. Masuk ke mode Draft untuk mengedit."},
            status_code=400,
        )
    if "title" in data:
        settlement.title = str(data["title"]).strip()
        # Rule 3: Jika Batch, update deskripsi T2 & T3 jika Judul berubah
        if settlement.settlement_type == "batch" and not settlement.modified_t2:
            pass # settlement.disbursement_comment = settlement.title
            pass # settlement.return_description = settlement.title
    if "description" in data:
        settlement.description = str(data["description"]).strip()
    if "document_date" in data:
        document_date_str = data.get("document_date")
        if document_date_str:
            try:
                settlement.document_date = datetime.strptime(
                    document_date_str, "%Y-%m-%d"
                ).date()
                # Rule 3: Deskripsi T2 & T3
                if settlement.settlement_type == "batch" and not settlement.modified_t2:
                    pass # settlement.disbursement_comment = settlement.title
                    pass # settlement.return_description = settlement.title
            except ValueError:
                pass
        else:
            settlement.document_date = None

    db.session.commit()
    return JSONResponse({"settlement": settlement.to_dict()}, status_code=200)

@settlements_crud_router.delete("/{settlement_id}")
def delete_settlement(
    settlement_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = _company_or_default(company)
    settlement = Settlement.query.filter_by(
        id=settlement_id, company=company
    ).first_or_404()

    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager:
        if settlement.user_id != user_id:
            return JSONResponse({"error": "Akses ditolak"}, status_code=403)
        if settlement.status not in ("draft",):
            return JSONResponse({"error": "Hanya draft yang bisa dihapus"}, status_code=400)

    # ✅ FIX: Rollback Kasbon debt & bank transactions BEFORE deleting the settlement
    
    reason_label = f"Penghapusan Settlement ({'Batch' if settlement.settlement_type == 'batch' else 'Single'})"
    rollback_settlement_transactions(settlement, user, reason_label)

    # Hapus semua expenses terkait secara eksplisit (opsional tapi aman)
    for exp in settlement.expenses:
        db.session.delete(exp)

    advance_id = settlement.advance_id
    db.session.delete(settlement)
    
    if advance_id:
        from models import Advance
        advance = Advance.query.get(advance_id)
        if advance and advance.status == 'in_settlement':
            advance.status = 'approved'

    db.session.commit()
    return JSONResponse({"message": "Settlement berhasil dihapus."}, status_code=200)

@settlements_crud_router.get("/{settlement_id}/history")
def get_settlement_history(settlement_id: int, user: User = Depends(get_current_user)):
    settlement = Settlement.query.get_or_404(settlement_id)

    from models import WorkflowLog

    logs = (
        WorkflowLog.query.filter_by(
            document_type="settlement", document_id=settlement.id
        )
        .order_by(WorkflowLog.created_at.asc())
        .all()
    )

    return JSONResponse({"history": [log.to_dict() for log in logs]}, status_code=200)

