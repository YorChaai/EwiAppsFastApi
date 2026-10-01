import openpyxl
from backend.scripts.generate_hybrid_migration_v14 import scan_sheet_analysis, preview_sheet

excel_path = r"D:\Aplikasi\EWIApps\data\excel\20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx"

wb_val = openpyxl.load_workbook(excel_path, data_only=True)
wb_form = openpyxl.load_workbook(excel_path, data_only=False)

print("==================================================")
print("     HASIL SCANNING SHEET 2024 & 2025 DARI EXCEL   ")
print("==================================================")

for sheet in ["Rev VS Ops cost th 2024", "Rev VS Ops cost th 2025_Final", "Rev VS Ops cost th 2026_"]:
    print(f"\n>>> SCANNING: {sheet} <<<")
    preview_sheet(wb_form, wb_val, sheet)
