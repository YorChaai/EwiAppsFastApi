import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/context_extensions.dart';

import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

extension DashboardWidgetsExt on SettlementListViewState {
  Future<void> deleteSettlement(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(context),
        title: const Text('Hapus Settlement'),
        content: const Text('Apakah Anda yakin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!mounted) return;
      await context.read<SettlementProvider>().deleteSettlement(id);
    }
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isMobile;
  final VoidCallback onTap;

  const _FilterChipWidget({
    required this.label,
    required this.selected,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final textColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppTheme.primary : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.primary : textColor,
          ),
        ),
      ),
    );
  }
}

class StatusFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isMobile;
  final VoidCallback onTap;
  const StatusFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.isMobile = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return _FilterChipWidget(
      label: label,
      selected: selected,
      isMobile: isMobile,
      onTap: onTap,
    );
  }
}
