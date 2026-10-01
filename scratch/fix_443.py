from pathlib import Path

p = Path(r'D:\Aplikasi\aitool\project_menu.py')
t = p.read_text(encoding='utf-8')
bad = 'print(f"\\n" + "="*56 + "\\n   5 COMMIT TERAKHIR\n" + "="*56)'
good = 'print("\\n" + "="*56 + "\\n   5 COMMIT TERAKHIR\\n" + "="*56)'
t = t.replace(bad, good)
p.write_text(t, encoding='utf-8')
print("Fixed line 443")
