import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/data_cleanup_screen.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';


extension SettingsLayoutCleanupSettingsCardExt on SettingsScreenState {
  Widget buildCleanupSettingsCard() {
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
              const Icon(Icons.cleaning_services_rounded,
                  color: AppTheme.danger),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pembersihan Data Selektif',
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
            'Hapus data transaksi (Kasbon, Settlement, Pajak, dll) berdasarkan tahun pilihan secara permanen.',
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger.withValues(alpha: 0.1),
                foregroundColor: AppTheme.danger,
                elevation: 0,
                side: const BorderSide(color: AppTheme.danger),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => const DataCleanupScreen()),
                );
              },
              icon: const Icon(Icons.auto_delete_rounded, size: 18),
              label: const Text(
                'Mulai Pembersihan Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
