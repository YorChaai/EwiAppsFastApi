import os
import re

def parse_python_file(filepath, base_dir):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract imports
    imports = re.findall(r'^(?:from\s+[a-zA-Z0-9_\.]+\s+)?import\s+[a-zA-Z0-9_\.\,\s]+', content, re.MULTILINE)
    
    # Extract classes
    classes = re.findall(r'^class\s+([a-zA-Z0-9_]+)', content, re.MULTILINE)
    
    # Extract functions (def or async def)
    functions = re.findall(r'^(?:async\s+)?def\s+([a-zA-Z0-9_]+)\s*\(', content, re.MULTILINE)
    
    lines = content.split('\n')
    line_count = len(lines)
    
    rel_path = os.path.relpath(filepath, base_dir).replace('\\\\', '/')
    return {
        'path': rel_path,
        'imports': imports,
        'classes': classes,
        'functions': functions,
        'line_count': line_count
    }

base_dir = r'D:\Aplikasi\EWIApps\backend'
files_data = {}

# Exclude directories
exclude_dirs = ['venv', '_backup_', 'backup_postgres', '__pycache__', '.pytest_cache', '.ruff_cache', 'migrations', 'scratch', '_archive', 'backup', 'side', 'scripts', 'uploads']

for root, dirs, files in os.walk(base_dir):
    if 'side' in root.lower() or 'backup' in root.lower():
        continue
    # modify dirs in place to skip excluded directories
    dirs[:] = [d for d in dirs if d not in exclude_dirs and not d.startswith('.') and d.lower() != 'side']
    
    for file in files:
        if file.endswith('.py') and not file.startswith('__'):
            fp = os.path.join(root, file)
            rel_path = os.path.relpath(fp, base_dir).replace('\\\\', '/')
            try:
                files_data[rel_path] = parse_python_file(fp, base_dir)
            except Exception as e:
                pass

# Tambahan manual untuk file v14 khusus
backend_dir = r'D:\Aplikasi\EWIApps\backend'
v14_path = os.path.join(backend_dir, 'scratch', 'scanner_fokus', 'scripts', 'generate_hybrid_migration_v14.py')
if os.path.exists(v14_path):
    rel_path = 'scratch/scanner_fokus/scripts/generate_hybrid_migration_v14.py'
    try:
        files_data[rel_path] = parse_python_file(v14_path, backend_dir)
    except Exception as e:
        pass

out_path = r'D:\Aplikasi\EWIApps\docs\Panduan_Backend_Lengkap.md'
os.makedirs(os.path.dirname(out_path), exist_ok=True)

with open(out_path, 'w', encoding='utf-8') as f:
    f.write('# Panduan Lengkap Backend (MiniProjectKPI_EWI_Revisi2)\n\n')
    f.write('Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file Python di dalam folder `backend`.\n')
    f.write('Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi backend FastAPI tanpa harus membaca source code satu per satu.\n\n')
    
    folders = set(os.path.dirname(p) for p in files_data.keys())
    for folder in sorted(folders):
        display_folder = folder.replace('\\\\', '/') if folder else 'Root (backend)'
        f.write(f'## Folder: `{display_folder}`\n\n')
        
        if 'routes' in folder or 'controllers' in folder:
            f.write('**Tujuan Folder:** Menyimpan endpoint API (Routes) yang memproses HTTP Request dari frontend.\n\n')
        elif 'services' in folder:
            f.write('**Tujuan Folder:** Menangani logika bisnis yang lebih kompleks, agar file routes tidak terlalu besar.\n\n')
        elif 'models' in folder:
            f.write('**Tujuan Folder:** Mendefinisikan skema database (ORM) dan validasi data.\n\n')
        elif 'utils' in folder or 'helpers' in folder:
            f.write('**Tujuan Folder:** Menyimpan fungsi utilitas umum (formatting, perhitungan, auth helpers).\n\n')
            
        folder_files = [p for p in files_data.keys() if os.path.dirname(p) == folder]
        for path in sorted(folder_files):
            data = files_data[path]
            clean_path = path.replace('\\\\', '/')
            f.write(f'### File: `{clean_path}`\n\n')
            
            f.write('**Tanggung Jawab (Responsibility):**\n')
            if 'route' in path.lower():
                f.write('- Menerima request API, memvalidasi input, memanggil service/database, dan mereturn JSON response.\n')
            elif 'model' in path.lower():
                f.write('- Merepresentasikan tabel database (SQLAlchemy/lainnya) dan skema data.\n')
            elif 'app.py' in path.lower() or 'main.py' in path.lower():
                f.write('- Entry-point server backend. Melakukan inisialisasi aplikasi, database, middleware, dan mendaftarkan blueprint/routes.\n')
            elif 'config' in path.lower():
                f.write('- Mengelola environment variables dan konfigurasi server.\n')
            else:
                f.write('- Modul pendukung (helper, utilitas, script) spesifik sesuai nama file.\n')
            f.write('\n')
            
            f.write('**Hubungan & Alur Data:**\n')
            f.write(f'- **Dependencies (Menggunakan):** Meng-import {len(data["imports"])} dependensi (baik internal maupun eksternal).\n\n')
            
            f.write('**Hal Penting & Risiko:**\n')
            if data['line_count'] > 900:
                f.write('- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug karena tingginya kompleksitas. Pertimbangkan untuk memecah endpoint/logic ke file service terpisah.\n')
            elif data['line_count'] > 500:
                f.write('- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengubah struktur endpoint.\n')
            else:
                f.write('- Perubahan pada file ini tergolong aman.\n')
            f.write('\n')
            
            if data['classes']:
                f.write('**Classes Terdeteksi:**\n')
                for c in data['classes']:
                    f.write(f'- `{c}`\n')
                f.write('\n')
                
            if data['functions']:
                f.write('**Fungsi Utama (Metode/Endpoint):**\n')
                funcs = list(dict.fromkeys(data['functions']))
                for func in funcs:
                    f.write(f'- `{func}()`\n')
                f.write('\n')
            
            f.write('---\n\n')

print('Backend Documentation successfully generated.')
