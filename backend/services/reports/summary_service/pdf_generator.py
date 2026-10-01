import io
from io import BytesIO
from reportlab.lib.pagesizes import A4, landscape, letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from sqlalchemy import extract
from fastapi.responses import JSONResponse, StreamingResponse
from models import Advance, AdvanceItem, Settlement, Expense, User, db
from datetime import datetime
from .data_helpers import _validate_date, _display_settlement_status


def generate_pdf_advance_report(advance_id, user):
    user_id = user.id
    advance = Advance.query.get_or_404(advance_id)
    if user.role not in ["manager", "super_manager"] and advance.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()
    title_style = styles["Heading1"]
    title_style.alignment = 1
    elements.append(Paragraph("Kasbon (Advance Request)", title_style))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph(f"<b>Judul:</b> {advance.title}", styles["Normal"]))
    elements.append(
        Paragraph(f"<b>Deskripsi:</b> {advance.description}", styles["Normal"])
    )
    elements.append(
        Paragraph(f"<b>Pemohon:</b> {advance.requester.full_name}", styles["Normal"])
    )
    elements.append(
        Paragraph(f"<b>Status:</b> {advance.status.upper()}", styles["Normal"])
    )
    elements.append(
        Paragraph(
            f"<b>Total Estimasi:</b> Rp {advance.total_amount:,.0f}", styles["Normal"]
        )
    )
    elements.append(
        Paragraph(
            f"<b>Disetujui:</b> Rp {advance.approved_amount:,.0f}", styles["Normal"]
        )
    )
    elements.append(Spacer(1, 12))
    data = [["Kategori", "Deskripsi", "Mata Uang", "Amount", "Kurs", "Estimasi (IDR)"]]
    for item in advance.items:
        currency = item.currency or "IDR"
        amount = item.estimated_amount or 0
        kurs = item.currency_exchange or 1
        idr = item.idr_amount or 0
        data.append(
            [
                item.category.name if item.category else "-",
                item.description,
                currency,
                f"{amount:,.0f}",
                f"{kurs:,.0f}",
                f"{idr:,.0f}",
            ]
        )
    t = Table(data, colWidths=[120, 180, 40, 60, 50, 80])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("ALIGN", (3, 0), (5, -1), "RIGHT"),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, 0), 12),
                ("BACKGROUND", (0, 1), (-1, -1), colors.beige),
                ("GRID", (0, 0), (-1, -1), 1, colors.black),
            ]
        )
    )
    elements.append(t)
    doc.build(elements)
    buffer.seek(0)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="kasbon_{advance_id}_{timestamp}.pdf"'},
    )

def generate_settlement_receipt(settlement_id, user):
    user_id = user.id
    settlement = Settlement.query.get_or_404(settlement_id)
    if user.role not in ["manager", "super_manager"] and settlement.user_id != user_id:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()
    title_style = styles["Heading1"]
    title_style.alignment = 1
    elements.append(Paragraph("Settlement Receipt", title_style))
    elements.append(Spacer(1, 12))
    elements.append(Paragraph(f"<b>Judul:</b> {settlement.title}", styles["Normal"]))
    elements.append(
        Paragraph(f"<b>Deskripsi:</b> {settlement.description}", styles["Normal"])
    )
    elements.append(
        Paragraph(f"<b>Karyawan:</b> {settlement.creator.full_name}", styles["Normal"])
    )
    elements.append(
        Paragraph(
            f"<b>Status:</b> {_display_settlement_status(settlement.status).upper()}",
            styles["Normal"],
        )
    )
    elements.append(
        Paragraph(
            f"<b>Total Pengajuan:</b> Rp {settlement.total_amount:,.0f}",
            styles["Normal"],
        )
    )
    elements.append(
        Paragraph(
            f"<b>Disetujui:</b> Rp {settlement.approved_amount:,.0f}", styles["Normal"]
        )
    )
    elements.append(Spacer(1, 12))
    data = [
        [
            "No",
            "Tanggal",
            "Kategori",
            "Deskripsi",
            "Mata Uang",
            "Amount",
            "Kurs",
            "Ekivalen (IDR)",
            "Status",
        ]
    ]
    for i, exp in enumerate(settlement.expenses, 1):
        data.append(
            [
                str(i),
                exp.date.strftime("%Y-%m-%d"),
                exp.category.name if exp.category else "-",
                exp.description,
                exp.currency or "IDR",
                f"{exp.amount:,.0f}",
                f"{exp.currency_exchange or 1:,.0f}",
                f"{exp.idr_amount or 0:,.0f}",
                exp.status.upper(),
            ]
        )
    t = Table(data, colWidths=[20, 60, 80, 110, 40, 50, 40, 70, 50])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("ALIGN", (5, 0), (7, -1), "RIGHT"),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 8),
                ("BOTTOMPADDING", (0, 0), (-1, 0), 8),
                ("GRID", (0, 0), (-1, -1), 1, colors.black),
            ]
        )
    )
    elements.append(t)
    doc.build(elements)
    buffer.seek(0)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="receipt_{settlement_id}_{timestamp}.pdf"'},
    )

