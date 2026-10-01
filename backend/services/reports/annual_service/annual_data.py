import logging
from datetime import date, datetime
from typing import Any, Dict, Optional
from dateutil.relativedelta import relativedelta
from models import (
    Advance,
    AdvanceItem,
    Category,
    CategoryGroup,
    Dividend,
    DividendSetting,
    Expense,
    Revenue,
    Settlement,
    Tax,
    db,
)
from sqlalchemy import text as sql_text
from sqlalchemy.orm import joinedload
from .annual_helpers import (
    _compute_dividend_distribution_v2,
)
from utils.report_helpers import (
    _clean_currency,
    _clean_settlement_title,
    _group_annual_expenses,
    _year_date_bounds,
)

from services.reports.data_fetcher.db_fetchers import _tagged_ids_for_year, _has_any_report_tags, _fetch_revenue_data, _fetch_expense_data, _fetch_asset_data, _fetch_bank_transaction_data, _fetch_tax_data, _fetch_advance_items_data, _fetch_dividend_data
from services.reports.data_fetcher.depreciation import _calculate_asset_depreciation
from services.reports.data_fetcher.payload_builder import (
    _build_annual_payload_from_db,
    _compute_dividend_distribution,
)
