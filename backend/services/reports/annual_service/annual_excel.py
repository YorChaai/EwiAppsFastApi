# annual laporan endpoints dan helpers (pdf, excel)

import logging
import os
from copy import copy
from datetime import date, datetime

from config import BASE_DIR
from models import (
    Category,
    CategoryGroup,
    db,
)
from openpyxl import load_workbook
from openpyxl.cell.cell import MergedCell
from openpyxl.drawing.image import Image as OpenpyxlImage
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

from .annual_constants import COL_INVOICE_VALUE_IDR, COL_PPH_23
from .annual_helpers import (
    MIN_WIDTHS,
    REVENUE_START_ROW,
    ROW_HEIGHT_DIVIDEND,
    _clear_merged_ranges_in_region,
    _root_category_info,
    _set_dividend_row_border,
)
from utils.report_helpers import (
    _clear_range_force,
    _idr_from_currency,
    _parse_iso_date,
    _safe_set_cell_with_merge,
    _to_float,
)

# Setup logging
logger = logging.getLogger(__name__)


def _clone_row_format(ws, source_row, target_row, start_col=1, end_col=17):
    ws.row_dimensions[target_row].height = ws.row_dimensions[source_row].height
    for col in range(start_col, end_col + 1):
        source_cell = ws.cell(row=source_row, column=col)
        target_cell = ws.cell(row=target_row, column=col)
        if isinstance(source_cell, MergedCell) or isinstance(target_cell, MergedCell):
            continue
        target_cell._style = copy(source_cell._style)
        target_cell.number_format = source_cell.number_format


def _replace_text_in_sheet(ws, search_text, replace_text):
    """
    Search and replace text in all cells of a worksheet.
    Used for updating headers like 'TAHUN 2024' -> 'TAHUN 2030'.
    """
    for row in ws.iter_rows():
        for cell in row:
            if cell.value and isinstance(cell.value, str):
                if search_text in cell.value:
                    cell.value = cell.value.replace(search_text, replace_text)


def _copy_template_row(
    ws, source_row, target_row, start_col=2, end_col=20, include_values=True
):
    if source_row == target_row:
        return

    _clear_merged_ranges_in_region(ws, target_row, target_row, start_col, end_col)
    ws.row_dimensions[target_row].height = ws.row_dimensions[source_row].height

    for col in range(start_col, end_col + 1):
        target_cell = ws.cell(row=target_row, column=col)
        if isinstance(target_cell, MergedCell):
            continue
        target_cell.value = None

    for col in range(start_col, end_col + 1):
        source_cell = ws.cell(row=source_row, column=col)
        target_cell = ws.cell(row=target_row, column=col)
        if isinstance(source_cell, MergedCell) or isinstance(target_cell, MergedCell):
            continue
        target_cell._style = copy(source_cell._style)
        target_cell.number_format = source_cell.number_format
        target_cell.font = copy(source_cell.font)
        target_cell.fill = copy(source_cell.fill)
        target_cell.border = copy(source_cell.border)
        target_cell.alignment = copy(source_cell.alignment)
        target_cell.protection = copy(source_cell.protection)
        target_cell.value = copy(source_cell.value) if include_values else None

    for merged_range in list(ws.merged_cells.ranges):
        min_col, min_row, max_col, max_row = merged_range.bounds
        if min_row != source_row or max_row != source_row:
            continue
        if min_col < start_col or max_col > end_col:
            continue
        try:
            ws.merge_cells(
                start_row=target_row,
                start_column=min_col,
                end_row=target_row,
                end_column=max_col,
            )
        except Exception:
            pass


def _copy_template_row_from_backup(
    ws_backup,
    ws_target,
    source_row,
    target_row,
    start_col=2,
    end_col=17,
    include_values=True,
):
    """Copy a template row from backup sheet to target sheet.
    Used when revenue data may have overwritten the original template rows (23-41)."""
    if ws_backup is None:
        # Fallback to same-sheet copy if no backup exists
        _copy_template_row(
            ws_target, source_row, target_row, start_col, end_col, include_values
        )
        return

    _clear_merged_ranges_in_region(
        ws_target, target_row, target_row, start_col, end_col
    )
    ws_target.row_dimensions[target_row].height = ws_backup.row_dimensions[
        source_row
    ].height

    for col in range(start_col, end_col + 1):
        target_cell = ws_target.cell(row=target_row, column=col)
        if isinstance(target_cell, MergedCell):
            continue
        target_cell.value = None

    for col in range(start_col, end_col + 1):
        source_cell = ws_backup.cell(row=source_row, column=col)
        target_cell = ws_target.cell(row=target_row, column=col)
        if isinstance(source_cell, MergedCell) or isinstance(target_cell, MergedCell):
            continue
        target_cell._style = copy(source_cell._style)
        target_cell.number_format = source_cell.number_format
        target_cell.font = copy(source_cell.font)
        target_cell.fill = copy(source_cell.fill)
        target_cell.border = copy(source_cell.border)
        target_cell.alignment = copy(source_cell.alignment)
        target_cell.protection = copy(source_cell.protection)
        target_cell.value = copy(source_cell.value) if include_values else None

    for merged_range in list(ws_backup.merged_cells.ranges):
        min_col, min_row, max_col, max_row = merged_range.bounds
        if min_row != source_row or max_row != source_row:
            continue
        if min_col < start_col or max_col > end_col:
            continue
        try:
            ws_target.merge_cells(
                start_row=target_row,
                start_column=min_col,
                end_row=target_row,
                end_column=max_col,
            )
        except Exception:
            pass


def _sum_sheet_column_formula(sheet_ref, column_letter, start_row, end_row):
    return f"=SUM({sheet_ref}!{column_letter}{start_row}:{column_letter}{end_row})"


def _safe_merge_cells_sheet(ws, start_row, start_col, end_row, end_col):
    """Merge range safely by unmerging any overlapping merged ranges first."""
    sr, er = sorted([int(start_row), int(end_row)])
    sc, ec = sorted([int(start_col), int(end_col)])

    overlaps = []
    for mr in list(ws.merged_cells.ranges):
        min_col, min_row, max_col, max_row = mr.bounds
        is_overlap = not (max_row < sr or min_row > er or max_col < sc or min_col > ec)
        if is_overlap:
            overlaps.append(str(mr))

    for rg in overlaps:
        try:
            ws.unmerge_cells(rg)
        except Exception:
            pass

    try:
        ws.merge_cells(
            start_row=sr,
            start_column=sc,
            end_row=er,
            end_column=ec,
        )
    except Exception:
        pass


def _add_image_to_sheet(ws, img_path, anchor, width=None, height=None):
    """Safely add an image to an openpyxl worksheet."""
    if not os.path.exists(img_path):
        logger.warning(f"Image not found for Excel: {img_path}")
        return
    try:
        img = OpenpyxlImage(img_path)
        if width:
            img.width = width
        if height:
            img.height = height
        ws.add_image(img, anchor)
    except Exception as e:
        logger.error(f"Failed to add image {img_path} to Excel: {e}")


