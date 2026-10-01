from utils.parsing_helper import _parse_date, _parse_float_safe
from datetime import datetime

from fastapi import APIRouter, Body, Depends, Header, Query
from fastapi.responses import JSONResponse
from core.security import get_current_user
from services.transactions.dividend_service import _fetch_revenues_and_expenses_for_year, _build_dividend_payload

from models import Dividend, DividendSetting, Expense, Revenue, Settlement, User, db

from services.reports.annual_service.annual_helpers import _compute_dividend_distribution_v2

dividends_router = APIRouter(prefix="/api/dividends", tags=["dividends"])




SETTING_FLOAT_FIELDS = [
    "profit_retained",
    "opening_cash_balance",
    "accounts_receivable",
    "prepaid_tax_pph23",
    "prepaid_expenses",
    "other_receivables",
    "office_inventory",
    "other_assets",
    "accounts_payable",
    "salary_payable",
    "shareholder_payable",
    "accrued_expenses",
    "share_capital",
    "retained_earnings_balance",
    "corporate_tax_pph29",
    "corporate_tax_rate",
    "other_income",
]


@dividends_router.get("")
def get_dividends(
    year: int | None = Query(default=None),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    if year is None:
        return JSONResponse({"error": "year wajib diisi"}, status_code=400)
    return _build_dividend_payload(year, company=company or "EWI Foundation")


@dividends_router.get("/{dividend_id}")
def get_dividend(
    dividend_id: int,
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    dividend = Dividend.query.filter_by(id=dividend_id, company=company).first_or_404()
    return dividend.to_dict()


@dividends_router.post("")
def create_dividend(
    data: dict = Body(default={}),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(
            {"error": "Akses ditolak. Hanya manager yang dapat membuat data dividen."},
            status_code=403,
        )

    date = _parse_date(data.get("date"))
    name = (data.get("name") or "").strip()
    profit_retained = data.get("profit_retained")
    percentage = float(data.get("percentage") or 0.0)

    if not date or not name:
        return JSONResponse({"error": "date dan name wajib diisi"}, status_code=400)

    try:
        year = date.year
        setting = DividendSetting.query.filter_by(year=year).first()
        if setting is None:
            setting = DividendSetting(
                year=year, profit_retained=float(profit_retained or 0)
            )
            db.session.add(setting)
        elif profit_retained is not None:
            setting.profit_retained = float(profit_retained or 0)

        dividend = Dividend(
            date=date,
            name=name,
            amount=0.0,
            percentage=percentage,
            recipient_count=1,
            tax_percentage=0.0,
            report_year=year,
            company=company or "EWI Foundation",
        )
        db.session.add(dividend)
        db.session.commit()
        return JSONResponse(dividend.to_dict(), status_code=201)
    except Exception as exc:
        db.session.rollback()
        return JSONResponse({"error": str(exc)}, status_code=500)


@dividends_router.put("/{dividend_id}")
def update_dividend(dividend_id: int, data: dict = Body(default={}), user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    dividend = Dividend.query.get_or_404(dividend_id)

    if "date" in data:
        parsed = _parse_date(data.get("date"))
        if not parsed:
            return JSONResponse({"error": "Format date tidak valid"}, status_code=400)
        dividend.date = parsed
    if "name" in data:
        dividend.name = (data.get("name") or "").strip()
    if "percentage" in data:
        dividend.percentage = float(data.get("percentage") or 0.0)

    if not dividend.name:
        return JSONResponse({"error": "name wajib diisi"}, status_code=400)

    try:
        db.session.commit()
        return dividend.to_dict()
    except Exception as exc:
        db.session.rollback()
        return JSONResponse({"error": str(exc)}, status_code=500)


@dividends_router.put("/settings/{year}")
def update_dividend_setting(
    year: int,
    data: dict = Body(default={}),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    if not any(field in data for field in SETTING_FLOAT_FIELDS):
        return JSONResponse({"error": "minimal satu field setting wajib diisi"}, status_code=400)

    try:
        company = company or "EWI Foundation"
        setting = DividendSetting.query.filter_by(year=year, company=company).first()
        if setting is None:
            setting = DividendSetting(year=year, company=company)
            db.session.add(setting)
        for field in SETTING_FLOAT_FIELDS:
            if field in data:
                val = _parse_float_safe(data.get(field), default=0.0)
                setattr(setting, field, val if val is not None else 0.0)
        db.session.commit()
        return setting.to_dict()
    except Exception as exc:
        db.session.rollback()
        return JSONResponse({"error": str(exc)}, status_code=500)


@dividends_router.delete("/{dividend_id}")
def delete_dividend(dividend_id: int, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak."}, status_code=403)

    dividend = Dividend.query.get_or_404(dividend_id)
    try:
        db.session.delete(dividend)
        db.session.commit()
        return {"message": "Penerima dividen dihapus"}
    except Exception as exc:
        db.session.rollback()
        return JSONResponse({"error": str(exc)}, status_code=500)
