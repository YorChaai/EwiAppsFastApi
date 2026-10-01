
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailDialogsExpenseshowAddCategoryDialogExt
    on SettlementDetailScreenState {
  Future<void> showAddCategoryDialog(
    BuildContext ctx,
    StateSetter setDialogState,
    Function(Map<String, dynamic>) onCreated, {
    int? parentId,
  }) async {
    final nameCtrl = TextEditingController();
    final prov = context.read<SettlementProvider>();

    try {
      await showDialog(
        context: ctx,
        builder: (innerCtx) => AlertDialog(
          backgroundColor: getCardColor(innerCtx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            parentId != null ? 'Tambah Sub Kategori' : 'Tambah Kategori Utama',
            style: TextStyle(color: getCreamColor(innerCtx)),
          ),
          content: SizedBox(
            width: 350,
            child: TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText:
                    parentId != null ? 'Nama Sub Kategori' : 'Nama Kategori',
              ),
              style: TextStyle(color: getPrimaryText(ctx)),
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(innerCtx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final messenger = ScaffoldMessenger.of(context);
                final success = await prov.createCategory(
                  nameCtrl.text.trim(),
                  parentId: parentId,
                );

                if (success) {
                  if (innerCtx.mounted) Navigator.pop(innerCtx);
                  if (mounted) {
                    // cari kategori baru untuk callback
                    final all = prov.categories;
                    Map<String, dynamic> found = {};

                    // cari kategori yang baru dibuat
                    for (final p in all) {
                      if (parentId == null &&
                          p['name'] == nameCtrl.text.trim()) {
                        found = p;
                        break;
                      }
                      if (parentId != null && p['id'] == parentId) {
                        final children = (p['children'] as List?) ?? [];
                        for (final c in children) {
                          if (c['name'] == nameCtrl.text.trim()) {
                            found = c;
                            break;
                          }
                        }
                      }
                    }

                    onCreated(found);

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Kategori ditambahkan (menunggu approval manager) ✓',
                        ),
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  }
                } else {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(prov.error ?? 'Gagal membuat kategori'),
                      backgroundColor: AppTheme.danger,
                    ),
                  );
                }
              },
              child: const Text('Tambah'),
            ),
          ],
        ),
      );
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        nameCtrl.dispose();
      });
    }
  }
}