def _apply_autofit_sheet1(ws, last_col_idx):
    max_process_col = max(last_col_idx, 19)

    for col_idx in range(1, max_process_col + 1):
        col_letter = get_column_letter(col_idx)
        max_length = 0

        for row in range(6, ws.max_row + 1):
            cell = ws.cell(row=row, column=col_idx)

            if cell.value is None or isinstance(cell, MergedCell):
                continue
            if cell.alignment and cell.alignment.text_rotation == 90:
                continue

            if isinstance(cell.value, (datetime, date)):
                length = 12
            elif isinstance(cell.value, (int, float)):
                # Tambah ekstra untuk memastikan koma dan titik muat
                length = len(f"{cell.value:,.0f}") + 2
            elif isinstance(cell.value, str) and cell.value.startswith("="):
                # Asumsi default untuk formula angka (biasanya miliaran/ratusan juta)
                length = 20
            else:
                length = len(str(cell.value))

            if length > max_length:
                max_length = length

        min_w = MIN_WIDTHS.get(col_letter, 12.0)
        # Jangan autofit kolom B, C, D terlalu ekstrim
        if col_letter in ["B", "C", "D"]:
            ws.column_dimensions[col_letter].width = min_w
        else:
            # Tambahkan ekstra lebar signifikan agar tidak ada lagi yang ###
            ws.column_dimensions[col_letter].width = max(min_w, max_length * 1.3 + 3)

    if "A" in MIN_WIDTHS:
        ws.column_dimensions["A"].width = MIN_WIDTHS["A"]


def _sheet_ref(name: str) -> str:
    return f"'{name}'" if " " in name or "-" in name else name


def _write_secondary_summary_sheets(
    wb, payload, year, main_sheet_name, expense_total_row=None, revenue_last_row=None
):
    from .annual_tables import _expense_amount_for_display, _get_revenue_bounds

    revenues = payload.get("revenue", {}).get("data", [])
    taxes = payload.get("tax", {}).get("data", [])
    expenses = payload.get("operation_cost", {}).get("data", [])
    monthly = {m: {"revenue": 0.0, "tax": 0.0, "expense": 0.0} for m in range(1, 13)}
    for r in revenues:
        dtv = _parse_iso_date(r.get("invoice_date"))
        if not dtv:
            continue
        monthly[dtv.month]["revenue"] += _idr_from_currency(
            r.get("amount_received"), r.get("currency"), r.get("currency_exchange")
        )
    for t in taxes:
        dtv = _parse_iso_date(t.get("date"))
        if not dtv:
            continue
        monthly[dtv.month]["tax"] += (
            _to_float(t.get("ppn"))
            + _to_float(t.get("pph_21"))
            + _to_float(t.get("pph_23"))
            + _to_float(t.get("pph_26"))
            + _to_float(t.get("pemasukan_negara"))
        )
    for e in expenses:
        dtv = _parse_iso_date(e.get("date"))
        if not dtv:
            continue
        monthly[dtv.month]["expense"] += _expense_amount_for_display(e)

    # ? CENTRALIZED: Use single source of truth for revenue row bounds
    if revenue_last_row is None:
        last_revenue_row, _ = _get_revenue_bounds(revenues)
    else:
        last_revenue_row = revenue_last_row

    # ? NO FALLBACK - expense_total_row is required
    if expense_total_row is None:
        raise ValueError(
            "expense_total_row is required - expense rendering must complete successfully"
        )
    cost_totals_row = expense_total_row

    def _get_or_create(name):
        if name in wb.sheetnames:
            return wb[name]
        return wb.create_sheet(name)

    header_fill = PatternFill(
        start_color="D9EAD3", end_color="D9EAD3", fill_type="solid"
    )
    month_labels = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "Mei",
        "Jun",
        "Jul",
        "Agu",
        "Sep",
        "Okt",
        "Nov",
        "Des",
    ]
    main_ref = _sheet_ref(main_sheet_name)
    sheet_suffix = "All" if year == 0 else str(year)
    ws_lr = _get_or_create(f"Laba rugi - {sheet_suffix}")
    ws_lr["A1"] = f"Laba Rugi Tahun {sheet_suffix}"
    ws_lr["A1"].font = Font(bold=True, size=14)
    ws_lr.merge_cells("A1:E1")
    ws_lr["A3"] = "Bulan"
    ws_lr["B3"] = "Revenue (IDR)"
    ws_lr["C3"] = "Tax Out (IDR)"
    ws_lr["D3"] = "Operation Cost (IDR)"
    ws_lr["E3"] = "Laba/Rugi (IDR)"
    for c in "ABCDE":
        cell = ws_lr[f"{c}3"]
        cell.font = Font(bold=True)
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal="center")
    row = 4
    for m in range(1, 13):
        ws_lr.cell(row=row, column=1, value=month_labels[m - 1])
        ws_lr.cell(row=row, column=2, value=monthly[m]["revenue"])
        ws_lr.cell(row=row, column=3, value=monthly[m]["tax"])
        ws_lr.cell(row=row, column=4, value=monthly[m]["expense"])
        ws_lr.cell(row=row, column=5, value=f"=B{row}-C{row}-D{row}")
        row += 1
    ws_lr.cell(row=row, column=1, value="TOTAL")
    for c in range(2, 6):
        ws_lr.cell(
            row=row, column=c, value=f"=SUM({chr(64 + c)}4:{chr(64 + c)}{row - 1})"
        )
    for c in range(1, 6):
        ws_lr.cell(row=row, column=c).font = Font(bold=True)
    for col, width in {"A": 14, "B": 22, "C": 20, "D": 24, "E": 24}.items():
        ws_lr.column_dimensions[col].width = width
    # sheet 3: business summary
    ws_bs = _get_or_create("Business Summary")
    _safe_set_cell_with_merge(ws_bs, 1, 1, f"Business Summary {sheet_suffix}")
    ws_bs["A1"].font = Font(bold=True, size=14)
    # Fetch root categories dynamically from DB
    root_cats_all = (
        Category.query.filter_by(parent_id=None).order_by(Category.sort_order).all()
    )

    # ? Pre-calculate totals per root category to filter zero ones
    all_cats_sync = Category.query.all()
    cat_map = {c.id: c for c in all_cats_sync}
    root_totals = {}
    for e in expenses:
        nominal = _expense_amount_for_display(e)
        r_name, _ = _root_category_info(e.get("category_id"), cat_map)
        if r_name:
            root_totals[r_name] = root_totals.get(r_name, 0.0) + nominal

    # Filter root_cats to only those with data
    root_cats = [c for c in root_cats_all if root_totals.get(c.name, 0.0) > 0]
    if not root_cats and root_cats_all:
        root_cats = [root_cats_all[0]]

    cat_names = [c.name for c in root_cats]
    last_cat_col_letter = get_column_letter(9 + len(cat_names) - 1)

    # ? FIX: Use dynamic category range instead of hardcoded :Q
    rows = [
        (
            "Total Revenue (IDR)",
            _sum_sheet_column_formula(
                main_ref,
                get_column_letter(COL_INVOICE_VALUE_IDR),
                REVENUE_START_ROW,
                last_revenue_row,
            ),
        ),
        (
            "Total Tax Out (IDR)",
            _sum_sheet_column_formula(
                main_ref,
                get_column_letter(COL_PPH_23),
                REVENUE_START_ROW,
                last_revenue_row,
            ),
        ),
        (
            "Total Pengeluaran (IDR)",
            f"=SUM({main_ref}!I{cost_totals_row}:{last_cat_col_letter}{cost_totals_row})",
        ),
        ("Net Profit/Loss (IDR)", "=B4-B5-B6"),
    ]
    ws_bs["A3"] = "Keterangan"
    ws_bs["B3"] = "Nilai"
    for c in "AB":
        cell = ws_bs[f"{c}3"]
        cell.font = Font(bold=True)
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal="center")
    rr = 4
    for label, value in rows:
        ws_bs.cell(row=rr, column=1, value=label)
        ws_bs.cell(row=rr, column=2, value=value)
        rr += 1
    ws_bs["A9"] = "Monthly Snapshot"
    ws_bs["A9"].font = Font(bold=True)
    ws_bs["A10"] = "Bulan"
    ws_bs["B10"] = "Revenue"
    ws_bs["C10"] = "Tax"
    ws_bs["D10"] = "Expense"
    ws_bs["E10"] = "Net"
    for c in "ABCDE":
        cell = ws_bs[f"{c}10"]
        cell.font = Font(bold=True)
        cell.fill = header_fill
        cell.alignment = Alignment(horizontal="center")
    rr = 11
    for m in range(1, 13):
        ws_bs.cell(row=rr, column=1, value=month_labels[m - 1])
        ws_bs.cell(row=rr, column=2, value=monthly[m]["revenue"])
        ws_bs.cell(row=rr, column=3, value=monthly[m]["tax"])
        ws_bs.cell(row=rr, column=4, value=monthly[m]["expense"])
        ws_bs.cell(
            row=rr,
            column=5,
            value=monthly[m]["revenue"] - monthly[m]["tax"] - monthly[m]["expense"],
        )
        rr += 1
    for col, width in {"A": 36, "B": 22, "C": 20, "D": 24, "E": 20}.items():
        ws_bs.column_dimensions[col].width = width


