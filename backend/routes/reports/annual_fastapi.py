import logging
from datetime import datetime

from fastapi import APIRouter, Depends, Header, Request
from fastapi.responses import FileResponse, JSONResponse

from core.security import require_role
from models import User
from services.reports.annual_service.caching import (
    _save_annual_payload_cache,
    _save_annual_pdf_cache,
)
from services.reports.data_fetcher.payload_builder import _build_annual_payload_from_db
from services.reports.annual_service.excel_generator import get_annual_report_excel
from services.reports.table_builder.pdf_builder import _build_annual_pdf_bytes
from utils.parsing_helper import _parse_iso_date

logger = logging.getLogger(__name__)
annual_router = APIRouter(prefix="/api/reports", tags=["reports"])


def _query_int(request: Request, key: str, default: int) -> int:
    try:
        return int(request.query_params.get(key, default))
    except (TypeError, ValueError):
        return default


def _query_company(company: str | None) -> str:
    return company or "EWI Foundation"


@annual_router.get("/annual")
def get_annual_report(
    request: Request,
    user: User = Depends(require_role("manager", "super_manager")),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    company = _query_company(company)
    year = _query_int(request, "year", datetime.now().year)
    mode = request.query_params.get("mode", "report")
    sort_mode = request.query_params.get("sort_mode", "kategori")
    start_date = _parse_iso_date(request.query_params.get("start_date"))
    end_date = _parse_iso_date(request.query_params.get("end_date"))

    try:
        payload = _build_annual_payload_from_db(
            year=year,
            mode=mode,
            start_date=start_date,
            end_date=end_date,
            company=company,
            sort_mode=sort_mode,
        )
        payload["cache_source"] = "refresh"
        payload["report_mode"] = mode
        payload["start_date"] = start_date.isoformat() if start_date else None
        payload["end_date"] = end_date.isoformat() if end_date else None
        return _save_annual_payload_cache(year, payload)
    except Exception as exc:
        logger.error("Error generating annual report: %s", exc, exc_info=True)
        return JSONResponse({"error": str(exc)}, status_code=500)


@annual_router.get("/annual/pdf")
def get_annual_report_pdf(
    request: Request,
    user: User = Depends(require_role("manager", "super_manager")),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    company = _query_company(company)
    year = _query_int(request, "year", datetime.now().year)
    mode = request.query_params.get("mode", "report")
    filename = f"Laporan_Tahunan_{year}_{mode}.pdf"
    payload = _save_annual_payload_cache(
        year, _build_annual_payload_from_db(year, mode=mode, company=company)
    )
    pdf_path = _save_annual_pdf_cache(year, _build_annual_pdf_bytes(payload))
    return FileResponse(pdf_path, filename=filename, media_type="application/pdf")


@annual_router.get("/annual/excel")
def export_annual_report_excel(
    request: Request,
    user: User = Depends(require_role("manager", "super_manager")),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    query = request.query_params
    return get_annual_report_excel(
        year=_query_int(request, "year", datetime.now().year),
        mode=query.get("mode", "report"),
        sort_mode=query.get("sort_mode", "kategori"),
        start_date_str=query.get("start_date"),
        end_date_str=query.get("end_date"),
        company=_query_company(company),
        force_refresh=query.get("refresh", "0") == "1",
    )
