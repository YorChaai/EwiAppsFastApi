"""
FastAPI routes for /api/auth.
"""
import uuid
from datetime import datetime, timedelta, timezone
from fastapi import APIRouter, Body, Depends, Header, status, HTTPException, Request
from fastapi.responses import HTMLResponse, JSONResponse
from sqlalchemy.orm import Session

from core.database import get_db
from core.security import create_access_token, get_current_user, require_role
from core.rate_limit import enforce_login_limit
from models import User
from services.core.auth_service import _internal_login
from services.core.email_service import generate_otp, send_reset_password_otp
from schemas.auth import (
    CreateUserSchema,
    ForgotPasswordSchema,
    GoogleLoginSchema,
    LinkGoogleSchema,
    LoginSchema,
    ProfileUpdateSchema,
    RegisterSchema,
    ResetPasswordSchema,
    UpdateUserSchema,
)

router = APIRouter(prefix="/api/auth", tags=["Auth"])


@router.post("/login")
def login(request: Request, payload: dict = Body(default={}), db: Session = Depends(get_db)):
    username = payload.get("username") if isinstance(payload, dict) else None
    password = payload.get("password") if isinstance(payload, dict) else None
    if not username or not password:
        return JSONResponse(
            content={"error": "Username and password are required"},
            status_code=status.HTTP_400_BAD_REQUEST,
        )
    enforce_login_limit(request)
    return _internal_login(username, password, db)


@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(payload: RegisterSchema, db: Session = Depends(get_db)):
    username = payload.username.strip()
    full_name = payload.full_name.strip()
    email = (payload.email or "").strip().lower() or None
    google_id = (payload.google_id or "").strip() or None
    phone_number = (payload.phone_number or "-").strip() or "-"
    if not username or not payload.password or not full_name:
        raise HTTPException(status_code=400, detail="Username, password, dan nama lengkap wajib diisi")
    if phone_number != "-" and not phone_number.isdigit():
        raise HTTPException(status_code=400, detail="Nomor HP harus berupa angka")
    if len(payload.password) < 6:
        raise HTTPException(status_code=400, detail="Password minimal 6 karakter")
    if db.query(User).filter_by(username=username).first():
        raise HTTPException(status_code=409, detail="Username sudah dipakai, gunakan yang lain")
    if email and db.query(User).filter_by(email=email).first():
        raise HTTPException(status_code=409, detail="Email sudah dipakai, gunakan email lain")
    if google_id and db.query(User).filter_by(google_id=google_id).first():
        raise HTTPException(status_code=409, detail="Akun Google ini sudah terhubung ke user lain")

    role = payload.role if payload.role in ["staff", "mitra_eks"] else "staff"
    user = User(
        username=username,
        email=email,
        google_id=google_id,
        full_name=full_name,
        phone_number=phone_number,
        workplace=(payload.workplace or "-").strip() or "-",
        role=role,
        company_access=payload.company_access or ["EWI Foundation"],
    )
    user.set_password(payload.password)
    db.add(user)
    db.commit()
    db.refresh(user)
    from services.core.notification_events import notify_user_registered
    notify_user_registered(user, full_name, username, role)
    return {"message": "Akun berhasil dibuat! Silakan login.", "user": user.to_dict()}


@router.post("/forgot-password")
def forgot_password(payload: ForgotPasswordSchema, db: Session = Depends(get_db)):
    email = payload.email.strip()
    if not email:
        raise HTTPException(status_code=400, detail="Email wajib diisi")
    user = db.query(User).filter_by(email=email).first()
    if not user:
        return {"message": "Jika email terdaftar, kode OTP akan dikirim."}
    otp = generate_otp()
    user.reset_token = otp
    user.reset_token_expiry = datetime.now(timezone.utc) + timedelta(minutes=10)
    db.commit()
    return send_reset_password_otp(email, user, otp)


