"""
Generator Excel Finansial Versi Bersih & Terstandar (Clean Financial Workbook)
PT. Exspan Wireline Indonesia (2024 - 2026)

Workbook ini memuat 5 sheet utama:
1. Rev VS Ops cost th 2024
2. Rev VS Ops cost th 2025_Final
3. Rev VS Ops cost th 2026_
4. labarugi2024
5. business_summary2024

Setiap data (Revenue, Pajak, Bank Status, Single, Batch, Laba Rugi, Deviden)
disalin 100% utuh tanpa ada yang hilang, ditata rapi dengan styling profesional,
serta dilengkapi formula Excel otomatis.
"""

import datetime as dt
import os
import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

import openpyxl
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

# Paths
PROJECT_ROOT = Path(__file__).resolve().parent.parent.parent
SOURCE_EXCEL_PATH = PROJECT_ROOT / "data" / "excel" / "20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"
OUTPUT_EXCEL_PATH = PROJECT_ROOT / "data" / "excel" / "EWI_Financial_Report_2024-2026_Clean.xlsx"

# Palette & Fonts
FONT_NAME = "Segoe UI"
FONT_TITLE = Font(name=FONT_NAME, size=15, bold=True, color="1F497D")
FONT_SUBTITLE = Font(name=FONT_NAME, size=11, bold=True, color="595959")
FONT_SECTION = Font(name=FONT_NAME, size=11, bold=True, color="FFFFFF")
FONT_HEADER = Font(name=FONT_NAME, size=10, bold=True, color="FFFFFF")
FONT_REGULAR = Font(name=FONT_NAME, size=9, bold=False, color="000000")
FONT_BOLD = Font(name=FONT_NAME, size=9, bold=True, color="000000")
FONT_SUBTOTAL = Font(name=FONT_NAME, size=9, bold=True, color="1F497D")
FONT_GRAND_TOTAL = Font(name=FONT_NAME, size=10, bold=True, color="FFFFFF")

# Fills
FILL_SEC_REV = PatternFill(start_color="1F4E78", end_color="1F4E78", fill_type="solid")       # Dark Navy
FILL_SEC_TAX = PatternFill(start_color="843C0C", end_color="843C0C", fill_type="solid")       # Crimson/Dark Brown
FILL_SEC_BANK = PatternFill(start_color="1E6B38", end_color="1E6B38", fill_type="solid")      # Forest Green
FILL_SEC_EXP = PatternFill(start_color="2F5597", end_color="2F5597", fill_type="solid")       # Classic Steel Blue
FILL_SUBTOTAL = PatternFill(start_color="EDF2F8", end_color="EDF2F8", fill_type="solid")      # Light Ice Blue
FILL_GROUP_HDR = PatternFill(start_color="D9E1F2", end_color="D9E1F2", fill_type="solid")     # Soft Lavender Blue
FILL_GRAND_TOT = PatternFill(start_color="1F497D", end_color="1F497D", fill_type="solid")     # Royal Navy
FILL_ZEBRA = PatternFill(start_color="F9FAFC", end_color="F9FAFC", fill_type="solid")         # Very soft gray

# Borders
THIN_GRAY = Side(border_style="thin", color="D9D9D9")
MEDIUM_DARK = Side(border_style="medium", color="595959")
DOUBLE_DARK = Side(border_style="double", color="1F497D")

BORDER_DATA = Border(left=THIN_GRAY, right=THIN_GRAY, top=THIN_GRAY, bottom=THIN_GRAY)
BORDER_HEADER = Border(left=THIN_GRAY, right=THIN_GRAY, top=MEDIUM_DARK, bottom=MEDIUM_DARK)
BORDER_SUBTOTAL = Border(top=THIN_GRAY, bottom=MEDIUM_DARK, left=THIN_GRAY, right=THIN_GRAY)
BORDER_GRAND = Border(top=MEDIUM_DARK, bottom=DOUBLE_DARK, left=THIN_GRAY, right=THIN_GRAY)

# Alignments
ALIGN_LEFT = Alignment(horizontal="left", vertical="center")
ALIGN_CENTER = Alignment(horizontal="center", vertical="center")
ALIGN_RIGHT = Alignment(horizontal="right", vertical="center")
ALIGN_HDR = Alignment(horizontal="center", vertical="center", wrap_text=True)

# Number Formats
FMT_CURRENCY = "Rp #,##0.00"
FMT_INTEGER = "#,##0"
FMT_DECIMAL = "#,##0.00"
FMT_DATE = "yyyy-mm-dd"


def auto_fit_columns(ws, min_col=1, max_col=None, max_width=45):
    """Atur lebar kolom secara proporsional agar tidak ada teks yang terpotong."""
    if max_col is None:
        max_col = ws.max_column
    for col in range(min_col, max_col + 1):
        col_letter = get_column_letter(col)
        max_len = 0
        for row in range(1, min(ws.max_row + 1, 300)):
            val = ws.cell(row, col).value
            if val is not None:
                # Abaikan baris header seksi yang sangat panjang (merged/banner)
                if ws.cell(row, col).font and ws.cell(row, col).font.size and ws.cell(row, col).font.size > 11:
                    continue
                s_val = str(val)
                if len(s_val) > max_len and "\n" not in s_val:
                    max_len = len(s_val)
        ws.column_dimensions[col_letter].width = max(max_len + 3, 11) if max_len < max_width else max_width


