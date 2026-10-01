import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class UsernameField extends StatelessWidget {
  final TextEditingController controller;

  const UsernameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final iconColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final hintColor = isDark
        ? AppTheme.textSecondary.withValues(alpha: 0.6)
        : AppTheme.lightTextSecondary.withValues(alpha: 0.6);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Username atau Email',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(
          Icons.person_outline,
          color: iconColor,
        ),
        hintText: 'user_atau_email@gmail.com',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
    );
  }
}
