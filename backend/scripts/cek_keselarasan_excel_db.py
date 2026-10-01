"""Alat Cek Keselarasan Data: File Excel vs Database PostgreSQL vs Aplikasi Live (EWI Financial Report).

Memeriksa secara presisi apakah seluruh data keuangan (Single Settlement, Batch Settlement,
Item Pengeluaran, dan Nominal IDR) di:
1. File Excel Asli (data/excel/20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx)
2. Database PostgreSQL (miniproject_revisi_db - tabel settlements & expenses)
3. Aplikasi Live / Backend FastAPI (http://127.0.0.1:8000/api/settlements)
telah 100% selaras tanpa selisih (Selisih = Rp 0,00).

Dapat dijalankan secara interaktif (pilihan menu) atau melalui argumen CLI:
  python cek_keselarasan_excel_db.py --all
  python cek_keselarasan_excel_db.py --year 2024
"""

import argparse
import datetime as dt
import json
import os
import re
import sys
import urllib.error
import urllib.request
from pathlib import Path

# Pastikan UTF-8 untuk output konsol Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

try:
    import openpyxl
except ImportError:
    print("❌ Modul 'openpyxl' belum terinstall. Jalankan: pip install openpyxl")
    sys.exit(1)

try:
    import psycopg2
    from psycopg2.extras import DictCursor
except ImportError:
    psycopg2 = None

# Paths
SCRIPT_DIR = Path(__file__).resolve().parent
if SCRIPT_DIR.name == "scripts":
    PROJECT_ROOT = SCRIPT_DIR.parent.parent
elif SCRIPT_DIR.name == "backend":
    PROJECT_ROOT = SCRIPT_DIR.parent
else:
    PROJECT_ROOT = SCRIPT_DIR

sys.path.insert(0, str(PROJECT_ROOT))

ORIGINAL_EXCEL_PATH = (
    PROJECT_ROOT
    / "data"
    / "excel"
    / "20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"
)
DEFAULT_EXCEL_PATH = ORIGINAL_EXCEL_PATH
DEFAULT_DB_URL = (
    "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"
)
API_BASE_URL = "http://127.0.0.1:8000"

SHEET_CONFIG = {
    2024: {
        "sheet_name": "Rev VS Ops cost th 2024",
        "r_single_start": 71,
        "r_single_end": 263,
        "r_batch_start": 264,
        "r_batch_end": 861,
        "col_cat": 8,
    },
    2025: {
        "sheet_name": "Rev VS Ops cost th 2025_Final",
        "r_single_start": 162,
        "r_single_end": 516,
        "r_batch_start": 517,
        "r_batch_end": 1305,
        "col_cat": 9,
    },
    2026: {
        "sheet_name": "Rev VS Ops cost th 2026_",
        "r_single_start": 176,
        "r_single_end": 390,
        "r_batch_start": 391,
        "r_batch_end": 830,
        "col_cat": 9,
    },
}


def get_db_connection():
    """Koneksi ke PostgreSQL menggunakan .env jika ada, atau default URL."""
    db_url = os.environ.get("DATABASE_URL")
    if not db_url:
        env_path = PROJECT_ROOT / "backend" / ".env"
        if env_path.exists():
            with open(env_path, "r", encoding="utf-8") as f:
                for line in f:
                    if line.startswith("DATABASE_URL="):
                        db_url = line.strip().split("=", 1)[1]
                        break
    if not db_url:
        db_url = DEFAULT_DB_URL

    if not psycopg2:
        return None, "Modul 'psycopg2' tidak terpasang."

    try:
        conn = psycopg2.connect(db_url)
        return conn, None
    except Exception as e:
        return None, str(e)


def to_num(val):
    """Konversi nilai ke float aman."""
    if val is None:
        return 0.0
    if isinstance(val, (int, float)):
        return float(val)
    s = str(val).strip().replace(",", "")
    try:
        return float(s)
    except Exception:
        return 0.0


def _is_marker_row(val_b, val_c) -> bool:
    """Baris penanda jika COL-B = keyword marker dan COL-C = ':'."""
    b = str(val_b or "").strip().lower()
    c = str(val_c or "").strip()
    return b in ("single", "batch", "subject", "detail") and c == ":"


