from datetime import datetime, timezone
from typing import Any
from sqlalchemy.ext.hybrid import hybrid_property
from werkzeug.security import check_password_hash, generate_password_hash
from .base import db, expense_subcategories, advance_item_subcategories

class Notification(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "notifications"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    actor_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)
    action_type = db.Column(
        db.String(50), nullable=False
    )  # submit, approve, reject, create
    target_type = db.Column(
        db.String(50), nullable=False
    )  # settlement, advance, category
    target_id = db.Column(db.Integer, nullable=False)
    message = db.Column(db.Text, nullable=False)
    read_status = db.Column(db.Boolean, default=False)
    is_multi_cat = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    link_path = db.Column(db.String(200), nullable=True)
    extra_metadata = db.Column(
        db.JSON, nullable=True
    )  # Additional data (e.g., threshold_day)

    user = db.relationship(
        "User", foreign_keys=[user_id], backref="notifications_received"
    )
    actor = db.relationship(
        "User", foreign_keys=[actor_id], backref="notifications_created"
    )

    def to_dict(self):
        actor_name = self.actor.full_name if self.actor else "System"
        actor_image = self.actor.profile_image if self.actor else None
        return {
            "id": self.id,
            "user_id": self.user_id,
            "actor_id": self.actor_id,
            "actor_name": actor_name,
            "actor_profile_image": actor_image,
            "action_type": self.action_type,
            "target_type": self.target_type,
            "target_id": self.target_id,
            "message": self.message,
            "read_status": self.read_status,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "link_path": self.link_path,
            "extra_metadata": self.extra_metadata,
        }


class DeadlineSetting(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "deadline_settings"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    rule_key = db.Column(
        db.String(50), nullable=False, unique=True
    )  # SETTLEMENT_SUBMISSION or SETTLEMENT_APPROVAL
    days = db.Column(
        db.JSON, nullable=False, default=lambda: [2, 10, 20]
    )  # Array of day thresholds
    is_active = db.Column(db.Boolean, default=True)
    is_multi_cat = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at = db.Column(
        db.DateTime,
        default=lambda: datetime.now(timezone.utc),
        onupdate=lambda: datetime.now(timezone.utc),
    )

    def to_dict(self):
        return {
            "id": self.id,
            "rule_key": self.rule_key,
            "days": self.days if isinstance(self.days, list) else [],
            "is_active": self.is_active,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }


class WorkflowLog(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "workflow_logs"
    company = db.Column(db.String(100), nullable=False, server_default="EWI Foundation")
    id = db.Column(db.Integer, primary_key=True)
    document_type = db.Column(
        db.String(20), nullable=False, index=True
    )  # 'advance', 'settlement'
    document_id = db.Column(db.Integer, nullable=False, index=True)
    from_status = db.Column(db.String(30), nullable=True)
    to_status = db.Column(db.String(30), nullable=False)
    action = db.Column(
        db.String(50), nullable=False
    )  # 'submit', 'approve_t1', 'approve_t2', 'approve_t3', 'final_approve', 'reject', 'revise'
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=True)
    created_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    duration_seconds = db.Column(db.Integer, nullable=True)
    comment = db.Column(db.Text, nullable=True)

    user = db.relationship("User", backref="workflow_logs", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "document_type": self.document_type,
            "document_id": self.document_id,
            "from_status": self.from_status,
            "to_status": self.to_status,
            "action": self.action,
            "user_id": self.user_id,
            "user_name": self.user.full_name if self.user else "System",
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "duration_seconds": self.duration_seconds,
            "comment": self.comment,
        }


class OverrideLog(db.Model):
    def __init__(self, **kwargs: Any) -> None:
        super().__init__(**kwargs)

    __tablename__ = "override_logs"
    id = db.Column(db.Integer, primary_key=True)
    item_id = db.Column(db.Integer, nullable=False, index=True)  # ID Advance / Settlement
    item_type = db.Column(db.String(50), nullable=False, index=True)  # 'advance' atau 'settlement'
    changed_by = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    original_amount = db.Column(db.Float, nullable=False)
    revised_amount = db.Column(db.Float, nullable=False)
    changed_at = db.Column(db.DateTime, default=lambda: datetime.now(timezone.utc))
    notes = db.Column(db.Text, nullable=True)

    user = db.relationship("User", backref="override_logs", lazy=True)

    def to_dict(self):
        return {
            "id": self.id,
            "item_id": self.item_id,
            "item_type": self.item_type,
            "changed_by": self.changed_by,
            "changed_by_name": self.user.full_name if self.user else "Unknown",
            "original_amount": self.original_amount,
            "revised_amount": self.revised_amount,
            "changed_at": self.changed_at.isoformat() if self.changed_at else None,
            "notes": self.notes,
        }
