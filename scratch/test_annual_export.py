import json
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "backend")))

from app import create_app
import openpyxl
from core.security import create_access_token

app = create_app()

with app.app_context():
    # 1. Check cached JSON
    cache_json_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "data", "exports", "annual_cache", "annual_2026.json"))
    if os.path.exists(cache_json_path):
        with open(cache_json_path, "r", encoding="utf-8") as f:
            jdata = json.load(f)
        revs = jdata.get("revenue", {}).get("data", [])
        print(f"Total revenues in cached 2026 JSON: {len(revs)}")
        if revs:
            for i, r in enumerate(revs[:5]):
                print(f"  Rev {i+1}: desc='{r.get('description')[:20]}', bank_name='{r.get('bank_name')}', source='{r.get('source')}', bank_id='{r.get('bank_id')}'")
    
    # 2. Test generate annual report excel
    from models import User
    
    user = User.query.first()
    token = create_access_token(identity=str(user.id))
    
    # Exercise the FastAPI endpoint through its ASGI test client.
    response = app.test_client().get(
        '/api/reports/annual/excel?year=2026&mode=annual&refresh=1',
        headers={"Authorization": f"Bearer {token}"},
    )
    print(f"Response status: {response.status_code}")
    print(f"Content type: {response.headers.get('content-type')}")

    # Save output to scratch/output_2026.xlsx to inspect
    excel_bytes = response.content
    out_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "output_2026.xlsx"))
    with open(out_path, "wb") as f:
        f.write(excel_bytes)
    print(f"Excel saved to {out_path}, size: {len(excel_bytes)} bytes")
        
    # Inspect workbook
    wb = openpyxl.load_workbook(out_path, data_only=False)
    sheet = wb.active
    print(f"Active sheet name: {sheet.title}")

    # Check Column R (18) headers
    top_h = sheet.cell(row=6, column=18).value
    bot_h = sheet.cell(row=7, column=18).value
    print(f"Row 6 Col 18 (R): '{top_h}', Row 7 Col 18: '{bot_h}'")

    # Check first 5 data rows in Col R
    for r in range(8, 15):
        val = sheet.cell(row=r, column=18).value
        desc = sheet.cell(row=r, column=4).value
        print(f"  Row {r}: Desc='{desc}' -> Sumber Dana='{val}'")

    # Check Operation Cost (Table 3) row heights for rows with multiline descriptions
    print("\nChecking Table 3 Operation Cost row heights:")
    for r in range(15, min(sheet.max_row + 1, 400)):
        desc = sheet.cell(row=r, column=4).value
        h = sheet.row_dimensions[r].height
        if desc and len(str(desc)) > 40:
            print(f"  Row {r} (len {len(str(desc))}): height={h}pt, desc='{str(desc)[:50]}...'")

print("\nVerifying Column dimensions and merges:")
wb = openpyxl.load_workbook(out_path, data_only=False)
sheet = wb.active
print(f"Col R width: {sheet.column_dimensions['R'].width}")
print(f"Col D width: {sheet.column_dimensions['D'].width}")
is_r6_r7_merged = any("R6:R7" in str(m) for m in sheet.merged_cells.ranges)
print(f"Is R6:R7 merged: {is_r6_r7_merged}")

print("\nDone testing annual report!")
