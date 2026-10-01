from datetime import datetime, timezone

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from core.security import create_access_token
from models import User
from services.core.notification_events import notify_user_returned


def _internal_login(identifier: str, password: str, db: Session) -> dict:
    identifier = identifier.strip()

    if not identifier or not password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username/Email dan password harus diisi"
        )

    user = db.query(User).filter(
        (User.username == identifier) | (User.email == identifier)
    ).first()

    if not user or not user.check_password(password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Username/Email atau password salah"
        )

    last_login = user.last_login
    notify_return = False
    days_since_last_login = 0

    if last_login:
        if last_login.tzinfo is None:
            last_login = last_login.replace(tzinfo=timezone.utc)
        days_since_last_login = (datetime.now(timezone.utc) - last_login).days
        notify_return = days_since_last_login > 30

    user.last_login = datetime.now(timezone.utc)
    db.commit()

    if notify_return:
        notify_user_returned(user, days_since_last_login)

    token = create_access_token(identity=user.id)
    return {"token": token, "access_token": token, "user": user.to_dict()}
