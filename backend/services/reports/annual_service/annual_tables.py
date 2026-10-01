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
from .annual_constants import (
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
from .annual_helpers import (
    BLUE_FILL,
    GREEN_FILL,
    REVENUE_START_ROW,
    REVENUE_TEMPLATE_END,
    THIN_BORDER,
    _clear_merged_ranges_in_region,
    _root_category_info,
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

from services.reports.table_builder.pdf_builder import _build_annual_pdf_bytes
from services.reports.table_builder.expense_renderer_utils import _expense_column_mapping_name, _expense_amount_for_display, _expense_subcategory_label, _group_expenses_by_subcategory
from services.reports.table_builder.expense_renderer import _render_expense_section_from_data
from services.reports.table_builder.revenue_helpers import _manual_combine_groups_by_table, _manual_combine_groups_by_rows, _apply_manual_revenue_combine_groups, _apply_manual_tax_combine_groups, _operation_cost_totals_by_column, _get_revenue_bounds, _group_revenues_by_type, _validate_revenue_data
