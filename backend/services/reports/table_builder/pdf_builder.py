import logging
import re
from datetime import datetime
from io import BytesIO
from typing import Dict, List
from models import (
    Category,
    ManualCombineGroup,
)
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter
from reportlab.lib import colors
from reportlab.lib.pagesizes import landscape, letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.platypus import Paragraph, SimpleDocTemplate, Spacer, Table, TableStyle
from services.reports.annual_service.annual_constants import (
    COL_AMOUNT_RECEIVED_IDR,
    COL_AMOUNT_RECEIVED_USD,
    COL_CLIENT,
    COL_CURRENCY,
    COL_EXCHANGE_RATE,
    COL_INVOICE_NUMBER,
    COL_INVOICE_VALUE_IDR,
    COL_INVOICE_VALUE_USD,
    COL_PPH_23,
    COL_PPN,
    COL_RECEIVE_DATE,
    COL_REMARK,
    COL_TAX_CURRENCY,
    COL_TAX_DATE,
    COL_TAX_DPP_PEMASUKAN_NEGARA,
    COL_TAX_DPP_PPH21,
    COL_TAX_DPP_PPH23,
    COL_TAX_DPP_PPH26,
    COL_TAX_DPP_PPN,
    COL_TAX_INV_VALUE_USD,
    COL_TAX_RATE,
    COL_TAX_TRANS_VALUE,
    COL_TAX_TRANS_VALUE_IDR,
    COL_TAX_VALUE_PEMASUKAN_NEGARA,
    COL_TAX_VALUE_PPH21,
    COL_TAX_VALUE_PPH23,
    COL_TAX_VALUE_PPH26,
    COL_TAX_VALUE_PPN,
    COL_TRANSFER_FEE,
)
from services.reports.annual_service.annual_helpers import (
    BLUE_FILL,
    GREEN_FILL,
    REVENUE_START_ROW,
    REVENUE_TEMPLATE_END,
    THIN_BORDER,
    _clear_merged_ranges_in_region,
    _root_category_info,
)
from services.reports.table_builder.expense_renderer_utils import (
    _expense_amount_for_display,
    _group_expenses_by_subcategory,
)

from utils.report_helpers import (
    _as_iso_date,
    _clean_currency,
    _clean_settlement_title,
    _clear_range,
    _clear_range_force,
    _extract_imported_row,
    _get_dynamic_row_height,
    _idr_from_currency,
    _is_batch_settlement,
    _map_expense_category_index_from_name,
    _map_expense_column,
    _parse_iso_date,
    _safe_set_cell,
    _safe_set_number,
    _safe_text,
    _set_date_with_format,
    _set_formula_with_format,
    _set_rows_hidden,
    _shorten,
    _to_float,
)

from .expense_renderer import _render_expense_section_from_data
from .revenue_helpers import _apply_manual_revenue_combine_groups, _apply_manual_tax_combine_groups, _operation_cost_totals_by_column, _get_revenue_bounds, _group_revenues_by_type

