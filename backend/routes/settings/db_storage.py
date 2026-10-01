import os
import shutil
import subprocess
from datetime import datetime
from urllib.parse import urlparse
from fastapi import Body, Depends, File, UploadFile
from fastapi.responses import JSONResponse
from config import BASE_DIR, Config
from core.security import require_role
from models import Expense, User, db
from . import settings_router as storage_router

@storage_router.get("/storage")
def get_storage_directory(user: User = Depends(require_role("manager", "super_manager"))):
    return {"current_directory": os.path.abspath(Config.UPLOAD_FOLDER)}


@storage_router.post("/storage")
def update_storage_directory(
    data: dict = Body(default={}),
    user: User = Depends(require_role("manager", "super_manager")),
):
    new_dir = data.get("new_directory")

    if not new_dir:
        return JSONResponse({"error": "Parameter new_directory tidak boleh kosong"}, status_code=400)

    new_dir = os.path.abspath(new_dir)
    old_dir = os.path.abspath(Config.UPLOAD_FOLDER)

    if new_dir == old_dir:
        return {"message": "Direktori baru sama dengan direktori saat ini."}

    try:
        # 1. buat direktori baru jika belum ada
        os.makedirs(new_dir, exist_ok=True)

        # 2. copy semua file ke direktori baru (termasuk exportdb jika ada)
        if os.path.exists(old_dir):
            for item in os.listdir(old_dir):
                s = os.path.join(old_dir, item)
                d = os.path.join(new_dir, item)
                if os.path.isdir(s):
                    shutil.copytree(s, d, dirs_exist_ok=True)
                else:
                    shutil.copy2(s, d)

        # 3. update file .env
        env_path = os.path.join(BASE_DIR, ".env")
        env_vars = {}

        # parse .env lama
        if os.path.exists(env_path):
            with open(env_path, "r", encoding="utf-8") as f:
                for line in f:
                    line = line.strip()
                    if line and not line.startswith("#") and "=" in line:
                        key, val = line.split("=", 1)
                        env_vars[key.strip()] = val.strip()

        # update upload dir
        env_vars["UPLOAD_DIR"] = new_dir

        # simpan kembali ke .env
        with open(env_path, "w", encoding="utf-8") as f:
            for key, val in env_vars.items():
                f.write(f"{key}={val}\n")

        # 4. update config app berjalan
        Config.UPLOAD_FOLDER = new_dir

        return {
            "message": "Penyimpanan berhasil dipindahkan ke lokasi baru.",
            "new_directory": new_dir,
        }
    except Exception as e:
        return JSONResponse({"error": f"Gagal memindahkan penyimpanan: {str(e)}"}, status_code=500)

