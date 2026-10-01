from datetime import datetime, timezone
from typing import Any
from sqlalchemy.ext.hybrid import hybrid_property
from werkzeug.security import check_password_hash, generate_password_hash
from .base import db, expense_subcategories, advance_item_subcategories

class Company(db.Model):
    __tablename__ = 'companies'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False, unique=True)
    sort_order = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'sort_order': self.sort_order,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }


class User(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(150), unique=True, nullable=True)  # Gmail for Login/OTP
    password_hash = db.Column(db.String(256), nullable=False)
    google_id = db.Column(
        db.String(200), nullable=True, unique=True
    )  # For Google Sign-In
    reset_token = db.Column(db.String(100), nullable=True)  # For Forgot Password OTP
    reset_token_expiry = db.Column(db.DateTime, nullable=True)
    full_name = db.Column(db.String(150), nullable=False)
    phone_number = db.Column(db.String(20), nullable=True, default="-")
    workplace = db.Column(db.String(100), nullable=True, default="-")
    role = db.Column(
        db.String(20), nullable=False, default="staff"
    )  # staff, manager, mitra_eks
    company_access = db.Column(db.JSON, nullable=True)  # List of company names
    profile_image = db.Column(db.String(500), nullable=True)
    default_report_year = db.Column(db.Integer, nullable=True)
    last_login = db.Column(db.DateTime, nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))

    settlements = db.relationship("Settlement", backref="creator", lazy=True)
    advances = db.relationship("Advance", backref="requester", lazy=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    @property
    def last_login_formatted(self):
        if self.last_login is None:
            return "-"

        last = self.last_login
        if last.tzinfo is None:
            last = last.replace(tzinfo=timezone.utc)

        now = datetime.now(timezone.utc)
        diff = now - last
        total_seconds = int(diff.total_seconds())

        if total_seconds < 86400:
            if total_seconds < 60:
                return "Baru saja"
            elif total_seconds < 3600:
                return f"{total_seconds // 60} menit yang lalu"
            else:
                return f"{total_seconds // 3600} jam yang lalu"

        months = {
            1: "Jan",
            2: "Feb",
            3: "Mar",
            4: "Apr",
            5: "Mei",
            6: "Jun",
            7: "Jul",
            8: "Agt",
            9: "Sep",
            10: "Okt",
            11: "Nov",
            12: "Des",
        }
        return f"{last.day} {months[last.month]}, {last.strftime('%H:%M')}"

    @property
    def is_online(self):
        if self.last_login is None:
            return False
        last = self.last_login
        if last.tzinfo is None:
            last = last.replace(tzinfo=timezone.utc)
        diff = datetime.now(timezone.utc) - last
        return diff.total_seconds() < 120

    def to_dict(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "google_id": self.google_id,
            "full_name": self.full_name,
            "phone_number": self.phone_number or "-",
            "workplace": self.workplace or "-",
            "role": self.role,
            "company_access": self.company_access or ["EWI Foundation"],
            "profile_image": self.profile_image,
            "default_report_year": self.default_report_year,
            "last_login": self.last_login.isoformat() if self.last_login else None,
            "last_login_formatted": self.last_login_formatted,
            "is_online": self.is_online,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }


class CategoryGroup(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "category_groups"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    sort_order = db.Column(db.Integer, default=0)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "sort_order": self.sort_order,
            "company": self.company,
        }


class Category(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "categories"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    code = db.Column(db.String(10), unique=True, nullable=False)  # a, b, c...
    parent_id = db.Column(
        db.Integer, db.ForeignKey("categories.id"), nullable=True, index=True
    )
    status = db.Column(
        db.String(20), default="approved", index=True
    )  # approved, pending
    created_by = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)
    sort_order = db.Column(db.Integer, default=0)  # For manual category ordering
    main_group = db.Column(
        db.String(100), nullable=True
    )  # Matches CategoryGroup.name (e.g. BEBAN LANGSUNG)

    children = db.relationship(
        "Category", backref=db.backref("parent", remote_side=[id]), lazy=True
    )
    expenses = db.relationship("Expense", backref="category", lazy=True)

    @property
    def full_name(self):
        if self.parent:
            return f"{self.parent.name} > {self.name}"
        return self.name

    def to_dict(self, include_children=False):
        data = {
            "id": self.id,
            "name": self.name,
            "full_name": self.full_name,
            "code": self.code,
            "parent_id": self.parent_id,
            "status": self.status,
            "created_by": self.created_by,
            "sort_order": self.sort_order,
            "main_group": self.main_group,
        }
        if include_children:
            data["children"] = [c.to_dict() for c in self.children]
        return data
