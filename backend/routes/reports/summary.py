# summary, settlement receipt, advance report, dan bulk export endpoints

import logging
import os
import re
from datetime import date, datetime
from io import BytesIO
from typing import Any, List, Optional, Union

from fastapi import APIRouter, Depends, Header, Request
from fastapi.responses import JSONResponse, StreamingResponse
from core.security import get_current_user
from services.reports.summary_service.data_helpers import _build_summary_payload, _validate_date, _expense_amount_for_summary, _get_display_subcategory, _summary_display_category, _display_settlement_status, _get_summary_approved_expenses
from services.reports.summary_service.excel_generator import generate_excel_report, generate_excel_advance_report
from services.reports.summary_service.pdf_generator import generate_pdf_advance_report, generate_settlement_receipt, generate_bulk_settlements_pdf, generate_bulk_advances_pdf

from models import Advance, Category, Expense, Settlement, User, db
from openpyxl import Workbook
from openpyxl.drawing.image import Image as OpenpyxlImage
from openpyxl.styles import Alignment, Font, PatternFill
from openpyxl.utils import get_column_letter
from reportlab.lib import colors
from reportlab.lib.pagesizes import landscape, letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.pdfbase.pdfmetrics import stringWidth
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle

from utils.parsing_helper import _default_report_year, _parse_iso_date, _year_date_bounds

# Setup logging
logger = logging.getLogger(__name__)
summary_router = APIRouter(prefix="/api/reports", tags=["reports"])


def _query_int(request: Request, key: str):
    try:
        return int(request.query_params.get(key))
    except (TypeError, ValueError):
        return None

COMMON_SUBCATEGORY_ORDER = [
    "Rental Tool",
    "Sales",
    "Gaji",
    "Pembuatan Alat",
    "Allowance",
    "Data Processing",
    "Project Operation",
    "Sparepart",
    "Maintenance",
    "Software License",
    "Operation",
    "Sewa Ruangan",
    "Modal Kerja",
    "Team Building",
    "Biaya Bank & Admin",
]
















@summary_router.get("/summary")
def get_summary_report(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):

    print(f"[SUMMARY_API] User={user.username}, role={user.role}")

    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    year = _query_int(request, "year")
    mode = request.query_params.get("mode", "report")
    start_date_str = request.query_params.get("start_date")
    end_date_str = request.query_params.get("end_date")

    # Jika mode bukan range, gunakan bounds tahun
    if mode != "range" and year:
        start_date, end_date = _year_date_bounds(year)
    else:
        start_date = _parse_iso_date(start_date_str)
        end_date = _parse_iso_date(end_date_str)

    expenses = _get_summary_approved_expenses(
        start_date=start_date, end_date=end_date, year=year, mode=mode, company=company
    )
    summary_data, grand_total = _build_summary_payload(expenses, company=company)

    return JSONResponse(
        {
            "summary": summary_data,
            "grand_total": grand_total,
            "year": year,
            "mode": mode,
            "start_date": start_date.isoformat() if start_date and hasattr(start_date, 'isoformat') else start_date,
            "end_date": end_date.isoformat() if end_date and hasattr(end_date, 'isoformat') else end_date,
            "cache_source": "refresh",
            "generated_at": datetime.now().isoformat(),
        }
    , status_code=200)


