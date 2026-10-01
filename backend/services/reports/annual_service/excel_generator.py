import json
import logging
import os
from copy import copy
from datetime import datetime
from io import BytesIO
from config import BASE_DIR
from fastapi.responses import FileResponse, JSONResponse, StreamingResponse
from models import (
    Category,
    db,
)
from openpyxl import load_workbook
from openpyxl.cell.cell import MergedCell
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from sqlalchemy import text as sql_text
from services.reports.annual_service.annual_constants import (
    COL_AMOUNT_RECEIVED_IDR,
    COL_AMOUNT_RECEIVED_USD,
    COL_CLIENT,
    COL_CURRENCY,
    COL_DATE,
    COL_EXCHANGE_RATE,
    COL_INVOICE_NUMBER,
    COL_INVOICE_VALUE_IDR,
    COL_INVOICE_VALUE_USD,
    COL_PPH_23,
    COL_PPN,
    COL_RECEIVE_DATE,
    COL_REMARK,
    COL_SEQ,
    COL_TAX_CURRENCY,
    COL_TAX_DATE,
    COL_TAX_DPP_PEMASUKAN_NEGARA,
    COL_TAX_DPP_PPH21,
    COL_TAX_DPP_PPH23,
    COL_TAX_DPP_PPH26,
    COL_TAX_DPP_PPN,
    COL_TAX_INV_VALUE_USD,
    COL_TAX_RATE,
    COL_TAX_SEQ,
    COL_TAX_TRANS_VALUE,
    COL_TAX_TRANS_VALUE_IDR,
    COL_TAX_VALUE_PEMASUKAN_NEGARA,
    COL_TAX_VALUE_PPH21,
    COL_TAX_VALUE_PPH23,
    COL_TAX_VALUE_PPH26,
    COL_TAX_VALUE_PPN,
    COL_TRANSFER_FEE,
    COL_SUMBER_DANA,
    EXPENSE_DATA_TEMPLATE_ROW,
    EXPENSE_HEADER_TEMPLATE_ROW,
    EXPENSE_TEMPLATE_END,
    EXPENSE_TITLE_TEMPLATE_ROW,
    REVENUE_HEADER_ROW,
    REVENUE_SEPARATOR_TEMPLATE_ROW,
    TAX_DATA_TEMPLATE_ROW,
    TAX_HEADER_BOTTOM_TEMPLATE_ROW,
    TAX_HEADER_TOP_TEMPLATE_ROW,
    TAX_TITLE_TEMPLATE_ROW,
    TAX_TOTAL_TEMPLATE_ROW,
)
from services.reports.annual_service.caching import (
    _annual_cache_paths,
    _save_annual_payload_cache,
)
from services.reports.annual_service.annual_data import _build_annual_payload_from_db
from services.reports.annual_service.annual_excel import (
    _add_image_to_sheet,
    _apply_autofit_sheet1,
    _clone_row_format,
    _copy_template_row_from_backup,
    _ensure_formatted_secondary_sheets,
    _safe_merge_cells_sheet,
    _sync_formatted_secondary_sheets,
    _write_secondary_summary_sheets,
)
from services.reports.annual_service.annual_helpers import (
    REVENUE_START_ROW,
    REVENUE_TEMPLATE_END,
    ROW_HEIGHT_HEADER_VERTICAL,
    TAX_TEMPLATE_END,
    THIN_BORDER,
    _clear_merged_ranges_in_region,
    _root_category_info,
    _write_dynamic_category_headers,
)
from services.reports.annual_service.annual_tables import (
    _apply_manual_revenue_combine_groups,
    _apply_manual_tax_combine_groups,
    _build_annual_pdf_bytes,
    _expense_amount_for_display,
    _manual_combine_groups_by_table,
    _render_expense_section_from_data,
    _validate_revenue_data,
)
from utils.report_helpers import (
    _clean_currency,
    _clear_range,
    _clear_range_force,
    _default_report_year,
    _idr_from_currency,
    _merge_description_cell,
    _normalize_external_formula_refs,
    _parse_iso_date,
    _safe_set_cell,
    _safe_set_number,
    _safe_text,
    _set_date_with_format,
    _set_formula_with_format,
    _set_rows_hidden,
    _to_float,
)

logger = logging.getLogger(__name__)

