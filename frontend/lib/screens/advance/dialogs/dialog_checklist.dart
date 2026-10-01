import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/layouts/advance_detail_tables.dart';
import 'package:expense_app/screens/advance/widgets/widget_add_comment_button.dart';

extension AdvanceDetailDialogsGeneralshowChecklistDialogExt
    on AdvanceDetailScreenState {
  void showChecklistDialog(
    int itemId,
    List<dynamic> checklist,
    String advanceStatus,
    String itemStatus,
  ) {
    final isRejected =
        advanceStatus == 'rejected' || advanceStatus == 'rejected';
    final isSubmitted =
        advanceStatus == 'submitted' || advanceStatus == 'submitted';
    final isDraft = advanceStatus == 'draft';
    final isRevisionDraft = advanceStatus == 'revision';

    // SEMUA user (manager/staff) TIDAK bisa edit saat submitted
    // Bisa edit saat draft/rejected/revision_draft
    final canEdit = !isSubmitted && (isDraft || isRejected || isRevisionDraft);
    final isManager = context.read<AuthProvider>().isManager;
    final canAddComment = canEdit && isManager;

    List<Map<String, dynamic>> localChecklist = parseChecklist(checklist);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            backgroundColor: cardColor(ctx),
            title: Text(
              'Rejection Checklist${!canEdit ? ' (Lihat saja)' : ''}',
              style: TextStyle(color: creamColor(ctx)),
            ),
            content: SizedBox(
              width: 400,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 420),
                child: AppScrollbar(
                  controller: checklistScrollController,
                  thumbVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: checklistScrollController,
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
                                    backgroundColor: cardColor(ctx),
                                    title: Text(
                                      'Hapus Komentar?',
                                      style: TextStyle(color: creamColor(ctx)),
                                    ),
                                    content: Text(
                                      'Apakah Anda yakin ingin menghapus komentar ini?',
                                      style:
                                          TextStyle(color: secondaryText(ctx)),
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
                          if (!canEdit && isSubmitted)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.warning.withValues(alpha: 0.1),
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
                                  Expanded(
                                    child: Text(
                                      'Kasbon disubmit, Move to Draft untuk edit',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.warning.withValues(
                                          alpha: 0.9,
                                        ),
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
                  style: TextStyle(color: secondaryText(ctx)),
                ),
              ),
              if (canEdit)
                buildSaveChecklistButton(
                  ctx,
                  itemId,
                  localChecklist,
                  advanceStatus,
                  itemStatus,
                ),
            ],
          );
        },
      ),
    );
  }
}
