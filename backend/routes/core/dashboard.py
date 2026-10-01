# endpoint summary dashboard - yield count dan total user/manager

from datetime import datetime, timezone
from fastapi import APIRouter, Depends, Header
from sqlalchemy import func
from core.security import get_current_user

from models import db, User, Settlement, Advance, Expense

dashboard_bp = APIRouter(prefix='/api/dashboard', tags=['dashboard'])


@dashboard_bp.get('/summary')
def get_summary(
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
):
    is_manager = user.role in ['manager', 'super_manager']
    company = company or 'EWI Foundation'

    # pending counts - filtered by company
    settle_q = Settlement.query.filter(Settlement.company == company).filter_by(status='submitted')
    advance_q = Advance.query.filter(Advance.company == company).filter_by(status='submitted')

    if not is_manager:
        settle_q = settle_q.filter_by(user_id=user.id)
        advance_q = advance_q.filter_by(user_id=user.id)

    pending_settlements = settle_q.count()
    pending_advances = advance_q.count()

    # total expenses bulan ini (idr)
    now = datetime.now(timezone.utc)
    first_of_month = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    expense_q = (
        db.session.query(func.coalesce(func.sum(Expense.idr_amount), 0))
        .filter(Expense.company == company)
        .filter(Expense.status == 'approved')
        .filter(Expense.date >= first_of_month.date())
    )
    if not is_manager:
        expense_q = expense_q.join(Settlement).filter(Settlement.user_id == user.id)

    total_expenses_month = float(expense_q.scalar() or 0)

    # total expenses TAHUN INI (idr) - for yearly dashboard card
    first_of_year = now.replace(month=1, day=1, hour=0, minute=0, second=0, microsecond=0)

    expense_year_q = (
        db.session.query(func.coalesce(func.sum(Expense.idr_amount), 0))
        .filter(Expense.company == company)
        .filter(Expense.status == 'approved')
        .filter(Expense.date >= first_of_year.date())
    )
    if not is_manager:
        expense_year_q = expense_year_q.join(Settlement).filter(Settlement.user_id == user.id)

    total_expenses_year = float(expense_year_q.scalar() or 0)

    # total settlements & advances - filtered by company
    total_settle_q = Settlement.query.filter(Settlement.company == company)
    total_advance_q = Advance.query.filter(Advance.company == company)
    if not is_manager:
        total_settle_q = total_settle_q.filter_by(user_id=user.id)
        total_advance_q = total_advance_q.filter_by(user_id=user.id)

    total_settlements = total_settle_q.count()
    total_advances = total_advance_q.count()

    return {
        'pending_settlements': pending_settlements,
        'pending_advances': pending_advances,
        'total_expenses_this_month': total_expenses_month,
        'total_expenses_this_year': total_expenses_year,
        'total_settlements': total_settlements,
        'total_advances': total_advances,
        'is_manager': is_manager,
    }
