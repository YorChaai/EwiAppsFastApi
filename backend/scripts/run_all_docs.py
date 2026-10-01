"""
run_all_docs.py
================
Script MASTER — satu klik untuk menjalankan semua 6 generator dokumentasi:

  [Kelompok 1] Scan langsung file kode (tidak butuh Graphify):
    1. generate_backend_docs.py     -> docs/alldocument/Panduan_Backend_Lengkap.md
    2. generate_frontend_docs.py    -> docs/alldocument/Panduan_Frontend_Lengkap.md
    3. auto_generate_and_compare_docs.py -> diff + banding/

  [Kelompok 2] Baca dari Graphify graph.json:
    0. graphify --update            <- SELALU dijalankan dulu agar data relasi fresh
    4. generate_backend_graphify.py  -> docs/alldocument/graphify/Panduan_Backend_Graphify.md
    5. generate_frontend_graphify.py -> docs/alldocument/graphify/Panduan_Frontend_Graphify.md
    6. auto_graphify_docs.py         -> diff + graphify/banding/

  [Bonus] Generate Index/TOC:
    7. Tulis docs/alldocument/INDEX.md (ringkasan + link semua dokumen)

Cara menjalankan (dari root proyek):
    python backend/scripts/run_all_docs.py

    Atau hanya Kelompok 1 saja (skip Graphify):
    python backend/scripts/run_all_docs.py --skip-graphify
"""

import os
import sys
import subprocess
from datetime import datetime

# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR     = r"D:\Aplikasi\EWIApps"
SCRIPTS_DIR  = os.path.dirname(os.path.abspath(__file__))
GRAPHIFY_DIR = os.path.join(SCRIPTS_DIR, "graphify_docs")

GRAPH_JSON   = os.path.join(ROOT_DIR, "graphify-out", "graph.json")
DOCS_OUT     = os.path.join(ROOT_DIR, "docs", "alldocument")
INDEX_PATH   = os.path.join(DOCS_OUT, "INDEX.md")

SKIP_GRAPHIFY = "--skip-graphify" in sys.argv

# ─── RUNNER ────────────────────────────────────────────────────────────────────

def run(script_path: str, label: str) -> bool:
    print(f"  [>>] {label}...")
    result = subprocess.run(
        ["python", script_path],
        cwd=ROOT_DIR,
        capture_output=True,
        text=True,
        encoding="utf-8",
    )
    if result.returncode != 0:
        print(f"  [ERROR] {label}:\n{result.stderr.strip()}")
        return False
    print(f"  [OK] {label} selesai.")
    return True

# ─── INDEX GENERATOR ───────────────────────────────────────────────────────────

