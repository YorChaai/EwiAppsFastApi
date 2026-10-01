import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/logbook_screen.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';


extension SettingsLayoutLogbookButtonExt on SettingsScreenState {
  Widget buildLogbookButton() {
    return Container(
      width: double.infinity,
      height: 48,
      margin: const EdgeInsets.only(top: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDark(context) ? AppTheme.card : AppTheme.lightCard,
          foregroundColor: isDark(context)
              ? AppTheme.textPrimary
              : AppTheme.lightTextPrimary,
          side: BorderSide(
            color: (isDark(context)
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary)
                .withValues(alpha: 0.2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const LogbookScreen()));
        },
        icon: const Icon(Icons.history_rounded, size: 20),
        label: const Text(
          'Logbook Bank Advance',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}
