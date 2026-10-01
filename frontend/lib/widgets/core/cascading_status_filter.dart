import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class CascadingStatusFilter extends StatelessWidget {
  final String? selectedStatus;
  final bool useCompact;
  final Function(String?) onSelected;
  final bool isManager;

  const CascadingStatusFilter({
    super.key,
    required this.selectedStatus,
    required this.useCompact,
    required this.onSelected,
    this.isManager = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statuses = [
      {'label': 'Semua Status', 'value': null, 'color': AppTheme.textSecondary},
      {'label': 'Draft', 'value': 'draft', 'color': AppTheme.textSecondary},
      {'label': 'Submitted', 'value': 'submitted', 'color': AppTheme.warning},
      {'label': 'Revision', 'value': 'revision', 'color': AppTheme.primary},
      {'label': 'Approved', 'value': 'approved', 'color': AppTheme.success},
      {'label': 'Completed', 'value': 'completed', 'color': Colors.blue},
      if (isManager)
        {'label': 'Rejected', 'value': 'rejected', 'color': AppTheme.danger},
    ];
    final selected = statuses.cast<Map<String, dynamic>>().firstWhere(
          (status) => status['value'] == selectedStatus,
          orElse: () => statuses.first,
        );
    final displayLabel = selected['label'] as String;

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
                    Icons.filter_list_rounded,
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
      menuChildren: statuses.map((status) {
        final isSelected = selectedStatus == status['value'];
        final color = status['color'] as Color;

        return MenuItemButton(
          onPressed: () => onSelected(status['value'] as String?),
          style: MenuItemButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: isSelected ? color.withValues(alpha: 0.1) : null,
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                status['label'] as String,
                style: TextStyle(
                  color: isSelected
                      ? color
                      : (isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
