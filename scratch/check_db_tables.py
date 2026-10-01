import psycopg2

for db in ['miniproject_db', 'miniproject_revisi_db']:
    try:
        conn = psycopg2.connect(host='localhost', port=5432, user='postgres', password='yorchai12', dbname=db)
        cur = conn.cursor()
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public'")
        tables = [r[0] for r in cur.fetchall()]
        print(f'{db} has {len(tables)} tables: {tables}')
        if 'users' in tables:
            cur.execute('SELECT count(*) FROM users')
            print(f'   users count: {cur.fetchone()[0]}')
        cur.close()
        conn.close()
    except Exception as e:
        print(f'Error on {db}: {e}')
