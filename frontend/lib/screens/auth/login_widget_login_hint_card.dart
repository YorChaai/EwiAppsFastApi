import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class LoginHintCard extends StatelessWidget {
  const LoginHintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.surface : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDark ? Colors.transparent : AppTheme.lightDivider),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 14, color: AppTheme.accent.withValues(alpha: 0.9)),
          const SizedBox(width: 8),
          Text(
            'EWIAPPS',
            style: TextStyle(
              fontSize: 10,
              color: isDark ? AppTheme.textPrimary : Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}
