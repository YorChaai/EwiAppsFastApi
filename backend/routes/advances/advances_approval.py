from fastapi import APIRouter, Depends, Request
from starlette.concurrency import run_in_threadpool

from core.security import get_current_user
from models import User
from services.advances.advance_approval_service import (
    process_approve_advance,
    process_approve_advance_item,
    process_final_approve_advance,
    process_reject_advance,
    process_reject_advance_item,
    process_start_revision,
    process_submit_advance,
)

advances_approval_router = APIRouter(prefix="/api/advances", tags=["advances"])


async def _read_request_data(request: Request) -> dict:
    content_type = request.headers.get("content-type", "")
    try:
        if "application/json" in content_type:
            payload = await request.json()
            return payload if isinstance(payload, dict) else {}
        if "application/x-www-form-urlencoded" in content_type or "multipart/form-data" in content_type:
            return dict(await request.form())
    except (ValueError, TypeError):
        return {}
    return {}


@advances_approval_router.post("/{advance_id}/start_revision")
async def start_revision(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_start_revision, advance_id, user.id, data)


@advances_approval_router.post("/{advance_id}/submit")
async def submit_advance(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_submit_advance, advance_id, user.id, data)


@advances_approval_router.post("/{advance_id}/approve_all")
async def approve_advance(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_approve_advance, advance_id, user.id, data)


@advances_approval_router.post("/{advance_id}/reject_all")
async def reject_advance(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_reject_advance, advance_id, user.id, data)


@advances_approval_router.post("/items/{item_id}/approve")
async def approve_advance_item(
    item_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_approve_advance_item, item_id, user.id, data)


@advances_approval_router.post("/items/{item_id}/reject")
async def reject_advance_item(
    item_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_reject_advance_item, item_id, user.id, data)


@advances_approval_router.post("/{advance_id}/final_approve")
async def final_approve_advance(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data = await _read_request_data(request)
    return await run_in_threadpool(process_final_approve_advance, advance_id, user.id, data)
