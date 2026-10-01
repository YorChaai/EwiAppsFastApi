
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/category_preview_dialog.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/utils/app_formatters.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/dialogs/dialog_add_category.dart';

extension SettlementDetailDialogsExpenseshowEditExpenseDialogExt
    on SettlementDetailScreenState {
  Future<void> showEditExpenseDialog(
    BuildContext context,
    Map<String, dynamic> exp,
  ) async {
    final descCtrl = TextEditingController(text: exp['description'] ?? '');
    final amountCtrl = TextEditingController(
      text: exp['amount'] != null
          ? NumberFormat('#,##0.###', 'id_ID')
              .format((exp['amount'] as num).abs())
          : '0',
    );
    final dateCtrl = TextEditingController(text: exp['date'] ?? '');
    final exchangeRateCtrl = TextEditingController(
      text: exp['currency_exchange'] != null
          ? NumberFormat('#,##0.###', 'id_ID').format(exp['currency_exchange'])
          : '1',
    );
    List<String> selectedFilePaths = (exp['evidence_path'] as String?)
            ?.split('|')
            .where((p) => p.isNotEmpty)
            .toList() ??
        [];
    List<String> selectedFileNames = (exp['evidence_filename'] as String?)
            ?.split('|')
            .where((f) => f.isNotEmpty)
            .toList() ??
        [];
    String? rawSource = exp['source'];
    String? selectedSource =
        (rawSource == null || rawSource == '-' || rawSource.isEmpty)
            ? ''
            : rawSource;
    String selectedCurrency = exp['currency'] ?? 'IDR';
    final rawAmount = (exp['amount'] ?? 0).toDouble();
    bool isNegative = rawAmount < 0;

    double calculateRemainingForSource(String? source) {
      if (source == null || source.isEmpty) return 0.0;

      String targetBankName = '';
      double totalHutang = 0.0;

      // 1. Cek apakah ada advance spesifik yang dipilih (adv_X_Bank)
      if (source.startsWith('adv_')) {
        for (var b in userVirtualBalances) {
          final bankName = b['bank_name']?.toString() ?? '';
          final advs = b['advances'] as List? ?? [];
          for (var a in advs) {
            if (a is Map) {
              final uniqueVal = 'adv_${a['id']}_$bankName';
              if (uniqueVal == source) {
                targetBankName = bankName;
                totalHutang = toDouble(a['amount']);
                break;
              }
            }
          }
          if (totalHutang > 0.01) break;
        }
      }

      // 2. Fallback jika format bank name atau match bank_name
      if (totalHutang <= 0.01) {
        for (var b in userVirtualBalances) {
          final bankName = b['bank_name']?.toString() ?? '';
          if (bankName.isNotEmpty &&
              (bankName.toLowerCase() == source.toLowerCase() ||
               source.toLowerCase().contains(bankName.toLowerCase()))) {
            targetBankName = bankName;
            totalHutang = toDouble(b['balance']);
            break;
          }
        }
      }

      // Fallback jika belum ketemu tapi userVirtualBalances ada item
      if (totalHutang <= 0.01 && userVirtualBalances.isNotEmpty) {
        totalHutang = toDouble(userVirtualBalances.first['balance']);
        targetBankName = userVirtualBalances.first['bank_name']?.toString() ?? '';
      }

      if (totalHutang <= 0.01) return 0.0;

      // 3. Hitung pemakaian pada settlement saat ini (kecuali item expense yang sedang diedit)
      double usedAmount = 0.0;
      final prov = context.read<SettlementProvider>();
      final expenses = prov.currentSettlement?['expenses'] as List? ?? [];
      for (var e in expenses) {
        if (e['id']?.toString() == exp['id']?.toString()) {
          continue;
        }
        final expSource = (e['source'] ?? '').toString();
        if (expSource == source ||
            (targetBankName.isNotEmpty && expSource.toLowerCase().contains(targetBankName.toLowerCase()))) {
          final expAmt = toDouble(e['amount']);
          final expRate = toDouble(e['currency_exchange'] ?? 1);
          usedAmount += (expAmt * expRate);
        }
      }

      double remaining = totalHutang - usedAmount;
      if (remaining < 0) remaining = 0;
      return remaining;
    }

    final prov = context.read<SettlementProvider>();
    // hanya kategori approved yang muncul di dropdown
    // Tampilkan semua kategori agar bisa dipilih staf (pending & approved)
    final allCats = prov.categories;

    // set pilihan awal
    int? selectedParentId;
    Set<int> selectedSubCategoryIds = {};
    final targetId = exp['category_id'] as int?;
    final existingSubIds = exp['subcategory_ids'] as List?;
    if (existingSubIds != null && existingSubIds.isNotEmpty) {
      selectedSubCategoryIds = existingSubIds.map((e) => e as int).toSet();
    }

    if (targetId != null) {
      // cek kategori utama atau child
      for (final p in allCats) {
        if (p['id'] == targetId) {
          selectedParentId = p['id'];
          break;
        }
        final children = (p['children'] as List?) ?? [];
        for (var c in children) {
          if (c['id'] == targetId || selectedSubCategoryIds.contains(c['id'])) {
            selectedParentId = p['id'];
            if (selectedSubCategoryIds.isEmpty) {
              selectedSubCategoryIds.add(c['id']);
            }
            break;
          }
        }
        if (selectedParentId != null) break;
      }
    }

    try {
      await showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) {
            final prov = ctx.read<SettlementProvider>();
            final allCats = prov.categories;

            return AlertDialog(
              backgroundColor: getCardColor(ctx),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Edit Expense',
                style: TextStyle(color: getCreamColor(ctx)),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 10,
                      ), // Ruang ekstra agar label terbaca
                      // dropdown kategori utama
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Kategori Utama',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        isExpanded: true,
                        dropdownColor: getCardColor(ctx),
                        style: TextStyle(color: getPrimaryText(ctx)),
                        initialValue: selectedParentId,
                        items: allCats.map((c) {
                          final isPending = c['status'] == 'pending';
                          return DropdownMenuItem<int>(
                            value: c['id'] as int,
                            child: Text(
                              isPending ? '${c['name']} (Pending)' : c['name'],
                              style: TextStyle(
                                color: isPending ? AppTheme.warning : null,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (v) => setDialogState(() {
                          selectedParentId = v;
                          selectedSubCategoryIds.clear(); // reset sub kategori
                        }),
                      ),
                      const SizedBox(height: 12),

                      // Checklist Sub Kategori
                      if (selectedParentId != null) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Builder(
                            builder: (context) {
                              final parent = allCats.firstWhere(
                                (c) => c['id'] == selectedParentId,
                                orElse: () => {},
                              );
                              final children =
                                  (parent['children'] as List?) ?? [];
                              return Text(
                                children.isNotEmpty
                                    ? 'Pilih Sub Kategori:'
                                    : 'Hanya Kategori Utama',
                                style: TextStyle(
                                  color: getSecondaryText(ctx),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Builder(
                          builder: (context) {
                            final parent = allCats.firstWhere(
                              (c) => c['id'] == selectedParentId,
                              orElse: () => {},
                            );
                            final children =
                                (parent['children'] as List?) ?? [];

                            if (children.isEmpty) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  'Kategori ini tidak memiliki sub-kategori.',
                                  style: TextStyle(
                                    color: getSecondaryText(ctx),
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }

                            return Container(
                              constraints: const BoxConstraints(maxHeight: 200),
                              decoration: BoxDecoration(
                                color: getSurfaceColor(ctx),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: getDividerColor(ctx)),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: children.map((c) {
                                    final subId = c['id'] as int;
                                    final isPending = c['status'] == 'pending';
                                    final isSelected =
                                        selectedSubCategoryIds.contains(subId);

                                    return Material(
                                      type: MaterialType.transparency,
                                      child: CheckboxListTile(
                                        value: isSelected,
                                        activeColor: AppTheme.primary,
                                        dense: true,
                                        title: Text(
                                          isPending
                                              ? '${c['name']} (Pending)'
                                              : c['name'],
                                          style: TextStyle(
                                            color: isSelected
                                                ? AppTheme.primary
                                                : (isPending
                                                    ? AppTheme.warning
                                                    : getPrimaryText(ctx)),
                                            fontSize: 13,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setDialogState(() {
                                            if (val == true) {
                                              selectedSubCategoryIds.add(subId);
                                            } else {
                                              selectedSubCategoryIds.remove(
                                                subId,
                                              );
                                            }
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: TextButton.icon(
                              onPressed: () => showAddCategoryDialog(
                                ctx,
                                setDialogState,
                                (newCat) {
                                  // coba pilih otomatis kalau bisa
                                  final parentID = newCat['parent_id'];
                                  final catID = newCat['id'] as int;
                                  setDialogState(() {
                                    if (parentID != null) {
                                      // ini sub kategori
                                      selectedParentId = parentID;
                                      selectedSubCategoryIds.add(catID);
                                    } else {
                                      // ini kategori utama
                                      selectedParentId = catID;
                                      selectedSubCategoryIds
                                          .clear(); // No sub yet
                                    }
                                  });
                                },
                                parentId: selectedParentId,
                              ),
                              icon: const Icon(
                                Icons.add_circle_outline,
                                size: 16,
                              ),
                              label: Text(
                                selectedParentId != null
                                    ? 'Tambah Sub-Kategori Baru'
                                    : 'Tambah Kategori Baru',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.category_rounded,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                            tooltip: 'Pratinjau Struktur Kategori',
                            onPressed: () => showCategoryPreviewDialog(
                              context,
                              context.read<SettlementProvider>().categories,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Sumber Dana (Kasbon mana yang dipakai)
                      Builder(builder: (ctxBuilder) {
                        final List<Map<String, String>> expenseSourceOptions = [
                          {'value': '', 'label': 'Bukan dari Kasbon (Reimbursement)', 'bank': ''},
                        ];

                        for (var b in userVirtualBalances) {
                          final bankName = b['bank_name']?.toString() ?? '-';
                          final advs = b['advances'] as List? ?? [];
                          if (advs.isNotEmpty) {
                            for (var a in advs) {
                              if (a is Map) {
                                final title = a['title']?.toString() ?? 'Kasbon';
                                final amt = toDouble(a['amount']);
                                if (amt > 0.01) {
                                  final uniqueVal = 'adv_${a['id']}_$bankName';
                                  expenseSourceOptions.add({
                                    'value': uniqueVal,
                                    'label': '• $title ($bankName) - Rp ${currencyFormat.format(amt)}',
                                    'bank': bankName,
                                  });
                                }
                              }
                            }
                          } else {
                            final bal = toDouble(b['balance']);
                            if (bal > 0.01) {
                              expenseSourceOptions.add({
                                'value': bankName,
                                'label': '$bankName (Saldo: Rp ${currencyFormat.format(bal)})',
                                'bank': bankName,
                              });
                            }
                          }
                        }

                        final String currentSourceVal = (() {
                          if (selectedSource == null || selectedSource!.isEmpty) return '';
                          for (var opt in expenseSourceOptions) {
                            if (opt['value'] == selectedSource) return opt['value']!;
                          }
                          final firstToken = selectedSource!.split(',').first.trim();
                          for (var opt in expenseSourceOptions) {
                            final val = opt['value'] ?? '';
                            final bank = opt['bank'] ?? '';
                            final label = opt['label'] ?? '';
                            if (val.isNotEmpty && (firstToken == val || val.contains(firstToken) || firstToken.contains(val))) {
                              return val;
                            }
                            if (bank.isNotEmpty && (firstToken == bank || selectedSource == bank || selectedSource!.contains(bank))) {
                              return val;
                            }
                            if (label.isNotEmpty && firstToken.isNotEmpty && label.contains(firstToken)) {
                              return val;
                            }
                          }
                          if (expenseSourceOptions.length > 1) {
                            return expenseSourceOptions[1]['value'] ?? '';
                          }
                          return '';
                        })();

                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Pilih Sumber Dana (Kasbon)',
                            hintText: 'Pilih bank kasbon...',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          isExpanded: true,
                          dropdownColor: getCardColor(ctx),
                          style: TextStyle(color: getPrimaryText(ctx)),
                          initialValue: currentSourceVal,
                          items: expenseSourceOptions.map((opt) {
                            return DropdownMenuItem<String>(
                              value: opt['value'],
                              child: Text(
                                opt['label']!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (v) => setDialogState(() {
                            selectedSource = v;
                            if (v != null && v.isNotEmpty) {
                              final rem = calculateRemainingForSource(v);
                              if (rem > 0 && (amountCtrl.text.isEmpty || amountCtrl.text == '0')) {
                                amountCtrl.text = AppFormatters.formatCurrencyPlain(rem);
                                selectedCurrency = 'IDR';
                                exchangeRateCtrl.text = '1';
                              }
                            }
                          }),
                        );
                      }),
                      const SizedBox(height: 12),

                      TextField(
                        controller: descCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Deskripsi'),
                        style: TextStyle(color: getPrimaryText(ctx)),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: dateCtrl,
                        decoration: InputDecoration(
                          labelText: 'Tanggal',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today, size: 18),
                            tooltip: 'Pilih Tanggal',
                            onPressed: () async {
                              final d = await showDatePicker(
                                context: ctx,
                                initialDate: DateTime.tryParse(dateCtrl.text) ??
                                    DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (d != null) {
                                dateCtrl.text = DateFormat(
                                  'yyyy-MM-dd',
                                ).format(d);
                              }
                            },
                          ),
                        ),
                        style: TextStyle(color: getPrimaryText(ctx)),
                        readOnly: true,
                      ),
                      const SizedBox(height: 12),
                      // mata uang
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Mata Uang',
                              ),
                              dropdownColor: getCardColor(ctx),
                              style: TextStyle(color: getPrimaryText(ctx)),
                              initialValue: selectedCurrency,
                              items: const [
                                DropdownMenuItem(
                                    value: 'IDR', child: Text('IDR')),
                                DropdownMenuItem(
                                    value: 'USD', child: Text('USD')),
                                DropdownMenuItem(
                                    value: 'EUR', child: Text('EUR')),
                                DropdownMenuItem(
                                    value: 'GBP', child: Text('GBP')),
                                DropdownMenuItem(
                                    value: 'JPY', child: Text('JPY')),
                                DropdownMenuItem(
                                    value: 'CNY', child: Text('CNY')),
                                DropdownMenuItem(
                                    value: 'AUD', child: Text('AUD')),
                                DropdownMenuItem(
                                    value: 'HKD', child: Text('HKD')),
                                DropdownMenuItem(
                                    value: 'SGD', child: Text('SGD')),
                                DropdownMenuItem(
                                    value: 'TWD', child: Text('TWD')),
                                DropdownMenuItem(
                                    value: 'THB', child: Text('THB')),
                                DropdownMenuItem(
                                    value: 'MYR', child: Text('MYR')),
                              ],
                              onChanged: (v) => setDialogState(() {
                                selectedCurrency = v ?? 'IDR';
                                if (selectedCurrency == 'IDR') {
                                  exchangeRateCtrl.text = '1';
                                }
                              }),
                            ),
                          ),
                          if (selectedCurrency != 'IDR') ...[
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: exchangeRateCtrl,
                                decoration: const InputDecoration(
                                  labelText: 'Kurs (ke IDR)',
                                ),
                                style: TextStyle(color: getPrimaryText(ctx)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [CurrencyInputFormatter()],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Material(
                            color: isNegative
                                ? AppTheme.danger.withValues(alpha: 0.15)
                                : AppTheme.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            child: Semantics(
                              button: true,
                              label: 'Ubah Positif Negatif',
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => setDialogState(() {
                                  isNegative = !isNegative;
                                }),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: Text(
                                    isNegative ? '−' : '+',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: isNegative
                                          ? AppTheme.danger
                                          : AppTheme.success,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: amountCtrl,
                              decoration: InputDecoration(
                                labelText: 'Amount ($selectedCurrency)',
                                hintText: '10.000',
                                hintStyle: TextStyle(
                                  color: getSecondaryText(ctx)
                                      .withValues(alpha: 0.5),
                                ),
                                prefixText: isNegative ? '- ' : null,
                                prefixStyle: TextStyle(
                                    color: AppTheme.danger,
                                    fontWeight: FontWeight.bold),
                                suffixIcon: (selectedSource != null &&
                                        selectedSource!.isNotEmpty)
                                    ? TextButton(
                                        onPressed: () {
                                          final remaining = calculateRemainingForSource(selectedSource);
                                          if (remaining > 0) {
                                            setDialogState(() {
                                              amountCtrl.text = AppFormatters.formatCurrencyPlain(remaining);
                                              selectedCurrency = 'IDR';
                                              exchangeRateCtrl.text = '1';
                                            });
                                          }
                                        },
                                        child: const Text('Sesuai Sisa'),
                                      )
                                    : null,
                              ),
                              style: TextStyle(
                                  color: isNegative
                                      ? AppTheme.danger
                                      : getPrimaryText(ctx)),
                              keyboardType: TextInputType.number,
                              inputFormatters: [CurrencyInputFormatter()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            final result = await FilePicker.pickFiles(
                              type: FileType.custom,
                              allowMultiple: true,
                              allowedExtensions: [
                                'jpg',
                                'jpeg',
                                'png',
                                'pdf',
                                'webp',
                              ],
                            );
                            if (result != null && result.files.isNotEmpty) {
                              setDialogState(() {
                                for (var file in result.files) {
                                  if (file.path != null &&
                                      !selectedFilePaths.contains(file.path)) {
                                    selectedFilePaths.add(file.path!);
                                    selectedFileNames.add(file.name);
                                  }
                                }
                              });
                            }
                          } catch (e) {
                            debugPrint('FilePicker Error: $e');
                          }
                        },
                        icon: const Icon(Icons.upload_file_rounded),
                        label: Text(
                          selectedFileNames.isEmpty
                              ? 'Upload Bukti (Bisa multiple)'
                              : 'Tambah Bukti Lainnya',
                        ),
                      ),
                      if (selectedFileNames.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: getSurfaceColor(ctx),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: getDividerColor(ctx)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terpilih (${selectedFileNames.length}):',
                                style: TextStyle(
                                  color: getSecondaryText(ctx),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...List.generate(selectedFileNames.length,
                                  (index) {
                                return Padding(
                                  key: ValueKey(selectedFilePaths[index]),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: AppTheme.success,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          selectedFileNames[index],
                                          style: const TextStyle(
                                            color: AppTheme.success,
                                            fontSize: 11,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setDialogState(() {
                                            selectedFilePaths.removeAt(index);
                                            selectedFileNames.removeAt(index);
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.cancel,
                                            size: 16,
                                            color: AppTheme.danger,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
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
                    // validasi berurutan dari atas ke bawah
                    // 1. validasi kategori utama
                    if (selectedParentId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih Kategori Utama'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }

                    final parent = allCats.firstWhere(
                      (c) => c['id'] == selectedParentId,
                      orElse: () => {},
                    );
                    final children = (parent['children'] as List?) ?? [];

                    // 2. validasi sub kategori (jika parent punya child)
                    if (children.isNotEmpty && selectedSubCategoryIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih Sub Kategori'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }

                    // 3. validasi deskripsi
                    if (descCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Deskripsi harus diisi'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }

                    final amount = toDouble(amountCtrl.text);

                    // 5. validasi nominal minimal 100
                    final rateForValidation = toDouble(exchangeRateCtrl.text);
                    final totalIdrValidation = amount * rateForValidation;

                    if (totalIdrValidation.abs() < 100) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100',
                          ),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }
                    // Apply negative sign if toggled
                    final finalAmount = isNegative ? -amount : amount;

                    // Check if expense is drawn from a Kasbon source and exceeds a single advance
                    if (selectedSource != null && selectedSource!.isNotEmpty && !isNegative) {
                      final matchingBank = userVirtualBalances.firstWhere(
                        (b) {
                          final bName = (b['bank_name'] ?? b['name'] ?? '').toString();
                          if (bName.isEmpty) return false;
                          if (selectedSource == bName || selectedSource!.contains(bName)) return true;
                          final advs = (b['advances'] as List? ?? []);
                          for (var a in advs) {
                            if (a is Map) {
                              final aId = a['id'];
                              final aTitle = a['title']?.toString() ?? '';
                              if (selectedSource!.contains('adv_${aId}_') || (aTitle.isNotEmpty && selectedSource!.contains(aTitle))) {
                                return true;
                              }
                            }
                          }
                          return false;
                        },
                        orElse: () => {},
                      );
                      if (matchingBank.isNotEmpty) {
                        final totalBal = toDouble(matchingBank['balance']);
                        final maxSingle = toDouble(matchingBank['max_single_advance']);
                        final advancesList = (matchingBank['advances'] as List? ?? []);

                        if (maxSingle > 0 && amount > maxSingle && totalBal >= amount) {
                          final confirmMulti = await showDialog<dynamic>(
                            context: ctx,
                            builder: (dialogCtx) {
                              bool foundPrimary = false;
                              int globalOrderCounter = 1;

                              final primaryToken = (selectedSource != null && selectedSource!.isNotEmpty)
                                  ? selectedSource!.split(',').first.trim()
                                  : '';

                              List<Map<String, dynamic>> itemsList = advancesList.map((adv) {
                                final m = adv as Map<String, dynamic>? ?? {};
                                final title = m['title']?.toString() ?? 'Kasbon';
                                final id = m['id'];

                                bool isPrimary = false;
                                if (!foundPrimary && primaryToken.isNotEmpty) {
                                  if (primaryToken.contains('adv_${id}_') ||
                                      primaryToken == title ||
                                      primaryToken.contains(title)) {
                                    isPrimary = true;
                                    foundPrimary = true;
                                  }
                                }

                                return {
                                  'id': id,
                                  'title': title,
                                  'amount': toDouble(m['amount']),
                                  'isPrimary': isPrimary,
                                  'selected': isPrimary, // Primary starts selected, others start unselected or user toggled
                                  'selectionOrder': isPrimary ? 0 : 999,
                                };
                              }).where((m) => (m['amount'] as double) > 0).toList();

                              if (!foundPrimary && itemsList.isNotEmpty) {
                                itemsList.first['isPrimary'] = true;
                                itemsList.first['selected'] = true;
                                itemsList.first['selectionOrder'] = 0;
                              }

                              return StatefulBuilder(
                                builder: (context, setMultiState) {
                                  // Sort active selected items by priority order (Primary #0 first, then user click order)
                                  List<Map<String, dynamic>> activeItems = itemsList.where((i) => i['selected'] == true).toList();
                                  activeItems.sort((a, b) {
                                    if (a['isPrimary'] == true) return -1;
                                    if (b['isPrimary'] == true) return 1;
                                    final int ordA = (a['selectionOrder'] as int? ?? 999);
                                    final int ordB = (b['selectionOrder'] as int? ?? 999);
                                    return ordA.compareTo(ordB);
                                  });

                                  double remaining = amount;
                                  List<Map<String, dynamic>> breakdown = [];
                                  
                                  for (var item in activeItems) {
                                    if (remaining <= 0) break;
                                    final advAmt = item['amount'] as double;
                                    final used = remaining > advAmt ? advAmt : remaining;
                                    final sisa = advAmt - used;
                                    breakdown.add({
                                      'id': item['id'],
                                      'title': item['title'],
                                      'total': advAmt,
                                      'used': used,
                                      'sisa': sisa,
                                    });
                                    remaining -= used;
                                  }

                                  final bool isFullyCovered = remaining <= 0.01;

                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                    backgroundColor: getCardColor(ctx),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    title: Row(
                                      children: [
                                        const Icon(Icons.account_balance_wallet_rounded, color: AppTheme.primary, size: 28),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Pilih Urutan Kasbon Tambahan',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: getCreamColor(ctx)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(ctx).size.width > 700 ? 580 : MediaQuery.of(ctx).size.width * 0.9,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pengajuan Expense: Rp ${currencyFormat.format(amount)}',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Centang kasbon tambahan sesuai urutan prioritas yang diinginkan:',
                                              style: TextStyle(fontSize: 12, color: getPrimaryText(ctx)),
                                            ),
                                            const SizedBox(height: 8),

                                            ...itemsList.map((item) {
                                              final title = item['title'] as String;
                                              final amt = item['amount'] as double;
                                              final isChecked = item['selected'] as bool;
                                              final isPrimary = item['isPrimary'] as bool;

                                              final usedInfo = breakdown.firstWhere(
                                                (b) => b['id'] == item['id'],
                                                orElse: () => {},
                                              );
                                              final used = usedInfo.isNotEmpty ? usedInfo['used'] as double : 0.0;
                                              final sisa = usedInfo.isNotEmpty ? usedInfo['sisa'] as double : amt;
                                              final int rank = isChecked ? (activeItems.indexOf(item) + 1) : 0;

                                              if (isPrimary) {
                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 8),
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme.primary.withValues(alpha: 0.12),
                                                    border: Border.all(color: AppTheme.primary, width: 1.5),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 11,
                                                        backgroundColor: AppTheme.primary,
                                                        child: const Text('#1', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              '$title (Kasbon Utama Form)',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.bold,
                                                                color: getPrimaryText(ctx),
                                                              ),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              'Dipakai: Rp ${currencyFormat.format(used)} → Sisa: Rp ${currencyFormat.format(sisa)}',
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color: sisa == 0 ? AppTheme.success : AppTheme.accent,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                                                    ],
                                                  ),
                                                );
                                              }

                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 8),
                                                child: Material(
                                                  color: isChecked ? AppTheme.primary.withValues(alpha: 0.08) : getCardColor(ctx).withValues(alpha: 0.5),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                      color: isChecked ? AppTheme.primary : Colors.grey.withValues(alpha: 0.3),
                                                      width: isChecked ? 1.5 : 1.0,
                                                    ),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: CheckboxListTile(
                                                    dense: true,
                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                                    value: isChecked,
                                                    secondary: isChecked && rank > 0
                                                        ? CircleAvatar(
                                                            radius: 11,
                                                            backgroundColor: AppTheme.primary,
                                                            child: Text('#$rank', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                                          )
                                                        : null,
                                                    title: Text(
                                                      '$title (Saldo: Rp ${currencyFormat.format(amt)})',
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                                                        color: getPrimaryText(ctx),
                                                      ),
                                                    ),
                                                    subtitle: isChecked && used > 0
                                                        ? Text(
                                                            'Dipakai: Rp ${currencyFormat.format(used)} → Sisa: Rp ${currencyFormat.format(sisa)}',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: sisa == 0 ? AppTheme.success : AppTheme.accent,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          )
                                                        : (isChecked
                                                            ? Text('Saldo sudah cukup (tidak terpakai)', style: TextStyle(fontSize: 11, color: getSecondaryText(ctx)))
                                                            : null),
                                                    onChanged: (val) {
                                                      setMultiState(() {
                                                        item['selected'] = val ?? false;
                                                        if (val == true) {
                                                          globalOrderCounter++;
                                                          item['selectionOrder'] = globalOrderCounter;
                                                        } else {
                                                          item['selectionOrder'] = 999;
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              );
                                            }),

                                          if (!isFullyCovered) ...[
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: AppTheme.danger.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Kekurangan: Rp ${currencyFormat.format(remaining)} akan dicatat sebagai Reimbursement (Uang Pribadi).',
                                                style: const TextStyle(fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(dialogCtx, false),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
                                        onPressed: () {
                                          final orderedStr = activeItems.map((item) => "adv_${item['id']}_${item['title']}").join(', ');
                                          Navigator.pop(dialogCtx, orderedStr);
                                        },
                                        child: const Text('Konfirmasi & Gunakan Kasbon'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );

                          if (confirmMulti == null || confirmMulti == false) {
                            return; // User canceled
                          }
                          if (confirmMulti is String && confirmMulti.isNotEmpty) {
                            selectedSource = confirmMulti;
                          }
                        }
                      }
                    }

                    if (!context.mounted) return;

                    // 4. validasi evidence wajib
                    if (selectedFilePaths.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Evidence (Bukti) wajib diisi'),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                      return;
                    }

                    try {
                      // pakai id sub sebagai ID utama
                      final finalCatId = selectedSubCategoryIds.isNotEmpty
                          ? selectedSubCategoryIds.first
                          : selectedParentId!;
                      final subcatIds = selectedSubCategoryIds.toList();

                      final existingPaths = selectedFilePaths
                          .where((p) => p.startsWith('receipts/'))
                          .toList();
                      final newPaths = selectedFilePaths
                          .where((p) => !p.startsWith('receipts/'))
                          .toList();

                      final existingNames = <String>[];
                      for (var i = 0; i < selectedFilePaths.length; i++) {
                        if (selectedFilePaths[i].startsWith('receipts/')) {
                          if (i < selectedFileNames.length) {
                            existingNames.add(selectedFileNames[i]);
                          } else {
                            existingNames.add(
                              selectedFilePaths[i].split('/').last,
                            );
                          }
                        }
                      }

                      final success = await prov.updateExpense(
                        expenseId: exp['id'],
                        settlementId: widget.settlementId,
                        categoryId: finalCatId,
                        categoryIds: subcatIds,
                        description: descCtrl.text.trim(),
                        amount: finalAmount,
                        date: dateCtrl.text,
                        source: selectedSource,
                        currency: selectedCurrency,
                        currencyExchange: rateForValidation,
                        filePaths: newPaths.isNotEmpty ? newPaths : null,
                        existingFilePaths: existingPaths,
                        existingFileNames: existingNames,
                      );
                      if (success) {
                        if (ctx.mounted) Navigator.pop(ctx);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expense diupdate ✓'),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  prov.error ?? 'Gagal mengupdate expense'),
                              backgroundColor: AppTheme.danger,
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      // error handled by provider
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        ),
      );
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        descCtrl.dispose();
        amountCtrl.dispose();
        dateCtrl.dispose();
        exchangeRateCtrl.dispose();
      });
    }
  }
}
