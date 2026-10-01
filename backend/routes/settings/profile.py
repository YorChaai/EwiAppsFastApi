import os
import shutil
import subprocess
from datetime import datetime, timezone
from urllib.parse import urlparse
from fastapi import APIRouter, Depends
from fastapi.responses import JSONResponse
from config import Config
from core.security import get_current_user
from models import DeadlineSetting, User, db
from schemas.settings import ReportYearUpdate

profile_router = APIRouter(prefix="/api/settings", tags=["settings"])

@profile_router.get("/companies")
def get_companies():
    """
    Mengambil daftar perusahaan unik yang tersedia di database.
    Ini diambil dari kolom company_access di tabel users.
    Jika kosong, kembalikan default.
    """
    companies = set()
    try:
        import json
        users = User.query.all()
        for u in users:
            if u.company_access:
                try:
                    acc = json.loads(u.company_access)
                    if isinstance(acc, list):
                        for c in acc:
                            companies.add(c)
                except Exception:
                    pass
    except Exception as e:
        print(f"[!] Error fetching companies: {e}")
        
    if not companies:
        companies = {"EWI Foundation", "Expans Wireless Indo"}
        
    return {"companies": sorted(list(companies))}

@profile_router.get("/report-year")
@profile_router.get("/report_year")
def get_report_year(user: User = Depends(get_current_user)):
    # Per-user setting: default_report_year di tabel users
    return {
        "default_report_year": user.default_report_year,
        "global_default_year": int(Config.REPORT_DEFAULT_YEAR),
    }

@profile_router.post("/report-year")
@profile_router.post("/report_year")
def update_report_year(
    payload: ReportYearUpdate,
    user: User = Depends(get_current_user),
):
    year_raw = payload.default_report_year

    # value 0 atau None dianggap "Default (Sesuai Tahun Berjalan)"
    if year_raw is None or str(year_raw) == "0":
        user.default_report_year = None
        db.session.commit()
        return {
            "message": "Default tahun laporan dikembalikan ke otomatis.",
            "default_report_year": None,
        }

    try:
        year = int(year_raw)
    except (TypeError, ValueError):
        return JSONResponse({"error": "default_report_year harus berupa angka tahun"}, status_code=400)

    if year < 2000 or year > 2100:
        return JSONResponse(
            {"error": "default_report_year di luar rentang valid (2000-2100)"},
            status_code=400,
        )

    try:
        user.default_report_year = year
        db.session.commit()
        return {
            "message": f"Tahun laporan default Anda diatur ke {year}.",
            "default_report_year": year,
        }
    except Exception as e:
        db.session.rollback()
        return JSONResponse(
            {"error": f"Gagal menyimpan setting tahun laporan: {str(e)}"},
            status_code=500,
        )
