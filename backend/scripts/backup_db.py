import os
import sys
import subprocess
import datetime
import urllib.parse

sys.stdout.reconfigure(encoding="utf-8")

def do_backup():
    # 1. Cari path root & database URL
    current_dir = os.path.dirname(os.path.abspath(__file__))
    backend_dir = os.path.abspath(os.path.join(current_dir, ".."))
    env_path = os.path.join(backend_dir, ".env")
    
    db_uri = None
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                if line.startswith("DATABASE_URL="):
                    db_uri = line.strip().split("=", 1)[1]
                    break
    
    if not db_uri:
        db_uri = "postgresql://postgres:yorchai12@localhost:5432/miniproject_revisi_db"

    url = urllib.parse.urlparse(db_uri)

    backup_dir = r"D:\Aplikasi\EWIApps\data\backupdataapps"
    os.makedirs(backup_dir, exist_ok=True)

    timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    target_sql = os.path.join(backup_dir, f"backup_database_{timestamp}.sql")

    pg_dump_paths = [
        "pg_dump",
        r"C:\Program Files\PostgreSQL\17\bin\pg_dump.exe",
        r"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
        r"C:\Program Files\PostgreSQL\15\bin\pg_dump.exe",
        r"D:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
    ]

    env = os.environ.copy()
    if url.password:
        env["PGPASSWORD"] = url.password

    success = False
    for path in pg_dump_paths:
        try:
            cmd = [
                path,
                "-h", url.hostname or "localhost",
                "-p", str(url.port or 5432),
                "-U", url.username or "postgres",
                "-F", "p",
                "--clean",
                "--if-exists",
                "-f", target_sql,
                url.path.lstrip("/"),
            ]
            res = subprocess.run(cmd, env=env, capture_output=True, text=True)
            if res.returncode == 0:
                size_kb = os.path.getsize(target_sql) / 1024
                print(f"✅ Backup Database BERHASIL DIBUAT!")
                print(f"📁 Lokasi : {target_sql}")
                print(f"📊 Ukuran : {size_kb:.2f} KB")
                success = True
                break
        except Exception:
            continue

    if not success:
        print("❌ Gagal membuat backup database. Pastikan PostgreSQL pg_dump terinstal.")

if __name__ == "__main__":
    do_backup()
