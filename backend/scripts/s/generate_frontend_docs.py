import os
import re

def parse_dart_file(filepath, base_dir):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract imports
    imports = re.findall(r"import\s+['\"]([^'\"]+)['\"]", content)
    
    # Extract classes
    classes = re.findall(r'(?:class|mixin|extension)\s+([a-zA-Z0-9_]+)', content)
    
    # Extract functions (very basic heuristic)
    functions = re.findall(r'(?:Future<[^>]+>|[a-zA-Z0-9_]+)\s+([a-zA-Z0-9_]+)\s*\([^)]*\)\s*(?:async\s*)?{', content)
    functions = [f for f in functions if f not in ('if', 'else', 'for', 'while', 'switch', 'catch')]
    
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

base_dir = r'D:\Aplikasi\EWIApps\frontend\lib'
files_data = {}

for root, _, files in os.walk(base_dir):
    if 'backup' in root.lower() or 'side' in root.lower(): continue
    for file in files:
        if file.endswith('.dart') and 'backup' not in file.lower() and 'side' not in file.lower():
            fp = os.path.join(root, file)
            rel_path = os.path.relpath(fp, base_dir).replace('\\\\', '/')
            try:
                files_data[rel_path] = parse_dart_file(fp, base_dir)
            except Exception as e:
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

out_path = r'D:\Aplikasi\EWIApps\docs\Panduan_Frontend_Lengkap.md'
os.makedirs(os.path.dirname(out_path), exist_ok=True)

with open(out_path, 'w', encoding='utf-8') as f:
    f.write('# Panduan Lengkap Frontend (MiniProjectKPI_EWI_Revisi2)\n\n')
    f.write('Dokumen ini digenerate secara menyeluruh untuk merinci struktur, peran, dependensi, fungsi, dan isi dari setiap file di dalam `frontend/lib`.\n')
    f.write('Ditujukan agar developer baru atau AI (LLM) dapat memahami aplikasi tanpa harus membaca source code satu per satu.\n\n')
    
    folders = set(os.path.dirname(p) for p in files_data.keys())
    for folder in sorted(folders):
        display_folder = folder.replace('\\\\', '/') if folder else 'Root (lib)'
        f.write(f'## Folder: `{display_folder}`\n\n')
        
        if 'screens' in folder:
            f.write('**Tujuan Folder:** Menyimpan komponen antarmuka pengguna (UI) dan halaman-halaman aplikasi (Screens/Views).\n\n')
        elif 'providers' in folder:
            f.write('**Tujuan Folder:** Mengelola state aplikasi (State Management) dan logika bisnis utama (Controllers).\n\n')
        elif 'models' in folder:
            f.write('**Tujuan Folder:** Mendefinisikan struktur data (Blueprint/Model) dan fungsi konversi (fromJson/toJson).\n\n')
        elif 'services' in folder:
            f.write('**Tujuan Folder:** Menangani komunikasi ke luar, seperti pemanggilan API ke backend (HTTP requests).\n\n')
        elif 'widgets' in folder:
            f.write('**Tujuan Folder:** Menyimpan komponen visual (Widget) yang dapat digunakan berulang (Reusable) di berbagai layar.\n\n')
        elif 'utils' in folder or 'mixins' in folder or 'theme' in folder:
            f.write('**Tujuan Folder:** Menyimpan fungsi-fungsi pembantu (Helpers), utilitas, dan konfigurasi tema global.\n\n')
            
        folder_files = [p for p in files_data.keys() if os.path.dirname(p) == folder]
        for path in sorted(folder_files):
            data = files_data[path]
            clean_path = path.replace('\\\\', '/')
            f.write(f'### File: `{clean_path}`\n\n')
            
            f.write('**Tanggung Jawab (Responsibility):**\n')
            if 'screen' in path.lower():
                f.write('- Menangani tampilan UI dan interaksi langsung dengan pengguna untuk fitur terkait.\n')
            elif 'provider' in path.lower():
                f.write('- Menampung state (data sementara) dan mengelola logika pembaruan layar saat data berubah.\n')
            elif 'model' in path.lower():
                f.write('- Mendefinisikan entitas data agar dapat dikenali dan diproses dengan aman (Type-safe) oleh Dart.\n')
            elif 'widget' in path.lower() or 'dialog' in path.lower() or 'card' in path.lower() or 'tile' in path.lower() or 'header' in path.lower() or 'layout' in path.lower():
                f.write('- Menyediakan potongan UI terpisah (komponen) agar kode lebih rapi dan modular.\n')
            elif path == 'main.dart':
                f.write('- File entry-point utama aplikasi. Menginisialisasi service, provider global, dan routing aplikasi.\n')
            else:
                f.write('- Modul pendukung (helper, utilitas, atau service) spesifik sesuai nama file.\n')
            f.write('\n')
            
            f.write('**Hubungan & Alur Data:**\n')
            f.write(f'- **Dependencies (Menggunakan):** Meng-import {len(data["imports"])} dependensi/file lain.\n')
            used_by = reverse_deps.get(path, [])
            if used_by:
                example_used = used_by[0].replace('\\\\', '/')
                f.write(f'- **Used By (Digunakan Oleh):** {len(used_by)} file lokal (contoh: `{example_used}`).\n')
            else:
                f.write('- **Used By (Digunakan Oleh):** Tidak dideteksi import eksplisit di file lokal lain (mungkin di-import melalui package import atau part of).\n')
            f.write('\n')
            
            f.write('**Hal Penting & Risiko:**\n')
            if data['line_count'] > 900:
                f.write('- **RISIKO TINGGI (File Sangat Besar):** File ini memiliki lebih dari 900 baris. Perubahan pada file ini rentan menyebabkan bug pada UI atau logic lain karena banyak komponen bergantung pada satu file ini. Pertimbangkan untuk memecah UI (extract widget) atau memindahkan logic ke file terpisah.\n')
            elif data['line_count'] > 500:
                f.write('- **Perhatian (File Besar):** File ini cukup panjang. Hati-hati saat mengedit karena scope-nya luas.\n')
            else:
                f.write('- Perubahan pada file ini tergolong aman. Modifikasi UI/Logika dasar dapat dilakukan tanpa banyak side-effect.\n')
            f.write('\n')
            
            if data['classes']:
                f.write('**Classes / Mixins / Widgets Terdeteksi:**\n')
                for c in data['classes']:
                    f.write(f'- `{c}`\n')
                f.write('\n')
                
            if data['functions']:
                f.write('**Fungsi / Logika Utama:**\n')
                funcs = list(dict.fromkeys(data['functions']))
                for func in funcs:
                    if func == 'build':
                        f.write(f'- `{func}()`: Membangun struktur UI/widget.\n')
                    elif func == 'initState':
                        f.write(f'- `{func}()`: Inisialisasi awal (lifecycle) saat komponen diload.\n')
                    elif func == 'dispose':
                        f.write(f'- `{func}()`: Membersihkan memori (cleanup) saat komponen ditutup.\n')
                    elif func == 'fromJson':
                        f.write(f'- `{func}()`: Parsing JSON response backend menjadi object Dart.\n')
                    elif func == 'toJson':
                        f.write(f'- `{func}()`: Parsing object Dart untuk dikirim ke backend (JSON).\n')
                    elif func == 'createState':
                        f.write(f'- `{func}()`: Membuat state untuk StatefulWidget.\n')
                    else:
                        f.write(f'- `{func}()`\n')
                f.write('\n')
            
            f.write('---\n\n')

print('Documentation successfully generated.')
