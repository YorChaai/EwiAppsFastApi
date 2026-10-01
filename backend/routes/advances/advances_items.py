from fastapi import APIRouter, Depends, Request
from starlette.concurrency import run_in_threadpool
from starlette.datastructures import UploadFile as StarletteUploadFile

from core.security import get_current_user
from models import User
from services.advances.advance_items_service import AdvanceItemsService

advances_items_router = APIRouter(prefix="/api/advances", tags=["advances"])


async def _read_payload(request: Request) -> tuple[dict, dict]:
    content_type = request.headers.get("content-type", "")
    if "multipart/form-data" in content_type or "application/x-www-form-urlencoded" in content_type:
        form = await request.form()
        data = {
            key: value
            for key, value in form.items()
            if not isinstance(value, StarletteUploadFile)
        }
        uploads = {}
        for key in form.keys():
            files = [
                value
                for value in form.getlist(key)
                if isinstance(value, StarletteUploadFile)
            ]
            if files:
                uploads[key] = files
        return data, uploads

    if "application/json" in content_type:
        try:
            payload = await request.json()
            return (payload if isinstance(payload, dict) else {}), {}
        except (ValueError, TypeError):
            return {}, {}
    return {}, {}


@advances_items_router.post("/{advance_id}/items")
async def add_advance_item(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data, files = await _read_payload(request)
    return await run_in_threadpool(
        AdvanceItemsService.add_advance_item, advance_id, user, data, files
    )


@advances_items_router.put("/items/{item_id}")
async def update_advance_item(
    item_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data, files = await _read_payload(request)
    return await run_in_threadpool(
        AdvanceItemsService.update_advance_item, item_id, user, data, files
    )


@advances_items_router.delete("/items/{item_id}")
def delete_advance_item(item_id: int, user: User = Depends(get_current_user)):
    return AdvanceItemsService.delete_advance_item(item_id, user)


@advances_items_router.post("/items/bulk-delete")
async def bulk_delete_advance_items(
    request: Request,
    user: User = Depends(get_current_user),
):
    data, _files = await _read_payload(request)
    return await run_in_threadpool(
        AdvanceItemsService.bulk_delete_advance_items,
        user,
        data,
        request.headers.get("X-Company") or "EWI Foundation",
    )


@advances_items_router.put("/{advance_id}/items/bulk")
async def update_advance_items_bulk(
    advance_id: int,
    request: Request,
    user: User = Depends(get_current_user),
):
    data, _files = await _read_payload(request)
    return await run_in_threadpool(
        AdvanceItemsService.update_advance_items_bulk,
        advance_id,
        user,
        data,
        request.headers.get("X-Company") or "EWI Foundation",
    )