@router.post("/reset-password")
def reset_password(payload: ResetPasswordSchema, db: Session = Depends(get_db)):
    user = db.query(User).filter_by(email=payload.email.strip(), reset_token=payload.otp.strip()).first()
    if not user or not user.reset_token_expiry:
        raise HTTPException(status_code=400, detail="Kode OTP salah atau tidak valid")
    expiry = user.reset_token_expiry
    if expiry.tzinfo is None:
        expiry = expiry.replace(tzinfo=timezone.utc)
    if datetime.now(timezone.utc) > expiry:
        raise HTTPException(status_code=400, detail="Kode OTP telah kadaluarsa")
    if len(payload.new_password) < 6:
        raise HTTPException(status_code=400, detail="Password minimal 6 karakter")
    user.set_password(payload.new_password)
    user.reset_token = None
    user.reset_token_expiry = None
    db.commit()
    return {"message": "Password berhasil diganti. Silakan login kembali."}


@router.post("/google-login")
def google_login(payload: GoogleLoginSchema, db: Session = Depends(get_db)):
    from google.auth.transport import requests as g_requests
    from google.oauth2 import id_token as google_id_token
    from config import Config
    try:
        id_info = google_id_token.verify_oauth2_token(payload.id_token, g_requests.Request(), Config.GOOGLE_CLIENT_ID)
        email = id_info.get("email")
        google_id = id_info.get("sub")
        full_name = id_info.get("name")
        user = db.query(User).filter((User.google_id == google_id) | (User.email == email)).first()
        if not user:
            user = User(username=email.split("@")[0], full_name=full_name, email=email, google_id=google_id, role="staff", company_access=["EWI Foundation"])
            user.set_password(str(uuid.uuid4()))
            db.add(user)
            db.commit()
            db.refresh(user)
        else:
            if not user.google_id:
                user.google_id = google_id
            if not user.email:
                user.email = email
            db.commit()
        token = create_access_token(identity=user.id)
        return {"access_token": token, "user": user.to_dict()}
    except ValueError:
        raise HTTPException(status_code=401, detail="Verifikasi token Google gagal")


@router.get("/me")
def get_me(current_user: User = Depends(get_current_user)):
    return {"user": current_user.to_dict()}


@router.put("/profile")
def update_profile(payload: ProfileUpdateSchema, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    user = db.get(User, current_user.id)
    if payload.full_name:
        user.full_name = payload.full_name.strip()
    if payload.phone_number:
        if payload.phone_number != "-" and not payload.phone_number.isdigit():
            raise HTTPException(status_code=400, detail="Nomor HP harus berupa angka")
        user.phone_number = payload.phone_number.strip()
    if payload.workplace:
        user.workplace = payload.workplace.strip()
    if payload.current_password and payload.new_password:
        if not user.check_password(payload.current_password):
            raise HTTPException(status_code=400, detail="Password lama tidak cocok")
        if len(payload.new_password) < 6:
            raise HTTPException(status_code=400, detail="Password baru minimal 6 karakter")
        user.set_password(payload.new_password)
    db.commit()
    return {"success": True, "user": user.to_dict()}


@router.get("/me/outstanding")
def get_outstanding(current_user: User = Depends(get_current_user), x_company: str = Header(default="EWI Foundation")):
    from services.balance.balance_service import calculate_user_running_balance

    outstanding = calculate_user_running_balance(current_user.id, company=x_company)
    return {
        "user_id": current_user.id,
        "outstanding": outstanding,
        "is_indebted": outstanding > 0.01,
    }


@router.get("/users")
def list_users(current_user: User = Depends(require_role("manager", "super_manager"))):
    users = User.query.filter(User.role.in_(["staff", "manager", "mitra_eks", "super_manager"])).all()
    return {"users": [u.to_dict() for u in users]}


@router.post("/users", status_code=status.HTTP_201_CREATED)
def create_user(payload: CreateUserSchema, current_user: User = Depends(require_role("manager", "super_manager")), db: Session = Depends(get_db)):
    username = payload.username.strip()
    if not username or not payload.password or not payload.full_name:
        raise HTTPException(status_code=400, detail="Semua field wajib diisi")
    phone = payload.phone_number or "-"
    if phone != "-" and not phone.isdigit():
        raise HTTPException(status_code=400, detail="Nomor HP harus berupa angka")
    if db.query(User).filter_by(username=username).first():
        raise HTTPException(status_code=409, detail="Username sudah terdaftar")
    role = payload.role if payload.role in ["staff", "manager", "mitra_eks", "super_manager"] else "staff"
    if role == "super_manager" and current_user.role != "super_manager":
        raise HTTPException(status_code=403, detail="Hanya Super Manager yang bisa membuat Super Manager lain")
    user = User(username=username, full_name=payload.full_name.strip(), company_access=payload.company_access or ["EWI Foundation"], phone_number=phone, workplace=payload.workplace or "-", role=role)
    user.set_password(payload.password)
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"user": user.to_dict()}