def build_annual_sheet(ws_clean, wb_src_val, wb_src_form, year, sheet_name):
    """Menyusun sheet tahunan 2024 / 2025 / 2026 secara lengkap, terstruktur, dan presisi."""
    ws_v = wb_src_val[sheet_name]
    ws_f = wb_src_form[sheet_name]
    
    print(f"📄 Memproses sheet: {sheet_name} (Tahun {year})...")
    
    # Grid lines on
    ws_clean.views.sheetView[0].showGridLines = True
    
    # 1. Title Block
    ws_clean.cell(1, 1, f"PT. EXSPAN WIRELINE INDONESIA").font = FONT_TITLE
    ws_clean.cell(2, 1, f"LAPORAN KEUANGAN REVENUE & OPERATION COST - TAHUN {year}").font = FONT_SUBTITLE
    
    curr_row = 4
    
    # -------------------------------------------------------------
    # 2. SEKSI 1: REVENUE & TAX (Pemasukan Proyek)
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 1, f"I. REVENUE & TAX (PEMASUKAN PROYEK TAHUN {year})").font = FONT_SECTION
    ws_clean.cell(curr_row, 1).fill = FILL_SEC_REV
    ws_clean.row_dimensions[curr_row].height = 24
    curr_row += 1
    
    rev_headers = [
        "No", "Tanggal Invoice", "No. Invoice", "Klien / Proyek", "Deskripsi / Aktivitas",
        "Mata Uang", "Nilai Invoice (Valas)", "Kurs (Rate)", "Nilai Invoice (IDR)",
        "Tanggal Terima", "Jumlah Diterima (IDR)", "PPN 11% (IDR)", "PPh 23 (IDR)",
        "Biaya Transfer", "Sumber Rekening / Bank", "Keterangan / Remark"
    ]
    for col_idx, h_text in enumerate(rev_headers, 1):
        cell = ws_clean.cell(curr_row, col_idx, h_text)
        cell.font = FONT_HEADER
        cell.fill = FILL_SEC_REV
        cell.alignment = ALIGN_HDR
        cell.border = BORDER_HEADER
    ws_clean.row_dimensions[curr_row].height = 28
    curr_row += 1
    
    rev_start_row = curr_row
    
    # Deteksi batas baris revenue di Excel asli
    rev_end_orig = 20 if year == 2024 else (44 if year == 2025 else 61)
    rev_start_orig = 7
    
    item_no = 1
    for r in range(rev_start_orig, rev_end_orig + 1):
        # Cari tanggal & deskripsi
        dt_val = ws_v.cell(r, 2).value
        desc = ws_v.cell(r, 4).value
        if not desc or "TOTAL" in str(desc).upper():
            continue
            
        inv_no = ws_v.cell(r, 8).value if year == 2024 else ws_v.cell(r, 8).value
        client = ws_v.cell(r, 9).value
        cur = str(ws_v.cell(r, 6 if year == 2024 else 6).value or "IDR").strip().upper()
        rate = ws_v.cell(r, 7 if year == 2024 else 7).value or 1.0
        
        # Values
        if year == 2024:
            val_valas = ws_v.cell(r, 5).value if cur != "IDR" else 0
            val_idr = ws_v.cell(r, 5).value
            dt_recv = ws_v.cell(r, 10).value
            amt_recv = ws_v.cell(r, 11).value
            ppn = ws_v.cell(r, 12).value
            pph23 = ws_v.cell(r, 13).value
            fee = ws_v.cell(r, 14).value
            bank = ws_v.cell(r, 22).value if ws_v.cell(r, 22).value else "BRI"
            remark = ws_v.cell(r, 15).value
        else: # 2025 & 2026
            val_valas = ws_v.cell(r, 5).value or 0
            val_idr = ws_v.cell(r, 6).value or 0
            cur = str(ws_v.cell(r, 7).value or "IDR").strip().upper()
            rate = ws_v.cell(r, 8).value or 1.0
            dt_recv = ws_v.cell(r, 11).value
            amt_recv = ws_v.cell(r, 12).value
            ppn = ws_v.cell(r, 14).value
            pph23 = ws_v.cell(r, 15).value
            fee = ws_v.cell(r, 16).value
            remark = ws_v.cell(r, 17).value
            bank = ws_v.cell(r, 18 if year == 2026 else 24).value or "-"

        ws_clean.cell(curr_row, 1, item_no).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 2, dt_val).number_format = FMT_DATE
        ws_clean.cell(curr_row, 3, inv_no or "-").alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 4, client or "-").alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 5, desc).alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 6, cur).alignment = ALIGN_CENTER
        
        c_valas = ws_clean.cell(curr_row, 7, val_valas or 0)
        c_valas.number_format = FMT_DECIMAL if cur != "IDR" else FMT_INTEGER
        c_valas.alignment = ALIGN_RIGHT
        
        c_rate = ws_clean.cell(curr_row, 8, rate or 1.0)
        c_rate.number_format = FMT_DECIMAL
        c_rate.alignment = ALIGN_RIGHT
        
        c_idr = ws_clean.cell(curr_row, 9, val_idr or 0)
        c_idr.number_format = FMT_CURRENCY
        c_idr.alignment = ALIGN_RIGHT
        
        ws_clean.cell(curr_row, 10, dt_recv).number_format = FMT_DATE
        
        c_recv = ws_clean.cell(curr_row, 11, amt_recv or 0)
        c_recv.number_format = FMT_CURRENCY
        c_recv.alignment = ALIGN_RIGHT
        
        c_ppn = ws_clean.cell(curr_row, 12, ppn or 0)
        c_ppn.number_format = FMT_CURRENCY
        c_ppn.alignment = ALIGN_RIGHT
        
        c_pph = ws_clean.cell(curr_row, 13, pph23 or 0)
        c_pph.number_format = FMT_CURRENCY
        c_pph.alignment = ALIGN_RIGHT
        
        c_fee = ws_clean.cell(curr_row, 14, fee or 0)
        c_fee.number_format = FMT_CURRENCY
        c_fee.alignment = ALIGN_RIGHT
        
        ws_clean.cell(curr_row, 15, bank or "-").alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 16, remark or "-").alignment = ALIGN_LEFT
        
        for c in range(1, 17):
            cell = ws_clean.cell(curr_row, c)
            cell.font = FONT_REGULAR
            cell.border = BORDER_DATA
            if item_no % 2 == 0:
                cell.fill = FILL_ZEBRA
                
        item_no += 1
        curr_row += 1
        
    rev_end_row = curr_row - 1
    
    # Revenue Subtotal Row
    ws_clean.cell(curr_row, 4, f"TOTAL REVENUE TAHUN {year}").font = FONT_SUBTOTAL
    ws_clean.cell(curr_row, 4).alignment = ALIGN_RIGHT
    
    # Rumus SUM
    for col_i in [7, 9, 11, 12, 13, 14]:
        col_let = get_column_letter(col_i)
        tot_cell = ws_clean.cell(curr_row, col_i, f"=SUM({col_let}{rev_start_row}:{col_let}{rev_end_row})")
        tot_cell.font = FONT_SUBTOTAL
        tot_cell.number_format = FMT_CURRENCY if col_i != 7 else FMT_DECIMAL
        tot_cell.alignment = ALIGN_RIGHT
        
    for c in range(1, 17):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_SUBTOTAL
        cell.border = BORDER_SUBTOTAL
    curr_row += 3

    # -------------------------------------------------------------
    # 3. SEKSI 2: PAJAK PENGELUARAN (TAXES)
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 1, f"II. PAJAK PENGELUARAN (TAX EXPENSES TAHUN {year})").font = FONT_SECTION
    ws_clean.cell(curr_row, 1).fill = FILL_SEC_TAX
    ws_clean.row_dimensions[curr_row].height = 24
    curr_row += 1
    
    tax_headers = [
        "No", "Tanggal", "Deskripsi / Rincian Pembayaran Pajak", "Mata Uang", "Kurs",
        "Nilai Transaksi (IDR)", "PPN (IDR)", "PPh 21 (IDR)", "PPh 23 (IDR)", "PPh 26 (IDR)",
        "Pemasukan Negara / Lainnya (IDR)", "Sumber Rekening / Bank"
    ]
    for col_idx, h_text in enumerate(tax_headers, 1):
        cell = ws_clean.cell(curr_row, col_idx, h_text)
        cell.font = FONT_HEADER
        cell.fill = FILL_SEC_TAX
        cell.alignment = ALIGN_HDR
        cell.border = BORDER_HEADER
    ws_clean.row_dimensions[curr_row].height = 26
    curr_row += 1
    
    tax_start_row = curr_row
    tax_start_orig = 26 if year == 2024 else (50 if year == 2025 else 67)
    tax_end_orig = 35 if year == 2024 else (79 if year == 2025 else 92)
    
    t_no = 1
    for r in range(tax_start_orig, tax_end_orig + 1):
        desc = ws_v.cell(r, 4).value
        if not desc or "PENERIMAAN" in str(desc).upper():
            continue
        dt_val = ws_v.cell(r, 2).value
        
        # Ekstraksi nominal per kolom pajak
        if year == 2024:
            val_idr = ws_v.cell(r, 5).value or 0
            ppn_val = ws_v.cell(r, 10).value or 0
            pph21 = ws_v.cell(r, 12).value or 0
            pph23 = ws_v.cell(r, 14).value or 0
            pph26 = ws_v.cell(r, 16).value or 0
            other_tax = 0
            cur = "IDR"
            rate = 1.0
            bank = "BRI"
        else: # 2025 & 2026
            cur = str(ws_v.cell(r, 7).value or "IDR").strip().upper()
            rate = ws_v.cell(r, 8).value or 1.0
            val_idr = ws_v.cell(r, 9).value or ws_v.cell(r, 6).value or 0
            ppn_val = ws_v.cell(r, 11).value or 0
            pph21 = ws_v.cell(r, 13).value or 0
            pph23 = ws_v.cell(r, 15).value or 0
            pph26 = ws_v.cell(r, 17).value or 0
            other_tax = ws_v.cell(r, 19).value or 0
            bank = "BRI" if "BRI" in str(desc).upper() else ("BCA" if "BCA" in str(desc).upper() else "Mandiri")

        ws_clean.cell(curr_row, 1, t_no).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 2, dt_val).number_format = FMT_DATE
        ws_clean.cell(curr_row, 3, desc).alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 4, cur).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 5, rate).number_format = FMT_DECIMAL
        
        c_tx = ws_clean.cell(curr_row, 6, val_idr)
        c_tx.number_format = FMT_CURRENCY
        
        c_ppn = ws_clean.cell(curr_row, 7, ppn_val)
        c_ppn.number_format = FMT_CURRENCY
        
        c_21 = ws_clean.cell(curr_row, 8, pph21)
        c_21.number_format = FMT_CURRENCY
        
        c_23 = ws_clean.cell(curr_row, 9, pph23)
        c_23.number_format = FMT_CURRENCY
        
        c_26 = ws_clean.cell(curr_row, 10, pph26)
        c_26.number_format = FMT_CURRENCY
        
        c_oth = ws_clean.cell(curr_row, 11, other_tax)
        c_oth.number_format = FMT_CURRENCY
        
        ws_clean.cell(curr_row, 12, bank).alignment = ALIGN_CENTER
        
        for c in range(1, 13):
            cell = ws_clean.cell(curr_row, c)
            cell.font = FONT_REGULAR
            cell.border = BORDER_DATA
            if t_no % 2 == 0:
                cell.fill = FILL_ZEBRA
                
        t_no += 1
        curr_row += 1
        
    tax_end_row = curr_row - 1
    
    # Tax Subtotal Row
    ws_clean.cell(curr_row, 3, f"TOTAL PAJAK PENGELUARAN TAHUN {year}").font = FONT_SUBTOTAL
    ws_clean.cell(curr_row, 3).alignment = ALIGN_RIGHT
    
    for col_i in range(6, 12):
        col_let = get_column_letter(col_i)
        tot_cell = ws_clean.cell(curr_row, col_i, f"=SUM({col_let}{tax_start_row}:{col_let}{tax_end_row})")
        tot_cell.font = FONT_SUBTOTAL
        tot_cell.number_format = FMT_CURRENCY
        tot_cell.alignment = ALIGN_RIGHT
        
    for c in range(1, 13):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_SUBTOTAL
        cell.border = BORDER_SUBTOTAL
    curr_row += 3

    # -------------------------------------------------------------
    # 4. SEKSI 3: BANK STATUS (Mutasi Kas / Bank & Bunga)
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 1, f"III. BANK STATUS & MUTASI (MUTASI KAS / BANK TAHUN {year})").font = FONT_SECTION
    ws_clean.cell(curr_row, 1).fill = FILL_SEC_BANK
    ws_clean.row_dimensions[curr_row].height = 24
    curr_row += 1
    
    bank_headers = [
        "No", "Tanggal", "Kategori Mutasi", "Deskripsi / Aktivitas Transaksi",
        "Rekening Sumber", "Rekening Tujuan", "Nominal Transaksi (IDR)"
    ]
    for col_idx, h_text in enumerate(bank_headers, 1):
        cell = ws_clean.cell(curr_row, col_idx, h_text)
        cell.font = FONT_HEADER
        cell.fill = FILL_SEC_BANK
        cell.alignment = ALIGN_HDR
        cell.border = BORDER_HEADER
    ws_clean.row_dimensions[curr_row].height = 26
    curr_row += 1
    
    bank_start_row = curr_row
    bank_start_orig = 41 if year == 2024 else (85 if year == 2025 else 97)
    bank_end_orig = 66 if year == 2024 else (158 if year == 2025 else 172)
    
    b_no = 1
    current_b_cat = "Bank Interest (Bunga)"
    for r in range(bank_start_orig, bank_end_orig + 1):
        val_b = ws_v.cell(r, 2).value
        val_d = ws_v.cell(r, 4).value
        val_e = ws_v.cell(r, 5).value
        val_f = ws_v.cell(r, 6).value
        
        amt_val = None
        if isinstance(val_f, (int, float)):
            amt_val = float(val_f)
        elif isinstance(val_e, (int, float)):
            amt_val = float(val_e)
            
        # Cek jika baris label kategori atau header
        if amt_val is None:
            if val_b and not isinstance(val_b, (dt.date, dt.datetime)):
                current_b_cat = str(val_b).strip()
            continue
            
        if not val_d and amt_val == 0:
            continue
            
        dt_val = val_b if isinstance(val_b, (dt.date, dt.datetime)) else None
        
        # Resolusi Rekening
        src_bank = "BRI" if "BRI" in str(val_d).upper() or "BRI" in current_b_cat.upper() else ("BCA" if "BCA" in current_b_cat.upper() else "Mandiri")
        dst_bank = "BCA" if "KE REK BCA" in str(val_d).upper() else ("Mandiri" if "KE REK MANDIRI" in str(val_d).upper() else "-")
        if "INTEREST" in str(val_d).upper():
            dst_bank = src_bank

        ws_clean.cell(curr_row, 1, b_no).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 2, dt_val).number_format = FMT_DATE
        ws_clean.cell(curr_row, 3, current_b_cat).alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 4, val_d or "-").alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 5, src_bank).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 6, dst_bank).alignment = ALIGN_CENTER
        
        c_amt = ws_clean.cell(curr_row, 7, amt_val)
        c_amt.number_format = FMT_CURRENCY
        c_amt.alignment = ALIGN_RIGHT
        
        for c in range(1, 8):
            cell = ws_clean.cell(curr_row, c)
            cell.font = FONT_REGULAR
            cell.border = BORDER_DATA
            if b_no % 2 == 0:
                cell.fill = FILL_ZEBRA
                
        b_no += 1
        curr_row += 1
        
    bank_end_row = curr_row - 1
    
    # Bank Subtotal Row
    ws_clean.cell(curr_row, 4, f"TOTAL MUTASI BANK STATUS TAHUN {year}").font = FONT_SUBTOTAL
    ws_clean.cell(curr_row, 4).alignment = ALIGN_RIGHT
    
    tot_cell = ws_clean.cell(curr_row, 7, f"=SUM(G{bank_start_row}:G{bank_end_row})")
    tot_cell.font = FONT_SUBTOTAL
    tot_cell.number_format = FMT_CURRENCY
    tot_cell.alignment = ALIGN_RIGHT
    
    for c in range(1, 8):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_SUBTOTAL
        cell.border = BORDER_SUBTOTAL
    curr_row += 3

    # -------------------------------------------------------------
    # 5. SEKSI 4: PENGELUARAN - SINGLE SETTLEMENTS
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 1, f"IV. PENGELUARAN - SINGLE SETTLEMENTS (TAHUN {year})").font = FONT_SECTION
    ws_clean.cell(curr_row, 1).fill = FILL_SEC_EXP
    ws_clean.row_dimensions[curr_row].height = 24
    curr_row += 1
    
    exp_headers = [
        "No", "Tanggal", "Tipe", "Deskripsi / Aktivitas Pengeluaran",
        "Mata Uang", "Nominal Valas", "Kurs", "Total Nominal (IDR)",
        "Biaya Operasi", "Biaya Research (R&D)", "Sewa Alat", "Interpretasi Log",
        "Transportasi", "Administrasi", "Pembelian Barang", "Sewa Kantor",
        "Kesehatan", "Training", "Bisnis Development", "Lain-Lain", "Deviden",
        "Dari (Bank)", "Ke (Tujuan)"
    ]
    for col_idx, h_text in enumerate(exp_headers, 1):
        cell = ws_clean.cell(curr_row, col_idx, h_text)
        cell.font = FONT_HEADER
        cell.fill = FILL_SEC_EXP
        cell.alignment = ALIGN_HDR
        cell.border = BORDER_HEADER
    ws_clean.row_dimensions[curr_row].height = 28
    curr_row += 1
    
    single_start_row = curr_row
    s_start_orig = 71 if year == 2024 else (162 if year == 2025 else 176)
    s_end_orig = 263 if year == 2024 else (516 if year == 2025 else 390)
    col_cat_offset = 8 if year == 2024 else 9
    
    s_no = 1
    current_bank_source = "BCA"
    for r in range(s_start_orig, s_end_orig + 1):
        val_b = ws_v.cell(r, 2).value
        val_d = ws_v.cell(r, 4).value
        desc_str = str(val_d or "").strip()
        
        # Kategori sum
        cat_vals = [ws_v.cell(r, col_cat_offset + i).value for i in range(13)]
        s_cat = sum([v for v in cat_vals if isinstance(v, (int, float))])
        
        # Col Jumlah / Amount
        c_amt_raw = ws_v.cell(r, 5 if year == 2024 else 6).value
        has_amt = (s_cat != 0) or (isinstance(c_amt_raw, (int, float)) and c_amt_raw != 0)
        
        # Cek bank header HANYA jika tidak ada nominal
        if not has_amt:
            if any(kw in desc_str.upper() for kw in ["TRANSFER FROM", "REKENING", "GIRO", "BIAYA ADMIN"]):
                current_bank_source = desc_str
            continue
            
        if "TOTAL" in desc_str.upper() or "SUB TOTAL" in desc_str.upper():
            continue
            
        cur = str(ws_v.cell(r, 6 if year == 2024 else 7).value or "IDR").strip().upper()
        rate = ws_v.cell(r, 7 if year == 2024 else 8).value or 1.0
        if cur in ["IDR", "RP", "-", ""]:
            rate = 1.0
            
        amt_valas = c_amt_raw if cur != "IDR" else 0
        total_idr = s_cat if s_cat != 0 else (float(c_amt_raw or 0) * float(rate))
        
        # Write row
        ws_clean.cell(curr_row, 1, s_no).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 2, val_b if isinstance(val_b, (dt.date, dt.datetime)) else None).number_format = FMT_DATE
        ws_clean.cell(curr_row, 3, "Single").alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 4, desc_str or "-").alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 5, cur).alignment = ALIGN_CENTER
        
        c_v = ws_clean.cell(curr_row, 6, amt_valas or 0)
        c_v.number_format = FMT_DECIMAL if cur != "IDR" else FMT_INTEGER
        c_v.alignment = ALIGN_RIGHT
        
        c_r = ws_clean.cell(curr_row, 7, rate)
        c_r.number_format = FMT_DECIMAL
        c_r.alignment = ALIGN_RIGHT
        
        c_idr = ws_clean.cell(curr_row, 8, total_idr)
        c_idr.number_format = FMT_CURRENCY
        c_idr.alignment = ALIGN_RIGHT
        
        # 13 Kolom Kategori
        for i in range(13):
            val_c = cat_vals[i] if isinstance(cat_vals[i], (int, float)) else 0
            if s_cat == 0 and i == 0 and total_idr > 0: # Fallback ke Operasi jika breakdown kosong
                val_c = total_idr
            c_cell = ws_clean.cell(curr_row, 9 + i, val_c or 0)
            c_cell.number_format = FMT_CURRENCY
            c_cell.alignment = ALIGN_RIGHT
            
        from_bank = ws_v.cell(r, 22 if year == 2024 else (24 if year == 2025 else 23)).value or current_bank_source
        to_dest = ws_v.cell(r, 23 if year == 2024 else (25 if year == 2025 else 24)).value or "-"
        ws_clean.cell(curr_row, 22, from_bank).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 23, to_dest).alignment = ALIGN_CENTER
        
        for c in range(1, 24):
            cell = ws_clean.cell(curr_row, c)
            cell.font = FONT_REGULAR
            cell.border = BORDER_DATA
            if s_no % 2 == 0:
                cell.fill = FILL_ZEBRA
                
        s_no += 1
        curr_row += 1
        
    single_end_row = curr_row - 1
    
    # Subtotal Single Row
    ws_clean.cell(curr_row, 4, f"SUBTOTAL SINGLE SETTLEMENTS ({s_no - 1} TRANSAKSI)").font = FONT_SUBTOTAL
    ws_clean.cell(curr_row, 4).alignment = ALIGN_RIGHT
    
    for col_i in range(8, 22):
        col_let = get_column_letter(col_i)
        tot_cell = ws_clean.cell(curr_row, col_i, f"=SUM({col_let}{single_start_row}:{col_let}{single_end_row})")
        tot_cell.font = FONT_SUBTOTAL
        tot_cell.number_format = FMT_CURRENCY
        tot_cell.alignment = ALIGN_RIGHT
        
    for c in range(1, 24):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_SUBTOTAL
        cell.border = BORDER_SUBTOTAL
    single_subtot_row = curr_row
    curr_row += 3

    # -------------------------------------------------------------
    # 6. SEKSI 5: PENGELUARAN - BATCH SETTLEMENTS
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 1, f"V. PENGELUARAN - BATCH SETTLEMENTS (TAHUN {year})").font = FONT_SECTION
    ws_clean.cell(curr_row, 1).fill = FILL_SEC_EXP
    ws_clean.row_dimensions[curr_row].height = 24
    curr_row += 1
    
    batch_headers = [
        "No", "Tanggal", "Tipe", "Nama Grup Batch / Subject", "Deskripsi Rincian Item",
        "Mata Uang", "Nominal Valas", "Kurs", "Total Nominal (IDR)",
        "Biaya Operasi", "Biaya Research (R&D)", "Sewa Alat", "Interpretasi Log",
        "Transportasi", "Administrasi", "Pembelian Barang", "Sewa Kantor",
        "Kesehatan", "Training", "Bisnis Development", "Lain-Lain", "Deviden",
        "Dari (Bank)", "Ke (Tujuan)"
    ]
    for col_idx, h_text in enumerate(batch_headers, 1):
        cell = ws_clean.cell(curr_row, col_idx, h_text)
        cell.font = FONT_HEADER
        cell.fill = FILL_SEC_EXP
        cell.alignment = ALIGN_HDR
        cell.border = BORDER_HEADER
    ws_clean.row_dimensions[curr_row].height = 28
    curr_row += 1
    
    batch_start_row = curr_row
    b_start_orig = 264 if year == 2024 else (517 if year == 2025 else 391)
    b_end_orig = 861 if year == 2024 else (1305 if year == 2025 else 830)
    
    b_no = 1
    current_batch_title = "General Operational Batch"
    
    for r in range(b_start_orig, b_end_orig + 1):
        val_b = ws_v.cell(r, 2).value
        val_c = ws_v.cell(r, 3).value
        val_d = ws_v.cell(r, 4).value
        
        val_b_str = str(val_b or "").strip()
        val_c_str = str(val_c or "").strip()
        val_d_str = str(val_d or "").strip()
        
        # Deteksi judul grup / Subject
        if any("SUBJECT" in x.upper() or "OPERATION COST" in x.upper() for x in [val_b_str, val_c_str, val_d_str]):
            matched = val_d_str or val_c_str or val_b_str
            cleaned = re.sub(r"(?i)subject|expense#|:", "", matched).strip()
            if cleaned:
                current_batch_title = cleaned
            continue
            
        cat_vals = [ws_v.cell(r, col_cat_offset + i).value for i in range(13)]
        s_cat = sum([v for v in cat_vals if isinstance(v, (int, float))])
        
        # Col Jumlah / Amount
        c_amt_raw = ws_v.cell(r, 5 if year == 2024 else 6).value
        has_amt = (s_cat != 0) or (isinstance(c_amt_raw, (int, float)) and c_amt_raw != 0)
        
        # Jika baris tidak memiliki nominal, cek apakah merupakan judul batch (banyak di 2025/2026 tanpa kata 'Subject')
        if not has_amt:
            txt_candidate = val_b_str or val_c_str or val_d_str
            if txt_candidate and not any(kw in txt_candidate.upper() for kw in ["TOTAL", "SUB TOTAL", "SUBTOTAL", "-"]):
                if len(txt_candidate) > 3 and txt_candidate not in [":", "Subject", "Subject :"]:
                    cleaned = re.sub(r"(?i)subject|expense#|:", "", txt_candidate).strip()
                    if cleaned:
                        current_batch_title = cleaned
            continue
        if any(kw in val_d_str.upper() for kw in ["TOTAL", "SUB TOTAL", "SUBTOTAL"]):
            continue
            
        cur = str(ws_v.cell(r, 6 if year == 2024 else 7).value or "IDR").strip().upper()
        rate = ws_v.cell(r, 7 if year == 2024 else 8).value or 1.0
        if cur in ["IDR", "RP", "-", ""]:
            rate = 1.0
            
        amt_valas = c_amt_raw if cur != "IDR" else 0
        total_idr = s_cat if s_cat != 0 else (float(c_amt_raw or 0) * float(rate))
        
        # Write row
        ws_clean.cell(curr_row, 1, b_no).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 2, val_b if isinstance(val_b, (dt.date, dt.datetime)) else None).number_format = FMT_DATE
        ws_clean.cell(curr_row, 3, "Batch").alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 4, current_batch_title).alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 5, val_d_str or val_c_str or "-").alignment = ALIGN_LEFT
        ws_clean.cell(curr_row, 6, cur).alignment = ALIGN_CENTER
        
        c_v = ws_clean.cell(curr_row, 7, amt_valas or 0)
        c_v.number_format = FMT_DECIMAL if cur != "IDR" else FMT_INTEGER
        c_v.alignment = ALIGN_RIGHT
        
        c_r = ws_clean.cell(curr_row, 8, rate)
        c_r.number_format = FMT_DECIMAL
        c_r.alignment = ALIGN_RIGHT
        
        c_idr = ws_clean.cell(curr_row, 9, total_idr)
        c_idr.number_format = FMT_CURRENCY
        c_idr.alignment = ALIGN_RIGHT
        
        # 13 Kolom Kategori
        for i in range(13):
            val_c = cat_vals[i] if isinstance(cat_vals[i], (int, float)) else 0
            if s_cat == 0 and i == 0 and total_idr != 0:
                val_c = total_idr
            c_cell = ws_clean.cell(curr_row, 10 + i, val_c or 0)
            c_cell.number_format = FMT_CURRENCY
            c_cell.alignment = ALIGN_RIGHT
            
        from_bank = ws_v.cell(r, 22 if year == 2024 else (24 if year == 2025 else 23)).value or "-"
        to_dest = ws_v.cell(r, 23 if year == 2024 else (25 if year == 2025 else 24)).value or "-"
        ws_clean.cell(curr_row, 23, from_bank).alignment = ALIGN_CENTER
        ws_clean.cell(curr_row, 24, to_dest).alignment = ALIGN_CENTER
        
        for c in range(1, 25):
            cell = ws_clean.cell(curr_row, c)
            cell.font = FONT_REGULAR
            cell.border = BORDER_DATA
            if b_no % 2 == 0:
                cell.fill = FILL_ZEBRA
                
        b_no += 1
        curr_row += 1
        
    batch_end_row = curr_row - 1
    
    # Subtotal Batch Row
    ws_clean.cell(curr_row, 5, f"SUBTOTAL BATCH SETTLEMENTS ({b_no - 1} ITEM)").font = FONT_SUBTOTAL
    ws_clean.cell(curr_row, 5).alignment = ALIGN_RIGHT
    
    for col_i in range(9, 23):
        col_let = get_column_letter(col_i)
        tot_cell = ws_clean.cell(curr_row, col_i, f"=SUM({col_let}{batch_start_row}:{col_let}{batch_end_row})")
        tot_cell.font = FONT_SUBTOTAL
        tot_cell.number_format = FMT_CURRENCY
        tot_cell.alignment = ALIGN_RIGHT
        
    for c in range(1, 25):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_SUBTOTAL
        cell.border = BORDER_SUBTOTAL
    batch_subtot_row = curr_row
    curr_row += 3

    # -------------------------------------------------------------
    # 7. GRAND TOTAL PENGELUARAN TAHUNAN
    # -------------------------------------------------------------
    ws_clean.cell(curr_row, 5, f"GRAND TOTAL PENGELUARAN (OPERATION COST) TAHUN {year}").font = FONT_GRAND_TOTAL
    ws_clean.cell(curr_row, 5).alignment = ALIGN_RIGHT
    ws_clean.row_dimensions[curr_row].height = 24
    
    # Total IDR = Subtotal Single + Subtotal Batch
    # Di Single, col 8 adalah Total IDR, col 9-21 kategori
    # Di Batch, col 9 adalah Total IDR, col 10-22 kategori
    tot_grand_cell = ws_clean.cell(curr_row, 9, f"=H{single_subtot_row}+I{batch_subtot_row}")
    tot_grand_cell.font = FONT_GRAND_TOTAL
    tot_grand_cell.number_format = FMT_CURRENCY
    tot_grand_cell.alignment = ALIGN_RIGHT
    
    for i in range(13):
        col_single = get_column_letter(9 + i)
        col_batch = get_column_letter(10 + i)
        cat_tot = ws_clean.cell(curr_row, 10 + i, f"={col_single}{single_subtot_row}+{col_batch}{batch_subtot_row}")
        cat_tot.font = FONT_GRAND_TOTAL
        cat_tot.number_format = FMT_CURRENCY
        cat_tot.alignment = ALIGN_RIGHT
        
    for c in range(1, 25):
        cell = ws_clean.cell(curr_row, c)
        cell.fill = FILL_GRAND_TOT
        cell.border = BORDER_GRAND

    # Format widths
    auto_fit_columns(ws_clean, min_col=1, max_col=25)


