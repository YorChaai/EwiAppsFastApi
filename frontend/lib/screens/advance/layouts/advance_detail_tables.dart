import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/advance_detail_previews.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_add_item.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_checklist.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_disbursement_evidence_cell.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_edit_disbursement.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_evidence.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_insufficient_balance.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_parse_plain_comments.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_plain_comments.dart';

extension AdvanceDetailTablesExt on AdvanceDetailScreenState {
  Widget buildChecklistTile(
    Map<String, dynamic> item,
    bool canEdit,
    bool isManager,
    bool isDocDraft,
    StateSetter setModalState, {
    VoidCallback? onDelete,
  }) {
    final isChecked = item['checked'] == true;
    final canEditText = isManager && isDocDraft;

    return Padding(
      key: ValueKey(item),
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: isChecked,
                onChanged: canEdit
                    ? (val) {
                        setModalState(() {
                          item['checked'] = val;
                        });
                      }
                    : null,
                activeColor: AppTheme.success,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: canEditText
                    ? TextFormField(
                        focusNode: item['focusNode'] as FocusNode?,
                        initialValue: item['text'] ?? '',
                        onChanged: (val) => item['text'] = val,
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 13,
                          color: creamColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar...',
                          hintStyle: TextStyle(
                            color:
                                secondaryText(context).withValues(alpha: 0.5),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: dividerColor(context),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          item['text'] ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: creamColor(context)
                                .withValues(alpha: isChecked ? 0.5 : 1.0),
                            decoration:
                                isChecked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
              ),
              if (canEditText && onDelete != null)
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline,
                      size: 18, color: AppTheme.danger),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPendingRichText(BuildContext context, String text) {
    if (!text.contains('(Pending)')) {
      return Text(text);
    }

    final items = text.split(' , ');
    final spans = <TextSpan>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.contains('(Pending)')) {
        final cleanName =
            item.replaceAll(' (Pending)', '').replaceAll('(Pending)', '');
        spans.add(TextSpan(
          text: cleanName,
          style: const TextStyle(
              color: AppTheme.warning, fontWeight: FontWeight.bold),
        ));
      } else {
        spans.add(TextSpan(text: item));
      }

      if (i < items.length - 1) {
        spans.add(const TextSpan(text: ' , '));
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: primaryText(context),
          fontSize: 13,
          fontFamily: 'Inter',
        ),
        children: spans,
      ),
    );
  }

  Widget buildItemsTable(
    List<Map<String, dynamic>> items,
    Map<String, dynamic> adv,
    AuthProvider auth,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor(context)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AppScrollbar(
          controller: itemTableVerticalCtrl,
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          child: SingleChildScrollView(
            controller: itemTableVerticalCtrl,
            child: AppScrollbar(
              controller: itemTableHorizontalCtrl,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              scrollDirection: Axis.horizontal,
              notificationPredicate: (notification) =>
                  notification.metrics.axis == Axis.horizontal,
              child: SingleChildScrollView(
                controller: itemTableHorizontalCtrl,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMaxHeight: double.infinity,
                  headingRowColor: WidgetStateProperty.all(
                    surfaceColor(context),
                  ),
                  dataRowColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return isDark(context)
                          ? AppTheme.cardHover
                          : AppTheme.lightCardHover;
                    }
                    return cardColor(context);
                  }),
                  columns: [
                    DataColumn(
                      label: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Kategori',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Subkategori',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Tanggal',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Evidence',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Aksi',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: creamColor(context),
                        ),
                      ),
                    ),
                  ],
                  rows: items.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final item = entry.value;
                    final itemId = item['id'] as int;
                    final itemStatus =
                        (item['status'] ?? 'pending').toString().toLowerCase();
                    final isItemApproved = itemStatus == 'approved';
                    final canEditRow = canEditCurrentRevision(adv, item);
                    final isSubmittedState = adv['status'] == 'submitted' ||
                        adv['status'] == 'submitted';
                    final showChecklist =
                        isManager && isSubmittedState && !isItemApproved;

                    final mainCat = item['category_name'] ?? '-';
                    final subCat = item['subcategory_name'] ?? '-';

                    final previewBtn = IconButton(
                      icon: const Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.primary,
                        size: 18,
                      ),
                      tooltip: 'Pratinjau Rincian Item',
                      onPressed: () => showItemPreview(item),
                    );

                    return DataRow(
                      selected: showChecklist
                          ? checkedItemIds.contains(itemId)
                          : selectedItemIds.contains(itemId),
                      onSelectChanged: (selected) {
                        updateState(() {
                          if (showChecklist) {
                            if (selected == true) {
                              checkedItemIds.add(itemId);
                            } else {
                              checkedItemIds.remove(itemId);
                            }
                          } else {
                            if (selected == true) {
                              selectedItemIds.add(itemId);
                            } else {
                              selectedItemIds.remove(itemId);
                            }
                          }
                        });
                      },
                      cells: [
                        DataCell(Text('${idx + 1}')),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(mainCat),
                          ),
                        ),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: buildPendingRichText(context, subCat),
                          ),
                        ),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              item['description'] ?? '',
                            ),
                          ),
                        ),
                        DataCell(Text(item['date'] ?? '-')),
                        DataCell(
                          Builder(
                            builder: (context) {
                              final currency = (item['currency'] ?? 'IDR')
                                  .toString()
                                  .toUpperCase();
                              final estimated =
                                  (item['estimated_amount'] ?? 0) as num;
                              final kurs =
                                  (item['currency_exchange'] ?? 1.0) as num;
                              final idrStr = item['idr_amount'];
                              final idr = (idrStr is num && idrStr > 0)
                                  ? idrStr
                                  : (estimated * kurs);

                              if (currency == 'IDR') {
                                return Text(
                                  AppFormatters.formatCurrency(estimated),
                                );
                              }
                              final foreignFormat = NumberFormat(
                                '#,##0.##',
                                'en_US',
                              );
                              return Text(
                                '$currency ${foreignFormat.format(estimated)}\n(${AppFormatters.formatCurrency(idr)})',
                              );
                            },
                          ),
                        ),
                        DataCell(
                          item['evidence_path'] != null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.image_rounded,
                                    color: AppTheme.accent,
                                    size: 20,
                                  ),
                                  tooltip: 'Lihat Bukti',
                                  onPressed: () => showEvidence(
                                    item['evidence_path'],
                                    item['description'] ?? 'Evidence',
                                  ),
                                )
                              : const Text('-'),
                        ),
                        DataCell(
                          Builder(
                            builder: (context) {
                              List<dynamic> checklist = [];
                              try {
                                if (item['notes'] != null &&
                                    (item['notes'] as String).isNotEmpty) {
                                  checklist = parseChecklist(item['notes']);
                                }
                              } catch (_) {}

                              final bool hasComments = checklist.isNotEmpty;
                              final int checkedCount = checklist
                                  .where((it) => it['checked'] == true)
                                  .length;
                              final int totalCount = checklist.length;

                              String itemStatus = (item['status'] ?? 'pending')
                                  .toString()
                                  .toUpperCase();

                              if (itemStatus == 'UNKNOWN') {
                                itemStatus = 'PENDING';
                              }

                              // FIX: If there are unchecked comments, force status to REJECTED
                              String effectiveStatus = itemStatus;
                              if (hasComments && checkedCount < totalCount) {
                                effectiveStatus = 'REJECTED';
                              }

                              Color clr =
                                  statusColor(effectiveStatus.toLowerCase());

                              Widget badge = Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: clr.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: hasComments
                                      ? Border.all(
                                          color: clr.withValues(
                                            alpha: 0.3,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Text(
                                  hasComments
                                      ? '$effectiveStatus (Comment $checkedCount/$totalCount)'
                                      : effectiveStatus,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: clr,
                                  ),
                                ),
                              );

                              if (hasComments) {
                                return InkWell(
                                  onTap: () => showChecklistDialog(
                                    itemId,
                                    checklist,
                                    (adv['status'] ?? '').toString(),
                                    itemStatus.toLowerCase(),
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  child: badge,
                                );
                              }

                              return badge;
                            },
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              previewBtn,
                              if (canEditRow) ...[
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    size: 18,
                                    color: AppTheme.primary,
                                  ),
                                  tooltip: 'Edit Item',
                                  onPressed: () =>
                                      showAddItemDialog(context, item),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 18,
                                    color: AppTheme.danger,
                                  ),
                                  tooltip: 'Hapus Item',
                                  onPressed: () => deleteItem(itemId),
                                ),
                              ],
                              if (!canEditRow &&
                                  isManager &&
                                  isSubmittedState) ...[
                                if (itemStatus == 'pending' ||
                                    itemStatus == 'submitted')
                                  IconButton(
                                    icon: const Icon(
                                      Icons.check_rounded,
                                      size: 18,
                                      color: AppTheme.success,
                                    ),
                                    tooltip: 'Approve Item',
                                    onPressed: () => approveItem(itemId),
                                  ),
                                if (itemStatus == 'pending' ||
                                    itemStatus == 'submitted' ||
                                    itemStatus == 'approved')
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: AppTheme.danger,
                                    ),
                                    tooltip: 'Reject Item',
                                    onPressed: () => rejectItem(itemId),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAdvanceFundTransferSection(
    BuildContext context,
    Map<String, dynamic> advance,
    AuthProvider auth,
  ) {
    // SYARAT: Tabel 2 baru bisa diproses jika SEMUA item di Tabel 1 sudah status Approved
    final allItems = asMapList(advance['items']);
    final allApproved = allItems.isNotEmpty &&
        allItems.every((item) => item['status'] == 'approved');

    if (!allApproved) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.warning.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded, color: AppTheme.warning),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Belum semua item di-approve. Tabel pengiriman dana kasbon akan muncul setelah semua item approved.',
                style: TextStyle(color: primaryText(context)),
              ),
            ),
          ],
        ),
      );
    }

    final options = advanceFundSourceOptions(advance);
    final isManager = auth.isManager;

    final dbAdminFee = toDouble(advance['admin_fee']);
    final targetAdminFee = AppFormatters.formatCurrencyPlain(dbAdminFee);
    final adminFeeFormatted = targetAdminFee == '0' ? '' : targetAdminFee;
    if (adminFeeController.text != adminFeeFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (adminFeeController.text != adminFeeFormatted) {
          adminFeeController.text = adminFeeFormatted;
          adminFeeController.selection =
              TextSelection.collapsed(offset: adminFeeFormatted.length);
        }
      });
    }

    final dbDisbursed = toDouble(advance['disbursed_amount']);
    final approvedAmount = toDouble(advance['approved_amount']);
    final isTable2Modified = advance['modified_t2'] == true;
    final isTable2Approved = advance['is_disbursement_approved'] == true;
    final status = (advance['status'] ?? 'draft').toString().toLowerCase();
    final isSubmitted = status.contains('submitted') ||
        status == 'approved' ||
        status == 'completed';

    // FIX: Prioritaskan dbDisbursed jika dokumen sudah disubmit atau diapprove.
    // Hanya gunakan approvedAmount jika dokumen masih draft dan belum pernah diedit.
    final targetDisbursed =
        (isSubmitted || isTable2Approved || isTable2Modified || dbDisbursed > 0)
            ? dbDisbursed
            : approvedAmount;
    final targetDisbursedText =
        AppFormatters.formatCurrencyPlain(targetDisbursed);
    final disbursedFormatted =
        targetDisbursedText == '0' ? '' : targetDisbursedText;
    if (disbursedAmountController.text != disbursedFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursedAmountController.text != disbursedFormatted) {
          disbursedAmountController.text = disbursedFormatted;
          disbursedAmountController.selection =
              TextSelection.collapsed(offset: disbursedFormatted.length);
        }
      });
    }

    final dbReturned = toDouble(advance['returned_amount']);
    final targetReturnedText = AppFormatters.formatCurrencyPlain(dbReturned);
    final returnedFormatted =
        targetReturnedText == '0' ? '' : targetReturnedText;
    if (returnedAmountController.text != returnedFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (returnedAmountController.text != returnedFormatted) {
          returnedAmountController.text = returnedFormatted;
          returnedAmountController.selection =
              TextSelection.collapsed(offset: returnedFormatted.length);
        }
      });
    }

    disbursementDate ??=
        AppFormatters.parseDateFromApi(advance['created_at']) ?? DateTime.now();
    final disbursementDesc = displayAdvanceTitle(advance);
    final descFormatted = disbursementDesc;
    if (disbursementDescriptionController.text != descFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursementDescriptionController.text != descFormatted) {
          disbursementDescriptionController.text = descFormatted;
          disbursementDescriptionController.selection =
              TextSelection.collapsed(offset: descFormatted.length);
        }
      });
    }

    final disbursementComment =
        (advance['disbursement_comment'] ?? '').toString();
    final commentFormatted = disbursementComment;
    if (disbursementCommentController.text != commentFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursementCommentController.text != commentFormatted) {
          disbursementCommentController.text = commentFormatted;
          disbursementCommentController.selection =
              TextSelection.collapsed(offset: commentFormatted.length);
        }
      });
    }

    final mainStatus = (advance['status'] ?? 'draft').toString().toLowerCase();
    final isDisbursementApproved =
        (advance['is_disbursement_approved'] ?? false) ||
            mainStatus == 'completed' ||
            mainStatus == 'approved';
    final isDisbursementSubmitted =
        !isDisbursementApproved && mainStatus == 'submitted';
    final disbursementStatusLabel = isDisbursementApproved
        ? 'APPROVED'
        : isDisbursementSubmitted
            ? 'SUBMITTED'
            : 'PENDING';
    final disbursementStatusColor = statusColor(disbursementStatusLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        Row(
          children: [
            Text(
              'Tabel Pengiriman Dana Kasbon',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: creamColor(context),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: disbursementStatusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: disbursementStatusColor, width: 1),
              ),
              child: Text(
                disbursementStatusLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: disbursementStatusColor,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: cardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: dividerColor(context)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  surfaceColor(context),
                ),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return isDark(context)
                        ? AppTheme.cardHover
                        : AppTheme.lightCardHover;
                  }
                  return cardColor(context);
                }),
                dataRowMaxHeight: double.infinity,
                columns: [
                  DataColumn(label: headerText('No')),
                  DataColumn(label: headerText('Tanggal')),
                  DataColumn(label: headerText('Sumber Dana')),
                  DataColumn(label: headerText('Deskripsi')),
                  DataColumn(label: headerText('Amount')),
                  DataColumn(label: headerText('Biaya Admin')),
                  DataColumn(label: headerText('Evidence')),
                  DataColumn(label: headerText('Status')),
                  DataColumn(label: headerText('Comment')),
                  DataColumn(label: headerText('Aksi')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(
                        Text(
                            AppFormatters.formatDateForApi(disbursementDate!)),
                      ),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(
                            advanceDisbursementSourceLabel(advance) == '-'
                                ? 'Pilih Sumber Dana'
                                : advanceDisbursementSourceLabel(advance),
                          ),
                        ),
                      ),
                      DataCell(
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: Text(
                            disbursementDesc,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 140,
                          child: Text(
                            AppFormatters.formatCurrency(targetDisbursed),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 110,
                          child: Text(
                            AppFormatters.formatCurrency(dbAdminFee),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      DataCell(
                        buildDisbursementEvidenceCell(advance),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: disbursementStatusColor.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            disbursementStatusLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: disbursementStatusColor,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Builder(builder: (context) {
                          final comments = parsePlainComments(
                            advance['disbursement_comment'],
                          );
                          if (comments.isEmpty) return const Text('-');

                          return TextButton.icon(
                            onPressed: () => showPlainCommentsDialog(
                              comments,
                              title: 'Riwayat Komentar',
                            ),
                            icon: const Icon(Icons.comment_rounded, size: 14),
                            label: const Text(
                              'Lihat Komentar',
                              style: TextStyle(fontSize: 11),
                            ),
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          );
                        }),
                      ),
                      DataCell(
                        Builder(builder: (context) {
                          final mainStatus = (advance['status'] ?? 'draft')
                              .toString()
                              .toLowerCase();
                          final isSubmittedDoc = mainStatus == 'submitted' ||
                              mainStatus == 'submitted';
                          final isInDraftDoc = mainStatus == 'draft';
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.info_outline_rounded,
                                    size: 18, color: AppTheme.primary),
                                onPressed: () =>
                                    showDisbursementPreview(advance),
                                tooltip: 'Pratinjau Pengiriman Dana',
                              ),
                              if (isManager && isInDraftDoc && !isDisbursementApproved)
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    color: AppTheme.primary,
                                  ),
                                  onPressed: () {
                                    existingDisbursementPaths.clear();
                                    existingDisbursementPaths.addAll(
                                      (advance['disbursement_evidence_path']
                                                  ?.toString() ??
                                              '')
                                          .split('|')
                                          .where((p) => p.isNotEmpty),
                                    );
                                    existingDisbursementFilenames.clear();
                                    existingDisbursementFilenames.addAll(
                                      (advance['disbursement_evidence_filename']
                                                  ?.toString() ??
                                              '')
                                          .split('|')
                                          .where((f) => f.isNotEmpty),
                                    );
                                    showEditDisbursementDialog(
                                      advance,
                                      options,
                                    );
                                  },
                                  tooltip: 'Edit Rincian Pengiriman',
                                ),
                              if (isManager &&
                                  isSubmittedDoc &&
                                  !isDisbursementApproved &&
                                  (() {
                                    final isSourceValid =
                                        advanceDisbursementSourceLabel(
                                                    advance) !=
                                                '-' &&
                                            advanceDisbursementSourceLabel(
                                                    advance) !=
                                                'Pilih Sumber Dana';
                                    final isEvidenceValid = advance[
                                                'disbursement_evidence_path'] !=
                                            null &&
                                        advance['disbursement_evidence_path']
                                            .toString()
                                            .trim()
                                            .isNotEmpty;
                                    final isAmountValid =
                                        toDouble(advance['disbursed_amount']) >
                                            0;
                                    return isSourceValid &&
                                        isEvidenceValid &&
                                        isAmountValid;
                                  })())
                                IconButton(
                                  icon: const Icon(Icons.check_circle_rounded,
                                      size: 20, color: AppTheme.success),
                                  onPressed: () async {
                                    final messenger =
                                        ScaffoldMessenger.of(context);
                                    final prov =
                                        context.read<AdvanceProvider>();

                                    // FIX: Sinkronisasi data ke DB sebelum approve jika berbeda
                                    final syncedSource =
                                        advanceDisbursementSourceLabel(
                                            advance);
                                    final dbSource =
                                        (advance['disbursement_source'] ?? '')
                                            .toString();

                                    if (syncedSource != dbSource &&
                                        syncedSource != '-') {
                                      final selectedBankId =
                                          getBankIdFromSourceName(
                                              syncedSource);
                                      await prov.saveDisbursement(
                                        advanceId: widget.advanceId,
                                        bankId: selectedBankId,
                                        disbursementSource: syncedSource,
                                      );
                                    }

                                    try {
                                      final success =
                                          await prov.approveDisbursement(
                                              widget.advanceId);
                                      if (!mounted) return;
                                      if (success) {
                                        messenger.showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Tabel Pengiriman Dana disetujui ✓'),
                                              backgroundColor:
                                                  AppTheme.success),
                                        );
                                        await prov
                                            .loadAdvance(widget.advanceId);
                                        // Refresh balances immediately
                                        if (prov.currentAdvanceMap != null) {
                                          await fetchActiveAdvanceBalance(prov
                                              .currentAdvanceMap!['user_id']);
                                        }
                                      }
                                    } on InsufficientAdvanceBalanceException catch (e) {
                                      if (!mounted) return;
                                      showInsufficientBalanceDialog(e);
                                    }
                                  },
                                  tooltip: 'Setujui Pengiriman',
                                ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
