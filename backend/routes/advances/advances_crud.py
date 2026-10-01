from services.approvals.advance_helpers import get_cash_composition_for_error, _advance_view_status_filter
from datetime import datetime, timezone
from sqlalchemy import extract
from fastapi import APIRouter, Depends, Header, Request
from fastapi.responses import JSONResponse
from starlette.concurrency import run_in_threadpool
from core.security import get_current_user
from models import (
    Advance,
    AdvanceItem,
    User,
    db,
)

from sqlalchemy.orm import joinedload
from starlette.datastructures import UploadFile as StarletteUploadFile

advances_crud_router = APIRouter(prefix="/api/advances", tags=["advances"])


def _query_int(request: Request, key: str) -> int | None:
    value = request.query_params.get(key)
    if value is None:
        return None
    try:
        return int(value)
    except ValueError:
        return None


async def _read_payload(request: Request) -> dict:
    content_type = request.headers.get("content-type", "")
    try:
        if "application/json" in content_type:
            payload = await request.json()
            return payload if isinstance(payload, dict) else {}
        if "application/x-www-form-urlencoded" in content_type or "multipart/form-data" in content_type:
            form = await request.form()
            return {key: value for key, value in form.items() if not isinstance(value, StarletteUploadFile)}
    except (ValueError, TypeError):
        return {}
    return {}



@advances_crud_router.get("")
def list_advances(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    status_filter = request.query_params.get("status")
    report_year = _query_int(request, "report_year")
    mode = request.query_params.get("mode", "report")  # 'report' or 'actual'
    type_filter = request.query_params.get("type")
    company = company or "EWI Foundation"

    query = Advance.query.filter(Advance.company == company).options(
        joinedload(Advance.items), joinedload(Advance.requester)
    )
    
    # Hide system-generated dummy advances from the UI
    query = query.filter(
        db.not_(Advance.title.like("Penyelesaian Kasbon:%")),
        db.not_(Advance.title.like("Kompensasi Split Kasbon:%")),
        db.not_(Advance.title.like("Split Potongan Kasbon:%"))
    )

    if user.role not in ["manager", "super_manager"]:
        query = query.filter_by(user_id=user.id)

    query = _advance_view_status_filter(query, status_filter)
    if type_filter in ("single", "batch"):
        query = query.filter_by(advance_type=type_filter)

    start_date_str = request.query_params.get("start_date")
    end_date_str = request.query_params.get("end_date")

    if start_date_str:
        try:
            start_date = datetime.strptime(
                start_date_str,
                "%Y-%m-%d",
            ).replace(tzinfo=timezone.utc)
            query = query.filter(Advance.created_at >= start_date)
        except ValueError:
            pass

    if end_date_str:
        try:
            end_date = datetime.strptime(
                end_date_str,
                "%Y-%m-%d",
            ).replace(hour=23, minute=59, second=59, tzinfo=timezone.utc)
            query = query.filter(Advance.created_at <= end_date)
        except ValueError:
            pass

    if report_year is not None and report_year != 0:
        if mode == "report":
            # MURNI berdasarkan report_year
            query = query.filter(Advance.report_year == report_year)
        else:
            # MURNI berdasarkan tahun aktual di item
            item_match = db.exists().where(
                db.and_(
                    AdvanceItem.advance_id == Advance.id,
                    extract("year", AdvanceItem.date) == report_year,
                )
            )
            # Fallback jika tidak ada item
            advance_no_items = db.not_(
                db.exists().where(AdvanceItem.advance_id == Advance.id)
            )
            advance_created_year_match = (
                extract("year", Advance.created_at) == report_year
            )

            query = query.filter(
                db.or_(
                    item_match,
                    db.and_(advance_no_items, advance_created_year_match),
                )
            ).distinct()

    search_query = request.query_params.get("search", "").strip()
    if search_query:
        like_pattern = f"%{search_query}%"

        parsed_date = None

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
            Advance.title.ilike(like_pattern),
            Advance.description.ilike(like_pattern),
            db.cast(Advance.document_date, db.String).ilike(like_pattern),
            db.cast(Advance.created_at, db.String).ilike(like_pattern),
        ]

        if parsed_date:
            or_conditions.append(Advance.document_date == parsed_date)
            or_conditions.append(db.cast(Advance.created_at, db.Date) == parsed_date)

        query = query.filter(db.or_(*or_conditions))

    advances = query.order_by(Advance.created_at.asc(), Advance.id.asc()).all()
    return JSONResponse({"advances": [a.to_dict() for a in advances]}, status_code=200)

