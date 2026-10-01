import os
import re
import glob

# 1. Target files
main_file = 'frontend/lib/screens/settlement/settlement_detail_screen.dart'
part_files = [
    'settlement_detail_actions.dart',
    'layouts/settlement_detail_layout.dart',
    'layouts/settlement_detail_tables.dart',
    'dialogs/dialog_add_category.dart',
    'dialogs/dialog_add_expense.dart',
    'dialogs/dialog_checklist.dart',
    'dialogs/dialog_comments.dart',
    'dialogs/dialog_edit_disbursement.dart',
    'dialogs/dialog_edit_expense.dart',
    'dialogs/dialog_edit_settlement.dart',
    'dialogs/dialog_evidence.dart',
    'dialogs/dialog_plain_comments.dart',
    'settlement_detail_previews.dart',
    'widgets/widget_settlement_detail_actions.dart',
    'widgets/widget_file_list.dart',
    'widgets/widget_insufficient_balance_dialog.dart',
    'widgets/widget_insuff_balance_row.dart'
]

# 2. Private variables and methods to make public
privates = [
    '_api', '_currencyFormat', '_foreignCurrencyFormat', '_expenseTableVerticalCtrl',
    '_expenseTableHorizontalCtrl', '_mainScrollController', '_subCategoryScrollController',
    '_selectedExpenses', '_isSaving', '_adminFeeController', '_disbursedAmountController',
    '_returnedAmountController', '_returnDescriptionController', '_disbursementDescriptionController',
    '_disbursementCommentController', '_disbursementDate', '_activeAdvanceBalance',
    '_userVirtualBalances', '_userCashComposition', '_officeBankBalances',
    '_sidebarExpanded', '_pendingSettlements', '_pendingAdvances', '_refreshSub',
    '_isAndroid', '_isDark', '_surfaceColor', '_cardColor', '_creamColor',
    '_primaryText', '_secondaryText', '_dividerColor', '_fetchActiveAdvanceBalance',
    '_fetchBadgeCounts', '_statusColor', '_toDouble', '_formatExpenseAmount',
    '_displaySettlementStatus', '_expenseFundSource', '_settlementDisbursementSourceLabel',
    '_fundSourceOptions', '_settlementReimbursementAmount', '_buildDisbursementDataRow',
    '_showEvidence', '_showInsufficientBalanceDialog', '_displaySettlementTitle',
    '_hasUncheckedChecklist', '_canSubmitSettlementItems', '_canApproveSettlementItems',
    '_handleNotificationTap', '_buildMobileSettlementActionBar', '_buildContent',
    '_getCommentsFromNotes', '_parsePlainComments'
]

def rename_privates(content):
    # Rename class
    content = content.replace('_SettlementDetailScreenState', 'SettlementDetailScreenState')
    # Rename variables/methods
    for p in privates:
        # Match word boundaries to avoid replacing parts of other words
        # but p starts with _, so \b doesn't work well on the left.
        # We use a negative lookbehind for alphanumeric and underscore.
        pattern = r'(?<![a-zA-Z0-9_])' + p + r'\b'
        replacement = p[1:]
        content = re.sub(pattern, replacement, content)
    return content

# Process main file
with open(main_file, 'r', encoding='utf-8') as f:
    main_content = f.read()

main_content = rename_privates(main_content)
# Replace 'part '...' with 'import '...'
main_content = re.sub(r"^part '([^']+)';", r"import '\1';", main_content, flags=re.MULTILINE)

with open(main_file, 'w', encoding='utf-8') as f:
    f.write(main_content)
print(f"Processed {main_file}")

# Process part files
for part in part_files:
    full_path = os.path.join('frontend/lib/screens/settlement', part)
    if not os.path.exists(full_path):
        print(f"File not found: {full_path}")
        continue
        
    with open(full_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    content = rename_privates(content)
    
    # Remove part of
    content = re.sub(r"^part of '[^']+';\s*", "", content, flags=re.MULTILINE)
    
    # Rename extensions
    content = re.sub(r'extension _([a-zA-Z0-9_]+)', r'extension \1', content)
    
    # Inject imports.
    # We will inject standard imports into every part file. Unused ones can be removed later by flutter analyze.
    depth = part.count('/')
    prefix = '../' * depth
    
    imports = f"""
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '{prefix}settlement_detail_screen.dart';

import '../../{prefix}utils/event_bus.dart';
import '../../{prefix}providers/auth_provider.dart';
import '../../{prefix}providers/settlement_provider.dart';
import '../../{prefix}providers/advance_provider.dart';
import '../{prefix}management/category_management_screen.dart';
import '../{prefix}advance/advance_detail_screen.dart';
import '../{prefix}main_layout.dart';
import '../../{prefix}theme/app_theme.dart';
import '../../{prefix}widgets/category_preview_dialog.dart';
import '../../{prefix}utils/currency_formatter.dart';
import '../../{prefix}utils/app_formatters.dart';
import '../../{prefix}utils/file_helper.dart';
import '../../{prefix}utils/app_snackbar.dart';
import '../../{prefix}widgets/app_scrollbar.dart';
import '../{prefix}widgets/sidebar.dart';
import '../{prefix}widgets/settlement_detail_widgets.dart';
import '../../{prefix}widgets/item_detail_preview_dialog.dart';
import '../../{prefix}widgets/workflow_timeline.dart';
import '../../{prefix}utils/responsive_layout.dart';
import '../../{prefix}utils/app_dialogs.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import '{prefix}settlement_detail_actions.dart';
import '{prefix}layouts/settlement_detail_layout.dart';
import '{prefix}layouts/settlement_detail_tables.dart';
import '{prefix}dialogs/dialog_add_category.dart';
import '{prefix}dialogs/dialog_add_expense.dart';
import '{prefix}dialogs/dialog_checklist.dart';
import '{prefix}dialogs/dialog_comments.dart';
import '{prefix}dialogs/dialog_edit_disbursement.dart';
import '{prefix}dialogs/dialog_edit_expense.dart';
import '{prefix}dialogs/dialog_edit_settlement.dart';
import '{prefix}dialogs/dialog_evidence.dart';
import '{prefix}dialogs/dialog_plain_comments.dart';
import '{prefix}settlement_detail_previews.dart';
import '{prefix}widgets/widget_settlement_detail_actions.dart';
import '{prefix}widgets/widget_file_list.dart';
import '{prefix}widgets/widget_insufficient_balance_dialog.dart';
import '{prefix}widgets/widget_insuff_balance_row.dart';
"""
    # Filter out self import
    imports = '\n'.join([line for line in imports.split('\n') if not line.strip().endswith(f"'{part}';")])
    
    # We only inject if it doesn't already have 'import 'package:flutter/material.dart';'
    if 'import \'package:flutter/material.dart\';' not in content:
        content = imports + '\n' + content
        
    with open(full_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Processed {part}")

print("Done refactoring settlement_detail_screen.dart")
