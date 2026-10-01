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

def _tagged_ids_for_year(table_name, report_year):
    try:
        rows = db.session.execute(
            sql_text("""SELECT row_id FROM report_entry_tags
                WHERE table_name = :table_name AND report_year = :report_year"""),
            {"table_name": table_name, "report_year": int(report_year)},
        ).fetchall()
        return [int(r[0]) for r in rows]
    except Exception:
        db.session.rollback()
        return []

def _has_any_report_tags():
    try:
        row = db.session.execute(
            sql_text("SELECT 1 FROM report_entry_tags LIMIT 1")
        ).first()
        return row is not None
    except Exception:
        db.session.rollback()
        return False

def _fetch_revenue_data(
    year,
    mode,
    start_date,
    end_date,
    has_report_tags,
    tagged_revenue_ids,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    if mode != "range" and has_report_tags and tagged_revenue_ids:
        revenues = (
            Revenue.query.filter(Revenue.company == company)
            .filter(Revenue.id.in_(tagged_revenue_ids))
            .order_by(Revenue.id.asc())
            .all()
        )
    else:
        if mode == "report":
            if year:
                revenues = (
                    Revenue.query.filter(Revenue.company == company)
                    .filter(Revenue.report_year == year)
                    .order_by(Revenue.id.asc())
                    .all()
                )
            else:
                revenues = (
                    Revenue.query.filter(Revenue.company == company)
                    .order_by(Revenue.id.asc())
                    .all()
                )
        elif mode == "range" and start_date and end_date:
            revenues = (
                Revenue.query.filter(Revenue.company == company)
                .filter(
                    Revenue.receive_date >= start_date,
                    Revenue.receive_date <= end_date,
                )
                .order_by(Revenue.id.asc())
                .all()
            )
        else:
            if year_start and next_year_start:
                revenues = (
                    Revenue.query.filter(Revenue.company == company)
                    .filter(
                        Revenue.invoice_date >= year_start,
                        Revenue.invoice_date < next_year_start,
                    )
                    .order_by(Revenue.id.asc())
                    .all()
                )
            else:
                revenues = (
                    Revenue.query.filter(Revenue.company == company)
                    .order_by(Revenue.id.asc())
                    .all()
                )
    return revenues

def _fetch_expense_data(
    year,
    mode,
    start_date,
    end_date,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    from sqlalchemy import func

    # Hanya expense dari settlement berstatus completed yang masuk laporan
    expenses_query = (
        Expense.query.filter(
            Expense.company == company,
            Expense.status.in_(["completed", "approved"]),
        )
        .options(
            joinedload(Expense.category),
            joinedload(Expense.subcategories),
            joinedload(Expense.settlement),
        )
        .join(Settlement, Expense.settlement_id == Settlement.id)
        .filter(
            Settlement.company == company,
            Settlement.status == "completed",
        )
    )

    if mode == "report":
        if year:
            expenses_query = expenses_query.filter(
                Settlement.report_year == year,
            )

        # Sort by Settlement document_date if available, else fallback to Expense.date
        return expenses_query.order_by(
            func.coalesce(Settlement.document_date, Expense.date).asc(),
            Expense.id.asc(),
        ).all()

    elif mode == "range" and start_date and end_date:
        expenses_query = expenses_query.filter(
            Expense.date >= start_date,
            Expense.date <= end_date,
        )
    else:
        if year_start and next_year_start:
            expenses_query = expenses_query.filter(
                Expense.date >= year_start,
                Expense.date < next_year_start,
            )

    return expenses_query.order_by(Expense.date.asc()).all()

def _fetch_asset_data(year, mode, end_date, next_year_start, company="EWI Foundation"):
    from models import Asset

    # Return all assets regardless of year to ensure visibility in Tabel 6
    return Asset.query.filter(Asset.company == company).all()

def _fetch_bank_transaction_data(
    year,
    mode,
    start_date,
    end_date,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    from models import BankStatusTransaction

    base_query = BankStatusTransaction.query.filter(BankStatusTransaction.company == company)

    if mode == "report":
        if year:
            query = base_query.filter(BankStatusTransaction.report_year == year)
        else:
            query = base_query
    elif mode == "range" and start_date and end_date:
        query = base_query.filter(
            BankStatusTransaction.date >= start_date, BankStatusTransaction.date <= end_date
        )
    else:
        if year_start and next_year_start:
            query = base_query.filter(
                BankStatusTransaction.date >= year_start,
                BankStatusTransaction.date < next_year_start,
            )
        else:
            query = base_query
    return query.order_by(BankStatusTransaction.date.asc()).all()

def _fetch_tax_data(
    year,
    mode,
    start_date,
    end_date,
    has_report_tags,
    tagged_tax_ids,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    base_query = Tax.query.filter(Tax.company == company)
    if mode != "range" and has_report_tags and tagged_tax_ids:
        taxes = (
            base_query.filter(Tax.id.in_(tagged_tax_ids)).order_by(Tax.id.asc()).all()
        )
    else:
        if mode == "report":
            if year:
                query = base_query.filter(Tax.report_year == year)
            else:
                query = base_query
        elif mode == "range" and start_date and end_date:
            query = base_query.filter(Tax.date >= start_date, Tax.date <= end_date)
        else:
            if year_start and next_year_start:
                query = base_query.filter(
                    Tax.date >= year_start, Tax.date < next_year_start
                )
            else:
                query = base_query
        taxes = query.order_by(Tax.id.asc()).all()
    return taxes

def _fetch_advance_items_data(
    year,
    mode,
    start_date,
    end_date,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    from models import Advance

    query = (
        AdvanceItem.query.filter(AdvanceItem.company == company)
        .options(
            joinedload(AdvanceItem.category),
            joinedload(AdvanceItem.subcategories),
            joinedload(AdvanceItem.advance),
        )
        .join(Advance, AdvanceItem.advance_id == Advance.id)
        .filter(AdvanceItem.status.in_(["completed", "approved"]))
        .filter(Advance.status == "completed")
    )

    if mode == "report":
        if year:
            query = query.filter(Advance.report_year == year)
    elif mode == "range" and start_date and end_date:
        query = query.filter(
            AdvanceItem.date >= start_date, AdvanceItem.date <= end_date
        )
    else:
        if year_start and next_year_start:
            query = query.filter(
                AdvanceItem.date >= year_start, AdvanceItem.date < next_year_start
            )

    return query.order_by(AdvanceItem.date.asc()).all()

def _fetch_dividend_data(
    year,
    mode,
    start_date,
    end_date,
    year_start,
    next_year_start,
    company="EWI Foundation",
):
    base_query = Dividend.query.filter(Dividend.company == company)

    if mode == "report":
        if year:
            query = base_query.filter(Dividend.report_year == year)
        else:
            query = base_query
    elif mode == "range" and start_date and end_date:
        query = base_query.filter(
            Dividend.date >= start_date, Dividend.date <= end_date
        )
    else:
        if year_start and next_year_start:
            query = base_query.filter(
                Dividend.date >= year_start, Dividend.date < next_year_start
            )
        else:
            query = base_query

    return query.order_by(Dividend.date.asc(), Dividend.id.asc()).all()

