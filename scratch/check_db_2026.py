import psycopg2
from psycopg2.extras import DictCursor

db_url = "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"

try:
    conn = psycopg2.connect(db_url)
    cur = conn.cursor(cursor_factory=DictCursor)
    print("Connected to PostgreSQL successfully!")
    
    # 1. Check settlements for 2026
    cur.execute("""
        SELECT settlement_type, count(*), sum(disbursed_amount)
        FROM settlements
        WHERE report_year = 2026
        GROUP BY settlement_type
        ORDER BY settlement_type;
    """)
    rows = cur.fetchall()
    print("\n--- SETTLEMENTS 2026 BY TYPE ---")
    total_sets = 0
    total_set_amount = 0
    for r in rows:
        stype = r['settlement_type']
        cnt = r['count']
        amt = r['sum'] or 0
        total_sets += cnt
        total_set_amount += amt
        print(f"Type: {stype:10s} | Count: {cnt:4d} | Disbursed Amount: Rp {amt:,.2f}")
    print(f"TOTAL: {total_sets} settlements | Rp {total_set_amount:,.2f}")

    # 2. Check total settlements count
    cur.execute("SELECT count(*) FROM settlements WHERE report_year = 2026")
    print(f"Exact count settlements 2026: {cur.fetchone()[0]}")

    # 3. Check expenses for 2026
    cur.execute("""
        SELECT s.settlement_type, count(e.id), sum(e.amount * e.currency_exchange)
        FROM expenses e
        JOIN settlements s ON e.settlement_id = s.id
        WHERE s.report_year = 2026
        GROUP BY s.settlement_type;
    """)
    exp_rows = cur.fetchall()
    print("\n--- EXPENSES 2026 BY SETTLEMENT TYPE ---")
    tot_exp_cnt = 0
    tot_exp_amt = 0
    for r in exp_rows:
        stype = r['settlement_type']
        cnt = r['count']
        amt = r['sum'] or 0
        tot_exp_cnt += cnt
        tot_exp_amt += amt
        print(f"Settlement Type: {stype:10s} | Expenses Count: {cnt:4d} | Total Amount IDR: Rp {amt:,.2f}")
    print(f"TOTAL EXPENSES: {tot_exp_cnt} | Total Amount IDR: Rp {tot_exp_amt:,.2f}")

    # 4. Check list of batch settlements
    cur.execute("""
        SELECT id, title, document_date, disbursed_amount, 
               (SELECT count(*) FROM expenses WHERE settlement_id = s.id) as item_count
        FROM settlements s
        WHERE report_year = 2026 AND settlement_type = 'batch'
        ORDER BY id ASC;
    """)
    batch_rows = cur.fetchall()
    print(f"\n--- DETAIL 27 BATCH SETTLEMENTS 2026 ({len(batch_rows)} groups) ---")
    for idx, b in enumerate(batch_rows, 1):
        print(f"{idx:2d}. [ID {b['id']}] Date: {b['document_date']} | Items: {b['item_count']:2d} | Amount: Rp {b['disbursed_amount']:,.0f} | Title: {b['title']}")

    # 5. Check if any expenses have 0 amount or are in draft
    cur.execute("""
        SELECT count(*) FROM expenses e
        JOIN settlements s ON e.settlement_id = s.id
        WHERE s.report_year = 2026 AND e.amount = 0;
    """)
    zero_cnt = cur.fetchone()[0]
    print(f"\nExpenses with 0 amount in 2026: {zero_cnt}")

    # 6. Check status distribution
    cur.execute("""
        SELECT status, count(*) FROM settlements WHERE report_year = 2026 GROUP BY status;
    """)
    print("Settlement statuses:", dict(cur.fetchall()))

    conn.close()
except Exception as e:
    print(f"Error querying DB: {e}")