def generate_bulk_settlements_pdf(user, status=None, start_date_str=None, end_date_str=None, report_year=None):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    query = Settlement.query
    if status in ("approved", "completed"):
        query = query.filter(Settlement.status.in_(("approved", "completed")))
    elif status and status != "null":
        query = query.filter_by(status=status)
    if report_year is not None:
        query = (
            query.join(Expense, Expense.settlement_id == Settlement.id)
            .filter(extract("year", Expense.date) == report_year)
            .distinct()
        )
    if start_date_str:
        query = query.filter(
            Settlement.created_at
            >= datetime.strptime(start_date_str, "%Y-%m-%d").date()
        )
    if end_date_str:
        query = query.filter(
            Settlement.created_at <= datetime.strptime(end_date_str, "%Y-%m-%d").date()
        )
    settlements = query.order_by(Settlement.created_at.desc()).all()
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()
    elements.append(Paragraph("Laporan Bulk Settlement", styles["Heading1"]))
    elements.append(Spacer(1, 12))
    data = [["ID", "Judul", "Karyawan", "Status", "Total (Rp)"]]
    for s in settlements:
        data.append(
            [
                str(s.id),
                s.title,
                s.creator.full_name,
                _display_settlement_status(s.status).upper(),
                f"{s.total_amount:,.0f}",
            ]
        )
    t = Table(data, colWidths=[40, 180, 120, 80, 80])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("GRID", (0, 0), (-1, -1), 1, colors.black),
            ]
        )
    )
    elements.append(t)
    doc.build(elements)
    buffer.seek(0)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="bulk_settlement_{timestamp}.pdf"'},
    )

def generate_bulk_advances_pdf(user, start_date_str=None, end_date_str=None):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse(content={"error": "Akses ditolak"}, status_code=403)
    query = Advance.query.filter(Advance.status == "completed")
    if start_date_str:
        query = query.filter(
            Advance.created_at >= datetime.strptime(start_date_str, "%Y-%m-%d").date()
        )
    if end_date_str:
        query = query.filter(
            Advance.created_at <= datetime.strptime(end_date_str, "%Y-%m-%d").date()
        )
    advances = query.order_by(Advance.created_at.desc()).all()
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()
    elements.append(Paragraph("Laporan Bulk Kasbon (Advances)", styles["Heading1"]))
    elements.append(Spacer(1, 12))
    data = [["ID", "Judul", "Pemohon", "Status", "Total (Rp)"]]
    for a in advances:
        data.append(
            [
                str(a.id),
                a.title,
                a.requester.full_name,
                a.status.upper(),
                f"{a.total_amount:,.0f}" if a.total_amount else "0",
            ]
        )
    t = Table(data, colWidths=[40, 180, 120, 80, 80])
    t.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.grey),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("ALIGN", (0, 0), (-1, -1), "LEFT"),
                ("GRID", (0, 0), (-1, -1), 1, colors.black),
            ]
        )
    )
    elements.append(t)
    doc.build(elements)
    buffer.seek(0)
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="bulk_kasbon_{timestamp}.pdf"'},
    )
    return StreamingResponse(
        buffer,
        media_type="application/pdf",
        headers={"Content-Disposition": f'attachment; filename="bulk_kasbon_{timestamp}.pdf"'},
    )

