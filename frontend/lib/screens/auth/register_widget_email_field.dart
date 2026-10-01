import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool readOnly;

  const EmailField({super.key, 
    required this.controller,
    this.readOnly = false,
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
      readOnly: readOnly,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(Icons.email_outlined, color: iconColor),
        hintText: 'nama@email.com',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
    );
  }
}
