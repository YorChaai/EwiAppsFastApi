from fastapi import APIRouter, Depends, Header, Query
from core.security import get_current_user
from services.core.notification_events import _can_access_notification

from models import Notification, User, db

notifications_bp = APIRouter(prefix='/api/notifications', tags=['notifications'])


@notifications_bp.get('')
def get_notifications(
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
    read_status: str = Query(default='all'),
    limit: int = Query(default=50),
    offset: int = Query(default=0),
):
    """
    Get notifications for the logged-in user.
    Role-based:
    - Manager: sees all notifications in the system for the active company
    - Staff & Mitra: sees only their own notifications (personal)
    Query params:
    - read_status: true/false/all (default: all)
    - limit: number of notifications (default: 50)
    - offset: pagination offset (default: 0)
    """
    user_id = user.id
    company = company or 'EWI Foundation'
    read_status = read_status.lower()
    limit = min(limit, 100)

    if user.role in ['manager', 'super_manager']:
        query = Notification.query.filter(Notification.company == company)
        unread_count = Notification.query.filter(
            Notification.company == company,
            Notification.read_status == False
        ).count()
    else:
        query = Notification.query.filter_by(user_id=user_id)
        unread_count = Notification.query.filter_by(user_id=user_id, read_status=False).count()

    if read_status == 'true':
        query = query.filter_by(read_status=True)
    elif read_status == 'false':
        query = query.filter_by(read_status=False)

    total = query.count()
    notifications = query.order_by(Notification.created_at.desc()).limit(limit).offset(offset).all()

    return {
        'success': True,
        'data': [notif.to_dict() for notif in notifications],
        'total': total,
        'unread_count': unread_count,
        'limit': limit,
        'offset': offset
    }




@notifications_bp.put('/{notification_id}/read')
def mark_notification_as_read(
    notification_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
):
    """Mark single notification as read"""
    user_id = user.id
    company = company or 'EWI Foundation'

    notification = Notification.query.get(notification_id)
    if not notification or not _can_access_notification(user, notification):
        from fastapi.responses import JSONResponse
        return JSONResponse({'success': False, 'message': 'Notification not found'}, status_code=404)

    notification.read_status = True
    db.session.commit()

    if user.role in ['manager', 'super_manager']:
        unread_count = Notification.query.filter(
            Notification.company == company,
            Notification.read_status == False
        ).count()
    else:
        unread_count = Notification.query.filter_by(user_id=user_id, read_status=False).count()

    return {
        'success': True,
        'message': 'Notification marked as read',
        'data': notification.to_dict(),
        'unread_count': unread_count
    }


@notifications_bp.put('/mark-all-read')
def mark_all_notifications_as_read(
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
):
    """Mark all notifications as read. Manager: semua notifikasi. Staff/Mitra: milik sendiri."""
    user_id = user.id
    company = company or 'EWI Foundation'

    if user.role in ['manager', 'super_manager']:
        Notification.query.filter(
            Notification.company == company,
            Notification.read_status == False
        ).update({'read_status': True}, synchronize_session=False)
    else:
        Notification.query.filter_by(user_id=user_id, read_status=False).update({'read_status': True})
    db.session.commit()

    return {
        'success': True,
        'message': 'All notifications marked as read',
        'unread_count': 0
    }


@notifications_bp.delete('/{notification_id}')
def delete_notification(
    notification_id: int,
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
):
    """Delete a single notification"""
    user_id = user.id
    company = company or 'EWI Foundation'

    notification = Notification.query.get(notification_id)
    if not notification or not _can_access_notification(user, notification):
        from fastapi.responses import JSONResponse
        return JSONResponse({'success': False, 'message': 'Notification not found'}, status_code=404)

    db.session.delete(notification)
    db.session.commit()

    if user.role in ['manager', 'super_manager']:
        unread_count = Notification.query.filter(
            Notification.company == company,
            Notification.read_status == False
        ).count()
    else:
        unread_count = Notification.query.filter_by(user_id=user_id, read_status=False).count()

    return {
        'success': True,
        'message': 'Notification deleted',
        'unread_count': unread_count
    }


@notifications_bp.get('/unread-count')
def get_unread_count(
    user: User = Depends(get_current_user),
    company: str = Header(default='EWI Foundation', alias='X-Company'),
):
    """Get unread notification count. Manager: semua notifikasi. Staff/Mitra: milik sendiri."""
    user_id = user.id
    company = company or 'EWI Foundation'

    if user.role in ['manager', 'super_manager']:
        unread_count = Notification.query.filter(
            Notification.company == company,
            Notification.read_status == False
        ).count()
    else:
        unread_count = Notification.query.filter_by(user_id=user_id, read_status=False).count()

    return {
        'success': True,
        'unread_count': unread_count
    }


# Helper functions
