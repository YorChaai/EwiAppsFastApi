import argparse
import datetime as dt
import difflib
import json
import math
import os
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")

from openpyxl import load_workbook
from openpyxl.utils.cell import column_index_from_string

try:
    import psycopg2
    from psycopg2.extras import DictCursor
except ImportError:
    psycopg2 = None

# --- CONFIGURATION ---
# CLI: jalankan tanpa argumen → mode interaktif (pilih Excel + sheet). --quick = satu klik lama.
#      Path workbook: posisi pertama FILE.xlsx atau -x/--excel PATH
#      Sheet: --sheet-revenue / --sheet-neraca / --sheet-dividen (nomor|nama) | --auto-sheets | --list-sheets


# -------------------------------------------------------------------------
# Evidence Matching Logic
# -------------------------------------------------------------------------
def load_old_evidence_data(db_url):
    old_evidence_data = {"expenses": [], "settlements": [], "advance_items": []}
    if not psycopg2 or not db_url:
        return old_evidence_data
    try:
        conn = psycopg2.connect(db_url)
        cur = conn.cursor(cursor_factory=DictCursor)

        # Load expenses
        cur.execute(
            "SELECT id, description, amount, date, evidence_path, evidence_filename FROM expenses WHERE evidence_path IS NOT NULL AND evidence_path != ''"
        )
        for row in cur.fetchall():
            old_evidence_data["expenses"].append(dict(row))

        # Load settlements
        cur.execute(
            "SELECT id, title as description, disbursed_amount as amount, document_date as date, disbursement_evidence_path as evidence_path, disbursement_evidence_filename as evidence_filename FROM settlements WHERE disbursement_evidence_path IS NOT NULL AND disbursement_evidence_path != ''"
        )
        for row in cur.fetchall():
            old_evidence_data["settlements"].append(dict(row))

        # Load advance items
        cur.execute(
            "SELECT id, description, estimated_amount AS amount, date, evidence_path, evidence_filename FROM advance_items WHERE evidence_path IS NOT NULL AND evidence_path != ''"
        )
        for row in cur.fetchall():
            old_evidence_data["advance_items"].append(dict(row))

        conn.close()
        print(
            f"Loaded {len(old_evidence_data['expenses'])} expenses, {len(old_evidence_data['settlements'])} settlements, {len(old_evidence_data['advance_items'])} advance items with evidence from DB."
        )
    except Exception as e:
        print(f"Failed to load old evidence data: {e}")

    return old_evidence_data


def normalize_match_text(value):
    text = "" if value is None else str(value)
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", " ", text)
    return re.sub(r"\s+", " ", text).strip()


def normalize_match_date(value):
    if value is None:
        return None
    if isinstance(value, dt.datetime):
        return value.date()
    if isinstance(value, dt.date):
        return value

    raw = str(value).strip()
    if not raw:
        return None

    for fmt in ("%Y-%m-%d", "%d/%m/%Y", "%d-%m-%Y", "%m/%d/%Y"):
        try:
            return dt.datetime.strptime(raw[:10], fmt).date()
        except ValueError:
            pass

    try:
        return dt.datetime.fromisoformat(raw.replace("Z", "+00:00")).date()
    except ValueError:
        return None


def evidence_file_exists(evidence_path):
    if not evidence_path:
        return False

    for rel_path in str(evidence_path).split("|"):
        rel_path = rel_path.strip().replace("\\", "/")
        if not rel_path:
            continue
        abs_path = os.path.join(UPLOAD_ROOT, *rel_path.split("/"))
        if os.path.exists(abs_path):
            return True

    return False


def match_evidence_fuzzy(new_desc, new_amount, table_name, old_data, new_date=None):
    if not new_desc:
        new_desc = ""
    new_desc = normalize_match_text(new_desc)
    new_date = normalize_match_date(new_date)

    candidates = old_data.get(table_name, [])
    if not candidates:
        return None, None

    best_match = None
    best_score = 0.0

    for row in candidates:
        if not row.get("evidence_path"):
            continue

        file_ok = evidence_file_exists(row.get("evidence_path"))
        if REQUIRE_EVIDENCE_FILE and not file_ok:
            continue

        old_date = normalize_match_date(row.get("date"))
        if new_date and old_date and new_date != old_date:
            continue

        old_desc = normalize_match_text(row.get("description"))
        desc_ratio = (
            1.0
            if not old_desc and not new_desc
            else difflib.SequenceMatcher(None, new_desc, old_desc).ratio()
        )

        if row.get("evidence_filename"):
            ev_name = normalize_match_text(row.get("evidence_filename"))
            ev_ratio = difflib.SequenceMatcher(None, new_desc, ev_name).ratio()
            desc_ratio = max(desc_ratio, ev_ratio * 0.92)

        amount_score = 0.0
        if row.get("amount") is not None and new_amount is not None:
            try:
                old_amount = abs(float(row["amount"]))
                new_amount_float = abs(float(new_amount))
                if abs(old_amount - new_amount_float) < 0.01:
                    amount_score = 0.18
                elif max(old_amount, new_amount_float) > 0:
                    diff_ratio = abs(old_amount - new_amount_float) / max(
                        old_amount, new_amount_float
                    )
                    amount_score = max(0.0, 0.12 * (1 - diff_ratio))
            except (TypeError, ValueError):
                amount_score = 0.0

        date_score = 0.24 if new_date and old_date and new_date == old_date else 0.0
        file_score = 0.08 if file_ok else 0.0
        score = (desc_ratio * 0.62) + date_score + amount_score + file_score

        if score > best_score:
            best_score = score
            best_match = row

    threshold = 0.78 if new_date else 0.86
    if best_match and best_score >= threshold:
        return best_match["evidence_path"], best_match["evidence_filename"]

    return None, None


# -------------------------------------------------------------------------
# Daftar perusahaan yang didukung
# -------------------------------------------------------------------------
excel_path = r"D:\Aplikasi\EWIApps\data\excel\20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"
HASILSQL_DIR = (
    r"D:\Aplikasi\EWIApps\data\backupdataapps"
)
OUTPUT_SQL_STEM = (
    "migrasi_data_multiyear_hybrid"  # nama file = stem + _YYYYMMDD_HHMMSS.sql
)
UPLOAD_ROOT = os.environ.get(
    "UPLOAD_DIR",
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), "..", "..", "..", "..", "data")
    ),
)
REQUIRE_EVIDENCE_FILE = os.environ.get("REQUIRE_EVIDENCE_FILE", "0") == "1"

# --- CATEGORY DEFINITIONS (Strict ID Ranges: 1-100 Category, 101+ Sub-category) ---
CATEGORY_CONFIG = [
    # (ID, Name, Code, ParentID, Group, SortOrder)
    (1, "Biaya Operasi", "A", None, "BEBAN LANGSUNG", 1),
    (2, "Biaya Research (R&D)", "B", None, "BEBAN LANGSUNG", 2),
    (3, "Biaya Sewa Peralatan", "C", None, "BEBAN LANGSUNG", 3),
    (4, "Biaya Interpretasi Log Data", "D", None, "BEBAN LANGSUNG", 4),
    (5, "Biaya Transportasi", "J", None, "BEBAN LANGSUNG", 5),
    (11, "Bisnis Development", "I", None, "BEBAN TIDAK LANGSUNG", 11),
    (12, "Lain-lain", "L", None, "BEBAN TIDAK LANGSUNG", 12),
    (13, "Deviden", "M", None, "BEBAN TIDAK LANGSUNG", 13),
    (6, "Administrasi", "E", None, "BIAYA ADMINISTRASI DAN UMUM", 6),
    (7, "Pembelian Barang", "F", None, "BIAYA ADMINISTRASI DAN UMUM", 7),
    (8, "Sewa Kantor", "G", None, "BIAYA ADMINISTRASI DAN UMUM", 8),
    (9, "Kesehatan", "H", None, "BIAYA ADMINISTRASI DAN UMUM", 9),
    (10, "Training", "K", None, "BIAYA ADMINISTRASI DAN UMUM", 10),
    # --- SUB-CATEGORIES (101+) ---
    (101, "Accommodation", "ACC", 1, "BEBAN LANGSUNG", 22),
    (102, "Allowance", "ALL", 1, "BEBAN LANGSUNG", 23),
    (103, "Meal", "MEA", 1, "BEBAN LANGSUNG", 24),
    (104, "Shipping", "SHI", 1, "BEBAN LANGSUNG", 25),
    (105, "Laundry", "LAU", 1, "BEBAN LANGSUNG", 26),
    (106, "Operation", "OPE", 1, "BEBAN LANGSUNG", 27),
    (107, "Trip", "TRI", 1, "BEBAN LANGSUNG", 28),
    (108, "Gaji", "GAJ", 1, "BIAYA ADMINISTRASI DAN UMUM", 30),
    (109, "Project Operation", "PO", 1, "BEBAN LANGSUNG", 32),
    (110, "Maintenance", "MNT", 1, "BEBAN LANGSUNG", 34),
    (111, "Logistic", "LOG", 1, "BEBAN LANGSUNG", 40),
    (112, "Hand Tools", "HT", 1, "BEBAN LANGSUNG", 41),
    (113, "Sparepart", "SP", 1, "BEBAN LANGSUNG", 42),
    (114, "Field Bonus", "FB", 1, "BEBAN LANGSUNG", 16),
    (115, "Field Allowance", "FA", 1, "BEBAN LANGSUNG", 17),
    (116, "Pembuatan Alat", "PA", 2, "BEBAN LANGSUNG", 35),
    (117, "Rental Tool", "RT", 3, "BEBAN LANGSUNG", 36),
    (118, "Data Processing", "DP", 4, "BEBAN LANGSUNG", 37),
    (119, "Software License", "SL", 4, "BEBAN LANGSUNG", 38),
    (120, "Team Building", "TB", 6, "BIAYA ADMINISTRASI DAN UMUM", 33),
    (121, "Biaya Bank & Admin", "BANK", 6, "BIAYA ADMINISTRASI DAN UMUM", 39),
    (122, "Modal Kerja", "MK", 6, "BIAYA ADMINISTRASI DAN UMUM", 45),
    (123, "ATK & Dokumen", "ATK", 6, "BIAYA ADMINISTRASI DAN UMUM", 19),
    (124, "Sewa Ruangan", "SR", 8, "BIAYA ADMINISTRASI DAN UMUM", 43),
    (125, "Medical", "MED", 9, "BIAYA ADMINISTRASI DAN UMUM", 44),
    (126, "Medical Check Up", "MCU", 9, "BIAYA ADMINISTRASI DAN UMUM", 20),
    (127, "Travel Ticket", "TT", 5, "BEBAN LANGSUNG", 18),
    # --- DASH SUB-CATEGORIES (900+) ---
    (901, "-", "A-", 1, "BEBAN LANGSUNG", 99),
    (902, "-", "B-", 2, "BEBAN LANGSUNG", 99),
    (903, "-", "C-", 3, "BEBAN LANGSUNG", 99),
    (904, "-", "D-", 4, "BEBAN LANGSUNG", 99),
    (905, "-", "J-", 5, "BEBAN LANGSUNG", 99),
    (906, "-", "E-", 6, "BIAYA ADMINISTRASI DAN UMUM", 99),
    (907, "-", "F-", 7, "BIAYA ADMINISTRASI DAN UMUM", 99),
    (908, "-", "G-", 8, "BIAYA ADMINISTRASI DAN UMUM", 99),
    (909, "-", "H-", 9, "BIAYA ADMINISTRASI DAN UMUM", 99),
    (910, "-", "K-", 10, "BIAYA ADMINISTRASI DAN UMUM", 99),
    (911, "-", "I-", 11, "BEBAN TIDAK LANGSUNG", 99),
    (912, "-", "L-", 12, "BEBAN TIDAK LANGSUNG", 99),
    (913, "-", "M-", 13, "BEBAN TIDAK LANGSUNG", 99),
]

# Map category/subcategory ID to its parent ID
CAT_PARENT_MAP = {c[0]: c[3] for c in CATEGORY_CONFIG}

# Map main category to its dash subcategory
DASH_SUBCAT_MAP = {
    1: 901,
    2: 902,
    3: 903,
    4: 904,
    5: 905,
    6: 906,
    7: 907,
    8: 908,
    9: 909,
    10: 910,
    11: 911,
    12: 912,
    13: 913,
}

# Mapping for data extraction
cat_id_by_name = {c[1]: c[0] for c in CATEGORY_CONFIG}
CATEGORY_ID_MAP = {c[1].upper(): c[0] for c in CATEGORY_CONFIG}
CATEGORY_ID_MAP.update(
    {
        "TRANSPORTATION": 5,
        "BIAYA TRANSPORTASI": 5,
        "ACCOMMODATION": 101,
        "ALLOWANCE": 102,
        "MEAL": 103,
        "SHIPPING": 104,
        "LAUNDRY": 105,
        "OPERATION": 106,
        "TRIP": 107,
        "TRAINING": 10,
        "GAJI": 108,
        "SALES": 109,
        "PROJECT OPERATION": 109,
        "TEAM BUILDING": 120,
        "MAINTENANCE": 110,
        "PEMBUATAN ALAT": 116,
        "RENTAL TOOL": 117,
        "DATA PROCESSING": 118,
        "SOFTWARE LICENSE": 119,
        "LOGISTIC": 111,
        "HAND TOOLS": 112,
        "SPAREPART": 113,
        "SEWA RUANGAN": 124,
        "MEDICAL": 125,
        "MODAL KERJA": 122,
        "BIAYA BANK": 121,
        "BIAYA BANK & ADMIN": 121,
        "IT SERVICES": 6,
        "FIELD BONUS": 114,
        "FIELD ALLOWANCE": 115,
        "TRAVEL TICKET": 127,
        "ATK & DOKUMEN": 123,
        "MEDICAL CHECK UP": 126,
        "KESEHATAN": 9,
        "LAIN LAIN": 12,
        "BISNIS DEV": 11,
        "BISNIS DEVELOPMENT": 11,
        "DIOFAVIAN": 9,
        "EXPENSE IC": 12,
        "EXPENSE TMA": 12,
        "EXPENSE AC": 12,
        "ADMIN": 121,
        "BIAYA ADMIN": 121,
        "BIAYAN ADMIN": 121,
        "BIAAY ADMIN": 121,
        "BIAYA DMIN": 121,
        "ADMIN FEE": 121,
        "BIAYA TRANSFER": 121,
        "TAX": 121,
        "TAX GIRO": 121,
        "TAX VALAS": 121,
        "TAX TAB BIS": 121,
        "MONTHLY FEE ATM": 121,
        "MONTHLY CARD CHARGE": 121,
        "FEE ATM": 121,
        "CASH ADVANCE": 12,
        "CASH ADV": 12,
    }
)

FULL_MAPPING = {
    "accomadation & transportation": "Transportation",
    "air tikect": "Travel Ticket",
    "airplane": "Travel Ticket",
    "land transportation": "Transportation",
    "train ticket": "Travel Ticket",
    "transportasi": "Transportation",
    "transportasi darat": "Transportation",
    "transportasi tools": "Transportation",
    "transportation": "Transportation",
    "taksi": "Transportation",
    "taxi": "Transportation",
    "toll": "Transportation",
    "tol ": "Transportation",
    "parkir": "Transportation",
    "parking": "Transportation",
    "fuel": "Transportation",
    "bensin": "Transportation",
    "tiket": "Travel Ticket",
    "ticket": "Travel Ticket",
    "rental mobil": "Transportation",
    "sewa mobil": "Transportation",
    "prabumulih field-alfa by si": "Project Operation",
    "hotel": "Accommodation",
    "hotel and logistic": "Accommodation",
    "hotel and loundry": "Accommodation",
    "loundry": "Laundry",
    "allowance": "Allowance",
    "aloowance": "Allowance",
    "field bonus": "Field Bonus",
    "field allowance": "Field Allowance",
    "tunjangan lapangan untuk 5 days": "Field Allowance",
    "perdiem meal": "Meal",
    "pediem": "Meal",
    "perdiem": "Meal",
    "perdiem uang makan": "Meal",
    "snack": "Meal",
    "meal": "Meal",
    "meal allowance": "Meal",
    "meal on field site": "Meal",
    "meals at wellsite": "Meal",
    "meals on field site": "Meal",
    "entertaiment on field site": "Meal",
    "logictic": "Logistic",
    "logistic": "Logistic",
    "logistik": "Logistic",
    "shipping": "Shipping",
    "jne courier": "Shipping",
    "atk dan dokumen sent": "ATK & Dokumen",
    "marker": "ATK & Dokumen",
    "atk": "ATK & Dokumen",
    "laundry": "Laundry",
    "laundry (25 - 30 may 2024)": "Laundry",
    "operation": "Operation",
    "operation need": "Operation",
    "trip alan to tgb-033 pertamina cirebon": "Trip",
    "trip to kl - benchmark dtr": "Trip",
    "trip to meeting at cirebon": "Trip",
    "trip zurailey to tgb-033 pertamina cirebon": "Trip",
    "training": "Training",
    "training course": "Training",
    "trip to bandung - upskilling event elnusa": "Training",
    "hand tools": "Hand Tools",
    "gloves": "Hand Tools",
    "battery": "Sparepart",
    "steker": "Logistic",
    "buy spare part connector from pei-genesis": "Hand Tools",
    "google domain and email services pt. exspan wireline indonesia": "IT Services",
    "medical": "Medical Check Up",
    "mcu": "Medical Check Up",
    "expense ic": "Project Expenses",
    "expense tma": "Project Expenses",
    "expense ac": "Project Expenses",
    "biaya admin": "Biaya Bank & Admin",
    "biayan admin": "Biaya Bank & Admin",
    "biaay admin": "Biaya Bank & Admin",
    "biaya dmin": "Biaya Bank & Admin",
    "tax": "Biaya Bank & Admin",
    "tax giro": "Biaya Bank & Admin",
    "tax valas": "Biaya Bank & Admin",
    "monthly fee atm": "Biaya Bank & Admin",
    "fee atm": "Biaya Bank & Admin",
}

SUBHEADER_MAPPING = {
    "hotel and loundry": [101, 105],
    "hotel and laundry": [101, 105],
    "hotel and logistic": [101, 111],
    "hotel": [101],
    "laundry": [105],
    "logistik": [111],
    "logictic": [111],
    "meals": [103],
    "meal allowance": [103],
    "meals on field site": [103],
    "meals at wellsite": [103],
    "entertaiment on field site": [103],
    "field bonus": [114],
    "field allowance": [115],
    "allowance": [102],
    "transportation": [5],
    "transportasi": [5],
    "biaya transportasi": [5],
    "air ticket": [127],
    "train ticket": [127],
    "airplane": [127],
    "accomadation & transportation": [101, 5],
    "shipping": [104],
    "operation": [106],
    "it services": [6],
    "internet data": [6],
    "biaya bank": [121],
    "biaya bank & admin": [121],
    "hand tools": [112],
    "sparepart": [113],
    "medical": [125],
    "mcu": [126],
    "atk dan dokumen": [123],
    "trip": [107],
    "training": [10],
    "beban tidak langsung": [
        12
    ],  # Using 'Lain-lain' as a placeholder for unknown indirect costs
    "lain-lain": [12],
    "lain lain": [12],
    "deviden": [13],
    "admin": [121],
    "biaya admin": [121],
    "biayan admin": [121],
    "biaay admin": [121],
    "biaya dmin": [121],
    "tax": [121],
    "tax giro": [121],
    "tax valas": [121],
    "fee atm": [121],
    "monthly fee": [121],
    "expense ic": [12],
    "expense tma": [12],
    "expense ac": [12],
    "job": [12],
}

BATCH_KEYWORDS = [
    "EXPENSE#",
    "TRANSFER FROM",
    "DIRECT TRANSFER",
    "PEMINDAHBUKUAN",
]

_CELL_REF_RE = re.compile(r"\$?([A-Z]{1,3})\$?(\d+)")


def get_cell_effective_value(ws, r, c):
    """
    Return actual cell value, including merged-cell fallback to top-left value.
    """
    if r < 1 or c < 1:
        return None
    cell = ws.cell(r, c)
    if cell.value is not None:
        return cell.value
    for mr in ws.merged_cells.ranges:
        min_col, min_row, max_col, max_row = mr.bounds
        if min_row <= r <= max_row and min_col <= c <= max_col:
            return ws.cell(min_row, min_col).value
    return None


def get_merge_range(ws, r, c):
    for mr in ws.merged_cells.ranges:
        min_col, min_row, max_col, max_row = mr.bounds
        if min_row <= r <= max_row and min_col <= c <= max_col:
            if max_row > min_row:
                return (min_row, max_row)
            return None
    return None


def find_column_index(ws, keyword, start_r, search_limit=25):
    """Mencari index kolom berdasarkan keyword dengan logika sinonim (Smart Detection)."""
    end_scan = min(start_r + search_limit, ws.max_row)
    key = keyword.upper()

    for r in range(start_r, end_scan + 1):
        for c in range(
            1, 100
        ):  # Scan up to 100 columns (Increased from 25 for robustness)
            val = str(ws.cell(r, c).value or "").upper().replace("\n", " ").strip()
            if not val:
                continue

            found = False
            if key in val:
                found = True

            # Smart Sub-header Detection (Stacked Headers)
            # If we match a generic part of the key, check the cell below
            if not found:
                # Example: Key is "INVOICE VALUE USD", val is "VALUE" or "INVOICE"
                if ("VALUE" in key and "VALUE" in val) or (
                    "RECEIVED" in key and "RECEIVED" in val
                ):
                    if r < end_scan:
                        val_below = str(ws.cell(r + 1, c).value or "").upper().strip()
                        # If key has "USD" and val_below has "USD", it's a match
                        if ("USD" in key and "USD" in val_below) or (
                            "IDR" in key and "IDR" in val_below
                        ):
                            found = True

            if (
                not found
                and key == "CURRENCY EXCHANGE"
                and (
                    ("CURR" in val and "EXCH" in val) or val == "EXCHANGE" or val == "1"
                )
            ):
                found = True
            elif not found and key == "11%" and ("11%" in val or "0.11" in val):
                found = True
            elif not found and key == "2%" and ("2%" in val or "0.02" in val):
                found = True
            elif (
                not found
                and key == "INTERPRETASI LOG DATA"
                and ("LOG" in val or "INTERPRET" in val or "BIAYA INTERP" in val)
            ):
                found = True
            elif (
                not found
                and key == "AMOUNT RECEIVED IDR"
                and (
                    ("AMOUNT" in val and "RECEIVED" in val)
                    or ("RECEIVED" in val and "IDR" in val)
                )
            ):
                found = True

            if found:
                # --- HEURISTIK KHUSUS PPN ---
                # Jika kita menemukan "PPN", cek apakah ini header atas yang membawahi sub-header.
                # Standar EWI: Header atas di Row N, Sub-header di Row N+1 atau N+2.
                if key == "PPN" and r < end_scan:
                    # Cek baris-baris di bawahnya dalam kolom yang sama atau sebelahnya (karena merged)
                    for r_next in range(r + 1, min(r + 4, end_scan + 1)):
                        val_below = str(ws.cell(r_next, c).value or "").upper().strip()
                        val_right_below = (
                            str(ws.cell(r_next, c + 1).value or "").upper().strip()
                        )
                        if val_below == "PPN" or val_right_below == "PPN":
                            # Ditemukan sub-header PPN yang lebih spesifik di bawah, lewati yang ini.
                            found = False
                            break

                if found:
                    return c
    return -1


def is_numeric_value(v):
    if v is None or str(v).strip() == "":
        return False
    s = str(v).strip()
    if s.startswith("="):
        return True
    s_clean = s.replace(",", "").replace(".", "").strip()
    if s_clean.isdigit() or (s_clean.startswith("-") and s_clean[1:].isdigit()):
        return True
    try:
        float(s.replace(",", ""))
        return True
    except Exception:
        try:
            float(s.replace(".", "").replace(",", "."))
            return True
        except Exception:
            return False


