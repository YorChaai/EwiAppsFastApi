import pytest
import os
import sys
from datetime import date

backend_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

from app import create_app
from models import db, BankAccount, BankTransaction, Revenue, User
from services.dto.transaction_dto import TransactionDTO
from services.balance.balance_service import calculate_bank_real_balance
from routes.transactions.revenues import sync_revenue_bank_transaction


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


def test_revenue_model_has_bank_relationship(app):
    """Test Revenue model has bank_id column and relationship to BankAccount."""
    bank = BankAccount(
        name="Bank BNI",
        account_number="1234567890",
        account_type="cash",
        initial_balance=1000000.0,
        company="EWI",
    )
    db.session.add(bank)
    db.session.commit()

    revenue = Revenue(
        invoice_date=date(2026, 3, 1),
        description="Testing Revenue Bank Sync",
        invoice_value=5000000.0,
        amount_received_idr=5000000.0,
        bank_id=bank.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(revenue)
    db.session.commit()

    # Check relationships
    assert revenue.bank is not None
    assert revenue.bank.name == "Bank BNI"
    assert revenue.bank_id == bank.id
    assert revenue in bank.revenues


def test_bank_transaction_has_revenue_relationship(app):
    """Test BankTransaction model has revenue_id column and relationship to Revenue."""
    bank = BankAccount(name="Bank Mandiri", account_type="cash", initial_balance=0.0, company="EWI")
    db.session.add(bank)
    db.session.commit()

    revenue = Revenue(
        invoice_date=date(2026, 3, 1),
        description="Testing Revenue",
        invoice_value=2500000.0,
        amount_received_idr=2500000.0,
        bank_id=bank.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(revenue)
    db.session.commit()

    bt = BankTransaction(
        bank_id=bank.id,
        date=date(2026, 3, 1),
        description="Penerimaan Revenue: Testing Revenue",
        amount_idr=2500000.0,
        transaction_type="income",
        revenue_id=revenue.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(bt)
    db.session.commit()

    assert bt.revenue_id == revenue.id
    assert bt.revenue is not None
    assert bt.revenue.description == "Testing Revenue"


def test_revenue_to_dict_includes_bank_info(app):
    """Test revenue_to_dict DTO includes bank_id and bank_name."""
    bank = BankAccount(name="Bank BRI", account_type="cash", initial_balance=0.0, company="EWI")
    db.session.add(bank)
    db.session.commit()

    # Case 1: with bank
    rev_with_bank = Revenue(
        invoice_date=date(2026, 3, 1),
        description="Rev with bank",
        invoice_value=1000000.0,
        amount_received_idr=1000000.0,
        bank_id=bank.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(rev_with_bank)
    db.session.commit()

    d1 = TransactionDTO.revenue_to_dict(rev_with_bank)
    assert d1["bank_id"] == bank.id
    assert d1["bank_name"] == "Bank BRI"

    # Case 2: without bank (unallocated / '-')
    rev_no_bank = Revenue(
        invoice_date=date(2026, 3, 1),
        description="Rev without bank",
        invoice_value=1000000.0,
        amount_received_idr=1000000.0,
        bank_id=None,
        company="EWI",
        report_year=2026,
    )
    db.session.add(rev_no_bank)
    db.session.commit()

    d2 = TransactionDTO.revenue_to_dict(rev_no_bank)
    assert d2["bank_id"] is None
    assert d2["bank_name"] is None


def test_sync_revenue_bank_transaction_creates_and_updates_and_deletes(app):
    """Test sync_revenue_bank_transaction lifecycle: create, update bank, unlink to None, and delete."""
    bni = BankAccount(name="Bank BNI", account_type="cash", initial_balance=1000000.0, company="EWI")
    bri = BankAccount(name="Bank BRI", account_type="cash", initial_balance=2000000.0, company="EWI")
    db.session.add_all([bni, bri])
    db.session.commit()

    # 1. Create Revenue with BNI
    rev = Revenue(
        invoice_date=date(2026, 3, 5),
        receive_date=date(2026, 3, 6),
        description="Project Alpha Payment",
        invoice_value=5000000.0,
        amount_received_idr=5000000.0,
        bank_id=bni.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(rev)
    db.session.flush()
    sync_revenue_bank_transaction(rev)
    db.session.commit()

    # Check BankTransaction was created
    bt = BankTransaction.query.filter_by(revenue_id=rev.id).first()
    assert bt is not None
    assert bt.bank_id == bni.id
    assert bt.amount_idr == 5000000.0
    assert bt.transaction_type == "income"
    assert bt.date == date(2026, 3, 6)

    # Check BNI real balance increased: 1,000,000 + 5,000,000 = 6,000,000
    bal_bni = calculate_bank_real_balance(bni.id)
    assert bal_bni == 6000000.0

    # 2. Update Revenue: Move from BNI to BRI
    rev.bank_id = bri.id
    sync_revenue_bank_transaction(rev)
    db.session.commit()

    bt = BankTransaction.query.filter_by(revenue_id=rev.id).first()
    assert bt is not None
    assert bt.bank_id == bri.id

    # BNI balance restored to initial, BRI balance increased: 2,000,000 + 5,000,000 = 7,000,000
    assert calculate_bank_real_balance(bni.id) == 1000000.0
    assert calculate_bank_real_balance(bri.id) == 7000000.0

    # 3. Update Revenue: Unlink bank (sumber dana '-')
    rev.bank_id = None
    sync_revenue_bank_transaction(rev)
    db.session.commit()

    bt = BankTransaction.query.filter_by(revenue_id=rev.id).first()
    assert bt is None
    assert calculate_bank_real_balance(bri.id) == 2000000.0

    # 4. Relink and test delete
    rev.bank_id = bni.id
    sync_revenue_bank_transaction(rev)
    db.session.commit()
    assert calculate_bank_real_balance(bni.id) == 6000000.0

    sync_revenue_bank_transaction(rev, is_delete=True)
    db.session.delete(rev)
    db.session.commit()

    assert BankTransaction.query.filter_by(revenue_id=rev.id).first() is None
    assert calculate_bank_real_balance(bni.id) == 1000000.0


def test_revenue_and_bank_transaction_tracks_creator(app):
    """Test user_id and creator_name are properly stored and returned for Revenue and BankTransaction."""
    user = User(username="testmanager", full_name="Manager Test", role="manager")
    user.set_password("pass123")
    bank = BankAccount(name="Bank Test", account_type="cash", initial_balance=0.0, company="EWI")
    db.session.add_all([user, bank])
    db.session.commit()

    rev = Revenue(
        invoice_date=date(2026, 3, 1),
        description="Rev with creator",
        invoice_value=1500000.0,
        amount_received_idr=1500000.0,
        bank_id=bank.id,
        user_id=user.id,
        company="EWI",
        report_year=2026,
    )
    db.session.add(rev)
    db.session.commit()

    sync_revenue_bank_transaction(rev, user_id=user.id)
    db.session.commit()

    rev_dict = TransactionDTO.revenue_to_dict(rev)
    assert rev_dict["user_id"] == user.id
    assert rev_dict["creator_name"] == "Manager Test"

    bt = BankTransaction.query.filter_by(revenue_id=rev.id).first()
    assert bt is not None
    assert bt.user_id == user.id
    assert bt.creator is not None
    assert bt.creator.full_name == "Manager Test"

    bt_dict = bt.to_dict()
    assert bt_dict["user_id"] == user.id
    assert bt_dict["creator_name"] == "Manager Test"

