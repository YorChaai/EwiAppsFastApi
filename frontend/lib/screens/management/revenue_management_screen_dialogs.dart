import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/services/bank_order_preferences.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/revenue_management_screen.dart';
import 'package:expense_app/screens/management/revenue_management_screen_actions.dart';


extension RevenueManagementDialogsExt on RevenueManagementScreenState {
  String formatNumericInput(dynamic value) {
    final number =
        value is num ? value.toDouble() : toDouble((value ?? '').toString());
    if (number == null || number == 0) return '';
    return numberFmt.format(number);
  }

  Future<void> showRevenueDialog([Map<String, dynamic>? data]) async {
    final bankProv = context.read<BankManagementProvider>();
    if (bankProv.banks.isEmpty) {
      await bankProv.loadBanks();
    }
    final customOrder = await BankOrderPreferences.getBankCashOrder();
    final sortedBanks = List<dynamic>.from(bankProv.banks);
    BankOrderPreferences.sortBankMaps(sortedBanks, customOrderIds: customOrder);
    int? selectedBankId = data?['bank_id'] != null
        ? int.tryParse(data!['bank_id'].toString())
        : null;

    final formKey = GlobalKey<FormState>();
    final now = DateTime.now();
    final defaultDate = selectedYear == 0 || selectedYear == now.year
        ? now
        : DateTime(selectedYear, 12, 31);
    final invoiceDate = TextEditingController(
      text: data?['invoice_date']?.toString().substring(0, 10) ??
          dateFmt.format(defaultDate),
    );
    final description = TextEditingController(text: data?['description'] ?? '');
    final invoiceValueUsd = TextEditingController(
      text: formatNumericInput(data?['invoice_value_usd']),
    );
    final invoiceValueIdr = TextEditingController(
      text: formatNumericInput(data?['invoice_value_idr']),
    );
    final currency = TextEditingController(text: data?['currency'] ?? 'IDR');
    final currencyExchange = TextEditingController(
      text: data?['currency_exchange']?.toString() ?? '',
    );
    final invoiceNumber = TextEditingController(
      text: data?['invoice_number'] ?? '',
    );
    final client = TextEditingController(text: data?['client'] ?? '');
    final receiveDate = TextEditingController(
      text: data?['receive_date']?.toString().substring(0, 10) ?? '',
    );
    final amountReceivedIdr = TextEditingController(
      text: formatNumericInput(data?['amount_received_idr']),
    );
    final amountReceivedUsd = TextEditingController(
      text: formatNumericInput(data?['amount_received_usd']),
    );
    final ppn = TextEditingController(text: formatNumericInput(data?['ppn']));
    final pph23 = TextEditingController(
      text: formatNumericInput(data?['pph_23']),
    );
    final transferFee = TextEditingController(
      text: formatNumericInput(data?['transfer_fee']),
    );
    final remark = TextEditingController(text: data?['remark'] ?? '');
    String revenueType = data?['revenue_type'] ?? 'pendapatan_langsung';
    int reportYear =
        data?['report_year'] ?? (selectedYear == 0 ? now.year : selectedYear);

    String inputCurrency = 'IDR';
    if (data != null) {
      final invUsd = data['invoice_value_usd'];
      final recvUsd = data['amount_received_usd'];
      final curr = (data['currency'] ?? '').toString().toUpperCase();
      if (curr == 'USD' ||
          (invUsd != null && invUsd != 0) ||
          (recvUsd != null && recvUsd != 0)) {
        inputCurrency = 'USD';
      }
    }

    void recalcDualCurrency() {
      final rate = toDouble(currencyExchange.text) ?? 1.0;
      if (inputCurrency == 'USD') {
        if (currency.text.trim().isEmpty || currency.text == 'IDR') {
          currency.text = 'USD';
        }
        final invUsd = toDouble(invoiceValueUsd.text) ?? 0.0;
        if (invUsd > 0) {
          final computedIdr = invUsd * (rate > 0 ? rate : 1.0);
          invoiceValueIdr.text = formatNumericInput(computedIdr);
          ppn.text = formatNumericInput(computedIdr * 0.11);
          pph23.text = formatNumericInput(computedIdr * 0.02);
        } else {
          invoiceValueIdr.clear();
          ppn.clear();
          pph23.clear();
        }

        final recvUsd = toDouble(amountReceivedUsd.text) ?? 0.0;
        if (recvUsd > 0) {
          final computedRecvIdr = recvUsd * (rate > 0 ? rate : 1.0);
          amountReceivedIdr.text = formatNumericInput(computedRecvIdr);
        } else if (amountReceivedUsd.text.isEmpty) {
          amountReceivedIdr.clear();
        }
      } else {
        if (currency.text.trim().isEmpty || currency.text == 'USD') {
          currency.text = 'IDR';
        }
        final invIdr = toDouble(invoiceValueIdr.text) ?? 0.0;
        if (invIdr > 0) {
          ppn.text = formatNumericInput(invIdr * 0.11);
          pph23.text = formatNumericInput(invIdr * 0.02);
        } else {
          ppn.clear();
          pph23.clear();
        }
      }
    }

    Future<void> pickDate(TextEditingController ctrl) async {
      final init =
          DateTime.tryParse(ctrl.text) ?? DateTime(selectedYear, 1, 1);
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2035),
        initialDate: init,
      );
      if (picked != null) {
        ctrl.text = dateFmt.format(picked);
      }
    }

    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          data == null ? 'Tambah Revenue' : 'Edit Revenue',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: StatefulBuilder(
            builder: (ctx, setDialogState) {
              final rate = toDouble(currencyExchange.text);
              final isUsd = inputCurrency == 'USD' ||
                  currency.text.trim().toUpperCase() == 'USD';
              final isSuspiciousKurs = isUsd && (rate == null || rate <= 1.0);

              return SizedBox(
                width: 760,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        dropdownField(
                          reportYear,
                          'Tahun Laporan',
                          List.generate(21, (i) => 2020 + i)
                              .map((y) => {'label': 'Laporan $y', 'value': y})
                              .toList(),
                          (v) => setDialogState(() => reportYear = v as int),
                          width: 720,
                        ),
                        dateField(invoiceDate, 'Invoice Date', pickDate),
                        textField(
                          description,
                          'Detail/Description',
                          width: 720,
                          required: true,
                        ),
                        dropdownField(
                          inputCurrency,
                          'Input Mata Uang',
                          [
                            {'label': 'Input (IDR)', 'value': 'IDR'},
                            {'label': 'Input (USD)', 'value': 'USD'},
                          ],
                          (v) => setDialogState(() {
                            inputCurrency = v as String;
                            if (inputCurrency == 'IDR') {
                              currency.text = 'IDR';
                              if (currencyExchange.text.isEmpty ||
                                  currencyExchange.text == '0') {
                                currencyExchange.text = '1';
                              }
                              invoiceValueUsd.clear();
                              amountReceivedUsd.clear();
                            } else {
                              currency.text = 'USD';
                              if (currencyExchange.text == '1' ||
                                  currencyExchange.text.isEmpty) {
                                // Default kurs kosong agar user sadar perlu mengisi kurs
                                currencyExchange.clear();
                              }
                            }
                            recalcDualCurrency();
                          }),
                        ),
                        if (isSuspiciousKurs)
                          Container(
                            width: 720,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: Colors.amber.shade700, width: 1),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.warning_amber_rounded,
                                    color: Colors.amber.shade700, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Perhatian Kurs USD:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isDark(ctx)
                                              ? Colors.amber.shade300
                                              : Colors.amber.shade900,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Mata uang USD dipilih tetapi Nilai Tukar (Kurs) masih ${rate == 1 ? "1" : "kosong"}. Nilai Rupiah (IDR) akan terhitung sama persis dengan nominal Dollar (contoh: \$4.650 = Rp 4.650). Silakan masukkan kurs konversi yang sesuai (contoh: 16000).',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark(ctx)
                                              ? Colors.amber.shade200
                                              : Colors.amber.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (inputCurrency == 'IDR')
                          numberField(
                            invoiceValueIdr,
                            'Invoice Value (IDR)',
                            onChanged: (v) {
                              setDialogState(() => recalcDualCurrency());
                            },
                          ),
                        if (inputCurrency == 'USD') ...[
                          numberField(
                            invoiceValueUsd,
                            'Invoice Value (USD)',
                            onChanged: (v) {
                              setDialogState(() => recalcDualCurrency());
                            },
                          ),
                          numberField(
                            invoiceValueIdr,
                            'Invoice Value (IDR) [Konversi Otomatis]',
                            readOnly: true,
                          ),
                        ],
                        textField(currency, 'Currency'),
                        numberField(
                          currencyExchange,
                          'Currency Exchange (Kurs ke Rupiah)',
                          onChanged: (v) {
                            setDialogState(() => recalcDualCurrency());
                          },
                        ),
                        textField(invoiceNumber, 'Invoice Number'),
                        textField(client, 'Client'),
                        dateField(
                          receiveDate,
                          'Receive Date',
                          pickDate,
                          allowEmpty: true,
                        ),
                        if (inputCurrency == 'USD') ...[
                          numberField(
                            amountReceivedUsd,
                            'Amount Received (USD)',
                            onChanged: (v) {
                              setDialogState(() => recalcDualCurrency());
                            },
                          ),
                          numberField(
                            amountReceivedIdr,
                            'Amount Received (IDR) [Konversi Otomatis]',
                            onChanged: (v) => setDialogState(() {}),
                          ),
                        ],
                        if (inputCurrency == 'IDR')
                          numberField(
                            amountReceivedIdr,
                            'Amount Received (IDR)',
                            onChanged: (v) => setDialogState(() {}),
                          ),
                        numberField(ppn, 'PPn', readOnly: true),
                        numberField(pph23, 'PPh (Pasal 23)', readOnly: true),
                        numberField(transferFee, 'Biaya transfer'),
                        dropdownField(
                          revenueType,
                          'Revenue',
                          [
                            {
                              'label': 'PENDAPATAN LANGSUNG',
                              'value': 'pendapatan_langsung'
                            },
                            {
                              'label': 'PENDAPATAN LAIN LAIN',
                              'value': 'pendapatan_lain_lain'
                            },
                          ],
                          (v) => setDialogState(
                              () => revenueType = v ?? 'pendapatan_langsung'),
                          width: 720,
                        ),
                        dropdownField<int?>(
                          selectedBankId,
                          'Sumber Dana (Bank Cash)',
                          [
                            {
                              'label': '- (Belum Ada Sumber Dana / Teralokasi)',
                              'value': null,
                            },
                            ...sortedBanks.map((b) {
                              final bName = (b['name'] ?? b['bank_name'] ?? '').toString();
                              final bAcc = (b['account_number'] ?? '').toString();
                              final label = bAcc.isNotEmpty
                                  ? '$bName ($bAcc)'
                                  : (bName.isNotEmpty ? bName : 'Bank #${b['id']}');
                              return {
                                'label': label,
                                'value': b['id'] is int
                                    ? b['id'] as int
                                    : int.tryParse(b['id'].toString()),
                              };
                            }),
                          ],
                          (v) => setDialogState(() => selectedBankId = v),
                          width: 720,
                        ),
                        textField(remark, 'Remark',
                            width: 720, hintText: 'Con : Pemungut'),
                      ],
                    ),
                  ),
                ),
              );
            }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              final rate = toDouble(currencyExchange.text);
              final isUsd = inputCurrency == 'USD' ||
                  currency.text.trim().toUpperCase() == 'USD';
              final isSuspiciousKurs = isUsd && (rate == null || rate <= 1.0);

              if (isSuspiciousKurs) {
                final proceed = await showDialog<bool>(
                  context: ctx,
                  builder: (c) => AlertDialog(
                    backgroundColor: cardColor(c),
                    title: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        Text('Konfirmasi Kurs USD',
                            style: TextStyle(color: creamColor(c))),
                      ],
                    ),
                    content: Text(
                      'Mata uang transaksi adalah USD tetapi Nilai Tukar (Kurs) diisi "${currencyExchange.text.trim()}".\n\n'
                      'Hal ini akan menyebabkan nominal Rupiah di Laporan dan mutasi Bank Cash sama persis dengan angka Dollar (contoh: \$4.650 = Rp 4.650).\n\n'
                      'Apakah Anda yakin ingin tetap melanjutkan?',
                      style: TextStyle(color: textColor(c)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Periksa Kembali'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade800,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(c, true),
                        child: const Text('Tetap Simpan'),
                      ),
                    ],
                  ),
                );
                if (proceed != true) return;
              }

              final payload = <String, dynamic>{
                'invoice_date': invoiceDate.text.trim(),
                'description': description.text.trim(),
                'invoice_value': toDouble(invoiceValueIdr.text) ??
                    toDouble(invoiceValueUsd.text), // Map IDR or USD to Master
                'invoice_value_usd': toDouble(invoiceValueUsd.text),
                'invoice_value_idr': toDouble(invoiceValueIdr.text),
                'currency':
                    currency.text.trim().isEmpty ? 'IDR' : currency.text.trim(),
                'currency_exchange': toDouble(currencyExchange.text),
                'invoice_number': invoiceNumber.text.trim(),
                'client': client.text.trim(),
                'receive_date': receiveDate.text.trim().isEmpty
                    ? null
                    : receiveDate.text.trim(),
                'amount_received': toDouble(amountReceivedIdr.text) ??
                    toDouble(amountReceivedUsd.text),
                'amount_received_idr': toDouble(amountReceivedIdr.text),
                'amount_received_usd': toDouble(amountReceivedUsd.text),
                'ppn': toDouble(ppn.text),
                'pph_23': toDouble(pph23.text),
                'transfer_fee': toDouble(transferFee.text),
                'remark': remark.text.trim(),
                'revenue_type': revenueType,
                'report_year': reportYear,
                'bank_id': selectedBankId,
              };
              try {
                await saveRevenue(payload: payload, id: data?['id'] as int?);
                if (!mounted) return;
                // Reload bank management so cash balances update reactively
                context.read<BankManagementProvider>().loadBanks();
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      data == null ? 'Revenue ditambahkan' : 'Revenue diupdate',
                    ),
                    backgroundColor: AppTheme.success,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal simpan: $e'),
                    backgroundColor: AppTheme.danger,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<bool?> showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }
}
