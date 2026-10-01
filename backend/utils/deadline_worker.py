"""
Background worker untuk mengecek deadline dan membuat notifikasi.
Dijalankan setiap jam 00:00 (tengah malam).
"""

from datetime import datetime, timezone

from models import Advance, DeadlineSetting, Notification, Settlement, User, db

DEADLINE_RULE_ALIASES = {
    "SETTLEMENT_APPROVAL": "SETTLEMENT_MANAGER_REVIEW",
}


def _normalize_rule_key(rule_key):
    # Backward compatibility for DB migration
    if rule_key == "ADVANCE_TO_SETTLEMENT":
        return "ADVANCE_COMPLETION"
    return DEADLINE_RULE_ALIASES.get(rule_key, rule_key)


def check_and_create_deadline_notifications():
    """
    Fungsi utama untuk check deadline dan membuat notifikasi.
    Dipanggil setiap hari jam 00:00.
    """
    try:
        today = datetime.now(timezone.utc).date()

        _cleanup_stale_deadline_notifications()
        db.session.commit()

        # Ambil semua setting deadline yang aktif
        settings = DeadlineSetting.query.filter_by(is_active=True).all()
        if not settings:
            return

        settings_map = {}
        for setting in settings:
            settings_map[_normalize_rule_key(setting.rule_key)] = sorted(setting.days)

        # =========================================
        # 1. CHECK ADVANCE_COMPLETION DEADLINE
        # =========================================
        if "ADVANCE_COMPLETION" in settings_map:
            days_thresholds = settings_map["ADVANCE_COMPLETION"]

            # Kasbon yang sudah approved Table 1 tapi belum 'completed' (finalized)
            active_advances = Advance.query.filter(
                Advance.current_stage.in_(["t2_pending", "t3_pending", "final_pending"])
            ).all()

            for advance in active_advances:
                start_date = advance.approved_at or advance.updated_at
                if not start_date:
                    continue
                days_passed = (today - start_date.date()).days

                for threshold_day in days_thresholds:
                    if days_passed >= threshold_day:
                        _create_deadline_notification_if_missing(
                            user_id=advance.user_id,
                            target_type="advance",
                            target_id=advance.id,
                            rule_key="ADVANCE_COMPLETION",
                            threshold_day=threshold_day,
                            message=f'Kasbon "{advance.title}" Anda sudah lewat {threshold_day} hari dari persetujuan Table 1, mohon segera selesaikan!',
                            link_path=f"/advances/{advance.id}",
                        )

        # =========================================
        # 2. CHECK SETTLEMENT_SUBMISSION DEADLINE
        # =========================================
        if "SETTLEMENT_SUBMISSION" in settings_map:
            days_thresholds = settings_map["SETTLEMENT_SUBMISSION"]

            # Settlement yang masih 'draft'
            draft_settlements = Settlement.query.filter(
                Settlement.current_stage == "draft"
            ).all()

            for settlement in draft_settlements:
                start_date = settlement.updated_at or settlement.created_at
                days_passed = (today - start_date.date()).days

                for threshold_day in days_thresholds:
                    if days_passed >= threshold_day:
                        _create_deadline_notification_if_missing(
                            user_id=settlement.user_id,
                            target_type="settlement",
                            target_id=settlement.id,
                            rule_key="SETTLEMENT_SUBMISSION",
                            threshold_day=threshold_day,
                            message=f'Settlement "{settlement.title}" Anda sudah tertahan di Draft selama {threshold_day} hari, mohon segera kirim!',
                            link_path=f"/settlements/{settlement.id}",
                        )

        # =========================================
        # 3. CHECK MANAGER_REVIEW DEADLINE (Table 1)
        # =========================================
        if "SETTLEMENT_MANAGER_REVIEW" in settings_map:
            days_thresholds = settings_map["SETTLEMENT_MANAGER_REVIEW"]

            t1_pending_settlements = Settlement.query.filter(
                Settlement.current_stage == "t1_pending"
            ).all()

            for settlement in t1_pending_settlements:
                start_date = settlement.submitted_at or settlement.updated_at
                days_passed = (today - start_date.date()).days

                for threshold_day in days_thresholds:
                    if days_passed >= threshold_day:
                        managers = User.query.filter_by(role="manager").all()
                        creator_name = (
                            settlement.creator.full_name
                            if settlement.creator
                            else "Unknown"
                        )

                        for manager in managers:
                            _create_deadline_notification_if_missing(
                                user_id=manager.id,
                                target_type="settlement",
                                target_id=settlement.id,
                                rule_key="SETTLEMENT_MANAGER_REVIEW",
                                threshold_day=threshold_day,
                                message=f'Settlement "{settlement.title}" dari {creator_name} sudah menunggu di Table 1 selama {threshold_day} hari!',
                                link_path=f"/settlements/{settlement.id}",
                            )

        # =========================================
        # 4. CHECK SETTLEMENT_FINAL_APPROVAL DEADLINE (Table 2/3)
        # =========================================
        if "SETTLEMENT_FINAL_APPROVAL" in settings_map:
            days_thresholds = settings_map["SETTLEMENT_FINAL_APPROVAL"]

            pending_final_settlements = Settlement.query.filter(
                Settlement.current_stage.in_(
                    ["t2_pending", "t3_pending", "final_pending"]
                )
            ).all()

            for settlement in pending_final_settlements:
                start_date = settlement.updated_at or settlement.submitted_at
                days_passed = (today - start_date.date()).days
                managers = User.query.filter_by(role="manager").all()
                creator_name = (
                    settlement.creator.full_name if settlement.creator else "Unknown"
                )

                for threshold_day in days_thresholds:
                    if days_passed >= threshold_day:
                        for manager in managers:
                            _create_deadline_notification_if_missing(
                                user_id=manager.id,
                                target_type="settlement",
                                target_id=settlement.id,
                                rule_key="SETTLEMENT_FINAL_APPROVAL",
                                threshold_day=threshold_day,
                                message=f'Settlement "{settlement.title}" dari {creator_name} sudah lewat {threshold_day} hari dari Table 1, mohon segera selesaikan Table 2/3 dan Final Approve!',
                                link_path=f"/settlements/{settlement.id}",
                            )

        db.session.commit()

    except Exception as e:
        db.session.rollback()
        print(f"[!] Error saat check deadline: {str(e)}")


