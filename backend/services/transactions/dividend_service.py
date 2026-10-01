from models import Revenue, Expense, Settlement, DividendSetting, Dividend, db
from sqlalchemy import extract, and_
from services.reports.annual_service.annual_helpers import _compute_dividend_distribution_v2

SETTING_FLOAT_FIELDS = [
    "revenue_cash_in_percentage",
    "revenue_ar_percentage",
    "profit_retained_percentage",
]


def _fetch_revenues_and_expenses_for_year(year: int, company="EWI Foundation"):
    """Fetch revenues and expenses using report_year (accrual mode) to match annual report."""
    revenues = (
        Revenue.query.filter(Revenue.company == company)
        .filter(Revenue.report_year == year)
        .all()
    )
    if not revenues:
        # Fallback: try invoice_date year
        revenues = Revenue.query.filter(
            Revenue.company == company,
            extract("year", Revenue.invoice_date) == year,
        ).all()

    expenses = (
        Expense.query.join(Settlement, Expense.settlement_id == Settlement.id)
        .filter(
            Expense.company == company,
            Expense.status.in_(("approved", "completed")),
            Settlement.company == company,
            Settlement.status == "completed",
            Settlement.report_year == year,
        )
        .all()
    )
    if not expenses:
        # Fallback: try expense date year
        expenses = (
            Expense.query.join(Settlement, Expense.settlement_id == Settlement.id)
            .filter(
                Expense.company == company,
                Expense.status.in_(("approved", "completed")),
                Settlement.company == company,
                Settlement.status == "completed",
                extract("year", Expense.date) == year,
            )
            .all()
        )

    return revenues, expenses

def _build_dividend_payload(year: int, company="EWI Foundation"):
    setting = DividendSetting.query.filter_by(year=year, company=company).first()
    recipients = (
        Dividend.query.filter(Dividend.company == company)
        .filter(
            extract("year", Dividend.date) == year,
        )
        .order_by(Dividend.date.asc(), Dividend.id.asc())
        .all()
    )

    # Use the SAME calculation as the annual report (Business Summary)
    revenues, expenses = _fetch_revenues_and_expenses_for_year(year, company=company)
    calc = _compute_dividend_distribution_v2(
        revenues, expenses, setting, len(recipients)
    )

    profit_after_tax = calc["profit_after_tax_accounting"]
    profit_retained = calc["profit_retained_setting"]
    dividend_distributed = calc["dividend_distributed"]
    dividend_per_person = calc["dividend_per_person"]
    recipient_count = len(recipients)

    recipient_data = []
    total_percentage = 0.0
    for item in recipients:
        data = item.to_dict()
        data["amount"] = dividend_distributed * (item.percentage / 100.0)
        total_percentage += item.percentage
        recipient_data.append(data)

    return {
        "year": year,
        "profit_after_tax": profit_after_tax,
        "profit_retained": profit_retained,
        "dividend_distributed": dividend_distributed,
        "recipient_count": recipient_count,
        "total_percentage": total_percentage,
        "settings": setting.to_dict()
        if setting
        else {
            "year": year,
            **{field: 0.0 for field in SETTING_FLOAT_FIELDS},
        },
        "data": recipient_data,
    }

