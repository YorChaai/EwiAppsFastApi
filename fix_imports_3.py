import os
import re

path = 'frontend/lib/screens/main_layout_settlement_list.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r'void reloadSettlements\(\) => reloadSettlements\(\);\s*', '', content)

extra_imports = """import 'widget_scrollable_settlement_header.dart';
import 'main_layout_components/widget_summary_cards.dart';
import 'main_layout_widgets.dart';
import 'main_layout_settlement_list_dialogs.dart';
import 'widget_type_toggle.dart';
"""
content = extra_imports + '\n' + content

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

path = 'frontend/lib/screens/main_layout_settlement_list_dialogs.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'dart:io' not in content:
    content = "import 'dart:io';\n" + content

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
