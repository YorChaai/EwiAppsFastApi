from pathlib import Path
p = Path(r'D:\Aplikasi\aitool\project_menu.py')
t = p.read_text(encoding='utf-8')
t = t.replace('print(f"\n[INFO] Menjalankan Master', 'print(f"\\n[INFO] Menjalankan Master')
t = t.replace('input("\nBuka folder dokumentasi', 'input("\\nBuka folder dokumentasi')
t = t.replace('input("\nBuka folder banding', 'input("\\nBuka folder banding')
p.write_text(t, encoding='utf-8')
print('Fixed lines in project_menu.py')
