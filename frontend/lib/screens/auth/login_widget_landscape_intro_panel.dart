import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/login_screen.dart';
import 'package:expense_app/screens/auth/login_widget_login_brand_icon.dart';


class LandscapeIntroPanel extends StatelessWidget {
  final String serverUrl;
  final VoidCallback onConfigureServer;

  const LandscapeIntroPanel({super.key, 
    required this.serverUrl,
    required this.onConfigureServer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoginBrandIcon(size: 58, iconSize: 30),
        const SizedBox(height: 18),
        Text(
          'ExspanApp',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: isDark ? AppTheme.cream : AppTheme.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masuk untuk mengelola settlement, kasbon, laporan, dan pengaturan dengan tampilan yang aman dan responsif.',
          style: TextStyle(
            color: isDark ? AppTheme.textSecondary : Colors.black87,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onConfigureServer,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              serverLabel(serverUrl),
              style: const TextStyle(
                color: AppTheme.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
