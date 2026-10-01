from datetime import datetime, timezone

from fastapi import APIRouter, Body, Depends, Header
from fastapi.responses import JSONResponse

from core.security import get_current_user
from models import DeadlineSetting, User, db
from services.core.settings_service import (
    _find_deadline_setting,
    _normalize_deadline_rule_key,
    _sanitize_deadline_days,
)

deadline_router = APIRouter(prefix="/api/settings", tags=["settings"])

DEADLINE_DEFAULTS = {
    "ADVANCE_COMPLETION": {
        "rule_key": "ADVANCE_COMPLETION",
        "days": [2, 10, 20],
        "is_active": True,
    },
    "ADVANCE_REVISION_APPROVAL": {
        "rule_key": "ADVANCE_REVISION_APPROVAL",
        "days": [1, 3, 7],
        "is_active": True,
    },
    "SETTLEMENT_SUBMISSION": {
        "rule_key": "SETTLEMENT_SUBMISSION",
        "days": [2, 5, 10],
        "is_active": True,
    },
    "SETTLEMENT_MANAGER_REVIEW": {
        "rule_key": "SETTLEMENT_MANAGER_REVIEW",
        "days": [2, 5, 10],
        "is_active": True,
    },
    "SETTLEMENT_FINAL_APPROVAL": {
        "rule_key": "SETTLEMENT_FINAL_APPROVAL",
        "days": [1, 3, 7],
        "is_active": True,
    },
}


def _manager_error(user: User):
    if user.role not in {"manager", "super_manager"}:
        return JSONResponse({"error": "Akses hanya untuk manager"}, status_code=403)
    return None


@deadline_router.get("/deadline")
def get_deadline_settings(
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    denied = _manager_error(user)
    if denied:
        return denied
    company = company or "EWI Foundation"
    try:
        settings = DeadlineSetting.query.filter_by(company=company).all()
        result = {key: value.copy() for key, value in DEADLINE_DEFAULTS.items()}
        for setting in settings:
            normalized_key = _normalize_deadline_rule_key(setting.rule_key)
            result[normalized_key] = {
                **setting.to_dict(),
                "rule_key": normalized_key,
            }
        return result
    except Exception as exc:
        return JSONResponse(
            {"error": f"Gagal mengambil setting deadline: {exc}"}, status_code=500
        )


@deadline_router.post("/deadline")
def create_deadline_setting(
    data: dict = Body(default={}),
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    denied = _manager_error(user)
    if denied:
        return denied
    company = company or "EWI Foundation"
    try:
        rule_key = _normalize_deadline_rule_key(data.get("rule_key"))
        days = _sanitize_deadline_days(data.get("days", []))
        is_active = data.get("is_active", True)
        if not rule_key:
            return JSONResponse({"error": "rule_key tidak boleh kosong"}, status_code=400)
        if days is None:
            return JSONResponse(
                {"error": "days harus berupa array angka positif dengan minimal 1 elemen"},
                status_code=400,
            )
        existing, _ = _find_deadline_setting(rule_key, company=company)
        if existing:
            return JSONResponse(
                {"error": f'Setting dengan rule_key "{rule_key}" sudah ada untuk perusahaan ini'},
                status_code=400,
            )
        setting = DeadlineSetting(
            rule_key=rule_key, days=days, is_active=is_active, company=company
        )
        db.session.add(setting)
        db.session.commit()
        return JSONResponse(
            {"message": "Setting deadline berhasil ditambahkan.", "data": setting.to_dict()},
            status_code=201,
        )
    except Exception as exc:
        db.session.rollback()
        return JSONResponse(
            {"error": f"Gagal menyimpan setting deadline: {exc}"}, status_code=500
        )


@deadline_router.put("/deadline")
def update_deadline_setting(
    data: dict = Body(default={}),
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    denied = _manager_error(user)
    if denied:
        return denied
    company = company or "EWI Foundation"
    rule_key = data.get("rule_key")
    days = data.get("days")
    is_active = data.get("is_active")
    if not rule_key:
        return JSONResponse({"error": "rule_key tidak boleh kosong"}, status_code=400)
    try:
        setting, normalized_key = _find_deadline_setting(rule_key, company=company)
        if not setting:
            sanitized_days = _sanitize_deadline_days(days) if days is not None else [1, 3, 7]
            if sanitized_days is None:
                return JSONResponse(
                    {"error": "days harus berupa array angka positif dengan minimal 1 elemen"},
                    status_code=400,
                )
            setting = DeadlineSetting(
                rule_key=normalized_key,
                days=sanitized_days,
                is_active=is_active if is_active is not None else True,
                company=company,
            )
            db.session.add(setting)
        else:
            setting.rule_key = normalized_key
        if days is not None:
            sanitized_days = _sanitize_deadline_days(days)
            if sanitized_days is None:
                return JSONResponse(
                    {"error": "days harus berupa array angka positif dengan minimal 1 elemen"},
                    status_code=400,
                )
            setting.days = sanitized_days
        if is_active is not None:
            setting.is_active = is_active
        setting.updated_at = datetime.now(timezone.utc)
        db.session.commit()
        return {
            "message": "Setting deadline berhasil diperbarui.",
            "data": setting.to_dict(),
        }
    except Exception as exc:
        db.session.rollback()
        return JSONResponse(
            {"error": f"Gagal memperbarui setting deadline: {exc}"}, status_code=500
        )
