from fastapi import APIRouter, Depends, Request
from fastapi.responses import JSONResponse
from starlette.concurrency import run_in_threadpool

from core.security import get_current_user
from models import Settlement, User, db
from services.approvals.settlement_helpers import rollback_settlement_transactions

settlements_other_router = APIRouter(prefix="/api/settlements", tags=["settlements"])


async def _read_json(request: Request) -> dict:
    try:
        payload = await request.json()
        return payload if isinstance(payload, dict) else {}
    except (ValueError, TypeError):
        return {}


@settlements_other_router.put("/{settlement_id}/override")
async def override_settlement(
    settlement_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_json(request)
    return await run_in_threadpool(_override_settlement, settlement_id, user, data)


def _override_settlement(settlement_id: int, user: User, data: dict):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(
            {"error": "Akses ditolak. Hanya manager yang bisa override data final"},
            status_code=403,
        )

    settlement = Settlement.query.get_or_404(settlement_id)
    for field in ("bank_id", "description", "status"):
        if field in data:
            setattr(settlement, field, data[field])

    db.session.commit()
    return JSONResponse(
        {
            "message": "Data settlement berhasil di-override",
            "settlement": settlement.to_dict(),
        },
        status_code=200,
    )


@settlements_other_router.post("/{settlement_id}/move_to_draft")
def move_to_draft(settlement_id: int, user: User = Depends(get_current_user)):
    return _move_to_draft(settlement_id, user)


def _move_to_draft(settlement_id: int, user: User):
    user_id = user.id
    settlement = Settlement.query.get_or_404(settlement_id)
    is_manager = user.role in ["manager", "super_manager"]

    if not is_manager and settlement.user_id != user_id:
        return JSONResponse(
            {"error": "Akses ditolak: Hanya pemilik atau manager yang bisa mengubah ke draft"},
            status_code=403,
        )

    if settlement.status in ("approved", "completed") and not is_manager:
        return JSONResponse(
            {"error": "Karyawan tidak bisa menarik Settlement yang sudah Approved atau Completed. Hubungi Manajer."},
            status_code=403,
        )

    if settlement.status not in ("submitted", "rejected", "approved", "completed"):
        return JSONResponse(
            {"error": f"Status {settlement.status} tidak bisa ditarik ke draft"},
            status_code=400,
        )

    settlement.status = "draft"
    for expense in settlement.expenses:
        if expense.status == "submitted":
            expense.status = "pending"

    settlement.is_disbursement_approved = False
    settlement.is_return_approved = False
    if settlement.return_status == "submitted":
        settlement.return_status = "pending"

    reason_label = (
        "Pembatalan (Move to Draft) Settlement "
        f"({'Batch' if settlement.settlement_type == 'batch' else 'Single'})"
    )
    rollback_settlement_transactions(settlement, user, reason_label)

    db.session.commit()
    return JSONResponse(
        {
            "message": "Settlement berhasil dikembalikan ke draft",
            "settlement": settlement.to_dict(),
        },
        status_code=200,
    )
