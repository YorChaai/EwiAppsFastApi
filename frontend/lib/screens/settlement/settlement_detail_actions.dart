
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/screens/management/category_management_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/utils/app_snackbar.dart';
import 'package:expense_app/widgets/workflow_timeline.dart';
import 'package:expense_app/utils/app_dialogs.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailActionsExt on SettlementDetailScreenState {
  Future<void> approveTable1() async {
    final s = context.read<SettlementProvider>().currentSettlement;
    if (s == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Approve'),
        content: const Text(
            'Apakah Anda yakin ingin menyetujui semua rincian item (Table 1) pada settlement ini?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    updateState(() => isSaving = true);
    final prov = context.read<SettlementProvider>();
    final success = await prov.approveAllSettlement(widget.settlementId);

    if (!mounted) return;
    if (success && context.mounted) {
      GlobalEventBus.triggerRefresh();
      await prov.loadSettlement(widget.settlementId);
      await fetchActiveAdvanceBalance(prov.currentSettlement!['user_id']);
      showGlobalSnackBar('Rincian item disetujui ✓', AppTheme.success);
    } else if (context.mounted) {
      showGlobalSnackBar(
          prov.error ?? 'Gagal menyetujui item.', AppTheme.danger);
    }
    updateState(() => isSaving = false);
  }

  Future<void> approveSettlement() async {
    final s = context.read<SettlementProvider>().currentSettlement;
    if (s == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Penyelesaian'),
        content: const Text(
            'Apakah Anda yakin ingin menyetujui final settlement ini? Data akan dicatat ke Bank.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
            child: const Text('Ya, Setujui'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    updateState(() => isSaving = true);
    final prov = context.read<SettlementProvider>();

    // Find the bankId from the disbursement source
    final source = settlementDisbursementSourceLabel(s);
    final bankId = getBankIdFromSourceName(source);

    final success = await prov.finalApproveSettlement(
      widget.settlementId,
      bankId: bankId,
    );

    if (!mounted) return;
    if (success && context.mounted) {
      GlobalEventBus.triggerRefresh();
      await prov.loadSettlement(widget.settlementId); // ✅ Ensure UI refresh
      await fetchActiveAdvanceBalance(
          prov.currentSettlement!['user_id']); // ✅ Ensure Hutang UI refresh
      showGlobalSnackBar('Settlement disetujui final ✓', AppTheme.success);
    } else if (context.mounted) {
      showGlobalSnackBar(
        prov.error ?? 'Gagal menyetujui final settlement',
        AppTheme.danger,
      );
    }
    updateState(() => isSaving = false);
  }

  Future<void> handleNotificationTap(String? rawPath) async {
    if (!mounted || rawPath == null || rawPath.trim().isEmpty) return;
    final path = rawPath.trim().toLowerCase();

    // Extract ID from path
    final parts = path.split('/');
    int? id;
    for (int i = parts.length - 1; i >= 0; i--) {
      final value = int.tryParse(parts[i]);
      if (value != null) {
        id = value;
        break;
      }
    }

    // Navigate based on path
    if (path.contains('/settlements') && id != null) {
      // Navigate to settlement detail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SettlementDetailScreen(settlementId: id!),
        ),
      );
      return;
    }

    if (path.contains('/advances') && id != null) {
      // Navigate to advance detail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdvanceDetailScreen(advanceId: id!)),
      );
      return;
    }

    if (path.contains('/categories')) {
      // Navigate to dashboard categories tab
      if (context.read<AuthProvider>().isManager) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
          arguments: {'initialTabIndex': 3},
        );
      }
      return;
    }

    if (path.contains('/reports')) {
      // Navigate to dashboard reports tab
      if (context.read<AuthProvider>().isManager) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
          arguments: {'initialTabIndex': 2},
        );
      }
      return;
    }
  }

  Future<void> downloadReceipt() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.getReceipt(widget.settlementId);
      final filename =
          'Receipt_${widget.settlementId}_${FileHelper.formatTimestamp()}.pdf';
      if (!mounted) return;

      await FileHelper.saveAndOpenFile(
        context: context,
        bytes: bytes,
        filename: filename,
        successMessage: 'PDF Receipt berhasil disimpan.',
        subFolder: 'Reports/Settlements/Receipt',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  void showGlobalSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> deleteExpense(int expenseId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Item'),
        content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    final prov = context.read<SettlementProvider>();
    await prov.deleteExpense(expenseId, widget.settlementId);
  }

  Future<void> moveToDraft() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: getCardColor(ctx),
        title: Text(
          'Kembalikan ke Draft?',
          style: TextStyle(color: getCreamColor(ctx)),
        ),
        content: Text(
          'Apakah Anda yakin ingin menarik kembali pengeluaran ini ke status Draft untuk melakukan perbaikan?',
          style: TextStyle(color: getSecondaryText(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Kembalikan ke Draft'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final prov = context.read<SettlementProvider>();
    final success = await prov.moveSettlementToDraft(widget.settlementId);
    if (mounted) {
      if (success) {
        GlobalEventBus
            .triggerRefresh(); // ✅ Refresh semua halaman (Bank, Laporan, Settings, dll.)
        AppSnackbar.success('Pengeluaran ditarik ke draft ✓');
        if (prov.currentSettlement != null) {
          await fetchActiveAdvanceBalance(prov.currentSettlement!['user_id']);
        }
        await prov.loadSettlement(widget.settlementId);
      } else {
        AppSnackbar.error(prov.error ?? 'Gagal memindahkan ke draft');
      }
    }
  }

  Widget buildSaveChecklistButton(
    BuildContext dialogCtx,
    int expenseId,
    List<Map<String, dynamic>> list,
    String settlementStatus,
    String itemStatus,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        bool allFinished = list.every((it) => it['checked'] == true);
        String newStatus = itemStatus;
        if (allFinished && itemStatus == 'rejected') {
          newStatus = 'pending';
        } else if (!allFinished && itemStatus == 'approved') {
          newStatus = 'pending';
        }
        final prov = context.read<SettlementProvider>();

        final cleanList = list.map((it) {
          final map = Map<String, dynamic>.from(it);
          map.remove('focusNode');
          return map;
        }).toList();

        final success = await prov.updateExpenseData(
          expenseId,
          widget.settlementId,
          {'notes': jsonEncode(cleanList), 'status': newStatus},
        );

        if (success) {
          prov.loadSettlement(widget.settlementId);
          if (dialogCtx.mounted) Navigator.pop(dialogCtx);
          AppSnackbar.success('Checklist berhasil disimpan ✓');
        } else {
          if (dialogCtx.mounted) Navigator.pop(dialogCtx);
          AppSnackbar.error('Gagal menyimpan checklist');
        }
      },
      child: const Text('Simpan'),
    );
  }

  Future<void> submitSettlement() async {
    if (!mounted) return;
    final prov = context.read<SettlementProvider>();

    final s = prov.currentSettlement;
    if (s != null) {
      final expenses = s['expenses'] as List? ?? [];
      final hasEmptyEvidence = expenses.any((e) {
        final ev = e['evidence_path']?.toString().trim() ?? '';
        return ev.isEmpty;
      });

      if (hasEmptyEvidence) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Tidak dapat submit: Ada item yang belum memiliki Evidence (Bukti). Silakan edit dan upload bukti terlebih dahulu.'),
            backgroundColor: AppTheme.danger,
          ),
        );
        return;
      }
    }

    final success = await prov.submitSettlement(widget.settlementId);
    if (!mounted) return;
    if (success) {
      GlobalEventBus.triggerRefresh(); // ✅ Refresh semua halaman
      await prov.loadSettlement(widget.settlementId);
      if (!mounted) return; // ✅ Guard setelah await sebelum pakai context
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settlement berhasil disubmit ✓'),
          backgroundColor: AppTheme.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prov.error ?? 'Gagal submit'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> exportSettlementExcel() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.exportExcel(settlementId: widget.settlementId);
      final filename =
          'Settlement_${widget.settlementId}_${FileHelper.formatTimestamp()}.xlsx';
      if (!mounted) return;

      await FileHelper.saveFile(
        context: context,
        bytes: bytes,
        filename: filename,
        successMessage: 'Excel Settlement berhasil disimpan.',
        subFolder: 'Reports/Settlements/Excel',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> rejectSettlement() async {
    final ctrl = TextEditingController();
    final prov = context.read<SettlementProvider>();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: getCardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Tolak Settlement',
          style: TextStyle(color: getCreamColor(ctx)),
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Berikan alasan mengapa settlement ini ditolak.',
                style: TextStyle(color: getSecondaryText(ctx), fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Alasan penolakan',
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  filled: true,
                  fillColor: getSurfaceColor(ctx),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: getDividerColor(ctx)),
                  ),
                ),
                style: TextStyle(color: getCreamColor(ctx), fontSize: 14),
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
            onPressed: () {
              final val = ctrl.text.trim();
              if (val.isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(
                    content: Text('Alasan wajib diisi!'),
                    backgroundColor: AppTheme.danger,
                  ),
                );
                return;
              }
              Navigator.pop(ctx, val);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text(
              'Tolak Sekarang',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      final success = await prov.rejectAllExpenses(widget.settlementId, result);
      if (mounted) {
        if (success) {
          AppSnackbar.success(
            'Settlement berhasil ditolak dan dikembalikan ke draft ✓',
          );
          prov.loadSettlement(widget.settlementId);
        } else {
          AppSnackbar.error(prov.error ?? 'Gagal menolak settlement');
        }
      }
    }

    ctrl.dispose();
  }

  Future<void> fetchBadgeCounts() async {
    try {
      final api = context.read<AuthProvider>().api;
      final data = await api.getDashboardSummary();
      if (mounted) {
        updateState(() {
          pendingSettlements = data['pending_settlements'] ?? 0;
          pendingAdvances = data['pending_advances'] ?? 0;
        });
      }
    } catch (_) {}
  }

  Future<void> approveExpense(int expenseId, String action) async {
    String notes = '';
    List<Map<String, dynamic>> reasonsList = [];

    if (action == 'reject') {
      final controllers = [TextEditingController()];
      final confirmReject = await showDialog<bool>(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: getCardColor(ctx),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Tolak Item',
                style: TextStyle(color: getCreamColor(ctx)),
              ),
              content: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berikan alasan penolakan dalam bentuk checklist:',
                      style: TextStyle(
                        color: getSecondaryText(ctx),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                        child: Column(
                          children: controllers.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final ctrl = entry.value;
                            return Padding(
                              key: ValueKey(
                                ctrl,
                              ), // Use controller as key to prevent reuse issues
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_box_outline_blank_rounded,
                                    size: 20,
                                    color: getSecondaryText(ctx),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: ctrl,
                                      autofocus: idx == controllers.length - 1,
                                      decoration: InputDecoration(
                                        hintText: 'Alasan #${idx + 1}',
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 12,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: getCreamColor(ctx),
                                        fontSize: 14,
                                      ),
                                      maxLines: null,
                                      minLines: 1,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                  if (controllers.length > 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                        color: AppTheme.danger,
                                        size: 20,
                                      ),
                                      tooltip: 'Hapus Catatan',
                                      onPressed: () {
                                        final removedCtrl = controllers[idx];
                                        setDialogState(() {
                                          controllers.removeAt(idx);
                                        });
                                        // Dispose after the rebuild has potentially finished
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                            removedCtrl.dispose();
                                          },
                                        );
                                      },
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => setDialogState(() {
                        controllers.add(TextEditingController());
                      }),
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 20,
                      ),
                      label: const Text('Tambah Alasan'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controllers.every((c) => c.text.trim().isEmpty)) return;
                    reasonsList = controllers
                        .where((c) => c.text.trim().isNotEmpty)
                        .map((c) => {'text': c.text.trim(), 'checked': false})
                        .toList();
                    Navigator.pop(ctx, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                  ),
                  child: const Text('Tolak Item'),
                ),
              ],
            );
          },
        ),
      );

      // Dispose all controllers after dialog is fully closed
      Future.delayed(const Duration(milliseconds: 300), () {
        for (var c in controllers) {
          try {
            c.dispose();
          } catch (_) {}
        }
      });

      if (confirmReject != true || reasonsList.isEmpty) return;
      notes = jsonEncode(reasonsList);
    }

    if (!mounted) return;
    final prov = context.read<SettlementProvider>();
    final success = await prov.approveExpense(expenseId, action, notes: notes);
    if (mounted) {
      if (!success && (prov.error ?? '').contains('belum disetujui')) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: getCardColor(ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: AppTheme.danger, width: 2),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: AppTheme.danger,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Akses Ditolak',
                  style: TextStyle(
                    color: getCreamColor(ctx),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prov.error ??
                      'Kategori item ini belum disetujui oleh manager.',
                  style: TextStyle(color: getCreamColor(ctx), fontSize: 16),
                ),
                const SizedBox(height: 12),
                Text(
                  'Silakan setujui kategori ini terlebih dahulu di halaman Manajemen Kategori agar item ini bisa diproses.',
                  style: TextStyle(color: getSecondaryText(ctx), fontSize: 14),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Tutup',
                  style: TextStyle(color: getSecondaryText(ctx)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Approve Kategori'),
                          backgroundColor: getSurfaceColor(context),
                        ),
                        body: const CategoryManagementView(),
                      ),
                    ),
                  ).then((_) {
                    if (mounted) {
                      context.read<SettlementProvider>().loadSettlement(
                            widget.settlementId,
                          );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.category_rounded, size: 18),
                label: const Text('Ke Management Kategori'),
              ),
            ],
          ),
        );
        return;
      }

      final label = action == 'reject' ? 'rejected' : 'approved';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Expense $label ✓' : (prov.error ?? 'Gagal')),
          backgroundColor: success ? AppTheme.success : AppTheme.danger,
        ),
      );
    }
  }

  Future<void> bulkDeleteExpenses() async {
    final count = selectedExpenses.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: getCardColor(ctx),
        title: Text(
          'Hapus $count Item',
          style: TextStyle(color: getCreamColor(ctx)),
        ),
        content: Text(
          'Hapus $count pengeluaran yang dipilih? Tindakan ini tidak bisa dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!mounted) return;
    final prov = context.read<SettlementProvider>();
    final success = await prov.bulkDeleteExpenses(
      selectedExpenses.toList(),
      widget.settlementId,
    );
    if (success) {
      updateState(() => selectedExpenses.clear());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count item dihapus ✓'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    }
  }

  Future<void> confirmLogout() async {
    final confirmed = await AppDialogs.showExitConfirmation(
      context,
      isLogout: true,
    );
    if (confirmed && mounted) {
      context.read<AuthProvider>().logout();
    }
  }

  Future<void> fetchActiveAdvanceBalance(dynamic userId) async {
    if (!mounted) return;
    final prov = context.read<SettlementProvider>();
    final s = prov.currentSettlement;
    if (s == null) return;

    try {
      final int parsedUserId = int.tryParse(userId.toString()) ?? 0;
      if (parsedUserId > 0) {
        // 1. Fetch Debt (Virtual Balances)
        final balances = await prov.fetchUserVirtualBalances(parsedUserId);

        // 2. Fetch Real Bank Balances (Office Money)
        final res = await api.getActiveAdvanceBalance(parsedUserId);

        if (mounted) {
          updateState(() {
            userVirtualBalances = balances;
            userCashComposition = {};
            double totalDebt = 0;
            for (var item in balances) {
              final bankName = item['bank_name']?.toString() ?? '';
              final bal =
                  double.tryParse(item['balance']?.toString() ?? '0') ?? 0.0;
              if (bankName.isNotEmpty) {
                userCashComposition[bankName] = bal;
                totalDebt += bal;
              }
            }

            officeBankBalances = {};
            final compList = res['cash_composition'] ?? res['breakdown'];
            if (compList != null && compList is List) {
              for (var item in compList) {
                final bankName = item['bank_name']?.toString() ?? '';
                final bal =
                    double.tryParse(item['balance']?.toString() ?? '0') ?? 0.0;
                if (bankName.isNotEmpty) {
                  officeBankBalances[bankName] = bal;
                }
              }
            }

            // Update activeAdvanceBalance jika ini adalah settlement umum (bukan advance spesifik)
            if (s['advance_id'] == null || s['advance_id'] == 0) {
              activeAdvanceBalance = totalDebt;
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching advance data: $e');
    }

    if (!mounted) return;
  }

  void showWorkflowTimelineDialog(Map<String, dynamic> settlement) {
    final prov = context.read<SettlementProvider>();

    showDialog(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.of(ctx).size.width;
        return AlertDialog(
          backgroundColor: getCardColor(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: width > 760 ? 720 : width * 0.92,
            child: SingleChildScrollView(
              child: WorkflowTimeline(
                history: prov.workflowHistory,
                currentStage: settlement['current_stage']?.toString(),
                expectedCompletionAt:
                    settlement['expected_completion_at']?.toString(),
                loading: prov.workflowHistoryLoading,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
