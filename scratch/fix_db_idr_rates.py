import psycopg2
from psycopg2.extras import DictCursor

db_url = "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"
conn = psycopg2.connect(db_url)
cur = conn.cursor(cursor_factory=DictCursor)

print("=== FIXING IDR CURRENCY EXCHANGE IN DATABASE ===")

# 1. Check affected rows
cur.execute("""
    SELECT count(*), array_agg(DISTINCT settlement_id)
    FROM expenses
    WHERE currency = 'IDR' AND currency_exchange > 1.0;
""")
cnt, set_ids = cur.fetchone()
print(f"Ditemukan {cnt} expenses dengan currency='IDR' dan currency_exchange > 1.0.")
print(f"Settlement ID terdampak: {set_ids}")

if cnt > 0:
    # 2. Update expenses to currency_exchange = 1.0
    cur.execute("""
        UPDATE expenses
        SET currency_exchange = 1.0
        WHERE currency = 'IDR' AND currency_exchange > 1.0;
    """)
    print(f"Berhasil mengupdate {cur.rowcount} baris expenses ke currency_exchange = 1.0.")

    # 3. Recalculate settlements disbursed_amount for affected settlements
    for sid in set_ids:
        cur.execute("""
            UPDATE settlements s
            SET disbursed_amount = COALESCE((
                SELECT SUM(amount * currency_exchange)
                FROM expenses
                WHERE settlement_id = s.id
            ), 0)
            WHERE s.id = %s
            RETURNING id, title, disbursed_amount;
        """, (sid,))
        res = cur.fetchone()
        print(f"  Updated Settlement ID {res['id']}: Disbursed Amount baru = Rp {res['disbursed_amount']:,.2f} | Title: {res['title'][:50]}")

    conn.commit()
    print("Database commit berhasil!")

# 4. Check new summary per year
print("\n=== RINGKASAN SETELAH PERBAIKAN ===")
for yr in [2024, 2025, 2026]:
    cur.execute("""
        SELECT s.settlement_type, count(DISTINCT s.id) as set_cnt, count(e.id) as exp_cnt, sum(e.amount * e.currency_exchange) as total_amt
        FROM settlements s
        LEFT JOIN expenses e ON e.settlement_id = s.id
        WHERE s.report_year = %s
        GROUP BY s.settlement_type
        ORDER BY s.settlement_type;
    """, (yr,))
    rows = cur.fetchall()
    tot_s = sum(r['set_cnt'] for r in rows)
    tot_e = sum(r['exp_cnt'] for r in rows)
    tot_a = sum(r['total_amt'] or 0 for r in rows)
    print(f"Tahun {yr}:")
    for r in rows:
        print(f"  {r['settlement_type']:8s}: {r['set_cnt']:3d} settlement | {r['exp_cnt']:4d} items | Rp {r['total_amt']:>18,.2f}")
    print(f"  TOTAL   : {tot_s:3d} settlement | {tot_e:4d} items | Rp {tot_a:>18,.2f}")

conn.close()
