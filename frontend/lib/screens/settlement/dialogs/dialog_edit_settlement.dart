
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailDialogsGeneralshowEditSettlementDialogExt
    on SettlementDetailScreenState {
  Future<void> showEditSettlementDialog(
    BuildContext context,
    Map<String, dynamic> settlement,
  ) async {
    final prov = context.read<SettlementProvider>();
    final titleCtrl = TextEditingController(text: settlement['title']);
    final isBatch = settlement['settlement_type'] == 'batch';
    String? selectedDate = settlement['document_date'];
    final dateCtrl = TextEditingController(text: selectedDate ?? '');

    try {
      await showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: getCardColor(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Edit Settlement',
              style: TextStyle(color: getCreamColor(ctx)),
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Judul Pengajuan / Nama Trip',
                    ),
                    style: TextStyle(color: getPrimaryText(ctx)),
                  ),
                  if (isBatch) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: dateCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Dokumen (Opsional)',
                        suffixIcon: Icon(Icons.calendar_today, size: 20),
                      ),
                      style: TextStyle(color: getPrimaryText(ctx)),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: ctx,
                          initialDate: selectedDate != null
                              ? DateTime.tryParse(selectedDate!) ??
                                  DateTime.now()
                              : DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) {
                          final str =
                              "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
                          setDialogState(() {
                            selectedDate = str;
                            dateCtrl.text = str;
                          });
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Judul wajib diisi'),
                        backgroundColor: AppTheme.danger,
                      ),
                    );
                    return;
                  }
                  final success = await prov.updateSettlement(
                    widget.settlementId,
                    title: titleCtrl.text.trim(),
                    documentDate: selectedDate,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settlement diupdate ✓'),
                        backgroundColor: AppTheme.success,
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
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        titleCtrl.dispose();
        dateCtrl.dispose();
      });
    }
  }
}