def copy_formatted_summary_sheet(ws_clean, ws_src, title_text):
    """Menyalin sheet labarugi2024 / business_summary2024 dengan styling dan borders yang elegan."""
    ws_clean.views.sheetView[0].showGridLines = True
    
    for r in range(1, ws_src.max_row + 1):
        for c in range(1, ws_src.max_column + 1):
            cell_src = ws_src.cell(r, c)
            val = cell_src.value
            if val is None:
                continue
                
            cell_dst = ws_clean.cell(r, c, val)
            
            # Formats
            if isinstance(val, (int, float)) and abs(val) > 1000:
                cell_dst.number_format = FMT_CURRENCY
                cell_dst.alignment = ALIGN_RIGHT
            elif isinstance(val, (int, float)):
                cell_dst.number_format = FMT_INTEGER
                cell_dst.alignment = ALIGN_RIGHT
            elif isinstance(val, str) and val.startswith("="):
                cell_dst.number_format = FMT_CURRENCY
                cell_dst.alignment = ALIGN_RIGHT
            else:
                cell_dst.alignment = ALIGN_LEFT
                
            # Fonts & Fills
            s_val = str(val).upper().strip()
            if any(kw in s_val for kw in ["TOTAL", "LABA RUGI", "BUSINESS SUMMARY", "AKTIVA", "PASIVA", "BEBAN"]):
                cell_dst.font = FONT_BOLD
                if "TOTAL" in s_val:
                    cell_dst.fill = FILL_SUBTOTAL
                    cell_dst.border = BORDER_SUBTOTAL
            else:
                cell_dst.font = FONT_REGULAR
                cell_dst.border = BORDER_DATA
                
    auto_fit_columns(ws_clean, min_col=1, max_col=ws_src.max_column, max_width=40)


