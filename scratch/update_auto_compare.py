from pathlib import Path

content = '''import os
import sys
import shutil
import re
import difflib
import subprocess
from datetime import datetime
from pathlib import Path

# Impor path resolver bersama
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common_paths import resolve_project_root, get_doc_dirs

def parse_sections(markdown_text):
    sections = {}
    if not markdown_text:
        return sections
    parts = re.split(r'^### File: ', markdown_text, flags=re.MULTILINE)
    for part in parts[1:]:
        lines = part.split('\\n')
        if not lines: continue
        filename = lines[0].strip('`').strip()
        content = '\\n'.join(lines[1:]).strip()
        sections[filename] = content
    return sections

def compare_sections(old_sections, new_sections):
    old_keys = set(old_sections.keys())
    new_keys = set(new_sections.keys())
    
    added = new_keys - old_keys
    removed = old_keys - new_keys
    common = old_keys & new_keys
    
    modified = {}
    for key in common:
        old_text = old_sections[key]
        new_text = new_sections[key]
        if old_text != new_text:
            old_lines = old_text.splitlines()
            new_lines = new_text.splitlines()
            diff = list(difflib.unified_diff(old_lines, new_lines, lineterm='', n=2))
            modified[key] = '\\n'.join(diff[2:])
            
    return added, removed, modified

def run(project_path=None):
    dirs = get_doc_dirs(project_path)
    project_root = dirs["project_root"]
    panduan_dir = dirs["panduan_dir"]
    banding_dir = dirs["banding_dir"]

    # Jalankan generator backend & frontend
    script_dir = Path(__file__).resolve().parent
    print("[1/4] Menjalankan generator dokumen Backend...")
    subprocess.run([sys.executable, str(script_dir / "generate_backend_docs.py"), str(project_root)], check=True)
    
    print("[2/4] Menjalankan generator dokumen Frontend...")
    subprocess.run([sys.executable, str(script_dir / "generate_frontend_docs.py"), str(project_root)], check=True)

    files_to_track = [
        "Panduan_Backend_Lengkap.md",
        "Panduan_Frontend_Lengkap.md"
    ]

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    display_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    report_lines = [
        f"# LAPORAN PERUBAHAN ARSITEKTUR KODE ({project_root.name})",
        f"*Dibuat pada: {display_time}*",
        "",
        "> Laporan ini membandingkan versi panduan kode saat ini dengan versi snapshot sebelumnya.",
        ""
    ]

    has_changes = False

    for fname in files_to_track:
        current_file = panduan_dir / fname
        backup_file = banding_dir / f".prev_{fname}"

        if not current_file.exists():
            continue

        curr_text = current_file.read_text(encoding='utf-8', errors='ignore')
        prev_text = ""
        if backup_file.exists():
            prev_text = backup_file.read_text(encoding='utf-8', errors='ignore')

        if not prev_text:
            report_lines.append(f"## {fname}: Inisialisasi Pertama (Snapshot Awal)")
            report_lines.append(f"- Dokumen `{fname}` baru pertama kali dicatat baseline-nya.")
            report_lines.append("")
            backup_file.write_text(curr_text, encoding='utf-8')
            continue

        old_sec = parse_sections(prev_text)
        new_sec = parse_sections(curr_text)
        added, removed, modified = compare_sections(old_sec, new_sec)

        if not added and not removed and not modified:
            report_lines.append(f"## {fname}: Tidak Ada Perubahan")
            report_lines.append("- Seluruh fungsi, struktur class, dan endpoint masih identik dengan snapshot sebelumnya.")
            report_lines.append("")
        else:
            has_changes = True
            report_lines.append(f"## {fname}: Terdeteksi Perubahan!")
            if added:
                report_lines.append("### [+] File / Komponen Baru Ditambahkan:")
                for a in sorted(added):
                    report_lines.append(f"- `{a}`")
                report_lines.append("")
            if removed:
                report_lines.append("### [-] File Dihapus / Dipindahkan:")
                for r in sorted(removed):
                    report_lines.append(f"- `{r}`")
                report_lines.append("")
            if modified:
                report_lines.append(f"### [*] File Mengalami Modifikasi ({len(modified)} file):")
                for m, diff_text in sorted(modified.items()):
                    report_lines.append(f"#### File: `{m}`")
                    report_lines.append("```diff")
                    report_lines.append(diff_text[:1500] if len(diff_text) > 1500 else diff_text)
                    if len(diff_text) > 1500:
                        report_lines.append("... [diff dipotong untuk efisiensi]")
                    report_lines.append("```")
                    report_lines.append("")

        # Perbarui snapshot backup
        backup_file.write_text(curr_text, encoding='utf-8')

    report_content = '\\n'.join(report_lines)
    history_report = banding_dir / f"Laporan_Banding_{timestamp}.md"
    latest_report = banding_dir / "Laporan_Perbandingan_Terakhir.md"

    history_report.write_text(report_content, encoding='utf-8')
    latest_report.write_text(report_content, encoding='utf-8')

    print(f"[v] Laporan perbandingan tersimpan di: {latest_report}")
    return latest_report

if __name__ == "__main__":
    p = sys.argv[1] if len(sys.argv) > 1 else None
    run(p)
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\auto_generate_and_compare_docs.py")
target.write_text(content, encoding="utf-8")
print("auto_generate_and_compare_docs.py updated successfully.")
