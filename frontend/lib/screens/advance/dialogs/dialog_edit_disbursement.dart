import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/widgets/widget_file_list.dart';

extension AdvanceDetailDialogsGeneralshowEditDisbursementDialogExt
    on AdvanceDetailScreenState {
  void showEditDisbursementDialog(
    Map<String, dynamic> advance,
    List<String> options,
  ) {
    final approvedAmount = toDouble(advance['approved_amount']);
    List<String> localDisbursementFilePaths = List.from(disbursementFilePaths);
    List<String> localExistingPaths = List.from(existingDisbursementPaths);
    List<String> localExistingNames = List.from(existingDisbursementFilenames);
    String syncedSource = advanceDisbursementSourceLabel(advance);
    String? localDisbursementSource = syncedSource != '-' ? syncedSource : '-';
    final initialDisbursedAmount = toDouble(disbursedAmountController.text);
    final initialAdminFee = toDouble(adminFeeController.text);

    bool hasAttemptedSubmit = false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Rincian Pengiriman'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Tanggal Pengiriman'),
                    subtitle: Text(
                      AppFormatters.formatDateForApi(disbursementDate!),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: disbursementDate!,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setDialogState(() => disbursementDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: localDisbursementSource,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Sumber Dana',
                      border: OutlineInputBorder(),
                    ),
                    items: options.map(
                      (source) {
                        double? balance;
                        try {
                          final sourceKey = source.trim().toLowerCase();

                          // HANYA ambil saldo dari Virtual Bank Advance milik user yang bersangkutan!
                          // officeBankBalances menyimpan data res['breakdown'] dari getActiveAdvanceBalance user
                          final Map<String, dynamic> userBalances = {
                            ...officeBankBalances,
                          };

                          if (userBalances.isNotEmpty) {
                            for (var entry in userBalances.entries) {
                              if (entry.key.toString().trim().toLowerCase() ==
                                  sourceKey) {
                                balance =
                                    double.tryParse(entry.value.toString());
                                if (balance != null && balance > 0) break;
                              }
                            }
                          }

                          // Jika tidak ada di officeBankBalances, cari di cash_composition dokumen
                          if (balance == null || balance == 0) {
                            final cashComp = advance['cash_composition'];
                            if (cashComp != null &&
                                cashComp is Map &&
                                cashComp.isNotEmpty) {
                              for (var k in cashComp.keys) {
                                if (k.toString().trim().toLowerCase() ==
                                    sourceKey) {
                                  balance = double.tryParse(
                                      (cashComp[k] ?? 0).toString());
                                  break;
                                }
                              }
                            }
                          }

                          if (sourceKey == 'advance') {
                            balance = activeAdvanceBalance;
                          }
                        } catch (_) {}

                        return DropdownMenuItem<String>(
                          value: source,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  source,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (balance != null && balance > 1) // HIDE Rp 0
                                Text(
                                  AppFormatters.formatCurrency(balance),
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setDialogState(() => localDisbursementSource = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value == '-') {
                        return 'Sumber Dana wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    disbursementDescriptionController.text,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: disbursementCommentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar / Catatan Pengiriman',
                      hintText: 'Masukkan komentar tambahan jika ada...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: disbursedAmountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: 'Rp ',
                      border: const OutlineInputBorder(),
                      suffixIcon: TextButton(
                        onPressed: () {
                          setDialogState(() {
                            final formatted =
                                AppFormatters.formatCurrencyPlain(approvedAmount);
                            disbursedAmountController.text =
                                formatted == '0' ? '' : formatted;
                            disbursedAmountController.selection =
                                TextSelection.collapsed(
                              offset: disbursedAmountController.text.length,
                            );
                          });
                        },
                        child: const Text('Sesuai Sisa'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: adminFeeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Biaya Admin',
                      prefixText: 'Rp ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // UI Evidence Konsisten dengan Table 1 (Bukti Terpilih, Button Tambah Bukti, dsb)
                  if (localExistingPaths.isNotEmpty ||
                      localDisbursementFilePaths.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bukti Terpilih:',
                            style: TextStyle(
                              color: secondaryText(ctx),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Tampilkan existing (readonly or deletable)
                          if (localExistingPaths.isNotEmpty)
                            buildFileList(
                              localExistingPaths,
                              localExistingNames,
                              false,
                              (idx) {
                                localExistingPaths.removeAt(idx);
                                if (localExistingNames.length > idx) {
                                  localExistingNames.removeAt(idx);
                                }
                              },
                              ctx,
                              setDialogState,
                            ),
                          // Tampilkan yang baru diupload
                          if (localDisbursementFilePaths.isNotEmpty)
                            buildFileList(
                              localDisbursementFilePaths,
                              null,
                              true,
                              (idx) => localDisbursementFilePaths.removeAt(idx),
                              ctx,
                              setDialogState,
                            ),
                        ],
                      ),
                    ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final paths = await pickDisbursementEvidence();
                      if (paths != null) {
                        setDialogState(() {
                          for (var p in paths) {
                            if (!localDisbursementFilePaths.contains(p)) {
                              localDisbursementFilePaths.add(p);
                            }
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Tambah Bukti'),
                  ),
                  if (hasAttemptedSubmit &&
                      localExistingPaths.isEmpty &&
                      localDisbursementFilePaths.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Evidence (Bukti) wajib diisi',
                        style: TextStyle(
                          color: AppTheme.danger,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                setDialogState(() => hasAttemptedSubmit = true);

                final prov = context.read<AdvanceProvider>();
                final disbursementSource = localDisbursementSource?.trim();

                if (!formKey.currentState!.validate()) {
                  return;
                }

                if (localExistingPaths.isEmpty &&
                    localDisbursementFilePaths.isEmpty) {
                  return;
                }

                setDialogState(() => isSaving = true);
                final currentDisbursedAmount =
                    toDouble(disbursedAmountController.text);
                final currentAdminFee = toDouble(adminFeeController.text);
                final changedDisbursed =
                    (currentDisbursedAmount - initialDisbursedAmount).abs() >
                        0.0001;
                final changedAdminFee =
                    (currentAdminFee - initialAdminFee).abs() > 0.0001;

                final selectedBankId =
                    getBankIdFromSourceName(disbursementSource);

                final success = await prov.saveDisbursement(
                  advanceId: widget.advanceId,
                  bankId: selectedBankId,
                  disbursementSource: disbursementSource,
                  disbursementSourceId: selectedBankId,
                  adminFee: changedAdminFee ? currentAdminFee : null,
                  disbursedAmount:
                      changedDisbursed ? currentDisbursedAmount : null,
                  disbursementComment:
                      disbursementCommentController.text.trim(),
                  evidenceFiles:
                      localDisbursementFilePaths.map((p) => File(p)).toList(),
                  existingFilePaths: localExistingPaths,
                  existingFileNames: localExistingNames,
                );
                setDialogState(() => isSaving = false);

                if (success && mounted) {
                  updateState(() {
                    disbursementFilePaths.clear();
                    disbursementFilePaths.addAll(localDisbursementFilePaths);
                  });
                  // Refresh balances immediately
                  if (prov.currentAdvanceMap != null) {
                    await fetchActiveAdvanceBalance(
                        prov.currentAdvanceMap!['user_id']);
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                } else if (!success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(prov.error ?? 'Gagal menyimpan data'),
                      backgroundColor: AppTheme.danger,
                    ),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