def to_num_cell(ws_f, ws_v, r, c, default=0.0, _depth=0):
    if _depth > 8:
        return default
    v_c = get_cell_effective_value(ws_v, r, c)
    if isinstance(v_c, (int, float)):
        return float(v_c)
    v_f = get_cell_effective_value(ws_f, r, c)
    if v_f is None:
        return default
    if isinstance(v_f, (int, float)):
        return float(v_f)
    t = str(v_f).strip()
    if t.startswith("="):
        w = t[1:].strip()
        w = re.sub(r"(\d+(?:\.\d+)?)\s*%", lambda m: str(float(m.group(1)) / 100.0), w)

        def _rep(m):
            cl, ri = m.group(1), int(m.group(2))
            return str(
                to_num_cell(
                    ws_f, ws_v, ri, column_index_from_string(cl), 0.0, _depth + 1
                )
            )

        w = _CELL_REF_RE.sub(_rep, w).replace("^", "**")
        if re.fullmatch(r"[0-9\.\+\-\*/\(\)\s]+", w):
            try:
                return float(eval(w, {"__builtins__": {}}, {}))
            except Exception:
                pass
    if isinstance(t, str):
        w = t.strip()
        is_negative = False
        if w.startswith("(") and w.endswith(")"):
            w = w[1:-1].strip()
            is_negative = True

        # Handle cases where it's just a hyphen or dash (usually means 0 or deduction)
        if w in ["-", "—", "–"]:
            return 0.0

        # If the string contains a lot of alphabetic characters, it's likely a sentence/filename, not a number with a prefix.
        # Check this BEFORE stripping out non-digits!
        if len(re.findall(r"[a-zA-Z]", w)) > 5:
            return default

        # NEW: Remove thousands separators (dots) globally if there's no comma
        # In Indonesian format 21.200.000 (with dots) or 21.200.000,00 (dots and comma)
        if "," in w:
            # Has comma: assume dot is thousands, comma is decimal
            w = w.replace(".", "").replace(",", ".")
        else:
            # No comma: if there are dots, they are likely thousands
            # e.g., 21.200.000 -> 21200000
            if "." in w:
                # If dot looks like decimal (only 1 dot and 1-2 digits after), handle carefully
                # but usually in this context large numbers with dots are thousands.
                parts = w.split(".")
                if (
                    len(parts) > 1
                    and all(len(p) == 3 for p in parts[1:-1])
                    and len(parts[-1]) == 3
                ):
                    w = w.replace(".", "")
                elif len(parts) == 2 and len(parts[1]) == 3:
                    w = w.replace(".", "")
                elif len(parts) > 2:
                    w = w.replace(".", "")

        try:
            # Final cleanup: remove any remaining non-numeric except decimal point
            # This handles cases where there might be a trailing dash or space
            clean_w = re.sub(r"[^\d.-]", "", w)
            if not clean_w or clean_w == ".":
                return 0.0
            val = float(clean_w)
            return -val if is_negative else val
        except ValueError:
            # Last resort: remove all but last dot/comma if numeric
            cleaned = re.sub(r"[^\d.,-]", "", w)
            if cleaned.count(".") > 1 or (
                cleaned.count(".") == 1 and cleaned.count(",") == 1
            ):
                # Indonesian: 2.701.000,00 -> 2701000.00
                cleaned = cleaned.replace(".", "").replace(",", ".")
            try:
                return -float(cleaned) if is_negative else float(cleaned)
            except ValueError:
                return default
    try:
        val = str(t).replace(",", "")
        is_neg = False
        if val.startswith("(") and val.endswith(")"):
            val = val[1:-1]
            is_neg = True
        num = float(val)
        return -num if is_neg else num
    except Exception:
        return default


def to_sql_val(val):
    if (
        val is None
        or (isinstance(val, float) and math.isnan(val))
        or str(val).strip() == ""
    ):
        return "NULL"
    if isinstance(val, (int, float)):
        return str(val)
    if isinstance(val, dt.date):
        return f"'{val.isoformat()}'"
    if isinstance(val, dt.datetime):
        return f"'{val.strftime('%Y-%m-%d %H:%M:%S')}'"
    safe_val = str(val).replace("'", "''")
    return f"'{safe_val}'"


def detect_cat(desc):
    d = str(desc).upper()

    # --- PRIORITAS 00: Deteksi berdasarkan Kode Kategori dalam kurung ---
    # Memastikan jika Excel typo teksnya tapi kode hurufnya benar, maka merujuk ke kode huruf
    if "(A)" in d:
        return 1  # Biaya Operasi
    if "(B)" in d:
        return 2  # Biaya Research
    if "(C)" in d:
        return 3  # Biaya Sewa Peralatan
    if "(D)" in d:
        return 4  # Biaya Interpretasi Log Data
    if "(J)" in d:
        return 5  # Biaya Transportasi
    if "(E)" in d:
        return 6  # Administrasi
    if "(F)" in d:
        return 7  # Pembelian Barang
    if "(G)" in d:
        return 8  # Sewa Kantor
    if "(H)" in d:
        return 9  # Kesehatan
    if "(I)" in d:
        return 11  # Bisnis Development
    if "(K)" in d:
        return 10  # Training
    if "(L)" in d:
        return 12  # Lain-lain
    if "(M)" in d:
        return 13  # Deviden

    # --- PRIORITAS 0: Identifikasi Nama Spesifik / User-Defined ---
    # Jika deskripsi mengandung nama tertentu, langsung arahkan ke kategori yang sesuai.
    if "DIOFAVIAN" in d:
        return 9  # Kesehatan
    if "BIAYA ADMIN" in d or "ADMIN FEE" in d:
        return 121  # Biaya Bank (Sub-category of Administrasi)

    # Kelompok Biaya Admin & Variasinya (termasuk Typo)
    admin_keywords = [
        "BIAYA ADMIN",
        "BIAYAN ADMIN",
        "BIAAY ADMIN",
        "BIAYA DMIN",
        "ADMIN FEE",
        "ADMIN BANK",
        "BIAYA TRANSFER",
        "MONTHLY FEE",
        "MONTHLY CARD CHARGE",
        "FEE ATM",
    ]
    if any(k in d for k in admin_keywords):
        return 121  # Biaya Bank & Admin

    # Kelompok Tax / Pajak Rekening
    tax_keywords = ["TAX ", "TAXTAB", "TAX GIRO", "TAX VALAS"]
    if any(k in d for k in tax_keywords):
        return 121  # Biaya Bank & Admin

    if any(k in d for k in ["TAX", "PAJAK", "PPH", "PPN"]):
        return 6  # Administrasi

    # Prioritas 1: Biaya Bank vs Administrasi Umum
    if "ADMINISTRASI" in d:
        return 6
    if "BISNIS DEVELOPMENT" in d or "BISNIS DEV" in d:
        return 11
    if any(k in d for k in ["FEE", "BANK", "BIAYA TRANSFER", "PEMINDAHBUKUAN"]):
        return 121  # Biaya Bank & Admin

    # Prioritas 3: Mapping dari config

    for k, v in FULL_MAPPING.items():
        if k.upper() in d:
            return CATEGORY_ID_MAP.get(v.upper(), 12)
    for k, v in CATEGORY_ID_MAP.items():
        if k in d:
            return v
    return 12  # Fallback to Lain-lain (ID 12) agar tidak merusak Biaya Operasi asli


def map_bank_source(raw_name):
    if not raw_name:
        return "-"
    n = str(raw_name).upper().strip()
    n_norm = n.replace(" ", "").replace("-", "").replace("_", "")

    # Priority matching order: BRI -> BNI -> Mandiri -> BCA -> EWI
    if "BRI" in n_norm:
        if "GIRO" in n_norm:
            return "BRI Giro"
        if "BISNIS" in n_norm:
            return "BRI Bisnis"
        if "TABBIS" in n_norm or "TABIS" in n_norm:
            return "BRI TabBis"
        if "VALAS" in n_norm:
            return "BRI Valas"
        return "BRI"
    if "BNI" in n_norm:
        if "GIRO" in n_norm:
            return "BNI Giro"
        if "BISNIS" in n_norm:
            return "BNI Bisnis"
        if "TABBIS" in n_norm or "TABIS" in n_norm:
            return "BNI TabBis"
        if "VALAS" in n_norm:
            return "BNI Valas"
        return "BNI"
    if "MANDIRI" in n_norm:
        if "GIRO" in n_norm:
            return "Mandiri Giro"
        if "BISNIS" in n_norm:
            return "Mandiri Bisnis"
        if "TABBIS" in n_norm or "TABIS" in n_norm:
            return "Mandiri TabBis"
        if "VALAS" in n_norm:
            return "Mandiri Valas"
        return "Mandiri"
    if "BCA" in n_norm:
        if "GIRO" in n_norm:
            return "BCA Giro"
        if "BISNIS" in n_norm:
            return "BCA Bisnis"
        if "TABBIS" in n_norm or "TABIS" in n_norm:
            return "BCA TabBis"
        if "VALAS" in n_norm:
            return "BCA Valas"
        return "BCA"
    if "EWI" in n_norm:
        return "EWI"

    # Fallbacks
    if "CASH" in n_norm:
        return "Cash"
    if "IDR" in n_norm:
        return "IDR"
    if "ADVANCE" in n_norm:
        return "Advance"

    # Suggestion: If not one of the main banks, fallback to '-'
    return "-"


def detect_subheader(text, cell):
    if not text:
        return None

    # User Suggestion: Arial 10 Bold is the key indicator for sub-headers
    is_bold_10 = False
    try:
        font = cell.font
        f_name = (font.name or "").upper()
        if (
            font
            and font.b
            and ("ARIAL" in f_name or f_name == "")
            and (9.5 <= font.sz <= 10.5)
        ):
            is_bold_10 = True
    except Exception:
        pass

    t = text.lower().strip()
    # 1. Try explicit mapping first
    for k, ids in SUBHEADER_MAPPING.items():
        if k in t:
            return ids

    # 2. If it's Arial 10 Bold, try to detect category from text even if not in SUBHEADER_MAPPING
    if is_bold_10:
        cid = detect_cat(text)
        if cid:
            return [cid]

    return None


def detect_master_year(ws):
    """Mendeteksi tahun laporan dari header sheet (misal: 'Januari - Desember 2024')."""
    for r in range(1, 11):
        for c in range(1, 6):
            val = str(ws.cell(r, c).value or "").upper()
            if "DATE" in val or "TH" in val or "PROJECT" in val or "202" in val:
                m = re.search(r"(20\d{2})", val)
                if m:
                    return int(m.group(1))
    return dt.datetime.now().year


def _is_anchor_cell(cell) -> bool:
    """Cek apakah sel adalah penanda (Arial 20 Bold) seperti standar laporan EWI."""
    if not cell or not cell.font:
        return False
    f = cell.font
    if not f.bold:
        return False
    try:
        sz = float(f.sz)
        if abs(sz - 20.0) > 0.1:
            return False
    except Exception:
        return False
    name = (f.name or "").lower()
    return "arial" in name


def _is_bank_source_cell(cell) -> bool:
    """Arial Narrow 12 Bold (terkadang Underline)"""
    if not cell or not cell.font:
        return False
    f = cell.font
    if not f.bold:
        return False
    try:
        sz = float(f.sz)
        if abs(sz - 12.0) > 0.1:
            return False
    except Exception:
        return False
    name = (f.name or "").lower()
    return "arial narrow" in name


# ------------------------------------------------------------------
# Helper baru: deteksi baris marker eksplisit (Single/Batch/Subject/Detail)
# ------------------------------------------------------------------

def _is_marker_row(val_b, val_c) -> bool:
    """Baris penanda jika COL-B = keyword marker dan COL-C = ':'."""
    b = str(val_b or "").strip().lower()
    c = str(val_c or "").strip()
    return b in ("single", "batch", "subject", "detail") and c == ":"


def _is_expense_item(val_b, val_g) -> bool:
    """Item pengeluaran valid jika COL-B = date, COL-G = currency (atau kosong tapi ada tanggal).
    COL-C (nomor) bersifat opsional.
    Currency kosong masih diterima selama ada tanggal — akan di-default ke IDR.
    """
    is_date = isinstance(val_b, (dt.date, dt.datetime))
    cur = str(val_g or "").strip().upper()
    # Terima IDR, USD, RP (alias IDR), MYR, dan currency kosong (default IDR)
    is_cur = cur in ("IDR", "USD", "RP", "MYR", "")
    return is_date and is_cur



def _is_subkategori_row(val_b, val_c, val_d, val_e, val_f, val_g) -> bool:
    """Subkategori = hanya COL-D terisi, semua kolom lain kosong."""
    d_filled = bool(val_d and str(val_d).strip())
    others_empty = not any([
        val_b and str(val_b).strip(),
        val_c and str(val_c).strip(),
        val_e and str(val_e).strip(),
        val_f and str(val_f).strip(),
        val_g and str(val_g).strip(),
    ])
    return d_filled and others_empty


def _is_subcategory_cell(cell) -> bool:
    """Deprecated – dipertahankan untuk kompatibilitas scan_sheet_analysis."""
    if not cell or not cell.font:
        return False
    val = str(cell.value or "").upper().strip()
    if val.startswith("SUBJECT") or "SUBJECT :" in val or "SUBJECT:" in val:
        return False
    f = cell.font
    is_font_match = (
        (f.name and ("arial" in f.name.lower() or "calibri" in f.name.lower()))
        and (f.sz and (abs(float(f.sz) - 10.0) < 0.1 or abs(float(f.sz) - 11.0) < 0.1))
        and f.b
    )
    if is_font_match:
        return True
    val = str(cell.value or "").strip()
    if (
        cell.font.b
        and len(val) > 10
        and (val.startswith("202") or "EXPENSES" in val.upper())
    ):
        return True
    return False


def is_divider_row(val_b_str, cell_b, val_d_str, cell_d):
    """Deprecated – dipertahankan untuk kompatibilitas scan_sheet_analysis.
    Deteksi batch/single sekarang menggunakan _is_marker_row() di main loop.
    """
    if "OPERATION COST AND OFFICE" in val_d_str or "OPERATION COST AND OFFICE" in val_b_str:
        return True
    return False


def is_bank_header_row(val_b_str, cell_b, val_d_str, cell_d):
    # Tier 1: Font Based
    if _is_bank_source_cell(cell_b) or _is_bank_source_cell(cell_d):
        return True

    # Tier 2: Keywords - MUST BE BOLD and look like a title
    bank_keywords = [
        "REKENING",
        "GIRO",
        "BRI",
        "BCA",
        "MANDIRI",
        "BNI",
        "CASH ON HAND",
        "FROM REKENING",
        "PEMINDAHBUKUAN DARI",
        "TRANSFER DARI",
    ]
    # Check both B and D
    for val, cell in [(val_b_str, cell_b), (val_d_str, cell_d)]:
        if any(kw in val for kw in bank_keywords) and not isinstance(
            cell.value, (dt.date, dt.datetime)
        ):
            # Special exclusion for "PETY CASH" which is a subcat, not a bank header
            if "PETY CASH" in val or "PETTY CASH" in val:
                continue

            if cell.font and cell.font.b:  # Headers are almost always Bold
                # Ensure it's not a data row by checking length
                if len(val) < 100:
                    # Special case for "BIAYA ADMIN" - usually a row, not a header
                    if (
                        "BIAYA ADMIN" in val.upper() or "ADMIN FEE" in val.upper()
                    ) and not any(
                        b in val.upper() for b in ["BRI", "BCA", "MANDIRI", "BNI"]
                    ):
                        continue
                    return True

    # Handle standalone "CASH" if it looks like a header
    if val_b_str == "CASH" or val_d_str == "CASH":
        if (cell_b.font and cell_b.font.b) or (cell_d.font and cell_d.font.b):
            return True

    return False


def find_table_range(
    ws, ws_f, title_keyword, footer_keywords, exact_title=False, start_row=1
):
    """
    Mencari rentang tabel berdasarkan keyword judul di kolom 1 sampai 4.
    """
    s_row, e_row = -1, -1
    for r in range(start_row, min(ws.max_row + 1, 2000)):
        cell_val = " ".join(
            [str(ws.cell(r, c).value or "").upper().strip() for c in range(1, 5)]
        )

        match = False
        if exact_title:
            for c in range(1, 5):
                if (
                    str(ws.cell(r, c).value or "").upper().strip()
                    == title_keyword.upper()
                ):
                    match = True
                    break
        else:
            if title_keyword.upper() in cell_val:
                match = True

        if match:
            s_row = r
            break

    if s_row != -1:
        # Cari footer untuk mengakhiri tabel
        for r in range(s_row + 1, min(ws.max_row + 1, s_row + 1000)):
            row_str = " ".join(
                [str(ws.cell(r, c).value or "") for c in range(1, 12)]
            ).upper()
            if any(f.upper() in row_str for f in footer_keywords):
                e_row = r
                break

    return s_row, e_row


def _pick_sheet_by_spec(sheetnames: list[str], spec: str) -> str | None:
    """
    Pilih nama sheet: nomor 1..N, nama persis, atau substring yang hanya cocok satu sheet.
    """
    spec = (spec or "").strip()
    if not spec:
        return None
    if spec.isdigit():
        i = int(spec)
        if 1 <= i <= len(sheetnames):
            return sheetnames[i - 1]
        raise ValueError(f"Nomor sheet {i} tidak valid (1..{len(sheetnames)})")
    for n in sheetnames:
        if n.lower() == spec.lower():
            return n
    hits = [n for n in sheetnames if spec.lower() in n.lower()]
    if len(hits) == 1:
        return hits[0]
    if len(hits) > 1:
        raise ValueError(
            f"Substring {spec!r} cocok lebih dari satu sheet: {hits}. "
            f"Pakai nomor (1-{len(sheetnames)}) atau nama persis."
        )
    raise ValueError(f"Tidak ada sheet yang cocok dengan: {spec!r}")


def _pick_sheet_auto(sheetnames: list[str], needle: str) -> str | None:
    for n in sheetnames:
        if needle in n:
            return n
    return None


def list_excel_sheets(excel_path: str) -> list[str]:
    wb = load_workbook(excel_path, read_only=True, data_only=True)
    try:
        return list(wb.sheetnames)
    finally:
        getattr(wb, "close", lambda: None)()