def _is_subkategori_row(val_b, val_c, val_d, val_e, val_f, val_g) -> bool:
    """Subkategori = hanya COL-D terisi, semua kolom lain kosong."""
    d_filled = bool(val_d and str(val_d).strip())
    others_empty = not any(
        [
            val_b and str(val_b).strip(),
            val_c and str(val_c).strip(),
            val_e and str(val_e).strip(),
            val_f and str(val_f).strip(),
            val_g and str(val_g).strip(),
        ]
    )
    return d_filled and others_empty


def extract_excel_stats(wb_val, wb_form, year):
    """Membaca data dari Excel Sheet tahun terkait dengan parsing penanda eksplisit."""
    cfg = SHEET_CONFIG.get(year)
    if not cfg or cfg["sheet_name"] not in wb_val.sheetnames:
        return None

    ws_v = wb_val[cfg["sheet_name"]]

    mode = None
    current_subject = None
    batch_groups = []
    single_items = []
    batch_items = []

    for r in range(1, ws_v.max_row + 1):
        val_b = ws_v.cell(r, 2).value
        val_c = ws_v.cell(r, 3).value
        val_d = ws_v.cell(r, 4).value
        val_e = ws_v.cell(r, 5).value
        val_f = ws_v.cell(r, 6).value
        val_g = ws_v.cell(r, 7).value

        val_b_str = str(val_b or "").strip()
        val_c_str = str(val_c or "").strip()
        val_d_str = str(val_d or "").strip()

        all_empty = not any(
            [
                str(x or "").strip()
                for x in [val_b, val_c, val_d, val_e, val_f, val_g]
            ]
        )
        if all_empty:
            continue

        if (
            val_b_str.upper() in ("DATE", "PENGELUARAN")
            or val_c_str.upper() in ("#",)
            or val_d_str.upper()
            in (
                "ACTIVITY",
                "DESCRIPTION",
                "DETAIL",
                "ITEM",
                "JUMLAH",
                "TOTAL",
                "SUBTOTAL",
                "USD",
                "IDR",
            )
        ):
            continue

        # 1. Deteksi Marker Eksplisit
        if _is_marker_row(val_b, val_c):
            m = val_b_str.lower()
            if m == "single":
                mode = "single"
                current_subject = None
            elif m == "batch":
                mode = "batch"
                current_subject = None
            elif m == "subject":
                if mode == "batch":
                    current_subject = val_d_str[:100]
                    batch_groups.append((r, current_subject))
            elif m == "detail":
                pass
            continue

        # 2. Skip bank transfer header row
        if "TRANSFER FROM" in val_b_str.upper():
            continue

        # 3. Skip baris subkategori (hanya Kolom D terisi)
        if _is_subkategori_row(val_b, val_c, val_d, val_e, val_f, val_g):
            continue

        # Hanya proses transaksi jika sudah di dalam blok Single atau Batch
        if mode is None:
            continue

        # 4. Ambil nominal transaksi dari Kolom 9-21 (Kategori) atau Kolom 5/6 (Fallback)
        col_amt = 0.0
        found_in_col = False
        for col in range(9, 22):
            v_tmp = to_num(ws_v.cell(r, col).value)
            if v_tmp != 0:
                col_amt = v_tmp
                found_in_col = True
                break

        if not found_in_col:
            for fallback_col in [6, 5]:
                v_tmp = to_num(ws_v.cell(r, fallback_col).value)
                if v_tmp != 0:
                    col_amt = v_tmp
                    found_in_col = True
                    break

        has_date = isinstance(val_b, (dt.date, dt.datetime))
        cur_raw = str(val_g or "").strip().upper()
        if cur_raw in ("RP", ""):
            cur = "IDR"
        else:
            cur = cur_raw

        # Transaksi valid bertanggal meskipun nominal 0
        if not found_in_col and has_date and cur in ("IDR", "USD", "MYR"):
            col_amt = 0.0
            found_in_col = True

        if not found_in_col:
            continue

        if val_d_str.upper() in ("TOTAL", "SUBTOTAL", "-", ""):
            continue

        # Hitung kurs secara presisi (IDR kurs selalu 1.0)
        rat_val = to_num(ws_v.cell(r, 8).value)
        calc_rat = rat_val if rat_val > 0 else 1.0
        if cur in ("IDR", "-", ""):
            calc_rat = 1.0

        if cur not in ("IDR", "-", "") and calc_rat > 1:
            t_st = round(col_amt / calc_rat, 4)
        else:
            t_st = col_amt

        item_amt_idr = t_st * calc_rat

        date_val = val_b if has_date else None
        if mode == "batch":
            batch_items.append((r, date_val, val_d_str, item_amt_idr, current_subject))
        else:
            single_items.append((r, date_val, val_d_str, item_amt_idr))

    active_batch_groups = set(x[4] for x in batch_items if x[4] is not None)
    b_count = len(active_batch_groups) if active_batch_groups else len(batch_groups)

    s_count = len(single_items)
    s_amt = sum(x[3] for x in single_items)
    b_items = len(batch_items)
    b_amt = sum(x[3] for x in batch_items)

    return {
        "year": year,
        "sheet_name": cfg["sheet_name"],
        "single_count": s_count,
        "single_amount": s_amt,
        "single_items": single_items,
        "batch_count": b_count,
        "batch_items_count": b_items,
        "batch_items": batch_items,
        "batch_amount": b_amt,
        "total_settlements": s_count + b_count,
        "total_items": s_count + b_items,
        "total_amount": s_amt + b_amt,
    }


