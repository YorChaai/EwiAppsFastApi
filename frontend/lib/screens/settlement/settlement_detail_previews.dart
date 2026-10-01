
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/widgets/item_detail_preview_dialog.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/layouts/settlement_detail_layout.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_comments.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_evidence.dart';

extension SettlementDetailPreviewsExt on SettlementDetailScreenState {
  void showItemPreview(Map<String, dynamic> item) {
    final prov = context.read<SettlementProvider>();

    showItemDetailPreviewDialog(
      context: context,
      item: {
        ...item,
        'source': expenseFundSource(item),
        'category_name': item['category_name'] ?? '-',
        'subcategory_name': item['subcategory_name'] ?? '-',
        'batch_notes': prov.currentSettlement?['notes']
      },
      title: 'Pratinjau Rincian Item',
      onViewEvidence: (path, name) => showEvidence(path, name),
    );
  }

  void showAllItemsPreview(
    List<Map<String, dynamic>> items,
    Map<String, dynamic> parent,
  ) {
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = getIsDark(ctx);
        final screenWidth = MediaQuery.of(ctx).size.width;
        final screenHeight = MediaQuery.of(ctx).size.height;
        int activeTab = 0; // 0: Items, 1: Disbursement

        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: getCardColor(ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            titlePadding: const EdgeInsets.fromLTRB(20, 20, 8, 10),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child:
                          Icon(Icons.list_alt_rounded, color: AppTheme.accent),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          String displayTitle =
                              parent['title'] ?? 'Pratinjau Pengajuan';
                          return Text(
                            displayTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.3,
                              color: getCreamColor(ctx),
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
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Builder(builder: (context) {
                    final allApproved = items.isNotEmpty &&
                        items.every((i) =>
                            i['status'] == 'approved' ||
                            i['status'] == 'completed');

                    final enableTable2 = allApproved;

                    return Row(
                      children: [
                        buildTabButton(
                          'Rincian Item',
                          activeTab == 0,
                          () => setDialogState(() => activeTab = 0),
                        ),
                        const SizedBox(width: 8),
                        buildTabButton(
                          'Pengiriman Dana',
                          activeTab == 1,
                          () {
                            if (enableTable2) {
                              setDialogState(() => activeTab = 1);
                            }
                          },
                          isDisabled: !enableTable2,
                        ),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
            content: SizedBox(
              width: screenWidth > 800 ? 700 : screenWidth * 0.95,
              height: screenHeight * 0.8,
              child: Builder(builder: (context) {
                if (activeTab == 1) {
                  return buildDisbursementPreviewContent(parent, isDark);
                }
                return buildAllItemsPreviewList(items, isDark);
              }),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ],
          );
        });
      },
    );
  }

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
                  color: getSecondaryText(context),
                  fontSize: 12,
                ),
              ),
            ),
            const Text(
              ' -> ',
              style: TextStyle(color: AppTheme.primary, fontSize: 12),
            ),
            Expanded(
              child: InkWell(
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
                color: getSecondaryText(context),
                fontSize: 12,
              ),
            ),
          ),
          const Text(
            ' -> ',
            style: TextStyle(color: AppTheme.primary, fontSize: 12),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                color: valueColor ?? getPrimaryText(context),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisbursementPreviewContent(
      Map<String, dynamic> settlement, bool isDark) {
    final expenses = asMapList(settlement['expenses']);
    final base = expenses.isNotEmpty ? expenses.first : <String, dynamic>{};
    final disbursementComment =
        (settlement['disbursement_comment'] ?? '').toString().trim();
    final Map<String, dynamic> data = {
      'category_name': (base['category_name'] ?? '-').toString(),
      'subcategory_name': (base['subcategory_name'] ?? '-').toString(),
      'date':
          AppFormatters.formatDateForApi(disbursementDate ?? DateTime.now()),
      'bank_name': settlementDisbursementSourceLabel(settlement),
      'description': disbursementDescriptionController.text,
      'amount': toDouble(disbursedAmountController.text),
      'admin_fee': toDouble(adminFeeController.text),
      'status': (settlement['is_disbursement_approved'] ?? false)
          ? 'APPROVED'
          : 'PENDING',
      'comment': disbursementComment.isEmpty ? '-' : disbursementComment,
      'evidence_path': settlement['disbursement_evidence_path'],
      'evidence_filename': settlement['disbursement_evidence_filename'],
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPreviewRow('Tanggal', data['date'], isDark),
          buildPreviewRow('Sumber Dana', data['bank_name'], isDark),
          buildPreviewRow('Kategori', data['category_name'], isDark),
          buildPreviewRow('Subkategori', data['subcategory_name'], isDark),
          buildPreviewRow(
              'Amount', AppFormatters.formatCurrency(data['amount']), isDark,
              valueColor: AppTheme.primary),
          buildPreviewRow('Biaya Admin',
              AppFormatters.formatCurrency(data['admin_fee']), isDark),
          buildPreviewRow('Deskripsi', data['description'], isDark),
          buildPreviewRow('Komentar', data['comment'], isDark),
          buildPreviewRow('Status', data['status'], isDark,
              valueColor: getStatusColor(data['status'].toLowerCase())),
          if (data['evidence_path'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton.icon(
                onPressed: () => showEvidence(
                    data['evidence_path'], data['evidence_filename']),
                icon: const Icon(Icons.image_rounded, size: 16),
                label:
                    const Text('Lihat Bukti', style: TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildAllItemsPreviewList(
      List<Map<String, dynamic>> items, bool isDark) {
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
              if (item['title'] != null && item['title'].toString().isNotEmpty)
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
                'Amount',
                formatExpenseAmount(
                  item,
                ).replaceAll('\n', ' '),
                isDark,
                valueColor: AppTheme.primary,
              ),
              buildPreviewRow(
                'Sumber',
                expenseFundSource(item),
                isDark,
              ),
              buildPreviewRow(
                'Deskripsi',
                item['description'] ?? '-',
                isDark,
              ),
              buildPreviewRow(
                'Status',
                (item['status'] ?? 'pending').toString().toUpperCase(),
                isDark,
                valueColor: getStatusColor(
                  (item['status'] ?? 'pending').toString(),
                ),
              ),
              if (item['notes'] != null && item['notes'].toString().isNotEmpty)
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
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void showDisbursementPreview(Map<String, dynamic> settlement) {
    final expenses = asMapList(settlement['expenses']);
    final base = expenses.isNotEmpty ? expenses.first : <String, dynamic>{};
    final disbursementComment =
        (settlement['disbursement_comment'] ?? '').toString().trim();

    final dbAdminFee = toDouble(settlement['admin_fee']);
    final dbDisbursed = toDouble(settlement['disbursed_amount']);
    final isTable2Modified = settlement['modified_t2'] == true;
    final isTable2Approved = settlement['is_disbursement_approved'] == true;
    final status = (settlement['status'] ?? 'draft').toString().toLowerCase();
    final isSubmitted =
        status == 'submitted' || status == 'approved' || status == 'completed';

    // Calculate total approved expenses for the initial disbursement value
    final totalApproved = expenses.fold<double>(
      0,
      (sum, e) =>
          sum + (double.tryParse(e['idr_amount']?.toString() ?? '0') ?? 0.0),
    );

    final targetDisbursed =
        (isSubmitted || isTable2Approved || isTable2Modified || dbDisbursed > 0)
            ? dbDisbursed
            : totalApproved;

    showDialog(
      context: context,
      builder: (ctx) => ItemDetailPreviewDialog(
        title: 'Pratinjau Pengiriman Dana',
        item: {
          'date': AppFormatters.formatDateForApi(disbursementDate!),
          'source': settlementDisbursementSourceLabel(settlement),
          'category_name': (base['category_name'] ?? '-').toString(),
          'subcategory_name': (base['subcategory_name'] ?? '-').toString(),
          'description': displaySettlementTitle(settlement),
          'comment': disbursementComment,
          'amount': targetDisbursed,
          'admin_fee': dbAdminFee,
          'status': (settlement['is_disbursement_approved'] ?? false)
              ? 'APPROVED'
              : 'PENDING',
          'evidence_path': (settlement['disbursement_evidence_path'] != null &&
                  settlement['disbursement_evidence_path']
                      .toString()
                      .trim()
                      .isNotEmpty)
              ? settlement['disbursement_evidence_path']
              : null,
          'evidence_filename': settlement['disbursement_evidence_filename'],
        },
        onViewEvidence: (path, name) => showEvidence(path, name),
      ),
    );
  }
}