def scan_sheet_analysis(wb_f, wb_v, sheet_spec: str) -> dict:
    """Scan data sheet dan kembalikan hasil analisis dalam bentuk dictionary."""
    results = {"name": None, "anchors": [], "type": None, "counts": {}, "valid": False}
    try:
        names = wb_f.sheetnames
        name = _pick_sheet_by_spec(names, sheet_spec)
        if not name:
            return results
        results["name"] = name
        ws_f, ws_v = wb_f[name], wb_v[name]

        # 1. Anchors
        for r in range(1, min(ws_f.max_row + 1, 1000)):
            if any(_is_anchor_cell(ws_f.cell(r, c)) for c in range(1, 3)):
                txt = str(ws_v.cell(r, 1).value or ws_v.cell(r, 2).value or "").strip()
                if txt:
                    results["anchors"].append((r, txt))

        # 2. Revenue & Bank Scan
        r1_s, r1_e = -1, -1
        for kw in ["REVENUE & TAX", "REVENUE DI"]:
            r1_s, r1_e = find_table_range(
                ws_v, ws_f, kw, ["REVENUE (IDR)", "NETT REVENUE"]
            )
            if r1_s != -1:
                break

        rb_s, rb_e = -1, -1
        for kw in ["BANK Status", "INTEREST FROM"]:
            rb_s, rb_e = find_table_range(ws_v, ws_f, kw, ["TOTAL", "PAJAK"])
            if rb_s != -1:
                break

        r2_s, r2_e = -1, -1
        for kw in ["PAJAK PENGELUARAN", "PAJAK DAN PENERIMAAN"]:
            r2_s, r2_e = find_table_range(ws_v, ws_f, kw, ["PENERIMAAN NEGARA"])
            if r2_s != -1:
                break

        r3_s = -1
        for k in [
            "PENGELUARAN",
            "ACTIVITY",
            "BIAYA OPERASIONAL",
            "PEMINDAHBUKUAN",
            "TRANSFER DARI",
            "SETTLEMENT EXPENSES",
        ]:
            r3_s, _ = find_table_range(
                ws_v,
                ws_f,
                k,
                ["DESCRIPTION", "TOTAL"],
                exact_title=(k == "PENGELUARAN"),
                start_row=max(1, r2_s),
            )
            if r3_s != -1 and r3_s != r2_s:
                break
            else:
                r3_s = -1

        if r1_s != -1 or r2_s != -1 or r3_s != -1 or rb_s != -1:
            results["type"] = "revenue"
            results["valid"] = True
            c_rev, c_tax, c_single, c_batch, c_sets_s, c_sets_b, c_bank = (
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            )

            # Initialize category column map for detection
            EXP_CAT_MAP = {}
            header_r = -1
            if r3_s != -1:
                # Scan 5 rows below title to find category headers
                for r_scan in range(r3_s + 1, r3_s + 6):
                    count_headers = 0
                    for col_scan in range(8, 30):
                        h_val = str(ws_v.cell(r_scan, col_scan).value or "").upper()
                        if h_val and any(
                            kw in h_val
                            for kw in ["GAJI", "TRANSPORT", "ADMIN", "BARANG", "SEWA"]
                        ):
                            count_headers += 1
                    if count_headers >= 3:
                        header_r = r_scan
                        break
            if header_r == -1:
                header_r = 4  # Fallback

            for col in range(8, 60):  # Scan typical category range
                h = ws_v.cell(header_r, col).value
                if not h:
                    continue
                target = re.sub(r"[^A-Z0-9]", "", str(h).upper())
                cid = None
                for cid_val, name, code, pid, group, sort in CATEGORY_CONFIG:
                    clean_name = re.sub(r"[^A-Z0-9]", "", name.upper())
                    if (
                        clean_name == target
                        or target in clean_name
                        or clean_name in target
                    ):
                        cid = cid_val
                        break

                if not cid:
                    TYPO_MAP = {
                        "RESEARCH": 2,
                        "INTEPRETASI": 4,
                        "OPERASI": 1,
                        "ALAT": 3,
                        "BARANG": 7,
                        "RUANGAN": 124,
                        "KANTOR": 8,
                        "TRANSPORT": 5,
                        "ADMINISTRASI": 6,
                        "KESEHATAN": 9,
                        "TRAINING": 10,
                        "LAIN": 12,
                        "BANK": 121,
                        "ADMIN": 121,
                        "PAJAK": 6,
                        "TAX": 121,
                        "CASH ADVANCE": 12,
                        "CASH ADV": 12,
                    }
                    for typo, tid in TYPO_MAP.items():
                        if typo in target:
                            cid = tid
                            break

                if cid:
                    EXP_CAT_MAP[col] = cid

            # Initialize counts to prevent KeyErrors
            results["counts"] = {
                "rev": 0,
                "tax": 0,
                "single": 0,
                "batch": 0,
                "sets_s": 0,
                "sets_b": 0,
                "bank": 0,
            }

            if r1_s != -1:
                col_desc = find_column_index(ws_v, "Detail/Description", r1_s)
                if col_desc == -1:
                    col_desc = 4

                col_val = find_column_index(ws_v, "INVOICE VALUE", r1_s)
                if col_val == -1:
                    col_val = 5
                col_val_usd = find_column_index(ws_v, "INVOICE VALUE USD", r1_s)
                col_val_idr = find_column_index(ws_v, "INVOICE VALUE IDR", r1_s)

                col_recv_val = find_column_index(ws_v, "AMOUNT RECEIVED", r1_s)
                if col_recv_val == -1:
                    col_recv_val = 12
                col_recv_val_idr = find_column_index(ws_v, "AMOUNT RECEIVED IDR", r1_s)
                col_recv_val_usd = find_column_index(ws_v, "AMOUNT RECEIVED USD", r1_s)

                for r in range(r1_s + 1, r1_e if r1_e != -1 else r1_s + 100):
                    desc = str(ws_v.cell(r, col_desc).value or "").strip()
                    if (
                        not desc
                        or "TOTAL" in desc.upper()
                        or "SUBTOTAL" in desc.upper()
                    ):
                        continue

                    inv_main = to_num_cell(ws_f, ws_v, r, col_val)
                    inv_usd = (
                        to_num_cell(ws_f, ws_v, r, col_val_usd)
                        if col_val_usd != -1
                        else 0
                    )
                    inv_idr = (
                        to_num_cell(ws_f, ws_v, r, col_val_idr)
                        if col_val_idr != -1
                        else 0
                    )
                    recv_main = to_num_cell(ws_f, ws_v, r, col_recv_val)
                    recv_idr = (
                        to_num_cell(ws_f, ws_v, r, col_recv_val_idr)
                        if col_recv_val_idr != -1
                        else 0
                    )
                    recv_usd = (
                        to_num_cell(ws_f, ws_v, r, col_recv_val_usd)
                        if col_recv_val_usd != -1
                        else 0
                    )

                    if (
                        inv_main != 0
                        or inv_usd != 0
                        or inv_idr != 0
                        or recv_main != 0
                        or recv_idr != 0
                        or recv_usd != 0
                    ):
                        c_rev += 1

            # Count Bank Transactions
            if rb_s != -1:
                col_bank_date = find_column_index(ws_v, "Date", rb_s)
                if col_bank_date == -1:
                    col_bank_date = 2

                bank_col_usd = find_column_index(ws_v, "USD", rb_s)

                bank_col_idr = find_column_index(ws_v, "IDR", rb_s)
                if bank_col_idr == -1:
                    bank_col_idr = find_column_index(ws_v, "VALUE", rb_s)
                if bank_col_idr == -1:
                    bank_col_idr = 5

                actual_rb_e = rb_e if rb_e != -1 else min(ws_v.max_row, rb_s + 500)
                # Pastikan tidak melewati bagian lain yang muncul setelahnya
                if r1_s > rb_s:
                    actual_rb_e = min(actual_rb_e, r1_s)
                if r2_s > rb_s:
                    actual_rb_e = min(actual_rb_e, r2_s)
                if r3_s > rb_s:
                    actual_rb_e = min(actual_rb_e, r3_s)

                for r in range(rb_s + 1, actual_rb_e):
                    v_b = get_cell_effective_value(ws_v, r, col_bank_date)
                    v_usd = (
                        to_num_cell(ws_f, ws_v, r, bank_col_usd)
                        if bank_col_usd != -1
                        else 0
                    )
                    v_idr = (
                        to_num_cell(ws_f, ws_v, r, bank_col_idr)
                        if bank_col_idr != -1
                        else 0
                    )

                    # Hanya hitung jika kolom tanggal berisi OBJEK TANGGAL dan ada angkanya
                    if isinstance(v_b, (dt.date, dt.datetime)) and (
                        v_usd != 0 or v_idr != 0
                    ):
                        c_bank += 1

            if r2_s != -1:
                col_tax_desc = find_column_index(ws_v, "Detail/Description", r2_s)
                if col_tax_desc == -1:
                    col_tax_desc = 4
                col_tax_val = find_column_index(ws_v, "Transaction Value", r2_s)
                if col_tax_val == -1:
                    col_tax_val = 5

                for r in range(r2_s + 1, r2_e if r2_e != -1 else r2_s + 100):
                    desc = str(ws_v.cell(r, col_tax_desc).value or "").strip()
                    if (
                        not desc
                        or "TOTAL" in desc.upper()
                        or "SUBTOTAL" in desc.upper()
                    ):
                        continue
                    has_val = False
                    for col in [col_tax_val, 8, 9, 10, 11, 12, 13, 14, 15, 16]:
                        if to_num_cell(ws_f, ws_v, r, col) != 0:
                            has_val = True
                            break
                    if has_val:
                        c_tax += 1

            if r3_s != -1:
                current_batch_active = False
                is_in_batch_section = False

                r = r3_s + 1
                while r <= ws_v.max_row:
                    val_b = get_cell_effective_value(ws_v, r, 2)
                    val_d = get_cell_effective_value(ws_v, r, 4)

                    cell_b = ws_f.cell(r, 2)
                    cell_d = ws_f.cell(r, 4)

                    val_d_str = str(val_d or "").upper().strip()
                    val_b_str = str(val_b or "").upper().strip()

                    # 1. Skip Noise Headers
                    header_noises = [
                        "ACTIVITY",
                        "DESCRIPTION",
                        "DETAIL",
                        "ITEM",
                        "PENGELUARAN",
                        "DATE",
                        "#",
                        "AMOUNT",
                        "VALUE",
                    ]
                    if any(h in val_d_str for h in header_noises) or any(
                        h in val_b_str for h in header_noises
                    ):
                        r += 1
                        continue

                    # 2. DETEKSI DIVIDER (SINGLE -> BATCH) - Hierarchical
                    if is_divider_row(val_b_str, cell_b, val_d_str, cell_d):
                        is_in_batch_section = True
                        current_batch_active = False
                        r += 1
                        continue

                    # 3. DETEKSI GROUP BY BANK - Hierarchical
                    if is_bank_header_row(val_b_str, cell_b, val_d_str, cell_d):
                        if is_in_batch_section:
                            c_sets_b += 1
                            current_batch_active = True
                        else:
                            c_sets_s += 1
                        r += 1
                        continue

                    # 4. DETEKSI SUB-KATEGORI - Hierarchical
                    elif (val_d and _is_subcategory_cell(cell_d)) or (
                        val_b and _is_subcategory_cell(cell_b)
                    ):
                        if is_in_batch_section:
                            c_sets_b += 1
                            current_batch_active = True
                        else:
                            # In Single mode, sub-cat headers might be labels,
                            # but we count them as group starts if they define a block
                            pass
                        r += 1
                        continue

                    # 5. Hitung has_amt di seluruh kolom yang relevan
                    has_amt = False
                    for fallback_col in [5, 6, 9]:
                        if to_num_cell(ws_f, ws_v, r, fallback_col) != 0:
                            has_amt = True
                            break

                    if not has_amt:
                        for col in EXP_CAT_MAP.keys():
                            if to_num_cell(ws_f, ws_v, r, col) != 0:
                                has_amt = True
                                break

                    if has_amt:
                        if is_in_batch_section and current_batch_active:
                            c_batch += 1
                        else:
                            c_single += 1
                            # If no set active in single mode, count this as a self-contained set
                            if not is_in_batch_section:
                                c_sets_s += 1

                    r += 1

            results["counts"] = {
                "rev": c_rev,
                "tax": c_tax,
                "single": c_single,
                "batch": c_batch,
                "sets_s": c_sets_s,
                "sets_b": c_sets_b,
                "bank": c_bank,
            }

        # 3. Neraca Scan (FULL LIST)
        found_n = []
        targets = [
            "PENDAPATAN LAINNYA",
            "CORPORATE TAX (PPh 29)",
            "KAS DAN SETARA KAS TAHUN SEBELUMNYA",
            "KAS DAN SETARA KAS TAHUN LAPORAN",
            "PIUTANG USAHA",
            "PAJAK BAYAR DI MUKA (pph23)",
            "BIAYA BAYAR DI MUKA",
            "PIUTANG LAIN LAIN",
            "INVENTARIS KANTOR",
            "HUTANG USAHA",
            "HUTANG GAJI",
            "HUTANG PEMEGANG SAHAM",
            "BIAYA YANG MASIH HARUS DI BAYAR",
            "MODAL SAHAM",
            "LABA DI TAHAN",
        ]
        for target in targets:
            t_up = target.upper()
            for r in range(1, 501):
                row_str = " ".join(
                    [str(ws_v.cell(r, c).value or "") for c in range(1, 12)]
                ).upper()
                if t_up in row_str:
                    found_n.append(target)
                    break
        if found_n:
            if results["type"] is None:
                results["type"] = "neraca"
                results["valid"] = True
            results["counts"]["neraca_items"] = found_n

        # 4. Dividend Scan
        div_n = []
        is_h = False
        for r in range(1, 150):
            val_a = str(ws_v.cell(r, 1).value or "").upper().strip()
            val_b = str(ws_v.cell(r, 2).value or "").upper().strip()
            if (
                "RECIPIENT" in val_b
                or "NAMA LENGKAP" in val_b
                or val_b == "DEVIDEN"
                or "RECIPIENT" in val_a
                or "NAMA LENGKAP" in val_a
                or val_a == "DEVIDEN"
            ):
                is_h = True
                continue
            if is_h:
                v2, v3 = ws_v.cell(r, 2).value, ws_v.cell(r, 3).value
                n = v3 if v3 and len(str(v3)) > 3 else v2
                if n and "TOTAL" not in str(n).upper() and len(str(n)) > 3:
                    div_n.append(str(n).strip())
                elif (v2 and "TOTAL" in str(v2).upper()) or (
                    v3 and "TOTAL" in str(v3).upper()
                ):
                    break
        if div_n:
            results["type"] = "dividend"
            results["valid"] = True
            results["counts"]["div_people"] = div_n

    except Exception as e:
        print(f"Error scan: {e}")
    return results


def preview_sheet(wb_f, wb_v, sheet_spec: str) -> None:
    """Tampilkan hasil analisis sheet secara visual."""
    try:
        res = scan_sheet_analysis(wb_f, wb_v, sheet_spec)
        if not res["name"]:
            print(f"❌ Sheet {sheet_spec} tidak ditemukan.")
            return

        print(f"\n--- INFORMASI SHEET: {res['name']} ---")
        if res["anchors"]:
            print("📌 Judul (Arial 20 Bold) ditemukan:")
            for r, txt in res["anchors"]:
                print(f"   Baris {r}: {txt}")

        print("\n🔍 Analisis Data Sheet:")
        if res["type"] == "revenue":
            c = res["counts"]
            print("   ✅ Terdeteksi: Sheet Revenue & Biaya")
            print(f"      - Pemasukan (Revenues) : {c['rev']} baris")
            print(f"      - Pajak (Taxes)        : {c['tax']} baris")
            print(f"      - Bank Status (NEW)   : {c.get('bank', 0)} mutasi")
            print(f"      - Pengeluaran (Total)  : {c['single'] + c['batch']} item")
            print(f"        ∟ Single Mode       : {c['single']} baris")
            print(f"        ∟ Batch Mode        : {c['batch']} baris")
            print(f"      - Single Total        : {c['sets_s']} settlement")
            print(f"      - Batch Total         : {c['sets_b']} settlement")
            print(f"      - Settlements Created : {c['sets_s'] + c['sets_b']} grup")
        elif res["type"] == "neraca":
            items = res["counts"]["neraca_items"]
            lr_targets = ["PENDAPATAN LAINNYA", "CORPORATE TAX (PPh 29)"]
            lr_found = [i for i in items if i in lr_targets]
            n_found = [i for i in items if i not in lr_targets]

            print("   ✅ Terdeteksi: Sheet Laba Rugi / Neraca")
            print(f"      - Total Item Terbaca   : {len(items)} item")

            if lr_found:
                print("\n     --- [LABA RUGI] ---")
                for item in lr_found:
                    print(f"     {item} : 1")

            if n_found:
                print("\n     --- [NERACA] ---")
                for item in n_found:
                    print(f"     {item} : 1")
        elif res["type"] == "dividend":
            people = res["counts"]["div_people"]
            print("   ✅ Terdeteksi: Sheet Dividend")
            print(f"      - Penerima Deviden: {len(people)} orang")
            for p in people[:5]:
                print(f"        👤 {p}")
        else:
            print("   ❓ Data tidak spesifik atau tidak terdeteksi.")
        print("-" * 70)
    except Exception as e:
        print(f"Gagal pratinjau: {e}")
    finally:
        pass