@storage_router.post("/db/export")
def export_database(user: User = Depends(require_role("manager", "super_manager"))):

    try:
        # Folder utama: data/Database/Backups
        base_data_dir = Config.UPLOAD_FOLDER or os.path.join(BASE_DIR, "..", "data")
        export_base_dir = os.path.join(base_data_dir, "backupdataapps")

        # Buat timestamp folder (Contoh: 2026-04-24_14-30-00)
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        target_dir = os.path.join(export_base_dir, timestamp)
        os.makedirs(target_dir, exist_ok=True)

        db_uri = Config.SQLALCHEMY_DATABASE_URI
        exported_files = []

        # 1. EKSPOR POSTGRESQL (Jika aktif)
        if db_uri.startswith("postgresql"):
            try:
                url = urlparse(db_uri)
                env = os.environ.copy()
                env["PGPASSWORD"] = url.password

                target_sql = os.path.join(
                    target_dir, f"backup_postgres_{timestamp}.sql"
                )

                # Cari pg_dump: Coba di PATH dulu, kalau gagal coba jalur spesifik user
                potential_paths = [
                    "pg_dump",
                    r"D:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
                    r"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
                ]

                success = False
                last_error = ""

                for path in potential_paths:
                    try:
                        command = [
                            path,
                            "-h",
                            url.hostname,
                            "-p",
                            str(url.port or 5432),
                            "-U",
                            url.username,
                            "-F",
                            "p",
                            "--clean",
                            "--if-exists",
                            "-f",
                            target_sql,
                            url.path[1:],
                        ]
                        process = subprocess.run(
                            command, env=env, capture_output=True, text=True
                        )
                        if process.returncode == 0:
                            exported_files.append("PostgreSQL (.sql)")
                            success = True
                            break
                        else:
                            last_error = process.stderr
                    except FileNotFoundError:
                        continue

                if not success and last_error:
                    print(f"[!] pg_dump error: {last_error}")
                elif not success:
                    print(
                        "[!] Error: 'pg_dump' utility not found in PATH or common locations."
                    )

            except Exception as pe:
                print(f"[!] Unexpected PostgreSQL export error: {str(pe)}")

        if not exported_files:
            return JSONResponse(content=
                {
                    "error": "Tidak ada database PostgreSQL yang bisa diekspor. Pastikan tools pg_dump terinstall."
                }
            , status_code=404)

        return JSONResponse(
            {
                "message": f"Export Berhasil: {', '.join(exported_files)}",
                "path": os.path.abspath(target_dir),
                "folder": timestamp,
            }
        )
    except Exception as e:
        print(f"[!] Global Export Exception: {str(e)}")
        import traceback

        traceback.print_exc()
        return JSONResponse(content={"error": f"Gagal eksport database: {str(e)}"}, status_code=500)

@storage_router.post("/db/import-preview")
def import_database_preview(file: UploadFile | None = File(default=None), user: User = Depends(require_role("manager", "super_manager"))):
    if file is None:
        return JSONResponse({"error": "Tidak ada file yang diunggah"}, status_code=400)
    if file.filename == "":
        return JSONResponse(content={"error": "Nama file kosong"}, status_code=400)

    # Lokasi data folder saat ini
    base_data_dir = Config.UPLOAD_FOLDER or os.path.join(BASE_DIR, "..", "data")

    # Gunakan subfolder tmp agar folder data tetap bersih
    tmp_dir = os.path.join(base_data_dir, "tmp")
    os.makedirs(tmp_dir, exist_ok=True)

    # Cek tipe database
    db_uri = Config.SQLALCHEMY_DATABASE_URI
    is_postgres = db_uri.startswith("postgresql")

    # Simpan sementara
    ext = ".sql" if is_postgres else ".db"
    temp_path = os.path.join(tmp_dir, f"temp_import{ext}")

    # Hapus file lama jika ada
    if os.path.exists(temp_path):
        os.remove(temp_path)
    with open(temp_path, "wb") as destination:
        shutil.copyfileobj(file.file, destination)

    try:
        if is_postgres:
            # PREVIEW POSTGRESQL (Sederhana: Cek ukuran file)
            file_size = os.path.getsize(temp_path) / 1024  # KB
            
            with open(temp_path, "r", encoding="utf-8", errors="ignore") as f:
                head = f.read(100000)
                is_migration = "CREATE TABLE" not in head and "PostgreSQL database dump" not in head and "-- SCHEMA UPDATES --" not in head
                
            msg = "File cadangan PostgreSQL terdeteksi."
            if is_migration:
                msg = "File Migrasi Data terdeteksi (Tabel tidak akan dihapus)."
                
            return JSONResponse(
                {
                    "message": msg,
                    "summary": [
                        {"table": "Database SQL", "rows": f"{file_size:.1f} KB"}
                    ],
                    "filename": file.filename,
                    "is_postgres": True,
                }
            )
        else:
            # PREVIEW SQLITE (Lama)
            return JSONResponse(content=
                {
                    "error": "Aplikasi saat ini dikonfigurasi menggunakan PostgreSQL. File SQLite tidak dapat dipreview."
                }
            , status_code=400)
    except Exception as e:
        if os.path.exists(temp_path):
            os.remove(temp_path)
        return JSONResponse(content={"error": f"File tidak valid: {str(e)}"}, status_code=400)