def fetch_db_stats(conn, year):
    """Ambil data statistik Single & Batch langsung dari database PostgreSQL."""
    cur = conn.cursor(cursor_factory=DictCursor)

    # 1. Settlements Single
    cur.execute(
        """
        SELECT count(*), COALESCE(sum(disbursed_amount), 0)
        FROM settlements
        WHERE report_year = %s AND settlement_type = 'single';
    """,
        (year,),
    )
    s_cnt, s_amt = cur.fetchone()

    # 2. Settlements Batch
    cur.execute(
        """
        SELECT s.id, s.title, s.document_date, s.disbursed_amount,
               (SELECT count(*) FROM expenses WHERE settlement_id = s.id) as item_count
        FROM settlements s
        WHERE s.report_year = %s AND s.settlement_type = 'batch'
        ORDER BY s.id ASC;
    """,
        (year,),
    )
    batch_rows = cur.fetchall()

    b_cnt = len(batch_rows)
    b_items = sum(r["item_count"] for r in batch_rows)
    b_amt = sum(float(r["disbursed_amount"] or 0) for r in batch_rows)

    # 3. Total Expenses
    cur.execute(
        """
        SELECT count(*), COALESCE(sum(amount * currency_exchange), 0)
        FROM expenses e
        JOIN settlements s ON e.settlement_id = s.id
        WHERE s.report_year = %s;
    """,
        (year,),
    )
    tot_exp_cnt, tot_exp_amt = cur.fetchone()

    # 4. Ambil sampel Single settlements
    cur.execute(
        """
        SELECT id, title, document_date, disbursed_amount
        FROM settlements
        WHERE report_year = %s AND settlement_type = 'single'
        ORDER BY id ASC;
    """,
        (year,),
    )
    single_rows = cur.fetchall()

    return {
        "year": year,
        "single_count": s_cnt,
        "single_amount": float(s_amt),
        "single_rows": single_rows,
        "batch_count": b_cnt,
        "batch_items_count": b_items,
        "batch_amount": float(b_amt),
        "batch_rows": batch_rows,
        "total_settlements": s_cnt + b_cnt,
        "total_items": tot_exp_cnt,
        "total_amount": float(tot_exp_amt),
    }


_CACHED_API_TOKEN = None


