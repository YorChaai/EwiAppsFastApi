import os

path = 'frontend/lib/screens/widget_type_toggle.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

content = "import 'widget_toggle_button.dart';\n" + content

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
