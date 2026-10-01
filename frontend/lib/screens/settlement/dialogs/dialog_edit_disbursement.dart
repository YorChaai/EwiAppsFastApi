
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/app_formatters.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/widgets/widget_file_list.dart';

extension SettlementDetailDialogsGeneralshowEditDisbursementDialogExt
    on SettlementDetailScreenState {
  void showEditDisbursementDialog(
    Map<String, dynamic> settlement,
    List<String> options,
  ) {
    final approvedExpenses = approvedSettlementExpenses(settlement);
    final totalApproved = approvedExpenses.fold<double>(
      0,
      (sum, e) =>
          sum + (double.tryParse(e['idr_amount']?.toString() ?? '0') ?? 0.0),
    );

    List<String> localDisbursementFilePaths = [];
    List<String> localDisbursementFileNames = [];
    String syncedSource = settlementDisbursementSourceLabel(settlement);
    String? localDisbursementSource = syncedSource != '-' ? syncedSource : '-';
    final initialDisbursedAmount = toDouble(disbursedAmountController.text);
    final initialAdminFee = toDouble(adminFeeController.text);

    // Initialize existing files11
    List<String> currentExistingPaths =
        (settlement['disbursement_evidence_path']?.toString() ?? '')
            .split('|')
            .where((p) => p.isNotEmpty)
            .toList();
    List<String> currentExistingNames =
        (settlement['disbursement_evidence_filename']?.toString() ?? '')
            .split('|')
            .where((f) => f.isNotEmpty)
            .toList();

    bool hasAttemptedSubmit = false;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: getCardColor(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Edit Rincian Pengiriman',
                style: TextStyle(color: getCreamColor(ctx))),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Tanggal Pengiriman',
                            style: TextStyle(color: getCreamColor(ctx))),
                        subtitle: Text(
                          AppFormatters.formatDateForApi(disbursementDate!),
                          style: TextStyle(color: getSecondaryText(ctx)),
                        ),
                        trailing:
                            Icon(Icons.calendar_today, color: AppTheme.primary),
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
                        dropdownColor: getCardColor(ctx),
                        isExpanded: true,
                        style: TextStyle(color: getPrimaryText(ctx)),
                        decoration: const InputDecoration(
                          labelText: 'Sumber Dana',
                          border: OutlineInputBorder(),
                        ),
                        items: fundSourceOptions(settlement).map(
                          (source) {
                            double? balance;
                            try {
                              final sourceKey = source.trim().toLowerCase();

                              // HANYA ambil saldo dari Virtual Bank Advance milik user yang bersangkutan!
                              final Map<String, dynamic> userBalances = {
                                ...officeBankBalances,
                              };

                              if (userBalances.isNotEmpty) {
                                for (var entry in userBalances.entries) {
                                  if (entry.key
                                          .toString()
                                          .trim()
                                          .toLowerCase() ==
                                      sourceKey) {
                                    balance =
                                        double.tryParse(entry.value.toString());
                                    if (balance != null && balance > 0) break;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      source,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (balance != null &&
                                      balance > 1) // HIDE Rp 0
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
                        style: TextStyle(color: getPrimaryText(ctx)),
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
                        style: TextStyle(color: getPrimaryText(ctx)),
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          prefixText: 'Rp ',
                          border: const OutlineInputBorder(),
                          suffixIcon: TextButton(
                            onPressed: () {
                              setDialogState(() {
                                double sisa = settlementReimbursementAmount(settlement);
                                if (sisa <= 0.01) {
                                  sisa = totalApproved - activeAdvanceBalance;
                                }
                                if (sisa < 0) sisa = 0;
                                final formatted =
                                    AppFormatters.formatCurrencyPlain(sisa);
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
                        style: TextStyle(color: getPrimaryText(ctx)),
                        decoration: const InputDecoration(
                          labelText: 'Biaya Admin',
                          prefixText: 'Rp ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Evidence (Bukti Transfer)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: getCreamColor(ctx)),
                      ),
                      const SizedBox(height: 8),
                      // UI Evidence Konsisten dengan Table 1 (Bukti Terpilih, Button Tambah Bukti, dsb)
                      if (currentExistingPaths.isNotEmpty ||
                          localDisbursementFilePaths.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bukti Terpilih:',
                                style: TextStyle(
                                  color: getSecondaryText(ctx),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (currentExistingPaths.isNotEmpty)
                                buildFileList(
                                  context,
                                  currentExistingPaths,
                                  currentExistingNames,
                                  false,
                                  (idx) {
                                    setDialogState(() {
                                      currentExistingPaths.removeAt(idx);
                                      if (currentExistingNames.length > idx) {
                                        currentExistingNames.removeAt(idx);
                                      }
                                    });
                                  },
                                ),
                              if (localDisbursementFilePaths.isNotEmpty)
                                buildFileList(
                                  context,
                                  localDisbursementFilePaths,
                                  localDisbursementFileNames,
                                  true,
                                  (idx) {
                                    setDialogState(() {
                                      localDisbursementFilePaths.removeAt(idx);
                                      localDisbursementFileNames.removeAt(idx);
                                    });
                                  },
                                ),
                            ],
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.pickFiles(
                            type: FileType.custom,
                            allowMultiple: true,
                            allowedExtensions: [
                              'jpg',
                              'jpeg',
                              'png',
                              'pdf',
                              'webp'
                            ],
                          );
                          if (result != null && result.files.isNotEmpty) {
                            setDialogState(() {
                              for (var file in result.files) {
                                if (file.path != null &&
                                    !localDisbursementFilePaths.contains(
                                      file.path,
                                    )) {
                                  localDisbursementFilePaths.add(file.path!);
                                  localDisbursementFileNames.add(file.name);
                                }
                              }
                            });
                          }
                        },
                        icon: const Icon(Icons.upload_file_rounded),
                        label: const Text('Tambah Bukti'),
                      ),
                      if (hasAttemptedSubmit &&
                          currentExistingPaths.isEmpty &&
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
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  setDialogState(() => hasAttemptedSubmit = true);

                  final prov = context.read<SettlementProvider>();
                  final disbursementSource = localDisbursementSource?.trim();

                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  if (currentExistingPaths.isEmpty &&
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
                    settlementId: widget.settlementId,
                    bankId: selectedBankId,
                    disbursementSource: disbursementSource,
                    disbursementSourceId: selectedBankId,
                    adminFee: changedAdminFee ? currentAdminFee : null,
                    disbursedAmount:
                        changedDisbursed ? currentDisbursedAmount : null,
                    disbursementDate: disbursementDate,
                    disbursementComment:
                        disbursementCommentController.text.trim(),
                    evidenceFiles:
                        localDisbursementFilePaths.map((p) => File(p)).toList(),
                    existingFilePaths: currentExistingPaths,
                    existingFileNames: currentExistingNames,
                  );
                  setDialogState(() => isSaving = false);

                  if (success && context.mounted) {
                    // Refresh balances immediately
                    if (prov.currentSettlement != null) {
                      await fetchActiveAdvanceBalance(
                          prov.currentSettlement!['user_id']);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                    showGlobalSnackBar(
                        'Data pengiriman disimpan', AppTheme.success);
                    updateState(() {});
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
          );
        },
      ),
    );
  }
}