def get_api_token():
    """Dapatkan JWT Token dengan cache agar tidak terkena limit login."""
    global _CACHED_API_TOKEN
    if _CACHED_API_TOKEN:
        return _CACHED_API_TOKEN

    login_data = json.dumps(
        {"username": "manager1", "password": "manager12345"}
    ).encode("utf-8")
    req_login = urllib.request.Request(
        f"{API_BASE_URL}/api/auth/login",
        data=login_data,
        headers={"Content-Type": "application/json"},
    )
    res_login = urllib.request.urlopen(req_login, timeout=3.0)
    token = json.loads(res_login.read().decode())["token"]
    _CACHED_API_TOKEN = token
    return _CACHED_API_TOKEN


def fetch_api_stats(year):
    """Ambil data statistik dari Live FastAPI backend jika server sedang aktif."""
    try:
        # Cek kesehatan server (timeout 1 detik)
        req_health = urllib.request.urlopen(
            f"{API_BASE_URL}/api/health", timeout=1.0
        )
        if req_health.status != 200:
            return {"is_online": False}

        token = get_api_token()
        if not token:
            return {"is_online": False}

        # Panggil endpoint settlements
        req_set = urllib.request.Request(
            f"{API_BASE_URL}/api/settlements?report_year={year}&limit=1000",
            headers={"Authorization": f"Bearer {token}"},
        )
        res_set = urllib.request.urlopen(req_set, timeout=5.0)
        data = json.loads(res_set.read().decode())
        items = data.get("settlements", [])

        single_cnt = sum(
            1 for s in items if s.get("settlement_type") == "single"
        )
        batch_cnt = sum(1 for s in items if s.get("settlement_type") == "batch")
        total_amt = sum(float(s.get("disbursed_amount") or 0) for s in items)

        return {
            "is_online": True,
            "single_count": single_cnt,
            "batch_count": batch_cnt,
            "total_settlements": len(items),
            "total_amount": total_amt,
        }
    except Exception:
        return {"is_online": False}


