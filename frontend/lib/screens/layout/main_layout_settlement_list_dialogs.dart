import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/utils/app_snackbar.dart';

import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

extension SettlementListDialogs on SettlementListViewState {
  void showStandaloneReturnDialog(BuildContext context, double outstanding) {
    final aProv = context.read<AdvanceProvider>();
    final auth = context.read<AuthProvider>();
    final userId = auth.user?['id'] ?? 0;

    final amountCtrl = TextEditingController(
        text: AppFormatters.formatCurrencyPlain(outstanding));
    final descCtrl = TextEditingController();

    String? selectedSource;
    int? selectedAdvanceId;
    List<Map<String, dynamic>> userAdvancesList = [];
    bool isSaving = false;
    File? evidence;

    bool isLoadingBanks = true;
    List<Map<String, dynamic>> bankList = [];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          if (isLoadingBanks && bankList.isEmpty) {
            isLoadingBanks = false; // Prevent re-fetching
            Future.wait<dynamic>([
              auth.api.getManagementBanks(),
              auth.api.getUserVirtualBalances(userId),
              auth.api.getActiveAdvanceBalance(userId),
            ]).then((results) {
              final mBanks =
                  (results[0] as Map<String, dynamic>)['banks'] as List? ?? [];
              final virtualBalances = results[1] as List? ?? [];
              final advanceRes = results[2] as Map<String, dynamic>? ?? {};
              final advanceBreakdown = advanceRes['breakdown'] as List? ?? [];

              final Map<String, Map<String, dynamic>> combinedBanks = {};

              // 1. Add all management banks
              for (var b in mBanks) {
                final name = b['name']?.toString() ?? '';
                if (name.isNotEmpty) {
                  combinedBanks[name] = {
                    'name': name,
                    'hutang': 0.0,
                    'advance': 0.0,
                  };
                }
              }

              // 2. Add Hutang (Virtual Balances)
              for (var b in virtualBalances) {
                final name = b['bank_name']?.toString() ?? '';
                final bal =
                    double.tryParse(b['balance']?.toString() ?? '0') ?? 0.0;
                if (name.isNotEmpty) {
                  if (!combinedBanks.containsKey(name)) {
                    combinedBanks[name] = {
                      'name': name,
                      'hutang': 0.0,
                      'advance': 0.0
                    };
                  }
                  combinedBanks[name]!['hutang'] = bal;
                }
              }

              // 3. Add Advance (Sisa Kasbon)
              for (var b in advanceBreakdown) {
                final name = b['bank_name']?.toString() ?? '';
                final bal = (b['balance'] is num)
                    ? (b['balance'] as num).toDouble()
                    : (double.tryParse(b['balance']?.toString() ?? '0') ?? 0.0);
                if (name.isNotEmpty) {
                  if (!combinedBanks.containsKey(name)) {
                    combinedBanks[name] = {
                      'name': name,
                      'hutang': 0.0,
                      'advance': 0.0
                    };
                  }
                  combinedBanks[name]!['advance'] = bal;
                }
              }

              final sortedBanks = combinedBanks.values.toList();
              // Sort alphabetically
              sortedBanks.sort((a, b) =>
                  (a['name'] as String).compareTo(b['name'] as String));

              final List<Map<String, dynamic>> extractedAdvances = [
                {'id': null, 'title': 'Semua Kasbon / Total Hutang', 'amount': outstanding}
              ];

              for (var b in virtualBalances) {
                if (b is Map) {
                  final advs = b['advances'] as List? ?? [];
                  for (var a in advs) {
                    if (a is Map) {
                      final amt = double.tryParse((a['amount'] ?? 0).toString()) ?? 0.0;
                      if (amt > 0.01) {
                        extractedAdvances.add({
                          'id': a['id'],
                          'title': (a['title'] ?? 'Kasbon').toString(),
                          'amount': amt,
                          'bank_name': (b['bank_name'] ?? '').toString(),
                        });
                      }
                    }
                  }
                }
              }

              if (ctx.mounted) {
                setDialogState(() {
                  bankList = sortedBanks;
                  userAdvancesList = extractedAdvances;
                  if (bankList.isNotEmpty) {
                    selectedSource = bankList.first['name'] as String;
                  }
                });
              }
            });
          }

          return AlertDialog(
            backgroundColor: cardColor(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Pengembalian Dana Langsung',
                style: TextStyle(color: titleColorLocal(ctx))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Sumber Bank (Field Pertama)
                  if (bankList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedSource,
                      dropdownColor: cardColor(ctx),
                      decoration: InputDecoration(
                        labelText: 'Sumber Bank *',
                        labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                      ),
                      style: TextStyle(color: primaryTextLocal(ctx)),
                      items: bankList.map((b) {
                        final name = b['name'] as String;
                        final hutang = b['hutang'] as double;
                        final advance = b['advance'] as double;

                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hutang > 0)
                                Text(
                                  AppFormatters.formatCurrency(hutang),
                                  style: const TextStyle(
                                    color: AppTheme.danger,
                                    fontSize: 13,
                                  ),
                                )
                              else if (advance > 0)
                                Text(
                                  AppFormatters.formatCurrency(advance),
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setDialogState(() {
                          selectedSource = v;
                          selectedAdvanceId = null; // Reset selection to "Semua Kasbon"
                        });
                      },
                    ),
                  const SizedBox(height: 16),

                  // 2. Pilih Kasbon (Field Kedua, difilter berdasarkan Sumber Bank)
                  Builder(builder: (ctxBuilder) {
                    final filteredAdvances = userAdvancesList.where((a) {
                      if (a['id'] == null) return false;
                      if (selectedSource == null || selectedSource!.isEmpty) return true;
                      final bName = (a['bank_name'] ?? '').toString().toLowerCase();
                      return bName.isEmpty || bName == selectedSource!.toLowerCase();
                    }).toList();

                    final selectedBankObj = bankList.firstWhere(
                      (b) => b['name'] == selectedSource,
                      orElse: () => {},
                    );
                    final bankHutangAmount = (selectedBankObj['hutang'] as double?) ?? 0.0;
                    final totalSemuaKasbonAmt = (selectedSource != null && selectedSource!.isNotEmpty)
                        ? bankHutangAmount
                        : outstanding;

                    final List<Map<String, dynamic>> kasbonOptions = [
                      {
                        'id': null,
                        'title': 'Semua Kasbon',
                        'amount': totalSemuaKasbonAmt,
                      },
                      ...filteredAdvances,
                    ];

                    return DropdownButtonFormField<int?>(
                      isExpanded: true,
                      initialValue: selectedAdvanceId,
                      dropdownColor: cardColor(ctx),
                      decoration: InputDecoration(
                        labelText: 'Pilih Kasbon *',
                        labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                      ),
                      style: TextStyle(color: primaryTextLocal(ctx)),
                      items: kasbonOptions.map((item) {
                        final id = item['id'] as int?;
                        final title = item['title'] as String;
                        final amt = item['amount'] as double;
                        final labelText = id == null
                            ? 'Semua Kasbon (${AppFormatters.formatCurrency(amt)})'
                            : '• $title - ${AppFormatters.formatCurrency(amt)}';

                        return DropdownMenuItem<int?>(
                          value: id,
                          child: Text(
                            labelText,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: id == null ? FontWeight.bold : FontWeight.normal,
                              color: id == null ? AppTheme.primary : primaryTextLocal(ctx),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setDialogState(() {
                          selectedAdvanceId = newVal;
                          if (newVal != null) {
                            final target = kasbonOptions.firstWhere(
                              (a) => a['id'] == newVal,
                              orElse: () => kasbonOptions.first,
                            );
                            amountCtrl.text = AppFormatters.formatCurrencyPlain(target['amount'] as double);
                          }
                        });
                      },
                    );
                  }),

                  // 3. Nominal Pengembalian (Field Ketiga - HIDE jika "Semua Kasbon" dipilih)
                  if (selectedAdvanceId != null) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
                      decoration: InputDecoration(
                        labelText: 'Nominal Pengembalian *',
                        labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                      ),
                      style: TextStyle(color: primaryTextLocal(ctx)),
                    ),
                  ],

                  // 4. Keterangan (Field Keempat)
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
                      hintText: 'Pengembalian Dana Mandiri (Standalone)',
                      hintStyle: const TextStyle(color: Colors.grey),
                      labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                    ),
                    style: TextStyle(color: primaryTextLocal(ctx)),
                    maxLines: 2,
                  ),

                  // 5. Upload Bukti Transfer (Field Kelima)
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await FilePicker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                        allowMultiple: false,
                      );
                      if (result != null && result.files.single.path != null) {
                        setDialogState(
                            () => evidence = File(result.files.single.path!));
                      }
                    },
                    icon: const Icon(Icons.upload_file_rounded),
                    label: Text(evidence == null
                        ? 'Upload Bukti Transfer *'
                        : 'Terpilih: ${evidence!.path.split(RegExp(r"[\\/]")).last}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          evidence == null ? AppTheme.primary : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        if (selectedSource == null || selectedSource!.trim().isEmpty) {
                          AppSnackbar.show('Silakan pilih Sumber Bank terlebih dahulu',
                              isError: true);
                          return;
                        }

                        double finalAmount = 0.0;
                        if (selectedAdvanceId != null) {
                          final amountRaw =
                              amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
                          finalAmount = double.tryParse(amountRaw) ?? 0;
                          if (finalAmount <= 0) {
                            AppSnackbar.show('Nominal pengembalian wajib diisi',
                                isError: true);
                            return;
                          }
                        } else {
                          // "Semua Kasbon" chosen -> use total hutang for selected bank
                          final bItem = bankList.firstWhere(
                            (b) => b['name'] == selectedSource,
                            orElse: () => {},
                          );
                          final bHutang = (bItem['hutang'] as double?) ?? 0.0;
                          finalAmount = bHutang > 0 ? bHutang : outstanding;
                          if (finalAmount <= 0) {
                            AppSnackbar.show(
                                'Tidak ada hutang/kasbon berjalan pada bank ini',
                                isError: true);
                            return;
                          }
                        }

                        if (evidence == null) {
                          AppSnackbar.show('Bukti transfer wajib diunggah',
                              isError: true);
                          return;
                        }

                        setDialogState(() => isSaving = true);
                        final success = await aProv.submitStandaloneReturn(
                          amount: finalAmount,
                          source: selectedSource ?? '',
                          description: descCtrl.text.trim().isEmpty
                              ? 'Pengembalian Dana Mandiri (Standalone)'
                              : descCtrl.text.trim(),
                          reportYear: DateTime.now().year,
                          evidence: evidence,
                          advanceId: selectedAdvanceId,
                        );

                        if (ctx.mounted) {
                          setDialogState(() => isSaving = false);
                          if (success) {
                            Navigator.pop(ctx);
                            AppSnackbar.show(
                                'Pengembalian dana berhasil dicatat');
                            await auth.retryInitialization();
                            await aProv.loadAdvances();
                            reloadSettlements();
                            GlobalEventBus.triggerRefresh();
                          } else {
                            AppSnackbar.show(
                                aProv.error ?? 'Gagal mencatat pengembalian',
                                isError: true);
                          }
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void showCreateDialog(BuildContext context) async {
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();

    // Check outstanding debt before showing dialog
    final outstandingData = await aProv.checkUserOutstanding();
    final double outstanding =
        (outstandingData['outstanding'] ?? 0.0).toDouble();

    if (!context.mounted) return;

    if (outstanding > 0.01) {
      final String formattedDebt = AppFormatters.formatCurrency(outstanding);
      final bool? proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: cardColor(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Perhatian: Outstanding Kasbon',
              style: TextStyle(color: AppTheme.danger)),
          content: Text(
            'Anda masih memiliki saldo kasbon (outstanding) sebesar $formattedDebt.\n\nJika Anda ingin membuat Settlement untuk Kasbon tersebut, mohon buka menu Kasbon, pilih Kasbon Anda, dan klik tombol "Buat Settlement".\n\nKlik "Buat Reimbursement" jika Anda ingin membuat settlement dana pribadi (Standalone).',
            style: TextStyle(color: primaryTextLocal(context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
                showStandaloneReturnDialog(context, outstanding);
              },
              child: const Text('Kembalikan Dana Sekarang',
                  style: TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              child: const Text('Buat Reimbursement',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (proceed != true) return;
    }

    final titleCtrl = TextEditingController();
    String selectedType = 'single';
    int selectedYear = sProv.reportYear;
    if (selectedYear < 2020 || selectedYear > 2040) {
      selectedYear = DateTime.now().year;
      if (selectedYear < 2020) selectedYear = 2020;
      if (selectedYear > 2040) selectedYear = 2040;
    }
    DateTime? selectedDate = DateTime.now();
    bool creating = false;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: cardColor(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Buat Settlement Baru',
            style: TextStyle(color: titleColorLocal(ctx)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pemilihan Tahun
              DropdownButtonFormField<int>(
                initialValue: selectedYear,
                dropdownColor: cardColor(ctx),
                decoration: InputDecoration(
                  labelText: 'Tahun Laporan',
                  labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryTextLocal(ctx).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                style: TextStyle(color: primaryTextLocal(ctx)),
                items: List.generate(21, (index) => 2020 + index)
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedYear = v!),
              ),
              const SizedBox(height: 16),
              // Pilihan Single / Batch
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Single',
                          style: TextStyle(
                              fontSize: 13, color: primaryTextLocal(ctx))),
                      value: 'single',
                      // ignore: deprecated_member_use
                      groupValue: selectedType,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setDialogState(() => selectedType = v!),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Batch',
                          style: TextStyle(
                              fontSize: 13, color: primaryTextLocal(ctx))),
                      value: 'batch',
                      // ignore: deprecated_member_use
                      groupValue: selectedType,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setDialogState(() => selectedType = v!),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedType == 'batch') ...[
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengeluaran / Reimbursement',
                  ),
                  style: TextStyle(color: primaryTextLocal(ctx)),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Batch (Mandatory)',
                      labelStyle: TextStyle(color: primaryTextLocal(ctx)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryTextLocal(ctx).withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : AppFormatters.formatDateForApi(selectedDate!),
                      style: TextStyle(color: primaryTextLocal(ctx)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: creating
                  ? null
                  : () async {
                      final title = selectedType == 'single'
                          ? 'Settlement Mandiri'
                          : titleCtrl.text.trim();

                      if (selectedType == 'batch') {
                        if (title.isEmpty) {
                          AppSnackbar.show('Judul Pengeluaran wajib diisi',
                              isError: true);
                          return;
                        }
                        if (selectedDate == null) {
                          AppSnackbar.show('Tanggal Batch wajib diisi',
                              isError: true);
                          return;
                        }
                      }

                      // Capture Navigator and SettlementProvider early
                      final navigator = Navigator.of(context);
                      final sProv = context.read<SettlementProvider>();

                      setDialogState(() => creating = true);
                      final result = await sProv.createSettlement(
                        title,
                        "",
                        settlementType: selectedType,
                        reportYear: selectedYear,
                        documentDate: selectedDate != null
                            ? AppFormatters.formatDateForApi(selectedDate!)
                            : null,
                      );

                      if (!ctx.mounted) return;

                      if (result != null) {
                        // Tutup dialog
                        Navigator.pop(ctx);

                        // Berpindah ke detail screen (gunakan navigator yang sudah dicapture)
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => SettlementDetailScreen(
                              settlementId: result['id'],
                            ),
                          ),
                        );
                      } else {
                        setDialogState(() => creating = false);
                        AppSnackbar.show(
                          sProv.error ?? 'Gagal membuat settlement',
                          isError: true,
                        );
                      }
                    },
              child: creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Buat'),
            ),
          ],
        ),
      ),
    );
  }
}
