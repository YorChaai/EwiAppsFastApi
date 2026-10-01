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
from services.reports.annual_service.annual_helpers import (
    _compute_dividend_distribution_v2,
)
from utils.report_helpers import (
    _clean_currency,
    _clean_settlement_title,
    _group_annual_expenses,
    _year_date_bounds,
)

def _calculate_asset_depreciation(assets, year=None, target_date=None):
    asset_data = []

    # Determine the evaluation date
    if target_date:
        if isinstance(target_date, str):
            try:
                eval_date = datetime.strptime(target_date, "%Y-%m-%d").date()
            except ValueError:
                eval_date = datetime.now().date()
        else:
            eval_date = target_date
    elif year:
        eval_date = date(year, 12, 31)
    else:
        eval_date = datetime.now().date()

    for a in assets:
        ad = a.to_dict()

        # Calculate repair costs linked to this asset (capitalization)
        # We sum approved expenses and advance items linked to this asset
        repair_cost = sum((e.idr_amount or 0.0) for e in a.expenses)
        repair_cost += sum(
            (ai.idr_amount or 0.0) for ai in a.advance_items if ai.status == "completed"
        )

        purchase_date = a.purchase_date

        depreciation_basis = a.purchase_price + repair_cost

        if purchase_date > eval_date:
            months_passed = 0
        else:
            # Calculate months passed until the eval_date
            months_passed = (
                (eval_date.year - purchase_date.year) * 12
                + (eval_date.month - purchase_date.month)
                + 1
            )
            months_passed = min(months_passed, a.useful_life_months)

        monthly_depreciation = (
            depreciation_basis / a.useful_life_months if a.useful_life_months > 0 else 0
        )
        accumulated_depreciation = monthly_depreciation * months_passed
        book_value = max(
            depreciation_basis - accumulated_depreciation, a.residual_value
        )

        ad["repair_cost"] = repair_cost
        ad["depreciation_basis"] = depreciation_basis
        ad["monthly_depreciation"] = monthly_depreciation
        ad["accumulated_depreciation"] = accumulated_depreciation
        ad["book_value"] = book_value
        ad["as_of_date"] = eval_date.isoformat()

        # Generate monthly breakdown for NDPV table (Fixed 5-year projection from evaluation month)
        monthly_breakdown = []
        cumulative_depr = 0.0

        eval_month_start = date(eval_date.year, eval_date.month, 1)
        # We start showing from purchase month OR eval month, whichever is earlier?
        # Actually, for matrix alignment, we should probably project from a fixed point.
        # Let's project from the EARLIEST purchase date among all assets to current + 60 months?
        # Or simpler: project from eval_month for 60 months.

        # Determine how many months passed from purchase to the start of eval month
        m_since_purchase_to_eval = (eval_month_start.year - purchase_date.year) * 12 + (
            eval_month_start.month - purchase_date.month
        )

        # Start loop from purchase date to provide full history
        start_date = date(purchase_date.year, purchase_date.month, 1)

        # Total projection: History since purchase + 60 months into the future from EVAL date
        months_into_future = 60
        total_loop_months = m_since_purchase_to_eval + months_into_future + 1

        for m_idx in range(total_loop_months):
            loop_date = start_date + relativedelta(months=m_idx)
            month_key = loop_date.strftime("%Y-%m-01")  # Request: start from day 1

            # Monthly depreciation logic
            if m_idx < a.useful_life_months:
                m_depr = monthly_depreciation
            else:
                m_depr = 0.0

            cumulative_depr += m_depr
            m_book_value = max(depreciation_basis - cumulative_depr, a.residual_value)

            monthly_breakdown.append(
                {
                    "period": month_key,
                    "depreciation": m_depr,
                    "accumulated": cumulative_depr,
                    "book_value": m_book_value,
                    "is_future": loop_date > eval_month_start,
                }
            )

        ad["monthly_breakdown"] = monthly_breakdown
        # Add metadata for card
        end_date = purchase_date + relativedelta(months=a.useful_life_months)
        ad["end_date"] = end_date.isoformat()

        months_left = max(
            a.useful_life_months
            - (
                (eval_date.year - purchase_date.year) * 12
                + (eval_date.month - purchase_date.month)
                + 1
            ),
            0,
        )
        ad["months_remaining"] = months_left

        asset_data.append(ad)
    return asset_data

