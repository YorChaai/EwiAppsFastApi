from datetime import datetime, timezone
from typing import Any
from sqlalchemy.ext.hybrid import hybrid_property
from werkzeug.security import check_password_hash, generate_password_hash
from .base import db, expense_subcategories, advance_item_subcategories

class Asset(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "assets"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    asset_code = db.Column(db.String(50), unique=True, nullable=True)
    name = db.Column(db.String(200), nullable=False)
    purchase_date = db.Column(db.Date, nullable=False)
    purchase_price = db.Column(db.Float, nullable=False)
    useful_life_months = db.Column(db.Integer, nullable=False)
    residual_value = db.Column(db.Float, default=0.0)
    asset_type = db.Column(db.String(50))
    status = db.Column(
        db.String(20), default="Active"
    )  # Active, Sold, Damaged, Disposed
    description = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        return {
            "id": self.id,
            "asset_code": self.asset_code,
            "name": self.name,
            "purchase_date": self.purchase_date.isoformat()
            if self.purchase_date
            else None,
            "purchase_price": self.purchase_price,
            "useful_life_months": self.useful_life_months,
            "residual_value": self.residual_value,
            "asset_type": self.asset_type,
            "status": self.status,
            "description": self.description,
        }


class Advance(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "advances"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(
        db.Text, nullable=True
    )  # Format: [Kategori] Vendor - Barang - Keperluan
    advance_type = db.Column(db.String(10), default="single")  # 'single' or 'batch'
    user_id = db.Column(
        db.Integer, db.ForeignKey("users.id"), nullable=False, index=True
    )
    document_date = db.Column(db.Date, nullable=True)
    status = db.Column(
        db.String(30), default="draft", index=True
    )  # draft, submitted, approved, rejected, revision_draft, revision_submitted, revision_rejected, in_settlement, completed(legacy)
    notes = db.Column(db.Text, nullable=True)  # notes approval mgr
    approved_revision_no = db.Column(db.Integer, default=0)
    active_revision_no = db.Column(db.Integer, nullable=True)
    report_year = db.Column(db.Integer, nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = db.Column(
        db.DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
    approved_at = db.Column(db.DateTime, nullable=True)
    bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    disbursement_source = db.Column(db.String(50), nullable=True)
    disbursement_source_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    return_source = db.Column(db.String(50), nullable=True)
    return_source_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    admin_fee = db.Column(db.Float, default=0.0)
    disbursed_amount = db.Column(db.Float, nullable=True)
    returned_amount = db.Column(db.Float, default=0.0)
    disbursement_comment = db.Column(db.Text, nullable=True)
    return_description = db.Column(db.Text, nullable=True)
    disbursement_evidence_path = db.Column(db.Text, nullable=True)
    disbursement_evidence_filename = db.Column(db.Text, nullable=True)
    return_evidence_path = db.Column(db.Text, nullable=True)
    return_evidence_filename = db.Column(db.Text, nullable=True)
    is_disbursement_approved = db.Column(db.Boolean, default=False)
    is_return_approved = db.Column(db.Boolean, default=False)
    return_status = db.Column(
        db.String(20), default="pending"
    )  # pending, submitted, rejected, approved
    return_notes = db.Column(db.Text, nullable=True)  # Manager comments on return
    modified_t1 = db.Column(db.Boolean, default=False)
    modified_t2 = db.Column(db.Boolean, default=False)
    modified_t3 = db.Column(db.Boolean, default=False)
    current_stage = db.Column(db.String(30), default="draft")
    expected_completion_at = db.Column(db.DateTime(timezone=True), nullable=True)
    approved_amount_override = db.Column(db.Float, nullable=True)

    items = db.relationship(
        "AdvanceItem",
        backref="advance",
        lazy=True,
        cascade="all, delete-orphan",
        order_by="AdvanceItem.id",
    )
    bank = db.relationship("BankAccount", foreign_keys=[bank_id])
    disbursement_bank = db.relationship("BankAccount", foreign_keys=[disbursement_source_id])
    return_bank = db.relationship("BankAccount", foreign_keys=[return_source_id])
    asset_id = db.Column(
        db.Integer, db.ForeignKey("assets.id"), nullable=True
    )  # Added for repair cost link
    asset = db.relationship("Asset", backref="advances", lazy=True)

    @property
    def total_amount(self):
        return sum((item.idr_amount or 0) for item in self.items)

    @property
    def approved_amount(self):
        if self.approved_amount_override is not None:
            return self.approved_amount_override
        return sum(
            (item.idr_amount or 0)
            for item in self.items
            if (item.revision_no or 0) <= (self.approved_revision_no or 0)
        )

    @property
    def base_amount(self):
        return sum(
            (item.idr_amount or 0)
            for item in self.items
            if (item.revision_no or 0) == 0
        )

    @property
    def revision_amount(self):
        return max(0, self.approved_amount - self.base_amount)

    @property
    def max_revision_no(self):
        revision_numbers = [item.revision_no or 0 for item in self.items]
        return max(revision_numbers, default=0)

    @property
    def rejected_count(self):
        return sum(1 for item in self.items if item.status == "rejected")

    def to_dict(self, include_items=False):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.advance_to_dict(self, include_items=include_items)

class AdvanceItem(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "advance_items"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    advance_id = db.Column(db.Integer, db.ForeignKey("advances.id"), nullable=False)
    category_id = db.Column(db.Integer, db.ForeignKey("categories.id"), nullable=False)
    description = db.Column(
        db.String(300), nullable=False
    )  # Format: [Kategori] Vendor - Barang - Keperluan
    estimated_amount = db.Column(db.Float, nullable=False)
    revision_no = db.Column(db.Integer, default=0)
    evidence_path = db.Column(db.Text, nullable=True)
    evidence_filename = db.Column(db.Text, nullable=True)

    date = db.Column(db.Date, nullable=True)
    source = db.Column(db.String(50), nullable=True)
    currency = db.Column(db.String(10), default="IDR")
    currency_exchange = db.Column(db.Float, default=1.0)
    status = db.Column(db.String(20), default="pending")  # pending, approved, rejected
    notes = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    asset_id = db.Column(
        db.Integer, db.ForeignKey("assets.id"), nullable=True
    )  # Added for repair cost link
    asset = db.relationship("Asset", backref="advance_items", lazy=True)

    category = db.relationship("Category")
    subcategories = db.relationship(
        "Category",
        secondary=advance_item_subcategories,
        backref="advance_items",
        lazy="subquery",
    )

    @property
    def combined_subcategory_label(self):
        """Returns alphabetically sorted comma separated names of subcategories."""
        if self.subcategories:
            names = []
            for c in sorted(self.subcategories, key=lambda x: x.name):
                if c.status == "pending":
                    names.append(f"{c.name} (Pending)")
                else:
                    names.append(c.name)
            return " , ".join(names)
        if self.category and self.category.parent:
            if self.category.status == "pending":
                return f"{self.category.name} (Pending)"
            return self.category.name
        return "-"

    @hybrid_property
    def idr_amount(self):
        if self.currency != "IDR" and self.currency_exchange:
            return self.estimated_amount * self.currency_exchange
        return self.estimated_amount

    @idr_amount.expression
    def idr_amount(cls):
        return db.case(
            (
                db.and_(cls.currency != "IDR", cls.currency_exchange.isnot(None)),
                cls.estimated_amount * cls.currency_exchange,
            ),
            else_=cls.estimated_amount,
        )

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.advanceitem_to_dict(self)

class Settlement(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "settlements"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text, nullable=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey("users.id"), nullable=False, index=True
    )
    document_date = db.Column(db.Date, nullable=True)
    settlement_type = db.Column(db.String(10), default="single")  # 'single' or 'batch'
    status = db.Column(
        db.String(20), default="draft", index=True
    )  # draft, submitted, approved, rejected, completed(legacy)
    report_year = db.Column(db.Integer, nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = db.Column(
        db.DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )
    submitted_at = db.Column(db.DateTime, nullable=True)
    completed_at = db.Column(db.DateTime, nullable=True)
    bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    disbursement_source = db.Column(db.String(50), nullable=True)
    disbursement_source_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    return_source = db.Column(db.String(50), nullable=True)
    return_source_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    admin_fee = db.Column(db.Float, default=0.0)
    disbursed_amount = db.Column(db.Float, nullable=True)
    disbursement_date = db.Column(db.Date, nullable=True)
    returned_amount = db.Column(db.Float, default=0.0)
    disbursement_comment = db.Column(db.Text, nullable=True)
    return_description = db.Column(db.Text, nullable=True)
    disbursement_evidence_path = db.Column(db.Text, nullable=True)
    disbursement_evidence_filename = db.Column(db.Text, nullable=True)
    return_evidence_path = db.Column(db.Text, nullable=True)
    return_evidence_filename = db.Column(db.Text, nullable=True)
    is_disbursement_approved = db.Column(db.Boolean, default=False)
    is_return_approved = db.Column(db.Boolean, default=False)
    return_status = db.Column(
        db.String(20), default="pending"
    )  # pending, submitted, rejected, approved
    return_notes = db.Column(db.Text, nullable=True)  # Manager comments on return
    modified_t1 = db.Column(db.Boolean, default=False)
    modified_t2 = db.Column(db.Boolean, default=False)
    modified_t3 = db.Column(db.Boolean, default=False)
    current_stage = db.Column(db.String(30), default="draft")
    expected_completion_at = db.Column(db.DateTime(timezone=True), nullable=True)
    approved_amount_override = db.Column(db.Float, nullable=True)
    advance_id = db.Column(db.Integer, db.ForeignKey("advances.id"), nullable=True)

    advance = db.relationship("Advance", backref="settlements")
    expenses = db.relationship(
        "Expense",
        backref="settlement",
        lazy=True,
        cascade="all, delete-orphan",
        order_by="Expense.id",
    )
    bank = db.relationship("BankAccount", foreign_keys=[bank_id])
    disbursement_bank = db.relationship("BankAccount", foreign_keys=[disbursement_source_id])
    return_bank = db.relationship("BankAccount", foreign_keys=[return_source_id])

    @property
    def total_amount(self):
        return sum((e.idr_amount or 0) for e in self.expenses)

    @property
    def approved_amount(self):
        if self.approved_amount_override is not None:
            return self.approved_amount_override
        return sum((e.idr_amount or 0) for e in self.expenses if e.status in ("approved", "completed"))

    @property
    def rejected_count(self):
        return sum(1 for e in self.expenses if e.status == "rejected")

    def to_dict(self, include_expenses=False):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.settlement_to_dict(self, include_expenses=include_expenses)

class Expense(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "expenses"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    settlement_id = db.Column(
        db.Integer, db.ForeignKey("settlements.id"), nullable=False, index=True
    )
    category_id = db.Column(
        db.Integer, db.ForeignKey("categories.id"), nullable=False, index=True
    )
    description = db.Column(
        db.String(300), nullable=False
    )  # Format: [Kategori] Vendor - Barang - Keperluan
    amount = db.Column(db.Float, nullable=False)
    date = db.Column(db.Date, nullable=False, index=True)
    source = db.Column(db.String(50), nullable=True)  # bca, bri, cash, dll
    revision_no = db.Column(db.Integer, default=0)
    currency = db.Column(db.String(10), default="IDR")  # idr, usd
    currency_exchange = db.Column(db.Float, default=1)  # exchange rate
    evidence_path = db.Column(db.Text, nullable=True)
    evidence_filename = db.Column(db.Text, nullable=True)

    status = db.Column(db.String(20), default="pending")  # pending, approved, rejected
    notes = db.Column(db.Text, nullable=True)  # notes
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    asset_id = db.Column(
        db.Integer, db.ForeignKey("assets.id"), nullable=True
    )  # Added for repair cost link
    asset = db.relationship("Asset", backref="expenses", lazy=True)

    subcategories = db.relationship(
        "Category",
        secondary=expense_subcategories,
        backref="expense_items",
        lazy="subquery",
    )

    @property
    def combined_subcategory_label(self):
        """Returns alphabetically sorted comma separated names of subcategories."""
        if self.subcategories:
            names = []
            for c in sorted(self.subcategories, key=lambda x: x.name):
                if c.status == "pending":
                    names.append(f"{c.name} (Pending)")
                else:
                    names.append(c.name)
            return " , ".join(names)
        if self.category and self.category.parent:
            if self.category.status == "pending":
                return f"{self.category.name} (Pending)"
            return self.category.name
        return "-"

    @hybrid_property
    def idr_amount(self):
        # amount idr setelah exchange
        if self.currency != "IDR" and self.currency_exchange:
            return self.amount * self.currency_exchange
        return self.amount

    @idr_amount.expression
    def idr_amount(cls):
        return db.case(
            (
                db.and_(cls.currency != "IDR", cls.currency_exchange.isnot(None)),
                cls.amount * cls.currency_exchange,
            ),
            else_=cls.amount,
        )

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.expense_to_dict(self)

class Revenue(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "revenues"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    invoice_date = db.Column(db.Date, nullable=False, index=True)
    description = db.Column(db.String(300), nullable=False)
    invoice_value = db.Column(db.Float, nullable=False)  # Legacy / Master value

    # 2026 Dual Currency Columns
    invoice_value_usd = db.Column(db.Float, nullable=True)
    invoice_value_idr = db.Column(db.Float, nullable=True)

    currency = db.Column(db.String(10), default="IDR")
    currency_exchange = db.Column(db.Float, nullable=True)  # nilai tukar jika bukan idr
    invoice_number = db.Column(db.String(50), nullable=True)
    client = db.Column(db.String(150), nullable=True)
    receive_date = db.Column(db.Date, nullable=True)
    amount_received = db.Column(db.Float, nullable=True)  # Legacy

    # 2026 Amount Received Dual Currency
    amount_received_idr = db.Column(db.Float, nullable=True)
    amount_received_usd = db.Column(db.Float, nullable=True)

    ppn = db.Column(db.Float, nullable=True)
    pph_23 = db.Column(db.Float, nullable=True)
    transfer_fee = db.Column(db.Float, nullable=True)
    remark = db.Column(db.Text, nullable=True)
    revenue_type = db.Column(
        db.String(32), nullable=False, default="pendapatan_langsung", index=True
    )
    is_selected_for_tax_offset = db.Column(
        db.Boolean, default=True
    )  # Added for manual tax reconciliation
    report_year = db.Column(db.Integer, nullable=True, index=True)
    bank_id = db.Column(db.Integer, db.ForeignKey("bank_accounts.id"), nullable=True)
    user_id = db.Column(
        db.Integer, db.ForeignKey("users.id", ondelete="SET NULL"), nullable=True, index=True
    )
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    bank = db.relationship("BankAccount", foreign_keys=[bank_id], backref="revenues")
    creator = db.relationship("User", foreign_keys=[user_id])

    REVENUE_DIRECT = "pendapatan_langsung"
    REVENUE_OTHER = "pendapatan_lain_lain"

    @staticmethod
    def normalize_revenue_type(value):
        raw = (value or "").strip().lower().replace(" ", "_")
        mapping = {
            "langsung": "pendapatan_langsung",
            "pendapatan_langsung": "pendapatan_langsung",
            "lain": "pendapatan_lain_lain",
            "lain_lain": "pendapatan_lain_lain",
            "pendapatan_lain_lain": "pendapatan_lain_lain",
        }
        return mapping.get(raw, "pendapatan_langsung")

    @property
    def idr_invoice_value(self):
        # 2026 priority
        if self.invoice_value_idr is not None:
            return self.invoice_value_idr
        # Fallback
        if self.currency != "IDR" and self.currency_exchange:
            return self.invoice_value * self.currency_exchange
        return self.invoice_value

    @property
    def idr_amount_received(self):
        # 2026 priority
        if self.amount_received_idr is not None:
            return self.amount_received_idr
        # Fallback
        if self.amount_received is None:
            return 0
        if self.currency != "IDR" and self.currency_exchange:
            return self.amount_received * self.currency_exchange
        return self.amount_received

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.revenue_to_dict(self)

class Tax(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "taxes"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False, index=True)
    description = db.Column(db.String(300), nullable=False)
    transaction_value = db.Column(db.Float, nullable=False)  # Legacy / Master

    # 2026 Columns
    invoice_value_usd = db.Column(db.Float, nullable=True)
    transaction_value_idr = db.Column(db.Float, nullable=True)

    currency = db.Column(db.String(10), default="IDR")
    currency_exchange = db.Column(db.Float, nullable=True)

    # simpan nilai nominal pajak saja
    ppn = db.Column(db.Float, nullable=True)
    ppn_base = db.Column(db.Float, nullable=True)
    pph_21 = db.Column(db.Float, nullable=True)
    pph_21_base = db.Column(db.Float, nullable=True)
    pph_23 = db.Column(db.Float, nullable=True)
    pph_23_base = db.Column(db.Float, nullable=True)
    pph_26 = db.Column(db.Float, nullable=True)
    pph_26_base = db.Column(db.Float, nullable=True)
    pemasukan_negara = db.Column(db.Float, nullable=True)
    pemasukan_negara_base = db.Column(db.Float, nullable=True)
    report_year = db.Column(db.Integer, nullable=True, index=True)

    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    @property
    def idr_transaction_value(self):
        # 2026 priority
        if self.transaction_value_idr is not None:
            return self.transaction_value_idr
        # Fallback
        if self.currency != "IDR" and self.currency_exchange:
            return self.transaction_value * self.currency_exchange
        return self.transaction_value

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.tax_to_dict(self)

class ManualCombineGroup(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "manual_combine_groups"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    table_name = db.Column(db.String(20), nullable=False)
    report_year = db.Column(db.Integer, nullable=False)
    group_date = db.Column(db.Date, nullable=False)
    row_ids_json = db.Column(db.Text, nullable=False)
    merged_columns_json = db.Column(db.Text, nullable=True)  # List of column names
    original_data_json = db.Column(
        db.Text, nullable=True
    )  # Backup of original row data for restoration
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def row_ids(self):
        try:
            import json

            data = json.loads(self.row_ids_json or "[]")
            if isinstance(data, list):
                return [int(x) for x in data]
        except Exception:
            pass
        return []

    def merged_columns(self):
        try:
            import json

            data = json.loads(self.merged_columns_json or "[]")
            if isinstance(data, list):
                return [str(x) for x in data]
        except Exception:
            pass
        return []

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.manualcombinegroup_to_dict(self)

class Dividend(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "dividends"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    date = db.Column(db.Date, nullable=False, index=True)
    name = db.Column(db.String(150), nullable=False)
    amount = db.Column(db.Float, nullable=False, default=0.0)
    percentage = db.Column(db.Float, nullable=False, default=0.0)
    recipient_count = db.Column(db.Integer, nullable=False, default=1)
    tax_percentage = db.Column(db.Float, nullable=False, default=0.0)
    report_year = db.Column(db.Integer, nullable=True, index=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.dividend_to_dict(self)

class DividendSetting(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "dividend_settings"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    year = db.Column(db.Integer, nullable=False, unique=True)
    profit_retained = db.Column(db.Float, nullable=False, default=0.0)
    opening_cash_balance = db.Column(db.Float, nullable=False, default=0.0)
    accounts_receivable = db.Column(db.Float, nullable=False, default=0.0)
    prepaid_tax_pph23 = db.Column(db.Float, nullable=False, default=0.0)
    prepaid_expenses = db.Column(db.Float, nullable=False, default=0.0)
    other_receivables = db.Column(db.Float, nullable=False, default=0.0)
    office_inventory = db.Column(db.Float, nullable=False, default=0.0)
    other_assets = db.Column(db.Float, nullable=False, default=0.0)
    accounts_payable = db.Column(db.Float, nullable=False, default=0.0)
    salary_payable = db.Column(db.Float, nullable=False, default=0.0)
    shareholder_payable = db.Column(db.Float, nullable=False, default=0.0)
    accrued_expenses = db.Column(db.Float, nullable=False, default=0.0)
    share_capital = db.Column(db.Float, nullable=False, default=0.0)
    retained_earnings_balance = db.Column(db.Float, nullable=False, default=0.0)
    corporate_tax_pph29 = db.Column(db.Float, nullable=False, default=0.0)
    corporate_tax_rate = db.Column(
        db.Float, nullable=False, default=0.11
    )  # Added for variable rate (11%, 22%, 50%)
    other_income = db.Column(db.Float, nullable=False, default=0.0)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        from services.dto.transaction_dto import TransactionDTO
        return TransactionDTO.dividendsetting_to_dict(self)