@advances_crud_router.post("")
async def create_advance(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    data = await _read_payload(request)
    return await run_in_threadpool(_create_advance, user.id, company or "EWI Foundation", data)


def _create_advance(user_id: int, company: str, data: dict):

    title = data.get("title", "").strip()
    description = data.get("description", "").strip()
    advance_type = data.get("advance_type", "single")
    try:
        report_year = int(data.get("report_year")) if data.get("report_year") else None
    except (ValueError, TypeError):
        report_year = None

    document_date_str = data.get("document_date")
    document_date = None
    if document_date_str:
        try:
            document_date = datetime.strptime(document_date_str, "%Y-%m-%d").date()
        except ValueError:
            pass

    if advance_type not in ("single", "batch"):
        advance_type = "single"

    if not title:
        return JSONResponse({"error": "Title wajib diisi"}, status_code=400)

    # Gunakan waktu asli sekarang untuk created_at
    # report_year tetap menyimpan tahun target laporan (misal: 2027)
    created_at = datetime.now(timezone.utc)

    advance = Advance(
        title=title,
        description=description,
        advance_type=advance_type,
        user_id=user_id,
        status="draft",
        approved_revision_no=0,
        active_revision_no=None,
        report_year=report_year,
        created_at=created_at,
        document_date=document_date,
        company=company,
    )
    db.session.add(advance)
    db.session.commit()

    return JSONResponse({"advance": advance.to_dict()}, status_code=201)

@advances_crud_router.get("/{advance_id:int}")
def get_advance(
    advance_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = company or "EWI Foundation"
    advance = Advance.query.filter_by(id=advance_id, company=company).first_or_404()

    if user.role not in ["manager", "super_manager"] and advance.user_id != user_id:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    advance_dict = advance.to_dict(include_items=True)

    # Tambahkan cash_composition dari Advance Bank pembuat kasbon
    advance_dict["cash_composition"] = get_cash_composition_for_error(advance)

    return JSONResponse({"advance": advance_dict}, status_code=200)

@advances_crud_router.put("/{advance_id}")
async def update_advance(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    data = await _read_payload(request)
    return await run_in_threadpool(
        _update_advance, advance_id, user.id, user, company or "EWI Foundation", data
    )


def _update_advance(advance_id, user_id, user, company, data):
    advance = Advance.query.filter_by(id=advance_id, company=company).first_or_404()
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and advance.user_id != user_id:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    # Enforce draft mode for everyone
    if advance.status not in (
        "draft",
        "revision",
        "rejected",
    ):
        return JSONResponse(
            {"error": "Data sudah terkunci. Masuk ke mode Draft untuk mengedit."},
            status_code=400,
        )
    if "title" in data:
        advance.title = data["title"].strip()
        # Rule 3: Jika Batch, update deskripsi T2 & T3 jika Judul berubah
        if advance.advance_type == "batch" and not advance.modified_t2:
            pass # advance.disbursement_comment = advance.title
            pass # advance.return_description = advance.title
    if "description" in data:
        advance.description = data["description"].strip()
    if "advance_type" in data and data["advance_type"] in ("single", "batch"):
        advance.advance_type = data["advance_type"]
    if "document_date" in data:
        document_date_str = data.get("document_date")
        if document_date_str:
            try:
                advance.document_date = datetime.strptime(
                    document_date_str, "%Y-%m-%d"
                ).date()
                # Rule 3: Deskripsi T2 & T3 (walaupun tanggal berubah, rule bilang deskripsi update)
                # Sebenarnya rule bilang Title atau Date berubah -> Deskripsi update.
                if advance.advance_type == "batch" and not advance.modified_t2:
                    pass # advance.disbursement_comment = advance.title
                    pass # advance.return_description = advance.title
            except ValueError:
                pass
        else:
            advance.document_date = None

    db.session.commit()
    return JSONResponse({"advance": advance.to_dict()}, status_code=200)

@advances_crud_router.delete("/{advance_id}")
def delete_advance(
    advance_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    user_id = user.id
    company = company or "EWI Foundation"
    advance = Advance.query.filter_by(id=advance_id, company=company).first_or_404()
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and advance.user_id != user_id:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    if not is_manager:
        if advance.status not in ("draft",):
            return JSONResponse({"error": "Hanya draft yang bisa dihapus"}, status_code=400)

    if advance.settlements:
        return JSONResponse({"error": "Kasbon ini tidak bisa dihapus karena sudah dipakai oleh Settlement. Hapus atau pindahkan Settlement terkait ke draft terlebih dahulu."}, status_code=400)

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
            contribution = advance.approved_amount
            if advance.is_return_approved:
                contribution -= advance.returned_amount

            simulated_hutang = current_hutang - contribution
            if simulated_hutang < -0.01:
                return JSONResponse(
                    {"error": "Kasbon ini tidak bisa dihapus! Saldo Virtual (Plafon) tidak mencukupi karena sudah terpakai oleh Settlement. Hapus atau kembalikan Settlement terkait ke draft terlebih dahulu."},
                    status_code=400,
                )

    db.session.delete(advance)
    db.session.commit()

    return JSONResponse({"message": "Kasbon berhasil dihapus"}, status_code=200)

@advances_crud_router.get("/{advance_id}/history")
def get_advance_history(advance_id: int, user: User = Depends(get_current_user)):
    advance = Advance.query.get_or_404(advance_id)

    from models import WorkflowLog

    logs = (
        WorkflowLog.query.filter_by(document_type="advance", document_id=advance.id)
        .order_by(WorkflowLog.created_at.asc())
        .all()
    )

    return JSONResponse({"history": [log.to_dict() for log in logs]}, status_code=200)

