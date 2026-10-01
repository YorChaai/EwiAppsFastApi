import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';
import 'package:expense_app/services/bank_order_preferences.dart';


extension BankManagementDialogsshowEditAdvanceBalanceDialogExt
    on BankManagementScreenState {
  Future<void> showEditAdvanceBalanceDialog(Map<String, dynamic> user) async {
    final formKey = GlobalKey<FormState>();
    final notesCtrl = TextEditingController();
    List<Map<String, dynamic>> allocations = [
      {
        'bank_id': null,
        'controller': TextEditingController(),
        'isPositive': true
      }
    ];

    StateSetter? dialogStateSetter;
    final bankProvider = context.read<BankManagementProvider>();
    if (bankProvider.banks.isEmpty) {
      bankProvider.loadBanks().then((_) {
        if (dialogStateSetter != null) dialogStateSetter!(() {});
      });
    }

    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    double getTotalAllocation() {
      double total = 0;
      for (var alloc in allocations) {
        final text = alloc['controller'].text.replaceAll('.', '');
        double amt = (text.isEmpty ? 0 : (double.tryParse(text) ?? 0));
        if (alloc['isPositive'] == false) amt = -amt;
        total += amt;
      }
      return total;
    }

    bool isSubmitting = false;
    final customCashOrderIds = await BankOrderPreferences.getBankCashOrder();
    if (!mounted) return;

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: surfaceColor(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) {
            dialogStateSetter = setDialogState;
            final availableBanks = bankProvider.banks;
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: secondaryTextColor(context)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        Expanded(
                          child: Text(
                            'Penyesuaian Saldo - ${user['full_name']}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark(context)
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...allocations.asMap().entries.map((entry) {
                            int index = entry.key;
                            var alloc = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: secondaryTextColor(context)
                                        .withValues(alpha: 0.2)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sumber Dana ${index + 1}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                      if (allocations.length > 1)
                                        InkWell(
                                          onTap: () {
                                            setDialogState(() {
                                              alloc['controller'].dispose();
                                              allocations.removeAt(index);
                                            });
                                          },
                                          child: const Icon(Icons.close,
                                              color: AppTheme.danger, size: 20),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    initialValue: alloc['bank_id'],
                                    dropdownColor: cardColor(context),
                                    decoration: InputDecoration(
                                        labelText: 'Pilih Bank Cash ${index + 1}',
                                        isDense: true),
                                    items: () {
                                      final sortedBanks =
                                          List<dynamic>.from(availableBanks);
                                      BankOrderPreferences.sortBankMaps(
                                          sortedBanks,
                                          customOrderIds: customCashOrderIds);
                                      return sortedBanks
                                          .map<DropdownMenuItem<int>>((bank) {
                                        final rb = double.tryParse(
                                                (bank['real_balance'] ?? 0.0)
                                                    .toString()) ??
                                            0.0;
                                        String title = bank['name'] ?? '';
                                        return DropdownMenuItem<int>(
                                          value: bank['id'],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  title,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                'Rp ${currencyFormat.format(rb).replaceAll("Rp ", "")}',
                                                style: const TextStyle(
                                                  color: AppTheme.accent,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList();
                                    }(),
                                    onChanged: (val) {
                                      setDialogState(
                                          () => alloc['bank_id'] = val);
                                    },
                                    validator: (val) =>
                                        val == null ? 'Pilih bank' : null,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                       Semantics(
                                         button: true,
                                         label: 'Ubah Positif Negatif ${index + 1}',
                                         child: InkWell(
                                           onTap: () {
                                             setDialogState(() {
                                               alloc['isPositive'] =
                                                   !(alloc['isPositive'] as bool);
                                             });
                                           },
                                           child: Container(
                                             height: 52,
                                             width: 52,
                                             margin:
                                                 const EdgeInsets.only(right: 12),
                                             decoration: BoxDecoration(
                                               color: (alloc['isPositive'] as bool)
                                                   ? AppTheme.success
                                                       .withValues(alpha: 0.1)
                                                   : AppTheme.danger
                                                       .withValues(alpha: 0.1),
                                               border: Border.all(
                                                 color:
                                                     (alloc['isPositive'] as bool)
                                                         ? AppTheme.success
                                                         : AppTheme.danger,
                                               ),
                                               borderRadius:
                                                   BorderRadius.circular(12),
                                             ),
                                             child: Center(
                                               child: Icon(
                                                 (alloc['isPositive'] as bool)
                                                     ? Icons.add
                                                     : Icons.remove,
                                                 color:
                                                     (alloc['isPositive'] as bool)
                                                         ? AppTheme.success
                                                         : AppTheme.danger,
                                                 size: 24,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: alloc['controller'],
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            CurrencyInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Jumlah Penyesuaian Saldo ${index + 1} (Rp)',
                                              hintText: '0',
                                              isDense: true,
                                              prefixText:
                                                  (alloc['isPositive'] as bool)
                                                      ? '+ '
                                                      : '- ',
                                              prefixStyle: TextStyle(
                                                color: (alloc['isPositive']
                                                        as bool)
                                                    ? AppTheme.success
                                                    : AppTheme.danger,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          onChanged: (val) =>
                                              setDialogState(() {}),
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Wajib diisi';
                                            }
                                            final cleanText =
                                                v.replaceAll('.', '');
                                            final parsed =
                                                double.tryParse(cleanText);
                                            if (parsed == null) {
                                              return 'Harus angka valid';
                                            }
                                            if (parsed.abs() < 100) {
                                              return 'Minimal nominal Rp 100';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          OutlinedButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                allocations.add({
                                  'bank_id': null,
                                  'controller': TextEditingController(),
                                  'isPositive': true
                                });
                              });
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Tambah Sumber Dana'),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Penyesuaian',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      (getTotalAllocation() >= 0 ? '+' : '') +
                                          currencyFormat
                                              .format(getTotalAllocation()),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getTotalAllocation() >= 0
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: surfaceColor(context),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Saldo Virtual Baru (Prediksi)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme
                                                  .getSecondaryTextColor(
                                                      context))),
                                      Text(
                                        currencyFormat.format(
                                            (advanceBalances[user['id']] ??
                                                    0.0) +
                                                getTotalAllocation()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primary,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: notesCtrl,
                            decoration: const InputDecoration(
                                labelText: 'Catatan / Alasan Alokasi (Opsional)',
                                hintText: 'Contoh: Terima Alokasi Operasional Proyek'),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: isSubmitting
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) return;

                                    List<Map<String, dynamic>> allocData =
                                        allocations.map((a) {
                                      final text =
                                          a['controller'].text.replaceAll('.', '');
                                      double amt = text.isEmpty
                                          ? 0.0
                                          : (double.tryParse(text) ?? 0.0);
                                      if (a['isPositive'] == false) amt = -amt;
                                      return {
                                        'bank_id': a['bank_id'],
                                        'amount': amt,
                                      };
                                    }).toList();

                                    final prov =
                                        context.read<BankManagementProvider>();
                                    final sm = ScaffoldMessenger.of(context);

                                    if ((advanceBalances[user['id']] ?? 0.0) +
                                            getTotalAllocation() <
                                        -0.01) {
                                      sm.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Prediksi saldo virtual tidak boleh di bawah nol.'),
                                          backgroundColor: AppTheme.danger,
                                        ),
                                      );
                                      return;
                                    }

                                    setDialogState(() => isSubmitting = true);
                                    try {
                                      String finalNote = notesCtrl.text.trim();
                                      if (finalNote.isEmpty) {
                                        finalNote = getTotalAllocation() >= 0
                                            ? 'Terima Alokasi'
                                            : 'Tarik Alokasi';
                                      }
                                      await advanceApi.initializeAdvanceBalance(
                                          user['id'],
                                          finalNote,
                                          allocData);

                                      // Global Sync: Reload Advance, Cash, and Transactions
                                      await Future.wait([
                                        loadAdvanceData(),
                                        prov.loadBanks(),
                                        loadData(),
                                      ]);

                                      if (ctx.mounted) {
                                        Navigator.pop(ctx);
                                      }
                                      if (mounted) {
                                        sm.showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Saldo virtual berhasil disesuaikan!'),
                                              backgroundColor: AppTheme.success),
                                        );
                                      }
                                    } catch (e) {
                                      if (ctx.mounted) {
                                        setDialogState(() => isSubmitting = false);
                                      }
                                      if (mounted) {
                                        sm.showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Gagal menyesuaikan saldo: $e'),
                                              backgroundColor: AppTheme.danger),
                                        );
                                      }
                                    }
                                  },
                            icon: isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.check_circle_outline_rounded),
                            label: Text(isSubmitting
                                ? 'Menyimpan...'
                                : 'Simpan Penyesuaian Saldo'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Error showing dialog: $e');
    }
  }
}
