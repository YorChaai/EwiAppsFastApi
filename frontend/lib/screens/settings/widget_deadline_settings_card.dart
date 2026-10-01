import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/deadline_manager_screen.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';


extension SettingsLayoutDeadlineSettingsCardExt on SettingsScreenState {
  Widget buildDeadlineSettingsCard() {
    return Container(
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
              const Icon(Icons.notifications_active_rounded,
                  color: AppTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pengaturan Deadline Notifikasi',
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
          const Text(
            'Atur kapan notifikasi deadline akan muncul untuk Kasbon dan Settlement.',
            style: TextStyle(fontSize: 13),
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
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const DeadlineManagerScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.schedule_rounded),
              label: const Text(
                'Kelola Deadline Notifikasi',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
