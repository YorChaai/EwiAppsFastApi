"""Filesystem cache helpers for annual report artifacts."""

import json
import os
import shutil
from datetime import datetime

from config import BASE_DIR


def _is_true(value):
    if value is None:
        return False
    return str(value).strip().lower() in ("1", "true", "yes", "y")


def _annual_cache_paths(year, sort_mode=None):
    cache_dir = os.path.abspath(
        os.path.join(BASE_DIR, "..", "data", "exports", "annual_cache")
    )
    os.makedirs(cache_dir, exist_ok=True)
    excel_suffix = "_tanggal" if sort_mode == "tanggal" else ""
    return {
        "json": os.path.join(cache_dir, f"annual_{year}.json"),
        "pdf": os.path.join(cache_dir, f"annual_{year}.pdf"),
        "excel": os.path.join(cache_dir, f"annual_{year}{excel_suffix}.xlsx"),
    }


def _load_annual_payload_cache(year):
    json_path = _annual_cache_paths(year)["json"]
    if not os.path.exists(json_path):
        return None
    with open(json_path, "r", encoding="utf-8") as cache_file:
        return json.load(cache_file)


def _save_annual_payload_cache(year, payload):
    data = dict(payload)
    data["cache_generated_at"] = datetime.now().isoformat()
    json_path = _annual_cache_paths(year)["json"]
    with open(json_path, "w", encoding="utf-8") as cache_file:
        json.dump(data, cache_file, ensure_ascii=False, indent=2)
    return data


def _save_annual_pdf_cache(year, pdf_bytes):
    pdf_path = _annual_cache_paths(year)["pdf"]
    with open(pdf_path, "wb") as cache_file:
        cache_file.write(pdf_bytes)
    return pdf_path


def clear_annual_report_cache():
    """Clear all exported annual report Excel, PDF, and JSON cache files."""
    cache_dir = os.path.abspath(
        os.path.join(BASE_DIR, "..", "data", "exports", "annual_cache")
    )
    if os.path.exists(cache_dir):
        shutil.rmtree(cache_dir)
        os.makedirs(cache_dir, exist_ok=True)
