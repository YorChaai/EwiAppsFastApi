import psycopg2
from psycopg2.extras import DictCursor

conn = psycopg2.connect('postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db')
cur = conn.cursor(cursor_factory=DictCursor)

for yr in [2024, 2025, 2026]:
    cur.execute('''
        SELECT count(*), sum(amount), sum(amount * currency_exchange)
        FROM expenses e
        JOIN settlements s ON e.settlement_id = s.id
        WHERE s.report_year = %s AND e.currency = 'IDR' AND e.currency_exchange > 1.0;
    ''', (yr,))
    row = cur.fetchone()
    print(f"Tahun {yr}: {row[0]} expenses punya currency='IDR' tapi currency_exchange > 1.0!")
    if row[0] > 0:
        cur.execute('''
            SELECT e.id, s.id as set_id, e.description, e.amount, e.currency, e.currency_exchange, (e.amount * e.currency_exchange) as total_idr
            FROM expenses e
            JOIN settlements s ON e.settlement_id = s.id
            WHERE s.report_year = %s AND e.currency = 'IDR' AND e.currency_exchange > 1.0
            LIMIT 5;
        ''', (yr,))
        for r in cur.fetchall():
            print(f"   [ID {r['id']}] {r['description'][:40]} | amt={r['amount']} {r['currency']} | rate={r['currency_exchange']} | total_idr={r['total_idr']}")

conn.close()
