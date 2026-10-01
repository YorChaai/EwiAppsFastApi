import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/management/asset_management_screen.dart';

Future<void> showAssetDialog(BuildContext context, AssetManagementScreenState parentState, DateFormat dateFmt, [Map<String, dynamic>? data]) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: data?['name'] ?? '');
    final codeCtrl = TextEditingController(text: data?['asset_code'] ?? '');
    final dateCtrl = TextEditingController(
        text: data?['purchase_date'] ?? dateFmt.format(DateTime.now()));

    final priceCtrl = TextEditingController(
        text: data != null
            ? AppFormatters.formatCurrencyPlain(data['purchase_price'])
            : '');
    final residualCtrl = TextEditingController(
        text: data != null
            ? AppFormatters.formatCurrencyPlain(data['residual_value'])
            : '0');

    // Structured Life Input - REMOVE DEFAULTS, USE HINTS
    final lifeYCtrl = TextEditingController(
        text:
            data != null ? (data['useful_life_months'] ~/ 12).toString() : '');
    final lifeMCtrl = TextEditingController(
        text: data != null ? (data['useful_life_months'] % 12).toString() : '');

    final typeCtrl = TextEditingController(text: data?['asset_type'] ?? '');
    String? selectedStatus = data?['status'] ?? 'Active';
    final descCtrl = TextEditingController(text: data?['description'] ?? '');

    final statuses = [
      'Active',
      'Under Maintenance',
      'Damaged',
      'Sold',
      'Disposed',
      'Lost'
    ];
    double monthlyDepr = 0.0;

    void calculatePreview(StateSetter setState) {
      double p = double.tryParse(
              priceCtrl.text.replaceAll('.', '').replaceAll(',', '.')) ??
          0.0;
      double r = double.tryParse(
              residualCtrl.text.replaceAll('.', '').replaceAll(',', '.')) ??
          0.0;
      int y = int.tryParse(lifeYCtrl.text) ?? 0;
      int m = int.tryParse(lifeMCtrl.text) ?? 0;
      int totalMonths = (y * 12) + m;

      if (totalMonths > 0) {
        setState(() {
          monthlyDepr = (p - r) / totalMonths;
        });
      } else {
        setState(() {
          monthlyDepr = 0.0;
        });
      }
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          if (monthlyDepr == 0.0 &&
              (priceCtrl.text.isNotEmpty || residualCtrl.text.isNotEmpty)) {
            calculatePreview(setState);
          }

          return AlertDialog(
            backgroundColor: parentState.cardColor(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data == null ? 'Tambah Aset' : 'Edit Aset',
                  style: TextStyle(
                      color: parentState.creamColor(ctx), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pastikan data sesuai dengan standar akuntansi',
                  style: TextStyle(
                      fontSize: 12,
                      color: parentState.secondaryTextColor(ctx),
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
            content: SizedBox(
              width: 550,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: codeCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Asset Code / SKU',
                                hintText: 'AST-2024-001',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonFormField<String>(
                              initialValue: selectedStatus,
                              decoration:
                                  const InputDecoration(labelText: 'Status'),
                              items: statuses
                                  .map((s) => DropdownMenuItem(
                                      value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => selectedStatus = v),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Aset',
                          hintText: 'Contoh: Wellhead Pump X-102',
                        ),
                        validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dateCtrl,
                              readOnly: true,
                              decoration: const InputDecoration(
                                labelText: 'Tanggal Pembelian',
                                suffixIcon: Icon(Icons.calendar_today_rounded,
                                    size: 20),
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.tryParse(dateCtrl.text) ??
                                          DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() =>
                                      dateCtrl.text = dateFmt.format(picked));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: typeCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Jenis Aset',
                                hintText: 'Contoh: Wellhead Equipment',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: priceCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [CurrencyInputFormatter()],
                              decoration: const InputDecoration(
                                labelText: 'Harga Barang',
                                prefixText: 'Rp ',
                                hintText: '0',
                              ),
                              onChanged: (_) => calculatePreview(setState),
                              validator: (v) =>
                                  v!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: residualCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [CurrencyInputFormatter()],
                              decoration: const InputDecoration(
                                labelText: 'Nilai Sisa',
                                prefixText: 'Rp ',
                                hintText: '0',
                              ),
                              onChanged: (_) => calculatePreview(setState),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Masa Manfaat (Accounting Life)',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: parentState.textColor(ctx))),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          lifeInput(parentState, lifeYCtrl, 'Tahun', '00',
                              (v) => calculatePreview(setState)),
                          const SizedBox(width: 8),
                          lifeInput(parentState, lifeMCtrl, 'Bulan', '00',
                              (v) => calculatePreview(setState)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Colors.blue.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calculate_outlined,
                                color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('ESTIMASI DEPRESIASI BULANAN',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                  Text(
                                    AppFormatters.formatCurrency(monthlyDepr),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Keterangan / Lokasi / PIC',
                          hintText: 'Contoh: Lokasi Well-A, PIC: John Doe',
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
                  child: Text('Batal',
                      style: TextStyle(color: parentState.secondaryTextColor(ctx)))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  double parseVal(String text) {
                    if (text.isEmpty) return 0.0;
                    String clean =
                        text.replaceAll('.', '').replaceAll(',', '.');
                    return double.tryParse(clean) ?? 0.0;
                  }

                  int years = int.tryParse(lifeYCtrl.text) ?? 0;
                  int months = int.tryParse(lifeMCtrl.text) ?? 0;
                  int totalMonths = (years * 12) + months;

                  final payload = {
                    'asset_code': codeCtrl.text.trim(),
                    'name': nameCtrl.text,
                    'purchase_date': dateCtrl.text,
                    'purchase_price': parseVal(priceCtrl.text),
                    'useful_life_months': totalMonths > 0 ? totalMonths : 1,
                    'residual_value': parseVal(residualCtrl.text),
                    'asset_type': typeCtrl.text,
                    'status': selectedStatus,
                    'description': descCtrl.text,
                  };
                  try {
                    final prov = context.read<AssetProvider>();
                    if (data == null) {
                      await prov.createAsset(payload);
                    } else {
                      await prov.updateAsset(data['id'], payload);
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red));
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

Widget lifeInput(AssetManagementScreenState parentState, TextEditingController ctrl, String label, String hint,
      Function(String) onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
