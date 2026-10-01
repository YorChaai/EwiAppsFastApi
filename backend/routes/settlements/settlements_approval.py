from fastapi import APIRouter, Depends, Request
from starlette.concurrency import run_in_threadpool

from core.security import get_current_user
from models import User
from services.settlements.settlement_approval_service import (
    process_approve_settlement,
    process_complete_settlement,
    process_final_approve_settlement,
    process_reject_all_expenses,
    process_submit_settlement,
)

settlements_approval_router = APIRouter(prefix="/api/settlements", tags=["settlements"])


async def _read_request_data(request: Request) -> dict:
    content_type = request.headers.get("content-type", "")
    try:
        if "application/json" in content_type:
            payload = await request.json()
            return payload if isinstance(payload, dict) else {}
    except (ValueError, TypeError):
        return {}
    return {}


@settlements_approval_router.post("/{settlement_id}/submit")
def submit_settlement(settlement_id: int, user: User = Depends(get_current_user)):
    return process_submit_settlement(settlement_id, user.id)


@settlements_approval_router.post("/{settlement_id}/approve")
async def approve_settlement(
    settlement_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_approve_settlement, settlement_id, user.id, data)


@settlements_approval_router.post("/{settlement_id}/complete")
def complete_settlement(settlement_id: int, user: User = Depends(get_current_user)):
    return process_complete_settlement(settlement_id, user.id)


@settlements_approval_router.post("/{settlement_id}/reject_all")
async def reject_all_expenses(
    settlement_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_reject_all_expenses, settlement_id, user.id, data)


@settlements_approval_router.post("/{settlement_id}/final_approve")
async def final_approve_settlement(
    settlement_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_final_approve_settlement, settlement_id, user.id, data)