def _set_merged_top_alignment(ws, row_num, col_num):
    cell = ws.cell(row=row_num, column=col_num)
    alignment = copy(cell.alignment)
    alignment.horizontal = "center"
    alignment.vertical = "center"
    cell.alignment = alignment


def _sync_formatted_secondary_sheets(
    wb, payload, year, main_sheet_name, expense_total_row=None, revenue_last_row=None, company="EWI Foundation"
):
    from .annual_tables import _expense_amount_for_display, _get_revenue_bounds

    """
    ? REDESIGNED: No hardcoded cell references (F22, N22, I750)
    All references are now dynamic based on actual table structure.

    Args:
        expense_total_row: Dynamic row where expense totals are stored (required, no fallback)
    """
    expenses = payload.get("operation_cost", {}).get("data", [])
    revenues = payload.get("revenue", {}).get("data", [])
    annual_settings = payload.get("dividend", {}).get("settings", {}) or {}

    # ? VALIDATION ALREADY DONE IN _build_annual_payload_from_db

    # ? CENTRALIZED: Use single source of truth for revenue row bounds
    if revenue_last_row is None:
        last_revenue_row, _ = _get_revenue_bounds(revenues)
    else:
        last_revenue_row = revenue_last_row

    # ? NO FALLBACK - expense_total_row is required
    if expense_total_row is None:
        raise ValueError(
            "expense_total_row is required - expense rendering must complete successfully"
        )
    cost_totals_row = expense_total_row

    # Fetch root categories dynamically from DB
    root_cats_all = (
        Category.query.filter_by(parent_id=None).order_by(Category.sort_order).all()
    )

    # ? Pre-calculate totals per root category to filter zero ones
    all_cats_sync = Category.query.all()
    category_by_id_map = {c.id: c for c in all_cats_sync}
    root_totals = {}
    for e in expenses:
        nominal = _expense_amount_for_display(e)
        r_name, _ = _root_category_info(e.get("category_id"), category_by_id_map)
        if r_name:
            root_totals[r_name] = root_totals.get(r_name, 0.0) + nominal

    # Filter root_cats to only those with data
    root_cats = [c for c in root_cats_all if root_totals.get(c.name, 0.0) > 0]
    if not root_cats and root_cats_all:
        root_cats = [root_cats_all[0]]

    cat_names = [c.name for c in root_cats]

    opening_cash_balance = _to_float(annual_settings.get("opening_cash_balance"))
    accounts_receivable = _to_float(annual_settings.get("accounts_receivable"))
    prepaid_tax_pph23 = _to_float(annual_settings.get("prepaid_tax_pph23"))
    prepaid_expenses = _to_float(annual_settings.get("prepaid_expenses"))
    other_receivables = _to_float(annual_settings.get("other_receivables"))
    office_inventory = _to_float(annual_settings.get("office_inventory"))
    other_assets = _to_float(annual_settings.get("other_assets"))
    accounts_payable = _to_float(annual_settings.get("accounts_payable"))
    salary_payable = _to_float(annual_settings.get("salary_payable"))
    shareholder_payable = _to_float(annual_settings.get("shareholder_payable"))
    accrued_expenses = _to_float(annual_settings.get("accrued_expenses"))
    share_capital = _to_float(annual_settings.get("share_capital"))
    retained_earnings_balance = _to_float(
        annual_settings.get("retained_earnings_balance")
    )

    main_ref = _sheet_ref(main_sheet_name)

    # ? MAIN SHEET: Don't overwrite cells - let Excel formulas work
    # Revenue total and PPh23 total are already calculated by Excel formulas in Table 1
    # Cost totals are written to template row for Laba Rugi references
    # Cost totals are calculated natively via Excel formulas in the MAIN SHEET
    sheet_suffix = "All" if year == 0 else str(year)
    lr_name = f"Laba rugi - {sheet_suffix}"
    if lr_name in wb.sheetnames:
        ws_lr = wb[lr_name]

        # ? DISABLE GRIDLINES for a clean look
        ws_lr.sheet_view.showGridLines = False

        # ? FIX COLUMN WIDTHS to match Original Proportions (Gambar 1)
        ws_lr.column_dimensions["B"].width = 20
        ws_lr.column_dimensions["C"].width = 30
        ws_lr.column_dimensions["D"].width = 5
        ws_lr.column_dimensions["E"].width = 15
        ws_lr.column_dimensions["F"].width = 2  # ? NARROW GAP between tables
        ws_lr.column_dimensions["G"].width = 20
        ws_lr.column_dimensions["H"].width = 30
        ws_lr.column_dimensions["I"].width = 5
        ws_lr.column_dimensions["J"].width = 15

        # ? REPLACE YEAR IN HEADERS (B4 and F4 in template)
        _replace_text_in_sheet(ws_lr, "2024", str(year))

        # ? CRITICAL: PRE-CLEAR ONLY LABA RUGI SIDE
        # We only clear columns A to E (1-5) to preserve NERACA on the right (G-J)
        max_lr_row = max(ws_lr.max_row, 150)
        _clear_range_force(ws_lr, 8, max_lr_row, 1, 5, reset_style=True)

        # Surgically clear old signatures area on BOTH sides to prevent duplicates
        # Clear more columns (1 to 8) to ensure stray "Direktur" from template are removed
        _clear_range_force(ws_lr, 48, max_lr_row, 1, 8, reset_style=True)

        # Helper to apply clean border style to a row (B to E)
        def _apply_pl_row_style(r, style_type="data"):
            s_thin = Side(style="thin")
            s_none = Side(style=None)
            s_double = (
                Side(style="double") if style_type == "final" else s_none
            )  # Or double if needed

            # ? FIX: Set standard row height
            ws_lr.row_dimensions[r].height = 15

            # Determine Top/Bottom borders based on style
            top_s = s_thin if style_type in ("total", "final", "header") else s_none
            bottom_s = (
                s_thin
                if style_type == "total"
                else (s_double if style_type == "final" else s_none)
            )

            # ? UNIFIED BOX LOGIC: Tambahkan garis vertikal antara Deskripsi dan simbol Rp
            # Laba Rugi Side (B-E)
            ws_lr.cell(row=r, column=2).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=3).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=4).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=5).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )

            # Neraca Side (G-J)
            ws_lr.cell(row=r, column=7).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=8).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=9).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=10).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )

            # Alignment for Laba Rugi
            ws_lr.cell(row=r, column=2).alignment = Alignment(
                horizontal="left", vertical="center"
            )
            ws_lr.cell(row=r, column=3).alignment = Alignment(
                horizontal="left", vertical="center"
            )
            ws_lr.cell(row=r, column=4).alignment = Alignment(
                horizontal="right", vertical="center"
            )  # Rp closer to number
            ws_lr.cell(row=r, column=5).alignment = Alignment(
                horizontal="right", vertical="center"
            )

            # Alignment for Neraca
            ws_lr.cell(row=r, column=7).alignment = Alignment(
                horizontal="left", vertical="center"
            )
            ws_lr.cell(row=r, column=8).alignment = Alignment(
                horizontal="left", vertical="center"
            )
            ws_lr.cell(row=r, column=9).alignment = Alignment(
                horizontal="right", vertical="center"
            )  # Rp closer to number
            ws_lr.cell(row=r, column=10).alignment = Alignment(
                horizontal="right", vertical="center"
            )

            # Font - Header and Totals are Bold
            is_bold = style_type in ("header", "total", "final")
            font = Font(bold=is_bold, size=11, name="Arial Narrow")
            for col in list(range(2, 6)) + list(range(7, 11)):
                ws_lr.cell(row=r, column=col).font = font
                ws_lr.cell(row=r, column=col).fill = PatternFill(fill_type=None)

            # Number Format for Value Columns (E and J)
            ws_lr.cell(row=r, column=5).number_format = "#,##0"
            ws_lr.cell(row=r, column=10).number_format = "#,##0"

        # ? EXACT ORIGINAL PROPORTIONS: Match Gambar 2 (from 2024 backup template)
        # Row Heights for the header gap
        ws_lr.row_dimensions[1].height = 15.0
        ws_lr.row_dimensions[2].height = 37.25  # Logo area
        ws_lr.row_dimensions[3].height = 33.6  # PT. EXSPAN header
        ws_lr.row_dimensions[4].height = 20.45  # Title row
        ws_lr.row_dimensions[5].height = 6.0  # Small gap before table

        # Column Widths
        ws_lr.column_dimensions["A"].width = 1.13
        ws_lr.column_dimensions["B"].width = 5.53  # Indent col
        ws_lr.column_dimensions["C"].width = 38.33  # Label col
        ws_lr.column_dimensions["D"].width = 3.66  # Rp col
        ws_lr.column_dimensions["E"].width = 30.13  # Amount col
        ws_lr.column_dimensions["F"].width = 1.13  # Middle spacer
        ws_lr.column_dimensions["G"].width = 5.53  # Indent col
        ws_lr.column_dimensions["H"].width = 38.33  # Label col
        ws_lr.column_dimensions["I"].width = 3.66  # Rp col
        ws_lr.column_dimensions["J"].width = 30.13  # Amount col

        # Just clean up old metadata values if they somehow persist
        ws_lr["A3"] = None
        ws_lr["F3"] = None

        # bersihkan nilai template dummy spesifik di neraca
        if ws_lr["J10"].value in (161401093, "=161401093", 161401093.0):
            ws_lr["J10"] = 0

        # ? REVENUE TOTALS BY TYPE - Hitung dengan SUM langsung ke baris sesuai tipe
        direct_count = sum(
            1
            for r in revenues
            if (r.get("revenue_type") or "pendapatan_langsung").strip().lower()
            != "pendapatan_lain_lain"
        )
        other_count = len(revenues) - direct_count
        col_letter = get_column_letter(COL_INVOICE_VALUE_IDR)
        start_row_ref = REVENUE_START_ROW

        # PENDAPATAN SECTION
        ws_lr["B8"] = "PENDAPATAN"
        ws_lr["B8"].font = Font(bold=True)
        _apply_pl_row_style(8, "header")

        ws_lr["C9"] = "PENDAPATAN LANGSUNG"
        ws_lr["D9"] = "Rp"
        if direct_count > 0:
            ws_lr["E9"] = (
                f"=SUM({main_ref}!{col_letter}{start_row_ref}:{col_letter}{start_row_ref + direct_count - 1})"
            )
        else:
            ws_lr["E9"] = 0
        _apply_pl_row_style(9, "data")

        ws_lr["C10"] = "PENDAPATAN LAIN LAIN"
        ws_lr["D10"] = "Rp"
        if other_count > 0:
            other_start = start_row_ref + direct_count
            ws_lr["E10"] = (
                f"=SUM({main_ref}!{col_letter}{other_start}:{col_letter}{other_start + other_count - 1})"
            )
        else:
            ws_lr["E10"] = 0
        _apply_pl_row_style(10, "data")

        _apply_pl_row_style(11, "data")  # Gap baris 11

        ws_lr["B12"] = "TOTAL PENDAPATAN"
        ws_lr["B12"].font = Font(bold=True)
        ws_lr["D12"] = "Rp"
        ws_lr["E12"] = "=SUM(E9:E11)"
        _apply_pl_row_style(12, "total")

        _apply_pl_row_style(13, "data")  # Gap baris 13

        # ? Expense totals: Dynamic Generation based on CategoryGroup
        # 1. Fetch all category groups for this company
        company = company or "EWI Foundation"
        all_groups = (
            CategoryGroup.query.filter_by(company=company)
            .order_by(CategoryGroup.sort_order)
            .all()
        )

        # If no groups found, seed them (fallback for safety)
        if not all_groups:
            defaults = [
                ("BEBAN LANGSUNG", 0),
                ("BEBAN TIDAK LANGSUNG", 1),
                ("BIAYA ADMINISTRASI DAN UMUM", 2),
            ]
            for name, order in defaults:
                g = CategoryGroup(name=name, sort_order=order, company=company)
                db.session.add(g)
            db.session.commit()
            all_groups = (
                CategoryGroup.query.filter_by(company=company)
                .order_by(CategoryGroup.sort_order)
                .all()
            )

        # Map categories to groups
        group_to_cats = {g.name.upper(): [] for g in all_groups}

        # We need the Category objects to check main_group
        category_obj_by_name = {c.name: c for c in root_cats}

        for idx, cat_name in enumerate(cat_names):
            col_letter = get_column_letter(9 + idx)
            cat_obj = category_obj_by_name.get(cat_name)

            if cat_obj and cat_obj.main_group:
                mg = cat_obj.main_group.upper()
                if mg not in group_to_cats:
                    group_to_cats[mg] = []
                group_to_cats[mg].append((cat_name, col_letter))
            else:
                # Fallback logic if main_group is missing
                direct_keywords = [
                    "operasi",
                    "research",
                    "r&d",
                    "r & d",
                    "sewa peralatan",
                    "interpretasi",
                    "log data",
                    "project",
                ]
                is_direct = any(k in str(cat_name).lower() for k in direct_keywords)
                mg = "BEBAN LANGSUNG" if is_direct else "BIAYA ADMINISTRASI DAN UMUM"
                if mg not in group_to_cats:
                    group_to_cats[mg] = []
                group_to_cats[mg].append((cat_name, col_letter))

        # Clear old Laba Rugi area (A14 - E max_row)
        max_lr_row = max(ws_lr.max_row, 150)
        _clear_range_force(ws_lr, 14, max_lr_row, 1, 5, reset_style=True)

        row = 14
        total_group_rows = []

        for group in all_groups:
            group_name = group.name.upper()
            cats_in_group = group_to_cats.get(group_name, [])

            # Header
            ws_lr[f"B{row}"] = group_name
            ws_lr[f"B{row}"].font = Font(bold=True)
            _apply_pl_row_style(row, "header")
            row += 1

            start_group_row = row
            if cats_in_group:
                for name, col_l in cats_in_group:
                    ws_lr[f"C{row}"] = f"{name.upper()}"
                    ws_lr[f"D{row}"] = "Rp"
                    ws_lr[f"E{row}"] = f"={main_ref}!{col_l}{cost_totals_row}"
                    _apply_pl_row_style(row, "data")
                    row += 1
                end_group_row = row - 1
            else:
                # Empty group row placeholder
                ws_lr[f"D{row}"] = "Rp"
                ws_lr[f"E{row}"] = 0
                _apply_pl_row_style(row, "data")
                end_group_row = row
                row += 1

            # Total for this group
            ws_lr[f"B{row}"] = f"TOTAL {group_name}"
            ws_lr[f"B{row}"].font = Font(bold=True)
            ws_lr[f"D{row}"] = "Rp"
            ws_lr[f"E{row}"] = f"=SUM(E{start_group_row}:E{end_group_row})"
            _apply_pl_row_style(row, "total")
            total_group_rows.append(row)
            row += 1

            _apply_pl_row_style(row, "data")  # Gap row
            row += 1

        # ? TOTAL BIAYA (Sum of all group totals)
        ws_lr[f"B{row}"] = "TOTAL BIAYA"
        ws_lr[f"B{row}"].font = Font(bold=True)
        ws_lr[f"D{row}"] = "Rp"

        if total_group_rows:
            formula = "=" + "+".join([f"E{r}" for r in total_group_rows])
            ws_lr[f"E{row}"] = formula
        else:
            ws_lr[f"E{row}"] = 0

        _apply_pl_row_style(row, "total")
        tot_biaya_row = row
        row += 1
        _apply_pl_row_style(row, "data")  # Gap row
        row += 1

        ws_lr[f"B{row}"] = "PENDAPATAN/BEBAN LAIN LAIN"
        ws_lr[f"B{row}"].font = Font(bold=True)
        _apply_pl_row_style(row, "header")
        row += 1
        ws_lr[f"C{row}"] = "PENDAPATAN LAIN LAIN"
        ws_lr[f"D{row}"] = "Rp"
        ws_lr[f"E{row}"] = 0
        _apply_pl_row_style(row, "data")
        row += 1
        _apply_pl_row_style(row, "data")  # Gap row
        row += 1

        ws_lr[f"B{row}"] = "LABA RUGI SEBELUM PAJAK"
        ws_lr[f"B{row}"].font = Font(bold=True)
        ws_lr[f"D{row}"] = "Rp"
        ws_lr[f"E{row}"] = f"=E12-E{tot_biaya_row}"
        _apply_pl_row_style(row, "total")
        laba_sblum_row = row
        row += 1
        _apply_pl_row_style(row, "data")  # Gap row
        row += 1

        ws_lr[f"B{row}"] = "CORPORATE TAX (PPh 29)"
        ws_lr[f"B{row}"].font = Font(bold=True)
        ws_lr[f"D{row}"] = "Rp"
        ws_lr[f"E{row}"] = 0
        _apply_pl_row_style(row, "total")
        tax_row = row
        row += 1
        _apply_pl_row_style(row, "data")  # Gap row
        row += 1

        ws_lr[f"B{row}"] = "LABA / RUGI BERSIH"
        ws_lr[f"B{row}"].font = Font(bold=True)
        ws_lr[f"D{row}"] = "Rp"
        ws_lr[f"E{row}"] = f"=E{laba_sblum_row}-E{tax_row}"
        _apply_pl_row_style(row, "final")
        laba_bersih_row = row

        # ? Track last Laba Rugi row
        final_lr_row = row

        # ? Tentukan posisi tanda tangan: Jeda 3 baris dari tabel terpanjang
        final_neraca_row = 46
        gap_size = 3
        sig_name_row = max(final_lr_row, final_neraca_row) + gap_size
        sig_title_row = sig_name_row + 1

        # ? BERSIHKAN AREA GAP (Hapus garis gantung)
        # Scan dari baris setelah tabel sampai baris tanda tangan
        start_cleanup = min(final_lr_row, final_neraca_row) + 1
        _clear_range_force(
            ws_lr, start_cleanup, sig_name_row - 1, 1, 10, reset_style=True
        )

        # Apply data styling and labels to all Neraca rows from 8 to 46
        neraca_content = {
            8: ("AKTIVA", None),
            9: ("AKTIVA LANCAR", None),
            10: ("  KAS DAN SETARA KAS TAHUN SEBELUMNYA", "Rp"),
            11: ("  KAS DAN SETARA KAS TAHUN LAPORAN", "Rp"),
            12: ("  PIUTANG USAHA", "Rp"),
            13: ("  PAJAK BAYAR DI MUKA (pph23)", "Rp"),
            14: ("  BIAYA BAYAR DI MUKA", "Rp"),
            15: ("  PIUTANG LAIN LAIN", "Rp"),
            16: ("TOTAL AKTIVA LANCAR", "Rp"),
            17: ("ACTIVA TETAP", None),
            20: ("  INVENTARIS KANTOR", "Rp"),
            22: ("TOTAL AKTIVA TETAP", "Rp"),
            24: ("ACTIVA LAIN LAIN", None),
            25: ("  TOTAL AKTIVA LAIN LAIN", "Rp"),
            28: ("TOTAL AKTIVA", "Rp"),
            30: ("HUTANG DAN MODAL", None),
            32: ("HUTANG LANCAR", None),
            33: ("  HUTANG USAHA", "Rp"),
            34: ("  HUTANG GAJI", "Rp"),
            35: ("  HUTANG PEMEGANG SAHAM", "Rp"),
            36: ("  BIAYA YANG MASIH HARUS DI BAYAR", "Rp"),
            38: ("TOTAL HUTANG LANCAR", "Rp"),
            40: ("MODAL", None),
            41: ("  MODAL SAHAM", "Rp"),
            42: ("  LABA DI TAHAN", "Rp"),
            43: ("  TOTAL LABA (RUGI) DITAHAN", "Rp"),
            44: ("TOTAL MODAL", "Rp"),
            46: ("TOTAL HUTANG DAN MODAL", "Rp"),
        }

        for r in range(8, final_neraca_row + 1):
            s_type = (
                "header"
                if r in (8, 17, 24, 30, 32, 40)
                else (
                    "total"
                    if r in (16, 22, 25, 28, 38, 44)
                    else ("final" if r == 46 else "data")
                )
            )

            # Apply labels
            if r in neraca_content:
                lbl, rp_sym = neraca_content[r]
                ws_lr[f"H{r}"] = lbl
                if rp_sym:
                    ws_lr[f"I{r}"] = rp_sym

            # Helper to clear and apply Neraca side borders
            s_thin = Side(style="thin")
            top_s = (
                s_thin if s_type in ("total", "final", "header") else Side(style=None)
            )
            bottom_s = (
                s_thin
                if s_type == "total"
                else (Side(style="double") if s_type == "final" else Side(style=None))
            )

            ws_lr.cell(row=r, column=7).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=8).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=9).border = Border(
                left=s_thin, top=top_s, bottom=bottom_s
            )
            ws_lr.cell(row=r, column=10).border = Border(
                right=s_thin, top=top_s, bottom=bottom_s
            )

            # Standard Neraca Alignment & Font
            font_n = Font(
                bold=(s_type in ("header", "total", "final")),
                size=11,
                name="Arial Narrow",
            )
            for c in range(7, 11):
                cell_n = ws_lr.cell(row=r, column=c)
                cell_n.font = font_n
                if c == 7:
                    cell_n.alignment = Alignment(horizontal="left", vertical="center")
                elif c == 8:
                    cell_n.alignment = Alignment(horizontal="left", vertical="center")
                elif c == 9:
                    cell_n.alignment = Alignment(horizontal="right", vertical="center")
                elif c == 10:
                    cell_n.alignment = Alignment(horizontal="right", vertical="center")
                    cell_n.number_format = "#,##0"

        # ? ALIGNED BRANDING & MERGED SIGNATURES
        os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "sheet1.png",
            )
        )
        logo_expsan_path = os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "expsan excel.png",
            )
        )
        profile_path = os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "profil.png",
            )
        )

        # Top Logos - Menggunakan expsan excel.png dengan ukuran presisi
        # Digeser ke E1 dan J1 agar sejajar dengan kolom nilai (Rp)
        ws_lr._images.clear()
        _add_image_to_sheet(ws_lr, logo_expsan_path, "E1", width=220, height=65)
        _add_image_to_sheet(ws_lr, logo_expsan_path, "J1", width=220, height=65)

        # Left Side Signature (Merge B-E and Center)
        ws_lr.merge_cells(f"B{sig_name_row}:E{sig_name_row}")
        ws_lr[f"B{sig_name_row}"] = "Nama Lengkap"
        ws_lr[f"B{sig_name_row}"].font = Font(bold=True, underline="single")
        ws_lr[f"B{sig_name_row}"].alignment = Alignment(horizontal="center")

        ws_lr.merge_cells(f"B{sig_title_row}:E{sig_title_row}")
        ws_lr[f"B{sig_title_row}"] = "Direktur"
        ws_lr[f"B{sig_title_row}"].font = Font(bold=True)
        ws_lr[f"B{sig_title_row}"].alignment = Alignment(horizontal="center")

        # Right Side Signature (Merge G-J and Center)
        ws_lr.merge_cells(f"G{sig_name_row}:J{sig_name_row}")
        ws_lr[f"G{sig_name_row}"] = "Nama Lengkap"
        ws_lr[f"G{sig_name_row}"].font = Font(bold=True, underline="single")
        ws_lr[f"G{sig_name_row}"].alignment = Alignment(horizontal="center")

        ws_lr.merge_cells(f"G{sig_title_row}:J{sig_title_row}")
        ws_lr[f"G{sig_title_row}"] = "Direktur"
        ws_lr[f"G{sig_title_row}"].font = Font(bold=True)
        ws_lr[f"G{sig_title_row}"].alignment = Alignment(horizontal="center")

        # Bottom Footers - Presisi sesuai screenshot (15.22cm x 1.25cm -> ~575px x 47px)
        footer_row = sig_title_row + 1
        _add_image_to_sheet(ws_lr, profile_path, f"B{footer_row}", width=575, height=47)
        _add_image_to_sheet(ws_lr, profile_path, f"G{footer_row}", width=575, height=47)

        # input dan formula neraca (ROUNDED)
        ws_lr["J10"] = round(opening_cash_balance)
        ws_lr["J11"] = f"=ROUND(E{laba_bersih_row}-'Business Summary'!E13, 0)"
        ws_lr["J12"] = round(accounts_receivable)
        ws_lr["J13"] = round(prepaid_tax_pph23)
        ws_lr["J14"] = round(prepaid_expenses)
        ws_lr["J15"] = round(other_receivables)
        ws_lr["J16"] = "=SUM(J10:J15)"
        ws_lr["J20"] = round(office_inventory)
        ws_lr["J22"] = "=J20"
        ws_lr["J25"] = round(other_assets)
        ws_lr["J26"] = "=SUM(J25:J25)"
        ws_lr["J28"] = "=J26+J22+J16"
        ws_lr["J33"] = round(accounts_payable)
        ws_lr["J34"] = round(salary_payable)
        ws_lr["J35"] = round(shareholder_payable)
        ws_lr["J36"] = round(accrued_expenses)
        ws_lr["J38"] = "=SUM(J33:J36)"
        ws_lr["J41"] = round(share_capital)
        ws_lr["J42"] = round(retained_earnings_balance)
        ws_lr["J43"] = "=J28-J38-J41-J42"
        ws_lr["J44"] = "=SUM(J41:J43)"
        ws_lr["J46"] = "=J44+J38"

    if "Business Summary" in wb.sheetnames:
        ws_bs = wb["Business Summary"]
        ws_bs["A4"] = None  # Clean up mistake
        ws_bs["B4"] = f"BUSINESS SUMMARY | TAHUN {year}"

        # ? REPLACE YEAR IN HEADERS
        _replace_text_in_sheet(ws_bs, "2024", str(year))

        # ? Clean background: Hide gridlines for a professional look
        ws_bs.sheet_view.showGridLines = False

        # ? Set column widths for Sheet 3
        ws_bs.column_dimensions["A"].width = 3.0
        ws_bs.column_dimensions["B"].width = 4.0
        ws_bs.column_dimensions["C"].width = 40.0
        ws_bs.column_dimensions["D"].width = 4.0
        ws_bs.column_dimensions["E"].width = 25.0
        ws_bs.column_dimensions["F"].width = 2.0  # Narrow separator as requested
        ws_bs.column_dimensions["G"].width = 15.0

        # FIX: Set consistent row height for main table (rows 6-16)
        for row_idx in range(6, 17):
            ws_bs.row_dimensions[row_idx].height = ROW_HEIGHT_DIVIDEND

        # ? FIX: Define variables to prevent NameErrors
        last_cat_col_letter_sync = get_column_letter(9 + len(cat_names) - 1)
        yellow_fill = PatternFill(
            start_color="FFFF00", end_color="FFFF00", fill_type="solid"
        )

        # Apply Custom Border to hide vertical line between D and E for rows 7-16 (NO MERGE)
        for r in range(7, 17):
            try:
                ws_bs.unmerge_cells(f"D{r}:E{r}")
            except Exception:
                pass
            _set_dividend_row_border(ws_bs, r)  # Uses helper that hides D-E line
            ws_bs[f"D{r}"] = "Rp"
            ws_bs[f"D{r}"].alignment = Alignment(horizontal="left")
            ws_bs[f"E{r}"].alignment = Alignment(horizontal="right")

        # Row 7: Item 1 - Revenue
        ws_bs["B7"] = 1
        ws_bs["C7"] = "Revenue"
        ws_bs["E7"] = _sum_sheet_column_formula(
            main_ref,
            get_column_letter(COL_INVOICE_VALUE_IDR),
            REVENUE_START_ROW,
            last_revenue_row,
        )
        ws_bs["E7"].number_format = "#,##0"

        # Row 8: Item 2 - Revenue Diterima (Setelah Pajak)
        ws_bs["B8"] = 2
        ws_bs["C8"] = "Revenue Diterima (Setelah Pajak)"
        ws_bs["E8"] = (
            f"=E7-{_sum_sheet_column_formula(main_ref, get_column_letter(COL_PPH_23), REVENUE_START_ROW, last_revenue_row)[1:]}"
        )
        ws_bs["E8"].number_format = "#,##0"

        # Row 9: Item 3 - Biaya
        ws_bs["B9"] = 3
        ws_bs["C9"] = "Biaya"
        ws_bs["E9"] = (
            f"=SUM({main_ref}!I{cost_totals_row}:{last_cat_col_letter_sync}{cost_totals_row})"
        )
        ws_bs["E9"].number_format = "#,##0"

        # Row 10: Item 4 - Profit SebelumTax
        ws_bs["B10"] = 4
        ws_bs["C10"] = "Profit SebelumTax"
        ws_bs["E10"] = "=E7-E9"
        ws_bs["E10"].number_format = "#,##0"

        # Row 11: Item 5 - PPh Badan (22%*50%)
        ws_bs["B11"] = 5
        ws_bs["C11"] = "PPh Badan (22%*50%)"
        ws_bs["E11"] = "=E10*22%*50%"
        ws_bs["E11"].number_format = "#,##0"

        # Row 12: Item 6 - PPh 23 Dipotong oleh client
        ws_bs["B12"] = 6
        ws_bs["C12"] = "PPh 23 Dipotong oleh client"
        ws_bs["E12"] = _sum_sheet_column_formula(
            main_ref, get_column_letter(COL_PPH_23), REVENUE_START_ROW, last_revenue_row
        )
        ws_bs["E12"].number_format = "#,##0"

        # Row 13: Item 7 - Kekurangan Bayar PPh Badan
        ws_bs["B13"] = 7
        ws_bs["C13"] = "Kekurangan Bayar PPh Badan"
        ws_bs["E13"] = "=E11-E12"
        ws_bs["E13"].number_format = "#,##0"
        ws_bs["E13"].fill = yellow_fill

        # Row 14: Item 8 - Profit After Tax
        ws_bs["B14"] = 8
        ws_bs["C14"] = "Profit After Tax"
        ws_bs["E14"] = "=E10-E13"
        ws_bs["E14"].number_format = "#,##0"

        dividends = payload.get("dividend", {}).get("data", [])
        profit_retained = _to_float(payload.get("dividend", {}).get("profit_retained"))

        # Row 15: Item 9 - Deviden Dibagi
        ws_bs["B15"] = 9
        ws_bs["C15"] = "Deviden Dibagi"
        ws_bs["E15"] = "=E14-E16"
        ws_bs["E15"].number_format = "#,##0"

        # Row 16: Item 10 - Profit Ditahan
        ws_bs["B16"] = 10
        ws_bs["C16"] = "Profit Ditahan"
        ws_bs["E16"] = profit_retained
        ws_bs["E16"].number_format = "#,##0"

        # ? DEVIDEN SECTION
        ws_bs["B18"] = "DEVIDEN"
        ws_bs["B18"].font = Font(bold=True, size=14, name="Trebuchet MS")

        # Row 19 Header - REMOVED 'Pajak' text
        ws_bs["B19"] = "#"
        ws_bs["C19"] = "Nama Lengkap"
        ws_bs["D19"] = "Rp"
        ws_bs["E19"] = "Amount"
        ws_bs["G19"] = ""
        for col in ("B", "C", "D", "E", "G"):
            cell = ws_bs[f"{col}19"]
            cell.font = Font(bold=True, size=14, name="Trebuchet MS")
            cell.alignment = Alignment(horizontal="center", vertical="center")

        # Hide middle border for header too
        try:
            ws_bs.unmerge_cells("D19:E19")
        except Exception:
            pass
        _set_dividend_row_border(ws_bs, 19)

        # Clear ALL potential dividend data rows (20-80) and REMOVE any existing borders
        for row in range(20, 81):
            for col in ("B", "C", "D", "E", "F", "G"):
                try:
                    ws_bs[f"{col}{row}"] = None
                    # Set border to None for all cells to clean up
                    ws_bs[f"{col}{row}"].border = Border()
                except Exception:
                    pass
            try:
                ws_bs.unmerge_cells(f"D{row}:E{row}")
            except Exception:
                pass

        # Fill actual dividend data
        num_dividends = len(dividends)
        last_row = 19 + num_dividends if num_dividends > 0 else 19

        for idx, item in enumerate(dividends, 1):
            row = 19 + idx
            ws_bs[f"B{row}"] = idx
            ws_bs[f"C{row}"] = item.get("name", "")
            ws_bs[f"D{row}"] = "Rp"
            ws_bs[f"E{row}"] = (
                f'=IF(C{row}="","",ROUND($E$15/COUNTA($C$20:$C${19 + num_dividends}), 0))'
            )
            ws_bs[f"G{row}"] = "Pajak 10%"

            # Styling for data rows
            for col in ("B", "C", "D", "E"):
                cell = ws_bs[f"{col}{row}"]
                cell.font = Font(size=14, name="Trebuchet MS")
                if col == "B":
                    cell.alignment = Alignment(horizontal="center")
                elif col == "C":
                    cell.alignment = Alignment(horizontal="left")
                elif col == "D":
                    cell.alignment = Alignment(horizontal="left")
                elif col == "E":
                    cell.alignment = Alignment(horizontal="right")

            ws_bs[f"E{row}"].number_format = "#,##0"
            # ? Apply border ONLY to the actual data row
            _set_dividend_row_border(ws_bs, row)

        # Set consistent row heights
        for r in range(19, last_row + 1):
            ws_bs.row_dimensions[r].height = ROW_HEIGHT_DIVIDEND

        # ? ADD BRANDING TO BUSINESS SUMMARY
        os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "sheet1.png",
            )
        )
        logo_expsan_path = os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "expsan excel.png",
            )
        )
        profile_path = os.path.abspath(
            os.path.join(
                BASE_DIR,
                "..",
                "frontend",
                "assets",
                "images",
                "profil.png",
            )
        )

        # Top Logo - Balanced size (match Sheet 2: 220px x 65px)
        ws_bs._images.clear()
        _add_image_to_sheet(ws_bs, logo_expsan_path, "D1", width=220, height=65)

        # Footer Profile - Restored "Gap Panjang" (4 rows below last_row to stay at the bottom)
        footer_row = last_row + 4
        _add_image_to_sheet(ws_bs, profile_path, f"B{footer_row}", width=550, height=45)