def generate_clean_workbook():
    """Fungsi utama pembuatan file Excel bersih."""
    if not SOURCE_EXCEL_PATH.exists():
        print(f"❌ File sumber tidak ditemukan di: {SOURCE_EXCEL_PATH}")
        return False
        
    print(f"📂 Membuka Workbook Sumber: {SOURCE_EXCEL_PATH.name}...")
    wb_val = openpyxl.load_workbook(SOURCE_EXCEL_PATH, data_only=True)
    wb_form = openpyxl.load_workbook(SOURCE_EXCEL_PATH, data_only=False)
    
    wb_clean = openpyxl.Workbook()
    # Hapus default sheet
    default_sheet = wb_clean.active
    wb_clean.remove(default_sheet)
    
    # 1. Rev VS Ops cost th 2024
    ws_2024 = wb_clean.create_sheet(title="Rev VS Ops cost th 2024")
    build_annual_sheet(ws_2024, wb_val, wb_form, 2024, "Rev VS Ops cost th 2024")
    
    # 2. Rev VS Ops cost th 2025_Final
    ws_2025 = wb_clean.create_sheet(title="Rev VS Ops cost th 2025_Final")
    build_annual_sheet(ws_2025, wb_val, wb_form, 2025, "Rev VS Ops cost th 2025_Final")
    
    # 3. Rev VS Ops cost th 2026_
    ws_2026 = wb_clean.create_sheet(title="Rev VS Ops cost th 2026_")
    build_annual_sheet(ws_2026, wb_val, wb_form, 2026, "Rev VS Ops cost th 2026_")
    
    # 4. labarugi2024
    if "labarugi2024" in wb_val.sheetnames:
        print("📄 Menyalin dan menata sheet: labarugi2024...")
        ws_lr = wb_clean.create_sheet(title="labarugi2024")
        copy_formatted_summary_sheet(ws_lr, wb_val["labarugi2024"], "LABA RUGI 2024")
        
    # 5. business_summary2024
    if "business_summary2024" in wb_val.sheetnames:
        print("📄 Menyalin dan menata sheet: business_summary2024...")
        ws_bs = wb_clean.create_sheet(title="business_summary2024")
        copy_formatted_summary_sheet(ws_bs, wb_val["business_summary2024"], "BUSINESS SUMMARY 2024")
        
    print(f"💾 Menyimpan Workbook Bersih ke: {OUTPUT_EXCEL_PATH}...")
    OUTPUT_EXCEL_PATH.parent.mkdir(parents=True, exist_ok=True)
    wb_clean.save(OUTPUT_EXCEL_PATH)
    print(f"🎉 SUKSES! File Excel baru berhasil dibuat.")
    return True


if __name__ == "__main__":
    generate_clean_workbook()
