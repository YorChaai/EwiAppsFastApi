import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/widget_toggle_button.dart';
import 'package:expense_app/services/bank_order_preferences.dart';

extension BankManagementLayoutSectionToggleExt on BankManagementScreenState {
  Widget buildSectionToggle() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final currentSortMode =
        activeSection == 'cash' ? bankCashSortMode : bankAdvanceSortMode;

    String sortLabel = 'Default';
    if (currentSortMode == 'highest') sortLabel = 'Saldo Terbanyak';
    if (currentSortMode == 'lowest') sortLabel = 'Saldo Terkecil';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Section Toggle
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cardColor(context).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: dark ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildToggleButton(
                  label: 'Bank Cash',
                  isActive: activeSection == 'cash',
                  onTap: () {
                    updateState(() => activeSection = 'cash');
                  },
                ),
                const SizedBox(width: 4),
                buildToggleButton(
                  label: 'Bank Advance',
                  isActive: activeSection == 'advance',
                  onTap: () {
                    updateState(() => activeSection = 'advance');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Instant Sort Menu
          PopupMenuButton<String>(
            tooltip: 'Urutkan Saldo ($sortLabel)',
            onSelected: (val) async {
              if (activeSection == 'cash') {
                updateState(() => bankCashSortMode = val);
                await BankOrderPreferences.saveBankCashSortMode(val);
              } else {
                updateState(() => bankAdvanceSortMode = val);
                await BankOrderPreferences.saveBankAdvanceSortMode(val);
              }
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: dark ? AppTheme.card : AppTheme.lightCard,
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'default',
                child: Row(
                  children: [
                    Icon(Icons.dashboard_customize_rounded,
                        size: 18,
                        color: currentSortMode == 'default'
                            ? AppTheme.primary
                            : (dark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary)),
                    const SizedBox(width: 10),
                    Text(
                      'Default (Template)',
                      style: TextStyle(
                        fontWeight: currentSortMode == 'default'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentSortMode == 'default'
                            ? AppTheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'highest',
                child: Row(
                  children: [
                    Icon(Icons.arrow_downward_rounded,
                        size: 18,
                        color: currentSortMode == 'highest'
                            ? AppTheme.primary
                            : (dark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary)),
                    const SizedBox(width: 10),
                    Text(
                      'Saldo Terbanyak',
                      style: TextStyle(
                        fontWeight: currentSortMode == 'highest'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentSortMode == 'highest'
                            ? AppTheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'lowest',
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward_rounded,
                        size: 18,
                        color: currentSortMode == 'lowest'
                            ? AppTheme.primary
                            : (dark
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary)),
                    const SizedBox(width: 10),
                    Text(
                      'Saldo Terkecil',
                      style: TextStyle(
                        fontWeight: currentSortMode == 'lowest'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: currentSortMode == 'lowest'
                            ? AppTheme.primary
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: currentSortMode != 'default'
                    ? AppTheme.primary.withValues(alpha: 0.15)
                    : cardColor(context).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: currentSortMode != 'default'
                      ? AppTheme.primary.withValues(alpha: 0.6)
                      : (dark ? AppTheme.divider : AppTheme.lightDivider),
                  width: currentSortMode != 'default' ? 1.5 : 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    currentSortMode == 'highest'
                        ? Icons.arrow_downward_rounded
                        : (currentSortMode == 'lowest'
                            ? Icons.arrow_upward_rounded
                            : Icons.sort_rounded),
                    size: 18,
                    color: currentSortMode != 'default'
                        ? AppTheme.primary
                        : (dark
                            ? AppTheme.textSecondary
                            : AppTheme.lightTextSecondary),
                  ),
                  if (currentSortMode != 'default')
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
