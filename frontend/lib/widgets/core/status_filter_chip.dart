import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/utils/context_extensions.dart';


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
    final isDark = context.isDark;
    final borderColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final textColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

    // Responsive sizing
    final isCompact = isMobile || ResponsiveLayout.isCompactPhone(context);
    final horizontalPadding = isCompact ? 10.0 : 14.0;
    final verticalPadding = isCompact ? 6.0 : 8.0;
    final fontSize = isCompact ? 11.5 : 13.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
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
            fontSize: fontSize,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.primary : textColor,
          ),
        ),
      ),
    );
  }
}