def print_comparison_table(excel_data, db_data, api_data, year):
    """Tampilkan tabel perbandingan 3-arah: Excel vs Database vs Aplikasi Live."""
    has_api = api_data and api_data.get("is_online", False)

    print("\n" + "═" * 105)
    print(f"   📊 HASIL AUDIT KESELARASAN DATA KEUANGAN TAHUN {year}")
    print(f"   [1] File Excel : {excel_data['sheet_name']}")
    print(f"   [2] Database   : PostgreSQL (miniproject_revisi_db)")
    api_status_str = "AKTIF (:8000) ✅" if has_api else "TIDAK AKTIF / OFFLINE"
    print(f"   [3] Aplikasi   : Live Backend API -> {api_status_str}")
    print("═" * 105)

    if has_api:
        header = (
            f"║ {'Indikator / Metrik':<26} │ {'Excel File':<17} │ {'Database (DB)':<17} │ "
            f"{'Aplikasi (Live)':<17} │ {'Selisih':<9} │ {'Status':<7} ║"
        )
        sep_mid = (
            "╟"
            + "─" * 28
            + "┼"
            + "─" * 19
            + "┼"
            + "─" * 19
            + "┼"
            + "─" * 19
            + "┼"
            + "─" * 11
            + "┼"
            + "─" * 9
            + "╢"
        )
        sep_bot = (
            "╚"
            + "═" * 28
            + "╧"
            + "═" * 19
            + "╧"
            + "═" * 19
            + "╧"
            + "═" * 19
            + "╧"
            + "═" * 11
            + "╧"
            + "═" * 9
            + "╝"
        )
    else:
        header = (
            f"║ {'Indikator / Metrik':<26} │ {'Excel File':<17} │ {'Database (DB)':<17} │ "
            f"{'Selisih':<10} │ {'Status':<7} ║"
        )
        sep_mid = (
            "╟"
            + "─" * 28
            + "┼"
            + "─" * 19
            + "┼"
            + "─" * 19
            + "┼"
            + "─" * 12
            + "┼"
            + "─" * 9
            + "╢"
        )
        sep_bot = (
            "╚"
            + "═" * 28
            + "╧"
            + "═" * 19
            + "╧"
            + "═" * 19
            + "╧"
            + "═" * 12
            + "╧"
            + "═" * 9
            + "╝"
        )

    print(header)
    print(sep_mid)

    rows = [
        (
            "Single Settlements",
            excel_data["single_count"],
            db_data["single_count"],
            api_data.get("single_count") if has_api else None,
            "settlement",
        ),
        (
            "Batch Settlements",
            excel_data["batch_count"],
            db_data["batch_count"],
            api_data.get("batch_count") if has_api else None,
            "settlement",
        ),
        (
            "TOTAL SETTLEMENTS",
            excel_data["total_settlements"],
            db_data["total_settlements"],
            api_data.get("total_settlements") if has_api else None,
            "settlement",
        ),
        (
            "Batch Item Pengeluaran",
            excel_data["batch_items_count"],
            db_data["batch_items_count"],
            None,
            "item",
        ),
        (
            "TOTAL ITEM PENGELUARAN",
            excel_data["total_items"],
            db_data["total_items"],
            None,
            "item",
        ),
        (
            "Total Nominal Single",
            excel_data["single_amount"],
            db_data["single_amount"],
            None,
            "IDR",
        ),
        (
            "Total Nominal Batch",
            excel_data["batch_amount"],
            db_data["batch_amount"],
            None,
            "IDR",
        ),
        (
            "TOTAL PENGELUARAN TAHUNAN",
            excel_data["total_amount"],
            db_data["total_amount"],
            api_data.get("total_amount") if has_api else None,
            "IDR",
        ),
    ]

    all_matched = True
    discrepancies = []

    for label, ex_val, db_val, api_val, unit in rows:
        if unit in ["settlement", "item"]:
            diff = ex_val - db_val
            is_match = diff == 0
            if has_api and api_val is not None and api_val != db_val:
                is_match = False

            ex_str = f"{ex_val} {unit}"
            db_str = f"{db_val} {unit}"
            api_str = (
                f"{api_val} {unit}"
                if (has_api and api_val is not None)
                else "-"
            )
            diff_str = f"{diff:+d} {unit}" if diff != 0 else "0"
        else:
            diff = ex_val - db_val
            is_match = abs(diff) < 1.0
            if (
                has_api
                and api_val is not None
                and abs(float(api_val) - db_val) >= 1.0
            ):
                is_match = False

            ex_str = f"Rp {ex_val:,.2f}"
            db_str = f"Rp {db_val:,.2f}"
            api_str = (
                f"Rp {api_val:,.2f}"
                if (has_api and api_val is not None)
                else "-"
            )
            diff_str = f"Rp {diff:+,.2f}" if not is_match else "Rp 0.00"

        status = "✅ MATCH" if is_match else "❌ BEDA"
        if not is_match:
            all_matched = False
            discrepancies.append((label, ex_str, db_str, diff_str))

        if has_api:
            print(
                f"║ {label:<26} │ {ex_str:>17} │ {db_str:>17} │ {api_str:>17} │ {diff_str:>9} │ {status:<7} ║"
            )
        else:
            print(
                f"║ {label:<26} │ {ex_str:>17} │ {db_str:>17} │ {diff_str:>10} │ {status:<7} ║"
            )

    print(sep_bot)

    if all_matched:
        print(
            f"🎉 KESIMPULAN TAHUN {year}: DATA EXCEL, DATABASE, DAN APLIKASI 100% SELARAS (Selisih Rp 0,00)!\n"
        )
    else:
        print(f"⚠️ PERHATIAN TAHUN {year}: Ditemukan perbedaan:")
        for lbl, e_s, d_s, d_diff in discrepancies:
            print(f"   • {lbl}: Excel={e_s} vs DB={d_s} (Selisih: {d_diff})")
        print()