def get_annual_report_excel(year=None, mode="report", sort_mode="kategori", start_date_str=None, end_date_str=None, company="EWI Foundation", force_refresh=False):
    """Generate and export annual report as an Excel file."""
    company = company or "EWI Foundation"
    year = _default_report_year() if year is None else year

    # Get and validate year parameter
    try:
        start_date = _parse_iso_date(start_date_str)
        end_date = _parse_iso_date(end_date_str)

        current_year = datetime.now().year
        # Allow year range from 2020 to 10 years in future (for planning/projection), and allow 0 for "All Years"
        if year != 0 and not (2020 <= year <= current_year + 10):
            # If mode is range, year can be null/invalid (fallback to 0), so we only validate if mode is not range
            if mode != "range":
                error_msg = f"Year must be between 2020 and {current_year + 10} or 0 for All Years"
                logger.error(f"Invalid year parameter: {year}")
                return JSONResponse(content={"error": error_msg}, status_code=400)
    except (TypeError, ValueError) as e:
        logger.error(f"Invalid year parameter: {e}")
        return JSONResponse(content={"error": "Invalid year parameter"}, status_code=400)

    logger.info(f"Starting Excel export for mode={mode}")

    # ? STEP 1: Check cache first
    cache_paths = _annual_cache_paths(year, sort_mode=sort_mode)
    excel_cache_path = cache_paths["excel"]
    # Always refresh if mode is actual or range (to avoid showing cached report data)
    if mode in ("actual", "range"):
        force_refresh = True

    if not force_refresh and os.path.exists(excel_cache_path):
        logger.info(f"Serving Excel from cache for year {year}")
        return FileResponse(
            excel_cache_path,
            filename=f"Laporan_Tahunan_{year}.xlsx",
            media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        )

    try:
        # Load data
        payload = _build_annual_payload_from_db(
            year=year,
            mode=mode,
            sort_mode=sort_mode,
            start_date=start_date,
            end_date=end_date,
            company=company,
        )
        _save_annual_payload_cache(year, payload)
        revenues = payload.get("revenue", {}).get("data", [])
        taxes = payload.get("tax", {}).get("data", [])
        expenses = payload.get("operation_cost", {}).get("data", [])
        assets = payload.get("assets", {}).get("data", [])
        bank_status = payload.get("bank_status", {}).get("data", [])

        logger.debug(
            f"Data loaded: {len(revenues)} revenues, {len(taxes)} taxes, {len(expenses)} expenses, {len(assets)} assets, {len(bank_status)} bank status"
        )

        # Load manual combine groups
        revenue_combine_groups = _manual_combine_groups_by_table(
            "revenues", year, company=company
        )
        tax_combine_groups = _manual_combine_groups_by_table(
            "taxes", year, company=company
        )

        # Get imported source name
        imported_source_name = None
        try:
            imported_source_name = db.session.execute(
                sql_text(
                    """SELECT source_excel FROM report_entry_tags
                   WHERE report_year = :year AND source_excel IS NOT NULL AND TRIM(source_excel) <> ''
                   ORDER BY imported_at DESC, id DESC LIMIT 1"""
                ),
                {"year": int(year)},
            ).scalar()
        except Exception:
            db.session.rollback()
            logger.debug("No imported source name found")

        template_dir = os.path.abspath(
            os.path.join(BASE_DIR, "..", "data", "excel")
        )

        template_candidates = []
        if imported_source_name:
            template_candidates.extend(
                [
                    os.path.abspath(os.path.join(template_dir, imported_source_name)),
                    os.path.abspath(
                        os.path.join(
                            BASE_DIR, "..", "data", imported_source_name
                        )
                    ),
                ]
            )
        template_candidates.extend(
            [
                os.path.abspath(
                    os.path.join(
                        template_dir, "Revenue-Cost_2024_cleaned_asli_cleaned.xlsx"
                    )
                ),
                os.path.abspath(
                    os.path.join(template_dir, "Revenue-Cost_2024_cleaned.xlsx")
                ),
            ]
        )
        template_path = next(
            (p for p in template_candidates if os.path.exists(p)),
            template_candidates[0],
        )

        logger.debug(f"Template path: {template_path}")

        if not os.path.exists(template_path):
            logger.error(f"Template not found: {template_path}")
            return JSONResponse(content={"error": f"Template tidak ditemukan: {template_path}"}, status_code=404)

        wb = load_workbook(template_path, keep_links=False)
        _normalize_external_formula_refs(wb)

        logger.debug("Template loaded, processing sheets")
        logger.debug("Keeping Excel tables from template for proper Alt+A behavior")

        # Hapus semua sheet Laba rugi yang lama dari template
        sheets_to_remove = [
            name for name in wb.sheetnames if name.startswith("Laba rugi -")
        ]
        for sheet_name in sheets_to_remove:
            del wb[sheet_name]

        # Cari dan rename sheet Revenue-Cost
        revenue_cost_sheet_name = next(
            (name for name in wb.sheetnames if name.startswith("Revenue-Cost")), None
        )
        sheet_suffix = "All" if year == 0 else str(year)
        if revenue_cost_sheet_name:
            ws = wb[revenue_cost_sheet_name]
            ws.title = f"Revenue-Cost_{sheet_suffix}"
        else:
            ws = wb.active
            ws.title = f"Revenue-Cost_{sheet_suffix}"

        # ? HILANGKAN GRIDLINES agar tampilan bersih putih polos
        ws.sheet_view.showGridLines = False

        # ? SET COLUMN WIDTHS matching reference Header_excel.xlsx
        ref_col_widths = {
            "A": 5.09,
            "B": 31.45,
            "C": 2.18,
            "D": 38.00,
            "E": 9.91,
            "F": 18.09,
            "G": 4.18,
            "H": 10.09,
            "I": 18.18,
            "J": 22.00,
            "K": 15.63,
            "L": 22.54,
            "M": 14.73,
            "N": 16.18,
            "O": 16.18,
            "P": 16.18,
            "Q": 18.00,
            "R": 18.00,
        }
        for letter, width in ref_col_widths.items():
            ws.column_dimensions[letter].width = width

        # ? CRITICAL: Backup template rows (23-41) to a hidden sheet BEFORE clearing
        # When revenue data has 300+ rows, it overwrites rows 23-41 which contain
        # separator, tax title, tax headers, expense title, and expense header templates.
        # By backing them up, _copy_template_row can always read pristine source data.
        TEMPLATE_BACKUP_ROWS = list(
            range(REVENUE_SEPARATOR_TEMPLATE_ROW, EXPENSE_DATA_TEMPLATE_ROW + 1)
        )  # rows 23-41
        backup_sheet_name = "_template_backup"
        if backup_sheet_name in wb.sheetnames:
            del wb[backup_sheet_name]
        ws_backup = wb.create_sheet(backup_sheet_name)
        ws_backup.sheet_state = "hidden"
        for src_row in TEMPLATE_BACKUP_ROWS:
            ws_backup.row_dimensions[src_row].height = ws.row_dimensions[src_row].height
            for col in range(1, 20):  # A-S (cols 1-19)
                src_cell = ws.cell(row=src_row, column=col)
                dst_cell = ws_backup.cell(row=src_row, column=col)
                if isinstance(src_cell, MergedCell):
                    continue
                dst_cell.value = copy(src_cell.value)
                dst_cell._style = copy(src_cell._style)
                dst_cell.number_format = src_cell.number_format
                dst_cell.font = copy(src_cell.font)
                dst_cell.fill = copy(src_cell.fill)
                dst_cell.border = copy(src_cell.border)
                dst_cell.alignment = copy(src_cell.alignment)
        # Also backup merged cell ranges in template rows
        for merged_range in list(ws.merged_cells.ranges):
            min_col, min_row, max_col, max_row = merged_range.bounds
            if min_row in TEMPLATE_BACKUP_ROWS and max_row in TEMPLATE_BACKUP_ROWS:
                try:
                    ws_backup.merge_cells(str(merged_range))
                except Exception:
                    pass

        # Update header document
        year_text = f"Tahun {year}" if year != 0 else "Semua Tahun"
        date_text = f"Januari - Desember {year}" if year != 0 else "Semua Periode"
        _safe_set_cell(ws, 2, 4, f"REVENUE vs OPERATION COST {year_text}")
        _safe_set_cell(ws, 3, 4, date_text)

        _safe_set_cell(ws, 5, 2, "REVENUE & TAX")
        ws.cell(row=5, column=2).font = Font(name="Arial", size=20, bold=True)
        _safe_set_cell(ws, 5, 14, "PAJAK PENGHASILAN")
        ws.cell(row=5, column=14).font = Font(name="Arial", size=18, bold=True)
        ws.cell(row=5, column=14).alignment = Alignment(
            horizontal="center", vertical="center"
        )

        # VALIDATE DATA BEFORE RENDER
        _validate_revenue_data(revenues)

        # RAPAPIKAN HEADER TABLE 1 (Revenue): parent/child baris 6-7
        rev_header_top = REVENUE_HEADER_ROW - 1  # row 6
        rev_header_bottom = REVENUE_HEADER_ROW  # row 7

        # -- Define fills matching reference exactly --
        theme6_fill = ws.cell(
            row=rev_header_top, column=2
        ).fill.copy()  # theme=6, tint=0.80
        yellow_fill_rev = PatternFill(
            start_color="FFFFFFCC", end_color="FFFFFFCC", fill_type="solid"
        )
        # theme=2/tint=-0.10 and theme=3/tint=0.80 are tricky via openpyxl; copy from template if present
        biaya_transfer_fill = (
            ws.cell(row=rev_header_top, column=15).fill.copy()
            if ws.cell(row=rev_header_top, column=15).fill.fill_type
            else theme6_fill
        )
        remark_fill = (
            ws.cell(row=rev_header_top, column=16).fill.copy()
            if ws.cell(row=rev_header_top, column=16).fill.fill_type
            else theme6_fill
        )

        # -- Row 6 (top header) -- Complete from reference --
        rev_top_headers = {
            # col: (value, font_name, font_size, fill, rotation)
            2: ("Invoice Date", "Arial", 12, theme6_fill, 0),
            3: ("#", "Arial", 12, theme6_fill, 0),
            4: ("Detail/Description", "Arial", 18, theme6_fill, 0),
            5: ("INVOICE VALUE", "Arial", 12, theme6_fill, 0),
            6: ("INVOICE VALUE", "Arial", 12, theme6_fill, 0),
            7: ("Currency", "Arial Narrow", 12, theme6_fill, 90),
            8: ("Currency\nExchange", "Arial Narrow", 12, theme6_fill, 90),
            9: ("INVOICE Number", "Arial", 12, theme6_fill, 0),
            10: ("Client", "Arial", 12, theme6_fill, 0),
            11: ("Receive Date", "Arial", 12, theme6_fill, 0),
            12: ("AMOUNT RECEIVED", "Arial", 12, theme6_fill, 0),
            13: ("AMOUNT RECEIVED", "Arial", 12, theme6_fill, 0),
            14: ("PPn", "Arial", 12, yellow_fill_rev, 0),
            15: ("PPH\n(Pasal 23)", "Arial", 12, yellow_fill_rev, 0),
            16: ("Biaya transfer", "Arial", 11, biaya_transfer_fill, 0),
            17: ("Remark", "Arial", 11, remark_fill, 0),
            18: ("Sumber Dana", "Arial", 11, theme6_fill, 0),
        }

        # -- Row 7 (sub-header) --
        rev_bot_headers = {
            # col: (value, font_name, font_size, fill, rotation)
            3: (None, "Arial", 12, theme6_fill, 0),
            4: (None, "Arial", 18, theme6_fill, 0),
            5: ("USD", "Arial", 10, theme6_fill, 0),
            6: ("IDR", "Arial", 10, theme6_fill, 0),
            7: (None, "Arial Narrow", 12, theme6_fill, 90),
            8: (None, "Arial Narrow", 12, theme6_fill, 90),
            9: (None, "Arial", 12, theme6_fill, 0),
            10: (None, "Arial", 12, theme6_fill, 0),
            11: (None, "Arial", 12, theme6_fill, 0),
            12: ("IDR", "Arial", 10, theme6_fill, 0),
            13: ("USD", "Arial", 10, theme6_fill, 0),
            14: (0.11, "Arial", 10, yellow_fill_rev, 0),
            15: (0.02, "Arial", 10, yellow_fill_rev, 0),
            16: (None, "Arial", 11, biaya_transfer_fill, 0),
            17: (None, "Arial", 11, remark_fill, 0),
            18: (None, "Arial", 11, theme6_fill, 0),
        }

        # Unmerge all existing merges in header rows to avoid conflicts
        for mr in list(ws.merged_cells.ranges):
            if mr.min_row >= rev_header_top and mr.max_row <= rev_header_bottom:
                try:
                    ws.unmerge_cells(str(mr))
                except Exception:
                    pass

        # Write top header row 6
        for col, (val, fname, fsize, fill, rot) in rev_top_headers.items():
            cell = ws.cell(row=rev_header_top, column=col)
            cell.value = val
            cell.font = Font(name=fname, size=fsize, bold=True)
            cell.fill = fill
            cell.alignment = Alignment(
                horizontal="center",
                vertical="center",
                wrap_text=True,
                text_rotation=rot,
            )
            cell.border = THIN_BORDER

        # Write sub-header row 7
        for col, (val, fname, fsize, fill, rot) in rev_bot_headers.items():
            cell = ws.cell(row=rev_header_bottom, column=col)
            cell.value = val
            cell.font = Font(name=fname, size=fsize, bold=True)
            cell.fill = fill
            cell.alignment = Alignment(
                horizontal="center",
                vertical="center",
                wrap_text=True if rot == 0 else True,
                text_rotation=rot,
            )
            cell.border = THIN_BORDER

        # Merges
        _safe_merge_cells_sheet(
            ws, rev_header_top, 5, rev_header_top, 6
        )  # INVOICE VALUE
        _safe_merge_cells_sheet(
            ws, rev_header_top, 12, rev_header_top, 13
        )  # AMOUNT RECEIVED

        # Merge vertical for single-value headers
        for col in [2, 3, 4, 7, 8, 9, 10, 11, 14, 15, 16, 17, 18]:
            _safe_merge_cells_sheet(ws, rev_header_top, col, rev_header_bottom, col)

        # Set row heights matching reference
        ws.row_dimensions[5].height = 25
        ws.row_dimensions[rev_header_top].height = 62
        ws.row_dimensions[rev_header_bottom].height = 15.5

        # Header utama Revenue sudah dirapikan

        # Clear data area - PRESERVE STYLE (Borders) for Sheet 1
        # ? FIX: Now safe to clear ENTIRE data zone because template rows are backed up
        template_max_data_row = max(ws.max_row, EXPENSE_TEMPLATE_END)
        # Clear data area (B-R) without resetting style to preserve font
        _clear_range_force(
            ws, REVENUE_START_ROW, template_max_data_row, 2, 18, reset_style=False
        )
        # Wipe styles for ghost columns (S-V)
        _clear_range_force(
            ws, REVENUE_START_ROW, template_max_data_row, 19, 22, reset_style=True
        )

        # Render revenue data
        row_cursor = REVENUE_START_ROW
        has_revenue_data = len(revenues) > 0
    except Exception as e:
        logger.error(f"Error during initial setup: {e}")
        raise

    if has_revenue_data:
        for idx, r in enumerate(revenues, 1):
            _clone_row_format(
                ws, REVENUE_START_ROW, row_cursor, start_col=2, end_col=20
            )

            invoice_value = _to_float(r.get("invoice_value"))
            inv_val_usd = _to_float(r.get("invoice_value_usd"))

            currency = _clean_currency(r.get("currency"))
            exchange = _to_float(r.get("currency_exchange"), 1) or 1

            # ? FIX: Fallback for legacy 2025 data where invoice_value_idr / amount_received_idr
            # columns are NULL. Mirrors the idr_invoice_value / idr_amount_received property logic.
            # NOTE: For non-IDR currencies, always multiply by exchange (even if exchange=1).
            raw_inv_val_idr = r.get("invoice_value_idr")
            if raw_inv_val_idr is not None:
                inv_val_idr = _to_float(raw_inv_val_idr)
            elif currency != "IDR":
                inv_val_idr = invoice_value * exchange
            else:
                inv_val_idr = invoice_value

            amount_received = _to_float(r.get("amount_received"))
            amt_recv_usd = _to_float(r.get("amount_received_usd"))

            raw_amt_recv_idr = r.get("amount_received_idr")
            if raw_amt_recv_idr is not None:
                amt_recv_idr = _to_float(raw_amt_recv_idr)
            elif currency != "IDR":
                amt_recv_idr = amount_received * exchange
            else:
                amt_recv_idr = amount_received

            p_ppn = _to_float(r.get("ppn"))
            p_pph23 = _to_float(r.get("pph_23"))
            transfer_fee = _to_float(r.get("transfer_fee"), 0)

            remark_from_db = _safe_text(r.get("remark"))
            if "inc.PPN11%" in remark_from_db or "inc. PPN11%" in remark_from_db:
                remark = ""
            else:
                remark = remark_from_db

            _set_date_with_format(ws, row_cursor, COL_DATE, r.get("invoice_date"))
            _safe_set_cell(ws, row_cursor, COL_SEQ, idx)

            description = r.get("description") or ""
            source = r.get("source") or ""
            combined_desc = (
                f"{description} ({source})"
                if source and source.strip()
                else description
            )
            _merge_description_cell(
                ws, row_cursor, combined_desc, col_start=4, col_end=4
            )

            _safe_set_number(ws, row_cursor, COL_INVOICE_VALUE_USD, inv_val_usd)
            _safe_set_number(ws, row_cursor, COL_INVOICE_VALUE_IDR, inv_val_idr)

            _safe_set_cell(ws, row_cursor, COL_CURRENCY, currency)
            _safe_set_number(ws, row_cursor, COL_EXCHANGE_RATE, exchange)

            invoice_num = r.get("invoice_number")
            if invoice_num and str(invoice_num).strip():
                _safe_set_cell(ws, row_cursor, COL_INVOICE_NUMBER, str(invoice_num))
            else:
                _safe_set_cell(ws, row_cursor, COL_INVOICE_NUMBER, "")

            _safe_set_cell(ws, row_cursor, COL_CLIENT, r.get("client") or "")
            _set_date_with_format(
                ws, row_cursor, COL_RECEIVE_DATE, r.get("receive_date")
            )
            _safe_set_number(ws, row_cursor, COL_AMOUNT_RECEIVED_IDR, amt_recv_idr)
            _safe_set_number(ws, row_cursor, COL_AMOUNT_RECEIVED_USD, amt_recv_usd)

            _safe_set_number(ws, row_cursor, COL_PPN, p_ppn)
            _safe_set_number(ws, row_cursor, COL_PPH_23, p_pph23)
            _safe_set_number(ws, row_cursor, COL_TRANSFER_FEE, transfer_fee)
            _safe_set_cell(ws, row_cursor, COL_REMARK, remark)
            sumber_dana = r.get("bank_name") or r.get("source") or ""
            _safe_set_cell(ws, row_cursor, COL_SUMBER_DANA, sumber_dana)
            ws.cell(row=row_cursor, column=COL_SUMBER_DANA).alignment = Alignment(
                horizontal="center", vertical="center"
            )

            # ? FIX: Explicitly apply THIN_BORDER to all data cells (Columns 2 to 18) to prevent missing borders from template cloning
            for c in range(2, 19):
                ws.cell(row=row_cursor, column=c).border = THIN_BORDER

            # Highlight kuning jika sumber dana (bank_id) belum dialokasikan / '-'
            if not r.get("bank_id") and not sumber_dana:
                yellow_fill = PatternFill(start_color="FFF9C4", end_color="FFF9C4", fill_type="solid")
                for c in range(2, 19):
                    ws.cell(row=row_cursor, column=c).fill = yellow_fill

            row_cursor += 1
    else:
        # ? No revenue data - show empty state message at row 8
        # ? FIX: Clone style FIRST, then clear and write
        _clone_row_format(ws, REVENUE_START_ROW, row_cursor, start_col=2, end_col=18)
        _clear_range_force(ws, row_cursor, row_cursor, 2, 18, reset_style=False)
        white_fill = PatternFill(fill_type="solid", fgColor="FFFFFF")
        for c in range(2, 19):
            cell = ws.cell(row=row_cursor, column=c)
            cell.border = THIN_BORDER
            cell.fill = white_fill

        # ? MERGE D for empty state message using helper
        _merge_description_cell(
            ws, row_cursor, "Belum ada data revenue dan pajak", col_start=4, col_end=4
        )
        cell = ws.cell(row=row_cursor, column=4)
        cell.font = cell.font.copy(italic=True, color="808080")
        cell.alignment = cell.alignment.copy(horizontal="center")
        row_cursor += 1

    # Apply manual combine revenue groups (after row rendering, before totals)
    if has_revenue_data:
        _apply_manual_revenue_combine_groups(
            ws,
            revenues,
            revenue_combine_groups,
            start_row=REVENUE_START_ROW,
        )

    # ? Calculate last & total row - SIMPLE
    # CEGAH RUMUS TERBALIK SAAT DATA KOSONG
    visible_revenue_rows = max(1, len(revenues))
    total_revenue_row = REVENUE_START_ROW + visible_revenue_rows
    last_revenue_row = total_revenue_row - 1

    # We will merge the title cell AFTER applying the borders so it doesn't get broken
    ws.cell(row=total_revenue_row, column=2).font = Font(bold=True)

    # ? Set total row with Excel formulas
    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_INVOICE_VALUE_USD,
        f"=SUM(E{REVENUE_START_ROW}:E{last_revenue_row})",
    )
    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_INVOICE_VALUE_IDR,
        f"=SUM(F{REVENUE_START_ROW}:F{last_revenue_row})",
    )

    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_AMOUNT_RECEIVED_IDR,
        f"=SUM(L{REVENUE_START_ROW}:L{last_revenue_row})",
    )
    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_AMOUNT_RECEIVED_USD,
        f"=SUM(M{REVENUE_START_ROW}:M{last_revenue_row})",
    )

    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_PPN,
        f"=SUM(N{REVENUE_START_ROW}:N{last_revenue_row})",
    )
    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_PPH_23,
        f"=SUM(O{REVENUE_START_ROW}:O{last_revenue_row})",
    )
    _set_formula_with_format(
        ws,
        total_revenue_row,
        COL_TRANSFER_FEE,
        f"=SUM(P{REVENUE_START_ROW}:P{last_revenue_row})",
    )

    # ? Style yellow for total row
    yellow_fill = PatternFill(
        start_color="FFFF00", end_color="FFFF00", fill_type="solid"
    )
    for col_idx in range(14, 19):  # Fill yellow up to column R (18)
        ws.cell(row=total_revenue_row, column=col_idx).fill = yellow_fill

    # Apply thin border to all columns in the total row to prevent missing lines
    for col_idx in range(2, 19):
        ws.cell(row=total_revenue_row, column=col_idx).border = THIN_BORDER

    # Clear extra borders to the right of Table 1 (Column S onwards, col 19+)
    no_border = Border(
        left=Side(style=None),
        right=Side(style=None),
        top=Side(style=None),
        bottom=Side(style=None),
    )
    no_fill = PatternFill(fill_type=None)
    for r in range(
        REVENUE_HEADER_ROW if "REVENUE_HEADER_ROW" in locals() else 6,
        total_revenue_row + 1,
    ):
        for c in range(19, 23):
            cell = ws.cell(row=r, column=c)
            cell.border = no_border
            cell.fill = no_fill

    # ? MERGE B8:D8 UNTUK TEKS REVENUE (IDR)
    _safe_merge_cells_sheet(ws, total_revenue_row, 2, total_revenue_row, 4)
    _safe_set_cell(ws, total_revenue_row, 2, "REVENUE (IDR)")
    ws.cell(row=total_revenue_row, column=2).alignment = Alignment(
        horizontal="right", vertical="center"
    )
    ws.cell(row=total_revenue_row, column=2).font = Font(
        name="Arial", size=10, bold=True
    )

    # ? Hide unused rows between total and template end
    if total_revenue_row < REVENUE_TEMPLATE_END:
        _set_rows_hidden(ws, total_revenue_row + 1, REVENUE_TEMPLATE_END, True)

    # ? FIX: Clear gap zone between revenue total and tax start to prevent ghost data
    gap_clear_end = max(TAX_TITLE_TEMPLATE_ROW - 1, total_revenue_row + 1)
    if total_revenue_row + 1 <= gap_clear_end:
        _clear_range_force(
            ws, total_revenue_row + 1, gap_clear_end, 2, 18, reset_style=False
        )

    # ? TABLE 2: PAJAK PENGELUARAN - ANCHOR TO STATC ROW 24
    # Calculate starting row for Table 2. If Table 1 is huge, we shift down.
    # Otherwise, we stay at TAX_TITLE_TEMPLATE_ROW (24).
    revenue_gap_row = total_revenue_row + 1
    tax_title_row = max(TAX_TITLE_TEMPLATE_ROW, total_revenue_row + 2)
    tax_header_top_row = tax_title_row + 1
    tax_header_row = tax_title_row + 2
    tax_start_row = tax_title_row + 3

    _copy_template_row_from_backup(
        ws_backup,
        ws,
        REVENUE_SEPARATOR_TEMPLATE_ROW,
        revenue_gap_row,
        start_col=2,
        end_col=18,
        include_values=True,
    )
    _clear_range(ws, revenue_gap_row, revenue_gap_row, 2, 18)
    _set_rows_hidden(ws, revenue_gap_row, revenue_gap_row, False)

    _copy_template_row_from_backup(
        ws_backup,
        ws,
        TAX_TITLE_TEMPLATE_ROW,
        tax_title_row,
        start_col=2,
        end_col=19,
        include_values=True,
    )
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        TAX_HEADER_TOP_TEMPLATE_ROW,
        tax_header_top_row,
        start_col=2,
        end_col=19,
        include_values=True,
    )
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        TAX_HEADER_BOTTOM_TEMPLATE_ROW,
        tax_header_row,
        start_col=2,
        end_col=19,
        include_values=True,
    )

    # -- WRITE TABLE 2 HEADERS EXPLICITLY (matching reference Header_excel.xlsx) --
    theme6_fill_tax = ws.cell(row=tax_header_top_row, column=2).fill.copy()
    yellow_fill_tax = PatternFill(
        start_color="FFFFFFCC", end_color="FFFFFFCC", fill_type="solid"
    )

    # Unmerge existing merges in tax header rows
    for mr in list(ws.merged_cells.ranges):
        if mr.min_row >= tax_header_top_row and mr.max_row <= tax_header_row:
            try:
                ws.unmerge_cells(str(mr))
            except Exception:
                pass

    # Row: tax_header_top_row (top header)
    tax_top = {
        # col: (value, font_name, font_size, fill, rotation)
        2: ("Date", "Arial", 12, theme6_fill_tax, 0),
        3: ("#", "Arial", 12, theme6_fill_tax, 0),
        4: ("Detail/Description", "Arial", 18, theme6_fill_tax, 0),
        5: ("INVOICE VALUE", "Arial", 12, theme6_fill_tax, 0),
        6: ("Transaction Value", "Arial", 12, theme6_fill_tax, 0),
        7: ("Currency", "Arial Narrow", 12, theme6_fill_tax, 90),
        8: ("Currency\nExchange", "Arial Narrow", 12, theme6_fill_tax, 90),
        9: ("Transaction Value", "Arial", 12, theme6_fill_tax, 0),
        10: ("PPN", "Arial", 16, yellow_fill_tax, 0),
        # 11 merged with 10
        12: ("PPh (pasal 21)", "Arial", 16, yellow_fill_tax, 0),
        # 13 merged with 12
        14: ("PPh (pasal 23)", "Arial", 16, yellow_fill_tax, 0),
        # 15 merged with 14
        16: ("PPh (pasal 26)", "Arial", 16, yellow_fill_tax, 0),
        # 17 merged with 16
        18: ("Pemasukan Negara (pasal ???)", "Arial", 16, yellow_fill_tax, 0),
        # 19 merged with 18
    }

    # Row: tax_header_row (sub-header)
    tax_bot = {
        3: (None, "Arial", 12, theme6_fill_tax, 0),
        4: (None, "Arial", 18, theme6_fill_tax, 0),
        5: ("USD", "Arial", 10, theme6_fill_tax, 0),
        6: (None, "Arial", 10, theme6_fill_tax, 0),
        7: (None, "Arial Narrow", 12, theme6_fill_tax, 90),
        8: (None, "Arial Narrow", 12, theme6_fill_tax, 90),
        9: ("IDR", "Arial", 10, theme6_fill_tax, 0),
        10: ("Transaction", "Arial", 10, yellow_fill_tax, 0),
        11: ("PPN", "Arial", 10, yellow_fill_tax, 0),
        12: ("Transaction", "Arial", 10, yellow_fill_tax, 0),
        13: ("PPh - 21", "Arial", 10, yellow_fill_tax, 0),
        14: ("Transaction", "Arial", 10, yellow_fill_tax, 0),
        15: ("PPh - 23", "Arial", 10, yellow_fill_tax, 0),
        16: ("Transaction", "Arial", 10, yellow_fill_tax, 0),
        17: ("PPh - 26", "Arial", 10, yellow_fill_tax, 0),
        18: ("Transaction", "Arial", 10, yellow_fill_tax, 0),
        19: ("Pajak", "Arial", 10, yellow_fill_tax, 0),
    }

    # Write top header
    for col, (val, fname, fsize, fill, rot) in tax_top.items():
        cell = ws.cell(row=tax_header_top_row, column=col)
        cell.value = val
        cell.font = Font(name=fname, size=fsize, bold=True)
        cell.fill = fill
        cell.alignment = Alignment(
            horizontal="center", vertical="center", wrap_text=True, text_rotation=rot
        )
        cell.border = THIN_BORDER

    # Write sub-header
    for col, (val, fname, fsize, fill, rot) in tax_bot.items():
        cell = ws.cell(row=tax_header_row, column=col)
        cell.value = val
        cell.font = Font(name=fname, size=fsize, bold=True)
        cell.fill = fill
        cell.alignment = Alignment(
            horizontal="center", vertical="center", wrap_text=True, text_rotation=rot
        )
        cell.border = THIN_BORDER

    # Merges for Table 2 headers
    # Vertical merges (single-header columns spanning both rows)
    for col in [2, 3, 4, 6, 7, 8]:
        _safe_merge_cells_sheet(ws, tax_header_top_row, col, tax_header_row, col)
    # Horizontal merges for parent tax groups (top row only)
    for start_col, end_col in [(10, 11), (12, 13), (14, 15), (16, 17), (18, 19)]:
        _safe_merge_cells_sheet(
            ws, tax_header_top_row, start_col, tax_header_top_row, end_col
        )

    # Set row heights
    ws.row_dimensions[tax_header_top_row].height = 53.5
    ws.row_dimensions[tax_header_row].height = 14.5

    _safe_set_cell(ws, tax_title_row, 2, "PAJAK PENGELUARAN")
    _set_rows_hidden(ws, tax_title_row, tax_header_row, False)

    # ? Clear data area - UNMERGE D:E FIRST (from template), then clear values
    # This is CRITICAL to remove existing merge from template before rendering
    # ? FIX: Clear a larger buffer (e.g., 100 rows) to ensure no ghost data remains from previous exports
    tax_clear_count = max(100, len(taxes) + 20)
    white_fill = PatternFill(fill_type="solid", fgColor="FFFFFF")
    for idx in range(tax_clear_count):
        row = tax_start_row + idx
        # Only clear if we are still within reasonable sheet bounds
        if row > ws.max_row + 100:
            break

        _copy_template_row_from_backup(
            ws_backup,
            ws,
            TAX_DATA_TEMPLATE_ROW,
            row,
            start_col=2,
            end_col=19,
            include_values=False,
        )
        # Unmerge D:E first (from template)
        try:
            ws.unmerge_cells(f"D{row}:E{row}")
        except Exception:
            pass
        # Clear all columns B-S (2-19)
        for col in range(2, 20):
            cell = ws.cell(row=row, column=col)
            if not isinstance(cell, MergedCell):
                cell.value = None
                cell.border = THIN_BORDER
                cell.fill = white_fill

    # ? FIX: Remove 10-row cap - render ALL tax rows
    visible_tax_rows = max(1, len(taxes))

    # Render tax rows dynamically with merged D:E columns
    for idx, t in enumerate(taxes):
        row = tax_start_row + idx

        _set_date_with_format(ws, row, COL_TAX_DATE, t.get("date"))
        _safe_set_cell(ws, row, COL_TAX_SEQ, idx + 1)

        # ? MERGE D for TAX description using helper
        description = t.get("description") or ""
        _merge_description_cell(ws, row, description, col_start=4, col_end=4)

        # Get tax values
        trans_val = _to_float(t.get("transaction_value"))
        inv_val_usd = _to_float(t.get("invoice_value_usd"))

        ppn_val = _to_float(t.get("ppn"))
        pph_21_val = _to_float(t.get("pph_21"))
        pph_23_val = _to_float(t.get("pph_23"))
        pph_26_val = _to_float(t.get("pph_26"))

        _safe_set_number(ws, row, COL_TAX_TRANS_VALUE, trans_val)
        _safe_set_number(ws, row, COL_TAX_INV_VALUE_USD, inv_val_usd)

        _safe_set_cell(ws, row, COL_TAX_CURRENCY, _clean_currency(t.get("currency")))
        _safe_set_number(
            ws, row, COL_TAX_RATE, _to_float(t.get("currency_exchange"), default=1) or 1
        )

        # ? Calculate Trans Value IDR (Priority on transaction_value_idr from 2026 schema)
        saved_idr = _to_float(t.get("transaction_value_idr"))
        if saved_idr is not None:
            trans_val_idr = saved_idr
        else:
            trans_val_idr = _idr_from_currency(
                t.get("transaction_value"),
                t.get("currency"),
                t.get("currency_exchange"),
            )

        # Show IDR value consistently to match frontend totals and ensure SUM() works correctly
        _safe_set_number(ws, row, COL_TAX_TRANS_VALUE_IDR, trans_val_idr)

        # ? Set DPP & Value ONLY for tax that has value (not all columns!)
        ppn_base = _to_float(t.get("ppn_base"))
        pph_21_base = _to_float(t.get("pph_21_base"))
        pph_23_base = _to_float(t.get("pph_23_base"))
        pph_26_base = _to_float(t.get("pph_26_base"))
        pem_neg_val = _to_float(t.get("pemasukan_negara"))
        pem_neg_base = _to_float(t.get("pemasukan_negara_base"))

        if ppn_val > 0:
            _safe_set_number(ws, row, COL_TAX_DPP_PPN, ppn_base)
            _safe_set_number(ws, row, COL_TAX_VALUE_PPN, ppn_val)

        if pph_21_val > 0:
            _safe_set_number(ws, row, COL_TAX_DPP_PPH21, pph_21_base)
            _safe_set_number(ws, row, COL_TAX_VALUE_PPH21, pph_21_val)

        if pph_23_val > 0:
            _safe_set_number(ws, row, COL_TAX_DPP_PPH23, pph_23_base)
            _safe_set_number(ws, row, COL_TAX_VALUE_PPH23, pph_23_val)

        if pph_26_val > 0:
            _safe_set_number(ws, row, COL_TAX_DPP_PPH26, pph_26_base)
            _safe_set_number(ws, row, COL_TAX_VALUE_PPH26, pph_26_val)

        if pem_neg_val > 0:
            _safe_set_number(ws, row, COL_TAX_DPP_PEMASUKAN_NEGARA, pem_neg_base)
            _safe_set_number(ws, row, COL_TAX_VALUE_PEMASUKAN_NEGARA, pem_neg_val)

        # ? FIX: Explicitly apply THIN_BORDER to all data cells (Columns 2 to 19) to prevent missing borders from template cloning
        for col_idx in range(2, 20):
            ws.cell(row=row, column=col_idx).border = THIN_BORDER

    # Apply merge cells if any (BEFORE hide)
    _apply_manual_tax_combine_groups(
        ws,
        taxes[:visible_tax_rows] if taxes else [],
        tax_combine_groups,
        start_row=tax_start_row,
    )

    # Handle no tax data
    if not taxes:
        # ? FIX: Clone style FIRST, then write
        _copy_template_row_from_backup(
            ws_backup,
            ws,
            TAX_DATA_TEMPLATE_ROW,
            tax_start_row,
            start_col=2,
            end_col=19,
            include_values=False,
        )

        # Clear any merges copied from the template in columns D:E before writing
        _clear_merged_ranges_in_region(ws, tax_start_row, tax_start_row, 4, 5)

        # ? MERGE D for empty state message using helper
        _merge_description_cell(
            ws, tax_start_row, "Belum ada data pajak", col_start=4, col_end=4
        )
        cell = ws.cell(row=tax_start_row, column=4)
        cell.font = cell.font.copy(italic=True, color="808080")
        cell.alignment = cell.alignment.copy(horizontal="center")
        _safe_set_cell(ws, tax_start_row, 7, "IDR")
        _safe_set_number(ws, tax_start_row, 8, 1)
        # Apply borders to empty row
        for col in range(2, 20):
            cell = ws.cell(row=tax_start_row, column=col)
            cell.border = THIN_BORDER
        visible_tax_rows = 1

    # ? FIX #2: TOTAL ROW MUST BE ADJACENT TO DATA (not hardcoded row 37!)
    total_tax_row = tax_start_row + visible_tax_rows
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        TAX_TOTAL_TEMPLATE_ROW,
        total_tax_row,
        start_col=2,
        end_col=19,
        include_values=False,
    )

    # ? FIX #3: Use EXCEL FORMULAS (not hardcoded values)
    last_tax_data_row = total_tax_row - 1

    # ? MERGE B:H for "PENERIMAAN NEGARA (TAX) (IDR)" text
    merge_range_tax = f"B{total_tax_row}:H{total_tax_row}"
    _safe_merge_cells_sheet(ws, total_tax_row, 2, total_tax_row, 8)
    _safe_set_cell(ws, total_tax_row, 2, "PENERIMAAN NEGARA (TAX) (IDR)")
    ws.cell(row=total_tax_row, column=2).alignment = Alignment(
        horizontal="right", vertical="center"
    )
    ws.cell(row=total_tax_row, column=2).font = Font(bold=True)

    _set_formula_with_format(
        ws, total_tax_row, 9, f"=SUM(I{tax_start_row}:I{last_tax_data_row})"
    )  # Total Transaction Value IDR
    _set_formula_with_format(
        ws, total_tax_row, 11, f"=SUM(K{tax_start_row}:K{last_tax_data_row})"
    )  # Total PPN
    _set_formula_with_format(
        ws, total_tax_row, 13, f"=SUM(M{tax_start_row}:M{last_tax_data_row})"
    )  # Total PPh 21
    _set_formula_with_format(
        ws, total_tax_row, 15, f"=SUM(O{tax_start_row}:O{last_tax_data_row})"
    )  # Total PPh 23
    _set_formula_with_format(
        ws, total_tax_row, 17, f"=SUM(Q{tax_start_row}:Q{last_tax_data_row})"
    )  # Total PPh 26
    _set_formula_with_format(
        ws, total_tax_row, 19, f"=SUM(S{tax_start_row}:S{last_tax_data_row})"
    )  # Total Pemasukan Negara

    # Bold total row
    for col in range(2, 20):
        ws.cell(row=total_tax_row, column=col).font = Font(bold=True)
        ws.cell(row=total_tax_row, column=col).border = THIN_BORDER
        if col in (9, 11, 13, 15, 17, 19):
            ws.cell(row=total_tax_row, column=col).fill = yellow_fill_tax

    # ? FIX: Only hide/clear template rows between tax total and TAX_TEMPLATE_END
    # if data hasn't already spilled past that boundary.
    # Previously this ALWAYS wiped row 37 (TAX_TEMPLATE_END) unconditionally,
    # which deleted Revenue data row 30 (REVENUE_START_ROW 8 + 29 = row 37)!
    if total_tax_row < TAX_TEMPLATE_END:
        _set_rows_hidden(ws, total_tax_row + 1, TAX_TEMPLATE_END, True)
        _clear_range_force(
            ws, total_tax_row + 1, TAX_TEMPLATE_END, 2, 20, reset_style=True
        )

    # ? TABLE 2.5: BANK STATUS
    # We want a 2-line gap: total_tax_row + 1 and total_tax_row + 2. So title starts at + 3.
    bank_title_row_candidate = max(EXPENSE_TITLE_TEMPLATE_ROW, total_tax_row + 3)
    bank_title_row = bank_title_row_candidate

    # Ensure exactly 2 gap rows are visible and cleared
    _set_rows_hidden(ws, total_tax_row + 1, total_tax_row + 2, False)
    _clear_range_force(
        ws, total_tax_row + 1, total_tax_row + 2, 2, 20, reset_style=True
    )

    # Hide any stray rows between the 2 gap rows and the bank title
    if total_tax_row + 3 < bank_title_row:
        _set_rows_hidden(ws, total_tax_row + 3, bank_title_row - 1, True)

    bank_header_row1 = bank_title_row + 1
    bank_header_row2 = bank_title_row + 2
    bank_start_row = bank_title_row + 3

    # Use theme 6 fill for Bank Status headers to match Table 1 & 2
    theme6_fill_bank = ws.cell(row=REVENUE_HEADER_ROW - 1, column=2).fill.copy()

    # Set Bank Status Title
    ws.row_dimensions[bank_title_row].height = 30
    for col in range(2, 7):
        cell = ws.cell(row=bank_title_row, column=col)
        cell.border = Border(
            left=Side(style=None),
            right=Side(style=None),
            top=Side(style=None),
            bottom=Side(style=None),
        )
        cell.fill = PatternFill(fill_type=None)

    _safe_merge_cells_sheet(ws, bank_title_row, 2, bank_title_row, 5)
    _safe_set_cell(ws, bank_title_row, 2, "BANK Status")
    ws.cell(row=bank_title_row, column=2).font = Font(bold=True, size=20, name="Arial")
    ws.cell(row=bank_title_row, column=2).alignment = Alignment(vertical="center")

    # Set Headers with Reference Styling
    # Row 1 (bank_header_row1)
    _safe_set_cell(ws, bank_header_row1, 2, "Invoice Date")
    ws.cell(row=bank_header_row1, column=2).font = Font(
        name="Arial", size=12, bold=True
    )
    _safe_set_cell(ws, bank_header_row1, 3, "#")
    ws.cell(row=bank_header_row1, column=3).font = Font(
        name="Arial", size=12, bold=True
    )
    _safe_set_cell(ws, bank_header_row1, 4, "Detail/Description")
    ws.cell(row=bank_header_row1, column=4).font = Font(
        name="Arial", size=18, bold=True
    )
    _safe_set_cell(ws, bank_header_row1, 5, "Value")
    ws.cell(row=bank_header_row1, column=5).font = Font(
        name="Arial", size=12, bold=True
    )
    _safe_set_cell(ws, bank_header_row1, 6, "Value")
    ws.cell(row=bank_header_row1, column=6).font = Font(
        name="Arial", size=12, bold=True
    )

    # Row 2 (bank_header_row2)
    _safe_set_cell(ws, bank_header_row2, 5, "USD")
    ws.cell(row=bank_header_row2, column=5).font = Font(
        name="Arial", size=12, bold=True
    )
    _safe_set_cell(ws, bank_header_row2, 6, "IDR")
    ws.cell(row=bank_header_row2, column=6).font = Font(
        name="Arial", size=12, bold=True
    )

    # Apply fills, alignment, borders, and merges
    for c in range(2, 7):
        # Row 1
        cell1 = ws.cell(row=bank_header_row1, column=c)
        cell1.fill = theme6_fill_bank
        cell1.border = THIN_BORDER
        cell1.alignment = Alignment(
            horizontal="center", vertical="center", wrap_text=True
        )
        # Row 2
        cell2 = ws.cell(row=bank_header_row2, column=c)
        cell2.fill = theme6_fill_bank
        cell2.border = THIN_BORDER
        cell2.alignment = Alignment(
            horizontal="center", vertical="center", wrap_text=True
        )

    # Vertical merges for B, C, D
    _safe_merge_cells_sheet(ws, bank_header_row1, 2, bank_header_row2, 2)
    _safe_merge_cells_sheet(ws, bank_header_row1, 3, bank_header_row2, 3)
    _safe_merge_cells_sheet(ws, bank_header_row1, 4, bank_header_row2, 4)
    # Horizontal merge for Value top header
    _safe_merge_cells_sheet(ws, bank_header_row1, 5, bank_header_row1, 6)

    # Set row heights
    ws.row_dimensions[bank_header_row1].height = 25
    ws.row_dimensions[bank_header_row2].height = 15.5

    row_cursor = bank_start_row
    if bank_status:
        for group in bank_status:
            gn = group.get("group_name") or "Lain-lain"
            _safe_set_cell(ws, row_cursor, 4, gn)
            ws.cell(row=row_cursor, column=4).font = Font(
                bold=False, size=12, name="Arial"
            )
            for c in range(2, 7):
                ws.cell(row=row_cursor, column=c).fill = theme6_fill_bank
                ws.cell(row=row_cursor, column=c).border = THIN_BORDER
            row_cursor += 1

            for idx, item in enumerate(group.get("items", [])):
                _set_date_with_format(ws, row_cursor, 2, item.get("date"))
                _safe_set_cell(ws, row_cursor, 3, str(idx + 1))
                _safe_set_cell(ws, row_cursor, 4, item.get("description"))
                _safe_set_number(ws, row_cursor, 5, item.get("amount_usd"))
                _safe_set_number(ws, row_cursor, 6, item.get("amount_idr"))
                
                # Apply precise alignments and formatting
                ws.cell(row=row_cursor, column=2).alignment = Alignment(horizontal="center", vertical="center")
                ws.cell(row=row_cursor, column=3).alignment = Alignment(horizontal="center", vertical="center")
                ws.cell(row=row_cursor, column=4).alignment = Alignment(horizontal="left", vertical="center")
                ws.cell(row=row_cursor, column=5).alignment = Alignment(horizontal="right", vertical="center")
                ws.cell(row=row_cursor, column=6).alignment = Alignment(horizontal="right", vertical="center")
                
                font_regular = Font(size=11, name="Arial")
                for c in range(2, 7):
                    ws.cell(row=row_cursor, column=c).border = THIN_BORDER
                    ws.cell(row=row_cursor, column=c).font = font_regular
                row_cursor += 1
    else:
        # Add empty message row
        white_fill = PatternFill(fill_type="solid", fgColor="FFFFFF")
        ws.row_dimensions[row_cursor].height = (
            ws.row_dimensions[bank_start_row].height
            if bank_start_row in ws.row_dimensions
            else 15
        )
        for col in range(2, 7):
            cell = ws.cell(row=row_cursor, column=col)
            cell.fill = white_fill
            cell.border = THIN_BORDER
        _safe_set_cell(ws, row_cursor, 4, "Belum ada bank status")
        ws.cell(row=row_cursor, column=4).font = Font(
            italic=True, size=12, name="Arial Narrow", color="808080"
        )
        ws.cell(row=row_cursor, column=4).alignment = Alignment(
            horizontal="center", vertical="center"
        )
        _safe_merge_cells_sheet(ws, row_cursor, 4, row_cursor, 4)
        row_cursor += 1

    bank_total_row = row_cursor
    _safe_merge_cells_sheet(ws, bank_total_row, 2, bank_total_row, 4)
    _safe_set_cell(ws, bank_total_row, 2, "TOTAL BANK STATUS (IDR)")
    ws.cell(row=bank_total_row, column=2).font = Font(bold=True)
    ws.cell(row=bank_total_row, column=2).alignment = Alignment(horizontal="right")
    _set_formula_with_format(
        ws, bank_total_row, 6, f"=SUM(F{bank_start_row}:F{row_cursor - 1})"
    )
    for c in range(2, 7):
        ws.cell(row=bank_total_row, column=c).fill = PatternFill(
            start_color="FFFF00", end_color="FFFF00", fill_type="solid"
        )
        ws.cell(row=bank_total_row, column=c).border = THIN_BORDER
        ws.cell(row=bank_total_row, column=c).font = Font(bold=True)

    # ? CRITICAL FIX: Clear ghost borders from template in columns G to T (7 to 20) for all Bank Status rows
    no_fill = PatternFill(fill_type=None)
    no_border = Border(
        left=Side(style=None),
        right=Side(style=None),
        top=Side(style=None),
        bottom=Side(style=None),
    )
    for r in range(bank_title_row, bank_total_row + 1):
        for c in range(7, 21):
            cell = ws.cell(row=r, column=c)
            cell.fill = no_fill
            cell.border = no_border

    # ? TABLE 3: PENGELUARAN - ANCHOR TO BANK TOTAL
    expense_title_row = bank_total_row + 3
    expense_header_row = expense_title_row + 1
    expense_start_row = expense_title_row + 2

    # Clear the 2 gap rows to ensure NO ghost borders
    _clear_range_force(
        ws, bank_total_row + 1, expense_title_row - 1, 2, 20, reset_style=True
    )
    _set_rows_hidden(ws, bank_total_row + 1, expense_title_row - 1, False)

    # Clear ghost borders to the right of Pengeluaran (Columns O onwards) for title/header
    _clear_range_force(
        ws, expense_title_row, expense_header_row, 15, 40, reset_style=True
    )
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        EXPENSE_TITLE_TEMPLATE_ROW,
        expense_title_row,
        start_col=2,
        end_col=17,
        include_values=True,
    )
    _safe_set_cell(ws, expense_title_row, 2, "PENGELUARAN")
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        EXPENSE_HEADER_TEMPLATE_ROW,
        expense_header_row,
        start_col=2,
        end_col=17,
        include_values=True,
    )
    _safe_set_cell(ws, expense_header_row, 6, "Jumlah")
    _safe_set_cell(ws, expense_header_row, 7, "Currency")
    _safe_set_cell(ws, expense_header_row, 8, "currency Exchange")
    _copy_template_row_from_backup(
        ws_backup,
        ws,
        EXPENSE_DATA_TEMPLATE_ROW,
        expense_start_row,
        start_col=2,
        end_col=17,
        include_values=False,
    )
    _set_rows_hidden(ws, expense_title_row, expense_start_row, False)

    # Fetch root categories dynamically from DB - ORDER BY sort_order (from Kategori Tabular)
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

    # If NO categories have data, fallback to a default
    if not root_cats:
        from collections import namedtuple

        DummyCat = namedtuple("DummyCat", ["name", "code"])
        root_cats = [DummyCat("OPERATION COST AND OFFICE", "-")]

    cat_names = [c.name for c in root_cats]  # for mapping

    _write_dynamic_category_headers(ws, root_cats, header_row=expense_header_row)

    # ? FIX: Override font for Expense header row (row 40) to match reference
    for col in range(2, 9):  # Columns B to H
        cell = ws.cell(row=expense_header_row, column=col)
        if not isinstance(cell, MergedCell):
            if col == 2:  # Date
                cell.font = Font(bold=True, size=16, name="Arial")
            elif col in (3, 4, 5, 6):  # #, Activity, Source, Jumlah
                cell.font = Font(bold=True, size=16, name="Arial Narrow")
            else:  # Currency, Currency Exchange
                cell.font = Font(bold=True, size=12, name="Arial Narrow")

            # Default alignment: center
            cell.alignment = Alignment(
                horizontal="center", vertical="center", wrap_text=False
            )

    # ? FIX: Set vertical text for Source (E=5), Currency (G=7), Currency Exchange (H=8)
    for col_idx in (5, 7, 8):  # E, G, H
        cell = ws.cell(row=expense_header_row, column=col_idx)
        if not isinstance(cell, MergedCell):
            rot = 90 if col_idx in (7, 8) else 180  # Source is rotated 180, others 90
            cell.alignment = Alignment(
                horizontal="center",
                vertical="center",
                text_rotation=rot,
                wrap_text=True,
            )

    # FIX: Set row height for header row to accommodate vertical text and wrapped category headers
    ws.row_dimensions[expense_header_row].height = ROW_HEIGHT_HEADER_VERTICAL

    # Define last_category_col for use below
    last_category_col = 9 + len(cat_names) - 1

    # TABLE 3: PENGELUARAN & OPERATION COST
    # Stamp category_sort_order so _group_expenses_by_subcategory sorts by Category Tabular order
    root_sort_map = {c.name: (c.sort_order or 999) for c in root_cats_all}
    for e in expenses:
        r_name, _ = _root_category_info(e.get("category_id"), category_by_id_map)
        e["category_sort_order"] = root_sort_map.get(r_name or "", 999)

    logger.debug(f"Rendering Table 3 (Expenses) starting at row {expense_start_row}")
    total_row = _render_expense_section_from_data(
        ws, expenses, cat_names, category_by_id_map, year, start_row=expense_start_row, sort_mode=sort_mode
    )
    logger.debug(f"Table 3 rendered up to row {total_row}")

    # ? CRITICAL FIX: Clear ghost borders from template dynamically, preserving actual category columns and Sub total/Total/From/To
    last_cat_col = 9 + len(cat_names) - 1
    _clear_range_force(
        ws,
        expense_start_row,
        total_row + 5,
        last_cat_col + 5,
        max(30, last_cat_col + 15),
        reset_style=True,
    )

    # ? FIX: Wipe any leftover template rows below the last table to remove stray numbers
    if ws.max_row > total_row:
        _clear_range_force(ws, total_row + 1, ws.max_row, 1, 30, reset_style=True)
        _set_rows_hidden(ws, total_row + 1, ws.max_row, True)

    # Section below Table 3 removed (Bank Status & Asset Register)

    # ? ALIGNED BRANDING & MERGED SIGNATURES
    logo_path = os.path.abspath(
        os.path.join(
            BASE_DIR, "..", "frontend", "assets", "images", "sheet1.png"
        )
    )

    # Clear ALL images from template to start fresh
    ws._images.clear()

    # Top Logo - Presisi agar terlihat rata kanan di kolom Q
    # Kita ikat di 'P1' agar gambar membentang menutupi P dan berakhir di ujung Q
    _add_image_to_sheet(ws, logo_path, "O1", width=308, height=78)

    # ? FOOTER IMAGE REMOVED (As requested)

    # ? APPLY AUTOFIT TO SHEET 1
    # Use last_category_col + 4 to define the range of columns to autofit (including Sub total, Total, From & To)
    _apply_autofit_sheet1(ws, last_category_col + 4)

    # DO NOT REMOVE TABLES - Keep template structure intact
    logger.debug("Keeping Excel tables for proper Alt+A behavior")

    sheet_suffix = "All" if year == 0 else str(year)
    final_main_sheet_name = f"Revenue-Cost_{sheet_suffix}"
    if ws.title != final_main_sheet_name:
        ws.title = final_main_sheet_name
        logger.debug(f"Renamed sheet to {final_main_sheet_name}")

    has_formatted_secondary = _ensure_formatted_secondary_sheets(wb, year, template_dir)
    if has_formatted_secondary:
        # ? CASE 1: Template found (Preferred) - Use sophisticated side-by-side logic
        _sync_formatted_secondary_sheets(
            wb,
            payload,
            year,
            final_main_sheet_name,
            expense_total_row=total_row,
            revenue_last_row=last_revenue_row,
            company=company,
        )
    else:
        # ? CASE 2: No template found - Fallback to basic monthly summary
        logger.warning(
            "Excel template not found - falling back to basic summary sheets"
        )
        _write_secondary_summary_sheets(
            wb,
            payload,
            year,
            final_main_sheet_name,
            expense_total_row=total_row,
            revenue_last_row=last_revenue_row,
        )

    try:
        wb.calculation.calcMode = "auto"
        wb.calculation.fullCalcOnLoad = True
        wb.calculation.forceFullCalc = True
    except Exception as e:
        logger.warning(f"Failed to set calculation mode: {e}")

    # ? Cleanup: Remove backup template sheet before saving
    if backup_sheet_name in wb.sheetnames:
        del wb[backup_sheet_name]

    logger.info("Export completed, sending file")

    # CRITICAL: Error handling for Excel save and send
    try:
        buffer = BytesIO()
        wb.save(buffer)
        buffer.seek(0)
        if mode == "range" and start_date and end_date:
            filename = f"Revenue-Cost_{start_date.strftime('%Y%m%d')}-{end_date.strftime('%Y%m%d')}.xlsx"
        else:
            sheet_suffix = "All" if year == 0 else str(year)
            filename = f"Revenue-Cost_{sheet_suffix}.xlsx"
        return StreamingResponse(
            buffer,
            media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            headers={"Content-Disposition": f'attachment; filename="{filename}"'},
        )
    except Exception as e:
        logger.error(f"ERROR: Failed to save/export Excel: {e}")
        wb.close()
        raise

