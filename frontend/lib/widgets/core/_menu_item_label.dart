import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class MenuItemLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final bool showArrow;

  const MenuItemLabel({super.key, 
    required this.icon,
    required this.label,
    required this.isDark,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // Sedikit lebih lebar agar panah sejajar manis di kanan
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            size: 20, // Sedikit lebih besar agar ikon lebih tegas
            color: AppTheme.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500, // Medium weight agar lebih terbaca
              ),
            ),
          ),
          if (showArrow)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: (isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary)
                    .withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}