def _clone_sheet_from_template(src_ws, target_wb, new_name):
    if new_name in target_wb.sheetnames:
        del target_wb[new_name]
    dst_ws = target_wb.create_sheet(new_name)
    dst_ws.sheet_format = copy(src_ws.sheet_format)
    dst_ws.sheet_properties = copy(src_ws.sheet_properties)
    dst_ws.page_margins = copy(src_ws.page_margins)
    dst_ws.page_setup = copy(src_ws.page_setup)
    dst_ws.print_options = copy(src_ws.print_options)
    dst_ws.freeze_panes = src_ws.freeze_panes
    dst_ws.auto_filter = copy(src_ws.auto_filter)
    for col_letter, col_dim in src_ws.column_dimensions.items():
        dst = dst_ws.column_dimensions[col_letter]
        dst.width = col_dim.width
        dst.hidden = col_dim.hidden
        dst.outlineLevel = col_dim.outlineLevel
        dst.bestFit = col_dim.bestFit
    for row_idx, row_dim in src_ws.row_dimensions.items():
        dst = dst_ws.row_dimensions[row_idx]
        dst.height = row_dim.height
        dst.hidden = row_dim.hidden
        dst.outlineLevel = row_dim.outlineLevel
    for row in src_ws.iter_rows(
        min_row=1, max_row=src_ws.max_row, min_col=1, max_col=src_ws.max_column
    ):
        for cell in row:
            dst = dst_ws.cell(row=cell.row, column=cell.column, value=cell.value)
            if cell.has_style:
                dst.font = copy(cell.font)
                dst.fill = copy(cell.fill)
                dst.border = copy(cell.border)
                dst.alignment = copy(cell.alignment)
                dst.number_format = copy(cell.number_format)
                dst.protection = copy(cell.protection)
    for merged in src_ws.merged_cells.ranges:
        dst_ws.merge_cells(str(merged))
    return dst_ws


