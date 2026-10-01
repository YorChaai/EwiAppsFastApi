import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const PasswordField({super.key, 
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
        labelText: 'Password',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(Icons.lock_outline, color: iconColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: iconColor,
          ),
          onPressed: onToggleObscure,
        ),
        hintText: 'Minimal 6 karakter',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.newPassword],
    );
  }
}