@summary_router.get("/summary/pdf")
def export_summary_pdf(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    year = _query_int(request, "year")
    mode = request.query_params.get("mode", "report")
    start_date_str = request.query_params.get("start_date")
    end_date_str = request.query_params.get("end_date")

    if mode != "range" and year:
        # ✅ FIX: _year_date_bounds hanya butuh 1 argumen
        start_date, end_date = _year_date_bounds(year)
    else:
        start_date = _parse_iso_date(start_date_str)
        end_date = _parse_iso_date(end_date_str)

    # ✅ Update call dengan parameter baru
    expenses = _get_summary_approved_expenses(
        start_date=start_date, end_date=end_date, year=year, mode=mode, company=company
    )
    summary_data, grand_total = _build_summary_payload(expenses, company=company)

    buffer = BytesIO()
    # Perkecil margin agar tabel punya ruang lebih luas (792 total lebar landscape)
    doc = SimpleDocTemplate(
        buffer,
        pagesize=landscape(letter),
        leftMargin=20,
        rightMargin=20,
        topMargin=30,
        bottom=30,
    )
    styles = getSampleStyleSheet()
    elements = []

    title = "Laporan Summary Pengeluaran"
    if start_date or end_date:
        s_text = start_date.isoformat() if hasattr(start_date, "isoformat") else str(start_date or "-")
        e_text = end_date.isoformat() if hasattr(end_date, "isoformat") else str(end_date or "-")
        period_text = f"Periode: {s_text} s/d {e_text}"
    else:
        period_text = "Periode: Semua Data"

    elements.append(Paragraph(title, styles["Heading1"]))
    elements.append(Paragraph(period_text, styles["Normal"]))
    elements.append(Spacer(1, 10))

    months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Agt",
        "Sep",
        "Okt",
        "Nov",
        "Des",
    ]
    table_data = [["Kategori"] + months + ["Total"]]

    # --- HITUNG LEBAR DINAMIS ---
    # Gunakan font sedikit lebih kecil agar angka besar (milyaran) tidak bertabrakan
    fontSize = 6.5
    max_cat_name_width = 110  # Minimum awal
    for row in summary_data:
        cat_name = str(row.get("category", "-"))
        level = row.get("level", 0)
        indent = level * 10
        w = (
            stringWidth(
                cat_name,
                "Helvetica-Bold" if row.get("is_parent") else "Helvetica",
                fontSize,
            )
            + indent
            + 12
        )
        if w > max_cat_name_width:
            max_cat_name_width = w

    # Cap category width agar kolom angka tetap proporsional
    if max_cat_name_width > 180:
        max_cat_name_width = 180

    month_totals = [0] * 12
    for row in summary_data:
        monthly = row.get("monthly", {})
        is_parent = row.get("is_parent", False)
        level = row.get("level", 0)

        values = []
        for i in range(1, 13):
            val = float(monthly.get(str(i), 0) or 0)
            month_totals[i - 1] += val
            values.append(f"{val:,.0f}" if val > 0 else "-")

        cat_name = row.get("category", "-")
        p_style = ParagraphStyle(
            "TableText", parent=styles["Normal"], fontSize=fontSize, leading=8
        )
        if is_parent:
            display_name = Paragraph(f"<b>{cat_name}</b>", p_style)
        else:
            p_style.leftIndent = level * 10
            display_name = Paragraph(cat_name, p_style)

        table_data.append(
            [display_name] + values + [f"{float(row.get('yearly_total', 0) or 0):,.0f}"]
        )

    table_data.append(
        [
            Paragraph(
                "<b>GRAND TOTAL</b>",
                ParagraphStyle("Total", parent=styles["Normal"], fontSize=fontSize),
            )
        ]
        + [f"{v:,.0f}" if v > 0 else "-" for v in month_totals]
        + [f"{float(grand_total):,.0f}"]
    )

    # Atur lebar kolom: month_width ditingkatkan ke 45, total_width ke 75
    month_col_width = 45
    last_col_width = 75
    col_widths = [max_cat_name_width] + [month_col_width] * 12 + [last_col_width]

    table = Table(table_data, colWidths=col_widths, repeatRows=1)

    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#3B82F6")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), fontSize),
                ("ALIGN", (1, 1), (-1, -1), "RIGHT"),
                ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#E6F0FF")),
                ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]
        )
    )

    elements.append(table)
    doc.build(elements)
    buffer.seek(0)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="summary_{timestamp}.pdf"'},
    )


@summary_router.get("/excel")
@summary_router.get("/summary/excel")
def export_summary_excel(
    request: Request,
    user: User = Depends(get_current_user),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)
    company = company or "EWI Foundation"
    query = request.query_params
    year = _query_int(request, "year")
    return generate_excel_report(
        company=company,
        year=_default_report_year() if year is None else year,
        mode=query.get("mode", "report"),
        start_date=_parse_iso_date(query.get("start_date")),
        end_date=_parse_iso_date(query.get("end_date")),
    )


@summary_router.get("/excel_advance")
def export_advance_excel(request: Request, user: User = Depends(get_current_user)):
    return generate_excel_advance_report(
        advance_id=_query_int(request, "advance_id"),
        start_date_str=request.query_params.get("start_date"),
        end_date_str=request.query_params.get("end_date"),
    )