def _cleanup_stale_deadline_notifications():
    notifications = Notification.query.filter_by(action_type="deadline_warning").all()

    for notification in notifications:
        rule_key = _normalize_rule_key(
            (notification.extra_metadata or {}).get("rule_key")
        )

        if notification.target_type == "advance":
            advance = Advance.query.get(notification.target_id)
            if not advance:
                db.session.delete(notification)
                continue

            if rule_key == "ADVANCE_REVISION_APPROVAL":
                if advance.status != "submitted" or not advance.active_revision_no:
                    db.session.delete(notification)
                continue

            if rule_key in (None, "ADVANCE_COMPLETION", "ADVANCE_TO_SETTLEMENT"):
                if advance.current_stage not in (
                    "t2_pending",
                    "t3_pending",
                    "final_pending",
                ):
                    db.session.delete(notification)
                continue

        if notification.target_type == "settlement":
            settlement = Settlement.query.get(notification.target_id)
            if not settlement:
                db.session.delete(notification)
                continue

            if rule_key == "SETTLEMENT_SUBMISSION":
                if settlement.current_stage != "draft":
                    db.session.delete(notification)
                continue

            if rule_key == "SETTLEMENT_MANAGER_REVIEW":
                if settlement.current_stage != "t1_pending":
                    db.session.delete(notification)
                continue

            if rule_key == "SETTLEMENT_FINAL_APPROVAL":
                if settlement.current_stage not in (
                    "t2_pending",
                    "t3_pending",
                    "final_pending",
                ):
                    db.session.delete(notification)
                continue


def _create_deadline_notification_if_missing(
    user_id, target_type, target_id, rule_key, threshold_day, message, link_path
):
    """
    Membuat notifikasi deadline jika belum ada untuk threshold hari tertentu.
    Menggunakan extra_metadata untuk melacak threshold_day.
    """
    try:
        existing = Notification.query.filter(
            Notification.user_id == user_id,
            Notification.action_type == "deadline_warning",
            Notification.target_type == target_type,
            Notification.target_id == target_id,
        ).all()

        has_notified = any(
            n.extra_metadata
            and n.extra_metadata.get("threshold_day") == threshold_day
            and (
                _normalize_rule_key(n.extra_metadata.get("rule_key")) == rule_key
                or n.extra_metadata.get("rule_key") is None
            )
            for n in existing
        )

        if has_notified:
            return

        notification = Notification(
            user_id=user_id,
            actor_id=None,
            action_type="deadline_warning",
            target_type=target_type,
            target_id=target_id,
            message=message,
            read_status=False,
            link_path=link_path,
            extra_metadata={
                "threshold_day": threshold_day,
                "rule_key": rule_key,
            },
        )
        db.session.add(notification)

    except Exception as e:
        print(f"[!] Error helper notifikasi: {str(e)}")


if __name__ == "__main__":
    # For testing purposes
    check_and_create_deadline_notifications()
