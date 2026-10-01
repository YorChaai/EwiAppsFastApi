"""
Bank Status Routes — Laporan & Mutasi Semua Rekening Bank
Untuk semua 20 bank (4 utama + 16 variannya: Giro, Bisnis, TabBis, Valas)
Transaksi di sini: bunga bank, pajak, biaya admin, mutasi rekening (is_bank_status=True)
"""
from datetime import datetime

from fastapi import APIRouter, Body, Depends, Header, Query
from fastapi.responses import JSONResponse
from core.security import get_current_user
from models import BankAccount, BankStatusTransaction, User, db
from services.core.notification_events import notify_bank_transaction_created

bank_status_router = APIRouter(prefix="/api/bank-status", tags=["bank_status"])


# ─── BANK ACCOUNTS ────────────────────────────────────────────────────────────

@bank_status_router.get("/banks")
def list_all_banks_for_status(
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    """Ambil SEMUA 20 bank (management + status) untuk dropdown di Bank Status screen."""
    company = company or "EWI Foundation"
    from services.balance.balance_service import get_all_bank_real_balances
    banks = BankAccount.query.filter_by(company=company, account_type="status").order_by(BankAccount.name).all()
    all_balances = get_all_bank_real_balances(company)
    result = []
    for b in banks:
        b_dict = b.to_dict()
        b_dict["real_balance"] = all_balances.get(b.id, b.initial_balance)
        result.append(b_dict)
    return {"banks": result}


# ─── TRANSACTIONS ──────────────────────────────────────────────────────────────

@bank_status_router.get("/transactions")
def list_status_transactions(
    year: int | None = Query(default=None),
    mode: str = Query(default="report"),
    bank_id: int | None = Query(default=None),
    start_date: str | None = Query(default=None),
    end_date: str | None = Query(default=None),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"

    query = BankStatusTransaction.query.outerjoin(
        BankAccount, BankStatusTransaction.bank_id == BankAccount.id
    ).filter(
        BankStatusTransaction.company == company
    )
    
    if bank_id:
        from sqlalchemy import or_
        query = query.filter(
            or_(BankStatusTransaction.bank_id == bank_id, BankStatusTransaction.to_bank_id == bank_id)
        )
    else:
        # If no specific bank is selected, show only status transactions (or those without bank)
        from sqlalchemy import or_
        query = query.filter(
            or_(
                BankAccount.account_type == "status",
                BankStatusTransaction.bank_id == None
            )
        )

    if year:
        if mode == "report":
            query = query.filter(BankStatusTransaction.report_year == year)
        else:
            from sqlalchemy import extract
            query = query.filter(extract("year", BankStatusTransaction.date) == year)
    if start_date:
        try:
            query = query.filter(BankStatusTransaction.date >= datetime.strptime(start_date, "%Y-%m-%d").date())
        except ValueError:
            pass
    if end_date:
        try:
            query = query.filter(BankStatusTransaction.date <= datetime.strptime(end_date, "%Y-%m-%d").date())
        except ValueError:
            pass

    transactions = query.order_by(BankStatusTransaction.date.desc(), BankStatusTransaction.id.desc()).all()
    return {"transactions": [t.to_dict() for t in transactions]}


@bank_status_router.post("/transactions")
def create_status_transaction(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    bank_id = data.get("bank_id")
    to_bank_id = data.get("to_bank_id")
    date_str = data.get("date")
    description = data.get("description")
    amount_idr = data.get("amount_idr", 0.0)
    amount_usd = data.get("amount_usd", 0.0)
    trans_type = data.get("transaction_type")
    group_name = data.get("group_name")
    report_year = data.get("report_year")

    if not bank_id or not date_str or not description:
        return JSONResponse({"error": "Data tidak lengkap"}, status_code=400)

    date = datetime.strptime(date_str, "%Y-%m-%d").date()
    bank = BankAccount.query.get(bank_id) if bank_id else None
    to_bank = BankAccount.query.get(to_bank_id) if to_bank_id else None

    if trans_type == "income" and bank and not group_name:
        lower_name = bank.name.lower()
        if "bri" in lower_name: parent_bank = "BRI"
        elif "bca" in lower_name: parent_bank = "BCA"
        elif "mandiri" in lower_name: parent_bank = "Mandiri"
        elif "bni" in lower_name: parent_bank = "BNI"
        else: parent_bank = bank.name
        group_name = f"Bank Interest ({parent_bank})"

    transaction = BankStatusTransaction(
        bank_id=bank_id,
        to_bank_id=to_bank_id,
        date=date,
        description=description,
        amount_usd=amount_usd,
        amount_idr=amount_idr,
        transaction_type=trans_type,
        group_name=group_name,
        report_year=report_year,
        company=company or "EWI Foundation",
    )
    db.session.add(transaction)
    db.session.commit()
    notify_bank_transaction_created(transaction, bank or to_bank, user, company=transaction.company)
    return JSONResponse(transaction.to_dict(), status_code=201)


@bank_status_router.put("/transactions/{transaction_id}")
def update_status_transaction(
    transaction_id: int,
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    transaction = BankStatusTransaction.query.filter_by(
        id=transaction_id, company=company
    ).first_or_404()
    if "bank_id" in data: transaction.bank_id = data["bank_id"]
    if "to_bank_id" in data: transaction.to_bank_id = data["to_bank_id"]
    if "date" in data: transaction.date = datetime.strptime(data["date"], "%Y-%m-%d").date()
    if "description" in data: transaction.description = data["description"]
    if "amount_idr" in data: transaction.amount_idr = data["amount_idr"]
    if "amount_usd" in data: transaction.amount_usd = data["amount_usd"]
    if "transaction_type" in data: transaction.transaction_type = data["transaction_type"]
    if "group_name" in data: transaction.group_name = data["group_name"]
    if "report_year" in data: transaction.report_year = data["report_year"]
    db.session.commit()
    return transaction.to_dict()


@bank_status_router.delete("/transactions/{transaction_id}")
def delete_status_transaction(
    transaction_id: int,
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    transaction = BankStatusTransaction.query.filter_by(
        id=transaction_id, company=company
    ).first_or_404()
    db.session.delete(transaction)
    db.session.commit()
    return {"message": "Transaksi berhasil dihapus"}
