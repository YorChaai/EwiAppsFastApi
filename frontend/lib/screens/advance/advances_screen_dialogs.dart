import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/utils/app_snackbar.dart';
import 'package:expense_app/screens/advance/advances_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/widgets/transaction_cards.dart';

extension AdvancesScreenDialogs on AdvancesScreenState {
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
            backgroundColor: cardColor(context),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Pengembalian Dana Langsung',
                style: TextStyle(color: titleColor(context))),
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
                      dropdownColor: cardColor(context),
                      decoration: InputDecoration(
                        labelText: 'Sumber Bank *',
                        labelStyle: TextStyle(color: primaryText(context)),
                      ),
                      style: TextStyle(color: primaryText(context)),
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
                  Builder(builder: (ctx) {
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
                      dropdownColor: cardColor(context),
                      decoration: InputDecoration(
                        labelText: 'Pilih Kasbon *',
                        labelStyle: TextStyle(color: primaryText(context)),
                      ),
                      style: TextStyle(color: primaryText(context)),
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
                              color: id == null ? AppTheme.primary : primaryText(context),
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
                        labelStyle: TextStyle(color: primaryText(context)),
                      ),
                      style: TextStyle(color: primaryText(context)),
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
                      labelStyle: TextStyle(color: primaryText(context)),
                    ),
                    style: TextStyle(color: primaryText(context)),
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
                            reloadAdvances();
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
    final prov = context.read<AdvanceProvider>();

    // Check outstanding debt before showing dialog
    final outstandingData = await prov.checkUserOutstanding();
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
            'Anda masih memiliki saldo kasbon (outstanding) sebesar $formattedDebt yang belum dipertanggungjawabkan.\n\nApakah Anda ingin mengembalikan dana sekarang atau lanjut membuat pengeluaran baru?',
            style: TextStyle(color: primaryText(context)),
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
              child: const Text('Lanjut Buat Pengeluaran',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (proceed != true) return;
    }
    if (!context.mounted) return;

    final titleCtrl = TextEditingController();
    String selectedType = 'single';
    int selectedYear = prov.reportYear;
    DateTime? selectedDate = DateTime.now();
    bool creating = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: cardColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Buat Kasbon Baru',
            style: TextStyle(color: titleColor(context)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pemilihan Tahun
              DropdownButtonFormField<int>(
                initialValue: selectedYear,
                dropdownColor: cardColor(context),
                decoration: InputDecoration(
                  labelText: 'Tahun Laporan',
                  labelStyle: TextStyle(color: primaryText(context)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryText(context).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                style: TextStyle(color: primaryText(context)),
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
              // Custom Radio Group
              AppRadioGroup<String>(
                groupValue: selectedType,
                onChanged: (v) => setDialogState(() => selectedType = v!),
                child: Row(
                  children: const [
                    Expanded(
                      child: AppRadioItem<String>(
                        value: 'single',
                        label: Text('Single'),
                      ),
                    ),
                    Expanded(
                      child: AppRadioItem<String>(
                        value: 'batch',
                        label: Text('Batch'),
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedType == 'batch') ...[
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Kegiatan',
                  ),
                  style: TextStyle(color: primaryText(context)),
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
                      labelStyle: TextStyle(color: primaryText(context)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryText(context).withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      selectedDate != null
                          ? DateFormat('dd MMM yyyy').format(selectedDate!)
                          : 'Pilih Tanggal',
                      style: TextStyle(color: primaryText(context)),
                    ),
                  ),
                ),
              ],
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
                          ? 'Kasbon Mandiri'
                          : titleCtrl.text.trim();
                      if (selectedType == 'batch') {
                        if (title.isEmpty) return;
                        if (selectedDate == null) {
                          AppSnackbar.show('Tanggal Batch wajib diisi',
                              isError: true);
                          return;
                        }
                      }

                      // Capture Navigator and Provider early
                      final navigator = Navigator.of(context);
                      final aProv = context.read<AdvanceProvider>();

                      setDialogState(() => creating = true);
                      final advance = await aProv.createUnsavedAdvance(
                        title,
                        "",
                        advanceType: selectedType,
                        reportYear: selectedYear,
                        documentDate: selectedDate != null
                            ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                            : null,
                      );

                      if (!ctx.mounted) return;

                      if (advance != null) {
                        Navigator.pop(ctx);
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AdvanceDetailScreen(advanceId: advance['id']),
                          ),
                        );
                      } else {
                        setDialogState(() => creating = false);
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
