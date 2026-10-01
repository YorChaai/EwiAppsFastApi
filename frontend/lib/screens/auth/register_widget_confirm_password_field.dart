import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const ConfirmPasswordField({super.key, 
    required this.controller,
    required this.obscure,
    required this.onToggleObscure,
  });

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
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(Icons.lock_rounded, color: iconColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: iconColor,
          ),
          onPressed: onToggleObscure,
        ),
        hintText: 'Ulangi password',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.newPassword],
      onSubmitted: (_) => onToggleObscure(),
    );
  }
}
