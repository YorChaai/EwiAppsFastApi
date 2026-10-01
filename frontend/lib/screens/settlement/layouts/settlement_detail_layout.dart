
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/layouts/settlement_detail_tables.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_add_expense.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_checklist.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_evidence.dart';
import 'package:expense_app/screens/settlement/widgets/widget_settlement_detail_actions.dart';

import 'package:expense_app/screens/settlement/widgets/widget_settlement_summary_cards.dart';
import 'package:expense_app/screens/settlement/widgets/widget_settlement_expense_table.dart';

extension SettlementDetailLayoutExt on SettlementDetailScreenState {
  Widget buildMobileSettlementActionBar(
    BuildContext context,
    Map<String, dynamic> s,
    AuthProvider auth,
    String settlementStatus,
  ) {
    final actions = buildSettlementDetailActions(
      context,
      s,
      auth,
      settlementStatus,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: getSurfaceColor(context),
        border: Border(
          bottom:
              BorderSide(color: getDividerColor(context).withValues(alpha: 0.6)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (selectedExpenses.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: bulkDeleteExpenses,
                  icon: const Icon(Icons.delete_sweep, color: AppTheme.danger),
                  tooltip: 'Hapus ${selectedExpenses.length} item pilihan',
                ),
              ),
            ...actions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: action,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContent(
    BuildContext context,
    Map<String, dynamic> s,
    AuthProvider auth,
    SettlementProvider prov,
  ) {
    final expenses = List<Map<String, dynamic>>.from(s['expenses'] ?? []);
    final policyWarnings = List<String>.from(s['policy_warnings'] ?? []);
    final isSingleSettlement =
        (s['settlement_type'] ?? 'single').toString().toLowerCase() == 'single';
    final canAddExpenses =
        (auth.user?['id']?.toString() == s['user_id']?.toString() ||
                auth.isManager) &&
            (s['status'] == 'draft' || s['status'] == 'rejected') &&
            !(isSingleSettlement && expenses.isNotEmpty);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // kartu ringkasan & metadata
          WidgetSettlementSummaryCards(
            settlement: s,
            expenses: expenses,
            userVirtualBalances: userVirtualBalances,
            currencyFormat: currencyFormat,
            settlementReimbursementAmount: settlementReimbursementAmount,
          ),
          if (userVirtualBalances.isNotEmpty) ...[
            const SizedBox(height: 16),
            Builder(builder: (context) {
              // Hitung proyeksi sisa per bank
              final Map<String, double> projectedPerBank = {};
              for (var b in userVirtualBalances) {
                projectedPerBank[b['bank_name'] ?? '-'] =
                    toDouble(b['balance']);
              }

              final bool isCompleted =
                  (s['status'] ?? '').toString().toLowerCase() == 'completed' ||
                      (s['status'] ?? '').toString().toLowerCase() ==
                          'approved';

              if (!isCompleted) {
                // Kurangi dengan item yang sudah di-approve
                for (var ex in expenses) {
                  final st = (ex['status'] ?? '').toString().toLowerCase();
                  if (st == 'approved' || st == 'completed') {
                    final source = (ex['source_bank_name'] ?? ex['source'] ?? '').toString();
                    for (var bankKey in projectedPerBank.keys) {
                      if (source.toLowerCase() == bankKey.toLowerCase() ||
                          source.toLowerCase().contains(bankKey.toLowerCase())) {
                        projectedPerBank[bankKey] = projectedPerBank[bankKey]! - toDouble(ex['idr_amount']);
                        break;
                      }
                    }
                  }
                }

                // Kurangi dengan pengembalian tunai (Tabel 3) jika ada bank terpilih
                final returnSource = (s['return_source'] ?? '').toString();
                if (projectedPerBank.containsKey(returnSource)) {
                  projectedPerBank[returnSource] =
                      projectedPerBank[returnSource]! -
                          toDouble(s['returned_amount']);
                }
              }

              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.danger.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppTheme.danger.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_wallet_rounded,
                            size: 18, color: AppTheme.danger),
                        const SizedBox(width: 8),
                        const Text(
                          'Dompet Kasbon / Hutang Anda (Proyeksi):',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.danger),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: userVirtualBalances.map((b) {
                        final bankName = b['bank_name']?.toString() ?? '-';
                        final currentBal = toDouble(b['balance']);
                        final projectedBal = (projectedPerBank[bankName] ?? 0.0)
                            .clamp(0.0, double.infinity);

                        final isSettled = projectedBal < currentBal;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: getCardColor(context),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: isSettled
                                    ? AppTheme.success.withValues(alpha: 0.5)
                                    : AppTheme.divider.withValues(alpha: 0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bankName,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: getSecondaryText(context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rp ${AppFormatters.formatCurrencyPlain(currentBal)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isSettled
                                          ? getSecondaryText(context)
                                          : AppTheme.danger,
                                      decoration: isSettled
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                  if (isSettled) ...[
                                    const Icon(Icons.arrow_right_alt_rounded,
                                        size: 16, color: AppTheme.success),
                                    Text(
                                      'Rp ${AppFormatters.formatCurrencyPlain(projectedBal)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.success,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (policyWarnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...policyWarnings.map(
              (warning) => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  warning,
                  style: TextStyle(color: getCreamColor(context)),
                ),
              ),
            ),
          ],

          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                'Rincian Item Settlement',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getCreamColor(context),
                ),
              ),
              if (expenses.isNotEmpty) ...[
                const SizedBox(width: 12),
                Builder(builder: (context) {
                  final mainStatus =
                      (s['status'] ?? 'draft').toString().toLowerCase();

                  String badgeText = 'PENDING';
                  Color badgeColor = AppTheme.warning;

                  bool hasRejected = expenses.any((i) =>
                      (i['status'] ?? '').toString().toLowerCase() ==
                      'rejected');
                  bool allApproved = (expenses.isNotEmpty &&
                          expenses.every((i) => [
                                'approved',
                                'completed',
                                'in_settlement'
                              ].contains((i['status'] ?? '')
                                  .toString()
                                  .toLowerCase()))) ||
                      ['completed', 'approved'].contains(mainStatus);
                  bool allSubmitted = (expenses.isNotEmpty &&
                          expenses.every((i) =>
                              (i['status'] ?? '').toString().toLowerCase() ==
                              'submitted')) ||
                      ['submitted', 'revision_submitted'].contains(mainStatus);

                  if (hasRejected) {
                    badgeText = 'REJECTED';
                    badgeColor = AppTheme.danger;
                  } else if (allApproved) {
                    badgeText = 'APPROVED';
                    badgeColor = AppTheme.success;
                  } else if (allSubmitted) {
                    badgeText = 'SUBMITTED';
                    badgeColor =
                        AppTheme.primary; // Blue (Konsisten dengan Kasbon)
                  }

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: badgeColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  );
                }),
              ],
            ],
          ),
          const SizedBox(height: 16),

          // tabel expense
          WidgetSettlementExpenseTable(
            expenses: expenses,
            selectedExpenses: selectedExpenses,
            canAddExpenses: canAddExpenses,
            expenseTableVerticalCtrl: expenseTableVerticalCtrl,
            expenseTableHorizontalCtrl: expenseTableHorizontalCtrl,
            s: s,
            auth: auth,
            buildEmptyState: (canAdd) => buildEmptyState(canAdd),
            onSelectChanged: (expId, selected) {
              updateState(() {
                if (selected) {
                  selectedExpenses.add(expId);
                } else {
                  selectedExpenses.remove(expId);
                }
              });
            },
            buildPendingRichText: buildPendingRichText,
            formatExpenseAmount: formatExpenseAmount,
            expenseFundSource: expenseFundSource,
            showEvidence: showEvidence,
            getStatusColor: getStatusColor,
            showChecklistDialog: showChecklistDialog,
            buildActionCell: buildActionCell,
          ),
          const SizedBox(height: 20),
          buildFundTransferSection(context, s, auth),
          const SizedBox(height: 100), // Padding extra agar tidak tertabrak FAB
        ],
      ),
    );
  }

