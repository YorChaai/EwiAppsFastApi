from pathlib import Path
import re

p = Path(r'D:\Aplikasi\aitool\project_menu.py')
text = p.read_text(encoding='utf-8')

# Ganti baris yang dimulai dengan print(" \n atau print(f" \n atau input(" \n
text = re.sub(r'print\(f?"\n', r'print(f"\n', text)
text = re.sub(r'input\("\n', r'input("\n', text)
text = re.sub(r'print\("\n', r'print("\n', text)

# Ganti specifically string broken
text = text.replace('print(" \n', 'print("\\n')
text = text.replace('print("\n', 'print("\\n')
text = text.replace('print(f"\n', 'print(f"\\n')
text = text.replace('input("\n', 'input("\\n')
text = text.replace('"\n + "="*56', '"\\n" + "="*56')
text = text.replace('"\n   5 COMMIT', '"\\n   5 COMMIT')

p.write_text(text, encoding='utf-8')
print("Sanitized project_menu.py successfully.")