@router.put("/users/{user_id}")
def update_user_by_manager(user_id: int, payload: UpdateUserSchema, current_user: User = Depends(require_role("manager", "super_manager")), db: Session = Depends(get_db)):
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    if current_user.role == "manager" and user.role in ["super_manager", "manager"] and user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Anda tidak memiliki akses untuk mengubah data akun Manager lain.")
    if current_user.role == "super_manager" and user.role == "super_manager" and user.id != current_user.id:
        raise HTTPException(status_code=403, detail="Super Manager tidak bisa mengubah data Super Manager lain.")
    if payload.full_name:
        user.full_name = payload.full_name.strip()
    if payload.phone_number:
        if payload.phone_number != "-" and not payload.phone_number.isdigit():
            raise HTTPException(status_code=400, detail="Nomor HP harus berupa angka")
        user.phone_number = payload.phone_number
    if payload.workplace:
        user.workplace = payload.workplace
    if payload.company_access is not None:
        user.company_access = payload.company_access
    if payload.role and payload.role in ["staff", "manager", "mitra_eks", "super_manager"]:
        if payload.role != "super_manager" or current_user.role == "super_manager":
            user.role = payload.role
    if payload.password:
        if len(payload.password) < 6:
            raise HTTPException(status_code=400, detail="Password minimal 6 karakter")
        user.set_password(payload.password)
    db.commit()
    return {"success": True, "message": "Data user berhasil diperbarui", "user": user.to_dict()}


@router.get("/users/{user_id}/active_advance_balance")
def get_user_active_advance_balance(user_id: int, current_user: User = Depends(get_current_user), x_company: str = Header(default="EWI Foundation")):
    from services.balance.user_balance_service import get_user_balance_breakdown
    try:
        return get_user_balance_breakdown(user_id, x_company)
    except Exception as e:
        raise HTTPException(status_code=404, detail=str(e))


@router.get("/users/all_active_advance_balances")
def get_all_active_advance_balances(current_user: User = Depends(get_current_user), x_company: str = Header(default="EWI Foundation")):
    from services.balance.user_balance_service import get_all_users_balance_breakdown
    try:
        return {"company": x_company, "balances": get_all_users_balance_breakdown(x_company)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/users/{user_id}")
def get_user_detail(user_id: int, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    user = db.get(User, user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    return {"user": user.to_dict()}


@router.post("/link-google")
def link_google(payload: LinkGoogleSchema, current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    from google.auth.transport import requests as g_requests
    from google.oauth2 import id_token as google_id_token
    from config import Config
    try:
        id_info = google_id_token.verify_oauth2_token(payload.id_token, g_requests.Request(), Config.GOOGLE_CLIENT_ID)
        email = id_info.get("email")
        google_id = id_info.get("sub")
        existing = db.query(User).filter(((User.google_id == google_id) | (User.email == email)) & (User.id != current_user.id)).first()
        if existing:
            raise HTTPException(status_code=409, detail="Akun Google ini sudah terhubung ke user lain")
        user = db.get(User, current_user.id)
        user.google_id = google_id
        if not user.email:
            user.email = email
        db.commit()
        return {"success": True, "message": f"Berhasil menghubungkan akun Google: {email}", "user": user.to_dict()}
    except ValueError:
        raise HTTPException(status_code=401, detail="Verifikasi token Google gagal")


@router.post("/unlink-google")
def unlink_google(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    user = db.get(User, current_user.id)
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    user.google_id = None
    db.commit()
    return {"success": True, "message": "Berhasil memutuskan hubungan akun Google", "user": user.to_dict()}


@router.get("/google-login-browser", response_class=HTMLResponse)
def google_login_browser():
    return """<html><body style="font-family:sans-serif;text-align:center;padding-top:50px;">
    <h2>Integrasi Google Browser</h2><p>Fitur login via browser sedang disiapkan.</p>
    <p>Gunakan HP Android untuk menghubungkan akun Gmail.</p></body></html>"""