def _build_annual_pdf_bytes(payload):
    year = payload.get("year", datetime.now().year)
    revenues = payload.get("revenue", {}).get("data", [])
    taxes = payload.get("tax", {}).get("data", [])
    dividends = payload.get("dividend", {}).get("data", [])
    expenses = payload.get("operation_cost", {}).get("data", [])
    buffer = BytesIO()
    doc = SimpleDocTemplate(
        buffer,
        pagesize=landscape(letter),
        rightMargin=20,
        leftMargin=20,
        topMargin=20,
        bottomMargin=20,
    )
    elements = []
    styles = getSampleStyleSheet()
    title_style = ParagraphStyle(
        "Title", parent=styles["Heading1"], alignment=0, fontSize=14
    )
    year_text = f"Tahun {year}" if year != 0 else "Semua Tahun"
    date_text = f"Januari - Desember {year}" if year != 0 else "Semua Periode"
    elements.append(
        Paragraph(f"Project: REVENUE vs Pengeluaran {year_text}", title_style)
    )
    elements.append(Paragraph(f"Date: {date_text}", styles["Normal"]))
    elements.append(Spacer(1, 15))
    # tabel revenue & tax
    elements.append(Paragraph("REVENUE & TAX", styles["Heading3"]))
    t1_headers = [
        "Invoice Date",
        "#",
        "Detail/Description",
        "INVOICE VALUE",
        "Curr",
        "Rate",
        "INVOICE Num",
        "Client",
        "Receive Date",
        "AMT RECEIVED",
        "PPn",
        "PPH 23",
        "TransferFee",
        "Remark",
    ]

    # Group revenues by type
    grouped_revenues = _group_revenues_by_type(revenues)

    # Check if we have both groups with data
    has_direct = len(grouped_revenues["pendapatan_langsung"]) > 0
    has_other = len(grouped_revenues["pendapatan_lain_lain"]) > 0
    use_grouping = has_direct and has_other  # Only group if BOTH types exist

    t1_data = [t1_headers]
    total_inv_value = 0
    total_received = 0
    total_ppn = 0
    total_pph = 0
    row_idx = 1

    # Set of row IDs that have already contributed their merged values in the PDF totals
    revenue_combine_groups = payload.get("revenue", {}).get("combine_groups", [])
    rev_contributed_groups = set()
    rev_id_to_group_idx = {}
    for idx, group in enumerate(revenue_combine_groups):
        for r_id in group.get("row_ids", []):
            rev_id_to_group_idx[int(r_id)] = idx

    if use_grouping:
        # Render with grouping (both types exist)
        for group_name, group_revenues in grouped_revenues.items():
            if not group_revenues:
                continue

            # Add group header row
            t1_data.append(
                [
                    f"=== {group_name.upper().replace('_', ' ')} ===",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                    "",
                ]
            )

            # Add revenue items for this group
            group_total_inv = 0.0
            group_total_rec = 0.0
            group_total_ppn = 0.0
            group_total_pph = 0.0
            for idx, r in enumerate(group_revenues, 1):
                inv_val = _idr_from_currency(
                    r.get("invoice_value"),
                    r.get("currency"),
                    r.get("currency_exchange"),
                )
                amt_rec = _idr_from_currency(
                    r.get("amount_received"),
                    r.get("currency"),
                    r.get("currency_exchange"),
                )
                ppn = _to_float(r.get("ppn"))
                pph23 = _to_float(r.get("pph_23"))
                transfer = _to_float(r.get("transfer_fee"))

                r_id = r.get("id")

                # Column-specific duplicate detection
                is_inv_val_dup = False
                is_amt_rec_dup = False
                is_ppn_dup = False
                is_pph_dup = False

                if r_id is not None and int(r_id) in rev_id_to_group_idx:
                    g_idx = rev_id_to_group_idx[int(r_id)]
                    group_meta = revenue_combine_groups[g_idx]
                    merged_cols = group_meta.get("merged_columns", [])

                    # If it's NOT the first row in the group, we check if columns are merged
                    # Note: We rely on the order in group_revenues matching the group order
                    group_row_ids = [int(rid) for rid in group_meta.get("row_ids", [])]
                    if int(r_id) != group_row_ids[0]:
                        if "invoice_value" in merged_cols:
                            is_inv_val_dup = True
                        if "amount_received" in merged_cols:
                            is_amt_rec_dup = True
                        if "ppn" in merged_cols:
                            is_ppn_dup = True
                        if "pph_23" in merged_cols:
                            is_pph_dup = True

                if not is_inv_val_dup:
                    total_inv_value += inv_val
                group_total_inv += inv_val
                if not is_amt_rec_dup:
                    total_received += amt_rec
                group_total_rec += amt_rec
                if not is_ppn_dup:
                    total_ppn += ppn
                group_total_ppn += ppn
                if not is_pph_dup:
                    total_pph += pph23
                group_total_pph += pph23

                t1_data.append(
                    [
                        _as_iso_date(r.get("invoice_date")),
                        str(row_idx),
                        _shorten(r.get("description"), 30),
                        f"{inv_val:,.0f}" if inv_val else "-",
                        _clean_currency(r.get("currency")),
                        f"{_to_float(r.get('currency_exchange'), 1):,.0f}"
                        if r.get("currency_exchange")
                        else "-",
                        _safe_text(r.get("invoice_number")),
                        _safe_text(r.get("client")),
                        _as_iso_date(r.get("receive_date")),
                        f"{amt_rec:,.0f}" if amt_rec else "-",
                        f"{ppn:,.0f}" if ppn else "-",
                        f"{pph23:,.0f}" if pph23 else "-",
                        f"{transfer:,.0f}" if transfer else "-",
                        _safe_text(r.get("remark")),
                    ]
                )
                row_idx += 1

            # Add subtotal row for this group
            t1_data.append(
                [
                    f"Subtotal {group_name.replace('_', ' ').title()}",
                    "",
                    "",
                    f"{group_total_inv:,.0f}",
                    "",
                    "",
                    "",
                    "",
                    "",
                    f"{group_total_rec:,.0f}",
                    f"{group_total_ppn:,.0f}",
                    f"{group_total_pph:,.0f}",
                    "",
                    "",
                ]
            )

            # Add blank row between groups
            if (
                group_name == "pendapatan_langsung"
                and grouped_revenues["pendapatan_lain_lain"]
            ):
                t1_data.append(["", "", "", "", "", "", "", "", "", "", "", "", "", ""])
    else:
        # Render WITHOUT grouping (only one type exists) - use original flat structure
        for idx, r in enumerate(revenues, 1):
            inv_val = _idr_from_currency(
                r.get("invoice_value"), r.get("currency"), r.get("currency_exchange")
            )
            amt_rec = _idr_from_currency(
                r.get("amount_received"), r.get("currency"), r.get("currency_exchange")
            )
            ppn = _to_float(r.get("ppn"))
            pph23 = _to_float(r.get("pph_23"))
            transfer = _to_float(r.get("transfer_fee"))

            r_id = r.get("id")

            is_inv_val_dup = False
            is_amt_rec_dup = False
            is_ppn_dup = False
            is_pph_dup = False

            if r_id is not None and int(r_id) in rev_id_to_group_idx:
                g_idx = rev_id_to_group_idx[int(r_id)]
                group_meta = revenue_combine_groups[g_idx]
                merged_cols = group_meta.get("merged_columns", [])
                group_row_ids = [int(rid) for rid in group_meta.get("row_ids", [])]
                if int(r_id) != group_row_ids[0]:
                    if "invoice_value" in merged_cols:
                        is_inv_val_dup = True
                    if "amount_received" in merged_cols:
                        is_amt_rec_dup = True
                    if "ppn" in merged_cols:
                        is_ppn_dup = True
                    if "pph_23" in merged_cols:
                        is_pph_dup = True

            if not is_inv_val_dup:
                total_inv_value += inv_val
                group_total_inv += inv_val
            if not is_amt_rec_dup:
                total_received += amt_rec
                group_total_rec += amt_rec
            if not is_ppn_dup:
                total_ppn += ppn
                group_total_ppn += ppn
            if not is_pph_dup:
                total_pph += pph23
                group_total_pph += pph23

            t1_data.append(
                [
                    _as_iso_date(r.get("invoice_date")),
                    str(idx),
                    _shorten(r.get("description"), 30),
                    f"{inv_val:,.0f}" if inv_val else "-",
                    _clean_currency(r.get("currency")),
                    f"{_to_float(r.get('currency_exchange'), 1):,.0f}"
                    if r.get("currency_exchange")
                    else "-",
                    _safe_text(r.get("invoice_number")),
                    _safe_text(r.get("client")),
                    _as_iso_date(r.get("receive_date")),
                    f"{amt_rec:,.0f}" if amt_rec else "-",
                    f"{ppn:,.0f}" if ppn else "-",
                    f"{pph23:,.0f}" if pph23 else "-",
                    f"{transfer:,.0f}" if transfer else "-",
                    _safe_text(r.get("remark")),
                ]
            )

    # Add grand total row
    t1_headers = [
        "Invoice Date",
        "#",
        "Detail/Description",
        "INVOICE VALUE(child=USD)",
        "INVOICE VALUE(child=IDR)",
        "Currency",
        "Currency Exchange",
        "INVOICE Number",
        "Client",
        "Receive Date",
        "AMOUNT RECEIVED(child=IDR)",
        "AMOUNT RECEIVED(child=USD)",
        "PPn(child=11%)",
        "PPH (Pasal 23)(child=2%)",
        "Biaya transfer",
        "Remark",
    ]

    t1_data = [t1_headers]
    sum_inv_usd = 0
    sum_inv_idr = 0
    sum_recv_usd = 0
    sum_recv_idr = 0
    sum_ppn = 0
    sum_pph23 = 0

    revenue_combine_groups = payload.get("revenue", {}).get("combine_groups", [])
    rev_contributed_groups = set()
    rev_id_to_group_idx = {}
    for idx, group in enumerate(revenue_combine_groups):
        for r_id in group.get("row_ids", []):
            rev_id_to_group_idx[int(r_id)] = idx

    for idx, r in enumerate(revenues, 1):
        inv_usd = _to_float(r.get("invoice_value_usd"))
        inv_idr = _to_float(r.get("invoice_value_idr"))
        recv_usd = _to_float(r.get("amount_received_usd"))
        recv_idr = _to_float(r.get("amount_received_idr"))
        ppn = _to_float(r.get("ppn"))
        pph23 = _to_float(r.get("pph_23"))

        r_id = r.get("id")
        is_duplicate = False
        if r_id is not None and int(r_id) in rev_id_to_group_idx:
            g_idx = rev_id_to_group_idx[int(r_id)]
            if g_idx in rev_contributed_groups:
                is_duplicate = True
            else:
                rev_contributed_groups.add(g_idx)

        if not is_duplicate:
            sum_inv_usd += inv_usd
            sum_inv_idr += inv_idr
            sum_recv_usd += recv_usd
            sum_recv_idr += recv_idr
            sum_ppn += ppn
            sum_pph23 += pph23

        t1_data.append(
            [
                _as_iso_date(r.get("invoice_date")),
                str(idx),
                _shorten(r.get("description"), 25),
                f"{inv_usd:,.0f}" if inv_usd else "-",
                f"{inv_idr:,.0f}" if inv_idr else "-",
                _clean_currency(r.get("currency")),
                f"{_to_float(r.get('currency_exchange'), 1):,.0f}"
                if r.get("currency_exchange")
                else "-",
                r.get("invoice_number") or "-",
                r.get("client") or "-",
                _as_iso_date(r.get("receive_date")),
                f"{recv_idr:,.0f}" if recv_idr else "-",
                f"{recv_usd:,.0f}" if recv_usd else "-",
                f"{ppn:,.0f}" if ppn else "-",
                f"{pph23:,.0f}" if pph23 else "-",
                f"{_to_float(r.get('transfer_fee')):,.0f}"
                if r.get("transfer_fee")
                else "-",
                _shorten(r.get("remark"), 15),
            ]
        )
    # Add grand total row
    t1_data.append(
        [
            "TOTAL",
            "-",
            "-",
            f"{sum_inv_usd:,.0f}",
            f"{sum_inv_idr:,.0f}",
            "-",
            "-",
            "-",
            "-",
            "-",
            f"{sum_recv_idr:,.0f}",
            f"{sum_recv_usd:,.0f}",
            f"{sum_ppn:,.0f}",
            f"{sum_pph23:,.0f}",
            "-",
            "-",
        ]
    )
    # 16 columns for Table 1
    t1_widths = [45, 15, 80, 45, 45, 25, 30, 45, 45, 45, 45, 45, 45, 45, 40, 45]
    t1 = Table(t1_data, colWidths=t1_widths, repeatRows=1)
    t1.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#2E7D32")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 7),
                ("ALIGN", (3, 1), (5, -1), "RIGHT"),
                ("ALIGN", (9, 1), (12, -1), "RIGHT"),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#E8F5E9")),
                ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
            ]
        )
    )
    elements.append(t1)
    elements.append(Spacer(1, 15))
    # tabel tax
    elements.append(Paragraph("PAJAK PENGELUARAN", styles["Heading3"]))
    t2_headers = [
        "Date",
        "#",
        "Detail/Description",
        "INVOICE VALUE(child=USD)",
        "Transaction Value",
        "Currency",
        "Rate",
        "Transaction Value",
        "PPN(child=Transaction)",
        "PPN(child=PPN)",
        "PPh (pasal 21)(child=Transaction)",
        "PPh (child=PPh - 21)",
        "PPh (pasal 23)(child=Transaction)",
        "PPh (child=PPh - 23)",
        "PPh (pasal 26)(child=Transaction)",
        "PPh (child=PPh - 26)",
        "Pemasukan Negara (pasal ???)(child=Transaction)",
        "Pemasukan Negara (child=Pajak)",
    ]

    t2_data = [t2_headers]
    sum_ppn = 0
    sum_pph21 = 0
    sum_pph23 = 0
    sum_pph26 = 0
    sum_ppemasukan = 0
    sum_ppn_base = 0
    sum_pph21_base = 0
    sum_pph23_base = 0
    sum_pph26_base = 0
    sum_ppemasukan_base = 0
    sum_trans_val_idr = 0

    tax_combine_groups = payload.get("tax", {}).get("combine_groups", [])
    tax_id_to_group_idx = {}
    for idx, group in enumerate(tax_combine_groups):
        for r_id in group.get("row_ids", []):
            tax_id_to_group_idx[int(r_id)] = idx

    for idx, t in enumerate(taxes, 1):
        ppn = _to_float(t.get("ppn"))
        pph21 = _to_float(t.get("pph_21"))
        pph23 = _to_float(t.get("pph_23"))
        pph26 = _to_float(t.get("pph_26"))
        pem_negara = _to_float(t.get("pemasukan_negara"))

        ppn_base = _to_float(t.get("ppn_base"))
        pph21_base = _to_float(t.get("pph_21_base"))
        pph23_base = _to_float(t.get("pph_23_base"))
        pph26_base = _to_float(t.get("pph_26_base"))
        pem_negara_base = _to_float(t.get("pemasukan_negara_base"))

        raw_trans_val = _to_float(t.get("transaction_value"))
        inv_val_usd = _to_float(t.get("invoice_value_usd"))
        trans_val_idr = _idr_from_currency(
            t.get("transaction_value"), t.get("currency"), t.get("currency_exchange")
        )

        t_id = t.get("id")

        is_trans_val_dup = False
        is_ppn_dup = False
        is_pph21_dup = False
        is_pph23_dup = False
        is_pph26_dup = False
        is_pem_dup = False

        if t_id is not None and int(t_id) in tax_id_to_group_idx:
            g_idx = tax_id_to_group_idx[int(t_id)]
            group_meta = tax_combine_groups[g_idx]
            merged_cols = group_meta.get("merged_columns", [])
            group_row_ids = [int(rid) for rid in group_meta.get("row_ids", [])]
            if int(t_id) != group_row_ids[0]:
                if "transaction_value" in merged_cols:
                    is_trans_val_dup = True
                if "ppn" in merged_cols:
                    is_ppn_dup = True
                if "pph_21" in merged_cols:
                    is_pph21_dup = True
                if "pph_23" in merged_cols:
                    is_pph23_dup = True
                if "pph_26" in merged_cols:
                    is_pph26_dup = True
                if "pemasukan_negara" in merged_cols:
                    is_pem_dup = True

        if not is_trans_val_dup:
            sum_trans_val_idr += trans_val_idr

        if not is_ppn_dup:
            sum_ppn += ppn
            sum_ppn_base += ppn_base
        if not is_pph21_dup:
            sum_pph21 += pph21
            sum_pph21_base += pph21_base
        if not is_pph23_dup:
            sum_pph23 += pph23
            sum_pph23_base += pph23_base
        if not is_pph26_dup:
            sum_pph26 += pph26
            sum_pph26_base += pph26_base
        if not is_pem_dup:
            sum_ppemasukan += pem_negara
            sum_ppemasukan_base += pem_negara_base

        t2_data.append(
            [
                _as_iso_date(t.get("date")),
                str(idx),
                _shorten(t.get("description"), 25),
                f"{inv_val_usd:,.0f}" if inv_val_usd else "-",
                f"{raw_trans_val:,.0f}" if raw_trans_val else "-",
                _clean_currency(t.get("currency")),
                f"{_to_float(t.get('currency_exchange'), 1):,.0f}"
                if t.get("currency_exchange")
                else "-",
                f"{trans_val_idr:,.0f}"
                if (trans_val_idr and t.get("currency") != "IDR")
                else "-",
                f"{ppn_base:,.0f}" if ppn_base else "-",
                f"{ppn:,.0f}" if ppn else "-",
                f"{pph21_base:,.0f}" if pph21_base else "-",
                f"{pph21:,.0f}" if pph21 else "-",
                f"{pph23_base:,.0f}" if pph23_base else "-",
                f"{pph23:,.0f}" if pph23 else "-",
                f"{pph26_base:,.0f}" if pph26_base else "-",
                f"{pph26:,.0f}" if pph26 else "-",
                f"{pem_negara_base:,.0f}" if pem_negara_base else "-",
                f"{pem_negara:,.0f}" if pem_negara else "-",
            ]
        )
    t2_data.append(
        [
            "TOTAL",
            "-",
            "-",
            "-",
            "-",
            "-",
            "-",
            f"{sum_trans_val_idr:,.0f}",
            f"{sum_ppn_base:,.0f}" if sum_ppn_base else "-",
            f"{sum_ppn:,.0f}" if sum_ppn else "-",
            f"{sum_pph21_base:,.0f}" if sum_pph21_base else "-",
            f"{sum_pph21:,.0f}" if sum_pph21 else "-",
            f"{sum_pph23_base:,.0f}" if sum_pph23_base else "-",
            f"{sum_pph23:,.0f}" if sum_pph23 else "-",
            f"{sum_pph26_base:,.0f}" if sum_pph26_base else "-",
            f"{sum_pph26:,.0f}" if sum_pph26 else "-",
            f"{sum_ppemasukan_base:,.0f}" if sum_ppemasukan_base else "-",
            f"{sum_ppemasukan:,.0f}" if sum_ppemasukan else "-",
        ]
    )
    # 18 columns for Table 2
    t2_widths = [45, 15, 80, 45, 45, 25, 30, 45, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40]
    t2 = Table(t2_data, colWidths=t2_widths, repeatRows=1)
    t2.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#D84315")),
                ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("FONTSIZE", (0, 0), (-1, -1), 7),
                ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#FBE9E7")),
                ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
            ]
        )
    )
    elements.append(t2)
    elements.append(Spacer(1, 15))

    # ? TABLE 3A: BANK ADMIN (DETAIL ITEM)
    admin_fees_root = payload.get("admin_fees", {})
    all_admin_fees_data = admin_fees_root.get("data", [])
    admin_fees_detail = [
        f for f in all_admin_fees_data if not f.get("is_admin_fee_extra")
    ]

    if admin_fees_detail:
        elements.append(
            Paragraph("Tabel 3A: Bank Admin (Detail Item)", styles["Heading3"])
        )
        t3a_headers = [
            "Date",
            "#",
            "Activity",
            "Source",
            "Amount",
            "Cur",
            "Rate",
            "Type",
        ]
        t3a_data = [t3a_headers]
        total_admin_val = 0
        for idx, fee in enumerate(admin_fees_detail, 1):
            admin_val = _to_float(fee.get("idr_amount") or fee.get("amount"))
            total_admin_val += admin_val
            t3a_data.append(
                [
                    _as_iso_date(fee.get("date")),
                    str(idx),
                    _shorten(fee.get("description"), 40),
                    fee.get("bank_name") or "-",
                    f"{admin_val:,.0f}",
                    _clean_currency(fee.get("currency")),
                    f"{_to_float(fee.get('exchange_rate'), 1):,.0f}",
                    (fee.get("settlement_type") or "single").upper(),
                ]
            )
        t3a_data.append(
            ["TOTAL BIAYA ADMIN", "", "", "", f"{total_admin_val:,.0f}", "", "", ""]
        )
        t3a = Table(t3a_data, colWidths=[60, 20, 180, 80, 70, 30, 45, 60])
        t3a.setStyle(
            TableStyle(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#1976D2")),
                    ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                    ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                    ("FONTSIZE", (0, 0), (-1, -1), 7),
                    ("ALIGN", (4, 1), (4, -1), "RIGHT"),
                    ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                    ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#E3F2FD")),
                    ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ]
            )
        )
        elements.append(t3a)
        elements.append(Spacer(1, 15))

    # ? TABLE 3B: BANK ADMIN (PENGIRIMAN DANA)
    admin_fees_direct = [f for f in all_admin_fees_data if f.get("is_admin_fee_extra")]
    if admin_fees_direct:
        elements.append(
            Paragraph("Tabel 3B: Bank Admin (Pengiriman Dana)", styles["Heading3"])
        )
        t3b_headers = [
            "Date",
            "#",
            "Activity",
            "Source",
            "Amount",
            "Cur",
            "Rate",
            "Type",
        ]
        t3b_data = [t3b_headers]
        total_admin_val = 0
        for idx, fee in enumerate(admin_fees_direct, 1):
            admin_val = _to_float(fee.get("idr_amount") or fee.get("amount"))
            total_admin_val += admin_val
            t3b_data.append(
                [
                    _as_iso_date(fee.get("date")),
                    str(idx),
                    _shorten(fee.get("description"), 40),
                    fee.get("bank_name") or "-",
                    f"{admin_val:,.0f}",
                    _clean_currency(fee.get("currency")),
                    f"{_to_float(fee.get('exchange_rate'), 1):,.0f}",
                    (fee.get("settlement_type") or "single").upper(),
                ]
            )
        t3b_data.append(
            ["TOTAL BIAYA ADMIN", "", "", "", f"{total_admin_val:,.0f}", "", "", ""]
        )
        t3b = Table(t3b_data, colWidths=[60, 20, 180, 80, 70, 30, 45, 60])
        t3b.setStyle(
            TableStyle(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#1976D2")),
                    ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                    ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                    ("FONTSIZE", (0, 0), (-1, -1), 7),
                    ("ALIGN", (4, 1), (4, -1), "RIGHT"),
                    ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                    ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#E3F2FD")),
                    ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ]
            )
        )
        elements.append(t3b)
        elements.append(Spacer(1, 15))

    # ? TABLE 3C: PENGEMBALIAN DANA (RETURNS)
    returned_funds_root = payload.get("returned_funds", {})
    returned_funds_data = returned_funds_root.get("data", [])
    if returned_funds_data:
        elements.append(
            Paragraph("Tabel 3C: Pengembalian Dana (Returns)", styles["Heading3"])
        )
        t3c_headers = [
            "Date",
            "#",
            "Activity",
            "Source",
            "Approved",
            "Disbursed",
            "Returned",
            "Type",
        ]
        t3c_data = [t3c_headers]
        total_ret = 0
        for idx, item in enumerate(returned_funds_data, 1):
            ret_val = _to_float(item.get("returned_amount"))
            total_ret += ret_val
            t3c_data.append(
                [
                    _as_iso_date(item.get("date")),
                    str(idx),
                    _shorten(item.get("title"), 40),
                    item.get("bank_name") or "-",
                    f"{_to_float(item.get('approved_amount')):,.0f}",
                    f"{_to_float(item.get('disbursed_amount')):,.0f}",
                    f"{ret_val:,.0f}",
                    (item.get("type") or "SINGLE").upper(),
                ]
            )
        t3c_data.append(["TOTAL", "", "", "", "", "", f"{total_ret:,.0f}", ""])
        t3c = Table(t3c_data, colWidths=[60, 20, 150, 80, 70, 70, 70, 50])
        t3c.setStyle(
            TableStyle(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#FF9800")),
                    ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                    ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                    ("FONTSIZE", (0, 0), (-1, -1), 7),
                    ("ALIGN", (4, 1), (6, -1), "RIGHT"),
                    ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                    ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#FFF3E0")),
                    ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ]
            )
        )
        elements.append(t3c)
        elements.append(Spacer(1, 15))

    if dividends:
        elements.append(Paragraph("DIVIDEN", styles["Heading3"]))
        t_div_headers = [
            "Date",
            "#",
            "Nama Penerima",
            "Profit Ditahan",
            "Dividen Dibagi",
            "Dibagi/Orang",
        ]
        t_div_data = [t_div_headers]
        total_dividend = _to_float(payload.get("dividend", {}).get("total_amount"))
        profit_retained = _to_float(payload.get("dividend", {}).get("profit_retained"))
        dividend_per_person = _to_float(
            payload.get("dividend", {}).get("dividend_per_person")
        )
        for idx, item in enumerate(dividends, 1):
            t_div_data.append(
                [
                    _as_iso_date(item.get("date")),
                    str(idx),
                    _safe_text(item.get("name")),
                    f"{profit_retained:,.0f}" if profit_retained else "-",
                    f"{total_dividend:,.0f}" if total_dividend else "-",
                    f"{dividend_per_person:,.0f}" if dividend_per_person else "-",
                ]
            )
        t_div_data.append(
            [
                "TOTAL",
                "",
                "",
                f"{profit_retained:,.0f}" if profit_retained else "-",
                f"{total_dividend:,.0f}" if total_dividend else "-",
                f"{dividend_per_person:,.0f}" if dividend_per_person else "-",
            ]
        )
        t_div = Table(t_div_data, colWidths=[60, 20, 180, 90, 90, 90])
        t_div.setStyle(
            TableStyle(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#6A1B9A")),
                    ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
                    ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                    ("FONTSIZE", (0, 0), (-1, -1), 7),
                    ("ALIGN", (3, 1), (-1, -1), "RIGHT"),
                    ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                    ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#F3E5F5")),
                    ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
                ]
            )
        )
        elements.append(t_div)
        elements.append(Spacer(1, 15))
    # tabel expense
    elements.append(Paragraph("PENGELUARAN & OPERATION COST", styles["Heading3"]))

    # ? Pre-calculate totals per root category to filter zero ones
    all_cats_sync = Category.query.all()
    cat_map = {c.id: c for c in all_cats_sync}
    root_totals = {}
    for e in expenses:
        nominal = _expense_amount_for_display(e)
        r_name, _ = _root_category_info(e.get("category_id"), cat_map)
        if r_name:
            root_totals[r_name] = root_totals.get(r_name, 0.0) + nominal

    root_cats_all = (
        Category.query.filter_by(parent_id=None)
        .order_by(Category.sort_order, Category.id)
        .all()
    )
    root_cats = [c for c in root_cats_all if root_totals.get(c.name, 0.0) > 0]
    if not root_cats and root_cats_all:
        root_cats = [root_cats_all[0]]

    cat_names = [c.name for c in root_cats]

    t3_headers = [
        "Date",
        "#",
        "Activity (Desc)",
        "Source",
        "Amount",
        "Curr",
        "Rate",
    ] + [c[:10] + "." for c in cat_names]
    t3_data = [t3_headers]
    cat_totals = [0] * len(cat_names)
    grand_total = 0

    # Separate single vs batch
    single_expenses = [
        e
        for e in expenses
        if not _is_batch_settlement(e.get("settlement_type"), e.get("settlement_title"))
    ]
    batch_expenses = [
        e
        for e in expenses
        if _is_batch_settlement(e.get("settlement_type"), e.get("settlement_title"))
    ]

    # Render Single
    if single_expenses:
        single_grouped = _group_expenses_by_subcategory(single_expenses)
        row_idx = 1
        for subcat, items in single_grouped["groups"].items():
            # Subcat header
            t3_data.append(["", "", subcat, "", "", "", ""] + [""] * len(cat_names))
            for e in items:
                nominal_idr = _expense_amount_for_display(e)
                raw_amount = _to_float(e.get("amount"))
                col_idx = _map_expense_column(e.get("category_name"), cat_names)
                row_cats = ["-"] * len(cat_names)
                row_cats[col_idx] = f"{nominal_idr:,.0f}" if nominal_idr else "-"
                cat_totals[col_idx] += nominal_idr
                grand_total += nominal_idr
                t3_data.append(
                    [
                        _as_iso_date(e.get("date")),
                        str(row_idx),
                        _shorten(e.get("description"), 30),
                        _shorten(e.get("source"), 10),
                        f"{raw_amount:,.0f}" if raw_amount else "-",
                        _clean_currency(e.get("currency")),
                        f"{_to_float(e.get('currency_exchange'), 1):,.0f}"
                        if e.get("currency_exchange")
                        else "-",
                    ]
                    + row_cats
                )
                row_idx += 1

    # Render Batch
    batch_by_settlement = {}
    for e in batch_expenses:
        key = f"{e.get('settlement_id')}:{e.get('settlement_title')}"
        batch_by_settlement.setdefault(key, []).append(e)

    sorted_keys = sorted(
        batch_by_settlement.keys(),
        key=lambda x: int(x.split(":")[0]) if x.split(":")[0].isdigit() else 0,
    )

    batch_counter = 0
    for key in sorted_keys:
        batch_counter += 1
        items = batch_by_settlement[key]
        title = _clean_settlement_title(
            items[0].get("settlement_title") or "Tanpa Settlement"
        )

        # Batch header (Expense#N) - Use Dark Navy Blue for "biru keiteman"
        t3_data.append(
            [f"Expense#{batch_counter}", ":", title, "", "", "", ""]
            + [""] * len(cat_names)
        )

        batch_grouped = _group_expenses_by_subcategory(items)
        row_idx = 1
        for subcat, sub_items in batch_grouped["groups"].items():
            t3_data.append(["", "", subcat, "", "", "", ""] + [""] * len(cat_names))
            for e in sub_items:
                nominal_idr = _expense_amount_for_display(e)
                raw_amount = _to_float(e.get("amount"))
                col_idx = _map_expense_column(e.get("category_name"), cat_names)
                row_cats = ["-"] * len(cat_names)
                row_cats[col_idx] = f"{nominal_idr:,.0f}" if nominal_idr else "-"
                cat_totals[col_idx] += nominal_idr
                grand_total += nominal_idr
                t3_data.append(
                    [
                        _as_iso_date(e.get("date")),
                        str(row_idx),
                        _shorten(e.get("description"), 30),
                        _shorten(e.get("source"), 10),
                        f"{raw_amount:,.0f}" if raw_amount else "-",
                        _clean_currency(e.get("currency")),
                        f"{_to_float(e.get('currency_exchange'), 1):,.0f}"
                        if e.get("currency_exchange")
                        else "-",
                    ]
                    + row_cats
                )
                row_idx += 1

    t3_data.append(
        ["TOTAL PENGELUARAN", "", "", "", "-", "", ""]
        + [f"{t:,.0f}" if t > 0 else "-" for t in cat_totals]
    )
    cw = [55, 20, 110, 50, 60, 25, 25] + [45] * len(cat_names)
    t3 = Table(t3_data, colWidths=cw)

    # Custom styling to apply different background for Expense# headers
    t3_style = [
        ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#0D47A1")),
        ("TEXTCOLOR", (0, 0), (-1, 0), colors.whitesmoke),
        ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
        ("FONTSIZE", (0, 0), (-1, -1), 6),
        ("ALIGN", (4, 1), (-1, -1), "RIGHT"),
        ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
        ("BACKGROUND", (0, -1), (-1, -1), colors.HexColor("#E3F2FD")),
        ("FONTNAME", (0, -1), (-1, -1), "Helvetica-Bold"),
    ]

    # Loop data to find 'Expense#' rows and subcategory headers to apply styling
    for i, row in enumerate(t3_data):
        if i == 0:
            continue  # Skip main header
        if str(row[0]).startswith("Expense#"):
            t3_style.append(
                ("BACKGROUND", (0, i), (-1, i), colors.HexColor("#0D47A1"))
            )  # Dark Navy Blue
            t3_style.append(("TEXTCOLOR", (0, i), (-1, i), colors.whitesmoke))
            t3_style.append(("FONTNAME", (0, i), (-1, i), "Helvetica-Bold"))
        elif (
            row[2] and not row[0] and not row[1] and i < len(t3_data) - 1
        ):  # Subcat header
            t3_style.append(("FONTNAME", (2, i), (2, i), "Helvetica-Bold"))
    t3.setStyle(TableStyle(t3_style))
    elements.append(t3)
    elements.append(Spacer(1, 14))
    elements.append(
        Paragraph(
            "AREA DISPLAY / IMPORT (Kosong - diisi saat refresh)", styles["Heading3"]
        )
    )
    area_data = [["No", "Keterangan", "Nilai"]]
    for idx in range(1, 6):
        area_data.append([str(idx), "", ""])
    area_table = Table(area_data, colWidths=[30, 410, 180], rowHeights=[18] + [24] * 5)
    area_table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#ECEFF1")),
                ("FONTNAME", (0, 0), (-1, 0), "Helvetica-Bold"),
                ("GRID", (0, 0), (-1, -1), 0.5, colors.grey),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
            ]
        )
    )
    elements.append(area_table)
    doc.build(elements)
    buffer.seek(0)
    return buffer.read()

