from pathlib import Path

content = '''import os
import re
import sys
from pathlib import Path

# Impor path resolver bersama
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common_paths import resolve_project_root, get_doc_dirs

def parse_dart_file(filepath, base_dir):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Extract imports
    imports = re.findall(r"import\\s+['\\\"]([^'\\\"]+)['\\\"]", content)
    
    # Extract classes
    classes = re.findall(r'(?:class|mixin|extension)\\s+([a-zA-Z0-9_]+)', content)
    
    # Extract functions (basic heuristic)
    functions = re.findall(r'(?:Future<[^>]+>|[a-zA-Z0-9_]+)\\s+([a-zA-Z0-9_]+)\\s*\\([^)]*\\)\\s*(?:async\\s*)?{', content)
    functions = [f for f in functions if f not in ('if', 'else', 'for', 'while', 'switch', 'catch')]
    
    lines = content.split('\\n')
    line_count = len(lines)
    
    rel_path = os.path.relpath(filepath, base_dir).replace('\\\\', '/')
    return {
        'path': rel_path,
        'imports': imports,
        'classes': classes,
        'functions': functions,
        'line_count': line_count
    }

def run(project_path=None):
    dirs = get_doc_dirs(project_path)
    project_root = dirs["project_root"]
    base_dir = str(dirs["frontend_lib_dir"])
    panduan_dir = dirs["panduan_dir"]
    out_path = panduan_dir / "Panduan_Frontend_Lengkap.md"

    if not Path(base_dir).exists():
        print(f"[i] Folder frontend/lib tidak ditemukan di {base_dir}. Melewati dokumentasi frontend.")
        return

    files_data = {}
    for root, _, files in os.walk(base_dir):
        if 'backup' in root.lower() or 'side' in root.lower():
            continue
        for file in files:
            if file.endswith('.dart') and 'backup' not in file.lower() and 'side' not in file.lower():
                fp = os.path.join(root, file)
                rel_path = os.path.relpath(fp, base_dir).replace('\\\\', '/')
                try:
                    files_data[rel_path] = parse_dart_file(fp, base_dir)
                except Exception:
                    pass

    reverse_deps = {k: [] for k in files_data.keys()}
    for path, data in files_data.items():
        for imp in data['imports']:
            if not imp.startswith('package:'):
                curr_dir = os.path.dirname(path)
                norm_imp = os.path.normpath(os.path.join(curr_dir, imp)).replace('\\\\', '/')
                if norm_imp in reverse_deps:
                    if path not in reverse_deps[norm_imp]:
                        reverse_deps[norm_imp].append(path)

    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(f'# Panduan Lengkap Frontend ({project_root.name})\\n\\n')
        f.write('Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file di dalam `frontend/lib`.\\n')
        f.write('Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi tanpa harus membaca source code satu per satu.\\n\\n')
        
        folders = set(os.path.dirname(p) for p in files_data.keys())
        for folder in sorted(folders):
            display_folder = folder.replace('\\\\', '/') if folder else 'Root (lib)'
            f.write(f'## Folder: `{display_folder}`\\n\\n')
            
            if 'screens' in folder:
                f.write('**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).\\n\\n')
            elif 'providers' in folder:
                f.write('**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).\\n\\n')
            elif 'models' in folder:
                f.write('**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).\\n\\n')
            elif 'services' in folder:
                f.write('**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).\\n\\n')
            elif 'widgets' in folder:
                f.write('**Tujuan Folder:** Komponen UI modular yang dapat digunakan kembali lintas screen (Reusable Widgets).\\n\\n')
            elif 'utils' in folder:
                f.write('**Tujuan Folder:** Fungsi bantuan, formatter, helper tanggal/uang, dan konstanta aplikasi.\\n\\n')
            else:
                f.write('**Tujuan Folder:** Berisi konfigurasi dasar aplikasi atau inisialisasi awal.\\n\\n')
                
            folder_files = [k for k in files_data.keys() if os.path.dirname(k) == folder]
            for file_key in sorted(folder_files):
                data = files_data[file_key]
                f.write(f'### File: `{data["path"]}` ({data["line_count"]} baris)\\n')
                
                # Risk Warnings
                if data['line_count'] > 1000:
                    f.write('- **Peringatan Kritis:** File ini tergolong "Monster File" (>1000 baris). Mengubahnya memiliki risiko regresi tinggi. Disarankan untuk memecah komponen ke sub-widget terpisah.\\n')
                elif data['line_count'] > 500:
                    f.write('- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati terhadap dependencies yang berubah.\\n')
                else:
                    f.write('- File ini berukuran ringkas/standar.\\n')
                f.write('\\n')
                
                # Classes
                if data['classes']:
                    f.write('**Classes/Widgets:**\\n')
                    for c in data['classes']:
                        f.write(f'- `{c}`\\n')
                    f.write('\\n')
                    
                # Functions
                if data['functions']:
                    f.write('**Fungsi Utama Terdeteksi:**\\n')
                    funcs = list(dict.fromkeys(data['functions']))
                    for func in funcs[:15]:
                        f.write(f'- `{func}()`\\n')
                    if len(funcs) > 15:
                        f.write(f'- *(dan {len(funcs) - 15} fungsi lainnya...)*\\n')
                    f.write('\\n')
                    
                # Reverse Dependencies
                if reverse_deps[file_key]:
                    f.write('**Digunakan oleh (Reverse Dependencies):**\\n')
                    for dep in sorted(reverse_deps[file_key]):
                        f.write(f'- `{dep}`\\n')
                    f.write('\\n')
                    
                f.write('---\\n\\n')

    print(f'[v] Frontend Documentation berhasil dibuat di: {out_path}')

if __name__ == "__main__":
    p = sys.argv[1] if len(sys.argv) > 1 else None
    run(p)
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\generate_frontend_docs.py")
target.write_text(content, encoding="utf-8")
print("generate_frontend_docs.py updated successfully.")
