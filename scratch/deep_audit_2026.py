import openpyxl
import re
import datetime as dt
from openpyxl.utils.cell import column_index_from_string

excel_path = r"D:\Aplikasi\EWIApps\data\excel\20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"
sheet_name = "Rev VS Ops cost th 2026_"

wb_val = openpyxl.load_workbook(excel_path, data_only=True)
wb_form = openpyxl.load_workbook(excel_path, data_only=False)

ws_v = wb_val[sheet_name]
ws_f = wb_form[sheet_name]

print(f"=== AUDIT SHEET: {sheet_name} ===")
print(f"Total Rows: {ws_v.max_row}, Total Cols: {ws_v.max_column}")

# 1. Check Row 174-175
print("\n--- Header Rows (170-176) ---")
for r in range(170, 177):
    row_vals = [f"Col {c}: {ws_v.cell(r, c).value}" for c in range(1, 12) if ws_v.cell(r, c).value is not None]
    print(f"Row {r}: {' | '.join(row_vals)}")

# 2. Check Single Rows (176 to 390)
print("\n--- Single Rows (176 to 390) ---")
single_valid = []
single_skipped = []

for r in range(176, 391):
    val_b = ws_v.cell(r, 2).value  # Date
    val_d = ws_v.cell(r, 4).value  # Desc
    
    # Check all numeric values in expense columns
    amounts = {}
    for c in range(5, 30):
        v = ws_v.cell(r, c).value
        if isinstance(v, (int, float)) and v != 0:
            amounts[c] = v
            
    # Check if empty
    all_empty = all(ws_v.cell(r, c).value is None for c in range(1, 35))
    desc_str = str(val_d or "").strip()
    
    if all_empty:
        single_skipped.append((r, "EMPTY ROW", ""))
    elif "TOTAL" in desc_str.upper() or "SUB TOTAL" in desc_str.upper():
        single_skipped.append((r, "SUBTOTAL", desc_str))
    elif not amounts and not isinstance(val_b, (dt.date, dt.datetime)):
        # header text like TRANSFER FROM BRI, etc.
        single_skipped.append((r, "HEADER / LABEL", desc_str or str(ws_v.cell(r, 2).value)))
    else:
        single_valid.append((r, val_b, desc_str, amounts))

print(f"Total Baris 176-390: {390 - 176 + 1}")
print(f"Single Valid Rows: {len(single_valid)}")
print(f"Single Skipped Rows: {len(single_skipped)}")

print("\nDetail Skipped Rows di 176-390:")
for r, reason, text in single_skipped:
    print(f"  Row {r:3d}: [{reason:15s}] {text}")

# 3. Check Transition at Row 390-395
print("\n--- Transition at Row 388-395 ---")
for r in range(388, 396):
    row_vals = [f"Col {c}: {ws_v.cell(r, c).value}" for c in range(1, 10) if ws_v.cell(r, c).value is not None]
    print(f"Row {r}: {' | '.join(row_vals)}")

# 4. Check Batch Section (391 to max_row)
print("\n--- Batch Section (391 to max_row) ---")
# Let's inspect what is in rows 391 to 830 and beyond 830
rows_beyond_830 = []
for r in range(831, ws_v.max_row + 1):
    vals = [f"Col {c}: {ws_v.cell(r, c).value}" for c in range(1, 15) if ws_v.cell(r, c).value is not None]
    if vals:
        rows_beyond_830.append((r, vals))

print(f"Total rows with data beyond 830: {len(rows_beyond_830)}")
if rows_beyond_830:
    print("Contoh data setelah baris 830:")
    for r, vals in rows_beyond_830[:10]:
        print(f"  Row {r}: {' | '.join(vals)}")

