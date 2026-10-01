import pytest
import os
import sys
from datetime import date

backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app import create_app
from models import db, BankAccount, BankTransaction
from services.balance.balance_service import calculate_bank_real_balance
from utils.parsing_helper import _year_date_bounds
from utils.report_helpers import _to_float, _clean_currency

@pytest.fixture
def app():
    app = create_app(config_override={
        "TESTING": True,
        "SQLALCHEMY_DATABASE_URI": "sqlite:///:memory:"
    })
    db.create_all()
    yield app
    db.session.remove()
    db.drop_all()

def test_bank_real_balance_calculation(app):
    """Test calculate_bank_real_balance accurately tallies transactions against initial balance."""
    bank = BankAccount(
        name="Bank Mandiri Bisnis",
        account_number="1122334455",
        account_type="cash",
        initial_balance=10000000.0,  # 10 Juta awal
        company="EWI Foundation"
    )
    db.session.add(bank)
    db.session.commit()

    # Mutasi 1: Uang masuk +5 Juta
    t1 = BankTransaction(
        bank_id=bank.id,
        date=date(2026, 1, 15),
        description="Revenue Client Project A",
        amount_idr=5000000.0,
        transaction_type="income",
        company="EWI Foundation"
    )
    # Mutasi 2: Uang keluar -2 Juta
    t2 = BankTransaction(
        bank_id=bank.id,
        date=date(2026, 1, 20),
        description="Kasbon Operasional Kantor",
        amount_idr=2000000.0,
        transaction_type="expense",
        company="EWI Foundation"
    )
    db.session.add_all([t1, t2])
    db.session.commit()

    real_bal = calculate_bank_real_balance(bank.id)
    # 10.000.000 + 5.000.000 - 2.000.000 = 13.000.000
    assert real_bal == 13000000.0

def test_parsing_helpers_safety():
    """Verify parsing helpers handle corrupt, none, and string boundary inputs safely."""
    # _to_float
    assert _to_float(None, 0.0) == 0.0
    assert _to_float("1500000", 0.0) == 1500000.0
    assert _to_float("invalid-number", 99.0) == 99.0
    assert _to_float(12345.67) == 12345.67

    # _clean_currency
    assert _clean_currency("IDR") == "IDR"
    assert _clean_currency("USD") == "USD"
    assert _clean_currency(None) == "IDR"

    # _year_date_bounds
    start_str, end_str = _year_date_bounds(2026)
    assert start_str == "2026-01-01"
    assert end_str == "2026-12-31"

    start_str_inv, end_str_inv = _year_date_bounds("invalid-year")
    assert "-01-01" in start_str_inv
    assert "-12-31" in end_str_inv


def test_settlement_reimbursement_virtual_bank_deduction(app):
    """Test that settlement reimbursement properly deducts virtual bank balance and composition."""
    from models import User, Settlement
    from services.balance.balance_service import calculate_bank_composition

    user = User(username="testmgr", full_name="Test Manager", role="manager", password_hash="dummy")
    db.session.add(user)
    db.session.commit()

    bni = BankAccount(name="BNI", account_type="management", company="EWI Foundation")
    adv_bank = BankAccount(name="Plafon Virtual", account_type="advance", user_id=user.id, company="EWI Foundation")
    db.session.add_all([bni, adv_bank])
    db.session.commit()

    # Top up 1.000.000 from BNI to adv_bank
    t_topup = BankTransaction(
        bank_id=bni.id,
        to_bank_id=adv_bank.id,
        date=date(2026, 1, 1),
        description="Terima Alokasi dari BNI",
        amount_idr=1000000.0,
        transaction_type="transfer",
        company="EWI Foundation"
    )
    db.session.add(t_topup)
    db.session.commit()

    # Check initial composition
    comp = calculate_bank_composition(adv_bank.id, [bni.id])
    assert comp[bni.id] == 1000000.0

    # Create settlement reimbursement
    s = Settlement(
        title="Klaim Reimbursement Makan",
        user_id=user.id,
        status="completed",
        settlement_type="single",
        company="EWI Foundation",
        disbursed_amount=100000.0,
        disbursement_source="BNI",
        disbursement_source_id=bni.id
    )
    db.session.add(s)
    db.session.commit()

    # Deduction transaction on adv_bank
    t_exp = BankTransaction(
        bank_id=adv_bank.id,
        date=date(2026, 1, 2),
        amount_idr=100000.0,
        transaction_type="expense",
        description=f"Pencairan Reimbursement Settlement (Plafon Virtual) - {user.full_name}\n{s.title} (Ref: #{s.id})",
        company="EWI Foundation"
    )
    db.session.add(t_exp)
    db.session.commit()

    # Verify real balance & composition
    assert calculate_bank_real_balance(adv_bank.id) == 900000.0
    comp_after = calculate_bank_composition(adv_bank.id, [bni.id])
    assert comp_after[bni.id] == 900000.0

