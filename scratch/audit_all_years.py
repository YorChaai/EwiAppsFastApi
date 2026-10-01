import psycopg2
from psycopg2.extras import DictCursor
import openpyxl

db_url = "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"
conn = psycopg2.connect(db_url)
cur = conn.cursor(cursor_factory=DictCursor)

print("==================================================")
print("       STATUS DATA DI DATABASE (POSTGRESQL)")
print("==================================================")

for yr in [2024, 2025, 2026]:
    cur.execute("""
        SELECT settlement_type, count(*), sum(disbursed_amount)
        FROM settlements
        WHERE report_year = %s
        GROUP BY settlement_type
        ORDER BY settlement_type;
    """, (yr,))
    rows = cur.fetchall()
    print(f"\n--- TAHUN {yr} (SETTLEMENTS) ---")
    tot_s = 0
    tot_a = 0
    for r in rows:
        tot_s += r['count']
        tot_a += r['sum'] or 0
        print(f"  {r['settlement_type']:10s}: {r['count']:4d} settlement | Rp {r['sum']:,.2f}")
    print(f"  TOTAL: {tot_s:4d} settlement | Rp {tot_a:,.2f}")

    cur.execute("""
        SELECT s.settlement_type, count(e.id), sum(e.amount * e.currency_exchange)
        FROM expenses e
        JOIN settlements s ON e.settlement_id = s.id
        WHERE s.report_year = %s
        GROUP BY s.settlement_type
        ORDER BY s.settlement_type;
    """, (yr,))
    exp_rows = cur.fetchall()
    print(f"--- TAHUN {yr} (EXPENSES ITEMS) ---")
    tot_e = 0
    tot_ea = 0
    for r in exp_rows:
        tot_e += r['count']
        tot_ea += r['sum'] or 0
        print(f"  {r['settlement_type']:10s}: {r['count']:4d} items      | Rp {r['sum']:,.2f}")
    print(f"  TOTAL: {tot_e:4d} items      | Rp {tot_ea:,.2f}")

conn.close()
