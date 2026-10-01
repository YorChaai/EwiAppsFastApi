import openpyxl
import os

excel_path = r"D:\Aplikasi\EWIApps\data\excel\20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"
sheet_name = "Rev VS Ops cost th 2026_"

wb = openpyxl.load_workbook(excel_path, data_only=True)
ws = wb[sheet_name]

print(f"Loaded sheet: {sheet_name}")
print(f"Max row: {ws.max_row}, Max col: {ws.max_column}")

# Row 174 to 390 (Single Mode)
print("\n=== ANALISIS SINGLE MODE (Row 174 - 390) ===")
single_rows_valid = []
single_rows_skipped = []

for r in range(176, 391):
    # Check col 2 (date), col 4 (desc), col 5-8 (values)
    date_val = ws.cell(r, 2).value
    desc_val = ws.cell(r, 4).value
    
    # Check all cols for amount
    has_amount = False
    amounts = []
    for c in range(5, 25):
        v = ws.cell(r, c).value
        if isinstance(v, (int, float)) and v > 0:
            has_amount = True
            amounts.append((c, v))
            
    is_valid = bool(desc_val and str(desc_val).strip() and (date_val or has_amount))
    
    # Check if bank header or section header
    row_text = " ".join([str(ws.cell(r, c).value or "") for c in range(1, 10)]).strip().upper()
    is_bank_header = any(b in row_text for b in ["REK BCA", "REK BRI", "REK MANDIRI", "MANDIRI VALAS", "MANDIRI BISNIS", "BRI GIRO", "BCA GIRO"]) and not has_amount
    is_subtotal = "TOTAL" in row_text or "SUB TOTAL" in row_text or "BALANCE" in row_text

    if is_bank_header:
        single_rows_skipped.append((r, "Bank Header", row_text[:50]))
    elif is_subtotal:
        single_rows_skipped.append((r, "Subtotal / Balance", row_text[:50]))
    elif not str(row_text).strip():
        single_rows_skipped.append((r, "Empty Row", ""))
    elif not has_amount and not date_val:
        single_rows_skipped.append((r, "No Date & No Amount", row_text[:50]))
    else:
        single_rows_valid.append((r, date_val, desc_val, amounts))

print(f"Total baris di rentang 176-390: {390 - 176 + 1}")
print(f"Baris Valid (Transaksi Single): {len(single_rows_valid)}")
print(f"Baris Dilewati (Header / Subtotal / Kosong): {len(single_rows_skipped)}")

print("\nRincian Baris yang Dilewati di Single Mode (176-390):")
for r, reason, text in single_rows_skipped:
    print(f"  Row {r:3d}: [{reason:20s}] {text}")

# Row 391 to 830 (Batch Mode)
print("\n=== ANALISIS BATCH MODE (Row 391 - 830) ===")
batch_groups = []
current_group = None
batch_items_count = 0

for r in range(391, min(835, ws.max_row + 1)):
    # Check font or style for group title
    # In v14, manual title is detected
    col2 = ws.cell(r, 2).value
    col4 = ws.cell(r, 4).value
    row_text = " ".join([str(ws.cell(r, c).value or "") for c in range(1, 10)]).strip()
    
    # Check amounts
    has_amount = False
    for c in range(5, 25):
        v = ws.cell(r, c).value
        if isinstance(v, (int, float)) and v > 0:
            has_amount = True
            break
            
    # Check if this row is a Group Header
    # Typically Arial 10/11 Bold or specific pattern
    # Let's inspect rows around 391-830
    if ("Expenses" in str(col4) or "Job" in str(col4) or "Trip" in str(col4) or "EXPENSES" in str(col4) or "Operation" in str(col4) or "MCU" in str(col4) or "Shipment" in str(col4)) and not has_amount:
        if current_group:
            batch_groups.append(current_group)
        current_group = {"header_row": r, "title": str(col4).strip(), "items": []}
    elif has_amount and current_group:
        current_group["items"].append(r)
        batch_items_count += 1
    elif "TOTAL" in row_text.upper():
        pass

if current_group:
    batch_groups.append(current_group)

print(f"Grup Batch terdeteksi secara teks: {len(batch_groups)}")
print(f"Total baris pengeluaran dalam Batch: {batch_items_count}")
