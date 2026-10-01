import os
import re

path = 'frontend/lib/screens/main_layout.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# Remove part lines
content = re.sub(r"part '.*?\.dart';\s*", '', content)

# Add imports
imports = """import 'main_layout_widgets.dart';
import 'widget_type_toggle.dart';
import 'widget_toggle_button.dart';
import 'widget_scrollable_settlement_header.dart';
import 'widget_summary_cards.dart';
import 'main_layout_settlement_list.dart';
import 'main_layout_settlement_list_dialogs.dart';
"""

# Find the last import and insert after it
match = re.search(r"import '.*?';\s*(?!import)", content)
if match:
    idx = match.end()
    content = content[:idx] + '\n' + imports + '\n' + content[idx:]
else:
    # Just put it at the top
    content = imports + '\n' + content

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