def generate_index(graphify_updated: bool):
    """Buat INDEX.md sebagai pintu masuk semua dokumentasi."""
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Cek file-file yang ada
    files = {
        "backend_lengkap": os.path.join(DOCS_OUT, "Panduan_Backend_Lengkap.md"),
        "frontend_lengkap": os.path.join(DOCS_OUT, "Panduan_Frontend_Lengkap.md"),
        "backend_graphify": os.path.join(DOCS_OUT, "graphify", "Panduan_Backend_Graphify.md"),
        "frontend_graphify": os.path.join(DOCS_OUT, "graphify", "Panduan_Frontend_Graphify.md"),
        "skrip_panduan": os.path.join(DOCS_OUT, "Panduan_Skrip_Dokumentasi.md"),
        "handover": os.path.join(DOCS_OUT, "Handover_Progress_Report.md"),
        "metode_uji": os.path.join(DOCS_OUT, "Metode_Pengujian_Backend.md"),
    }

    def size_kb(path):
        if os.path.exists(path):
            return f"{os.path.getsize(path) // 1024} KB"
        return "—"

    def status(path):
        return "✔" if os.path.exists(path) else "✘"

    graphify_note = (
        "✔ Graphify di-update pada sesi ini"
        if graphify_updated
        else "⚠ Graphify **tidak** di-update sesi ini — data relasi mungkin kadaluarsa"
    )

    lines = [
        "# INDEX — Dokumentasi Proyek MiniProjectKPI EWI\n\n",
        f"> **Terakhir di-generate:** {ts}\n",
        f"> **Status Graphify:** {graphify_note}\n\n",
        "---\n\n",

        "## Dokumen Teknis Utama\n\n",
        "| Dokumen | Isi Singkat | Ukuran | Ada? |\n",
        "|---|---|---|---|\n",
        f"| [Panduan_Backend_Lengkap.md](Panduan_Backend_Lengkap.md) | Semua `def` fungsi per file Python (scan regex) | {size_kb(files['backend_lengkap'])} | {status(files['backend_lengkap'])} |\n",
        f"| [Panduan_Frontend_Lengkap.md](Panduan_Frontend_Lengkap.md) | Semua widget/fungsi Dart (scan regex), Stateful/Stateless | {size_kb(files['frontend_lengkap'])} | {status(files['frontend_lengkap'])} |\n",
        f"| [graphify/Panduan_Backend_Graphify.md](graphify/Panduan_Backend_Graphify.md) | Relasi antar file backend, call graph, dependency map | {size_kb(files['backend_graphify'])} | {status(files['backend_graphify'])} |\n",
        f"| [graphify/Panduan_Frontend_Graphify.md](graphify/Panduan_Frontend_Graphify.md) | Provider deps, import internal, relasi antar Dart file | {size_kb(files['frontend_graphify'])} | {status(files['frontend_graphify'])} |\n",
        "\n---\n\n",

        "## Dokumen Referensi & Panduan\n\n",
        "| Dokumen | Isi Singkat | Ukuran |\n",
        "|---|---|---|\n",
        f"| [Panduan_Skrip_Dokumentasi.md](Panduan_Skrip_Dokumentasi.md) | Perbandingan lengkap Kelompok 1 vs 2, cara pakai, rekomendasi | {size_kb(files['skrip_panduan'])} |\n",
        f"| [Handover_Progress_Report.md](Handover_Progress_Report.md) | Laporan handover & status proyek | {size_kb(files['handover'])} |\n",
        f"| [Metode_Pengujian_Backend.md](Metode_Pengujian_Backend.md) | Metode audit keamanan & kualitas kode backend | {size_kb(files['metode_uji'])} |\n",
        "\n---\n\n",

        "## Riwayat Perubahan (Diff Reports)\n\n",
        "| Folder | Isi |\n",
        "|---|---|\n",
        "| [banding/](banding/) | Laporan diff Kelompok 1 (scan regex) |\n",
        "| [graphify/banding/](graphify/banding/) | Laporan diff Kelompok 2 (graphify) |\n",
        "| [graphify/archive/](graphify/archive/) | Salinan dokumen graphify versi sebelumnya |\n",
        "\n---\n\n",

        "## Cara Regenerasi Semua Dokumen\n\n",
        "```bash\n",
        "# Regenerasi semua (Kelompok 1 + 2):\n",
        'python "backend\\scripts\\run_all_docs.py"\n\n',
        "# Hanya Kelompok 1 (tanpa butuh Graphify):\n",
        'python "backend\\scripts\\run_all_docs.py" --skip-graphify\n',
        "```\n\n",
        "> **Catatan:** Sebelum menjalankan Kelompok 2, pastikan Graphify sudah diperbarui\n",
        "> agar data relasi tidak kadaluarsa setelah ada perubahan kode.\n",
    ]

    with open(INDEX_PATH, "w", encoding="utf-8") as f:
        f.writelines(lines)

    print(f"  [OK] INDEX.md dibuat di: {INDEX_PATH}")

# ─── MAIN ──────────────────────────────────────────────────────────────────────

def main():
    print("\n" + "=" * 55)
    print("  MASTER DOC RUNNER — MiniProjectKPI EWI")
    print("=" * 55)

    if SKIP_GRAPHIFY:
        print("\n  [MODE] Hanya Kelompok 1 (--skip-graphify aktif)\n")
    else:
        # Cek graphify.exe tersedia
        import shutil as _shutil
        if not _shutil.which("graphify"):
            print("\n  [ERROR] 'graphify' tidak ditemukan di PATH.")
            print("          Kelompok 2 tidak bisa dijalankan.")
            print("          Tambahkan --skip-graphify untuk lewati Kelompok 2.\n")
            sys.exit(1)

    # ── Kelompok 1 ─────────────────────────────────────────────────────────────
    print("-" * 55)
    print("  [Kelompok 1] Scan Langsung File Kode")
    print("-" * 55)
    run(
        os.path.join(SCRIPTS_DIR, "auto_generate_and_compare_docs.py"),
        "Kelompok 1: Backend + Frontend docs + diff"
    )

    graphify_updated = False

    # ── Kelompok 2 ─────────────────────────────────────────────────────────────
    if not SKIP_GRAPHIFY:
        print()
        print("-" * 55)
        print("  [Kelompok 2] Graphify Knowledge Graph")
        print("-" * 55)

        # Selalu update graphify dulu agar data relasi fresh
        print("  [>>] Menjalankan graphify --update ...")
        gfy_result = subprocess.run(
            ["graphify", "--update"],
            cwd=ROOT_DIR,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        if gfy_result.returncode != 0:
            print(f"  [ERROR] graphify --update gagal:\n{gfy_result.stderr.strip()}")
            print("  [SKIP] Kelompok 2 dilewati karena graphify gagal.")
        else:
            print("  [OK] graphify --update selesai.")
            graphify_updated = run(
                os.path.join(GRAPHIFY_DIR, "auto_graphify_docs.py"),
                "Kelompok 2: Graphify docs + diff"
            )

    # ── Index ──────────────────────────────────────────────────────────────────
    print()
    print("-" * 55)
    print("  [Bonus] Generate INDEX.md")
    print("-" * 55)
    generate_index(graphify_updated)

    print()
    print("=" * 55)
    print("  SELESAI! Semua dokumentasi telah di-generate.")
    print(f"  Index: {INDEX_PATH}")
    print("=" * 55 + "\n")


if __name__ == "__main__":
    main()
