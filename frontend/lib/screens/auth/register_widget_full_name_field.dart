import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class FullNameField extends StatelessWidget {
  final TextEditingController controller;

  const FullNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final iconColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final hintColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(Icons.badge_outlined, color: iconColor),
        hintText: 'Nama Lengkap Anda',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
    );
  }
}
