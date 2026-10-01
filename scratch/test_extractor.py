import openpyxl

wb_orig = openpyxl.load_workbook('data/excel/20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx', data_only=True)
wb_form = openpyxl.load_workbook('data/excel/20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx', data_only=False)

def test_extract_2024():
    ws_v = wb_orig['Rev VS Ops cost th 2024']
    ws_f = wb_form['Rev VS Ops cost th 2024']
    
    # 1. Revenue: rows 7 to 20
    rev_items = []
    for r in range(7, 21):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value
        if d and amt:
            rev_items.append((r, d, amt))
    print(f"2024 Revenue items: {len(rev_items)}, sum: {sum(x[2] for x in rev_items):,.2f}")
    
    # 2. Tax: rows 26 to 35
    tax_items = []
    for r in range(26, 36):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value
        if d and amt:
            tax_items.append((r, d, amt))
    print(f"2024 Tax items: {len(tax_items)}, sum: {sum(x[2] for x in tax_items):,.2f}")

    # 3. Bank: rows 42 to 66
    bank_items = []
    for r in range(41, 67):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value
        if amt:
            bank_items.append((r, d, amt))
    print(f"2024 Bank items: {len(bank_items)}, sum: {sum(x[2] for x in bank_items):,.2f}")

    # 4. Single: rows 71 to 263
    single_items = []
    for r in range(71, 264):
        d = ws_v.cell(r, 4).value
        s = sum([ws_v.cell(r, c).value for c in range(8, 21) if isinstance(ws_v.cell(r, c).value, (int, float))])
        if s > 0:
            single_items.append((r, d, s))
    print(f"2024 Single items: {len(single_items)}, sum: {sum(x[2] for x in single_items):,.2f}")

    # 5. Batch: rows 264 to 861
    batch_items = []
    for r in range(264, 862):
        d = ws_v.cell(r, 4).value or ws_v.cell(r, 3).value
        s = sum([ws_v.cell(r, c).value for c in range(8, 21) if isinstance(ws_v.cell(r, c).value, (int, float))])
        if s > 0:
            batch_items.append((r, d, s))
    print(f"2024 Batch items: {len(batch_items)}, sum: {sum(x[2] for x in batch_items):,.2f}")
    
def test_extract_2025():
    ws_v = wb_orig['Rev VS Ops cost th 2025_Final']
    
    # 1. Revenue: rows 7 to 44
    rev_items = []
    for r in range(7, 45):
        d = ws_v.cell(r, 4).value
        # Col 6 is IDR, Col 5 is USD
        amt_idr = ws_v.cell(r, 6).value
        amt_usd = ws_v.cell(r, 5).value
        if d and (amt_idr or amt_usd):
            rev_items.append((r, d, amt_idr or 0, amt_usd or 0))
    print(f"\n2025 Revenue items: {len(rev_items)}, sum IDR: {sum(x[2] for x in rev_items):,.2f}, sum USD: {sum(x[3] for x in rev_items):,.2f}")
    
    # 2. Tax: rows 49 to 80
    tax_items = []
    for r in range(49, 81):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value or ws_v.cell(r, 6).value
        if d and amt:
            tax_items.append((r, d, amt))
    print(f"2025 Tax items: {len(tax_items)}, sum: {sum(x[2] for x in tax_items):,.2f}")

    # 3. Bank: rows 85 to 158
    bank_items = []
    for r in range(85, 159):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value or ws_v.cell(r, 6).value
        if amt:
            bank_items.append((r, d, amt))
    print(f"2025 Bank items: {len(bank_items)}, sum: {sum(x[2] for x in bank_items):,.2f}")

    # 4. Single: rows 162 to 516
    single_items = []
    for r in range(162, 517):
        d = ws_v.cell(r, 4).value
        desc_str = str(d or '').strip().upper()
        if 'TOTAL' in desc_str or 'SUB TOTAL' in desc_str:
            continue
        s = sum([ws_v.cell(r, c).value for c in range(9, 22) if isinstance(ws_v.cell(r, c).value, (int, float))])
        c6 = ws_v.cell(r, 6).value if isinstance(ws_v.cell(r, 6).value, (int, float)) else 0
        amt = s if s > 0 else c6
        if amt > 0:
            single_items.append((r, d, amt))
    print(f"2025 Single items: {len(single_items)}, sum: {sum(x[2] for x in single_items):,.2f}")

    # 5. Batch: rows 517 to 1305
    batch_items = []
    for r in range(517, 1306):
        d = ws_v.cell(r, 4).value or ws_v.cell(r, 3).value
        desc_str = str(d or '').strip().upper()
        if desc_str in ['TOTAL', 'SUBTOTAL', 'SUB TOTAL', '-']:
            continue
        s = sum([ws_v.cell(r, c).value for c in range(9, 22) if isinstance(ws_v.cell(r, c).value, (int, float))])
        c6 = ws_v.cell(r, 6).value if isinstance(ws_v.cell(r, 6).value, (int, float)) else 0
        c5 = ws_v.cell(r, 5).value if isinstance(ws_v.cell(r, 5).value, (int, float)) else 0
        cur_val = str(ws_v.cell(r, 7).value or 'IDR').strip().upper()
        rate_val = ws_v.cell(r, 8).value
        rate = float(rate_val) if isinstance(rate_val, (int, float)) and rate_val > 0 else 1.0
        if cur_val in ['IDR', 'RP', '-', '']:
            rate = 1.0
        amt = s if s > 0 else (c6 if c6 > 0 else c5)
        if amt != 0:
            batch_items.append((r, d, amt, cur_val, rate, amt * rate))
    print(f"2025 Batch items: {len(batch_items)}")

