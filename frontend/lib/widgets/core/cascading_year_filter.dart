import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';

import 'package:expense_app/widgets/core/_menu_item_label.dart';

class CascadingYearFilter extends StatelessWidget {
  final String label;
  final int selectedYear;
  final String currentMode; // 'report', 'actual', 'range'
  final bool useCompact;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(int year, String mode) onSelected;
  final VoidCallback onRangeTap;

  const CascadingYearFilter({
    super.key,
    this.label = 'Periode Data',
    required this.selectedYear,
    required this.currentMode,
    required this.useCompact,
    this.startDate,
    this.endDate,
    required this.onSelected,
    required this.onRangeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String displayLabel = label;
    if (currentMode == 'report') {
      displayLabel =
          selectedYear == 0 ? 'Semua Laporan' : 'Laporan $selectedYear';
    } else if (currentMode == 'actual') {
      displayLabel = selectedYear == 0 ? 'Semua Tahun' : 'Year $selectedYear';
    } else if (currentMode == 'range') {
      if (startDate != null && endDate != null) {
        String sDay = startDate!.day.toString().padLeft(2, '0');
        String sMonth = startDate!.month.toString().padLeft(2, '0');
        String sYear = startDate!.year.toString().substring(2);

        String eDay = endDate!.day.toString().padLeft(2, '0');
        String eMonth = endDate!.month.toString().padLeft(2, '0');
        String eYear = endDate!.year.toString().substring(2);

        displayLabel = '$sDay/$sMonth/$sYear - $eDay/$eMonth/$eYear';
      } else {
        displayLabel = 'Custom Range';
      }
    }
    return MenuAnchor(
      alignmentOffset: const Offset(0, 4),
      style: MenuStyle(
        backgroundColor:
            WidgetStatePropertyAll(isDark ? AppTheme.surface : Colors.white),
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        elevation: const WidgetStatePropertyAll(8),
      ),
      builder: (context, controller, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () =>
                controller.isOpen ? controller.close() : controller.open(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: useCompact ? 36 : 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.card : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppTheme.divider : AppTheme.lightDivider,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    displayLabel,
                    style: TextStyle(
                      color: isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      fontSize: useCompact ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 20,
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      menuChildren: [
        SubmenuButton(
          menuChildren: _buildYearList(context, 'report'),
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: MenuItemLabel(
            icon: Icons.account_balance_rounded,
            label: 'Laporan',
            isDark: isDark,
            showArrow: false, // Biar tidak double panah dengan SubmenuButton
          ),
        ),
        SubmenuButton(
          menuChildren: _buildYearList(context, 'actual'),
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: MenuItemLabel(
            icon: Icons.calendar_month_rounded,
            label: 'Year',
            isDark: isDark,
            showArrow: false, // Biar tidak double panah dengan SubmenuButton
          ),
        ),
        MenuItemButton(
          onPressed: onRangeTap,
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: MenuItemLabel(
            icon: Icons.date_range_rounded,
            label: 'Range',
            isDark: isDark,
            showArrow: false,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildYearList(BuildContext context, String mode) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Buat list item tahun (Semua, 2020 - 2040)
    final years = [0, ...List.generate(21, (i) => 2020 + i)];
    final yearItems = years.map((year) {
      final isSelected = selectedYear == year && currentMode == mode;
      return MenuItemButton(
        onPressed: () => onSelected(year, mode),
        style: MenuItemButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          backgroundColor:
              isSelected ? AppTheme.primary.withValues(alpha: 0.1) : null,
        ),
        child: SizedBox(
          width: 80, // Lebar kotak tahun agar rapi
          child: Text(
            year == 0 ? 'Semua' : year.toString(),
            style: TextStyle(
              color: isSelected
                  ? AppTheme.primary
                  : (isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }).toList();

    // 2. Bungkus dalam Container Scrollable dengan tinggi terbatas
    return [
      ConstrainedBox(
        constraints:
            const BoxConstraints(maxHeight: 280), // Tinggi maksimal menu
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: yearItems,
          ),
        ),
      )
    ];
  }
}
