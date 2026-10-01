import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';

import 'package:expense_app/widgets/core/cascading_menu_item.dart';

class CascadingMenuCustom extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool useCompact;
  final List<CascadingMenuItem> items;
  final ValueChanged<String> onSelected;

  final bool closeOnSelect;

  const CascadingMenuCustom({
    super.key,
    required this.label,
    required this.icon,
    required this.useCompact,
    required this.items,
    required this.onSelected,
    this.closeOnSelect = true,
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
                    icon,
                    size: 16,
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
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
      menuChildren: items.map((item) {
        final content = Row(
          children: [
            if (item.icon != null) ...[
              Icon(
                item.icon,
                size: 16,
                color: item.selected
                    ? AppTheme.primary
                    : (isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: item.selected
                      ? AppTheme.primary
                      : (isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary),
                  fontWeight:
                      item.selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
            if (item.selected)
              const Icon(
                Icons.check_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
          ],
        );

        if (closeOnSelect) {
          return MenuItemButton(
            onPressed: () => onSelected(item.id),
            style: MenuItemButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: item.selected
                  ? AppTheme.primary.withValues(alpha: 0.1)
                  : null,
            ),
            child: content,
          );
        } else {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelected(item.id),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: item.selected
                      ? AppTheme.primary.withValues(alpha: 0.1)
                      : null,
                ),
                child: content,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}
