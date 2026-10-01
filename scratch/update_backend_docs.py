from pathlib import Path

content = '''import os
import re
import sys
from pathlib import Path

# Impor path resolver bersama
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from common_paths import resolve_project_root, get_doc_dirs

def parse_python_file(filepath, base_dir):
    with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Extract imports
    imports = re.findall(r'^(?:from\\s+[a-zA-Z0-9_\\.]+\\s+)?import\\s+[a-zA-Z0-9_\\.\\,\\s]+', content, re.MULTILINE)
    
    # Extract classes
    classes = re.findall(r'^class\\s+([a-zA-Z0-9_]+)', content, re.MULTILINE)
    
    # Extract functions (def or async def)
    functions = re.findall(r'^(?:async\\s+)?def\\s+([a-zA-Z0-9_]+)\\s*\\(', content, re.MULTILINE)
    
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
    backend_dir = str(dirs["backend_dir"])
    panduan_dir = dirs["panduan_dir"]
    out_path = panduan_dir / "Panduan_Backend_Lengkap.md"

    files_data = {}
    exclude_dirs = ['venv', '_backup_', 'backup_postgresql', '.git', 'node_modules', '__pycache__', 'scratch']

    for root, d_list, files in os.walk(backend_dir):
        if 'side' in root.lower() or 'backup' in root.lower():
            continue
        d_list[:] = [d for d in d_list if d not in exclude_dirs and not d.startswith('.') and d.lower() != 'side']
        
        for file in files:
            if file.endswith('.py') and not file.startswith('__'):
                fp = os.path.join(root, file)
                rel_path = os.path.relpath(fp, backend_dir).replace('\\\\', '/')
                try:
                    files_data[rel_path] = parse_python_file(fp, backend_dir)
                except Exception:
                    pass

    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(f'# Panduan Lengkap Backend ({project_root.name})\\n\\n')
        f.write('Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file Python di dalam folder backend.\\n')
        f.write('Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi backend tanpa harus membaca source code satu per satu.\\n\\n')
        
        folders = set(os.path.dirname(p) for p in files_data.keys())
        for folder in sorted(folders):
            display_folder = folder.replace('\\\\', '/') if folder else 'Root (backend)'
            f.write(f'## Folder: `{display_folder}`\\n\\n')
            
            if 'routes' in folder or 'blueprints' in folder:
                f.write('**Tujuan Folder:** Menyimpan API Endpoints / Blueprints yang dapat diakses oleh client / frontend.\\n\\n')
            elif 'models' in folder:
                f.write('**Tujuan Folder:** Menyimpan Blueprint Database / SQLAlchemy Models.\\n\\n')
            elif 'services' in folder or 'business' in folder:
                f.write('**Tujuan Folder:** Menyimpan Business Logic terpisah dari Route handler.\\n\\n')
            elif 'scripts' in folder:
                f.write('**Tujuan Folder:** Script CLI bantuan / utilitas perbaikan data dan otomatisasi.\\n\\n')
            else:
                f.write('**Tujuan Folder:** File inti atau modul pendukung backend.\\n\\n')
            
            folder_files = [k for k in files_data.keys() if os.path.dirname(k) == folder]
            for file_key in sorted(folder_files):
                data = files_data[file_key]
                f.write(f'### File: `{data["path"]}` ({data["line_count"]} baris)\\n')
                
                if data['line_count'] > 1000:
                    f.write('- **Peringatan (God Object / Overly Long):** File ini sangat besar (>1000 baris). Rentan menimbulkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.\\n')
                elif data['line_count'] > 500:
                    f.write('- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.\\n')
                else:
                    f.write('- Perubahan pada file ini tergolong aman.\\n')
                f.write('\\n')
                
                if data['classes']:
                    f.write('**Classes Terdeteksi:**\\n')
                    for c in data['classes']:
                        f.write(f'- `{c}`\\n')
                    f.write('\\n')
                    
                if data['functions']:
                    f.write('**Fungsi Utama (Metode/Endpoint):**\\n')
                    funcs = list(dict.fromkeys(data['functions']))
                    for func in funcs:
                        f.write(f'- `{func}()`\\n')
                    f.write('\\n')
                
                f.write('---\\n\\n')

    print(f'[v] Backend Documentation berhasil dibuat di: {out_path}')

if __name__ == "__main__":
    p = sys.argv[1] if len(sys.argv) > 1 else None
    run(p)
'''

target = Path(r"D:\Aplikasi\aitool\docs_generator\generate_backend_docs.py")
target.write_text(content, encoding="utf-8")
print("generate_backend_docs.py updated successfully.")
