"""
auto_graphify_docs.py
======================
Script BARU (terpisah dari auto_generate_and_compare_docs.py).
Orkestrator utama yang menjalankan kedua generator graphify:
  1. generate_backend_graphify.py  → docs/Panduan_Backend_Graphify.md
  2. generate_frontend_graphify.py → docs/Panduan_Frontend_Graphify.md

Lalu membandingkan dengan versi lama di docs/alldocument/ (smart diff),
menghasilkan laporan di docs/alldocument/banding/, dan membersihkan laporan
yang lebih dari 30 hari.

Cara menjalankan (dari root proyek):
    python backend/scripts/graphify_docs/auto_graphify_docs.py
"""

import os
import re
import shutil
import difflib
import subprocess
from datetime import datetime, timedelta

# ─── CONFIG ────────────────────────────────────────────────────────────────────
ROOT_DIR      = r"D:\Aplikasi\EWIApps"
SCRIPTS_DIR   = os.path.dirname(os.path.abspath(__file__))
GRAPHIFY_DIR  = os.path.join(ROOT_DIR, "docs", "alldocument", "graphify")
BANDING_DIR   = os.path.join(GRAPHIFY_DIR, "banding")
CLEANUP_DAYS  = 30  # laporan banding lebih lama dari ini akan dihapus

FILES_TO_COMPARE = {
    "Backend (Graphify)":  "Panduan_Backend_Graphify.md",
    "Frontend (Graphify)": "Panduan_Frontend_Graphify.md",
}

# ─── GENERATOR ─────────────────────────────────────────────────────────────────

def run_generators():
    for name, script in [
        ("Backend",  "generate_backend_graphify.py"),
        ("Frontend", "generate_frontend_graphify.py"),
    ]:
        script_path = os.path.join(SCRIPTS_DIR, script)
        print(f"  [>>] Menjalankan {script} ...")
        result = subprocess.run(
            ["python", script_path],
            cwd=ROOT_DIR,
            capture_output=True,
            text=True,
            encoding="utf-8",
        )
        if result.returncode != 0:
            print(f"  [ERROR] pada {script}:\n{result.stderr}")
        else:
            print(f"  [OK] {name} selesai.")

# ─── SMART DIFF ────────────────────────────────────────────────────────────────

def parse_sections(markdown_text: str) -> dict:
    """Pecah markdown menjadi dict berdasarkan header '### File:'."""
    sections = {}
    if not markdown_text:
        return sections
    parts = re.split(r'^### File: ', markdown_text, flags=re.MULTILINE)
    for part in parts[1:]:
        lines = part.split("\n")
        if not lines:
            continue
        filename = lines[0].strip("`").strip()
        content  = "\n".join(lines[1:]).strip()
        sections[filename] = content
    return sections


def compare_sections(old: dict, new: dict):
    old_keys = set(old.keys())
    new_keys = set(new.keys())
    added    = new_keys - old_keys
    removed  = old_keys - new_keys
    modified = {}
    for key in old_keys & new_keys:
        if old[key] != new[key]:
            diff = list(difflib.unified_diff(
                old[key].splitlines(), new[key].splitlines(), lineterm="", n=2
            ))
            modified[key] = "\n".join(diff[2:])
    return added, removed, modified


def build_diff_section(title: str, added, removed, modified: dict) -> str:
    lines = [f"## {title}\n"]
    if not added and not removed and not modified:
        lines.append("> ✅ **Tidak ada perubahan.**\n")
        lines.append("---\n")
        return "".join(lines)
    if added:
        lines.append("### 🆕 File / Entitas Baru\n")
        for f in sorted(added):
            lines.append(f"- `{f}`\n")
        lines.append("\n")
    if removed:
        lines.append("### ❌ File / Entitas Dihapus\n")
        for f in sorted(removed):
            lines.append(f"- `{f}`\n")
        lines.append("\n")
    if modified:
        lines.append("### 📝 Konten Berubah\n")
        for f in sorted(modified):
            lines.append(f"#### `{f}`\n")
            lines.append("```diff\n")
            lines.append(modified[f] + "\n")
            lines.append("```\n\n")
    lines.append("---\n")
    return "".join(lines)

# ─── CLEANUP ───────────────────────────────────────────────────────────────────

def cleanup_old_reports():
    cutoff = datetime.now() - timedelta(days=CLEANUP_DAYS)
    removed = 0
    for fname in os.listdir(BANDING_DIR):
        if not fname.startswith("Laporan_Perubahan_") or not fname.endswith(".md"):
            continue
        fpath = os.path.join(BANDING_DIR, fname)
        mtime = datetime.fromtimestamp(os.path.getmtime(fpath))
        if mtime < cutoff:
            os.remove(fpath)
            removed += 1
    if removed:
        print(f"  [cleanup] {removed} laporan lama (> {CLEANUP_DAYS} hari) dihapus dari banding/.")

# ─── MAIN ──────────────────────────────────────────────────────────────────────

def main():
    print("\n=== Auto Graphify Docs ===\n")

    os.makedirs(GRAPHIFY_DIR, exist_ok=True)
    os.makedirs(BANDING_DIR, exist_ok=True)

    # 1. Generate
    print("[1/4] Menjalankan generator Graphify ...")
    run_generators()

    # 2. Diff
    print("\n[2/4] Membandingkan dengan versi sebelumnya ...")
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_path = os.path.join(BANDING_DIR, f"Laporan_Graphify_{ts}.md")

    full_report = [
        "# Laporan Perubahan Dokumentasi Graphify\n",
        f"**Tanggal Generate:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n",
        "Laporan ini mendeteksi perubahan pada dokumentasi berbasis Knowledge Graph.\n\n",
        "---\n\n",
    ]

    summary_stats = {"added": 0, "removed": 0, "modified": 0}

    for title, filename in FILES_TO_COMPARE.items():
        # File sudah langsung di graphify/ (output generator)
        cur_file = os.path.join(GRAPHIFY_DIR, filename)
        # Arsip sebelumnya di graphify/archive/ untuk perbandingan
        archive_dir = os.path.join(GRAPHIFY_DIR, "archive")
        os.makedirs(archive_dir, exist_ok=True)
        old_file = os.path.join(archive_dir, filename)

        new_text = open(cur_file, encoding="utf-8").read() if os.path.exists(cur_file) else ""
        old_text = open(old_file, encoding="utf-8").read() if os.path.exists(old_file) else ""

        old_sec = parse_sections(old_text)
        new_sec = parse_sections(new_text)

        added, removed, modified = compare_sections(old_sec, new_sec)
        summary_stats["added"]    += len(added)
        summary_stats["removed"]  += len(removed)
        summary_stats["modified"] += len(modified)

        section = build_diff_section(f"Perubahan {title}", added, removed, modified)
        full_report.append(section + "\n")

        # Simpan salinan terbaru ke archive/ untuk diff berikutnya
        if os.path.exists(cur_file):
            shutil.copy2(cur_file, old_file)
            print(f"  -> {filename} disalin ke graphify/archive/")

    # 3. Tulis laporan
    print("\n[3/4] Menulis laporan diff ...")
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("".join(full_report))

    # 4. Cleanup laporan lama
    print("\n[4/4] Membersihkan laporan lama ...")
    cleanup_old_reports()

    # Summary
    print(f"""
=== Selesai! ===
   Laporan  : {report_path}
   Baru     : {summary_stats['added']}
   Dihapus  : {summary_stats['removed']}
   Diubah   : {summary_stats['modified']}
""")


if __name__ == "__main__":
    main()
