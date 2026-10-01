import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_add_item.dart';

extension AdvanceDetailLayoutEmptyStateExt on AdvanceDetailScreenState {
  Widget buildEmptyState(bool canEditItems) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:
            Border.all(color: dividerColor(context), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada item ditambahkan',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
          if (canEditItems) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => showAddItemDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Item Sekarang'),
            ),
          ],
        ],
      ),
    );
  }
}
