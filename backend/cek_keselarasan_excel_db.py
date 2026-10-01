"""Runner Cek Keselarasan Excel vs Database vs Aplikasi.
Lokasi: backend/cek_keselarasan_excel_db.py

Memungkinkan eksekusi langsung dari dalam direktori 'backend':
  cd backend
  python cek_keselarasan_excel_db.py --all
  python cek_keselarasan_excel_db.py
"""

import sys
from pathlib import Path

CURRENT_DIR = Path(__file__).resolve().parent
SCRIPTS_DIR = CURRENT_DIR / "scripts"

if str(SCRIPTS_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPTS_DIR))

try:
    from cek_keselarasan_excel_db import main
except ImportError:
    # Fallback jika dijalankan langsung
    import importlib.util
    target_file = SCRIPTS_DIR / "cek_keselarasan_excel_db.py"
    spec = importlib.util.spec_from_file_location("cek_keselarasan_excel_db", target_file)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    main = module.main

if __name__ == "__main__":
    main()