def test_extract_2026():
    ws_v = wb_orig['Rev VS Ops cost th 2026_']
    
    # 1. Revenue: rows 7 to 61
    rev_items = []
    for r in range(7, 62):
        d = ws_v.cell(r, 4).value
        amt_idr = ws_v.cell(r, 6).value
        amt_usd = ws_v.cell(r, 5).value
        if d and (amt_idr or amt_usd):
            rev_items.append((r, d, amt_idr or 0, amt_usd or 0))
    print(f"\n2026 Revenue items: {len(rev_items)}, sum IDR: {sum(x[2] for x in rev_items):,.2f}, sum USD: {sum(x[3] for x in rev_items):,.2f}")

    # 2. Tax: rows 66 to 92
    tax_items = []
    for r in range(66, 93):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value or ws_v.cell(r, 6).value
        if d and amt:
            tax_items.append((r, d, amt))
    print(f"2026 Tax items: {len(tax_items)}, sum: {sum(x[2] for x in tax_items):,.2f}")

    # 3. Bank: rows 97 to 172
    bank_items = []
    for r in range(97, 173):
        d = ws_v.cell(r, 4).value
        amt = ws_v.cell(r, 5).value or ws_v.cell(r, 6).value
        if amt:
            bank_items.append((r, d, amt))
    print(f"2026 Bank items: {len(bank_items)}, sum: {sum(x[2] for x in bank_items):,.2f}")

    # 4. Single: rows 176 to 390
    single_items = []
    for r in range(176, 391):
        d = ws_v.cell(r, 4).value
        desc_str = str(d or '').strip().upper()
        if 'TOTAL' in desc_str or 'SUB TOTAL' in desc_str:
            continue
        s = sum([ws_v.cell(r, c).value for c in range(9, 22) if isinstance(ws_v.cell(r, c).value, (int, float))])
        c6 = ws_v.cell(r, 6).value if isinstance(ws_v.cell(r, 6).value, (int, float)) else 0
        amt = s if s > 0 else c6
        if amt > 0:
            single_items.append((r, d, amt))
    print(f"2026 Single items: {len(single_items)}, sum: {sum(x[2] for x in single_items):,.2f}")

    # 5. Batch: rows 391 to 830
    batch_items = []
    for r in range(391, 831):
        d = ws_v.cell(r, 4).value or ws_v.cell(r, 3).value
        desc_str = str(d or '').strip().upper()
        if desc_str in ['TOTAL', 'SUBTOTAL', 'SUB TOTAL', '-']:
            continue
        s = sum([ws_v.cell(r, c).value for c in range(9, 22) if isinstance(ws_v.cell(r, c).value, (int, float))])
        c6 = ws_v.cell(r, 6).value if isinstance(ws_v.cell(r, 6).value, (int, float)) else 0
        c5 = ws_v.cell(r, 5).value if isinstance(ws_v.cell(r, 5).value, (int, float)) else 0
        amt = s if s > 0 else (c6 if c6 > 0 else c5)
        if amt > 0:
            batch_items.append((r, d, amt))
    print(f"2026 Batch items: {len(batch_items)}, sum: {sum(x[2] for x in batch_items):,.2f}")

test_extract_2024()
test_extract_2025()
test_extract_2026()

