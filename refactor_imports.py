import os
import re

files = [
    'main_layout_widgets.dart',
    'widget_type_toggle.dart',
    'widget_toggle_button.dart',
    'widget_scrollable_settlement_header.dart',
    'widget_summary_cards.dart',
    'main_layout_settlement_list.dart',
    'main_layout_settlement_list_dialogs.dart'
]

common_imports = """import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/settlement_provider.dart';
import '../providers/advance_provider.dart';
import '../providers/revenue_provider.dart';
import '../providers/tax_provider.dart';
import '../providers/dividend_provider.dart';
import '../providers/asset_provider.dart';
import '../providers/bank_management_provider.dart';
import '../providers/bank_status_provider.dart';
import '../theme/app_theme.dart';
import '../utils/file_helper.dart';
import '../utils/context_extensions.dart';
import '../utils/app_dialogs.dart';
import '../utils/app_formatters.dart';
import '../utils/currency_formatter.dart';
import '../utils/event_bus.dart';
import '../widgets/notification_bell_icon.dart';
import 'settlement/settlement_detail_screen.dart';
import 'reports/report_screen.dart';
import 'advance/advances_screen.dart';
import 'advance/advance_detail_screen.dart';
import 'settings/settings_screen.dart';
import 'management/category_management_screen.dart';
import 'management/bank_management_screen.dart';
import '../utils/responsive_layout.dart';
import 'widgets/sidebar.dart';
import 'widgets/page_selector.dart';
import 'widgets/common_widgets.dart';
import '../widgets/app_scrollbar.dart';
import '../utils/app_snackbar.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';
import 'widgets/transaction_cards.dart';

import 'main_layout_settlement_list.dart';
"""

for filename in files:
    path = os.path.join('frontend/lib/screens', filename)
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        content = re.sub(r"part of 'main_layout\.dart';\s*", common_imports, content)
            
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Added imports to {filename}')
