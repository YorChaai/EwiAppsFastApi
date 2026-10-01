import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/tax_management_screen.dart';
import 'package:expense_app/screens/management/tax_management_screen_actions.dart';


extension TaxManagementDialogsExt on TaxManagementScreenState {
  /// Format numeric value to Indonesian format: 1500000.50 → "1.500.000,50"
  String formatNumericInput(dynamic value) {
    if (value == null) return '';
    final num = value is double ? value : double.tryParse('$value');
    if (num == null) return '$value';

    // Pisahkan integer dan desimal
    final integerPart = num.truncate().abs();
    final decimalPart = num - num.truncate();

    // Format integer dengan pemisah ribuan
    final formattedInteger = integerPart.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        );

    // Tambahkan tanda minus jika negatif
    final sign = num < 0 ? '-' : '';

    if (decimalPart > 0) {
      final decimalStr = decimalPart.toStringAsFixed(2).substring(1);
      return '$sign$formattedInteger,$decimalStr';
    }

    return '$sign$formattedInteger';
  }

  Future<void> showTaxDialog([Map<String, dynamic>? data]) async {
    final formKey = GlobalKey<FormState>();
    final now = DateTime.now();
    final defaultDate = selectedYear == 0 || selectedYear == now.year
        ? now
        : DateTime(selectedYear, 12, 31);
    final date = TextEditingController(
      text: data?['date']?.toString().substring(0, 10) ??
          dateFmt.format(defaultDate),
    );
    final description = TextEditingController(text: data?['description'] ?? '');
    final transactionValue = TextEditingController(
      text: formatNumericInput(data?['transaction_value']),
    );
    final invoiceValueUsd = TextEditingController(
      text: formatNumericInput(data?['invoice_value_usd']),
    );
    final currency = TextEditingController(text: data?['currency'] ?? 'IDR');
    final currencyExchange = TextEditingController(
      text: formatNumericInput(data?['currency_exchange']),
    );
    final ppn = TextEditingController(text: formatNumericInput(data?['ppn']));
    final ppnBase =
        TextEditingController(text: formatNumericInput(data?['ppn_base']));
    final pph21 = TextEditingController(
      text: formatNumericInput(data?['pph_21'] ?? data?['pph_2_1']),
    );
    final pph21Base =
        TextEditingController(text: formatNumericInput(data?['pph_21_base']));
    final pph23 = TextEditingController(
      text: formatNumericInput(data?['pph_23']),
    );
    final pph23Base =
        TextEditingController(text: formatNumericInput(data?['pph_23_base']));
    final pph26 = TextEditingController(
      text: formatNumericInput(data?['pph_26']),
    );
    final pph26Base =
        TextEditingController(text: formatNumericInput(data?['pph_26_base']));
    final pemasukanNegara = TextEditingController(
      text: formatNumericInput(data?['pemasukan_negara']),
    );
    final pemasukanNegaraBase = TextEditingController(
      text: formatNumericInput(data?['pemasukan_negara_base']),
    );
    int reportYear =
        data?['report_year'] ?? (selectedYear == 0 ? now.year : selectedYear);

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

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          data == null ? 'Tambah Pajak' : 'Edit Pajak',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: SizedBox(
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
                    (v) => updateState(() => reportYear = v as int),
                    width: 720,
                  ),
                  dateField(date, 'Date', pickDate),
                  textField(
                    description,
                    'Detail/Description',
                    width: 720,
                    required: true,
                  ),
                  numberField(invoiceValueUsd, 'Inv Value USD'),
                  numberField(
                    transactionValue,
                    'Transaction Value',
                    required: true,
                    onChanged: (v) {
                      // Auto-fill bases if they are empty
                      if (ppnBase.text.isEmpty) ppnBase.text = v;
                      if (pph21Base.text.isEmpty) pph21Base.text = v;
                      if (pph23Base.text.isEmpty) pph23Base.text = v;
                      if (pph26Base.text.isEmpty) pph26Base.text = v;
                      if (pemasukanNegaraBase.text.isEmpty) {
                        pemasukanNegaraBase.text = v;
                      }
                    },
                  ),
                  textField(currency, 'Currency'),
                  numberField(currencyExchange, 'Rate'),

                  // Read-only Live IDR calculation
                  StatefulBuilder(builder: (ctx, setDialogState) {
                    transactionValue.addListener(() => setDialogState(() {}));
                    currencyExchange.addListener(() => setDialogState(() {}));

                    final val = toDouble(transactionValue.text) ?? 0;
                    final rate = toDouble(currencyExchange.text) ?? 1;
                    final idr = val * rate;

                    return Container(
                      width: 230,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: surfaceColor(ctx).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: secondaryTextColor(ctx)
                                .withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaction Value(child=IDR)',
                            style: TextStyle(
                              color: secondaryTextColor(ctx),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            fmtMoney(idr),
                            style: TextStyle(
                              color: textColor(ctx),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  numberField(ppnBase, 'PPN Base'),
                  numberField(ppn, 'PPN'),
                  numberField(pph21Base, 'PPh 21 Base'),
                  numberField(pph21, 'PPh 21'),
                  numberField(pph23Base, 'PPh 23 Base'),
                  numberField(pph23, 'PPh 23'),
                  numberField(pph26Base, 'PPh 26 Base'),
                  numberField(pph26, 'PPh 26'),
                  numberField(pemasukanNegaraBase, 'Pemasukan Negara Base'),
                  numberField(pemasukanNegara, 'Pajak (Pemasukan Negara)'),
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
              if (!formKey.currentState!.validate()) return;
              final payload = <String, dynamic>{
                'date': date.text.trim(),
                'description': description.text.trim(),
                'transaction_value': toDouble(transactionValue.text),
                'invoice_value_usd': toDouble(invoiceValueUsd.text),
                'transaction_value_idr':
                    (toDouble(transactionValue.text) ?? 0) *
                        (toDouble(currencyExchange.text) ?? 1),
                'currency':
                    currency.text.trim().isEmpty ? 'IDR' : currency.text.trim(),
                'currency_exchange': toDouble(currencyExchange.text),
                'ppn': toDouble(ppn.text),
                'ppn_base': toDouble(ppnBase.text),
                'pph_21': toDouble(pph21.text),
                'pph_21_base': toDouble(pph21Base.text),
                'pph_23': toDouble(pph23.text),
                'pph_23_base': toDouble(pph23Base.text),
                'pph_26': toDouble(pph26.text),
                'pph_26_base': toDouble(pph26Base.text),
                'pemasukan_negara': toDouble(pemasukanNegara.text),
                'pemasukan_negara_base': toDouble(pemasukanNegaraBase.text),
                'report_year': reportYear,
              };
              try {
                await saveTax(payload: payload, id: data?['id'] as int?);
                if (!mounted) return;
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      data == null ? 'Pajak ditambahkan' : 'Pajak diupdate',
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
