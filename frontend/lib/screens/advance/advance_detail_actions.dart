import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/screens/management/category_management_screen.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_insufficient_balance.dart';
import 'package:expense_app/screens/advance/layouts/advance_detail_layout.dart';

extension AdvanceDetailActionsExt on AdvanceDetailScreenState {
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

  Future<void> moveToDraft() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          'Kembalikan ke Draft?',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: Text(
          'Apakah Anda yakin ingin menarik kembali kasbon ini ke status Draft untuk melakukan perbaikan?',
          style: TextStyle(color: secondaryText(ctx)),
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
    final prov = context.read<AdvanceProvider>();
    final success = await prov.moveAdvanceToDraft(widget.advanceId);
    if (!mounted) return;
    if (success) {
      GlobalEventBus
          .triggerRefresh(); // ✅ Refresh semua halaman (Bank, Laporan, Settings, dll.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kasbon ditarik ke draft ✓'),
          backgroundColor: AppTheme.success,
        ),
      );
      if (prov.currentAdvanceMap != null) {
        await fetchActiveAdvanceBalance(prov.currentAdvanceMap!['user_id']);
      }
      await prov.loadAdvance(widget.advanceId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(prov.error ?? 'Gagal memindahkan ke draft'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> approveAdvance() async {
    final currentAdvance = context.read<AdvanceProvider>().currentAdvanceMap;
    if (currentAdvance == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Penyelesaian'),
        content: const Text(
            'Apakah Anda yakin ingin menyetujui final kasbon ini? Data akan dicatat ke Bank.'),
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
    final prov = context.read<AdvanceProvider>();

    try {
      // Find the bankId from the disbursement source
      final source = advanceDisbursementSourceLabel(currentAdvance);
      final bankId = getBankIdFromSourceName(source);

      final success = await prov.finalApproveAdvance(
        widget.advanceId,
        bankId: bankId,
      );
      if (!mounted) return;
      if (success) {
        GlobalEventBus.triggerRefresh(); // Refresh Bank Advance & other screens
        await Future.wait([
          prov.loadAdvance(widget.advanceId),
          fetchActiveAdvanceBalance(currentAdvance['user_id']),
        ]);

        if (!mounted) return;
        showGlobalSnackBar(
          'Kasbon berhasil disetujui final ✓',
          AppTheme.success,
        );
      } else {
        if (!mounted) return;
        showGlobalSnackBar(
          prov.error ?? 'Gagal menyetujui final kasbon',
          AppTheme.danger,
        );
      }
    } on InsufficientAdvanceBalanceException catch (ex) {
      if (mounted) showInsufficientBalanceDialog(ex);
    } finally {
      if (mounted) updateState(() => isSaving = false);
    }
  }

  Future<void> rejectItem(int itemId) async {
    final controllers = [TextEditingController()];

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: cardColor(ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              'Tolak Item',
              style: TextStyle(color: creamColor(ctx)),
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
                      color: secondaryText(ctx),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: controllers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final ctrl = entry.value;
                          return Padding(
                            key: ValueKey(ctrl),
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_box_outline_blank_rounded,
                                  size: 20,
                                  color: secondaryText(ctx),
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
                                      color: primaryText(ctx),
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
                onPressed: () {
                  Navigator.pop(ctx, false);
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controllers.every((c) => c.text.trim().isEmpty)) return;
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

    if (result == true) {
      if (!mounted) {
        for (var c in controllers) {
          try {
            c.dispose();
          } catch (_) {}
        }
        return;
      }
      final reasons = controllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .map((t) => {'text': t, 'checked': false})
          .toList();

      if (reasons.isNotEmpty) {
        final notesJson = jsonEncode(reasons);
        final prov = context.read<AdvanceProvider>();
        final success = await prov.approveAdvanceItem(
          itemId,
          'reject',
          notes: notesJson,
        );
        if (mounted) {
          if (success) {
            prov.loadAdvance(widget.advanceId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(prov.error ?? 'Gagal reject item'),
                backgroundColor: AppTheme.danger,
              ),
            );
          }
        }
      }
    }

    // Always dispose after everything is done
    Future.delayed(const Duration(milliseconds: 300), () {
      for (var c in controllers) {
        try {
          c.dispose();
        } catch (_) {}
      }
    });
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

  void deleteItem(int itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Item'),
        content: const Text('Apakah Anda yakin ingin menghapus item ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final prov = context.read<AdvanceProvider>();
              final success = await prov.deleteAdvanceItem(itemId);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    success
                        ? 'Item dihapus'
                        : (prov.error ?? 'Gagal menghapus'),
                  ),
                  backgroundColor: success ? AppTheme.success : AppTheme.danger,
                ),
              );
              if (success) {
                prov.loadAdvance(widget.advanceId);
              }
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: AppTheme.danger),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> downloadReceipt() async {
    try {
      final prov = context.read<AdvanceProvider>();
      final bytes = await prov.getAdvanceReceipt(widget.advanceId);
      final timestamp = FileHelper.formatTimestamp(DateTime.now());
      final filename = 'Kasbon_${widget.advanceId}_$timestamp.pdf';

      if (mounted) {
        await FileHelper.saveAndOpenFile(
          context: context,
          bytes: bytes,
          filename: filename,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal export PDF: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> submitAdvance() async {
    final prov = context.read<AdvanceProvider>();
    final success = await prov.submitAdvance(widget.advanceId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kasbon berhasil disubmit untuk approval'),
        ),
      );
      prov.loadAdvance(widget.advanceId);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            prov.error ?? 'Submit gagal. Cek checklist komentar revisi.',
          ),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  void bulkDeleteItems() async {
    final count = selectedItemIds.length;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          'Hapus $count Item',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: Text(
          'Hapus $count item yang dipilih? Tindakan ini tidak bisa dibatalkan.',
          style: TextStyle(color: secondaryText(ctx)),
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
    final prov = context.read<AdvanceProvider>();
    final success = await prov.bulkDeleteAdvanceItems(
      selectedItemIds.toList(),
      widget.advanceId,
    );
    if (success) {
      updateState(() => selectedItemIds.clear());
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

  Widget buildSaveChecklistButton(
    BuildContext dialogCtx,
    int itemId,
    List<Map<String, dynamic>> list,
    String status,
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
          newStatus =
              'pending'; // or 'rejected', but maybe they just shouldn't be here
        }

        final cleanList = list.map((it) {
          final map = Map<String, dynamic>.from(it);
          map.remove('focusNode');
          return map;
        }).toList();

        final prov = context.read<AdvanceProvider>();
        final success = await prov.updateItemPartial(itemId, {
          'notes': jsonEncode(cleanList),
          'status': newStatus,
        });

        if (success) {
          prov.loadAdvance(widget.advanceId);
          if (dialogCtx.mounted) Navigator.pop(dialogCtx);
          showGlobalSnackBar(
            'Checklist berhasil disimpan ✓',
            AppTheme.success,
          );
        } else {
          if (dialogCtx.mounted) Navigator.pop(dialogCtx);
          showGlobalSnackBar('Gagal menyimpan checklist', AppTheme.danger);
        }
      },
      child: const Text('Simpan'),
    );
  }

  Future<void> approveItem(int itemId) async {
    final prov = context.read<AdvanceProvider>();
    try {
      final success = await prov.approveAdvanceItem(itemId, 'approve');
      if (!mounted) return;
      if (success) {
        prov.loadAdvance(widget.advanceId);
      } else {
        if (!mounted) return;
        if ((prov.error ?? '').contains('belum disetujui')) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: cardColor(ctx),
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
                      color: creamColor(ctx),
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
                    style: TextStyle(color: creamColor(ctx), fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Silakan setujui kategori ini terlebih dahulu di halaman Manajemen Kategori agar item ini bisa diproses.',
                    style: TextStyle(color: secondaryText(ctx), fontSize: 14),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Tutup',
                    style: TextStyle(color: secondaryText(ctx)),
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
                            backgroundColor: surfaceColor(context),
                          ),
                          body: const CategoryManagementView(),
                        ),
                      ),
                    ).then((_) {
                      if (mounted) {
                        context.read<AdvanceProvider>().loadAdvance(
                              widget.advanceId,
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(prov.error ?? 'Gagal approve item'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } on InsufficientAdvanceBalanceException catch (ex) {
      if (mounted) showInsufficientBalanceDialog(ex);
    }
  }

  Future<void> exportAdvanceExcel() async {
    try {
      final prov = context.read<AdvanceProvider>();
      final bytes = await prov.exportExcel(advanceId: widget.advanceId);
      final timestamp = FileHelper.formatTimestamp(DateTime.now());
      final filename = 'Kasbon_${widget.advanceId}_$timestamp.xlsx';

      if (mounted) {
        await FileHelper.saveAndOpenFolder(
          context: context,
          bytes: bytes,
          filename: filename,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal export Excel: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  bool canEditCurrentRevision(
    Map<String, dynamic> advance,
    Map<String, dynamic> item,
  ) {
    final status = (advance['status'] ?? '').toString();
    if (status == 'completed' ||
        status == 'approved' ||
        status == 'manager_approved') {
      return false;
    }

    final itemRevisionNo = item['revision_no'] ?? 0;
    if (status == 'draft' || status == 'rejected') {
      return itemRevisionNo == 0;
    }
    if (status == 'revision' || status == 'rejected') {
      return itemRevisionNo == (advance['active_revision_no'] ?? -1);
    }
    return false;
  }

  bool canApproveAdvanceItems(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return false;
    return items.every(
      (item) =>
          (item['status'] ?? 'pending').toString().toLowerCase() == 'approved',
    );
  }

  bool canSubmitAdvanceItems(
      List<Map<String, dynamic>> items, Map<String, dynamic> adv) {
    if (items.isEmpty) return false;

    // 1. Validasi Tabel 1 (Selalu Wajib)
    final itemsOk = !items.any(hasUncheckedChecklist);
    if (!itemsOk) return false;

    // Cek apakah Tabel 1 sudah Full Approved (Siap ke Tabel 2)
    final allApproved =
        items.isNotEmpty && items.every((item) => item['status'] == 'approved');

    // 2. Validasi Tabel 2 (HANYA jika Tabel 1 sudah Approved)
    if (allApproved) {
      final isSourceValid = advanceDisbursementSourceLabel(adv) != '-' &&
          advanceDisbursementSourceLabel(adv) != 'Pilih Sumber Dana';
      final isEvidenceValid = adv['disbursement_evidence_path'] != null &&
          adv['disbursement_evidence_path'].toString().trim().isNotEmpty;
      final isAmountValid = toDouble(adv['disbursed_amount']) > 0;
      final isDisbursementComplete =
          isSourceValid && isEvidenceValid && isAmountValid;
      if (!isDisbursementComplete) return false;
    }

    return true;
  }

  Future<void> fetchActiveAdvanceBalance(dynamic userId) async {
    if (userId == null) return;
    try {
      final uid = int.tryParse(userId.toString());
      if (uid == null) return;

      final prov = context.read<AdvanceProvider>();

      // 1. Fetch Debt (Virtual Balances)
      final balances = await prov.fetchUserVirtualBalances(uid);

      // 2. Fetch Real Bank Balances (Office Money)
      final res = await api.getActiveAdvanceBalance(uid);

      if (mounted) {
        updateState(() {
          // Update Debt Data
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
          activeAdvanceBalance = totalDebt;

          // Update Office Bank Balances Data
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
        });
      }
    } catch (e) {
      debugPrint('Error fetching advance data: $e');
    }
  }
}