@storage_router.post("/db/import-confirm")
def import_database_confirm(user: User = Depends(require_role("manager", "super_manager"))):

    temp_path = None
    try:
        base_data_dir = Config.UPLOAD_FOLDER or os.path.join(BASE_DIR, "..", "data")
        export_base_dir = os.path.join(base_data_dir, "Database", "Backups")

        db_uri = Config.SQLALCHEMY_DATABASE_URI
        is_postgres = db_uri.startswith("postgresql")

        ext = ".sql" if is_postgres else ".db"
        temp_path = os.path.join(base_data_dir, "tmp", f"temp_import{ext}")

        if not os.path.exists(temp_path):
            return JSONResponse(content=
                {"error": "File import tidak ditemukan. Silakan upload ulang."}
            , status_code=404)

        # --- FOLDER RIWAYAT IMPOR (Sesuai Permintaan User) ---
        timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        history_dir = os.path.join(export_base_dir, f"{timestamp}(import)")
        os.makedirs(history_dir, exist_ok=True)

        # Simpan salinan file yang diimpor sebagai arsip
        archived_import_file = os.path.join(
            history_dir, f"file_yang_diimpor_{timestamp}{ext}"
        )
        shutil.copy2(temp_path, archived_import_file)

        if is_postgres:
            # RESTORE POSTGRESQL
            url = urlparse(db_uri)
            env = os.environ.copy()
            env["PGPASSWORD"] = url.password

            # --- BACKUP DATA LAMA KE FOLDER RIWAYAT ---
            try:
                backup_path = os.path.join(
                    history_dir, f"backup_data_lama_sebelum_import_{timestamp}.sql"
                )

                pg_dump_path = "pg_dump"
                for p in [
                    "pg_dump",
                    r"D:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
                    r"C:\Program Files\PostgreSQL\16\bin\pg_dump.exe",
                ]:
                    if os.path.exists(p) or p == "pg_dump":
                        pg_dump_path = p
                        break

                subprocess.run(
                    [
                        pg_dump_path,
                        "-h",
                        url.hostname,
                        "-p",
                        str(url.port or 5432),
                        "-U",
                        url.username,
                        "-F",
                        "p",
                        "-f",
                        backup_path,
                        url.path[1:],
                    ],
                    env=env,
                    capture_output=True,
                )
                print(f"[*] Pre-import backup saved to: {backup_path}")
            except Exception as e:
                print(f"[!] Pre-import backup warning: {e}")

            # --- PROSES RESTORE ---
            print(f"[*] Memulai Restore PostgreSQL dari file: {temp_path}")

            # Close pooled SQLAlchemy connections before replacing the database file.
            from models import db

            db.session.remove()
            db.engine.dispose()
            print("[*] Koneksi internal dilepaskan untuk menghindari deadlock.")

            psql_path = "psql"
            for p in [
                "psql",
                r"D:\Program Files\PostgreSQL\16\bin\psql.exe",
                r"C:\Program Files\PostgreSQL\16\bin\psql.exe",
            ]:
                if os.path.exists(p) or p == "psql":
                    psql_path = p
                    break

            # 1. BERSIHKAN DATABASE TERLEBIH DAHULU (Wipe Schema)
            print("[*] Membersihkan schema public lama...")
            # Tambahkan perintah untuk memutus koneksi lain yang mungkin nyangkut
            import re
            target_db_name = re.sub(r"[^a-zA-Z0-9_]", "", url.path[1:])
            kill_conns = f"SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '{target_db_name}' AND pid <> pg_backend_pid();"  # nosec B608
            subprocess.run(
                [
                    psql_path,
                    "-h",
                    url.hostname,
                    "-p",
                    str(url.port or 5432),
                    "-U",
                    url.username,
                    "-d",
                    "postgres",  # Connect ke db 'postgres' untuk drop db target
                    "-c",
                    kill_conns,
                ],
                env=env,
                capture_output=True,
            )

            # Cek apakah ini file migrasi data (hanya INSERT, tanpa CREATE TABLE)
            with open(temp_path, "r", encoding="utf-8", errors="ignore") as f:
                head = f.read(100000)
                is_migration = "CREATE TABLE" not in head and "PostgreSQL database dump" not in head and "-- SCHEMA UPDATES --" not in head

            if not is_migration:
                # 1. BERSIHKAN DATABASE TERLEBIH DAHULU (Wipe Schema) JIKA FULL BACKUP
                print("[*] Membersihkan schema public lama (Full Backup)...")
                wipe_cmd = "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"
                subprocess.run(
                    [
                        psql_path,
                        "-h",
                        url.hostname,
                        "-p",
                        str(url.port or 5432),
                        "-U",
                        url.username,
                        "-d",
                        url.path[1:],
                        "-c",
                        wipe_cmd,
                    ],
                    env=env,
                    capture_output=True,
                )
            else:
                print("[*] Mode Migrasi Data terdeteksi, melewati penghapusan schema...")

            # 2. JALANKAN RESTORE
            print("[*] Menjalankan perintah psql restore...")
            process = subprocess.run(
                [
                    psql_path,
                    "-h",
                    url.hostname,
                    "-p",
                    str(url.port or 5432),
                    "-U",
                    url.username,
                    "-d",
                    url.path[1:],
                    "-v",
                    "ON_ERROR_STOP=1",
                    "-f",
                    temp_path,
                ],
                env=env,
                capture_output=True,
                text=True,
            )
            if process.returncode != 0:
                print(f"[!] PSQL RESTORE ERROR:\n{process.stderr}")
                return JSONResponse(content=
                    {"error": f"Gagal restore PostgreSQL: {process.stderr}"}
                , status_code=500)
            print("[*] Restore Selesai. Melakukan verifikasi data...")

            # 3. SCHEMA SYNC (Backfill kolom yang mungkin belum ada di dump lama)
            if not is_migration:
                print("[*] Menjalankan schema sync pasca-restore...")
                schema_sync_sql = (
                    "ALTER TABLE public.settlements "
                    "ADD COLUMN IF NOT EXISTS disbursement_source varchar(50), "
                    "ADD COLUMN IF NOT EXISTS return_source varchar(50), "
                    "ADD COLUMN IF NOT EXISTS admin_fee float DEFAULT 0, "
                    "ADD COLUMN IF NOT EXISTS disbursed_amount float, "
                    "ADD COLUMN IF NOT EXISTS returned_amount float DEFAULT 0, "
                    "ADD COLUMN IF NOT EXISTS disbursement_comment text, "
                    "ADD COLUMN IF NOT EXISTS return_description text, "
                    "ADD COLUMN IF NOT EXISTS disbursement_evidence_path text, "
                    "ADD COLUMN IF NOT EXISTS disbursement_evidence_filename text, "
                    "ADD COLUMN IF NOT EXISTS return_evidence_path text, "
                    "ADD COLUMN IF NOT EXISTS return_evidence_filename text, "
                    "ADD COLUMN IF NOT EXISTS is_disbursement_approved boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS is_return_approved boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS return_status character varying(20) DEFAULT 'pending', "
                    "ADD COLUMN IF NOT EXISTS return_notes text, "
                    "ADD COLUMN IF NOT EXISTS modified_t1 boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS modified_t2 boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS modified_t3 boolean DEFAULT false; "
                    "ALTER TABLE public.advances "
                    "ADD COLUMN IF NOT EXISTS disbursement_source varchar(50), "
                    "ADD COLUMN IF NOT EXISTS return_source varchar(50), "
                    "ADD COLUMN IF NOT EXISTS admin_fee float DEFAULT 0, "
                    "ADD COLUMN IF NOT EXISTS disbursed_amount float, "
                    "ADD COLUMN IF NOT EXISTS returned_amount float DEFAULT 0, "
                    "ADD COLUMN IF NOT EXISTS disbursement_comment text, "
                    "ADD COLUMN IF NOT EXISTS return_description text, "
                    "ADD COLUMN IF NOT EXISTS disbursement_evidence_path text, "
                    "ADD COLUMN IF NOT EXISTS disbursement_evidence_filename text, "
                    "ADD COLUMN IF NOT EXISTS return_evidence_path text, "
                    "ADD COLUMN IF NOT EXISTS return_evidence_filename text, "
                    "ADD COLUMN IF NOT EXISTS is_disbursement_approved boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS is_return_approved boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS return_status character varying(20) DEFAULT 'pending', "
                    "ADD COLUMN IF NOT EXISTS return_notes text, "
                    "ADD COLUMN IF NOT EXISTS modified_t1 boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS modified_t2 boolean DEFAULT false, "
                    "ADD COLUMN IF NOT EXISTS modified_t3 boolean DEFAULT false;"
                )
                sync_process = subprocess.run(
                    [
                        psql_path,
                        "-h",
                        url.hostname,
                        "-p",
                        str(url.port or 5432),
                        "-U",
                        url.username,
                        "-d",
                        url.path[1:],
                        "-v",
                        "ON_ERROR_STOP=1",
                        "-c",
                        schema_sync_sql,
                    ],
                    env=env,
                    capture_output=True,
                    text=True,
                )
                if sync_process.returncode != 0:
                    print(f"[!] SCHEMA SYNC ERROR (Ignored):\n{sync_process.stderr}")
            print("[*] Schema sync pasca-restore selesai.")

            # --- VERIFIKASI DATA (Cek apakah tabel ada isinya) ---
            from models import Expense, User, db

            try:
                # Kita perlu me-refresh sesi database karena koneksi psql tadi di luar SQLAlchemy
                db.session.remove()

                # --- SYNC SEQUENCES ---
                print("[*] Menjalankan sinkronisasi sequence database...")
                tables_to_sync = [
                    'companies', 'users', 'category_groups', 'categories',
                    'bank_accounts', 'bank_transactions', 'bank_status_transactions',
                    'assets', 'advances', 'advance_items', 'settlements', 'expenses',
                    'revenues', 'taxes', 'manual_combine_groups', 'dividends',
                    'dividend_settings', 'notifications', 'deadline_settings',
                    'workflow_logs', 'override_logs'
                ]
                for table in tables_to_sync:
                    if not re.match(r"^[a-zA-Z0-9_]+$", table):
                        continue
                    try:
                        db.session.execute(db.text(f"SELECT setval(pg_get_serial_sequence('{table}','id'), COALESCE(MAX(id),1)) FROM \"{table}\""))  # nosec B608
                    except Exception as e:
                        db.session.rollback()
                        print(f"[!] Gagal sinkronisasi sequence untuk tabel {table}: {e}")
                db.session.commit()
                print("[*] Sinkronisasi sequence selesai.")

                user_count = db.session.query(db.func.count(User.id)).scalar()
                exp_count = db.session.query(db.func.count(Expense.id)).scalar()
                print(
                    f"[+] Verifikasi Berhasil: Ditemukan {user_count} User dan {exp_count} Pengeluaran di database baru."
                )
                debug_info = f"Import OK. Users: {user_count}, Expenses: {exp_count}"
            except Exception as ve:
                print(f"[!] Verifikasi Gagal: {ve}")
                debug_info = f"Import selesai tapi verifikasi gagal: {str(ve)}"

        else:
            return JSONResponse(content=
                {
                    "error": "Aplikasi saat ini dikonfigurasi menggunakan PostgreSQL. File SQLite tidak dapat diimpor."
                }
            , status_code=400)

        # Hapus file sampah
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)

        return JSONResponse(
            {
                "message": "Database berhasil dipulihkan.",
                "debug": debug_info,
                "history_folder": f"{timestamp}(import)",
            }
        )

    except Exception as e:
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)
        return JSONResponse(content={"error": f"Gagal import database: {str(e)}"}, status_code=500)
