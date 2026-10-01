import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailDialogsGeneralshowEditAdvanceDialogExt
    on AdvanceDetailScreenState {
  Future<void> showEditAdvanceDialog(
    BuildContext context,
    Map<String, dynamic> advance,
  ) async {
    final titleCtrl = TextEditingController(text: advance['title']);
    final isBatch = advance['advance_type'] == 'batch';
    String? selectedDate = advance['document_date'];
    final dateCtrl = TextEditingController(text: selectedDate ?? '');

    try {
      await showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: cardColor(ctx),
            title:
                Text('Edit Kasbon', style: TextStyle(color: creamColor(ctx))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengajuan / Nama Trip',
                  ),
                  style: TextStyle(color: primaryText(ctx)),
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
                    style: TextStyle(color: primaryText(ctx)),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate != null
                            ? DateTime.tryParse(selectedDate!) ?? DateTime.now()
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  await context.read<AdvanceProvider>().updateAdvance(
                        advance['id'],
                        titleCtrl.text.trim(),
                        "", // empty description
                        documentDate: selectedDate,
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (context.mounted) {
                    context.read<AdvanceProvider>().loadAdvance(advance['id']);
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