def print_batch_details(db_data, year):
    """Tampilkan rincian daftar grup batch di database untuk verifikasi lanjutan."""
    rows = db_data["batch_rows"]
    print(f"\n📋 DETAIL {len(rows)} BATCH SETTLEMENTS DI DATABASE (TAHUN {year}):")
    print("─" * 90)
    print(
        f"{'No':<4} {'ID':<6} {'Tanggal':<12} {'Items':<7} {'Nominal (IDR)':<18} {'Nama / Judul Grup Batch'}"
    )
    print("─" * 90)
    for idx, r in enumerate(rows, 1):
        dt_str = str(r["document_date"]) if r["document_date"] else "-"
        amt_str = (
            f"Rp {r['disbursed_amount']:,.0f}"
            if r["disbursed_amount"]
            else "Rp 0"
        )
        ttl = str(r["title"] or "")
        print(
            f"{idx:<4} {r['id']:<6} {dt_str:<12} {r['item_count']:<7} {amt_str:>17}  {ttl[:45]}"
        )
    print("─" * 90)


def print_single_samples(excel_data, db_data, year):
    """Tampilkan sampel perbandingan 5 transaksi Single pertama antara Excel dan Database."""
    print(f"\n🔍 SAMPEL 5 TRANSAKSI SINGLE PERTAMA (TAHUN {year}):")
    print("─" * 105)
    print(f" {'No':<3} │ {'Tanggal (Excel)':<15} {'Nominal Excel':<18} │ {'Nominal DB':<18} {'Judul / Deskripsi'}")
    print("─" * 105)

    ex_singles = excel_data.get("single_items", [])[:5]
    db_singles = db_data.get("single_rows", [])[:5]

    for i in range(max(len(ex_singles), len(db_singles))):
        ex_row = ex_singles[i] if i < len(ex_singles) else None
        db_row = db_singles[i] if i < len(db_singles) else None

        ex_dt = str(ex_row[1])[:10] if (ex_row and ex_row[1]) else "-"
        ex_amt = f"Rp {ex_row[3]:,.0f}" if ex_row else "-"
        db_amt = (
            f"Rp {float(db_row['disbursed_amount']):,.0f}" if db_row else "-"
        )
        desc = (
            db_row["title"]
            if db_row
            else (ex_row[2] if ex_row else "-")
        )

        match_icon = "✅" if ex_amt == db_amt else "❌"
        print(f" {i+1:<3} │ {ex_dt:<15} {ex_amt:>18} │ {db_amt:>18} {match_icon}  {str(desc)[:45]}")
    print("─" * 105)


def run_full_audit(excel_path=None):
    """Jalankan audit komparasi lengkap untuk seluruh tahun (2024, 2025, 2026)."""
    xl_file = Path(excel_path) if excel_path else DEFAULT_EXCEL_PATH
    if not xl_file.exists():
        print(f"❌ File Excel tidak ditemukan di: {xl_file}")
        return

    print(f"📂 Membuka Workbook Excel: {xl_file.name}...")
    wb_val = openpyxl.load_workbook(xl_file, data_only=True)
    wb_form = openpyxl.load_workbook(xl_file, data_only=False)

    conn, err = get_db_connection()
    if err:
        print(f"❌ Gagal koneksi ke database: {err}")
        return

    print("✅ Berhasil terkoneksi ke Database PostgreSQL!")

    for yr in [2024, 2025, 2026]:
        ex_stats = extract_excel_stats(wb_val, wb_form, yr)
        if not ex_stats:
            print(f"⚠️ Melewati tahun {yr} (sheet tidak ditemukan).")
            continue
        db_stats = fetch_db_stats(conn, yr)
        api_stats = fetch_api_stats(yr)
        print_comparison_table(ex_stats, db_stats, api_stats, yr)

    conn.close()


