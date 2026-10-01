import psycopg2

conn = psycopg2.connect("postgresql://postgres:yorchai12@localhost:5432/miniproject_db")
c = conn.cursor()
c.execute("SELECT column_name FROM information_schema.columns WHERE table_name='users';")
cols = [r[0] for r in c.fetchall()]
print("User columns:", cols)
c.execute(f"SELECT {', '.join(cols[:6])} FROM users;")
print("Users:", c.fetchall())
conn.close()