def migrate(
    excel_path_override: str | None = None,
    target_year: int | None = None,
    *,
    auto_sheets: bool = True,
    sheet_revenue: str | None = None,
    sheet_neraca: str | None = None,
    sheet_dividend: str | None = None,
    output_path: str | None = None,
    target_company: str = "EWI Foundation",
):
    print(f"Membangun Reconstructed SQL (Target Year: {target_year or 'SEMUA'})...")
    years_found = set()
    os.makedirs(HASILSQL_DIR, exist_ok=True)
    if output_path:
        output_sql = output_path
        mode = "a" if os.path.exists(output_path) else "w"
    else:
        # Create a subfolder with YYYY-MM-DD_HH-mm-ss
        folder_stamp = dt.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        subfolder = os.path.join(HASILSQL_DIR, folder_stamp)
        os.makedirs(subfolder, exist_ok=True)

        file_stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
        output_sql = os.path.join(subfolder, f"{OUTPUT_SQL_STEM}_{file_stamp}.sql")
        mode = "w"

    is_append = mode == "a"

    # --- Load Old Evidence ---
    db_url = None
    env_path = os.path.join(
        os.path.dirname(os.path.dirname(os.path.dirname(__file__))), ".env"
    )
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("DATABASE_URL="):
                    db_url = line.strip().split("=", 1)[1]
                    break
    old_evidence_data = load_old_evidence_data(db_url)

    global_seq_idx = 0

    def get_seq_date(idx, start_year=None):
        yr = (
            start_year if start_year else (target_year if target_year else default_year)
        )
        # idx starts from 0, 1, 2...
        d = (idx % 28) + 1
        m = (idx // 28) % 12 + 1
        y_off = idx // (28 * 12)
        try:
            return dt.date(yr + y_off, m, d)
        except ValueError:
            return dt.date(yr + y_off, m, 28)

    DDL_SCHEMA = r"""
-- =====================================================================
-- PostgreSQL Schema DDL (sync dengan models.py terkini)
-- =====================================================================
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Companies
CREATE TABLE IF NOT EXISTS public.companies (
    id SERIAL PRIMARY KEY,
    name character varying(100) NOT NULL UNIQUE,
    sort_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Users (company_access = JSON array of allowed companies)
CREATE TABLE IF NOT EXISTS public.users (
    id SERIAL PRIMARY KEY,
    username character varying(80) NOT NULL UNIQUE,
    email character varying(150) UNIQUE,
    google_id character varying(200) UNIQUE,
    password_hash character varying(256) NOT NULL,
    reset_token character varying(100),
    reset_token_expiry timestamp without time zone,
    full_name character varying(150) NOT NULL,
    phone_number character varying(20) DEFAULT '-',
    workplace character varying(100) DEFAULT '-',
    role character varying(20) NOT NULL DEFAULT 'staff',
    company_access json,
    profile_image character varying(500),
    default_report_year integer DEFAULT 0,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Categories (multi-tenant)
CREATE TABLE IF NOT EXISTS public.categories (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL UNIQUE,
    parent_id integer REFERENCES public.categories(id),
    status character varying(20) DEFAULT 'approved',
    created_by integer REFERENCES public.users(id),
    sort_order integer DEFAULT 0,
    main_group character varying(50)
);

-- Bank Accounts
CREATE TABLE IF NOT EXISTS public.bank_accounts (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    name character varying(100) NOT NULL,
    account_number character varying(50),
    currency character varying(10) DEFAULT 'IDR',
    account_type character varying(20) DEFAULT 'management',
    user_id integer REFERENCES public.users(id),
    initial_balance double precision DEFAULT 0.0,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Bank Transactions (multi-tenant)
CREATE TABLE IF NOT EXISTS public.bank_transactions (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    bank_id integer REFERENCES public.bank_accounts(id),
    to_bank_id integer REFERENCES public.bank_accounts(id),
    date date NOT NULL,
    description character varying(300) NOT NULL,
    amount_usd double precision DEFAULT 0.0,
    amount_idr double precision DEFAULT 0.0,
    transaction_type character varying(50),
    group_name character varying(100),
    report_year integer,
    revenue_id integer,
    user_id integer REFERENCES public.users(id),
    created_at timestamp without time zone DEFAULT NOW()
);

-- Bank Status Transactions (multi-tenant)
CREATE TABLE IF NOT EXISTS public.bank_status_transactions (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    bank_id integer REFERENCES public.bank_accounts(id),
    to_bank_id integer REFERENCES public.bank_accounts(id),
    date date NOT NULL,
    description character varying(300) NOT NULL,
    amount_usd double precision DEFAULT 0.0,
    amount_idr double precision DEFAULT 0.0,
    transaction_type character varying(50),
    group_name character varying(100),
    report_year integer,
    user_id integer REFERENCES public.users(id),
    created_at timestamp without time zone DEFAULT NOW()
);

-- Assets (multi-tenant)
CREATE TABLE IF NOT EXISTS public.assets (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    asset_code character varying(50),
    name character varying(200) NOT NULL,
    purchase_date date NOT NULL,
    purchase_price double precision NOT NULL,
    useful_life_months integer NOT NULL,
    residual_value double precision DEFAULT 0.0,
    asset_type character varying(50),
    status character varying(30) DEFAULT 'Active',
    description text,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Advances (multi-tenant, full workflow)
CREATE TABLE IF NOT EXISTS public.advances (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    title character varying(200) NOT NULL,
    description text,
    advance_type character varying(10) DEFAULT 'single',
    document_date date,
    user_id integer NOT NULL REFERENCES public.users(id),
    status character varying(30) DEFAULT 'draft',
    notes text,
    approved_revision_no integer,
    active_revision_no integer,
    report_year integer,
    created_at timestamp without time zone DEFAULT NOW(),
    updated_at timestamp without time zone DEFAULT NOW(),
    approved_at timestamp without time zone,
    bank_id integer REFERENCES public.bank_accounts(id),
    disbursement_source character varying(200),
    disbursement_source_id integer REFERENCES public.bank_accounts(id),
    return_source character varying(200),
    return_source_id integer REFERENCES public.bank_accounts(id),
    admin_fee double precision DEFAULT 0.0,
    disbursed_amount double precision DEFAULT 0.0,
    returned_amount double precision DEFAULT 0.0,
    disbursement_comment text,
    return_description text,
    disbursement_evidence_path text,
    disbursement_evidence_filename text,
    return_evidence_path text,
    return_evidence_filename text,
    is_disbursement_approved boolean DEFAULT false,
    is_return_approved boolean DEFAULT false,
    return_status character varying(20) DEFAULT 'pending',
    return_notes text,
    current_stage character varying(30) DEFAULT 'draft',
    expected_completion_at timestamp without time zone,
    modified_t1 boolean DEFAULT false,
    modified_t2 boolean DEFAULT false,
    modified_t3 boolean DEFAULT false,
    approved_amount_override double precision,
    asset_id integer REFERENCES public.assets(id)
);

-- Advance Items (multi-tenant)
CREATE TABLE IF NOT EXISTS public.advance_items (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    advance_id integer NOT NULL REFERENCES public.advances(id) ON DELETE CASCADE,
    category_id integer NOT NULL,
    description character varying(300) NOT NULL,
    estimated_amount double precision NOT NULL,
    revision_no integer,
    evidence_path text,
    evidence_filename text,
    date date,
    source character varying(50),
    currency character varying(10) DEFAULT 'IDR',
    currency_exchange double precision DEFAULT 1.0,
    status character varying(20) DEFAULT 'pending',
    notes text,
    asset_id integer REFERENCES public.assets(id),
    created_at timestamp without time zone DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.advance_item_subcategories (
    advance_item_id integer NOT NULL REFERENCES public.advance_items(id) ON DELETE CASCADE,
    category_id integer NOT NULL
);

-- Settlements (multi-tenant, full workflow)
CREATE TABLE IF NOT EXISTS public.settlements (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    title character varying(200) NOT NULL,
    description text,
    document_date date,
    settlement_type character varying(10) DEFAULT 'single',
    user_id integer NOT NULL REFERENCES public.users(id),
    status character varying(20) DEFAULT 'draft',
    report_year integer,
    created_at timestamp without time zone DEFAULT NOW(),
    updated_at timestamp without time zone DEFAULT NOW(),
    submitted_at timestamp without time zone,
    completed_at timestamp without time zone,
    bank_id integer REFERENCES public.bank_accounts(id),
    disbursement_source character varying(200),
    disbursement_source_id integer REFERENCES public.bank_accounts(id),
    return_source character varying(200),
    return_source_id integer REFERENCES public.bank_accounts(id),
    admin_fee double precision DEFAULT 0.0,
    disbursed_amount double precision DEFAULT 0.0,
    returned_amount double precision DEFAULT 0.0,
    disbursement_comment text,
    return_description text,
    disbursement_evidence_path text,
    disbursement_evidence_filename text,
    return_evidence_path text,
    return_evidence_filename text,
    is_disbursement_approved boolean DEFAULT false,
    is_return_approved boolean DEFAULT false,
    return_status character varying(20) DEFAULT 'pending',
    return_notes text,
    current_stage character varying(30) DEFAULT 'draft',
    expected_completion_at timestamp without time zone,
    modified_t1 boolean DEFAULT false,
    modified_t2 boolean DEFAULT false,
    modified_t3 boolean DEFAULT false,
    approved_amount_override double precision,
    advance_id integer REFERENCES public.advances(id)
);

-- Expenses (multi-tenant)
CREATE TABLE IF NOT EXISTS public.expenses (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    settlement_id integer NOT NULL REFERENCES public.settlements(id) ON DELETE CASCADE,
    category_id integer NOT NULL,
    description character varying(300) NOT NULL,
    amount double precision NOT NULL,
    date date NOT NULL,
    source character varying(50),
    advance_item_id integer,
    revision_no integer,
    currency character varying(10) DEFAULT 'IDR',
    currency_exchange double precision DEFAULT 1.0,
    evidence_path text,
    evidence_filename text,
    status character varying(20) DEFAULT 'pending',
    notes text,
    asset_id integer REFERENCES public.assets(id),
    created_at timestamp without time zone DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.expense_subcategories (
    expense_id integer NOT NULL REFERENCES public.expenses(id) ON DELETE CASCADE,
    category_id integer NOT NULL
);

-- Revenues (multi-tenant)
CREATE TABLE IF NOT EXISTS public.revenues (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    invoice_date date NOT NULL,
    description character varying(300) NOT NULL,
    invoice_value double precision NOT NULL DEFAULT 0.0,
    invoice_value_usd double precision DEFAULT 0.0,
    invoice_value_idr double precision DEFAULT 0.0,
    currency character varying(10) DEFAULT 'IDR',
    currency_exchange double precision DEFAULT 1.0,
    invoice_number character varying(50),
    client character varying(150),
    receive_date date,
    amount_received double precision DEFAULT 0.0,
    amount_received_idr double precision DEFAULT 0.0,
    amount_received_usd double precision DEFAULT 0.0,
    ppn double precision DEFAULT 0.0,
    pph_23 double precision DEFAULT 0.0,
    transfer_fee double precision DEFAULT 0.0,
    remark text,
    revenue_type character varying(32) NOT NULL DEFAULT 'pendapatan_langsung',
    is_selected_for_tax_offset boolean DEFAULT true,
    report_year integer,
    bank_id integer REFERENCES public.bank_accounts(id),
    user_id integer REFERENCES public.users(id),
    created_at timestamp without time zone DEFAULT NOW()
);

-- Taxes (multi-tenant, extended bases)
CREATE TABLE IF NOT EXISTS public.taxes (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    date date NOT NULL,
    description character varying(300) NOT NULL,
    transaction_value double precision NOT NULL DEFAULT 0.0,
    invoice_value_usd double precision DEFAULT 0.0,
    transaction_value_idr double precision DEFAULT 0.0,
    currency character varying(10) DEFAULT 'IDR',
    currency_exchange double precision DEFAULT 1.0,
    ppn double precision DEFAULT 0.0,
    ppn_base double precision DEFAULT 0.0,
    pph_21 double precision DEFAULT 0.0,
    pph_21_base double precision DEFAULT 0.0,
    pph_23 double precision DEFAULT 0.0,
    pph_23_base double precision DEFAULT 0.0,
    pph_26 double precision DEFAULT 0.0,
    pph_26_base double precision DEFAULT 0.0,
    pemasukan_negara double precision DEFAULT 0.0,
    pemasukan_negara_base double precision DEFAULT 0.0,
    report_year integer,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Dividends (multi-tenant)
CREATE TABLE IF NOT EXISTS public.dividends (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    date date NOT NULL,
    name character varying(150) NOT NULL,
    amount double precision NOT NULL DEFAULT 0.0,
    percentage double precision DEFAULT 0.0,
    recipient_count integer NOT NULL DEFAULT 1,
    tax_percentage double precision NOT NULL DEFAULT 10.0,
    report_year integer,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Category Groups
CREATE TABLE IF NOT EXISTS public.category_groups (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    name character varying(100) NOT NULL,
    sort_order integer DEFAULT 0
);

-- Dividend Settings (multi-tenant)
CREATE TABLE IF NOT EXISTS public.dividend_settings (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    year integer NOT NULL UNIQUE,
    profit_retained double precision NOT NULL DEFAULT 0.0,
    opening_cash_balance double precision NOT NULL DEFAULT 0.0,
    accounts_receivable double precision NOT NULL DEFAULT 0.0,
    prepaid_tax_pph23 double precision NOT NULL DEFAULT 0.0,
    prepaid_expenses double precision NOT NULL DEFAULT 0.0,
    other_receivables double precision NOT NULL DEFAULT 0.0,
    office_inventory double precision NOT NULL DEFAULT 0.0,
    other_assets double precision NOT NULL DEFAULT 0.0,
    accounts_payable double precision NOT NULL DEFAULT 0.0,
    salary_payable double precision NOT NULL DEFAULT 0.0,
    shareholder_payable double precision NOT NULL DEFAULT 0.0,
    accrued_expenses double precision NOT NULL DEFAULT 0.0,
    share_capital double precision NOT NULL DEFAULT 0.0,
    retained_earnings_balance double precision NOT NULL DEFAULT 0.0,
    corporate_tax_pph29 double precision NOT NULL DEFAULT 0.0,
    corporate_tax_rate double precision DEFAULT 22.0,
    other_income double precision NOT NULL DEFAULT 0.0,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Manual Combine Groups (laporan tabel)
CREATE TABLE IF NOT EXISTS public.manual_combine_groups (
    id SERIAL PRIMARY KEY,
    table_name character varying(20) NOT NULL,
    report_year integer NOT NULL,
    group_date date NOT NULL,
    row_ids_json text NOT NULL,
    merged_columns_json text,
    original_data_json text,
    created_at timestamp without time zone DEFAULT NOW()
);

-- Notifications
CREATE TABLE IF NOT EXISTS public.notifications (
    id SERIAL PRIMARY KEY,
    user_id integer NOT NULL REFERENCES public.users(id),
    actor_id integer REFERENCES public.users(id),
    action_type character varying(50) NOT NULL,
    target_type character varying(50) NOT NULL,
    target_id integer NOT NULL,
    message text NOT NULL,
    read_status boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT NOW(),
    link_path character varying(200),
    extra_metadata json
);

-- Deadline Settings
CREATE TABLE IF NOT EXISTS public.deadline_settings (
    id SERIAL PRIMARY KEY,
    rule_key character varying(50) NOT NULL,
    days json NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT NOW(),
    updated_at timestamp without time zone DEFAULT NOW()
);

-- Workflow Logs
CREATE TABLE IF NOT EXISTS public.workflow_logs (
    id SERIAL PRIMARY KEY,
    company character varying(100) NOT NULL DEFAULT 'EWI Foundation',
    document_type character varying(20) NOT NULL,
    document_id integer NOT NULL,
    from_status character varying(30),
    to_status character varying(30) NOT NULL,
    action character varying(50) NOT NULL,
    user_id integer REFERENCES public.users(id),
    created_at timestamp without time zone DEFAULT NOW(),
    duration_seconds integer,
    comment text
);

-- Alembic
CREATE TABLE IF NOT EXISTS public.alembic_version (
    version_num character varying(32) NOT NULL,
    CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num)
);

CREATE TABLE IF NOT EXISTS public.override_logs (
    id SERIAL PRIMARY KEY,
    item_id integer NOT NULL,
    item_type character varying(50) NOT NULL,
    changed_by integer NOT NULL REFERENCES public.users(id),
    original_amount double precision NOT NULL,
    revised_amount double precision NOT NULL,
    changed_at timestamp without time zone DEFAULT NOW(),
    notes text
);

-- Indexes
CREATE UNIQUE INDEX IF NOT EXISTS users_username_key ON public.users(username);
CREATE INDEX IF NOT EXISTS idx_settlements_company_year ON public.settlements(company, report_year);
CREATE INDEX IF NOT EXISTS idx_expenses_settlement ON public.expenses(settlement_id);
CREATE INDEX IF NOT EXISTS idx_advances_company_year ON public.advances(company, report_year);
CREATE INDEX IF NOT EXISTS ix_workflow_logs_document_id ON public.workflow_logs(document_id);
CREATE INDEX IF NOT EXISTS ix_workflow_logs_document_type ON public.workflow_logs(document_type);
CREATE INDEX IF NOT EXISTS idx_revenues_company_year ON public.revenues(company, report_year);
CREATE INDEX IF NOT EXISTS idx_taxes_company_year ON public.taxes(company, report_year);
CREATE INDEX IF NOT EXISTS idx_bank_transactions_company_year ON public.bank_transactions(company, report_year);
"""

    cat_id_by_name = {}
    for cid, name, code, pid, group, sort in CATEGORY_CONFIG:
        n_up = name.upper().strip()
        cat_id_by_name[n_up] = cid
        # Also map without parentheses for more flexible matching
        short_name = re.sub(r"\(.*?\)", "", n_up).strip()
        cat_id_by_name[short_name] = cid

    header_ddl = DDL_SCHEMA
    data_part = ""  # Dikosongkan agar tidak mengambil data lama dari backup SQL
    footer_part = "\n-- End of Schema --\n"

    xl_path = excel_path_override or excel_path
    sheetnames = list_excel_sheets(xl_path)
    if auto_sheets:
        name_rev = _pick_sheet_auto(sheetnames, "Revenue-Cost") or _pick_sheet_auto(
            sheetnames, "Rev VS"
        )
        name_ner = _pick_sheet_auto(sheetnames, "Laba rugi") or _pick_sheet_auto(
            sheetnames, "Neraca"
        )
        name_div = _pick_sheet_auto(sheetnames, "Business Summary") or _pick_sheet_auto(
            sheetnames, "Deviden"
        )
    else:
        name_rev = (
            _pick_sheet_by_spec(sheetnames, sheet_revenue) if sheet_revenue else None
        )
        name_ner = (
            _pick_sheet_by_spec(sheetnames, sheet_neraca) if sheet_neraca else None
        )
        name_div = (
            _pick_sheet_by_spec(sheetnames, sheet_dividend) if sheet_dividend else None
        )

    print(f"  File Excel: {xl_path}")
    print(
        "  Sheet dipakai — Revenue-Cost: "
        f"{name_rev or '(dilewati)'} | Laba rugi: {name_ner or '(dilewati)'} | Dividen: {name_div or '(dilewati)'}"
    )

    wb_f = load_workbook(xl_path, data_only=False)
    wb_v = load_workbook(xl_path, data_only=True)

    ws_f = wb_f[name_rev] if name_rev else None
    ws_v = wb_v[name_rev] if name_rev else None

    # MENDETEKSI TAHUN DEFAULT DARI HEADER SHEET
    # User Request: Prioritize terminal selection (target_year) over detected year
    detected_yr = detect_master_year(ws_v) if ws_v else 2024
    default_year = target_year if target_year else detected_yr
    print(
        f"  Tahun laporan terdeteksi: {default_year} (Target: {target_year}, Detected: {detected_yr})"
    )

    if ws_v:
        r1_start, r1_end = -1, -1
        for kw in ["REVENUE & TAX", "REVENUE DI"]:
            r1_start, r1_end = find_table_range(
                ws_v, ws_f, kw, ["REVENUE (IDR)", "NETT REVENUE"]
            )
            if r1_start != -1:
                break

        rb_start, rb_end = -1, -1
        for kw in ["BANK Status", "INTEREST FROM"]:
            rb_start, rb_end = find_table_range(ws_v, ws_f, kw, ["TOTAL", "PAJAK"])
            if rb_start != -1:
                break

        r2_start, r2_end = -1, -1
        for kw in ["PAJAK PENGELUARAN", "PAJAK DAN PENERIMAAN"]:
            r2_start, r2_end = find_table_range(ws_v, ws_f, kw, ["PENERIMAAN NEGARA"])
            if r2_start != -1:
                break

        r3_start, r3_end = -1, -1
        search_start = max(1, r2_start)
        for k in [
            "PENGELUARAN",
            "ACTIVITY",
            "BIAYA OPERASIONAL",
            "BIAYA OPERASI",
            "OPERATION COST",
            "OPERATION COST AND OFFICE",
            "PEMINDAHBUKUAN",
            "TRANSFER DARI",
            "SETTLEMENT EXPENSES",
        ]:
            tmp_s, _ = find_table_range(
                ws_v,
                ws_f,
                k,
                ["TOTAL"],
                exact_title=(k == "PENGELUARAN"),
                start_row=search_start,
            )
            if tmp_s != -1:
                r3_start = tmp_s
                print(f"   [Found] '{k}' title at row {r3_start}")
                break

        # If still not found, fallback search anywhere
        if r3_start == -1:
            for r in range(1, 1000):
                v_all = " ".join(
                    [
                        str(ws_v.cell(r, c).value or "").upper().strip()
                        for c in range(1, 5)
                    ]
                )
                if "PENGELUARAN" in v_all and r != r2_start:
                    r3_start = r
                    print(f"   [Found] 'PENGELUARAN' anchor at row {r3_start}")
                    break

        # FIX: Scan for category map (IDENTIFY HEADERS DINAMIS)
        # Logika: Cari baris header (biasanya 1-2 baris di bawah judul "PENGELUARAN")
        EXP_CAT_MAP = {}
        header_r = -1
        if r3_start != -1:
            # Scan 5 baris di bawah judul untuk mencari baris yang berisi banyak header kategori
            for r_scan in range(r3_start + 1, r3_start + 6):
                count_headers = 0
                for col_scan in range(
                    8, 30
                ):  # Kolom kategori biasanya mulai dari kolom 9 (I) ke kanan
                    h_val = str(ws_v.cell(r_scan, col_scan).value or "").upper()
                    if h_val and any(
                        kw in h_val
                        for kw in ["GAJI", "TRANSPORT", "ADMIN", "BARANG", "SEWA"]
                    ):
                        count_headers += 1
                if count_headers >= 3:
                    header_r = r_scan
                    break

        if header_r == -1:
            header_r = r3_start if r3_start != -1 else 40

        print(f"   [Header Scan] Scanning row {header_r} for category columns...")

        for col in range(1, 100):
            h = ws_v.cell(header_r, col).value
            if h is None:
                if col < 50 and ws_v.cell(header_r, col + 1).value is None:
                    continue
                if col >= 50:
                    break
                continue

            target = re.sub(r"[^A-Z0-9]", "", str(h).upper())
            if not target or target in [
                "FROM",
                "TO",
                "TOTAL",
                "DATE",
                "ACTIVITY",
                "DESCRIPTION",
                "AMOUNT",
                "VALUE",
                "CURRENCY",
            ]:
                continue

            cid = None
            for cid_val, name, code, pid, group, sort in CATEGORY_CONFIG:
                if cid_val >= 900:
                    continue
                clean_name = re.sub(r"[^A-Z0-9]", "", name.upper())
                if not clean_name:
                    continue
                if clean_name == target or target in clean_name or clean_name in target:
                    cid = cid_val
                    break

            if not cid:
                TYPO_MAP = {
                    "RESEARCH": 2,
                    "INTEPRETASI": 4,
                    "OPERASI": 1,
                    "ALAT": 3,
                    "BARANG": 7,
                    "RUANGAN": 124,
                    "KANTOR": 8,
                    "TRANSPORT": 5,
                    "ADMINISTRASI": 6,
                    "KESEHATAN": 9,
                    "TRAINING": 10,
                    "LAIN": 12,
                    "BANK": 121,
                    "ADMIN": 121,
                    "PAJAK": 6,
                    "TAX": 121,
                }

                for typo, tid in TYPO_MAP.items():
                    if typo in target:
                        cid = tid
                        break

            if cid:
                print(f"      - Column {col} ({h}) mapped to Category ID {cid}")
                EXP_CAT_MAP[col] = cid

    else:
        r1_start, r1_end = -1, -1
        rb_start, rb_end = -1, -1
        r2_start, r2_end = -1, -1
        r3_start = -1
        EXP_CAT_MAP = {}

    data_ops = [
        "\n-- SCHEMA UPDATES --\n",
        "CREATE TABLE IF NOT EXISTS public.companies (id SERIAL PRIMARY KEY, name varchar(100) NOT NULL UNIQUE, sort_order integer DEFAULT 0, created_at timestamp without time zone DEFAULT NOW());\n",
        "INSERT INTO public.companies (name, sort_order) VALUES ('EWI Foundation', 1), ('Expans Wireless Indo', 2) ON CONFLICT (name) DO NOTHING;\n",
        "ALTER TABLE public.settlements ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS report_year integer, ADD COLUMN IF NOT EXISTS document_date date, ADD COLUMN IF NOT EXISTS submitted_at timestamp with time zone, ADD COLUMN IF NOT EXISTS completed_at timestamp with time zone, ADD COLUMN IF NOT EXISTS bank_id integer, ADD COLUMN IF NOT EXISTS disbursement_source varchar(50), ADD COLUMN IF NOT EXISTS disbursement_source_id integer REFERENCES public.bank_accounts(id), ADD COLUMN IF NOT EXISTS return_source varchar(50), ADD COLUMN IF NOT EXISTS return_source_id integer REFERENCES public.bank_accounts(id), ADD COLUMN IF NOT EXISTS admin_fee float DEFAULT 0, ADD COLUMN IF NOT EXISTS disbursed_amount float, ADD COLUMN IF NOT EXISTS disbursement_date date, ADD COLUMN IF NOT EXISTS returned_amount float DEFAULT 0, ADD COLUMN IF NOT EXISTS disbursement_evidence_path text, ADD COLUMN IF NOT EXISTS disbursement_evidence_filename text, ADD COLUMN IF NOT EXISTS return_evidence_path text, ADD COLUMN IF NOT EXISTS return_evidence_filename text, ADD COLUMN IF NOT EXISTS is_disbursement_approved boolean DEFAULT false, ADD COLUMN IF NOT EXISTS is_return_approved boolean DEFAULT false, ADD COLUMN IF NOT EXISTS return_status character varying(20) DEFAULT 'pending', ADD COLUMN IF NOT EXISTS return_notes text, ADD COLUMN IF NOT EXISTS current_stage character varying(30) DEFAULT 'draft', ADD COLUMN IF NOT EXISTS expected_completion_at timestamp with time zone, ADD COLUMN IF NOT EXISTS modified_t1 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS modified_t2 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS modified_t3 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS approved_amount_override double precision, ADD COLUMN IF NOT EXISTS advance_id integer REFERENCES public.advances(id);\n",
        "ALTER TABLE public.advances ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS report_year integer, ADD COLUMN IF NOT EXISTS document_date date, ADD COLUMN IF NOT EXISTS approved_revision_no integer DEFAULT 0, ADD COLUMN IF NOT EXISTS active_revision_no integer, ADD COLUMN IF NOT EXISTS bank_id integer, ADD COLUMN IF NOT EXISTS disbursement_source varchar(50), ADD COLUMN IF NOT EXISTS disbursement_source_id integer REFERENCES public.bank_accounts(id), ADD COLUMN IF NOT EXISTS return_source varchar(50), ADD COLUMN IF NOT EXISTS return_source_id integer REFERENCES public.bank_accounts(id), ADD COLUMN IF NOT EXISTS admin_fee float DEFAULT 0, ADD COLUMN IF NOT EXISTS disbursed_amount float, ADD COLUMN IF NOT EXISTS returned_amount float DEFAULT 0, ADD COLUMN IF NOT EXISTS disbursement_evidence_path text, ADD COLUMN IF NOT EXISTS disbursement_evidence_filename text, ADD COLUMN IF NOT EXISTS return_evidence_path text, ADD COLUMN IF NOT EXISTS return_evidence_filename text, ADD COLUMN IF NOT EXISTS is_disbursement_approved boolean DEFAULT false, ADD COLUMN IF NOT EXISTS is_return_approved boolean DEFAULT false, ADD COLUMN IF NOT EXISTS return_status character varying(20) DEFAULT 'pending', ADD COLUMN IF NOT EXISTS return_notes text, ADD COLUMN IF NOT EXISTS current_stage character varying(30) DEFAULT 'draft', ADD COLUMN IF NOT EXISTS expected_completion_at timestamp with time zone, ADD COLUMN IF NOT EXISTS modified_t1 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS modified_t2 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS modified_t3 boolean DEFAULT false, ADD COLUMN IF NOT EXISTS approved_amount_override double precision, ADD COLUMN IF NOT EXISTS asset_id integer;\n",
        "ALTER TABLE public.advance_items ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS revision_no integer DEFAULT 0, ADD COLUMN IF NOT EXISTS evidence_path text, ADD COLUMN IF NOT EXISTS evidence_filename text, ADD COLUMN IF NOT EXISTS date date, ADD COLUMN IF NOT EXISTS source varchar(50), ADD COLUMN IF NOT EXISTS currency varchar(10) DEFAULT 'IDR', ADD COLUMN IF NOT EXISTS currency_exchange float DEFAULT 1.0, ADD COLUMN IF NOT EXISTS status varchar(20) DEFAULT 'pending', ADD COLUMN IF NOT EXISTS notes text, ADD COLUMN IF NOT EXISTS created_at timestamp with time zone DEFAULT NOW(), ADD COLUMN IF NOT EXISTS asset_id integer;\n",
        "ALTER TABLE public.notifications ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS is_multi_cat boolean DEFAULT false, ADD COLUMN IF NOT EXISTS link_path varchar(200), ADD COLUMN IF NOT EXISTS extra_metadata json;\n",
        "ALTER TABLE public.deadline_settings ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS is_multi_cat boolean DEFAULT false;\n",
        "ALTER TABLE public.revenues ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS invoice_value_usd float, ADD COLUMN IF NOT EXISTS invoice_value_idr float, ADD COLUMN IF NOT EXISTS amount_received_idr float, ADD COLUMN IF NOT EXISTS amount_received_usd float, ADD COLUMN IF NOT EXISTS is_selected_for_tax_offset boolean DEFAULT false, ADD COLUMN IF NOT EXISTS bank_id integer REFERENCES public.bank_accounts(id), ADD COLUMN IF NOT EXISTS user_id integer REFERENCES public.users(id);\n",
        "ALTER TABLE public.taxes ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS invoice_value_usd float, ADD COLUMN IF NOT EXISTS transaction_value_idr float, ADD COLUMN IF NOT EXISTS ppn_base float, ADD COLUMN IF NOT EXISTS pph_21_base float, ADD COLUMN IF NOT EXISTS pph_23_base float, ADD COLUMN IF NOT EXISTS pph_26_base float, ADD COLUMN IF NOT EXISTS pemasukan_negara float, ADD COLUMN IF NOT EXISTS pemasukan_negara_base float;\n",
        "ALTER TABLE public.manual_combine_groups ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS merged_columns_json text, ADD COLUMN IF NOT EXISTS original_data_json text;\n",
        "ALTER TABLE public.users ADD COLUMN IF NOT EXISTS default_report_year integer DEFAULT 0, ADD COLUMN IF NOT EXISTS company_access json;\n",
        "ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation';\n",
        "ALTER TABLE public.bank_accounts ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation';\n",
        "ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS revenue_id integer REFERENCES public.revenues(id) ON DELETE SET NULL, ADD COLUMN IF NOT EXISTS user_id integer REFERENCES public.users(id);\n",
        "ALTER TABLE public.assets ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation';\n",
        "ALTER TABLE public.expenses ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS asset_id integer;\n",
        "ALTER TABLE public.dividends ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS percentage float DEFAULT 0;\n",
        "ALTER TABLE public.dividend_settings ADD COLUMN IF NOT EXISTS company varchar(100) DEFAULT 'EWI Foundation', ADD COLUMN IF NOT EXISTS corporate_tax_rate float DEFAULT 22.0;\n",
        "CREATE TABLE IF NOT EXISTS public.category_groups (id SERIAL PRIMARY KEY, company varchar(100) NOT NULL DEFAULT 'EWI Foundation', name varchar(100) NOT NULL, sort_order integer DEFAULT 0);\n",
        "INSERT INTO public.category_groups (name, sort_order) VALUES ('BEBAN LANGSUNG', 1), ('BEBAN TIDAK LANGSUNG', 2), ('BIAYA ADMINISTRASI DAN UMUM', 3) ON CONFLICT DO NOTHING;\n",
        "CREATE TABLE IF NOT EXISTS public.workflow_logs (id SERIAL PRIMARY KEY, company varchar(100) NOT NULL DEFAULT 'EWI Foundation', document_type varchar(20) NOT NULL, document_id integer NOT NULL, from_status varchar(30), to_status varchar(30) NOT NULL, action varchar(50) NOT NULL, user_id integer REFERENCES public.users(id), created_at timestamp with time zone DEFAULT NOW(), duration_seconds integer, comment text);\n",
        "CREATE TABLE IF NOT EXISTS public.override_logs (id SERIAL PRIMARY KEY, item_id integer NOT NULL, item_type varchar(50) NOT NULL, changed_by integer NOT NULL REFERENCES public.users(id), original_amount double precision NOT NULL, revised_amount double precision NOT NULL, changed_at timestamp without time zone DEFAULT NOW(), notes text);\n",
        "CREATE INDEX IF NOT EXISTS ix_workflow_logs_document_id ON public.workflow_logs(document_id);\n",
        "CREATE INDEX IF NOT EXISTS ix_workflow_logs_document_type ON public.workflow_logs(document_type);\n",
        "\n-- CLEAR EXISTING CODES TO PREVENT CONFLICTS DURING RE-SORTING --\n",
        "UPDATE public.categories SET code = 'TEMP_' || id;\n",
        "\n-- UPDATE CATEGORY SORTING (UI CONFIG) --\n",
    ]
    for cid, name, code, pid, group, sort in CATEGORY_CONFIG:
        p_val = f"{pid}" if pid else "NULL"
        data_ops.append(
            f"INSERT INTO public.categories (id, name, code, parent_id, main_group, sort_order, status, company) VALUES ({cid}, '{name}', '{code}', {p_val}, '{group}', {sort}, 'approved', {to_sql_val(target_company)}) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, code = EXCLUDED.code, parent_id = EXCLUDED.parent_id, main_group = EXCLUDED.main_group, sort_order = EXCLUDED.sort_order, company = EXCLUDED.company;\n"
        )

    # 5. DEFAULT USERS (Wajib ada agar tidak error role)
    data_ops.append("\n-- DEFAULT USERS --\n")
    users_sql = """
INSERT INTO public.users (username, password_hash, full_name, role, created_at, company_access) VALUES
('supermanager1', 'scrypt:32768:8:1$E6xU7nF8wW5R$f8c2e6f9d7c4a1b0e9d8c7b6a5f4e3d2c1b0a9f8e7d6c5b4a3f2e1d0c9b8a7f6', 'Super Manager 1', 'super_manager', NOW(), '["EWI Foundation", "Expans Wireless Indo"]'),
('manager1', 'scrypt:32768:8:1$YOJgsQEpXbyAyKL5$4a3e62180014b254470b7aee8be202ee6b681f66f17609762294900f3123f8e5b41b1b3ddeffe5bbb69f3bf5f66e986ac12e48235151a89c670500dc029a27fc', 'Manager 1', 'super_manager', NOW(), '["EWI Foundation", "Expans Wireless Indo"]'),
('manager2', 'scrypt:32768:8:1$VDB7BPZIyGeupeA2$1a11f790020cae495a8971cac8ab55babddfd11541f214840e82e0a0f1e01ca99af5d2fdd65e2768dd9f78442b216a7dec8d31814c09ffb1527e555669754b51', 'Manager 2', 'manager', NOW(), '["EWI Foundation"]'),
('staff1', 'scrypt:32768:8:1$Z2wS8xM0lK4J$k2l3m4n5o6p7q8r9s0t1u2v3w4x5y6z7a8b9c0d1e2f3g4h5i6j7k8l9m0n1o2', 'Staff 1', 'staff', NOW(), '["EWI Foundation"]'),
('mitra1', 'scrypt:32768:8:1$A3qP9zO1bV5N$z3a4b5c6d7e8f9g0h1i2j3k4l5m6n7o8p9q0r1s2t3u4v5w6x7y8z9a0b1c2d3e', 'Mitra 1', 'mitra', NOW(), '["EWI Foundation"]')
ON CONFLICT (username) DO UPDATE SET
    password_hash = EXCLUDED.password_hash,
    role = EXCLUDED.role,
    full_name = EXCLUDED.full_name,
    company_access = EXCLUDED.company_access;
SELECT pg_catalog.setval('public.users_id_seq', (SELECT COALESCE(MAX(id), 1) FROM public.users), true);
"""
    data_ops.append(users_sql)

    if is_append:
        data_ops = ["\n-- NEXT YEAR DATA BLOCK --\n"]
    else:
        alembic_sql = "DELETE FROM public.alembic_version; INSERT INTO public.alembic_version (version_num) VALUES ('72e16ee21ce9');\n"
        data_ops.extend(
            [
                "\n" + alembic_sql,
            ]
        )

    main_data_ops = []  # Buffer for actual data to track years first

    counts = {
        "revenues": 0,
        "taxes": 0,
        "expenses": 0,
        "settlements": 0,
        "settlements_s": 0,
        "settlements_b": 0,
        "bank": 0,
    }
    single_items_count, batch_items_count, found_sheet2_items, found_dividend_names = (
        0,
        0,
        [],
        [],
    )

    # REVENUES
    last_inv_d, last_recv_d = None, None
    if ws_f and ws_v and r1_start != -1:
        print("Extracting REVENUE & TAX (Dynamic Columns)...")
        # Smart Column Mapping (seperti checkdb)
        col_inv_d = find_column_index(ws_v, "Invoice Date", r1_start)
        if col_inv_d == -1:
            col_inv_d = 2

        col_desc = find_column_index(ws_v, "Detail/Description", r1_start)
        if col_desc == -1:
            col_desc = 4

        col_val_usd = find_column_index(ws_v, "INVOICE VALUE USD", r1_start)
        col_val_idr = find_column_index(ws_v, "INVOICE VALUE IDR", r1_start)

        col_val = find_column_index(ws_v, "INVOICE VALUE", r1_start)
        if col_val == -1:
            col_val = 5

        col_exch = find_column_index(ws_v, "Currency Exchange", r1_start)
        if col_exch == -1:
            col_exch = 7

        col_recv_d = find_column_index(ws_v, "Receive Date", r1_start)
        if col_recv_d == -1:
            col_recv_d = 11

        col_recv_val_idr = find_column_index(ws_v, "AMOUNT RECEIVED IDR", r1_start)
        col_recv_val_usd = find_column_index(ws_v, "AMOUNT RECEIVED USD", r1_start)

        col_recv_val = find_column_index(ws_v, "AMOUNT RECEIVED", r1_start)
        if col_recv_val == -1:
            col_recv_val = 12

        col_ppn = find_column_index(ws_v, "PPn", r1_start)
        if col_ppn == -1:
            col_ppn = 13

        col_pph23 = find_column_index(ws_v, "PPH (Pasal 23)", r1_start)
        if col_pph23 == -1:
            col_pph23 = 14

        col_fee = find_column_index(ws_v, "Biaya transfer", r1_start)
        if col_fee == -1:
            col_fee = 15

        col_remark = find_column_index(ws_v, "Remark", r1_start)
        if col_remark == -1:
            col_remark = 16

        col_inv_n = find_column_index(ws_v, "Invoice No", r1_start)
        if col_inv_n == -1:
            col_inv_d = find_column_index(ws_v, "Invoice Date", r1_start)
        if col_inv_d == -1:
            col_inv_d = 1

        col_desc = find_column_index(ws_v, "Detail/Description", r1_start)
        if col_desc == -1:
            col_desc = 4

        col_val_usd = find_column_index(ws_v, "INVOICE VALUE USD", r1_start)
        col_val_idr = find_column_index(ws_v, "INVOICE VALUE IDR", r1_start)

        # Better col_val: find exact or preferred fallback
        col_val = find_column_index(ws_v, "INVOICE VALUE", r1_start)
        if col_val == -1 or col_val == col_val_usd or col_val == col_val_idr:
            # If col_val is just picking up one of the split columns, try to find a generic one
            # or default to col_val_idr if exists, else col_val_usd
            col_val = (
                col_val_idr
                if col_val_idr != -1
                else (col_val_usd if col_val_usd != -1 else 5)
            )

        col_exch = find_column_index(ws_v, "Currency Exchange", r1_start)
        if col_exch == -1:
            col_exch = find_column_index(ws_v, "Exchange", r1_start)
        if col_exch == -1:
            col_exch = 8

        col_recv_d = find_column_index(ws_v, "Receive Date", r1_start)
        if col_recv_d == -1:
            col_recv_d = 11

        col_recv_val_idr = find_column_index(ws_v, "AMOUNT RECEIVED IDR", r1_start)
        col_recv_val_usd = find_column_index(ws_v, "AMOUNT RECEIVED USD", r1_start)
        col_recv_val = find_column_index(ws_v, "AMOUNT RECEIVED", r1_start)
        if (
            col_recv_val == -1
            or col_recv_val == col_recv_val_idr
            or col_recv_val == col_recv_val_usd
        ):
            col_recv_val = (
                col_recv_val_idr
                if col_recv_val_idr != -1
                else (col_recv_val_usd if col_recv_val_usd != -1 else 12)
            )

        col_ppn = find_column_index(ws_v, "PPn", r1_start)
        if col_ppn == -1:
            col_ppn = 14

        col_pph23 = find_column_index(ws_v, "PPH (Pasal 23)", r1_start)
        if col_pph23 == -1:
            col_pph23 = 15

        col_fee = find_column_index(ws_v, "Biaya transfer", r1_start)
        if col_fee == -1:
            col_fee = 16

        col_remark = find_column_index(ws_v, "Remark", r1_start)
        if col_remark == -1:
            col_remark = 17

        col_inv_n = find_column_index(ws_v, "Invoice No", r1_start)
        if col_inv_n == -1:
            col_inv_n = 9

        col_client = find_column_index(ws_v, "Client", r1_start)
        if col_client == -1:
            col_client = 10

        # Smart Bank Column Mapping (Bank / Sumber Dana / Rekening / Bank Cash)
        col_bank = find_column_index(ws_v, "Bank", r1_start)
        if col_bank == -1:
            col_bank = find_column_index(ws_v, "Sumber Dana", r1_start)
        if col_bank == -1:
            col_bank = find_column_index(ws_v, "Rekening", r1_start)
        if col_bank == -1:
            col_bank = find_column_index(ws_v, "Bank Cash", r1_start)
        if col_bank == -1:
            col_bank = find_column_index(ws_v, "Metode Pembayaran", r1_start)
        if col_bank == -1:
            col_bank = find_column_index(ws_v, "Payment Method", r1_start)

        # Buffer to collect revenue items and detect merges
        revenue_items = []
        for r in range(r1_start + 1, r1_end):
            raw_dv = get_cell_effective_value(ws_v, r, col_inv_d)
            desc = get_cell_effective_value(ws_f, r, col_desc)
            inv_no = str(get_cell_effective_value(ws_v, r, col_inv_n) or "").strip()
            client_name = str(
                get_cell_effective_value(ws_v, r, col_client) or ""
            ).strip()

            # Fallback to extract invoice number and client from description if they are empty
            if not inv_no and desc:
                # E.g. "Revenue ... INV 056" -> "INV 056"
                m_inv = re.search(r"(INV[\s_-]*\d+)", str(desc), re.IGNORECASE)
                if m_inv:
                    inv_no = m_inv.group(1).replace("_", " ").replace("-", " ")
            if not client_name and desc:
                # E.g. "... Nesitor_ONWJ ..." -> "Nesitor"
                # Or "... Elnusa_PHR ..." -> "Elnusa"
                # Just some common client names hardcoded fallback
                desc_upper = str(desc).upper()
                for c_name in [
                    "ELNUSA",
                    "NESITOR",
                    "SIJAK",
                    "TGE",
                    "PGE",
                    "MEDCO",
                    "SCHLUMBERGER",
                    "ENECAL",
                    "PPT SMN",
                    "BARIKIN SAKTI",
                    "HUATONG",
                ]:
                    if c_name in desc_upper:
                        client_name = c_name
                        break

            val = to_num_cell(ws_f, ws_v, r, col_val)
            val_usd = (
                to_num_cell(ws_f, ws_v, r, col_val_usd) if col_val_usd != -1 else None
            )
            val_idr = (
                to_num_cell(ws_f, ws_v, r, col_val_idr) if col_val_idr != -1 else None
            )

            # Detect Currency from cell or neighboring cell
            cur_raw = ws_f.cell(r, col_exch - 1).value if col_exch > 1 else None
            cur = (
                str(cur_raw).strip().upper()
                if cur_raw and str(cur_raw).strip()
                else "IDR"
            )
            if len(cur) > 5 or cur == "-":
                cur = "IDR"
            rat_val = to_num_cell(ws_f, ws_v, r, col_exch, 1.0)
            rat = to_sql_val(rat_val if rat_val > 0 else 1.0)

            if str(raw_dv).strip().upper() == "INVOICE DATE":
                continue

            # Update stateful dates
            if isinstance(raw_dv, (dt.date, dt.datetime)):
                last_inv_d = raw_dv

            recv_date_raw = get_cell_effective_value(ws_v, r, col_recv_d)
            if isinstance(recv_date_raw, (dt.date, dt.datetime)):
                last_recv_d = recv_date_raw

            # Filter out footers and noise but BE LENIENT
            if (
                (not desc and not inv_no and not client_name)
                or "TOTAL" in str(desc or "").upper()
                or "SUBTOTAL" in str(desc or "").upper()
            ):
                continue

            amt_recv = to_num_cell(ws_f, ws_v, r, col_recv_val)
            amt_recv_idr = (
                to_num_cell(ws_f, ws_v, r, col_recv_val_idr)
                if col_recv_val_idr != -1
                else None
            )
            amt_recv_usd = (
                to_num_cell(ws_f, ws_v, r, col_recv_val_usd)
                if col_recv_val_usd != -1
                else None
            )

            # Detect Bank Account for Bank Cash Sync (Kolom Sumber Dana)
            bank_raw = (
                get_cell_effective_value(ws_v, r, col_bank)
                if col_bank != -1
                else None
            )
            bank_name = None
            if (
                bank_raw
                and str(bank_raw).strip()
                and str(bank_raw).strip().lower() not in ["none", "-", "nan", "null"]
            ):
                b_val = str(bank_raw).strip()
                b_upper = b_val.upper()
                # Prioritaskan varian compound bank yang spesifik lebih dahulu
                if "MANDIRI VALAS" in b_upper:
                    bank_name = "Mandiri Valas"
                elif "MANDIRI BISNIS" in b_upper:
                    bank_name = "Mandiri Bisnis"
                elif "MANDIRI GIRO" in b_upper:
                    bank_name = "Mandiri Giro"
                elif "MANDIRI TABBIS" in b_upper:
                    bank_name = "Mandiri TabBis"
                elif "BCA VALAS" in b_upper:
                    bank_name = "BCA Valas"
                elif "BCA BISNIS" in b_upper:
                    bank_name = "BCA Bisnis"
                elif "BCA GIRO" in b_upper:
                    bank_name = "BCA Giro"
                elif "BRI VALAS" in b_upper:
                    bank_name = "BRI Valas"
                elif "BRI BISNIS" in b_upper:
                    bank_name = "BRI Bisnis"
                elif "BRI GIRO" in b_upper:
                    bank_name = "BRI Giro"
                elif "BNI VALAS" in b_upper:
                    bank_name = "BNI Valas"
                elif "BNI BISNIS" in b_upper:
                    bank_name = "BNI Bisnis"
                elif "BNI GIRO" in b_upper:
                    bank_name = "BNI Giro"
                # Generic fallback hanya jika tidak ada suffix khusus
                elif b_upper == "MANDIRI" or "BANK MANDIRI" in b_upper:
                    bank_name = "Mandiri"
                elif b_upper == "BCA" or "BANK BCA" in b_upper:
                    bank_name = "BCA"
                elif b_upper == "BRI" or "BANK BRI" in b_upper:
                    bank_name = "BRI"
                elif b_upper == "BNI" or "BANK BNI" in b_upper:
                    bank_name = "BNI"
                elif "CASH" in b_upper or "KAS" in b_upper:
                    bank_name = "Cash"
                else:
                    bank_name = b_val

            # CATATAN: Jika kolom Sumber Dana kosong atau "-", jangan tebak dari keterangan!
            # Biarkan bank_name = None agar bank_id bernilai NULL dan tidak mempengaruhi saldo bank lain.

            # Robust Calculation of Totals (Dual Currency USD & IDR)
            if cur == "USD":
                if val_usd is not None and val_usd > 0:
                    val = val_usd
                elif val > 0 and (val_usd is None or val_usd <= 0):
                    val_usd = val

                if (val_idr is None or val_idr <= 0) and val_usd is not None and val_usd > 0:
                    val_idr = round(val_usd * (rat_val if rat_val > 0 else 1.0), 2)

                if amt_recv_usd is not None and amt_recv_usd > 0:
                    amt_recv = amt_recv_usd
                elif amt_recv > 0 and (amt_recv_usd is None or amt_recv_usd <= 0):
                    amt_recv_usd = amt_recv

                if (amt_recv_idr is None or amt_recv_idr <= 0) and amt_recv_usd is not None and amt_recv_usd > 0:
                    amt_recv_idr = round(amt_recv_usd * (rat_val if rat_val > 0 else 1.0), 2)
            else:
                if val_idr is not None and val_idr > 0:
                    val = val_idr
                elif val > 0 and (val_idr is None or val_idr <= 0):
                    val_idr = val

                if amt_recv_idr is not None and amt_recv_idr > 0:
                    amt_recv = amt_recv_idr
                elif amt_recv > 0 and (amt_recv_idr is None or amt_recv_idr <= 0):
                    amt_recv_idr = amt_recv

                if rat_val > 1.0:
                    if (val_usd is None or val_usd <= 0) and val > 0:
                        val_usd = round(val / rat_val, 2)
                    if (amt_recv_usd is None or amt_recv_usd <= 0) and amt_recv > 0:
                        amt_recv_usd = round(amt_recv / rat_val, 2)

            # Fallback agar invoice_value/amount_received tidak 0 jika data ada di kolom split USD/IDR
            if val <= 0:
                if val_idr is not None and val_idr > 0:
                    val = val_idr
                elif val_usd is not None and val_usd > 0:
                    val = val_usd

            if amt_recv <= 0:
                if amt_recv_idr is not None and amt_recv_idr > 0:
                    amt_recv = amt_recv_idr
                elif amt_recv_usd is not None and amt_recv_usd > 0:
                    amt_recv = amt_recv_usd

            # FINAL ROW DECISION: If we have an invoice number or a description with ANY value or even 0 (for pending)
            if (desc or inv_no) and (
                val > 0
                or (val_usd is not None and val_usd > 0)
                or (val_idr is not None and val_idr > 0)
                or amt_recv > 0
                or inv_no
                != ""  # Keep it if there's an invoice number even if value is 0
            ):
                rt = (
                    "pendapatan_lain_lain"
                    if "bunga bank" in str(desc).lower()
                    else "pendapatan_langsung"
                )
                # FORCE REPORT YEAR based on menu setting if available
                year = (
                    target_year
                    if target_year
                    else (last_inv_d.year if last_inv_d else default_year)
                )
                years_found.add(year)

                # Detect Merge Range for Grouping (Check Amount Received and Receive Date too, because sometimes multiple invoices are paid in one lump sum)
                m_range = (
                    get_merge_range(ws_v, r, col_recv_val)
                    or get_merge_range(ws_v, r, col_recv_d)
                    or get_merge_range(ws_v, r, col_inv_n)
                    or get_merge_range(ws_v, r, col_desc)
                )

                revenue_items.append(
                    {
                        "row": r,
                        "merge_key": m_range,
                        "invoice_date": last_inv_d,
                        "description": desc,
                        "invoice_value": val,
                        "invoice_value_usd": val_usd,
                        "invoice_value_idr": val_idr,
                        "currency": cur,
                        "currency_exchange": rat,
                        "invoice_number": inv_no,
                        "client": client_name,
                        "receive_date": last_recv_d,
                        "amount_received": amt_recv,
                        "amount_received_idr": amt_recv_idr,
                        "amount_received_usd": amt_recv_usd,
                        "ppn": to_num_cell(ws_f, ws_v, r, col_ppn),
                        "pph_23": to_num_cell(ws_f, ws_v, r, col_pph23),
                        "transfer_fee": to_num_cell(ws_f, ws_v, r, col_fee),
                        "remark": ws_f.cell(r, col_remark).value,
                        "revenue_type": rt,
                        "report_year": year,
                        "bank_name": bank_name,
                    }
                )

        # Process and Group Revenue Items
        processed_merges = set()
        for i, item in enumerate(revenue_items):
            m_key = item["merge_key"]

            if m_key and m_key not in processed_merges:
                # Find all items in this merge range
                group = [it for it in revenue_items if it["merge_key"] == m_key]
                if len(group) > 1:
                    processed_merges.add(m_key)
                    # Generate SQL with multiple inserts and a manual_combine_groups record
                    var_names = []
                    orig_data = {}
                    merged_cols = set()

                    # Detect which columns are merged (Strictly based on Excel Merge Ranges)
                    cols_to_check = [
                        ("invoice_date", col_inv_d),
                        ("invoice_number", col_inv_n),
                        ("client", col_client),
                        ("receive_date", col_recv_d),
                        ("currency", col_exch - 1),
                        ("currency_exchange", col_exch),
                        ("description", col_desc),
                        ("invoice_value", col_val),
                        ("invoice_value_idr", col_val_idr),
                        ("invoice_value_usd", col_val_usd),
                        ("ppn", col_ppn),
                        ("pph_23", col_pph23),
                        ("amount_received", col_recv_val),
                        ("amount_received_idr", col_recv_val_idr),
                        ("amount_received_usd", col_recv_val_usd),
                        ("transfer_fee", col_fee),
                        ("remark", col_remark),
                        ("bank_id", col_bank),
                    ]

                    group_rows = [it["row"] for it in group]
                    min_g, max_g = min(group_rows), max(group_rows)

                    for col_key, col_idx in cols_to_check:
                        if col_idx == -1:
                            continue

                        # Check if Excel has a merge range for this specific column that covers our group
                        m_range = get_merge_range(ws_v, group[0]["row"], col_idx)
                        if m_range and m_range[0] <= min_g and m_range[1] >= max_g:
                            merged_cols.add(col_key)

                    for idx, g_item in enumerate(group):
                        counts["revenues"] += 1

                        # For rows > 1 in a group, we must still provide values for NOT NULL columns
                        # to avoid database errors, but the metadata will tell UI to merge them.
                        def get_val(key, actual_val):
                            if idx > 0 and key in merged_cols:
                                # NOT NULL columns in DB schema must have values
                                if key in [
                                    "invoice_date",
                                    "description",
                                    "revenue_type",
                                ]:
                                    return to_sql_val(actual_val)
                                if key in [
                                    "invoice_value",
                                    "ppn",
                                    "pph_23",
                                    "amount_received",
                                    "amount_received_idr",
                                    "amount_received_usd",
                                    "transfer_fee",
                                ]:
                                    return "0"
                                return "NULL"
                            return to_sql_val(actual_val)

                        b_name = g_item.get("bank_name")
                        if idx > 0 and "bank_id" in merged_cols:
                            bank_sql_val = "NULL"
                        elif b_name:
                            bank_sql_val = f"(SELECT id FROM public.bank_accounts WHERE LOWER(TRIM(name)) = LOWER({to_sql_val(b_name)}) AND (company = {to_sql_val(target_company)} OR company IS NULL OR company = 'EWI Foundation') ORDER BY (company = {to_sql_val(target_company)}) DESC, id ASC LIMIT 1)"
                        else:
                            bank_sql_val = "NULL"

                        sql = f"INSERT INTO public.revenues (company, invoice_date, description, invoice_value, invoice_value_usd, invoice_value_idr, currency, currency_exchange, invoice_number, client, receive_date, amount_received, amount_received_idr, amount_received_usd, ppn, pph_23, transfer_fee, remark, revenue_type, created_at, report_year, bank_id, user_id) VALUES ({to_sql_val(target_company)}, {get_val('invoice_date', g_item['invoice_date'])}, {get_val('description', g_item['description'])}, {get_val('invoice_value', g_item['invoice_value'])}, {get_val('invoice_value_usd', g_item['invoice_value_usd'])}, {get_val('invoice_value_idr', g_item['invoice_value_idr'])}, {get_val('currency', g_item['currency'])}, {get_val('currency_exchange', g_item['currency_exchange'])}, {get_val('invoice_number', g_item['invoice_number'])}, {get_val('client', g_item['client'])}, {get_val('receive_date', g_item['receive_date'])}, {get_val('amount_received', g_item['amount_received'])}, {get_val('amount_received_idr', g_item['amount_received_idr'])}, {get_val('amount_received_usd', g_item['amount_received_usd'])}, {get_val('ppn', g_item['ppn'])}, {get_val('pph_23', g_item['pph_23'])}, {get_val('transfer_fee', g_item['transfer_fee'])}, {get_val('remark', g_item['remark'])}, '{g_item['revenue_type']}', NOW(), {g_item['report_year']}, {bank_sql_val}, v_admin_id) RETURNING id INTO v_id_temp;\n"
                        main_data_ops.append(sql)
                        main_data_ops.append(
                            "  INSERT INTO _tmp_ids VALUES (v_id_temp);\n"
                        )

                        # Sinkronisasi Bank Cash Income untuk item revenue jika ada bank
                        if b_name and (idx == 0 or (g_item.get("amount_received") and g_item["amount_received"] > 0) or (g_item.get("invoice_value") and g_item["invoice_value"] > 0)):
                            tx_amt_idr = g_item.get("amount_received_idr") if (g_item.get("amount_received_idr") and g_item["amount_received_idr"] > 0) else (g_item.get("invoice_value_idr") or g_item.get("invoice_value") or 0.0)
                            tx_amt_usd = g_item.get("amount_received_usd") if (g_item.get("amount_received_usd") and g_item["amount_received_usd"] > 0) else (g_item.get("invoice_value_usd") or 0.0)
                            if tx_amt_idr > 0 or tx_amt_usd > 0:
                                tx_date = g_item.get("receive_date") or g_item.get("invoice_date")
                                main_data_ops.append(
                                    f"  INSERT INTO public.bank_transactions (company, bank_id, date, description, amount_usd, amount_idr, transaction_type, group_name, report_year, revenue_id, user_id, created_at) "
                                    f"VALUES ({to_sql_val(target_company)}, {bank_sql_val}, {to_sql_val(tx_date)}, {to_sql_val('Penerimaan Revenue: ' + str(g_item['description'])[:250])}, {tx_amt_usd}, {tx_amt_idr}, 'income', 'Revenue', {g_item['report_year']}, v_id_temp, v_admin_id, NOW());\n"
                                )
                                counts["bank"] += 1

                        # Prepare original data for JSON
                        orig_data[idx + 1] = {
                            k: str(v) if isinstance(v, (dt.date, dt.datetime)) else v
                            for k, v in g_item.items()
                            if k not in ["row", "merge_key"]
                        }

                    # Insert into manual_combine_groups using subquery for IDs
                    ids_subquery = "(SELECT json_agg(id) FROM _tmp_ids)"
                    main_data_ops.append(
                        f"INSERT INTO public.manual_combine_groups (table_name, report_year, group_date, row_ids_json, merged_columns_json, original_data_json, created_at) VALUES ('revenues', {group[0]['report_year']}, {to_sql_val(group[0]['invoice_date'])}, {ids_subquery}::text, {to_sql_val(json.dumps(list(merged_cols)))}, {to_sql_val(json.dumps(orig_data))}, NOW());\n"
                    )
                    main_data_ops.append("  TRUNCATE _tmp_ids;\n")
                    continue

            if not m_key or m_key not in processed_merges:
                counts["revenues"] += 1
                b_name = item.get("bank_name")
                bank_sql_val = (
                    f"(SELECT id FROM public.bank_accounts WHERE LOWER(TRIM(name)) = LOWER({to_sql_val(b_name)}) AND (company = {to_sql_val(target_company)} OR company IS NULL OR company = 'EWI Foundation') ORDER BY (company = {to_sql_val(target_company)}) DESC, id ASC LIMIT 1)"
                    if b_name
                    else "NULL"
                )
                main_data_ops.append(
                    f"INSERT INTO public.revenues (company, invoice_date, description, invoice_value, invoice_value_usd, invoice_value_idr, currency, currency_exchange, invoice_number, client, receive_date, amount_received, amount_received_idr, amount_received_usd, ppn, pph_23, transfer_fee, remark, revenue_type, created_at, report_year, bank_id, user_id) VALUES ({to_sql_val(target_company)}, {to_sql_val(item['invoice_date'])}, {to_sql_val(item['description'])}, {item['invoice_value']}, {to_sql_val(item['invoice_value_usd'])}, {to_sql_val(item['invoice_value_idr'])}, {to_sql_val(item['currency'])}, {item['currency_exchange']}, {to_sql_val(item['invoice_number'])}, {to_sql_val(item['client'])}, {to_sql_val(item['receive_date'])}, {item['amount_received']}, {to_sql_val(item['amount_received_idr'])}, {to_sql_val(item['amount_received_usd'])}, {item['ppn']}, {item['pph_23']}, {item['transfer_fee']}, {to_sql_val(item['remark'])}, '{item['revenue_type']}', NOW(), {item['report_year']}, {bank_sql_val}, v_admin_id) RETURNING id INTO v_id_temp;\n"
                )
                if b_name:
                    tx_amt_idr = item.get("amount_received_idr") if (item.get("amount_received_idr") and item["amount_received_idr"] > 0) else (item.get("invoice_value_idr") or item.get("invoice_value") or 0.0)
                    tx_amt_usd = item.get("amount_received_usd") if (item.get("amount_received_usd") and item["amount_received_usd"] > 0) else (item.get("invoice_value_usd") or 0.0)
                    if tx_amt_idr > 0 or tx_amt_usd > 0:
                        tx_date = item.get("receive_date") or item.get("invoice_date")
                        main_data_ops.append(
                            f"  INSERT INTO public.bank_transactions (company, bank_id, date, description, amount_usd, amount_idr, transaction_type, group_name, report_year, revenue_id, user_id, created_at) "
                            f"VALUES ({to_sql_val(target_company)}, {bank_sql_val}, {to_sql_val(tx_date)}, {to_sql_val('Penerimaan Revenue: ' + str(item['description'])[:250])}, {tx_amt_usd}, {tx_amt_idr}, 'income', 'Revenue', {item['report_year']}, v_id_temp, v_admin_id, NOW());\n"
                        )
                        counts["bank"] += 1

    # BANK Status (NEW & Stateful)
    if ws_f and ws_v and rb_start != -1:
        print("Extracting BANK Status (Dynamic Columns)...")
        curr_group = "Unknown Group"

        # Detect Bank Columns
        col_bank_date = find_column_index(ws_v, "Date", rb_start)
        if col_bank_date == -1:
            col_bank_date = 2
        col_bank_desc = find_column_index(ws_v, "Detail/Description", rb_start)
        if col_bank_desc == -1:
            col_bank_desc = 4

        bank_col_usd = find_column_index(ws_v, "USD", rb_start)
        bank_col_idr = find_column_index(ws_v, "IDR", rb_start)
        if bank_col_idr == -1:
            bank_col_idr = find_column_index(ws_v, "VALUE", rb_start)
        if bank_col_idr == -1 and bank_col_usd == -1:
            bank_col_idr = 5  # Default fallback

        actual_rb_end = rb_end if rb_end != -1 else min(ws_v.max_row, rb_start + 500)
        if r1_start > rb_start:
            actual_rb_end = min(actual_rb_end, r1_start)
        if r2_start > rb_start:
            actual_rb_end = min(actual_rb_end, r2_start)
        if r3_start > rb_start:
            actual_rb_end = min(actual_rb_end, r3_start)

        # Blacklist keywords for group detection (don't treat header as group)
        BANK_HEADER_BLACKLIST = [
            "DATE",
            "#",
            "DETAIL/DESCRIPTION",
            "VALUE",
            "IDR",
            "USD",
            "TOTAL",
            "BALANCE",
            "PENGELUARAN",
            "PAJAK",
            "REVENUE",
            "ACTIVITY",
            "ACTIVTY",
            "INVOICE DATE",
        ]

        # Buffering Bank Transactions to sort them by priority
        bank_transactions_buffer = []

        for r in range(rb_start + 1, actual_rb_end):
            v_date = ws_v.cell(r, col_bank_date).value
            v_desc_raw = str(ws_f.cell(r, col_bank_desc).value or "").strip()
            v_label_raw = str(
                ws_v.cell(r, col_bank_date).value or ""
            ).strip()  # Use same col as date for label
            v_usd = (
                to_num_cell(ws_f, ws_v, r, bank_col_usd) if bank_col_usd != -1 else 0
            )
            v_idr = (
                to_num_cell(ws_f, ws_v, r, bank_col_idr) if bank_col_idr != -1 else 0
            )

            # AGGRESSIVE STOP CONDITION: If we see section keywords in the label or description
            row_text_full = " ".join(
                [str(ws_v.cell(r, c).value or "") for c in range(1, 10)]
            ).upper()
            if (
                any(
                    kw in row_text_full
                    for kw in [
                        "PENGELUARAN",
                        "PAJAK PENGELUARAN",
                        "REVENUE & TAX",
                        "ACTIVITY",
                    ]
                )
                and r > rb_start + 5
            ):  # Only stop if we are reasonably far into the section
                break

            # 1. Detect Group Header (Using improved logic)
            val_b_str = v_label_raw.upper()
            val_d_str = v_desc_raw.upper()
            cell_b = ws_f.cell(r, col_bank_date)
            cell_d = ws_f.cell(r, col_bank_desc)

            if is_bank_header_row(val_b_str, cell_b, val_d_str, cell_d):
                # Use description as group name if date col is empty, else use label
                curr_group = (
                    v_desc_raw if v_desc_raw and not v_label_raw else v_label_raw
                )
                if not curr_group:
                    curr_group = "Bank Section"
                print(f"   [Bank Header] New Group: {curr_group} at Row {r}")
                continue

            # 2. Legacy Group Header Detection (Fallback)
            if (
                v_label_raw
                and not isinstance(v_date, (dt.date, dt.datetime))
                and v_usd == 0
                and v_idr == 0
                and v_label_raw.upper() not in BANK_HEADER_BLACKLIST
            ):
                curr_group = v_label_raw
                continue

            # BREAK CONDITION: If we hit a new section header (Arial 20 Bold)
            if _is_anchor_cell(ws_f.cell(r, 1)) or _is_anchor_cell(ws_f.cell(r, 2)):
                row_text = " ".join(
                    [str(ws_v.cell(r, c).value or "") for c in range(1, 5)]
                ).upper()
                if any(
                    kw in row_text
                    for kw in ["PAJAK", "PENGELUARAN", "ACTIVITY", "REVENUE"]
                ):
                    break

            # Fallback description
            v_desc = v_desc_raw or f"Mutasi {curr_group}"

            # Additional filter for noise
            if (
                v_desc.upper() in BANK_HEADER_BLACKLIST
                or v_label_raw.upper() in BANK_HEADER_BLACKLIST
            ):
                continue

            # Process Transaction
            # User request: capture rows with 0 amounts if they have valid date & description
            if isinstance(v_date, (dt.date, dt.datetime)) and (
                v_usd != 0 or v_idr != 0 or v_desc_raw
            ):
                counts["bank"] += 1

                # Logic: Determine transaction type & bank_id
                t_type = "expense"  # default
                if "BUNGA" in v_desc.upper() or "INTEREST" in v_desc.upper():
                    t_type = "income"
                elif "PEMINDAHBUKUAN" in v_desc.upper() or "TRANSFER" in v_desc.upper():
                    t_type = "transfer"

                # Dynamic Bank ID Mapping
                b_match = re.search(r"\((.*?)\)", curr_group)
                b_name_raw = b_match.group(1) if b_match else curr_group
                b_name_final = (
                    b_name_raw.replace(":", "").replace("EWI", "").strip() or "Cash"
                )
                b_sql = f"(SELECT id FROM public.bank_accounts WHERE name ILIKE '%{b_name_final}%' AND account_type = 'status' LIMIT 1)"

                # For Transfer, try to find target bank
                to_b_sql = "NULL"
                if t_type == "transfer":
                    m_to = re.search(r"KE\s+([A-Z\s]+)", v_desc.upper())
                    if m_to:
                        to_b_name = (
                            m_to.group(1).replace("EWI", "").replace("REK", "").strip()
                        )
                        to_b_sql = f"(SELECT id FROM public.bank_accounts WHERE name ILIKE '%{to_b_name}%' AND account_type = 'status' LIMIT 1)"

                # FORCE REPORT YEAR based on menu setting if available
                year = (
                    target_year
                    if target_year
                    else (v_date.year if v_date else default_year)
                )
                years_found.add(year)

                # --- SORTING PRIORITY LOGIC ---
                # 1. Type Priority (Transfer & Admin first)
                type_priority = 99
                v_desc_up = v_desc.upper()
                if "TRANSFER" in v_desc_up or "PEMINDAHBUKUAN" in v_desc_up:
                    type_priority = 1
                elif "ADMIN" in v_desc_up or "FEE" in v_desc_up:
                    type_priority = 2

                # 2. Bank Priority (BRI -> BNI -> Mandiri -> BCA -> EWI)
                bank_priority = 99
                curr_group_up = curr_group.upper()
                if "BRI" in curr_group_up:
                    bank_priority = 1
                elif "BNI" in curr_group_up:
                    bank_priority = 2
                elif "MANDIRI" in curr_group_up:
                    bank_priority = 3
                elif "BCA" in curr_group_up:
                    bank_priority = 4
                elif "EWI" in curr_group_up:
                    bank_priority = 5

                # --- NEW MULTI-LINE LOG FORMAT ---
                # Description format is now simple as requested.
                v_desc_log = v_desc

                bank_transactions_buffer.append(
                    {
                        "type_prio": 4,
                        "date": v_date,
                        "bank_prio": bank_priority,
                        "sql": f"INSERT INTO public.bank_status_transactions (company, bank_id, to_bank_id, date, description, amount_usd, amount_idr, transaction_type, group_name, report_year, created_at) "
                        f"VALUES ({to_sql_val(target_company)}, COALESCE({b_sql}, (SELECT id FROM public.bank_accounts WHERE account_type='status' LIMIT 1)), {to_b_sql}, {to_sql_val(v_date)}, {to_sql_val(v_desc_log)}, {v_usd}, {v_idr}, '{t_type}', {to_sql_val(curr_group)}, {year}, NOW());\n",
                    }
                )

        # Sort buffer: Type Priority -> Bank Priority -> Date
        bank_transactions_buffer.sort(
            key=lambda x: (x["type_prio"], x["bank_prio"], x["date"])
        )
        for tx in bank_transactions_buffer:
            main_data_ops.append(tx["sql"])

    # TAXES
    if ws_f and ws_v and r2_start != -1:
        print("Extracting PAJAK PENGELUARAN (Dynamic Columns)...")
        col_tax_d = find_column_index(ws_v, "Date", r2_start)
        if col_tax_d == -1:
            col_tax_d = 2
        col_tax_desc = find_column_index(ws_v, "Detail/Description", r2_start)
        if col_tax_desc == -1:
            col_tax_desc = 4
        col_tax_val = find_column_index(ws_v, "Transaction Value", r2_start)
        if col_tax_val == -1:
            col_tax_val = 5
        col_tax_exch = find_column_index(ws_v, "Currency Exchange", r2_start)
        if col_tax_exch == -1:
            col_tax_exch = 7

        col_ppn = find_column_index(ws_v, "PPN", r2_start)
        if col_ppn == -1:
            col_ppn = 9
        col_pph21 = find_column_index(ws_v, "PPh - 21", r2_start)
        if col_pph21 == -1:
            col_pph21 = 11
        col_pph23 = find_column_index(ws_v, "PPh - 23", r2_start)
        if col_pph23 == -1:
            col_pph23 = 13
        col_pph26 = find_column_index(ws_v, "PPh - 26", r2_start)
        if col_pph26 == -1:
            col_pph26 = 15

        # Cari baris header yang sebenarnya untuk kolom Trans Value & Desc
        header_r_tax = r2_start
        for r_h in range(r2_start, r2_start + 5):
            row_txt = " ".join(
                [str(ws_v.cell(r_h, c).value or "") for c in range(1, 10)]
            ).upper()
            if "TRANS" in row_txt or "VALUE" in row_txt or "DETAIL" in row_txt:
                header_r_tax = r_h
                break

        col_tax_val = find_column_index(ws_v, "Transaction Value", header_r_tax)
        if col_tax_val == -1:
            col_tax_val = 5
        col_tax_desc = find_column_index(ws_v, "Detail/Description", header_r_tax)
        if col_tax_desc == -1:
            col_tax_desc = 4

        col_inv_val_usd = find_column_index(ws_v, "INVOICE VALUE USD", header_r_tax)
        col_trans_val_idr = find_column_index(
            ws_v, "Transaction Value IDR", header_r_tax
        )

        # Dynamic detection for Pemasukan Negara (Table columns 17-18 usually)
        # Search for "PEMASUKAN" first
        col_pem_header = find_column_index(ws_v, "PEMASUKAN NEGARA", r2_start)
        col_pem_neg_b = -1
        col_pem_neg_v = -1

        if col_pem_header != -1:
            # Pemasukan Negara usually has 2 columns: Transaction (base) and Pajak (value)
            # We check the row below the header for sub-labels
            for c_off in [0, 1]:
                curr_col = col_pem_header + c_off
                sub_label = (
                    str(ws_v.cell(header_r_tax + 1, curr_col).value or "")
                    .upper()
                    .strip()
                )
                if "TRANS" in sub_label:
                    col_pem_neg_b = curr_col
                elif "PAJAK" in sub_label or "PPN" in sub_label or not sub_label:
                    # If it's the second column of Pemasukan Negara, it's the value
                    if col_pem_neg_v == -1:
                        col_pem_neg_v = curr_col

        # Fallback to hardcoded defaults if still not found (Common in EWI templates)
        if col_pem_neg_b == -1:
            col_pem_neg_b = 17
        if col_pem_neg_v == -1:
            col_pem_neg_v = 18

        # Buffer to collect tax items and detect merges
        tax_items = []
        # Expand scan range slightly to ensure we don't miss rows near the footer
        scan_end = r2_end + 5 if r2_end != -1 else ws_v.max_row + 1

        for r in range(r2_start + 1, scan_end):
            dv = get_cell_effective_value(ws_v, r, col_tax_d)
            desc = get_cell_effective_value(ws_f, r, col_tax_desc)

            # Robust check for "-" or empty cells as 0
            val = to_num_cell(ws_f, ws_v, r, col_tax_val)
            val_usd = (
                to_num_cell(ws_f, ws_v, r, col_inv_val_usd)
                if col_inv_val_usd != -1
                else None
            )
            val_idr = (
                to_num_cell(ws_f, ws_v, r, col_trans_val_idr)
                if col_trans_val_idr != -1
                else 0.0
            )

            cur_raw = ws_f.cell(r, col_tax_exch - 1).value if col_tax_exch > 1 else None
            cur = (
                str(cur_raw).strip().upper()
                if cur_raw and str(cur_raw).strip()
                else "IDR"
            )
            if len(cur) > 5 or cur == "-":
                cur = "IDR"
            rat_val = to_num_cell(ws_f, ws_v, r, col_tax_exch, 1.0)
            rat = to_sql_val(rat_val if rat_val > 0 else 1.0)

            p_b, p_v, p21_b, p21_v, p23_b, p23_v, p26_b, p26_v = [
                to_num_cell(ws_f, ws_v, r, col_ppn - 1),
                to_num_cell(ws_f, ws_v, r, col_ppn),
                to_num_cell(ws_f, ws_v, r, col_pph21 - 1),
                to_num_cell(ws_f, ws_v, r, col_pph21),
                to_num_cell(ws_f, ws_v, r, col_pph23 - 1),
                to_num_cell(ws_f, ws_v, r, col_pph23),
                to_num_cell(ws_f, ws_v, r, col_pph26 - 1),
                to_num_cell(ws_f, ws_v, r, col_pph26),
            ]

            # Pemasukan Negara (New Columns)
            pem_neg_b = (
                to_num_cell(ws_f, ws_v, r, col_pem_neg_b)
                if col_pem_neg_b != -1
                else 0.0
            )
            pem_neg_v = (
                to_num_cell(ws_f, ws_v, r, col_pem_neg_v)
                if col_pem_neg_v != -1
                else 0.0
            )

            # Filter out footers and noise
            desc_str = str(desc or "").strip().upper()
            if not desc or desc_str in ["TOTAL", "SUBTOTAL", "-", ""]:
                continue

            # Check if row has any values
            has_tax_val = (
                val != 0
                or (val_usd is not None and val_usd != 0)
                or (val_idr is not None and val_idr != 0)
                or p_b != 0
                or p21_b != 0
                or p23_b != 0
                or p26_b != 0
                or p_v != 0
                or p21_v != 0
                or p23_v != 0
                or p26_v != 0
                or pem_neg_v != 0
                or pem_neg_b != 0
            )

            if has_tax_val:
                # Use current row date if valid, otherwise fallback to last valid or default
                tx_date = (
                    dv
                    if isinstance(dv, (dt.date, dt.datetime))
                    else (last_recv_d or dt.datetime(default_year, 1, 1))
                )
                # User Request: Force year to target_year
                if target_year:
                    try:
                        tx_date = tx_date.replace(year=target_year)
                    except ValueError:  # handle Feb 29
                        tx_date = tx_date.replace(year=target_year, day=28)

                year = (
                    target_year
                    if target_year
                    else (tx_date.year if tx_date else default_year)
                )
                years_found.add(year)

                # Synthetic created_at for consistency
                seq_d_tax = get_seq_date(global_seq_idx)
                # Note: Not incrementing global_seq_idx here to keep it for settlements
                # but using it for created_at
                tax_ts = f"{seq_d_tax.isoformat()} 08:00:00"

                # Detect Merge Range for Grouping (Use Date or Desc)
                m_range = get_merge_range(ws_v, r, col_tax_d) or get_merge_range(
                    ws_v, r, col_tax_desc
                )

                tax_items.append(
                    {
                        "row": r,
                        "merge_key": m_range,
                        "date": tx_date,
                        "description": desc,
                        "transaction_value": val,
                        "invoice_value_usd": val_usd,
                        "transaction_value_idr": val_idr,
                        "currency": cur,
                        "currency_exchange": rat,
                        "ppn": p_v,
                        "ppn_base": p_b,
                        "pph_21": p21_v,
                        "pph_21_base": p21_b,
                        "pph_23": p23_v,
                        "pph_23_base": p23_b,
                        "pph_26": p26_v,
                        "pph_26_base": p26_b,
                        "pemasukan_negara": pem_neg_v,
                        "pemasukan_negara_base": pem_neg_b,
                        "report_year": year,
                        "created_at": tax_ts,
                    }
                )

        # Process and Group Tax Items
        processed_tax_merges = set()
        for i, item in enumerate(tax_items):
            m_key = item["merge_key"]

            if m_key and m_key not in processed_tax_merges:
                group = [it for it in tax_items if it["merge_key"] == m_key]
                if len(group) > 1:
                    processed_tax_merges.add(m_key)
                    var_names = []
                    orig_data = {}
                    merged_cols = set()

                    cols_to_check = [
                        ("date", col_tax_d),
                        ("currency", col_tax_exch - 1),
                        ("currency_exchange", col_tax_exch),
                        ("description", col_tax_desc),
                        ("transaction_value", col_tax_val),
                        ("transaction_value_idr", col_trans_val_idr),
                        ("invoice_value_usd", col_inv_val_usd),
                        ("ppn", col_ppn),
                        ("ppn_base", col_ppn - 1),
                        ("pph_21", col_pph21),
                        ("pph_21_base", col_pph21 - 1),
                        ("pph_23", col_pph23),
                        ("pph_23_base", col_pph23 - 1),
                        ("pph_26", col_pph26),
                        ("pph_26_base", col_pph26 - 1),
                        ("pemasukan_negara", col_pem_neg_v),
                        ("pemasukan_negara_base", col_pem_neg_b),
                    ]

                    group_rows = [it["row"] for it in group]
                    min_g, max_g = min(group_rows), max(group_rows)

                    for col_key, col_idx in cols_to_check:
                        if col_idx == -1:
                            continue
                        m_range = get_merge_range(ws_v, group[0]["row"], col_idx)
                        if m_range and m_range[0] <= min_g and m_range[1] >= max_g:
                            merged_cols.add(col_key)

                    for idx, g_item in enumerate(group):
                        counts["taxes"] += 1

                        def get_val(key, actual_val):
                            if idx > 0 and key in merged_cols:
                                if key in ["date", "description"]:
                                    return to_sql_val(actual_val)
                                if key in [
                                    "transaction_value",
                                    "transaction_value_idr",
                                    "invoice_value_usd",
                                    "ppn",
                                    "ppn_base",
                                    "pph_21",
                                    "pph_21_base",
                                    "pph_23",
                                    "pph_23_base",
                                    "pph_26",
                                    "pph_26_base",
                                    "pemasukan_negara",
                                    "pemasukan_negara_base",
                                ]:
                                    return "0"
                                return "NULL"
                            return to_sql_val(actual_val)

                        sql = f"INSERT INTO public.taxes (company, date, description, transaction_value, invoice_value_usd, transaction_value_idr, currency, currency_exchange, ppn, ppn_base, pph_21, pph_21_base, pph_23, pph_23_base, pph_26, pph_26_base, pemasukan_negara, pemasukan_negara_base, created_at, report_year) VALUES ({to_sql_val(target_company)}, {get_val('date', g_item['date'])}, {get_val('description', g_item['description'])}, {get_val('transaction_value', g_item['transaction_value'])}, {get_val('invoice_value_usd', g_item['invoice_value_usd'])}, {get_val('transaction_value_idr', g_item['transaction_value_idr'])}, {get_val('currency', g_item['currency'])}, {get_val('currency_exchange', g_item['currency_exchange'])}, {get_val('ppn', g_item['ppn'])}, {get_val('ppn_base', g_item['ppn_base'])}, {get_val('pph_21', g_item['pph_21'])}, {get_val('pph_21_base', g_item['pph_21_base'])}, {get_val('pph_23', g_item['pph_23'])}, {get_val('pph_23_base', g_item['pph_23_base'])}, {get_val('pph_26', g_item['pph_26'])}, {get_val('pph_26_base', g_item['pph_26_base'])}, {get_val('pemasukan_negara', g_item['pemasukan_negara'])}, {get_val('pemasukan_negara_base', g_item['pemasukan_negara_base'])}, '{g_item['created_at']}', {g_item['report_year']}) RETURNING id INTO v_id_temp;\n"
                        main_data_ops.append(sql)
                        main_data_ops.append(
                            "  INSERT INTO _tmp_ids VALUES (v_id_temp);\n"
                        )

                        orig_data[idx + 1] = {
                            k: str(v) if isinstance(v, (dt.date, dt.datetime)) else v
                            for k, v in g_item.items()
                            if k not in ["row", "merge_key"]
                        }

                    ids_subquery = "(SELECT json_agg(id) FROM _tmp_ids)"
                    main_data_ops.append(
                        f"INSERT INTO public.manual_combine_groups (table_name, report_year, group_date, row_ids_json, merged_columns_json, original_data_json, created_at) VALUES ('taxes', {group[0]['report_year']}, {to_sql_val(group[0]['date'])}, {ids_subquery}::text, {to_sql_val(json.dumps(list(merged_cols)))}, {to_sql_val(json.dumps(orig_data))}, '{group[0]['created_at']}');\n"
                    )
                    main_data_ops.append("  TRUNCATE _tmp_ids;\n")
                    continue

            if not m_key or m_key not in processed_tax_merges:
                counts["taxes"] += 1
                main_data_ops.append(
                    f"INSERT INTO public.taxes (company, date, description, transaction_value, invoice_value_usd, transaction_value_idr, currency, currency_exchange, ppn, ppn_base, pph_21, pph_21_base, pph_23, pph_23_base, pph_26, pph_26_base, pemasukan_negara, pemasukan_negara_base, created_at, report_year) VALUES ({to_sql_val(target_company)}, {to_sql_val(item['date'])}, {to_sql_val(item['description'])}, {item['transaction_value']}, {to_sql_val(item['invoice_value_usd'])}, {to_sql_val(item['transaction_value_idr'])}, {to_sql_val(item['currency'])}, {item['currency_exchange']}, {item['ppn']}, {item['ppn_base']}, {item['pph_21']}, {item['pph_21_base']}, {item['pph_23']}, {item['pph_23_base']}, {item['pph_26']}, {item['pph_26_base']}, {item['pemasukan_negara']}, {item['pemasukan_negara_base']}, '{item['created_at']}', {item['report_year']});\n"
                )

    if ws_f and ws_v and r3_start != -1:
        batch_seq_idx = 0  # counter untuk batch settlements

        current_sid = None
        pending_settlement_sql = None
        pending_settlement_meta = {}
        current_seq_ts = f"{default_year}-01-01 08:00:00"

        # mode: "single" atau "batch"
        mode = "single"
        curr_subject = None   # Nama batch aktif (dari Subject :)
        curr_detail = None    # Deskripsi detail aktif (dari Detail :)

        # Detect Currency and Rate columns dynamically
        col_curr = find_column_index(ws_v, "CURR", r3_start)
        if col_curr == -1:
            col_curr = 7  # Fallback kolom G
        col_rate = find_column_index(ws_v, "RATE", r3_start)
        if col_rate == -1:
            col_rate = find_column_index(ws_v, "EXCHANGE", r3_start)
        if col_rate == -1:
            col_rate = 8  # Fallback kolom H

        actual_end = ws_v.max_row + 1
        last_valid_date = dt.datetime(default_year, 1, 1)

        # State aktif
        curr_bank_src = "-"
        curr_subcat_id = 12  # Default: Lain-lain
        curr_subcat_ids = []

        print(f"Debug loop: r3_start={r3_start}, actual_end={actual_end}")
        for r in range(r3_start + 1, actual_end):
            val_b = get_cell_effective_value(ws_f, r, 2)  # Date atau keyword marker
            val_c = get_cell_effective_value(ws_f, r, 3)  # # atau ":"
            val_d = get_cell_effective_value(ws_f, r, 4)  # Deskripsi / nilai marker
            val_e = get_cell_effective_value(ws_f, r, 5)  # Jumlah USD
            val_f = get_cell_effective_value(ws_f, r, 6)  # Jumlah IDR
            val_g = ws_f.cell(r, col_curr).value          # Currency
            val_h = ws_f.cell(r, col_rate).value          # Exchange rate

            cell_b = ws_f.cell(r, 2)
            cell_c = ws_f.cell(r, 3)
            cell_d = ws_f.cell(r, 4)

            # Update last_valid_date jika baris memiliki tanggal
            if isinstance(val_b, (dt.date, dt.datetime)):
                last_valid_date = val_b

            val_b_str = str(val_b or "").strip()
            val_b_low = val_b_str.lower()
            val_c_str = str(val_c or "").strip()
            val_d_str = str(val_d or "").strip()

            # ─────────────────────────────────────────────────────────────
            # 0. SKIP: baris header tabel (Date, #, Activity, dll.)
            # ─────────────────────────────────────────────────────────────
            if val_b_str.upper() in ("DATE",) or val_c_str.upper() in ("#",):
                continue
            if val_d_str.upper() in ("ACTIVITY", "DESCRIPTION", "DETAIL/DESCRIPTION"):
                continue

            # ─────────────────────────────────────────────────────────────
            # 1. SKIP: semua kolom kosong
            # ─────────────────────────────────────────────────────────────
            all_empty = not any([
                val_b_str, val_c_str, val_d_str,
                val_e and str(val_e).strip(),
                val_f and str(val_f).strip(),
                val_g and str(val_g).strip(),
            ])
            if all_empty:
                continue

            # ─────────────────────────────────────────────────────────────
            # 2. DETEKSI MARKER (Single / Batch / Subject / Detail)
            # ─────────────────────────────────────────────────────────────
            if _is_marker_row(val_b, val_c):
                marker = val_b_low  # "single" / "batch" / "subject" / "detail"
                marker_val = val_d_str

                if marker == "single":
                    mode = "single"
                    curr_subject = None
                    curr_detail = None
                    current_sid = None
                    pending_settlement_sql = None
                    print(f"   [Mode] SINGLE at row {r}")

                elif marker == "batch":
                    mode = "batch"
                    curr_subject = None
                    curr_detail = None
                    current_sid = None
                    pending_settlement_sql = None
                    print(f"   [Mode] BATCH at row {r}")

                elif marker == "subject":
                    # Subject baru → settlement baru
                    curr_subject = marker_val
                    curr_detail = None
                    current_sid = None

                    if mode == "batch":
                        ttl = curr_subject[:200]
                        year = (
                            target_year
                            if target_year
                            else (last_valid_date.year if last_valid_date else default_year)
                        )
                        years_found.add(year)
                        seq_d = get_seq_date(batch_seq_idx)
                        batch_seq_idx += 1
                        seq_ts = f"{seq_d.isoformat()} 08:00:00"
                        pending_settlement_meta = {
                            "ttl": ttl,
                            "r": r,
                            "year": year,
                            "seq_d": seq_d,
                            "seq_ts": seq_ts,
                        }
                        pending_settlement_sql = "PENDING"
                        print(f"   [Subject] {ttl} (Row {r})")

                elif marker == "detail":
                    curr_detail = marker_val
                    print(f"   [Detail] {marker_val} (Row {r})")

                continue

            # ─────────────────────────────────────────────────────────────
            # 3. DETEKSI BANK SOURCE ("Transfer from BCA / BRI / ...")
            # ─────────────────────────────────────────────────────────────
            if is_bank_header_row(val_b_str.upper(), cell_b, val_d_str.upper(), cell_d):
                sc_text = val_b_str or val_d_str
                new_src = map_bank_source(sc_text)
                if new_src != curr_bank_src:
                    curr_bank_src = new_src
                    print(f"   [Bank] Source: {curr_bank_src} (Row {r})")
                continue

            # ─────────────────────────────────────────────────────────────
            # 4. DETEKSI SUBKATEGORI: hanya COL-D terisi, lainnya kosong
            # ─────────────────────────────────────────────────────────────
            if _is_subkategori_row(val_b, val_c, val_d, val_e, val_f, val_g):
                sc_text = val_d_str
                sh_res = detect_subheader(sc_text, cell_d)
                if sh_res:
                    curr_subcat_id = sh_res[0]
                    curr_subcat_ids = sh_res
                else:
                    tmp_id = detect_cat(sc_text)
                    if tmp_id:
                        curr_subcat_id = tmp_id
                        curr_subcat_ids = [tmp_id]
                print(f"   [Sub-Cat] {sc_text} → ID {curr_subcat_id} (Row {r})")
                continue

            # ─────────────────────────────────────────────────────────────
            # 5. DETEKSI ITEM PENGELUARAN
            # COL-B = date, COL-C = nomor, COL-G = currency
            # ─────────────────────────────────────────────────────────────
            has_date = isinstance(val_b, (dt.date, dt.datetime))
            _cur_upper = str(val_g or "").strip().upper()
            has_currency = _cur_upper in ("IDR", "USD", "RP", "MYR", "")

            # Item valid jika ada tanggal + currency, ATAU ada angka di salah satu kolom kategori
            cid = None
            col_amt = 0
            found_in_col = False

            # Cek angka di kolom-kolom kategori yang sudah di-map (9-21)
            for col, c_id in EXP_CAT_MAP.items():
                v_tmp = to_num_cell(ws_f, ws_v, r, col)
                if v_tmp != 0:
                    cid = c_id
                    col_amt = v_tmp
                    found_in_col = True
                    break

            # Fallback: cek kolom F (IDR) dan E (USD)
            if not found_in_col:
                for fallback_col in [6, 5]:
                    v_tmp = to_num_cell(ws_f, ws_v, r, fallback_col)
                    if v_tmp != 0:
                        cid = detect_cat(val_d_str) or curr_subcat_id or 12
                        col_amt = v_tmp
                        found_in_col = True
                        break

            # Fallback lanjut: EXP_CAT_MAP kolom lain
            if not found_in_col:
                for col in EXP_CAT_MAP.keys():
                    if col in (col_curr, col_rate):
                        continue
                    v_tmp = to_num_cell(ws_f, ws_v, r, col)
                    if v_tmp != 0:
                        cid = EXP_CAT_MAP[col]
                        col_amt = v_tmp
                        found_in_col = True
                        break

            # Force detection jika ada tanggal + currency meskipun nominal 0
            if not found_in_col and has_date and has_currency:
                cid = detect_cat(val_d_str) or curr_subcat_id or 12
                col_amt = 0
                found_in_col = True

            # Jika tidak ada data yang bisa diambil, skip
            if not found_in_col:
                continue

            # Skip footer / noise
            desc_check = val_d_str.upper()
            if desc_check in ("TOTAL", "SUBTOTAL", "-", ""):
                continue

            # ─────────────────────────────────────────────────────────────
            # 5b. Ambil metadata item
            # ─────────────────────────────────────────────────────────────
            cur_raw = val_g
            cur = str(cur_raw).strip().upper() if cur_raw and str(cur_raw).strip() else "IDR"
            if len(cur) > 10 or "=" in cur or cur == "-":
                cur = "IDR"
            # Normalize alias: "Rp" → "IDR"
            if cur in ("RP", ""):
                cur = "IDR"

            rat_val = to_num_cell(ws_f, ws_v, r, col_rate, 1.0)
            calc_rat = rat_val if rat_val and rat_val > 0 else 1.0
            if cur in ("IDR", "-", ""):
                calc_rat = 1.0
            rat = to_sql_val(calc_rat)

            # Deskripsi: kolom D (atau C jika D adalah angka)
            desc = str(val_c if is_numeric_value(val_d) else (val_d or "-")).strip()

            # Tanggal
            dv = val_b if isinstance(val_b, (dt.date, dt.datetime)) else last_valid_date
            if target_year and isinstance(dv, (dt.date, dt.datetime)):
                try:
                    dv = dv.replace(year=target_year)
                except ValueError:
                    dv = dv.replace(year=target_year, day=28)

            year = target_year if target_year else (dv.year if dv else default_year)
            years_found.add(year)

            if cur not in ("IDR", "-", "") and calc_rat > 1:
                t_st = round(col_amt / calc_rat, 4)
            else:
                t_st = col_amt

            item_status = "completed" if t_st != 0 else "draft"
            item_is_appr = "true" if t_st != 0 else "false"

            # ─────────────────────────────────────────────────────────────
            # 6. INSERSI BATCH ITEM
            # ─────────────────────────────────────────────────────────────
            if mode == "batch":
                # Flush pending settlement jika belum di-insert
                if current_sid != "sid" and pending_settlement_sql:
                    if pending_settlement_sql == "PENDING":
                        meta = pending_settlement_meta
                        set_ev_path, set_ev_fn = match_evidence_fuzzy(
                            meta["ttl"], None, "settlements", old_evidence_data, last_valid_date
                        )
                        real_sql = (
                            f"  INSERT INTO public.settlements "
                            f"(company, title, description, user_id, settlement_type, status, "
                            f"current_stage, report_year, document_date, created_at, updated_at, "
                            f"completed_at, disbursement_source, return_source, "
                            f"is_disbursement_approved, is_return_approved, "
                            f"disbursement_evidence_path, disbursement_evidence_filename, bank_id) "
                            f"VALUES ({to_sql_val(target_company)}, {to_sql_val(meta['ttl'])}, "
                            f"'Excel Row {meta['r']}', v_admin_id, 'batch', 'completed', "
                            f"'completed', {meta['year']}, {to_sql_val(meta['seq_d'])}, "
                            f"'{meta['seq_ts']}', '{meta['seq_ts']}', '{meta['seq_ts']}', "
                            f"{to_sql_val(curr_bank_src)}, '-', true, true, "
                            f"{to_sql_val(set_ev_path)}, {to_sql_val(set_ev_fn)}, "
                            f"(SELECT id FROM public.bank_accounts WHERE name = "
                            f"{to_sql_val(curr_bank_src)} LIMIT 1)) "
                            f"RETURNING id INTO current_set_id;\n"
                        )
                        real_sql += "  SELECT SUM(amount * currency_exchange) INTO st_total FROM public.expenses WHERE settlement_id = current_set_id;\n"
                        real_sql += "  UPDATE public.settlements SET disbursed_amount = COALESCE(st_total, 0) WHERE id = current_set_id;\n"
                        main_data_ops.append(real_sql)
                        current_seq_ts = meta["seq_ts"]
                    else:
                        main_data_ops.append(pending_settlement_sql)
                        seq_d_tmp = get_seq_date(batch_seq_idx - 1)
                        current_seq_ts = f"{seq_d_tmp.isoformat()} 08:00:00"

                    pending_settlement_sql = None
                    current_sid = "sid"
                    counts["settlements"] += 1
                    counts["settlements_b"] += 1

                # Jika belum ada settlement aktif, buat default
                if current_sid != "sid":
                    ttl = curr_subject[:200] if curr_subject else "Batch Group"
                    seq_d = get_seq_date(batch_seq_idx)
                    batch_seq_idx += 1
                    current_seq_ts = f"{seq_d.isoformat()} 08:00:00"
                    set_ev_path, set_ev_fn = match_evidence_fuzzy(
                        ttl, None, "settlements", old_evidence_data, dv
                    )
                    main_data_ops.append(
                        f"  INSERT INTO public.settlements "
                        f"(company, title, description, user_id, settlement_type, status, "
                        f"current_stage, report_year, document_date, created_at, updated_at, "
                        f"completed_at, disbursement_source, return_source, "
                        f"is_disbursement_approved, is_return_approved, "
                        f"disbursement_evidence_path, disbursement_evidence_filename, bank_id) "
                        f"VALUES ({to_sql_val(target_company)}, {to_sql_val(ttl)}, "
                        f"'Auto Row {r}', v_admin_id, 'batch', 'completed', 'completed', "
                        f"{year}, {to_sql_val(seq_d)}, '{current_seq_ts}', "
                        f"'{current_seq_ts}', '{current_seq_ts}', "
                        f"{to_sql_val(curr_bank_src)}, '-', true, true, "
                        f"{to_sql_val(set_ev_path)}, {to_sql_val(set_ev_fn)}, "
                        f"(SELECT id FROM public.bank_accounts WHERE name = "
                        f"{to_sql_val(curr_bank_src)} LIMIT 1)) "
                        f"RETURNING id INTO current_set_id;\n"
                    )
                    current_sid = "sid"
                    counts["settlements"] += 1
                    counts["settlements_b"] += 1

                if current_sid == "sid":
                    batch_items_count += 1
                    counts["expenses"] += 1

                    main_cid = cid
                    item_subcat_ids = []
                    if cid and cid >= 100:
                        main_cid = CAT_PARENT_MAP.get(cid) or cid
                        item_subcat_ids.append(cid)

                    for sub_id in curr_subcat_ids:
                        if CAT_PARENT_MAP.get(sub_id) == main_cid:
                            if sub_id not in item_subcat_ids:
                                item_subcat_ids.append(sub_id)

                    if not item_subcat_ids:
                        dash_id = DASH_SUBCAT_MAP.get(main_cid, 912)
                        item_subcat_ids = [dash_id]

                    ev_path, ev_fn = match_evidence_fuzzy(
                        desc, t_st, "expenses", old_evidence_data, dv
                    )

                    main_data_ops.append(
                        f"  INSERT INTO public.expenses "
                        f"(company, settlement_id, category_id, description, amount, date, "
                        f"source, currency, currency_exchange, status, evidence_path, "
                        f"evidence_filename, created_at) "
                        f"VALUES ({to_sql_val(target_company)}, current_set_id, {main_cid}, "
                        f"{to_sql_val(desc)}, {t_st}, {to_sql_val(dv)}, "
                        f"{to_sql_val(curr_bank_src)}, {to_sql_val(cur)}, {rat}, "
                        f"'{item_status}', {to_sql_val(ev_path)}, {to_sql_val(ev_fn)}, "
                        f"'{current_seq_ts}') RETURNING id INTO v_exp_id;\n"
                    )
                    main_data_ops.append(
                        "  SELECT SUM(amount * currency_exchange) INTO st_total FROM public.expenses WHERE settlement_id = current_set_id;\n"
                    )
                    main_data_ops.append(
                        "  UPDATE public.settlements SET disbursed_amount = COALESCE(st_total, 0) WHERE id = current_set_id;\n"
                    )
                    if item_status == "draft":
                        main_data_ops.append(
                            "  UPDATE public.settlements SET status = 'draft', current_stage = 'draft', is_disbursement_approved = false, is_return_approved = false WHERE id = current_set_id;\n"
                        )
                    for sub_id in item_subcat_ids:
                        main_data_ops.append(
                            f"  INSERT INTO public.expense_subcategories (expense_id, category_id) VALUES (v_exp_id, {sub_id}) ON CONFLICT DO NOTHING;\n"
                        )

            # ─────────────────────────────────────────────────────────────
            # 7. INSERSI SINGLE ITEM
            # ─────────────────────────────────────────────────────────────
            else:  # mode == "single"
                single_items_count += 1
                counts["expenses"] += 1
                counts["settlements"] += 1
                years_found.add(year)

                doc_date_single = dv
                if isinstance(doc_date_single, (dt.date, dt.datetime)):
                    date_str = doc_date_single.strftime("%Y-%m-%d")
                    ts_single = f"{date_str} 08:00:00"
                    doc_date_sql = f"'{date_str}'"
                else:
                    ts_single = f"{default_year}-01-01 08:00:00"
                    doc_date_sql = f"'{default_year}-01-01'"

                main_cid = cid
                item_subcat_ids = []
                if cid and cid >= 100:
                    main_cid = CAT_PARENT_MAP.get(cid) or cid
                    item_subcat_ids.append(cid)

                for sub_id in curr_subcat_ids:
                    if CAT_PARENT_MAP.get(sub_id) == main_cid:
                        if sub_id not in item_subcat_ids:
                            item_subcat_ids.append(sub_id)

                if not item_subcat_ids:
                    dash_id = DASH_SUBCAT_MAP.get(main_cid, 912)
                    item_subcat_ids = [dash_id]

                set_ev_path, set_ev_fn = match_evidence_fuzzy(
                    desc[:200], t_st, "settlements", old_evidence_data, dv
                )
                ev_path, ev_fn = match_evidence_fuzzy(
                    desc, t_st, "expenses", old_evidence_data, dv
                )

                item_stage = "completed" if item_status == "completed" else "draft"
                sql_single = (
                    f"  INSERT INTO public.settlements "
                    f"(company, title, description, user_id, settlement_type, status, "
                    f"current_stage, report_year, document_date, created_at, updated_at, "
                    f"completed_at, disbursement_source, return_source, "
                    f"is_disbursement_approved, is_return_approved, "
                    f"disbursement_evidence_path, disbursement_evidence_filename, bank_id)\n"
                    f"    VALUES ({to_sql_val(target_company)}, {to_sql_val(desc[:200])}, "
                    f"'Excel Row {r}', v_admin_id, 'single', '{item_status}', '{item_stage}', "
                    f"{year}, {doc_date_sql}, '{ts_single}', '{ts_single}', '{ts_single}', "
                    f"{to_sql_val(curr_bank_src)}, '-', {item_is_appr}, {item_is_appr}, "
                    f"{to_sql_val(set_ev_path)}, {to_sql_val(set_ev_fn)}, "
                    f"(SELECT id FROM public.bank_accounts WHERE name = "
                    f"{to_sql_val(curr_bank_src)} LIMIT 1)) RETURNING id INTO current_set_id;\n"
                    f"  INSERT INTO public.expenses "
                    f"(company, settlement_id, category_id, description, amount, date, source, "
                    f"currency, currency_exchange, status, evidence_path, evidence_filename, created_at)\n"
                    f"    VALUES ({to_sql_val(target_company)}, current_set_id, {main_cid}, "
                    f"{to_sql_val(desc)}, {t_st}, {doc_date_sql}, "
                    f"{to_sql_val(curr_bank_src)}, {to_sql_val(cur)}, {rat}, '{item_status}', "
                    f"{to_sql_val(ev_path)}, {to_sql_val(ev_fn)}, '{ts_single}') "
                    f"RETURNING id INTO v_exp_id;\n"
                    f"  UPDATE public.settlements SET disbursed_amount = ({t_st} * {rat}) WHERE id = current_set_id;\n"
                )
                for sub_id in item_subcat_ids:
                    sql_single += f"  INSERT INTO public.expense_subcategories (expense_id, category_id) VALUES (v_exp_id, {sub_id}) ON CONFLICT DO NOTHING;\n"

                main_data_ops.append(sql_single)
                counts["settlements_s"] += 1

        # Close last block if still open
        if current_sid == "sid":
            current_sid = None

    # SHEET 2: LABA RUGI & NERACA
    ws2_f = wb_f[name_ner] if name_ner else None
    ws2_v = wb_v[name_ner] if name_ner else None
    if ws2_f:
        print("Extracting Laba Rugi & Neraca (Sheet 2)...")
        targets = [
            "PENDAPATAN LAINNYA",
            "CORPORATE TAX (PPh 29)",
            "KAS DAN SETARA KAS TAHUN SEBELUMNYA",
            "KAS DAN SETARA KAS TAHUN LAPORAN",
            "PIUTANG USAHA",
            "PAJAK BAYAR DI MUKA (pph23)",
            "BIAYA BAYAR DI MUKA",
            "PIUTANG LAIN LAIN",
            "INVENTARIS KANTOR",
            "HUTANG USAHA",
            "HUTANG GAJI",
            "HUTANG PEMEGANG SAHAM",
            "BIAYA YANG MASIH HARUS DI BAYAR",
            "MODAL SAHAM",
            "LABA DI TAHAN",
        ]
        items = {k: 0.0 for k in targets}
        for target in targets:
            found = False
            for r in range(1, 401):
                for c in range(1, 21):
                    val = str(ws2_f.cell(r, c).value or "").upper()
                    if target.upper() in val:
                        for offset in range(1, 10):
                            v = ws2_v.cell(r, c + offset).value
                            if is_numeric_value(v):
                                items[target] = to_num_cell(ws2_f, ws2_v, r, c + offset)
                                found = True
                                break
                        if not found:  # Try openpyxl logic fallback
                            for offset in range(1, 10):
                                v_raw = ws2_f.cell(r, c + offset).value
                                if v_raw is not None and is_numeric_value(v_raw):
                                    items[target] = to_num_cell(
                                        ws2_f, ws2_v, r, c + offset
                                    )
                                    found = True
                                    break
                    if found:
                        break
                if found:
                    break
            if found:
                found_sheet2_items.append(target)

        # Use the master year detected or first year found as fallback
        ner_year = default_year
        if years_found:
            ner_year = min(years_found)
        # FORCE REPORT YEAR based on menu setting if available
        final_ner_year = target_year if target_year else ner_year

        # ✅ Process if no filter OR if it matches target (though we forced it now)
        if True:
            seq_d_ner = get_seq_date(global_seq_idx)
            ner_ts = f"{seq_d_ner.isoformat()} 08:00:00"
            st = "INSERT INTO public.dividend_settings (company, year, profit_retained, opening_cash_balance, accounts_receivable, prepaid_tax_pph23, prepaid_expenses, other_receivables, office_inventory, other_assets, accounts_payable, salary_payable, shareholder_payable, accrued_expenses, share_capital, retained_earnings_balance, corporate_tax_pph29, other_income, created_at) VALUES ("
            st += f"{to_sql_val(target_company)}, {final_ner_year}, 0, {items['KAS DAN SETARA KAS TAHUN SEBELUMNYA']}, {items['PIUTANG USAHA']}, {items['PAJAK BAYAR DI MUKA (pph23)']}, {items['BIAYA BAYAR DI MUKA']}, {items['PIUTANG LAIN LAIN']}, {items['INVENTARIS KANTOR']}, 0, {items['HUTANG USAHA']}, {items['HUTANG GAJI']}, {items['HUTANG PEMEGANG SAHAM']}, {items['BIAYA YANG MASIH HARUS DI BAYAR']}, {items['MODAL SAHAM']}, {items['LABA DI TAHAN']}, {items['CORPORATE TAX (PPh 29)']}, {items['PENDAPATAN LAINNYA']}, '{ner_ts}');\n"
            main_data_ops.append(st)

    # SHEET 3: DEVIDEN
    ws3_f = wb_f[name_div] if name_div else None
    ws3_v = wb_v[name_div] if name_div else None
    if ws3_f:
        print("Extracting Dividends (Sheet 3)...")
        start_r = -1
        # Cari header "DEVIDEN" yang berdiri sendiri di Col 2 (baris 18)
        for r in range(1, 100):
            val_col2 = str(ws3_f.cell(r, 2).value or "").upper().strip()
            if val_col2 == "DEVIDEN":
                start_r = r
                break

        if start_r != -1:
            # Ambil data dari baris setelah header (Baris 19-20 dst)
            for r in range(start_r + 1, start_r + 11):
                name_val = ws3_f.cell(r, 3).value  # Nama di Col 3 (C)
                amount_val = to_num_cell(ws3_f, ws3_v, r, 5)  # Amount di Col 5 (E)

                if name_val and isinstance(name_val, str) and len(name_val) > 2:
                    clean_n = name_val.strip()
                    # Filter out noise labels
                    if clean_n.upper() not in [
                        "RP",
                        "PAJAK 10%",
                        "DEVIDEN",
                        "IDR",
                        "TOTAL",
                        "AMOUNT",
                        "NAMA LENGKAP",
                    ]:
                        found_dividend_names.append(clean_n)
                        # Use the master year or first year found as fallback
                        div_year = default_year
                        if years_found:
                            div_year = min(years_found)
                        # FORCE REPORT YEAR based on menu setting if available
                        final_div_year = target_year if target_year else div_year

                        if True:
                            seq_d_div = get_seq_date(global_seq_idx)
                            div_ts = f"{seq_d_div.isoformat()} 08:00:00"
                            main_data_ops.append(
                                f"INSERT INTO public.dividends (company, date, name, amount, recipient_count, tax_percentage, report_year, created_at) VALUES ({to_sql_val(target_company)}, '{final_div_year}-12-31', {to_sql_val(clean_n)}, {amount_val}, 1, 10.0, {final_div_year}, '{div_ts}');\n"
                            )

    # BANK SCHEMA
    bank_schema_ddl = """
-- SCHEMA MIGRATION: Bank Accounts & Transactions
CREATE TABLE IF NOT EXISTS public.bank_accounts (id SERIAL PRIMARY KEY, company VARCHAR(100) NOT NULL DEFAULT 'EWI Foundation', name VARCHAR(100) NOT NULL, account_number VARCHAR(50), currency VARCHAR(10) DEFAULT 'IDR', account_type VARCHAR(20) DEFAULT 'management', user_id INTEGER REFERENCES public.users(id), initial_balance DOUBLE PRECISION DEFAULT 0.0, created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW());
CREATE TABLE IF NOT EXISTS public.bank_transactions (id SERIAL PRIMARY KEY, company VARCHAR(100) NOT NULL DEFAULT 'EWI Foundation', bank_id INTEGER REFERENCES public.bank_accounts(id), to_bank_id INTEGER REFERENCES public.bank_accounts(id), date DATE NOT NULL, description VARCHAR(300) NOT NULL, amount_usd DOUBLE PRECISION DEFAULT 0.0, amount_idr DOUBLE PRECISION DEFAULT 0.0, transaction_type VARCHAR(50), group_name VARCHAR(100), report_year INTEGER, revenue_id INTEGER, user_id INTEGER REFERENCES public.users(id), created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW());
CREATE TABLE IF NOT EXISTS public.bank_status_transactions (id SERIAL PRIMARY KEY, company VARCHAR(100) NOT NULL DEFAULT 'EWI Foundation', bank_id INTEGER REFERENCES public.bank_accounts(id), to_bank_id INTEGER REFERENCES public.bank_accounts(id), date DATE NOT NULL, description VARCHAR(300) NOT NULL, amount_usd DOUBLE PRECISION DEFAULT 0.0, amount_idr DOUBLE PRECISION DEFAULT 0.0, transaction_type VARCHAR(50), group_name VARCHAR(100), report_year INTEGER, user_id INTEGER REFERENCES public.users(id), created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW());
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS to_bank_id INTEGER REFERENCES public.bank_accounts(id);
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS group_name VARCHAR(100);
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS report_year INTEGER;
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS amount_usd DOUBLE PRECISION DEFAULT 0.0;
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS amount_idr DOUBLE PRECISION DEFAULT 0.0;
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS revenue_id INTEGER REFERENCES public.revenues(id) ON DELETE SET NULL;
ALTER TABLE public.bank_transactions ADD COLUMN IF NOT EXISTS user_id INTEGER REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.revenues ADD COLUMN IF NOT EXISTS bank_id INTEGER REFERENCES public.bank_accounts(id);
ALTER TABLE public.revenues ADD COLUMN IF NOT EXISTS user_id INTEGER REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS to_bank_id INTEGER REFERENCES public.bank_accounts(id);
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS group_name VARCHAR(100);
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS report_year INTEGER;
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS amount_usd DOUBLE PRECISION DEFAULT 0.0;
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS amount_idr DOUBLE PRECISION DEFAULT 0.0;
ALTER TABLE public.bank_status_transactions ADD COLUMN IF NOT EXISTS user_id INTEGER REFERENCES public.users(id) ON DELETE SET NULL;
ALTER TABLE public.bank_accounts ADD COLUMN IF NOT EXISTS company VARCHAR(100) NOT NULL DEFAULT 'EWI Foundation';
INSERT INTO public.bank_accounts (name, account_type, company)
SELECT v.name, v.account_type, 'EWI Foundation'
FROM (VALUES 
    ('BRI', 'management'), ('BNI', 'management'), ('Mandiri', 'management'), ('BCA', 'management'),
    ('BRI Giro', 'status'), ('BNI Giro', 'status'), ('Mandiri Giro', 'status'), ('BCA Giro', 'status'),
    ('BRI Bisnis', 'status'), ('BNI Bisnis', 'status'), ('Mandiri Bisnis', 'status'), ('BCA Bisnis', 'status'),
    ('BRI TabBis', 'status'), ('BNI TabBis', 'status'), ('Mandiri TabBis', 'status'), ('BCA TabBis', 'status'),
    ('BRI Valas', 'status'), ('BNI Valas', 'status'), ('Mandiri Valas', 'status'), ('BCA Valas', 'status'),
    ('Cash', 'status'), ('IDR', 'status'), ('EWI', 'status'), ('-', 'status')
) AS v(name, account_type)
WHERE NOT EXISTS (
    SELECT 1 FROM public.bank_accounts b 
    WHERE b.name = v.name AND b.account_type = v.account_type AND b.company = 'EWI Foundation'
);
"""
    data_ops.insert(0, bank_schema_ddl)

    # DYNAMIC DELETE STATEMENTS based on years_found
    delete_ops = ["BEGIN;\n"]
    if not years_found:
        years_found.add(default_year)

    years_str = ", ".join(map(str, sorted(years_found)))
    delete_ops.append(f"-- DELETE EXISTING DATA FOR YEARS: {years_str} --\n")
    for yr in sorted(years_found):
        del_sql = (
            f"DELETE FROM public.bank_transactions WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.bank_status_transactions WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.revenues WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.taxes WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.expense_subcategories WHERE expense_id IN (SELECT id FROM public.expenses WHERE settlement_id IN (SELECT id FROM public.settlements WHERE report_year = {yr} AND company = {to_sql_val(target_company)}));\n"
            f"DELETE FROM public.expenses WHERE settlement_id IN (SELECT id FROM public.settlements WHERE report_year = {yr} AND company = {to_sql_val(target_company)});\n"
            f"DELETE FROM public.settlements WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.dividend_settings WHERE year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.dividends WHERE report_year = {yr} AND company = {to_sql_val(target_company)};\n"
            f"DELETE FROM public.manual_combine_groups WHERE report_year = {yr} AND (company = {to_sql_val(target_company)} OR company IS NULL);\n"
        )
        delete_ops.append(del_sql)

    # --- FINAL SQL CONSTRUCTION ---
    mode = "a" if is_append else "w"
    with open(output_sql, mode, encoding="utf-8") as f:
        if not is_append:
            f.write(header_ddl)
            f.write(data_part)
            f.write(footer_part)

        # Write setup data (categories, users, schema) OUTSIDE the DO block
        if not is_append:
            for line in data_ops:
                f.write(line)

        # Start the transaction block for this specific year
        f.write(
            "\nDO $$\nDECLARE\n    current_set_id integer;\n    current_batch_id integer;\n    new_adv_id integer;\n    v_exp_id integer;\n    v_id_temp integer;\n    v_admin_id integer;\n    st_total double precision;\nBEGIN\n"
        )
        f.write(
            "  SELECT id INTO v_admin_id FROM public.users WHERE role IN ('manager', 'super_manager') ORDER BY id ASC LIMIT 1;\n"
            "  IF v_admin_id IS NULL THEN\n"
            "    SELECT id INTO v_admin_id FROM public.users ORDER BY id ASC LIMIT 1;\n"
            "  END IF;\n"
            "  CREATE TEMP TABLE IF NOT EXISTS _tmp_ids (id integer) ON COMMIT DROP;\n"
        )
        f.write("  TRUNCATE _tmp_ids;\n")

        # Write delete statements for this year
        for line in delete_ops:
            if "BEGIN;" in line or "COMMIT;" in line:
                continue  # Skip nested tx markers
            f.write(line)

        # Write main data (revenues, expenses, etc.)
        for line in main_data_ops:
            f.write(line)

        # Close the transaction block
        f.write("\nEND $$;\n")

        # Write footer/commit/sequence fix only if it's the last run OR if we want it after every block
        if not is_append:
            f.write("COMMIT;\n")
            f.write("\n-- FIX SEQUENCES --\n")
            for table in [
                "advances",
                "advance_items",
                "assets",
                "bank_accounts",
                "bank_status_transactions",
                "bank_transactions",
                "categories",
                "category_groups",
                "companies",
                "deadline_settings",
                "dividend_settings",
                "dividends",
                "expenses",
                "manual_combine_groups",
                "notifications",
                "override_logs",
                "revenues",
                "settlements",
                "taxes",
                "users",
                "workflow_logs",
            ]:
                f.write(
                    f"SELECT pg_catalog.setval('public.{table}_id_seq', (SELECT COALESCE(MAX(id), 1) FROM public.{table}), true);\n"
                )
            f.write("\nSELECT pg_catalog.set_config('search_path', 'public', false);\n")

    print("\n" + "=" * 60 + "\n[FINAL] LAPORAN AUDIT EKSTRAKSI DATA\n" + "=" * 60)

    lab_rev = name_rev or "(dilewati)"
    print(f"\nSheet revenue / biaya: {lab_rev}")
    if not name_rev:
        print("   (dilewati — tidak ada data revenue/tax/expense dari Excel)")
    else:
        print(f"   - Pemasukan (Revenues) : {counts['revenues']} baris")
        print(f"   - Pajak (Taxes)        : {counts['taxes']} baris")
        print(f"   - Bank Status (NEW)    : {counts['bank']} mutasi")
        print(f"   - Pengeluaran (Total)  : {counts['expenses']} item")
        print(f"     ∟ Single Mode        : {single_items_count} baris")
        print(f"     ∟ Batch Mode         : {batch_items_count} baris")
        print(f"   - Single Total        : {single_items_count} settlement")
        print(
            f"   - Batch Total         : {counts['settlements'] - single_items_count} settlement"
        )
        print(f"   - Settlements Created  : {counts['settlements']} grup")

    lab_ner = name_ner or "(dilewati)"
    print(f"\n📄 Sheet laba rugi & neraca: {lab_ner}")
    if not name_ner:
        print("   (dilewati)")
    else:
        print(f"   - Item Neraca Terbaca  : {len(found_sheet2_items)} item")
        for item in found_sheet2_items[:5]:
            print(f"     ✅ {item}")
        if len(found_sheet2_items) > 5:
            print(f"     ... dan {len(found_sheet2_items) - 5} item lainnya")

    lab_div = name_div or "(dilewati)"
    print(f"\n📄 Sheet deviden: {lab_div}")
    if not name_div:
        print("   (dilewati)")
    else:
        print(f"   - Penerima Deviden     : {len(found_dividend_names)} orang")
        for name in found_dividend_names:
            print(f"     👤 {name}")

    print("\n" + "=" * 60)
    print(f"Selesai! SQL tersimpan di: {output_sql}")
    print("=" * 60)


# ─────────────────────────────────────────────────────────────────────────────
# Daftar perusahaan yang didukung
# ─────────────────────────────────────────────────────────────────────────────
def get_companies_from_db():
    default_companies = ["EWI Foundation", "Expans Wireless Indo"]
    if not psycopg2:
        return default_companies

    try:
        # Coba ambil dari .env
        env_path = os.path.join(os.path.dirname(__file__), "..", "..", "..", ".env")
        db_url = None
        if os.path.exists(env_path):
            with open(env_path, "r") as f:
                for line in f:
                    if line.startswith("DATABASE_URL="):
                        db_url = line.strip().split("=", 1)[1]
                        break

        if not db_url:
            return default_companies

        conn = psycopg2.connect(db_url)
        cur = conn.cursor()
        # Ambil unik dari json company_access
        cur.execute("SELECT company_access FROM users WHERE company_access IS NOT NULL")
        rows = cur.fetchall()

        companies_set = set()
        for row in rows:
            if row[0]:
                try:
                    access_list = json.loads(row[0])
                    for c in access_list:
                        companies_set.add(c)
                except:
                    pass
        conn.close()

        if companies_set:
            return sorted(list(companies_set))
        return default_companies
    except Exception as e:
        print(
            f"[*] Warning: Tidak bisa mengambil perusahaan dari DB ({e}). Menggunakan default."
        )
        return default_companies


COMPANIES = get_companies_from_db()


def run_interactive() -> None:
    """Mode interaktif v14: pilih Perusahaan → Preview/Load → Jalankan."""
    print("\n" + "═" * 55)
    print("  🚀  MIGRASI EXCEL → SQL  (Hybrid Migration v14)")
    print("═" * 55)
    print(f"File default: {os.path.basename(excel_path)}")

    # 1. Pilih file Excel
    try:
        raw = (
            input("\nMasukkan path Excel (Enter = pakai default): ")
            .strip()
            .strip('"')
            .strip("'")
        )
    except EOFError:
        migrate()
        return

    xl = raw or excel_path
    if not os.path.isfile(xl):
        print(f"❌ File tidak ditemukan: {xl}", file=sys.stderr)
        sys.exit(1)

    print("⏳ Memuat workbook (tunggu sebentar)...")
    try:
        wb_f = load_workbook(xl, data_only=False)
        wb_v = load_workbook(xl, data_only=True)
        names = list(wb_v.sheetnames)
    except Exception as e:
        print(f"❌ Gagal membaca file: {e}", file=sys.stderr)
        sys.exit(1)

    # Antrean migrasi: list of dict {company, year, revenue, neraca, dividen}
    migration_queue: list[dict] = []

    try:
        while True:
            # ─── MENU UTAMA ────────────────────────────────────────────
            print("\n" + "═" * 55)
            print("  🏢  PILIH PERUSAHAAN / AKSI")
            print("─" * 55)
            for i, comp in enumerate(COMPANIES, 1):
                print(f"  [{i}] {comp}")
            print("  [3] 🚀 JALANKAN SEMUA ANTREAN")
            print("  [4] 🧹 RESET ANTREAN")
            print("  [5] ❌ KELUAR")
            print("─" * 55)

            if not migration_queue:
                print("  Status: Antrean kosong")
            else:
                print(f"  Status: {len(migration_queue)} item dalam antrean:")
                for i, job in enumerate(migration_queue, 1):
                    y = job["year"] or "SEMUA"
                    print(
                        f"    {i}. [{job['company']}] Tahun {y} "
                        f"[Rev:{job['revenue'] or '-'} | "
                        f"Ner:{job['neraca'] or '-'} | "
                        f"Div:{job['dividen'] or '-'}]"
                    )
            print("─" * 55)

            try:
                opt = input("Pilih [1-5]: ").strip()
            except EOFError:
                break

            # ─── [1] atau [2]: Pilih Perusahaan ────────────────────────
            if opt in ("1", "2"):
                chosen_company = COMPANIES[int(opt) - 1]
                print(f"\n✅ Perusahaan dipilih: {chosen_company}")

                # Sub-menu: Preview atau Load untuk perusahaan ini
                while True:
                    print(f"\n{'─' * 55}")
                    print(f"  📂  {chosen_company.upper()}")
                    print("─" * 55)
                    print("  [1] 🔍 PREVIEW   – Intip isi sheet")
                    print("  [2] 📥 LOAD      – Atur tahun & sheet, masukkan antrean")
                    print("  [0] ↩  Kembali ke menu utama")
                    print("─" * 55)

                    try:
                        sub0 = input("Pilih [0-2]: ").strip()
                    except EOFError:
                        break

                    if sub0 == "0" or not sub0:
                        break

                    # ── [1] PREVIEW ────────────────────────────────────
                    elif sub0 == "1":
                        while True:
                            print("\n--- PREVIEW (pilih sheet untuk diintip) ---")
                            for i, n in enumerate(names, start=1):
                                print(f"  [{i:2}] {n}")
                            print("  [ 0] Kembali")
                            num = input("Nomor/nama sheet: ").strip()
                            if num == "0" or not num:
                                break
                            preview_sheet(wb_f, wb_v, num)

                    # ── [2] LOAD ───────────────────────────────────────
                    elif sub0 == "2":
                        # Pilih tahun
                        print("\n--- PILIH TAHUN LAPORAN ---")
                        years_options = list(range(2020, 2041))
                        for i, y in enumerate(years_options, 1):
                            print(f" [{i:2}] {y}", end="  ")
                            if i % 5 == 0:
                                print()
                        print("\n  [0] SEMUA TAHUN (tanpa filter)")
                        y_choice = input(
                            f"\nPilih tahun [1-{len(years_options)}, 0]: "
                        ).strip()
                        current_ty: int | None = None
                        if y_choice == "0" or not y_choice:
                            current_ty = None
                        elif y_choice.isdigit() and 1 <= int(y_choice) <= len(
                            years_options
                        ):
                            current_ty = years_options[int(y_choice) - 1]
                        elif y_choice.isdigit() and len(y_choice) == 4:
                            current_ty = int(y_choice)
                        print(f"✅ Tahun: {current_ty or 'SEMUA'}")

                        current_sr, current_sn, current_sd = None, None, None

                        # Pilih sheet per kategori
                        while True:
                            y_label = (
                                f"Tahun {current_ty}" if current_ty else "Semua Tahun"
                            )
                            print(f"\n--- LOAD SHEET [{chosen_company}] {y_label} ---")
                            print(
                                f"  [1] Revenue & Cost       (Sekarang: {current_sr or '-'})"
                            )
                            print(
                                f"  [2] Laba Rugi & Neraca   (Sekarang: {current_sn or '-'})"
                            )
                            print(
                                f"  [3] Deviden              (Sekarang: {current_sd or '-'})"
                            )
                            print("  [0] SELESAI & masuk antrean")

                            try:
                                sub = input("Pilih [0-3]: ").strip()
                            except EOFError:
                                break

                            if sub == "0" or not sub:
                                if not (current_sr or current_sn or current_sd):
                                    print("⚠️  Tidak ada sheet yang dipilih. Batalkan.")
                                else:
                                    migration_queue.append(
                                        {
                                            "company": chosen_company,
                                            "year": current_ty,
                                            "revenue": current_sr,
                                            "neraca": current_sn,
                                            "dividen": current_sd,
                                        }
                                    )
                                    print(
                                        f"✅ Ditambahkan ke antrean: [{chosen_company}] {y_label}"
                                    )
                                break

                            cat_label = (
                                "Revenue & Cost"
                                if sub == "1"
                                else "Laba Rugi & Neraca"
                                if sub == "2"
                                else "Deviden"
                            )
                            expected_type = (
                                "revenue"
                                if sub == "1"
                                else "neraca"
                                if sub == "2"
                                else "dividend"
                            )

                            print("\n--- Daftar Sheet ---")
                            for i, n in enumerate(names, start=1):
                                print(f"  [{i:2}] {n}")
                            try:
                                num = input(f"Sheet untuk {cat_label}: ").strip()
                            except EOFError:
                                break
                            if not num:
                                continue

                            preview_sheet(wb_f, wb_v, num)
                            res = scan_sheet_analysis(wb_f, wb_v, num)
                            if not res["name"]:
                                continue

                            if res["type"] != expected_type:
                                print(
                                    f"\n⚠️  Sheet ini terdeteksi sebagai '{res['type'] or 'Unknown'}', bukan '{expected_type}'."
                                )
                                try:
                                    conf = (
                                        input("   Tetap pakai? (y/n): ").strip().lower()
                                    )
                                except EOFError:
                                    conf = "n"
                                if conf != "y":
                                    continue

                            print(f"✅ '{res['name']}' dimuat untuk {cat_label}.")
                            if sub == "1":
                                current_sr = res["name"]
                            elif sub == "2":
                                current_sn = res["name"]
                            elif sub == "3":
                                current_sd = res["name"]

            # ─── [3] JALANKAN ──────────────────────────────────────────
            elif opt == "3":
                if not migration_queue:
                    print(
                        "\n⚠️ Antrean kosong! Silakan pilih perusahaan & load data dulu."
                    )
                    continue

                # Create a subfolder with YYYY-MM-DD_HH-mm-ss
                folder_stamp = dt.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
                subfolder = os.path.join(HASILSQL_DIR, folder_stamp)
                os.makedirs(subfolder, exist_ok=True)

                file_stamp = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
                combined_filename = f"{OUTPUT_SQL_STEM}_{file_stamp}.sql"
                combined_path = os.path.join(subfolder, combined_filename)

                print(f"\n🚀 Memulai Migrasi ({len(migration_queue)} job)...")
                print(f"📄 Output: {combined_path}")

                count_success = 0
                for job in migration_queue:
                    y_label = job["year"] if job["year"] else "SEMUA"
                    comp_label = job["company"]
                    print(f"\n>>> [{comp_label}] Tahun {y_label}...")
                    try:
                        migrate(
                            xl,
                            job["year"],
                            auto_sheets=False,
                            sheet_revenue=job["revenue"],
                            sheet_neraca=job["neraca"],
                            sheet_dividend=job["dividen"],
                            output_path=combined_path,
                            target_company=comp_label,
                        )
                        count_success += 1
                    except Exception as e:
                        print(f"❌ Gagal [{comp_label}] tahun {y_label}: {e}")

                print(f"\n✅ SELESAI: {count_success}/{len(migration_queue)} berhasil.")
                print(f"📁 SQL tersimpan di: {combined_path}")

                if count_success == len(migration_queue):
                    migration_queue.clear()
                    print("🧹 Antrean dibersihkan otomatis.")

            # ─── [4] RESET ─────────────────────────────────────────────
            elif opt == "4":
                migration_queue.clear()
                print("🧹 Antrean dikosongkan.")

            # ─── [5] KELUAR ────────────────────────────────────────────
            elif opt == "5":
                sys.exit(0)

    finally:
        for wb in [wb_f, wb_v]:
            getattr(wb, "close", lambda: None)()


def main() -> None:
    p = argparse.ArgumentParser(
        description="Generate SQL migrasi hybrid dari workbook Excel.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Contoh:\n"
            "  %(prog)s                                    -> mode interaktif (pilih file + sheet)\n"
            "  %(prog)s --quick                            -> satu klik: excel default + semua sheet otomatis\n"
            '  %(prog)s "D:\\\\laporan.xlsx" --sheet-dividen 3   -> file lain, hanya sheet 3 untuk deviden\n'
            "  %(prog)s --excel path.xlsx --list-sheets\n"
            "  %(prog)s --excel path.xlsx --auto-sheets\n"
        ),
    )
    p.add_argument(
        "excel_pos",
        nargs="?",
        default=None,
        metavar="FILE.xlsx",
        help="Path workbook (opsional; bisa diganti --excel)",
    )
    p.add_argument(
        "-x",
        "--excel",
        type=str,
        default=None,
        dest="excel_opt",
        help="Path .xlsx (override path posisional)",
    )
    p.add_argument(
        "--quick",
        action="store_true",
        help="Tanpa tanya: pakai excel dari -x/--excel/posisi atau default di skrip + auto semua sheet",
    )
    p.add_argument(
        "--list-sheets",
        action="store_true",
        help="Tampilkan nomor urut dan nama sheet, lalu keluar",
    )
    p.add_argument(
        "--auto-sheets",
        action="store_true",
        help="Pilih sheet otomatis (substring Revenue-Cost, Laba rugi, Business Summary)",
    )
    p.add_argument(
        "--sheet-revenue",
        type=str,
        default=None,
        metavar="N|NAMA",
        help="Sheet untuk revenue/pajak/pengeluaran (nomor 1..N, nama persis, atau substring unik)",
    )
    p.add_argument(
        "--sheet-neraca",
        type=str,
        default=None,
        metavar="N|NAMA",
        help="Sheet untuk laba rugi / neraca (dividen_settings)",
    )
    p.add_argument(
        "--sheet-dividen",
        type=str,
        default=None,
        metavar="N|NAMA",
        help="Sheet untuk deviden (dividends)",
    )
    p.add_argument(
        "--year",
        type=int,
        default=None,
        help="Filter hanya tahun tertentu (misal 2024)",
    )
    args = p.parse_args()
    xl = args.excel_opt or args.excel_pos or excel_path
    target_yr = args.year

    if args.list_sheets:
        print(f"Sheet di: {xl}\n")
        for i, n in enumerate(list_excel_sheets(xl), start=1):
            print(f"  {i}: {n}")
        return

    if args.quick:
        migrate(xl, auto_sheets=True)
        return

    explicit_any = bool(args.sheet_revenue or args.sheet_neraca or args.sheet_dividen)
    auto = args.auto_sheets or not explicit_any
    try:
        migrate(
            xl,
            target_yr,
            auto_sheets=auto,
            sheet_revenue=args.sheet_revenue,
            sheet_neraca=args.sheet_neraca,
            sheet_dividend=args.sheet_dividen,
        )
    except ValueError as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    if len(sys.argv) == 1:
        if sys.stdin.isatty():
            run_interactive()
        else:
            migrate()
    else:
        main()
