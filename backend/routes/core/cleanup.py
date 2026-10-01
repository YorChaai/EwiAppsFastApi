from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse
from core.security import get_current_user
from schemas.cleanup import CleanupRequest
from sqlalchemy import extract, func
from models import (
    User, db, Settlement, Advance, Revenue, Tax, 
    BankTransaction, Asset, Dividend, ManualCombineGroup, Notification,
    Expense, AdvanceItem, expense_subcategories, advance_item_subcategories
)

cleanup_bp = APIRouter(prefix="/api/cleanup", tags=["cleanup"])

@cleanup_bp.post("/preview")
def cleanup_preview(data: CleanupRequest, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses hanya untuk manager"}, status_code=403)

    years = data.years  # List of years or ["all"]
    modules = data.modules  # List of module names

    results = []

    def get_filter(model, year_col):
        if "all" in years:
            return True
        return year_col.in_(years)

    # Helper to get count
    def get_count(model, year_col):
        query = db.session.query(func.count(model.id))
        if "all" not in years:
            # If year_col is a Date column (for Assets)
            if hasattr(year_col, 'type') and hasattr(year_col.type, 'python_type') and year_col.type.python_type.__name__ == 'date':
                query = query.filter(extract('year', year_col).in_(years))
            else:
                query = query.filter(year_col.in_(years))
        return query.scalar() or 0

    if "settlement" in modules:
        count = get_count(Settlement, Settlement.report_year)
        results.append({"module": "settlement", "label": "Settlement & Expenses", "count": count})

    if "advance" in modules:
        count = get_count(Advance, Advance.report_year)
        results.append({"module": "advance", "label": "Kasbon & Items", "count": count})

    if "revenue" in modules:
        count = get_count(Revenue, Revenue.report_year)
        results.append({"module": "revenue", "label": "Pemasukan (Revenue)", "count": count})

    if "tax" in modules:
        count = get_count(Tax, Tax.report_year)
        results.append({"module": "tax", "label": "Pajak", "count": count})

    if "bank_status" in modules:
        count = get_count(BankTransaction, BankTransaction.report_year)
        results.append({"module": "bank_status", "label": "Bank Status (Transactions)", "count": count})

    if "asset" in modules:
        # Assets uses purchase_date
        count = get_count(Asset, Asset.purchase_date)
        results.append({"module": "asset", "label": "Asset Register", "count": count})

    if "dividend" in modules:
        count = get_count(Dividend, Dividend.report_year)
        results.append({"module": "dividend", "label": "Dividen", "count": count})

    return {"summary": results}

@cleanup_bp.post("/execute")
def cleanup_execute(data: CleanupRequest, user: User = Depends(get_current_user)):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses hanya untuk manager"}, status_code=403)

    years = data.years
    modules = data.modules
    
    if not years or not modules:
        return JSONResponse({"error": "Tahun dan Modul harus dipilih"}, status_code=400)

    deleted_summary = {}

    try:
        # 1. Settlement
        if "settlement" in modules:
            # 1a. Filter by year
            s_q = db.session.query(Settlement.id)
            if "all" not in years:
                # Include NULL years if searching for specific years to be safe, 
                # or just filter strictly. Let's include NULL in 'all' or if specifically requested.
                s_q = s_q.filter((Settlement.report_year.in_(years)) | (Settlement.report_year.is_(None)))
            else:
                # 'all' means everything including NULL
                pass
            settlement_ids = [s.id for s in s_q.all()]

            if settlement_ids:
                # 1b. Delete from expense_subcategories (Join Table)
                db.session.execute(
                    expense_subcategories.delete().where(
                        expense_subcategories.c.expense_id.in_(
                            db.session.query(Expense.id).filter(Expense.settlement_id.in_(settlement_ids))
                        )
                    )
                )

                # 1c. Delete expenses
                db.session.query(Expense).filter(Expense.settlement_id.in_(settlement_ids)).delete(synchronize_session=False)

                # 1d. Delete notifications related to these settlements
                db.session.query(Notification).filter(
                    Notification.target_type == "settlement",
                    Notification.target_id.in_(settlement_ids)
                ).delete(synchronize_session=False)

                # 1e. Delete settlements
                count = Settlement.query.filter(Settlement.id.in_(settlement_ids)).delete(synchronize_session=False)
                deleted_summary["settlement"] = count

                # 1f. Cleanup manual groups for settlements
                g_q = ManualCombineGroup.query.filter(ManualCombineGroup.table_name == "settlements")
                if "all" not in years:
                    g_q = g_q.filter(ManualCombineGroup.report_year.in_(years))
                g_q.delete(synchronize_session=False)

        # 2. Advance
        if "advance" in modules:
            # 2a. Filter by year
            a_q = db.session.query(Advance.id)
            if "all" not in years:
                a_q = a_q.filter((Advance.report_year.in_(years)) | (Advance.report_year.is_(None)))
            else:
                pass
            advance_ids = [a.id for a in a_q.all()]

            if advance_ids:
                # 2b. Delete from advance_item_subcategories (Join Table)
                db.session.execute(
                    advance_item_subcategories.delete().where(
                        advance_item_subcategories.c.advance_item_id.in_(
                            db.session.query(AdvanceItem.id).filter(AdvanceItem.advance_id.in_(advance_ids))
                        )
                    )
                )

                # 2c. Delete advance items
                db.session.query(AdvanceItem).filter(AdvanceItem.advance_id.in_(advance_ids)).delete(synchronize_session=False)

                # 2d. Delete notifications
                db.session.query(Notification).filter(
                    Notification.target_type == "advance",
                    Notification.target_id.in_(advance_ids)
                ).delete(synchronize_session=False)

                # 2e. Delete advances
                count = Advance.query.filter(Advance.id.in_(advance_ids)).delete(synchronize_session=False)
                deleted_summary["advance"] = count

                # 2f. Cleanup manual groups for advances
                g_q = ManualCombineGroup.query.filter(ManualCombineGroup.table_name == "advances")
                if "all" not in years:
                    g_q = g_q.filter(ManualCombineGroup.report_year.in_(years))
                g_q.delete(synchronize_session=False)

        # 3. Revenue
        if "revenue" in modules:
            q = Revenue.query
            if "all" not in years:
                q = q.filter(Revenue.report_year.in_(years))
            count = q.delete(synchronize_session=False)
            deleted_summary["revenue"] = count

        # 4. Tax
        if "tax" in modules:
            q = Tax.query
            if "all" not in years:
                q = q.filter(Tax.report_year.in_(years))
            count = q.delete(synchronize_session=False)
            deleted_summary["tax"] = count

        # 5. Bank Transaction
        if "bank_status" in modules:
            q = BankTransaction.query
            if "all" not in years:
                q = q.filter(BankTransaction.report_year.in_(years))
            count = q.delete(synchronize_session=False)
            deleted_summary["bank_status"] = count

        # 6. Asset
        if "asset" in modules:
            q = Asset.query
            if "all" not in years:
                q = q.filter(extract('year', Asset.purchase_date).in_(years))
            count = q.delete(synchronize_session=False)
            deleted_summary["asset"] = count

        # 7. Dividend
        if "dividend" in modules:
            q = Dividend.query
            if "all" not in years:
                q = q.filter(Dividend.report_year.in_(years))
            count = q.delete(synchronize_session=False)
            deleted_summary["dividend"] = count

        db.session.commit()
        return {
            "message": "Pembersihan data berhasil dilakukan",
            "summary": deleted_summary
        }

    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": f"Gagal membersihkan data: {str(e)}"}, status_code=500)
