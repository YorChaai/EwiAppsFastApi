import os
import re

def count_lines_in_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            has_part = any(re.match(r'^part \'', line) for line in lines)
            has_part_of = any(re.match(r'^part of \'', line) for line in lines)
            return len(lines), has_part, has_part_of
    except Exception:
        try:
            with open(filepath, 'r', encoding='latin-1') as f:
                lines = f.readlines()
                has_part = any(re.match(r'^part \'', line) for line in lines)
                has_part_of = any(re.match(r'^part of \'', line) for line in lines)
                return len(lines), has_part, has_part_of
        except Exception:
            return 0, False, False

def get_files_info():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    target_folders = ['frontend', 'backend']
    ignore_folders = ['side', 'node_modules', '.git', '__pycache__', 'build', '.dart_tool', 'windows', 'linux', 'macos', 'web', 'android', 'ios', 'venv', '.venv', 'migrations']
    
    file_list = []
    
    for folder in target_folders:
        folder_path = os.path.join(base_dir, folder)
        if not os.path.exists(folder_path):
            continue
            
        for root, dirs, files in os.walk(folder_path):
            dirs[:] = [d for d in dirs if d not in ignore_folders]
            
            for file in files:
                if file.endswith('.py') or file.endswith('.dart'):
                    filepath = os.path.join(root, file)
                    rel_path = os.path.relpath(filepath, base_dir)
                    lines, has_part, has_part_of = count_lines_in_file(filepath)
                    
                    status = '-'
                    if has_part:
                        status = 'Parent (God Object)'
                    elif has_part_of:
                        status = 'Child (part of)'
                        
                    file_list.append({
                        'file': rel_path.replace('\\', '/'),
                        'lines': lines,
                        'abs_path': filepath.replace('\\', '/'),
                        'status': status
                    })
                    
    file_list.sort(key=lambda x: x['lines'], reverse=True)
    return file_list

if __name__ == "__main__":
    files_info = get_files_info()
    
    output_path = r"C:\Users\diofa\.gemini\antigravity-ide\brain\3abf8707-aeb8-47d7-baa7-f9953e71a7f6\file_lines_report.md"
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("# Laporan Analisis File Codebase\n\n")
        f.write("Laporan ini menunjukkan jumlah baris setiap file serta mendeteksi file yang masih menggunakan pola `part` dan `part of` (indikasi God Objects).\n\n")
        f.write("| Nomor | Status Ketergantungan | File | Line |\n")
        f.write("|---|---|---|---|\n")
        
        for i, info in enumerate(files_info, 1):
            f.write(f"| {i} | {info['status']} | [{info['file']}](file:///{info['abs_path']}) | {info['lines']} |\n")
            
    print(f"Report generated at {output_path}")
