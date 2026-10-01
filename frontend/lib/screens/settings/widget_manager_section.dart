import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';
import 'package:expense_app/screens/settings/widget_deadline_settings_card.dart';
import 'package:expense_app/screens/settings/widget_database_settings_card.dart';
import 'package:expense_app/screens/settings/widget_cleanup_settings_card.dart';
import 'package:expense_app/screens/settings/widget_storage_settings_card.dart';
import 'package:expense_app/screens/settings/widget_bank_order_settings_card.dart';


extension SettingsLayoutManagerSectionExt on SettingsScreenState {
  Widget buildManagerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'MANAGER ONLY',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        buildBankOrderSettingsCard(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: dividerColor(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.people_outline_rounded,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Manage User (Account List)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: titleColor(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: showAccountList,
                  icon: const Icon(Icons.list_rounded),
                  label: const Text(
                    'Lihat Account List',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        buildDeadlineSettingsCard(),
        const SizedBox(height: 16),
        buildStorageSettingsCard(),
        const SizedBox(height: 16),
        buildCleanupSettingsCard(),
        const SizedBox(height: 16),
        buildDatabaseSettingsCard(),
      ],
    );
  }
}
