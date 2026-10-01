import os
import shutil
import re
import difflib
import subprocess
from datetime import datetime

ROOT_DIR = r"D:\Aplikasi\EWIApps"
TOOLS_DIR = os.path.dirname(os.path.abspath(__file__))
DOCS_DIR = os.path.join(ROOT_DIR, "docs")
ALL_DOCS_DIR = os.path.join(DOCS_DIR, "alldocument")
BANDING_DIR = os.path.join(ALL_DOCS_DIR, "banding")

def run_generators():
    print("[1/4] Menjalankan generator dokumen Backend...")
    subprocess.run(["python", os.path.join(TOOLS_DIR, "generate_backend_docs.py")], cwd=ROOT_DIR, check=True)
    
    print("[2/4] Menjalankan generator dokumen Frontend...")
    subprocess.run(["python", os.path.join(TOOLS_DIR, "generate_frontend_docs.py")], cwd=ROOT_DIR, check=True)

def parse_sections(markdown_text):
    """Memecah markdown menjadi dictionary berdasarkan header '### File:'."""
    sections = {}
    if not markdown_text:
        return sections
        
    # Split by ### File:
    parts = re.split(r'^### File: ', markdown_text, flags=re.MULTILINE)
    
    # Bagian pertama (parts[0]) adalah header root, kita abaikan saja.
    for part in parts[1:]:
        lines = part.split('\n')
        if not lines: continue
        filename = lines[0].strip('`').strip()
        content = '\n'.join(lines[1:]).strip()
        sections[filename] = content
        
    return sections

def compare_sections(old_sections, new_sections):
    """Mengembalikan dict berisi added, removed, modified"""
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
            # Gunakan difflib untuk mendapatkan unified diff
            old_lines = old_text.splitlines()
            new_lines = new_text.splitlines()
            diff = list(difflib.unified_diff(old_lines, new_lines, lineterm='', n=2))
            modified[key] = '\n'.join(diff[2:]) # Skip header difflib
            
    return added, removed, modified

def build_diff_report(title, added, removed, modified):
    report = [f"## {title}\n"]
    
    if not added and not removed and not modified:
        report.append("> ✅ **Tidak ada perubahan pada dokumentasi ini.**\n")
        return "".join(report)
        
    if added:
        report.append("### 🆕 File Baru / Dokumentasi Ditambahkan\n")
        for f in sorted(added):
            report.append(f"- `{f}`\n")
        report.append("\n")
        
    if removed:
        report.append("### ❌ File Dihapus / Dokumentasi Dihapus\n")
        for f in sorted(removed):
            report.append(f"- `{f}`\n")
        report.append("\n")
        
    if modified:
        report.append("### 📝 Dokumentasi Diedit\n")
        for f in sorted(modified):
            report.append(f"#### Perubahan pada: `{f}`\n")
            report.append("```diff\n")
            report.append(modified[f] + "\n")
            report.append("```\n\n")
            
    report.append("---\n")
    return "".join(report)

def main():
    print("Memulai proses otomatisasi dokumentasi...\n")
    
    # 1. Jalankan generator
    run_generators()
    
    # 2. Siapkan direktori output
    os.makedirs(ALL_DOCS_DIR, exist_ok=True)
    os.makedirs(BANDING_DIR, exist_ok=True)
    
    print("\n[3/4] Melakukan perbandingan cerdas (Smart Diffing)...")
    
    files_to_compare = {
        "Backend": "Panduan_Backend_Lengkap.md",
        "Frontend": "Panduan_Frontend_Lengkap.md"
    }
    
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_filename = f"Laporan_Perubahan_{timestamp}.md"
    report_path = os.path.join(BANDING_DIR, report_filename)
    
    full_report = [
        f"# Laporan Perubahan Dokumentasi\n",
        f"**Tanggal Generate:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n",
        "Laporan ini mendeteksi perubahan struktur kode (file ditambahkan, dihapus, atau dimodifikasi) yang berdampak pada dokumentasi.\n\n",
        "---\n\n"
    ]
    
    for title, filename in files_to_compare.items():
        new_file = os.path.join(DOCS_DIR, filename)
        old_file = os.path.join(ALL_DOCS_DIR, filename)
        
        # Baca teks baru
        if os.path.exists(new_file):
            with open(new_file, 'r', encoding='utf-8') as f:
                new_text = f.read()
        else:
            new_text = ""
            
        # Baca teks lama
        if os.path.exists(old_file):
            with open(old_file, 'r', encoding='utf-8') as f:
                old_text = f.read()
        else:
            old_text = ""
            
        # Parse & Compare
        old_sections = parse_sections(old_text)
        new_sections = parse_sections(new_text)
        
        added, removed, modified = compare_sections(old_sections, new_sections)
        
        # Tambahkan ke laporan
        section_report = build_diff_report(f"Perubahan {title}", added, removed, modified)
        full_report.append(section_report)
        
        # 3. Salin/Timpa file baru ke folder alldocument
        if os.path.exists(new_file):
            shutil.copy2(new_file, old_file)
            print(f" -> {filename} terbaru berhasil disalin ke alldocument.")
            
    # Tulis laporan
    with open(report_path, 'w', encoding='utf-8') as f:
        f.write("".join(full_report))
        
    print(f"\n[4/4] Selesai! Laporan perbandingan tersimpan di:")
    print(f" -> {report_path}")

if __name__ == "__main__":
    main()
