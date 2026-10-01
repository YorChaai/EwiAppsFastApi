import openpyxl, psycopg2
from backend.scripts.cek_keselarasan_excel_db import extract_excel_stats

conn = psycopg2.connect('postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db')
cur = conn.cursor()
cur.execute('SELECT id, description, title, (SELECT count(*) FROM expenses WHERE settlement_id=s.id) FROM settlements s WHERE report_year = 2024 AND settlement_type = \'batch\' ORDER BY id ASC;')
db_batches = cur.fetchall()

xl = r'D:\Aplikasi\EWIApps\data\excel\20250427_EWI Financial-Repport_2024-2026 (version 2).xlsx'
wb_v = openpyxl.load_workbook(xl, data_only=True)
wb_f = openpyxl.load_workbook(xl, data_only=False)
ex_stats = extract_excel_stats(wb_v, wb_f, 2024)

print('Excel Groups count:', len(ex_stats['batch_groups']))
print('DB Batches count:', len(db_batches))

for i in range(max(len(ex_stats['batch_groups']), len(db_batches))):
    ex = ex_stats['batch_groups'][i] if i < len(ex_stats['batch_groups']) else None
    db = db_batches[i] if i < len(db_batches) else None
    ex_info = f"[R{ex['row']}] ({len(ex['items'])}) {ex['title'][:25]}" if ex else '---'
    db_info = f"[ID{db[0]} {db[1]}] ({db[3]}) {db[2][:25]}" if db else '---'
    print(f"{i+1:2d}. EX: {ex_info:<35} | DB: {db_info}")
