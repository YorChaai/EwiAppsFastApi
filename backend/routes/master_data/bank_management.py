"""
Bank Management Routes — Kelola Bank Cash (Kas Riil)
Hanya untuk 4 bank utama: BRI, BNI, Mandiri, BCA
Transaksi di sini: kasbon, settlement, transfer antar bank (is_bank_status=False)
"""

from datetime import datetime

from fastapi import APIRouter, Body, Depends, Header, Query
from fastapi.responses import JSONResponse
from core.security import get_current_user
from models import BankAccount, BankTransaction, Settlement, User, db
from sqlalchemy.exc import IntegrityError
from services.core.notification_events import (
    notify_bank_created,
    notify_bank_transaction_created,
)

bank_management_router = APIRouter(prefix="/api/bank-management", tags=["bank_management"])


# ─── BANK ACCOUNTS ────────────────────────────────────────────────────────────


@bank_management_router.get("/banks")
def list_management_banks(
    account_type: str | None = Query(default=None),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    
    from services.balance.balance_service import get_all_bank_real_balances

    query = BankAccount.query.filter(BankAccount.company == company)
    
    if account_type:
        query = query.filter(BankAccount.account_type == account_type)
    else:
        # Fetch banks (management + status) but EXCLUDE 'advance' (Virtual Employee Banks)
        query = query.filter(BankAccount.account_type != "advance")
        
    banks = query.all()
    
    def _bank_sort_key(b):
        name = (b.name or "").lower().strip()
        if "bca" in name:
            bank_rank = 1000
        elif "mandiri" in name:
            bank_rank = 2000
        elif "bri" in name:
            bank_rank = 3000
        elif "bni" in name:
            bank_rank = 4000
        elif "ewi" in name:
            bank_rank = 5000
        elif "cash" in name or "kas" in name:
            bank_rank = 6000
        elif "lain" in name:
            return (99900 + (b.id or 0), name)
        else:
            return (90000 + (b.id or 0), name)
        
        if "giro" in name:
            group_rank = 20
        elif "bisnis" in name:
            group_rank = 30
        elif "tabbis" in name or "tabis" in name:
            group_rank = 40
        elif "valas" in name:
            group_rank = 50
        else:
            group_rank = 10
            
        return (bank_rank + group_rank, name)

    banks.sort(key=_bank_sort_key)
    
    all_balances = get_all_bank_real_balances(company)
    result = []
    for b in banks:
        b_dict = b.to_dict()
        b_dict["real_balance"] = all_balances.get(b.id, b.initial_balance)
        result.append(b_dict)
    return {"banks": result}


@bank_management_router.post("/banks")
def create_management_bank(
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)
    name = (data.get("name") or "").strip()
    if not name:
        return JSONResponse({"error": "Nama bank harus diisi"}, status_code=400)

    account_number = (data.get("account_number") or "").strip()
    company = company or "EWI Foundation"

    # Validasi duplikasi nomor rekening (jika diisi)
    if account_number and account_number != "-":
        existing = BankAccount.query.filter_by(
            account_number=account_number, company=company
        ).first()
        if existing:
            return JSONResponse(
                {"error": f"Nomor rekening '{account_number}' sudah terdaftar pada rekening '{existing.name}'."},
                status_code=400,
            )

    bank = BankAccount(
        name=name,
        account_number=account_number if account_number else None,
        currency=data.get("currency", "IDR"),
        initial_balance=data.get("initial_balance", 0.0),
        account_type="management",
        company=company,
    )
    db.session.add(bank)
    db.session.commit()
    notify_bank_created(bank, user, company=company or "EWI Foundation")
    return JSONResponse(bank.to_dict(), status_code=201)


@bank_management_router.put("/banks/{bank_id}")
def update_management_bank(
    bank_id: int,
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)
    company = company or "EWI Foundation"
    bank = BankAccount.query.filter_by(
        id=bank_id, company=company
    ).first_or_404()

    name = (data.get("name", bank.name) or "").strip()
    if not name:
        return JSONResponse({"error": "Nama bank tidak boleh kosong"}, status_code=400)

    account_number = (data.get("account_number", bank.account_number or "") or "").strip()

    # Validasi duplikasi nomor rekening pada rekening lain (jika diisi)
    if account_number and account_number != "-":
        existing = BankAccount.query.filter(
            BankAccount.account_number == account_number,
            BankAccount.company == company,
            BankAccount.id != bank_id,
        ).first()
        if existing:
            return JSONResponse(
                {"error": f"Nomor rekening '{account_number}' sudah terdaftar pada rekening '{existing.name}'."},
                status_code=400,
            )

    bank.name = name
    bank.account_number = account_number if account_number else None
    bank.currency = data.get("currency", bank.currency)
    bank.initial_balance = data.get("initial_balance", bank.initial_balance)
    db.session.commit()
    return bank.to_dict()


@bank_management_router.delete("/banks/{bank_id}")
def delete_management_bank(
    bank_id: int,
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    if user.role not in ["manager", "super_manager"]:
        return JSONResponse({"error": "Akses ditolak"}, status_code=403)

    company = company or "EWI Foundation"
    bank = BankAccount.query.filter_by(id=bank_id, company=company).first_or_404()

    # 1. Cek apakah memiliki transaksi buku kas
    has_transactions = BankTransaction.query.filter(
        (BankTransaction.bank_id == bank_id) | (BankTransaction.to_bank_id == bank_id)
    ).first()
    if has_transactions:
        return JSONResponse(
            {
                "error": f"Gagal menghapus: Rekening '{bank.name}' memiliki riwayat transaksi buku kas. "
                "Hapus semua riwayat transaksi terkait terlebih dahulu jika ingin menghapus rekening ini."
            }, status_code=400
        )

    # 2. Cek apakah tertaut pada data Settlement / Pengajuan
    has_settlement = Settlement.query.filter_by(bank_id=bank_id).first()
    if has_settlement:
        return JSONResponse(
            {
                "error": f"Gagal menghapus: Rekening '{bank.name}' masih digunakan pada riwayat pengajuan/settlement. "
                "Rekening tidak dapat dihapus demi menjaga integritas data keuangan."
            }, status_code=400
        )

    try:
        db.session.delete(bank)
        db.session.commit()
        return {"message": f"Rekening '{bank.name}' berhasil dihapus"}
    except IntegrityError:
        db.session.rollback()
        return JSONResponse(
            {
                "error": f"Gagal menghapus: Rekening '{bank.name}' masih terhubung dengan data lain di sistem."
            }, status_code=400
        )
    except Exception as e:
        db.session.rollback()
        return JSONResponse({"error": f"Terjadi kesalahan saat menghapus: {str(e)}"}, status_code=500)


# ─── TRANSACTIONS ──────────────────────────────────────────────────────────────


@bank_management_router.get("/transactions")
def list_management_transactions(
    year: int | None = Query(default=None),
    mode: str = Query(default="report"),
    bank_id: int | None = Query(default=None),
    start_date: str | None = Query(default=None),
    end_date: str | None = Query(default=None),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"

    query = BankTransaction.query.outerjoin(
        BankAccount, BankTransaction.bank_id == BankAccount.id
    ).filter(
        BankTransaction.company == company
    )

    if bank_id:
        from sqlalchemy import or_

        query = query.filter(
            or_(
                BankTransaction.bank_id == bank_id,
                BankTransaction.to_bank_id == bank_id,
            )
        )
    else:
        query = query.filter(BankAccount.account_type == "management")

    if year:
        if mode == "report":
            query = query.filter(BankTransaction.report_year == year)
        else:
            from sqlalchemy import extract

            query = query.filter(extract("year", BankTransaction.date) == year)
    if start_date:
        try:
            query = query.filter(
                BankTransaction.date
                >= datetime.strptime(start_date, "%Y-%m-%d").date()
            )
        except ValueError:
            pass
    if end_date:
        try:
            query = query.filter(
                BankTransaction.date
                <= datetime.strptime(end_date, "%Y-%m-%d").date()
            )
        except ValueError:
            pass

    transactions = query.order_by(
        BankTransaction.date.desc(), BankTransaction.id.desc()
    ).all()
    return {"transactions": [t.to_dict() for t in transactions]}


@bank_management_router.post("/transactions")
def create_management_transaction(
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

    bank = BankAccount.query.get(bank_id) if bank_id else None
    to_bank = BankAccount.query.get(to_bank_id) if to_bank_id else None

    # Append Performer Name & Bank Details for Balance Adjustments
    from utils.transaction_templates import TxTemplates
    if description.startswith(TxTemplates.ADD_REAL_CASH) or description.startswith(
        TxTemplates.SUB_REAL_CASH
    ):
        # Original from frontend: "Main|Before|After"
        if "|" in description:
            parts = description.split("|")
            # Update Main Description with performer name in parentheses
            description = f"{parts[0]} ({user.full_name})"
        else:
            description = f"{description} ({user.full_name})"

    date = datetime.strptime(date_str, "%Y-%m-%d").date()

    if trans_type == "transfer" and bank and to_bank and not group_name:
        group_name = f"Pemindahbukuan dari {bank.name} ke {to_bank.name}"

    transaction = BankTransaction(
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
        user_id=user.id,
    )
    db.session.add(transaction)
    db.session.commit()
    notify_bank_transaction_created(transaction, bank or to_bank, user, company=transaction.company)
    return JSONResponse(transaction.to_dict(), status_code=201)


@bank_management_router.put("/transactions/{transaction_id}")
def update_management_transaction(
    transaction_id: int,
    data: dict = Body(...),
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    transaction = BankTransaction.query.filter_by(
        id=transaction_id, company=company
    ).first_or_404()
    if "bank_id" in data:
        transaction.bank_id = data["bank_id"]
    if "to_bank_id" in data:
        transaction.to_bank_id = data["to_bank_id"]
    if "date" in data:
        transaction.date = datetime.strptime(data["date"], "%Y-%m-%d").date()
    if "description" in data:
        transaction.description = data["description"]
    if "amount_idr" in data:
        transaction.amount_idr = data["amount_idr"]
    if "amount_usd" in data:
        transaction.amount_usd = data["amount_usd"]
    if "transaction_type" in data:
        transaction.transaction_type = data["transaction_type"]
    if "group_name" in data:
        transaction.group_name = data["group_name"]
    if "report_year" in data:
        transaction.report_year = data["report_year"]
    transaction.user_id = user.id
    db.session.commit()
    return transaction.to_dict()


@bank_management_router.delete("/transactions/{transaction_id}")
def delete_management_transaction(
    transaction_id: int,
    company: str = Header(default="EWI Foundation", alias="X-Company"),
    _user: User = Depends(get_current_user),
):
    company = company or "EWI Foundation"
    transaction = BankTransaction.query.filter_by(
        id=transaction_id, company=company
    ).first_or_404()
    db.session.delete(transaction)
    db.session.commit()
    return {"message": "Transaksi berhasil dihapus"}
