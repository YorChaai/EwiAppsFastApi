from datetime import datetime, timezone

from models import WorkflowLog, db


def log_workflow(
    document_type, document_id, from_status, to_status, action, user_id, comment=None
):
    """
    Records a workflow transition log.
    Calculates duration based on the previous log for this document.
    """
    try:
        # Get the latest log for this document to calculate duration
        last_log = (
            WorkflowLog.query.filter_by(
                document_type=document_type, document_id=document_id
            )
            .order_by(WorkflowLog.created_at.desc())
            .first()
        )

        duration_seconds = None
        if last_log:
            now = datetime.now(timezone.utc)
            # Ensure last_log.created_at has timezone info if it's naive
            last_created = last_log.created_at
            if last_created.tzinfo is None:
                last_created = last_created.replace(tzinfo=timezone.utc)

            diff = now - last_created
            duration_seconds = int(diff.total_seconds())

        new_log = WorkflowLog(
            document_type=document_type,
            document_id=document_id,
            from_status=from_status,
            to_status=to_status,
            action=action,
            user_id=user_id,
            duration_seconds=duration_seconds,
            comment=comment,
        )
        db.session.add(new_log)
        db.session.commit()
        return new_log
    except Exception as e:
        db.session.rollback()
        print(f"[!] Error logging workflow: {str(e)}")
        return None


def update_document_stage(document, stage):
    """
    Updates the current_stage of a document (Advance or Settlement).
    """
    try:
        document.current_stage = stage
        # TODO: Calculate expected_completion_at based on SLA settings if needed
        db.session.commit()
    except Exception as e:
        db.session.rollback()
        print(f"[!] Error updating document stage: {str(e)}")
