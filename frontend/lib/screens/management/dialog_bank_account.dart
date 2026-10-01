import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/transaction_templates.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';


extension BankManagementDialogsshowBankAccountDialogExt
    on BankManagementScreenState {
  Future<void> showBankAccountDialog(Map<String, dynamic>? data,
      {bool isEditOnly = false, bool isAdjustOnly = false}) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: data?['name'] ?? '');
    final accountCtrl =
        TextEditingController(text: data?['account_number'] ?? '');

    // Untuk mode edit: adjustment +/- dari saldo saat ini (riil)
    final double currentBalance = data?['real_balance'] != null
        ? double.tryParse(data!['real_balance'].toString()) ?? 0.0
        : (data?['initial_balance'] != null
            ? (data!['initial_balance'] as num).toDouble()
            : 0.0);
    final adjustmentCtrl = TextEditingController(text: '0');
    bool isPositive = true; // true = tambah, false = kurang

    String currency = data?['currency'] ?? 'IDR';
    final fmt = NumberFormat.decimalPattern('id_ID');
    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, updateState) => AlertDialog(
          backgroundColor: cardColor(ctx),
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(ctx),
                color: creamColor(ctx),
              ),
              Expanded(
                child: Text(
                  data == null
                      ? 'Tambah Rekening Bank'
                      : (isAdjustOnly ? 'Kelola Cash/Uang' : 'Edit Bank Cash'),
                  style: TextStyle(color: creamColor(ctx)),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 450,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isAdjustOnly) ...[
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Bank / Kantong',
                          hintText: 'Contoh: BCA EWI (IDR), Mandiri Giro, Cash',
                        ),
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: accountCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Rekening',
                          hintText: 'Contoh: 1234567890 (kosongkan jika Cash)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: currency,
                        items: const [
                          DropdownMenuItem(
                              value: 'IDR', child: Text('IDR (Rupiah)')),
                          DropdownMenuItem(
                              value: 'USD', child: Text('USD (Dollar)')),
                        ],
                        onChanged: (v) => updateState(() => currency = v!),
                        decoration:
                            const InputDecoration(labelText: 'Mata Uang'),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (data != null && !isEditOnly) ...[
                      // MODE EDIT: +/- adjustment dari saldo saat ini
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.getSecondaryTextColor(ctx)
                              .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo Saat Ini: Rp${fmt.format(currentBalance.toInt())}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.getSecondaryTextColor(ctx),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // +/- toggle button
                                GestureDetector(
                                  onTap: () => updateState(
                                      () => isPositive = !isPositive),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 44,
                                    height: 52,
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 4),
                                    decoration: BoxDecoration(
                                      color: isPositive
                                          ? AppTheme.success
                                              .withValues(alpha: 0.1)
                                          : AppTheme.danger
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isPositive
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      isPositive ? Icons.add : Icons.remove,
                                      color: isPositive
                                          ? AppTheme.success
                                          : AppTheme.danger,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                // Nominal input
                                Expanded(
                                  child: TextFormField(
                                    controller: adjustmentCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [CurrencyInputFormatter()],
                                    style: TextStyle(
                                      color: isPositive
                                          ? AppTheme.success
                                          : AppTheme.danger,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    validator: (v) {
                                      final val = double.tryParse((v ?? '')
                                              .replaceAll('.', '')
                                              .replaceAll(',', '.')) ??
                                          0.0;
                                      final minVal = currency == 'IDR' ? 100.0 : 0.01;
                                      if (val < minVal) {
                                        return currency == 'IDR'
                                            ? 'Nominal penyesuaian minimal Rp 100'
                                            : 'Nominal penyesuaian harus lebih dari 0';
                                      }
                                      if (!isPositive && val > currentBalance) {
                                        return 'Saldo tidak mencukupi (Maks: Rp${fmt.format(currentBalance.toInt())})';
                                      }
                                      return null;
                                    },
                                    onChanged: (_) => updateState(() {}),
                                    decoration: InputDecoration(
                                      labelText: 'Jumlah Penyesuaian',
                                      labelStyle: TextStyle(
                                        color: isPositive
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                      ),
                                      prefixText: isPositive ? '+ ' : '- ',
                                      prefixStyle: TextStyle(
                                        color: isPositive
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Real-time preview
                            Builder(builder: (_) {
                              final adj = double.tryParse(
                                    adjustmentCtrl.text
                                        .replaceAll('.', '')
                                        .replaceAll(',', '.'),
                                  ) ??
                                  0.0;
                              final newBal = isPositive
                                  ? currentBalance + adj
                                  : currentBalance - adj;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rp${fmt.format(currentBalance.toInt())} ${isPositive ? "+" : "-"} Rp${fmt.format(adj.toInt())} = ',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.getSecondaryTextColor(
                                              ctx)),
                                    ),
                                    Text(
                                      'Rp${fmt.format(newBal.toInt())}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: newBal >= 0
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ] else if (data == null) ...[
                      // MODE TAMBAH BARU: input langsung
                      TextFormField(
                        controller: adjustmentCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [CurrencyInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Saldo Awal / Opening Balance',
                        ),
                        validator: (v) => double.tryParse((v ?? '')
                                    .replaceAll('.', '')
                                    .replaceAll(',', '.')) ==
                                null
                            ? 'Input harus angka valid'
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            if (data != null && !isAdjustOnly)
              TextButton.icon(
                onPressed: () async {
                  final prov = context.read<BankManagementProvider>();
                  final shouldDelete =
                      await _showDeleteConfirmation(ctx, data['name'] ?? '');
                  if (!shouldDelete) return;

                  try {
                    await prov.deleteBankAccount(data['id']);
                    await Future.wait([
                      prov.loadBanks(),
                      loadAdvanceData(),
                    ]);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Rekening bank berhasil dihapus.'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      final cleanMsg =
                          e.toString().replaceAll('Exception: ', '');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(cleanMsg),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppTheme.danger, size: 18),
                label: const Text('Hapus Rekening',
                    style: TextStyle(
                        color: AppTheme.danger, fontWeight: FontWeight.bold)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;

                      final adj = double.tryParse(
                            adjustmentCtrl.text
                                .replaceAll('.', '')
                                .replaceAll(',', '.'),
                          ) ??
                          0.0;

                      final minVal = currency == 'IDR' ? 100.0 : 0.01;
                      if (isAdjustOnly && adj < minVal) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(currency == 'IDR'
                                ? 'Nominal penyesuaian minimal Rp 100.'
                                : 'Nominal penyesuaian harus lebih dari 0.'),
                            backgroundColor: AppTheme.danger,
                          ),
                        );
                        return;
                      }

                      if (isAdjustOnly && !isPositive && adj > currentBalance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Saldo tidak mencukupi untuk melakukan penarikan kas.'),
                            backgroundColor: AppTheme.danger,
                          ),
                        );
                        return;
                      }

                      updateState(() => isSubmitting = true);
                      final prov = context.read<BankManagementProvider>();
                      final newBalance = data == null
                          ? adj // Mode tambah baru: langsung
                          : (data['initial_balance'] as num)
                              .toDouble(); // Jangan ubah initial_balance saat edit
                      final payload = {
                        'name': nameCtrl.text.trim(),
                        'account_number': accountCtrl.text.trim(),
                        'currency': currency,
                        'initial_balance': newBalance,
                      };

                      try {
                        if (data == null) {
                          await prov.createBankAccount(payload);
                        } else {
                          await prov.updateBankAccount(data['id'], payload);
                          if (adj > 0) {
                            await prov.createTransaction({
                              'bank_id': data['id'],
                              'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              'description':
                                  '${isPositive ? TxTemplates.addRealCash : TxTemplates.subRealCash}|$currentBalance|${isPositive ? currentBalance + adj : currentBalance - adj}',
                              'amount_idr': currency == 'IDR' ? adj : 0.0,
                              'amount_usd': currency == 'USD' ? adj : 0.0,
                              'transaction_type': isPositive ? 'income' : 'expense',
                              'group_name': 'Penyesuaian Saldo',
                              'report_year': DateTime.now().year,
                            });
                          }
                        }
                        // Global Sync: Reload both Cash and Advance data
                        await Future.wait([
                          prov.loadBanks(),
                          loadAdvanceData(),
                        ]);

                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          final isEdit = data != null && !isAdjustOnly;
                          final msg = isAdjustOnly
                              ? 'Saldo kas berhasil disesuaikan.'
                              : (isEdit
                                  ? 'Data rekening berhasil diperbarui.'
                                  : 'Rekening bank berhasil ditambahkan.');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(msg),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      } catch (e) {
                        if (ctx.mounted) {
                          updateState(() => isSubmitting = false);
                        }
                        if (mounted) {
                          final cleanMsg = e.toString().replaceAll('Exception: ', '');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(cleanMsg),
                              backgroundColor: AppTheme.danger,
                            ),
                          );
                        }
                      }
                    },
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
      BuildContext context, String bankName) async {
    final deleteTextCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            // Wajib persis huruf besar DELETE
            final isMatched = deleteTextCtrl.text.trim() == 'DELETE';

            return AlertDialog(
              backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AppTheme.danger, size: 24),
                  SizedBox(width: 10),
                  Text('Konfirmasi Hapus'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apakah Anda yakin ingin menghapus rekening "$bankName"? Tindakan ini permanen dan tidak dapat dibatalkan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ketik "DELETE" di bawah ini untuk mengonfirmasi:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: deleteTextCtrl,
                    autofocus: true,
                    onChanged: (_) => setDialogState(() {}),
                    decoration: InputDecoration(
                      hintText: 'DELETE',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dCtx, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete_forever_rounded, size: 18),
                  label: const Text('Hapus Rekening'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        Colors.grey.withValues(alpha: 0.3),
                    disabledForegroundColor: Colors.grey,
                  ),
                  onPressed:
                      isMatched ? () => Navigator.pop(dCtx, true) : null,
                ),
              ],
            );
          },
        );
      },
    );

    deleteTextCtrl.dispose();
    return confirmed ?? false;
  }
}
