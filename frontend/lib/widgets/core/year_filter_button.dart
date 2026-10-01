import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class YearFilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool useCompact;
  final VoidCallback onTap;
  final Function(int) onYearChanged;
  final int selectedYear;
  final bool showModeIcon;

  const YearFilterButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.useCompact,
    required this.onTap,
    required this.onYearChanged,
    required this.selectedYear,
    this.showModeIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MenuAnchor(
      alignmentOffset: const Offset(0, 4),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          isDark ? AppTheme.surface : Colors.white,
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: const WidgetStatePropertyAll(8),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 8)),
      ),
      builder: (context, controller, child) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
              onTap();
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActive ? 1.0 : 0.7,
              child: Container(
                height: useCompact ? 36 : 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.primary.withValues(alpha: 0.15)
                      : (isDark ? AppTheme.card : AppTheme.lightCard),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isActive
                        ? AppTheme.primary
                        : (isDark ? AppTheme.divider : AppTheme.lightDivider),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showModeIcon) ...[
                      Icon(
                        label.contains('Laporan')
                            ? Icons.account_balance_rounded
                            : Icons.calendar_month_rounded,
                        size: 18,
                        color: isActive
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isActive
                            ? AppTheme.primary
                            : (isDark
                                ? AppTheme.textPrimary
                                : AppTheme.lightTextPrimary),
                        fontSize: useCompact ? 12 : 14,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 24,
                      color:
                          isActive ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () => onYearChanged(0),
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(
            'Semua Tahun',
            style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
              fontWeight:
                  selectedYear == 0 ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
        ...List.generate(21, (i) => 2020 + i).map((y) {
          final isSelected = selectedYear == y;
          return MenuItemButton(
            onPressed: () => onYearChanged(y),
            style: MenuItemButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor:
                  isSelected ? AppTheme.primary.withValues(alpha: 0.1) : null,
            ),
            child: Text(
              y.toString(),
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primary
                    : (isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          );
        }),
      ],
    );
  }
}
