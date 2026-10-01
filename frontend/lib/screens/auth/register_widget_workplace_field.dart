import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class WorkplaceField extends StatelessWidget {
  final TextEditingController controller;

  const WorkplaceField({super.key, required this.controller});

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
        labelText: 'Tempat Kerja',
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: Icon(Icons.work_outline, color: iconColor),
        hintText: 'Nama Kantor/Instansi',
        hintStyle: TextStyle(color: hintColor),
      ),
      style: TextStyle(color: textColor),
      textInputAction: TextInputAction.next,
    );
  }
}
