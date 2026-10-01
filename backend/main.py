import os
from contextlib import asynccontextmanager
from pathlib import Path
from uuid import uuid4

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse
from config import Config
from core.database import (
    Base,
    db_session,
    get_engine,
    reset_session_scope,
    set_session_scope,
)


@asynccontextmanager
async def lifespan(_app: FastAPI):
    # Importing models registers every mapped table on Base.metadata.
    import models  # noqa: F401

    Base.metadata.create_all(bind=get_engine())
    yield

app = FastAPI(
    title="EWIApps KPI & Financial Management API",
    description="Backend API FastAPI dengan dokumentasi interaktif OpenAPI.",
    version="2.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)


@app.middleware("http")
async def cleanup_scoped_database_session(request: Request, call_next):
    scope_token = set_session_scope(uuid4().hex)
    try:
        return await call_next(request)
    finally:
        db_session.remove()
        reset_session_scope(scope_token)


def _touch_authenticated_user(request: Request):
    if not request.url.path.startswith("/api/") or request.url.path in {
        "/api/auth/login",
        "/api/auth/register",
    }:
        return
    authorization = request.headers.get("authorization", "")
    if not authorization.lower().startswith("bearer "):
        return
    try:
        import jwt
        from datetime import datetime, timezone
        from models import User

        claims = jwt.decode(
            authorization.split(None, 1)[1],
            Config.JWT_SECRET_KEY,
            algorithms=["HS256"],
        )
        identity = claims.get("sub") or claims.get("identity")
        user = db_session.get(User, int(identity))
        if user is None:
            return
        now = datetime.now(timezone.utc)
        last_seen = user.last_login
        if last_seen and last_seen.tzinfo is None:
            last_seen = last_seen.replace(tzinfo=timezone.utc)
        if last_seen is None or (now - last_seen).total_seconds() >= 30:
            user.last_login = now
            db_session.commit()
    except Exception:
        db_session.rollback()

# Konfigurasi CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=Config.ALLOWED_ORIGINS if Config.ALLOWED_ORIGINS != ["*"] else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Folder upload bukan direktori static publik. Sajikan hanya kategori file
# yang memang ditampilkan oleh aplikasi.
upload_dir = Config.UPLOAD_FOLDER
os.makedirs(upload_dir, exist_ok=True)


@app.get("/api/uploads/{filename:path}", tags=["Files"])
def serve_upload(filename: str):
    relative = Path(filename.replace("\\", "/"))
    if relative.is_absolute() or ".." in relative.parts:
        raise HTTPException(status_code=403, detail="Akses ke direktori ini dibatasi")
    normalized = relative.as_posix().lstrip("/")
    if not normalized.startswith(("profiles/", "receipts/", "assets/")):
        raise HTTPException(status_code=403, detail="Akses ke direktori ini dibatasi")
    if normalized.lower().endswith((".sql", ".db", ".sqlite", ".env", ".py", ".sh", ".bat", ".exe", ".cmd", ".ps1")):
        raise HTTPException(status_code=403, detail="Tipe file tidak diizinkan")

    root = Path(Config.UPLOAD_FOLDER).resolve()
    path = (root / relative).resolve()
    if root not in path.parents or not path.is_file():
        raise HTTPException(status_code=404, detail="File tidak ditemukan")
    return FileResponse(path)


from routes.core.auth_fastapi import router as auth_router
from routes.master_data.companies_fastapi import router as companies_router

from routes.advances.advances_approval import advances_approval_router
from routes.advances.advances_crud import advances_crud_router
from routes.advances.advances_other import advances_other_router
from routes.advances.advances_disbursement import advances_disbursement_router
from routes.advances.advances_items import advances_items_router
from routes.core.cleanup import cleanup_bp
from routes.core.dashboard import dashboard_bp
from routes.core.notifications import notifications_bp
from routes.master_data.bank_management import bank_management_router
from routes.master_data.bank_status import bank_status_router
from routes.master_data.categories import categories_router
from routes.master_data.taxes import taxes_router
from routes.reports.annual_fastapi import annual_router
from routes.reports.summary import summary_router
from routes.settings import settings_router
from routes.settings.profile import profile_router
from routes.settings.deadline import deadline_router
from routes.settlements.settlements_approval import settlements_approval_router
from routes.settlements.settlements_other import settlements_other_router
from routes.settlements.settlements_expenses import settlements_expenses_router
from routes.settlements.settlements_crud import settlements_crud_router
from routes.settlements.settlements_disbursement import settlements_disbursement_router
from routes.transactions.assets import assets_router
from routes.transactions.dividends import dividends_router
from routes.transactions.expenses import expenses_router
from routes.transactions.revenues import revenues_router

app.include_router(auth_router)
app.include_router(companies_router)
app.include_router(profile_router)
app.include_router(deadline_router)
for api_router in (
    advances_approval_router,
    advances_crud_router,
    advances_other_router,
    advances_disbursement_router,
    advances_items_router,
    cleanup_bp,
    dashboard_bp,
    notifications_bp,
    bank_management_router,
    bank_status_router,
    categories_router,
    taxes_router,
    summary_router,
    annual_router,
    settings_router,
    settlements_approval_router,
    settlements_other_router,
    settlements_expenses_router,
    settlements_crud_router,
    settlements_disbursement_router,
    assets_router,
    dividends_router,
    expenses_router,
    revenues_router,
):
    app.include_router(api_router)

# Health Check & Info
@app.get("/api/health", tags=["System"])
def health_check():
    return {
        "status": "healthy",
        "framework": "FastAPI",
        "version": "2.0.0",
        "database": get_engine().dialect.name,
    }

@app.get("/", tags=["System"])
def root_info():
    return {
        "message": "EWIApps API Server is running.",
        "documentation": "/docs"
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "main:app",
        host=os.getenv("EWI_HOST", "0.0.0.0"),
        port=int(os.getenv("EWI_PORT", "8000")),
        reload=os.getenv("EWI_RELOAD", "false").lower() in {"1", "true", "yes"},
    )
