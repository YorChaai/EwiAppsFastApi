import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/master_data/bank_status_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/account_list_dialog.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_dialogs.dart';


extension SettingsActionsExt on SettingsScreenState {
  Future<void> loadSettings() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      if (mounted) updateState(() => loading = false);
      return;
    }
    api.setToken(auth.token!);

    try {
      // Fetch active advance balance
      final userId = auth.user?['id'];
      if (userId != null) {
        try {
          final balanceRes = await api.getActiveAdvanceBalance(userId);
          final hutangRes = await api.getUserBalances(userId);

          if (mounted) {
            updateState(() {
              balanceData = balanceRes;

              bankBreakdown.clear();
              final compList = balanceRes['cash_composition'] ?? balanceRes['breakdown'];
              if (compList != null) {
                for (var b in compList) {
                  bankBreakdown[b['bank_name'] ?? ''] =
                      (b['balance'] ?? 0.0).toDouble();
                }
              }

              bankHutangBreakdown.clear();
              rawHutangBalances.clear();
              if (hutangRes['balances'] != null) {
                for (var b in hutangRes['balances']) {
                  final mapB = Map<String, dynamic>.from(b);
                  bankHutangBreakdown[mapB['bank_name'] ?? ''] =
                      (mapB['balance'] ?? 0.0).toDouble();
                  rawHutangBalances.add(mapB);
                }
              }

              loadingBalance = false;
            });
          }
        } catch (e) {
          debugPrint('Failed to load active advance balance: $e');
          if (mounted) {
            updateState(() {
              loadingBalance = false;
            });
          }
        }
      }
      // ... rest of loadSettings logic ...

      // Fetch report year settings (accessible to all now)
      final reportYearRes = await api.getReportYearSettings();
      if (mounted) {
        final parsedYear = int.tryParse(
          (reportYearRes['default_report_year'] ?? 0).toString(),
        );
        updateState(() {
          currentReportYear = parsedYear ?? 0;
          // If not manager, we stop here
          if (!auth.isManager) {
            loading = false;
          }
        });
      }

      // Fetch manager-only settings if applicable
      if (auth.isManager) {
        final res = await api.getStorageSettings();
        if (mounted) {
          updateState(() {
            currentDir = res['current_directory'] ?? '';
            dirController.text = currentDir;
            loading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) updateState(() => loading = false);
    }
  }

  Future<void> saveSettings() async {
    final newDir = dirController.text.trim();
    if (newDir.isEmpty) return;
    updateState(() => loading = true);
    try {
      final res = await api.updateStorageSettings(newDir);
      if (mounted) {
        updateState(() {
          loading = false;
          currentDir = res['new_directory'] ?? newDir;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res['message'] ?? 'Berhasil memindahkan penyimpanan.',
            ),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        updateState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> saveReportYearSettings() async {
    final year = currentReportYear;
    updateState(() => loading = true);
    try {
      final res = await api.updateReportYearSettings(year);
      if (mounted) {
        final savedYear =
            int.tryParse((res['default_report_year'] ?? 0).toString()) ?? 0;
        updateState(() {
          loading = false;
          currentReportYear = savedYear;
        });

        // ✅ Explicitly set to report mode and update year
        // If savedYear is 0, use current device year
        final effectiveYear = savedYear == 0 ? DateTime.now().year : savedYear;

        context
            .read<CascadeProvider>()
            .syncAllFromSettings(context, effectiveYear);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tahun laporan default berhasil diperbarui.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        updateState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> exportDatabase() async {
    updateState(() => loading = true);
    try {
      final res = await api.exportDatabase();
      if (mounted) {
        updateState(() => loading = false);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: AppTheme.success),
                SizedBox(width: 8),
                Text('Export Berhasil'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Database telah berhasil dicadangkan.'),
                const SizedBox(height: 12),
                const Text(
                  'Lokasi Folder:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  res['path'] ?? '-',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nama Folder: ${res['folder']}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        updateState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> importDatabase() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.any, // SQLite .db biasanya dideteksi as any/binary
        allowMultiple: false,
        withData: true, // Wajib true agar file.bytes terisi di Flutter Web
      );

      if (result == null || result.files.isEmpty) return;
      final file = result.files.single;
      final fileName = file.name.toLowerCase();

      if (!fileName.endsWith('.sql') && !fileName.endsWith('.db')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hanya file .sql atau .db yang diperbolehkan.'),
              backgroundColor: AppTheme.danger,
            ),
          );
        }
        return;
      }
      updateState(() => loading = true);
      final preview = await api.importDatabasePreview(
        filePath: file.path,
        fileBytes: file.bytes,
        fileName: file.name,
      );

      if (mounted) {
        updateState(() => loading = false);
        showImportPreviewDialog(preview);
      }
    } catch (e) {
      if (mounted) {
        updateState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> confirmImport() async {
    updateState(() => loading = true);
    try {
      final res = await api.confirmImportDatabase();
      if (mounted) {
        updateState(() => loading = false);

        // RELOAD ALL DATA PROVIDERS (IMPORTANT BUG FIX)
        final authProv = context.read<AuthProvider>();
        final settlementProv = context.read<SettlementProvider>();
        final advanceProv = context.read<AdvanceProvider>();
        final bankMgmtProv = context.read<BankManagementProvider>();
        final bankStatProv = context.read<BankStatusProvider>();

        // 1. Sync report year first (in case it changed in the new DB)
        await Future.wait([
          authProv.reloadUser(),
          settlementProv.syncReportYear(),
          advanceProv.syncReportYear(),
          bankMgmtProv.syncReportYear(),
          bankStatProv.syncReportYear(),
        ]);

        // 2. Reload categories and data
        await Future.wait([
          settlementProv.loadCategories(),
          settlementProv.loadSettlements(),
          advanceProv.loadAdvances(),
          bankMgmtProv.loadBanks(),
          bankStatProv.loadBanks(),
        ]);

        // 3. Sync and reload all remaining providers via Cascade
        if (mounted) {
          context
              .read<CascadeProvider>()
              .syncAllFromSettings(context, currentReportYear);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res['message'] ??
                  'Database berhasil dipulihkan. Aplikasi akan dimuat ulang...'),
              backgroundColor: AppTheme.success,
              duration: const Duration(seconds: 3),
            ),
          );

          // Force a full UI rebuild by restarting the navigation stack
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        updateState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  void showAccountList() async {
    showDialog(context: context, builder: (ctx) => const AccountListDialog());
  }

  void toggleManagerSection() {
    updateState(() => showManagerSection = !showManagerSection);
  }

  Widget profileColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.primary.withValues(alpha: 0.7)),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: bodyColor(context), fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: titleColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
