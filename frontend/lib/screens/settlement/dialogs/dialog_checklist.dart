
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/layouts/settlement_detail_layout.dart';
import 'package:expense_app/screens/settlement/layouts/settlement_detail_tables.dart';

extension SettlementDetailDialogsGeneralshowChecklistDialogExt
    on SettlementDetailScreenState {
  void showChecklistDialog(
    int expenseId,
    List<dynamic> checklist,
    String settlementStatus,
    String itemStatus,
  ) {
    final normalizedStatus = settlementStatus.toLowerCase();
    // Bisa edit jika status draft atau rejected (setelah revisi)
    final canEdit = normalizedStatus == 'draft' ||
        normalizedStatus == 'rejected' ||
        normalizedStatus == 'revision' ||
        normalizedStatus == 'rejected';
    final isManager = context.read<AuthProvider>().isManager;
    final canAddComment = canEdit && isManager;

    List<Map<String, dynamic>> localChecklist = parseChecklist(checklist);
    final checklistCtrl = ScrollController();

    try {
      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              backgroundColor: getCardColor(ctx),
              title: Text(
                'Rejection Checklist${!canEdit ? ' (Lihat saja)' : ''}',
                style: TextStyle(color: getCreamColor(ctx)),
              ),
              content: SizedBox(
                width: 400,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 420),
                  child: AppScrollbar(
                    controller: checklistCtrl,
                    thumbVisibility: true,
                    interactive: true,
                    child: SingleChildScrollView(
                      controller: checklistCtrl,
                      child: SelectionArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...localChecklist.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final item = entry.value;
                              return buildChecklistTile(
                                item,
                                canEdit,
                                isManager,
                                canEdit,
                                setModalState,
                                onDelete: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor: getCardColor(ctx),
                                      title: Text(
                                        'Hapus Komentar?',
                                        style:
                                            TextStyle(color: getCreamColor(ctx)),
                                      ),
                                      content: Text(
                                        'Apakah Anda yakin ingin menghapus komentar ini?',
                                        style: TextStyle(
                                            color: getSecondaryText(ctx)),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text('Batal'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppTheme.danger,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Ya, Hapus'),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    setModalState(() {
                                      if (item['focusNode'] is FocusNode) {
                                        (item['focusNode'] as FocusNode)
                                            .dispose();
                                      }
                                      localChecklist.removeAt(idx);
                                    });
                                    showGlobalSnackBar(
                                      'Komentar berhasil dihapus ✓',
                                      AppTheme.success,
                                    );
                                  }
                                },
                              );
                            }),
                            if (canAddComment)
                              buildAddCommentButton(
                                localChecklist,
                                setModalState,
                              ),
                            if (!canEdit &&
                                (normalizedStatus == 'submitted' ||
                                    normalizedStatus == 'submitted'))
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.warning.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppTheme.warning.withValues(
                                      alpha: 0.3,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      size: 16,
                                      color: AppTheme.warning,
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Settlement disubmit, Move to Draft untuk edit',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Tutup',
                    style: TextStyle(color: getSecondaryText(ctx)),
                  ),
                ),
                if (canEdit)
                  buildSaveChecklistButton(
                    ctx,
                    expenseId,
                    localChecklist,
                    settlementStatus,
                    itemStatus,
                  ),
              ],
            );
          },
        ),
      );
    } finally {
      checklistCtrl.dispose();
      // Dispose focus nodes in checklist
      for (var item in localChecklist) {
        if (item['focusNode'] is FocusNode) {
          (item['focusNode'] as FocusNode).dispose();
        }
      }
    }
  }
}