def _ensure_formatted_secondary_sheets(wb, year, template_dir):
    sheet_suffix = "All" if year == 0 else str(year)
    target_lr = f"Laba rugi - {sheet_suffix}"
    target_bs = "Business Summary"

    # Hapus semua sheet Laba rugi yang lama (dari template)
    sheets_to_remove = [
        name
        for name in wb.sheetnames
        if name.startswith("Laba rugi -") and name != target_lr
    ]
    for sheet_name in sheets_to_remove:
        if sheet_name in wb.sheetnames:
            del wb[sheet_name]

    if target_lr in wb.sheetnames and target_bs in wb.sheetnames:
        return True

    donor_candidates = [
        os.path.abspath(
            os.path.join(template_dir, "20250427_EWI Financial-Repport_2024.xlsx")
        ),
        os.path.abspath(
            os.path.join(
                template_dir, "20250427_EWI Financial-Repport_2024_Submitted_Rev1.xlsx"
            )
        ),
        os.path.abspath(os.path.join(template_dir, "Revenue-Cost_2024_cleaned.xlsx")),
    ]
    donor_path = next((p for p in donor_candidates if os.path.exists(p)), None)
    if not donor_path:
        return False

    donor_wb = load_workbook(donor_path, keep_links=False)

    # Cari sheet Laba rugi (bisa Laba rugi -2024 atau nama lain)
    donor_lr_name = next(
        (name for name in donor_wb.sheetnames if name.startswith("Laba rugi")), None
    )
    donor_lr = donor_wb[donor_lr_name] if donor_lr_name else None

    # Cari sheet Business Summary
    donor_bs_name = next(
        (name for name in donor_wb.sheetnames if name == "Business Summary"), None
    )
    donor_bs = donor_wb[donor_bs_name] if donor_bs_name else None

    if donor_lr is None or donor_bs is None:
        return False

    _clone_sheet_from_template(donor_lr, wb, target_lr)
    _clone_sheet_from_template(donor_bs, wb, target_bs)

    # ? FIX: Override column widths from template for Business Summary
    # Template has wide columns, we want smaller consistent columns
    if target_bs in wb.sheetnames:
        ws_bs = wb[target_bs]
        ws_bs.column_dimensions["A"].width = 1  # # column - kecil
        ws_bs.column_dimensions["B"].width = 5  # # column - kecil
        ws_bs.column_dimensions["C"].width = 40  # Items / Nama Lengkap (diperlebar)
        ws_bs.column_dimensions["D"].width = 5  # Rp currency
        ws_bs.column_dimensions["E"].width = 25  # Amount (diperlebar)
        ws_bs.column_dimensions["F"].width = 4  # Empty separator
        ws_bs.column_dimensions["G"].width = 10  # Pajak

    return True


__all__ = [
    "_clone_row_format",
    "_replace_text_in_sheet",
    "_copy_template_row",
    "_copy_template_row_from_backup",
    "_sum_sheet_column_formula",
    "_safe_merge_cells_sheet",
    "_add_image_to_sheet",
    "_apply_autofit_sheet1",
    "_sheet_ref",
    "_write_secondary_summary_sheets",
    "_set_merged_top_alignment",
    "_sync_formatted_secondary_sheets",
    "_clone_sheet_from_template",
    "_ensure_formatted_secondary_sheets",
]