  Widget headerText(String label) {
    return Text(
      label,
      style:
          TextStyle(fontWeight: FontWeight.w600, color: getCreamColor(context)),
    );
  }

  Widget buildAddCommentButton(
    List<Map<String, dynamic>> list,
    StateSetter setModalState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          final focusNode = FocusNode();
          setModalState(() {
            list.add({
              'text': '',
              'checked': false,
              'focusNode': focusNode,
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            focusNode.requestFocus();
          });
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Tambah komentar'),
      ),
    );
  }

  Widget buildEmptyState(bool canAddItems) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:
            Border.all(color: getDividerColor(context), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: getSecondaryText(context),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada expense ditambahkan',
            style: TextStyle(color: getSecondaryText(context)),
          ),
          if (canAddItems) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => showAddExpenseDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Item Sekarang'),
            ),
          ],
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
          color: getPrimaryText(context),
          fontSize: 13,
          fontFamily: 'Inter',
        ),
        children: spans,
      ),
    );
  }

  Widget buildTabButton(String label, bool active, VoidCallback onTap,
      {bool isDisabled = false}) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppTheme.primary
              : (isDisabled
                  ? Colors.grey.withValues(alpha: 0.2)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active
                ? AppTheme.primary
                : (isDisabled ? Colors.transparent : getDividerColor(context)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active
                ? Colors.white
                : (isDisabled
                    ? getSecondaryText(context).withValues(alpha: 0.5)
                    : getSecondaryText(context)),
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
