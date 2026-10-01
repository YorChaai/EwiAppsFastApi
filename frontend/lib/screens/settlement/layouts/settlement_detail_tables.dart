
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/layouts/settlement_detail_layout.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_edit_expense.dart';
import 'package:expense_app/screens/settlement/settlement_detail_previews.dart';

extension SettlementDetailTablesExt on SettlementDetailScreenState {
  Widget buildFundTransferSection(
    BuildContext context,
    Map<String, dynamic> settlement,
    AuthProvider auth,
  ) {
    final approvedExpenses = approvedSettlementExpenses(settlement);
    final options = fundSourceOptions(settlement);
    final hasPendingItems =
        asMapList(settlement['expenses']).length != approvedExpenses.length;

    // SYARAT: Tabel 2 baru bisa diproses jika SEMUA item di Tabel 1 sudah status Approved
    final allExpenses = asMapList(settlement['expenses']);
    final allApproved = allExpenses.isNotEmpty &&
        allExpenses.every((item) =>
            item['status'] == 'approved' || item['status'] == 'completed');

    final totalApproved = approvedExpenses.fold<double>(
      0,
      (sum, e) =>
          sum + (double.tryParse(e['idr_amount']?.toString() ?? '0') ?? 0.0),
    );

    final double disbursedAmtDB = toDouble(settlement['disbursed_amount']);

    // Tentukan apakah T2 diperlukan:
    final double reimbAmt = settlementReimbursementAmount(settlement);
    final bool isModifiedT2 = settlement['modified_t2'] == true;
    final bool needsTable2 = (isModifiedT2 && disbursedAmtDB > 0.01) || reimbAmt > 0.01;

    if (!needsTable2) {
      return const SizedBox.shrink(); // T2 tidak diperlukan
    }

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
                'Belum semua item di-approve. Tabel pengiriman dana akan muncul setelah semua item approved.',
                style: TextStyle(color: getPrimaryText(context)),
              ),
            ),
          ],
        ),
      );
    }

    final mainStatus =
        (settlement['status'] ?? 'draft').toString().toLowerCase();
    final isDisbursementApproved =
        (settlement['is_disbursement_approved'] ?? false) ||
            mainStatus == 'completed';
    final initialSource = settlementDisbursementSourceLabel(settlement);

    final isDisbursementSubmitted =
        !isDisbursementApproved && mainStatus == 'submitted';
    final disbursementStatusLabel = isDisbursementApproved
        ? 'APPROVED'
        : isDisbursementSubmitted
            ? 'SUBMITTED'
            : 'PENDING';
    final disbursementStatusColor = getStatusColor(disbursementStatusLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tabel Pengiriman Dana',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: getCreamColor(context),
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
          ],
        ),
        if (hasPendingItems) ...[
          const SizedBox(height: 8),
          Text(
            'Hanya item approved yang ditampilkan di tabel verifikasi dana.',
            style: TextStyle(color: getSecondaryText(context), fontSize: 12),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: getCardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: getDividerColor(context)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  getSurfaceColor(context),
                ),
                dataRowColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return getIsDark(context)
                        ? AppTheme.cardHover
                        : AppTheme.lightCardHover;
                  }
                  return getCardColor(context);
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
                  buildDisbursementDataRow(
                    settlement,
                    approvedExpenses,
                    initialSource,
                    totalApproved,
                    isDisbursementApproved,
                    auth,
                    options,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildActionCell(
    Map<String, dynamic> exp,
    AuthProvider auth,
    Map<String, dynamic> s,
  ) {
    final settlementStatus = s['status'];
    final itemStatus = (exp['status'] ?? 'pending').toString().toLowerCase();
    final isOwner = auth.user?['id'] == s['user_id'];
    final isManager = auth.isManager;

    final previewBtn = IconButton(
      icon: Icon(Icons.info_outline_rounded, color: AppTheme.primary, size: 20),
      tooltip: 'Pratinjau Rincian Item',
      onPressed: () => showItemPreview(exp),
    );

    final isInDraft =
        settlementStatus == 'draft' || settlementStatus == 'rejected';

    if (isManager) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          previewBtn,
          if (isInDraft) ...[
            IconButton(
              icon: Icon(Icons.edit_rounded, color: AppTheme.accent, size: 20),
              tooltip: 'Edit',
              onPressed: () => showEditExpenseDialog(context, exp),
            ),
            IconButton(
              icon:
                  Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
              tooltip: 'Hapus',
              onPressed: () => deleteExpense(exp['id']),
            ),
          ],
          if (settlementStatus == 'submitted' ||
              settlementStatus == 'submitted') ...[
            if (itemStatus == 'pending' || itemStatus == 'submitted')
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: AppTheme.success,
                  size: 20,
                ),
                tooltip: 'Approve',
                onPressed: () => approveExpense(exp['id'], 'approve'),
              ),
            if (itemStatus == 'pending' ||
                itemStatus == 'submitted' ||
                itemStatus == 'approved')
              IconButton(
                icon:
                    Icon(Icons.close_rounded, color: AppTheme.danger, size: 20),
                tooltip: 'Reject',
                onPressed: () => approveExpense(exp['id'], 'reject'),
              ),
          ],
        ],
      );
    }

    if (isOwner && isInDraft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          previewBtn,
          IconButton(
            icon: Icon(Icons.edit_rounded, color: AppTheme.accent, size: 20),
            tooltip: 'Edit',
            onPressed: () => showEditExpenseDialog(context, exp),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppTheme.danger, size: 20),
            tooltip: 'Hapus',
            onPressed: () => deleteExpense(exp['id']),
          ),
        ],
      );
    }
    return previewBtn;
  }

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
                          color: getCreamColor(context),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tulis komentar...',
                          hintStyle: TextStyle(
                            color:
                                getSecondaryText(context).withValues(alpha: 0.5),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: getDividerColor(context),
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
                            color: getCreamColor(context)
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
                  tooltip: 'Hapus Item',
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
}
