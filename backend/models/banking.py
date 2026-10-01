from datetime import datetime, timezone
from typing import Any
from sqlalchemy.ext.hybrid import hybrid_property
from werkzeug.security import check_password_hash, generate_password_hash
from .base import db, expense_subcategories, advance_item_subcategories

class BankAccount(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "bank_accounts"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    name = db.Column(db.String(100), nullable=False)
    account_number = db.Column(db.String(50), nullable=True)
    currency = db.Column(db.String(10), default="IDR")
    account_type = db.Column(db.String(20), default="management", server_default="management")
    initial_balance = db.Column(db.Float, default=0.0)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "account_number": self.account_number,
            "currency": self.currency,
            "account_type": self.account_type,
            "initial_balance": self.initial_balance,
        }


class BankTransaction(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "bank_transactions"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    to_bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    date = db.Column(db.Date, nullable=False)
    description = db.Column(db.String(300), nullable=False)
    amount_usd = db.Column(db.Float, default=0.0)
    amount_idr = db.Column(db.Float, default=0.0)
    transaction_type = db.Column(db.String(50))  # income, expense, transfer
    group_name = db.Column(
        db.String(100)
    )  # e.g., "Bank Interest (BRI)", "Pemindahbukuan dari..."
    report_year = db.Column(db.Integer, index=True)
    revenue_id = db.Column(
        db.Integer, db.ForeignKey("revenues.id", ondelete="SET NULL"), nullable=True, index=True
    )
    user_id = db.Column(
        db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"), nullable=True, index=True
    )
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    bank = db.relationship(
        "BankAccount", foreign_keys=[bank_id], backref="transactions_from"
    )
    to_bank = db.relationship(
        "BankAccount", foreign_keys=[to_bank_id], backref="transactions_to"
    )
    revenue = db.relationship(
        "Revenue", foreign_keys=[revenue_id], backref="bank_transactions"
    )
    creator = db.relationship(
        "User", foreign_keys=[user_id]
    )

    def to_dict(self):
        creator_name = None
        if self.creator:
            creator_name = self.creator.full_name or self.creator.username
        elif self.revenue and hasattr(self.revenue, "creator") and self.revenue.creator:
            creator_name = self.revenue.creator.full_name or self.revenue.creator.username

        return {
            "id": self.id,
            "bank_id": self.bank_id,
            "bank_name": self.bank.name if self.bank else None,
            "to_bank_id": self.to_bank_id,
            "to_bank_name": self.to_bank.name if self.to_bank else None,
            "date": self.date.isoformat() if self.date else None,
            "description": self.description,
            "amount_usd": self.amount_usd,
            "amount_idr": self.amount_idr,
            "transaction_type": self.transaction_type,
            "group_name": self.group_name,
            "report_year": self.report_year,
            "revenue_id": self.revenue_id,
            "user_id": self.user_id,
            "creator_name": creator_name,
        }


class BankStatusTransaction(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "bank_status_transactions"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    to_bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    date = db.Column(db.Date, nullable=False)
    description = db.Column(db.String(300), nullable=False)
    amount_usd = db.Column(db.Float, default=0.0)
    amount_idr = db.Column(db.Float, default=0.0)
    transaction_type = db.Column(db.String(50))  # income, expense, transfer
    group_name = db.Column(
        db.String(100)
    )  # e.g., "Bank Interest (BRI)", "Pemindahbukuan dari..."
    report_year = db.Column(db.Integer, index=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"), nullable=True, index=True
    )
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    bank = db.relationship(
        "BankAccount", foreign_keys=[bank_id], backref="status_transactions_from"
    )
    to_bank = db.relationship(
        "BankAccount", foreign_keys=[to_bank_id], backref="status_transactions_to"
    )
    creator = db.relationship(
        "User", foreign_keys=[user_id]
    )

    def to_dict(self):
        creator_name = (self.creator.full_name or self.creator.username) if self.creator else None
        return {
            "id": self.id,
            "bank_id": self.bank_id,
            "bank_name": self.bank.name if self.bank else None,
            "to_bank_id": self.to_bank_id,
            "to_bank_name": self.to_bank.name if self.to_bank else None,
            "date": self.date.isoformat() if self.date else None,
            "description": self.description,
            "amount_usd": self.amount_usd,
            "amount_idr": self.amount_idr,
            "transaction_type": self.transaction_type,
            "group_name": self.group_name,
            "report_year": self.report_year,
            "user_id": self.user_id,
            "creator_name": creator_name,
        }
