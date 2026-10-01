import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/widgets/item_detail_preview_dialog.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_comments.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_evidence.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_get_comments_from_notes.dart';
import 'package:expense_app/screens/advance/layouts/advance_detail_layout.dart';

extension AdvanceDetailPreviewsExt on AdvanceDetailScreenState {
  Widget buildPreviewRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isNotes = false,
  }) {
    if (isNotes) {
      final comments = getCommentsFromNotes(value);
      if (comments.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                style: TextStyle(
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const Text(
              ' -> ',
              style: TextStyle(color: AppTheme.primary, fontSize: 12),
            ),
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: () => showCommentsDialog(comments, isDark),
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.comment_rounded,
                            size: 18,
                            color: AppTheme.accent,
                          ),
                        ),
                        if (comments.isNotEmpty)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppTheme.danger,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                comments.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                fontSize: 12,
              ),
            ),
          ),
          const Text(
            ' -> ',
            style: TextStyle(color: AppTheme.primary, fontSize: 12),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? titleColor(context),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAllItemsPreview(
    List<Map<String, dynamic>> items,
    Map<String, dynamic> parent,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(ctx).size.width;
        final screenHeight = MediaQuery.of(ctx).size.height;

        return AlertDialog(
          backgroundColor: cardColor(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 8, 10),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2),
                child: Icon(Icons.list_alt_rounded, color: AppTheme.accent),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Builder(
                  builder: (context) {
                    String displayTitle = parent['title'] ?? 'Pratinjau Item';
                    final type = (parent['settlement_type'] ?? 'batch')
                        .toString()
                        .toLowerCase();

                    if (type == 'single' && items.isNotEmpty) {
                      displayTitle = items.first['description'] ?? displayTitle;
                    }

                    return Text(
                      displayTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.3,
                        color: titleColor(ctx),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close_rounded),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          content: SizedBox(
            width: screenWidth > 800 ? 700 : screenWidth * 0.95,
            height: screenHeight * 0.8,
            child: Column(
              children: [
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final lvCtrl = ScrollController();
                      return AppScrollbar(
                        controller: lvCtrl,
                        thumbVisibility: true,
                        interactive: true,
                        child: ListView.separated(
                          controller: lvCtrl,
                          padding: const EdgeInsets.fromLTRB(0, 0, 16, 10),
                          itemCount: items.length,
                          separatorBuilder: (c, i) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(),
                          ),
                          itemBuilder: (c, i) {
                            final item = items[i];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'ITEM #${i + 1}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (item['title'] != null &&
                                    item['title'].toString().isNotEmpty)
                                  buildPreviewRow(
                                    'Judul',
                                    item['title'],
                                    isDark,
                                  ),
                                buildPreviewRow(
                                  'Tanggal',
                                  item['date'] ?? '-',
                                  isDark,
                                ),
                                buildPreviewRow(
                                  'Kategori',
                                  item['category_name'] ?? '-',
                                  isDark,
                                ),
                                buildPreviewRow(
                                  'Subkategori',
                                  item['subcategory_name'] ?? '-',
                                  isDark,
                                ),
                                buildPreviewRow(
                                  'Estimasi',
                                  formatItemAmount(item),
                                  isDark,
                                  valueColor: AppTheme.primary,
                                ),
                                buildPreviewRow(
                                  'Deskripsi',
                                  item['description'] ?? '-',
                                  isDark,
                                ),
                                buildPreviewRow(
                                  'Status',
                                  (item['status'] ?? 'pending')
                                      .toString()
                                      .toUpperCase(),
                                  isDark,
                                  valueColor: statusColor(
                                    (item['status'] ?? 'pending').toString(),
                                  ),
                                ),
                                if (item['notes'] != null &&
                                    item['notes'].toString().isNotEmpty)
                                  buildPreviewRow(
                                    'Komentar Reject',
                                    item['notes'],
                                    isDark,
                                    isNotes: true,
                                  ),
                                if (item['evidence_path'] != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: TextButton.icon(
                                      onPressed: () => showEvidence(
                                        item['evidence_path'],
                                        item['evidence_filename'],
                                      ),
                                      icon: const Icon(
                                        Icons.image_rounded,
                                        size: 16,
                                      ),
                                      label: const Text(
                                        'Lihat Bukti',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppTheme.primary,
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void showDisbursementPreview(Map<String, dynamic> advance) {
    final items = asMapList(advance['items']);
    final base = items.isNotEmpty ? items.first : <String, dynamic>{};
    final disbursementComment =
        (advance['disbursement_comment'] ?? '').toString().trim();

    final dbAdminFee = toDouble(advance['admin_fee']);
    final dbDisbursed = toDouble(advance['disbursed_amount']);
    final approvedAmount = toDouble(advance['approved_amount']);
    final isTable2Modified = advance['modified_t2'] == true;
    final isTable2Approved = advance['is_disbursement_approved'] == true;
    final status = (advance['status'] ?? 'draft').toString().toLowerCase();
    final isSubmitted = status.contains('submitted') ||
        status == 'approved' ||
        status == 'completed';

    final targetDisbursed =
        (isSubmitted || isTable2Approved || isTable2Modified || dbDisbursed > 0)
            ? dbDisbursed
            : approvedAmount;

    showDialog(
      context: context,
      builder: (ctx) => ItemDetailPreviewDialog(
        title: 'Pratinjau Pengiriman Dana',
        item: {
          'date': AppFormatters.formatDateForApi(disbursementDate!),
          'source': advanceDisbursementSourceLabel(advance),
          'category_name': (base['category_name'] ?? '-').toString(),
          'subcategory_name': (base['subcategory_name'] ?? '-').toString(),
          'description': displayAdvanceTitle(advance),
          'comment': disbursementComment,
          'amount': targetDisbursed,
          'admin_fee': dbAdminFee,
          'status': (advance['is_disbursement_approved'] ?? false)
              ? 'APPROVED'
              : 'PENDING',
          'evidence_path': (advance['disbursement_evidence_path'] != null &&
                  advance['disbursement_evidence_path']
                      .toString()
                      .trim()
                      .isNotEmpty)
              ? advance['disbursement_evidence_path']
              : null,
          'evidence_filename': advance['disbursement_evidence_filename'],
        },
        onViewEvidence: (path, name) => showEvidence(path, name),
      ),
    );
  }

  void showItemPreview(Map<String, dynamic> item) {
    final adv = context.read<AdvanceProvider>().currentAdvanceMap;

    showItemDetailPreviewDialog(
      context: context,
      item: {
        ...item,
        'category_name': item['category_name'] ?? '-',
        'subcategory_name': item['subcategory_name'] ?? '-',
        'batch_notes': adv?['notes']
      },
      title: 'Pratinjau Rincian Item',
      onViewEvidence: (path, name) => showEvidence(path, name),
    );
  }
}
