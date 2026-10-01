import psycopg2, openpyxl
from psycopg2.extras import DictCursor

conn = psycopg2.connect('postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db')
cur = conn.cursor(cursor_factory=DictCursor)

# Let's inspect settlement ID and expenses for settlement around row 1269:
cur.execute("""
    SELECT s.id, s.title, s.description, count(e.id), sum(e.amount * e.currency_exchange)
    FROM settlements s
    JOIN expenses e ON e.settlement_id = s.id
    WHERE s.report_year = 2025 AND s.settlement_type = 'batch' AND s.title ILIKE '%Benakat%'
    GROUP BY s.id, s.title, s.description;
""")
set_info = cur.fetchall()
print('Settlement Benakat in DB:', [dict(r) for r in set_info])

set_id = set_info[0]['id']
cur.execute("""
    SELECT id, description, amount, currency, date
    FROM expenses
    WHERE settlement_id = %s
    ORDER BY id ASC;
""", (set_id,))
exps = cur.fetchall()
print(f'Total expenses in Settlement {set_id}: {len(exps)}')
for i, exp in enumerate(exps):
    print(f'  [{i+1}] ID {exp["id"]}: {exp["date"]} | {exp["description"]} | Rp {float(exp["amount"]):,.0f}')
