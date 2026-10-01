import psycopg2
from psycopg2.extras import DictCursor

conn = psycopg2.connect('postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db')
cur = conn.cursor(cursor_factory=DictCursor)

cur.execute('''
    SELECT e.id, s.id as set_id, s.title, e.description, e.amount, e.currency, e.currency_exchange, (e.amount * e.currency_exchange) as total_idr
    FROM expenses e
    JOIN settlements s ON e.settlement_id = s.id
    WHERE s.report_year = 2024 AND (e.amount * e.currency_exchange) > 100000000
    ORDER BY total_idr DESC;
''')
rows = cur.fetchall()
print(f"Expenses > 100 Juta in 2024 ({len(rows)} items):")
for r in rows:
    print(f"ID {r['id']} | Set {r['set_id']} | {r['amount']:,.2f} {r['currency']} @ {r['currency_exchange']} = Rp {r['total_idr']:,.2f} | {r['description'][:50]}")
