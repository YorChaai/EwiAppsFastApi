"""Runner Cek Keselarasan Excel vs Database vs Aplikasi.
Lokasi: scripts/cek_keselarasan_excel_db.py

Memungkinkan eksekusi dari direktori scripts:
  python cek_keselarasan_excel_db.py --all
  python cek_keselarasan_excel_db.py
"""

import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
BACKEND_SCRIPTS = PROJECT_ROOT / "backend" / "scripts"

if str(BACKEND_SCRIPTS) not in sys.path:
    sys.path.insert(0, str(BACKEND_SCRIPTS))

from cek_keselarasan_excel_db import main

if __name__ == "__main__":
    main()
