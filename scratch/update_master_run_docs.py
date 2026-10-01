import os
import sys
from pathlib import Path

content = '''"""
run_all_docs.py (Universal AI Tool Version)
===========================================
Script MASTER — satu klik untuk menjalankan semua generator dokumentasi:
  [Kelompok 1] Scan langsung file kode:
    1. generate_backend_docs.py     -> docs/alldocument/panduan/Panduan_Backend_Lengkap.md
    2. generate_frontend_docs.py    -> docs/alldocument/panduan/Panduan_Frontend_Lengkap.md
    3. auto_generate_and_compare_docs.py -> docs/alldocument/banding/

  [Kelompok 2] Baca dari Graphify graph.json:
    0. graphify --update            <- di-update jika graphify tersedia di project
    4. generate_backend_graphify.py  -> docs/alldocument/graphify/Panduan_Backend_Graphify.md
    5. generate_frontend_graphify.py -> docs/alldocument/graphify/Panduan_Frontend_Graphify.md
    6. auto_graphify_docs.py         -> docs/alldocument/graphify/banding/

  [Bonus] Generate Index/TOC:
    7. Tulis docs/alldocument/INDEX.md (ringkasan + link terstruktur ke subfolder)

Penggunaan:
    python run_all_docs.py "D:\\Path\\To\\Project"
    Atau skip graphify:
    python run_all_docs.py "D:\\Path\\To\\Project" --skip-graphify
"""

import os
import sys
import shutil
import subprocess
from datetime import datetime
from pathlib import Path

# Impor path resolver bersama
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common_paths import resolve_project_root, get_doc_dirs

def run_script(script_path: str, project_root: str, label: str) -> bool:
    print(f"  [>>] {label}...")
    result = subprocess.run(
        [sys.executable, script_path, str(project_root)],
        cwd=str(project_root),
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="ignore",
    )
    if result.returncode != 0:
        print(f"  [PERHATIAN] {label}:\\n{result.stderr.strip()}")
        return False
    print(f"  [OK] {label} selesai.")
    return True

def generate_index(dirs: dict, graphify_updated: bool):
    """Buat docs/alldocument/INDEX.md sebagai hub navigasi terstruktur."""
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    project_root = dirs["project_root"]
    docs_out = dirs["docs_root"]
    panduan_dir = dirs["panduan_dir"]
    laporan_dir = dirs["laporan_dir"]
    graphify_dir = dirs["graphify_dir"]
    banding_dir = dirs["banding_dir"]

    files = {
        "backend_lengkap": panduan_dir / "Panduan_Backend_Lengkap.md",
        "frontend_lengkap": panduan_dir / "Panduan_Frontend_Lengkap.md",
        "skrip_panduan": panduan_dir / "Panduan_Skrip_Dokumentasi.md",
        "handover": laporan_dir / "Handover_Progress_Report.md",
        "metode_uji": laporan_dir / "Metode_Pengujian_Backend.md",
        "backend_graphify": graphify_dir / "Panduan_Backend_Graphify.md",
        "frontend_graphify": graphify_dir / "Panduan_Frontend_Graphify.md",
        "banding_terakhir": banding_dir / "Laporan_Perbandingan_Terakhir.md",
    }

    def size_kb(path):
        p = Path(path)
        if p.exists():
            return f"{p.stat().st_size // 1024} KB"
        return "-"

    def status(path):
        return "Tersedia" if Path(path).exists() else "Belum Ada"

    graphify_note = (
        "Graphify di-update pada sesi ini"
        if graphify_updated
        else "Graphify tidak di-update sesi ini (lewati atau belum di-setup)"
    )

    lines = [
        f"# INDEX — Dokumentasi Proyek {project_root.name}\\n\\n",
        f"> **Terakhir di-generate:** {ts}\\n",
        f"> **Status Graphify:** {graphify_note}\\n\\n",
        "---\\n\\n",

        "## 1. Panduan Arsitektur & Kode (`panduan/`)\\n\\n",
        "| Dokumen | Deskripsi | Ukuran | Status |\\n",
        "|---|---|---|---|\\n",
        f"| [Panduan_Backend_Lengkap.md](panduan/Panduan_Backend_Lengkap.md) | Seluruh fungsi & class Python per file backend | {size_kb(files['backend_lengkap'])} | {status(files['backend_lengkap'])} |\\n",
        f"| [Panduan_Frontend_Lengkap.md](panduan/Panduan_Frontend_Lengkap.md) | Seluruh widget & fungsi Dart di frontend/lib | {size_kb(files['frontend_lengkap'])} | {status(files['frontend_lengkap'])} |\\n",
        f"| [Panduan_Skrip_Dokumentasi.md](panduan/Panduan_Skrip_Dokumentasi.md) | Panduan teknis cara pakai generator dokumentasi | {size_kb(files['skrip_panduan'])} | {status(files['skrip_panduan'])} |\\n",
        "\\n---\\n\\n",

        "## 2. Laporan Proyek & Pengujian (`laporan/`)\\n\\n",
        "| Dokumen | Deskripsi | Ukuran | Status |\\n",
        "|---|---|---|---|\\n",
        f"| [Handover_Progress_Report.md](laporan/Handover_Progress_Report.md) | Laporan progres handover & checklist fitur | {size_kb(files['handover'])} | {status(files['handover'])} |\\n",
        f"| [Metode_Pengujian_Backend.md](laporan/Metode_Pengujian_Backend.md) | Standar metode audit keamanan & testing backend | {size_kb(files['metode_uji'])} | {status(files['metode_uji'])} |\\n",
        "\\n---\\n\\n",

        "## 3. Dokumentasi Berbasis Knowledge Graph (`graphify/`)\\n\\n",
        "| Dokumen | Deskripsi | Ukuran | Status |\\n",
        "|---|---|---|---|\\n",
        f"| [Panduan_Backend_Graphify.md](graphify/Panduan_Backend_Graphify.md) | Relasi antar file backend, dependency map & call graph | {size_kb(files['backend_graphify'])} | {status(files['backend_graphify'])} |\\n",
        f"| [Panduan_Frontend_Graphify.md](graphify/Panduan_Frontend_Graphify.md) | Provider deps, import internal, relasi antar Dart file | {size_kb(files['frontend_graphify'])} | {status(files['frontend_graphify'])} |\\n",
        "\\n---\\n\\n",

        "## 4. Riwayat Perubahan & Perbandingan (`banding/`)\\n\\n",
        "| Folder / File | Deskripsi |\\n",
        "|---|---|\\n",
        f"| [Laporan_Perbandingan_Terakhir.md](banding/Laporan_Perbandingan_Terakhir.md) | Laporan diff terakhir (scan regex) |\\n",
        "| [banding/](banding/) | Arsip lengkap riwayat perubahan kode versi sebelumnya |\\n",
        "| [graphify/banding/](graphify/banding/) | Riwayat perbandingan versi Graphify |\\n",
        "\\n---\\n\\n",

        "## Struktur Folder Dokumentasi Bersih\\n\\n",
        "```text\\n",
        "docs/alldocument/\\n",
        "|-- INDEX.md              <- Hub navigasi utama (file ini)\\n",
        "|-- panduan/              <- Seluruh panduan arsitektur & kode\\n",
        "|-- laporan/              <- Laporan progres, handover, & audit\\n",
        "|-- banding/              <- Laporan diff kode versi sebelumnya\\n",
        "\\`-- graphify/             <- Knowledge graph dokumentasi & relasi\\n",
        "    \\`-- banding/          <- Riwayat perbandingan graphify\\n",
        "```\\n",
    ]

    index_file = dirs["index_path"]
    index_file.write_text("".join(lines), encoding="utf-8")
    print(f"  [OK] INDEX.md berhasil dibuat di: {index_file}")

def main(project_path=None):
    dirs = get_doc_dirs(project_path)
    project_root = dirs["project_root"]
    scripts_dir = Path(__file__).resolve().parent
    graphify_dir = scripts_dir / "graphify_docs"
    skip_graphify = "--skip-graphify" in sys.argv

    print("=" * 65)
    print(f"  AI TOOL MASTER DOCS GENERATOR")
    print(f"  Project Target : {project_root}")
    print(f"  Output Folder  : {dirs['docs_root']}")
    print("=" * 65)

    # 1. Kelompok 1: Scan langsung file kode
    print("\\n[Kelompok 1] Scan Langsung File Kode:")
    run_script(str(scripts_dir / "generate_backend_docs.py"), str(project_root), "1/3 Backend Docs")
    run_script(str(scripts_dir / "generate_frontend_docs.py"), str(project_root), "2/3 Frontend Docs")
    run_script(str(scripts_dir / "auto_generate_and_compare_docs.py"), str(project_root), "3/3 Banding & Diff")

    # 2. Kelompok 2: Graphify
    graphify_updated = False
    graph_json = project_root / "graphify-out" / "graph.json"

    if skip_graphify:
        print("\\n[Kelompok 2] Graphify dilewati (--skip-graphify).")
    else:
        print("\\n[Kelompok 2] Dokumentasi Berbasis Graphify:")
        graphify_bin = shutil.which("graphify")
        if graphify_bin:
            print("  [>>] Menjalankan graphify --update...")
            res = subprocess.run([graphify_bin, "--update"], cwd=str(project_root), capture_output=True, text=True)
            graphify_updated = (res.returncode == 0)
            if graphify_updated:
                print("  [OK] Graphify berhasil di-update.")
            else:
                print("  [i] graphify update menghasilkan catatan (melanjutkan pembacaan graph.json)...")
        else:
            print("  [i] Tool CLI 'graphify' tidak ditemukan di PATH, membaca graph.json lokal...")

        if graph_json.exists():
            run_script(str(graphify_dir / "generate_backend_graphify.py"), str(project_root), "4/6 Backend Graphify")
            run_script(str(graphify_dir / "generate_frontend_graphify.py"), str(project_root), "5/6 Frontend Graphify")
            run_script(str(graphify_dir / "auto_graphify_docs.py"), str(project_root), "6/6 Graphify Banding")
        else:
            print("  [i] graphify-out/graph.json tidak ditemukan di proyek ini. Melewati Kelompok 2.")

    # 3. Generate INDEX.md
    print("\\n[INDEX] Memperbarui Hub Navigasi INDEX.md...")
    generate_index(dirs, graphify_updated)

    print("\\n" + "=" * 65)
    print("  [SELESAI] Semua dokumentasi berhasil di-generate secara rapi!")
    print(f"  Lihat hasil di: {dirs['docs_root']}")
    print("=" * 65 + "\\n")

if __name__ == "__main__":
    p = None
    for arg in sys.argv[1:]:
        if not arg.startswith("-"):
            p = arg
            break
    main(p)
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\run_all_docs.py")
target.write_text(content, encoding="utf-8")
print("run_all_docs.py written successfully to", target)
