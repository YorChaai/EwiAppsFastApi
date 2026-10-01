import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';


extension SettingsDialogsExt on SettingsScreenState {
  void showImportPreviewDialog(Map<String, dynamic> preview) {
    final summary = (preview['summary'] as List? ?? []);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Preview Data Import'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File: ${preview['filename']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Ringkasan Isi Database:',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: dividerColor(context)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: summary.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (c, i) => ListTile(
                    dense: true,
                    title: Text(
                      summary[i]['table'].toString().toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Text(
                      '${summary[i]['rows']} baris',
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.danger,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'PERHATIAN: Database saat ini akan DIHAPUS dan diganti dengan data dari file ini. Pastikan Anda sudah melakukan Export untuk cadangan.',
                        style: TextStyle(
                          color: AppTheme.danger,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              confirmImport();
            },
            child: const Text('YA, GANTI DATABASE'),
          ),
        ],
      ),
    );
  }

  void showEditProfileDialog() async {
    final auth = context.read<AuthProvider>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => EditProfileDialog(user: auth.user!),
    );

    if (result != null && result['success'] == true && mounted) {
      auth.updateUserData(result['user']);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }
}
