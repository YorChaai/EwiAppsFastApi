import psycopg2
from psycopg2.extras import DictCursor

db_url = "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"

conn = psycopg2.connect(db_url)
cur = conn.cursor(cursor_factory=DictCursor)

print("=== CHECK INTEGRITAS DATABASE 2026 (v14) ===")

# 1. Settlements without expenses
cur.execute("""
    SELECT s.id, s.title, s.settlement_type
    FROM settlements s
    LEFT JOIN expenses e ON e.settlement_id = s.id
    WHERE s.report_year = 2026 AND e.id IS NULL;
""")
empty_sets = cur.fetchall()
print(f"1. Settlement tanpa expenses: {len(empty_sets)}")

# 2. Expenses without category or settlement
cur.execute("""
    SELECT count(*) FROM expenses e
    WHERE e.settlement_id IN (SELECT id FROM settlements WHERE report_year = 2026)
    AND (e.category_id IS NULL OR e.settlement_id IS NULL);
""")
print(f"2. Expenses tanpa kategori/settlement: {cur.fetchone()[0]}")

# 3. Expenses without subcategories
cur.execute("""
    SELECT count(DISTINCT e.id) FROM expenses e
    LEFT JOIN expense_subcategories es ON es.expense_id = e.id
    WHERE e.settlement_id IN (SELECT id FROM settlements WHERE report_year = 2026)
    AND es.id IS NULL;
""")
print(f"3. Expenses tanpa subkategori: {cur.fetchone()[0]}")

# 4. Settlements disbursed_amount vs sum of expenses
cur.execute("""
    SELECT s.id, s.title, s.disbursed_amount, COALESCE(sum(e.amount * e.currency_exchange), 0) as calc_amount
    FROM settlements s
    JOIN expenses e ON e.settlement_id = s.id
    WHERE s.report_year = 2026
    GROUP BY s.id, s.title, s.disbursed_amount
    HAVING abs(s.disbursed_amount - sum(e.amount * e.currency_exchange)) > 0.01;
""")
diff_amounts = cur.fetchall()
print(f"4. Settlement dengan selisih disbursed_amount vs expenses: {len(diff_amounts)}")
if diff_amounts:
    for d in diff_amounts[:5]:
        print(f"   ID {d['id']}: DB={d['disbursed_amount']} vs Calc={d['calc_amount']}")

# 5. Bank Accounts mapping in settlements
cur.execute("""
    SELECT count(*) FROM settlements
    WHERE report_year = 2026 AND bank_id IS NULL;
""")
print(f"5. Settlements tanpa bank_id: {cur.fetchone()[0]}")

# 6. Check bank_id distribution
cur.execute("""
    SELECT b.name, count(s.id)
    FROM settlements s
    LEFT JOIN bank_accounts b ON s.bank_id = b.id
    WHERE s.report_year = 2026
    GROUP BY b.name;
""")
print("   Distribusi Bank di Settlements 2026:", dict(cur.fetchall()))

# 7. Check user_id in settlements
cur.execute("""
    SELECT count(*) FROM settlements
    WHERE report_year = 2026 AND user_id IS NULL;
""")
print(f"6. Settlements tanpa user_id: {cur.fetchone()[0]}")

# 8. Check document_date in settlements
cur.execute("""
    SELECT count(*) FROM settlements
    WHERE report_year = 2026 AND document_date IS NULL;
""")
print(f"7. Settlements tanpa document_date: {cur.fetchone()[0]}")

# 9. Check Revenues and Taxes 2026
cur.execute("SELECT count(*), sum(invoice_value_idr) FROM revenues WHERE report_year = 2026;")
rev_data = cur.fetchone()
print(f"\n8. Revenues 2026: {rev_data[0]} baris | Total: Rp {rev_data[1]:,.2f}")

cur.execute("SELECT count(*), sum(transaction_value_idr) FROM taxes WHERE report_year = 2026;")
tax_data = cur.fetchone()
print(f"9. Taxes 2026: {tax_data[0]} baris | Total: Rp {tax_data[1]:,.2f}")

cur.execute("SELECT count(*) FROM bank_status_transactions WHERE report_year = 2026;")
bank_data = cur.fetchone()
print(f"10. Bank Status Transactions 2026: {bank_data[0]} baris")

conn.close()