def run_interactive_menu():
    """Menu interaktif pilihan tahun atau fitur detail."""
    xl_file = DEFAULT_EXCEL_PATH
    if not xl_file.exists():
        print(f"❌ File Excel default tidak ditemukan: {xl_file}")
        return

    print("\n⏳ Memuat Workbook Excel & Database (tunggu sebentar)...")
    wb_val = openpyxl.load_workbook(xl_file, data_only=True)
    wb_form = openpyxl.load_workbook(xl_file, data_only=False)

    conn, err = get_db_connection()
    if err:
        print(f"❌ Gagal koneksi database: {err}")
        return

    while True:
        print("\n" + "═" * 65)
        print("  📊 ALAT CEK KESELARASAN DATA: EXCEL vs DATABASE vs APLIKASI")
        print(f"  File Sumber : {xl_file.name}")
        print("═" * 65)
        print(" [1] Cek Keselarasan SEMUA TAHUN (2024 - 2026)")
        print(" [2] Cek Spesifik Tahun 2024 (Excel vs DB vs Live API)")
        print(" [3] Cek Spesifik Tahun 2025 (Excel vs DB vs Live API)")
        print(" [4] Cek Spesifik Tahun 2026 (Excel vs DB vs Live API)")
        print(" [5] Lihat Rincian Daftar Grup Batch di Database")
        print(" [6] Lihat Sampel Transaksi Single (Excel vs Database)")
        print(" [0] Keluar")
        print("═" * 65)

        pilihan = input("Pilih nomor menu [0-6]: ").strip()

        if pilihan == "0":
            print("👋 Selesai. Terima kasih!")
            break
        elif pilihan == "1":
            for yr in [2024, 2025, 2026]:
                ex_stats = extract_excel_stats(wb_val, wb_form, yr)
                db_stats = fetch_db_stats(conn, yr)
                api_stats = fetch_api_stats(yr)
                print_comparison_table(ex_stats, db_stats, api_stats, yr)
        elif pilihan in ["2", "3", "4"]:
            yr_map = {"2": 2024, "3": 2025, "4": 2026}
            target_year = yr_map[pilihan]
            ex_stats = extract_excel_stats(wb_val, wb_form, target_year)
            db_stats = fetch_db_stats(conn, target_year)
            api_stats = fetch_api_stats(target_year)
            print_comparison_table(ex_stats, db_stats, api_stats, target_year)
        elif pilihan == "5":
            sub = input(
                "Masukkan tahun yang ingin dilihat rincian batch-nya [2024/2025/2026]: "
            ).strip()
            if sub in ["2024", "2025", "2026"]:
                y = int(sub)
                db_stats = fetch_db_stats(conn, y)
                print_batch_details(db_stats, y)
            else:
                print("❌ Tahun tidak valid.")
        elif pilihan == "6":
            sub = input(
                "Masukkan tahun yang ingin dilihat sampel single-nya [2024/2025/2026]: "
            ).strip()
            if sub in ["2024", "2025", "2026"]:
                y = int(sub)
                ex_stats = extract_excel_stats(wb_val, wb_form, y)
                db_stats = fetch_db_stats(conn, y)
                print_single_samples(ex_stats, db_stats, y)
            else:
                print("❌ Tahun tidak valid.")
        else:
            print("❌ Pilihan tidak dikenali. Silakan masukkan angka 0-6.")

    conn.close()


def main():
    parser = argparse.ArgumentParser(
        description="Alat Cek Keselarasan Excel vs Database vs Aplikasi Live (EWI Financial Report)"
    )
    parser.add_argument(
        "--all",
        action="store_true",
        help="Jalankan audit komparasi semua tahun otomatis",
    )
    parser.add_argument(
        "--year",
        type=int,
        choices=[2024, 2025, 2026],
        help="Audit tahun tertentu",
    )
    parser.add_argument(
        "--excel",
        type=str,
        help="Path alternatif file Excel",
    )

    args = parser.parse_args()

    if args.all:
        run_full_audit(args.excel)
    elif args.year:
        xl_file = Path(args.excel) if args.excel else DEFAULT_EXCEL_PATH
        wb_val = openpyxl.load_workbook(xl_file, data_only=True)
        wb_form = openpyxl.load_workbook(xl_file, data_only=False)
        conn, err = get_db_connection()
        if err:
            print(f"❌ Error DB: {err}")
            sys.exit(1)
        ex_stats = extract_excel_stats(wb_val, wb_form, args.year)
        db_stats = fetch_db_stats(conn, args.year)
        api_stats = fetch_api_stats(args.year)
        print_comparison_table(ex_stats, db_stats, api_stats, args.year)
        conn.close()
    else:
        run_interactive_menu()


if __name__ == "__main__":
    main()
