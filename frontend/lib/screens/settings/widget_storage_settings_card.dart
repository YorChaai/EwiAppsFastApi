import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';


extension SettingsLayoutStorageSettingsCardExt on SettingsScreenState {
  Widget buildStorageSettingsCard() {
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
              const Icon(Icons.folder_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Penyimpanan Data',
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
          TextField(
            controller: dirController,
            decoration: const InputDecoration(
              hintText: 'Direktori penyimpanan',
            ),
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
              onPressed: loading ? null : saveSettings,
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Simpan & Pindahkan Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
