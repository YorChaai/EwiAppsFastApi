import 'package:flutter/material.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/layouts/advance_detail_tables.dart';
import 'package:expense_app/screens/advance/widgets/widget_empty_state.dart';
import 'package:expense_app/screens/advance/widgets/widget_warning_box.dart';
import 'package:expense_app/screens/widgets/settlement_detail_widgets.dart';

extension AdvanceDetailLayoutContentExt on AdvanceDetailScreenState {
  Widget buildContent(
    BuildContext context,
    Map<String, dynamic> adv,
    AuthProvider auth,
    AdvanceProvider prov,
    List<Map<String, dynamic>> items,
  ) {
    final approved = adv['approved_amount'] ?? 0;
    final warnings = List<String>.from(adv['policy_warnings'] ?? []);
    final canEditItems =
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
            [
              'draft',
              'rejected',
              'revision',
              'rejected',
            ].contains(adv['status']);

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 600 ||
        Theme.of(context).platform == TargetPlatform.android;

    return Padding(
      padding: EdgeInsets.all(useCompact ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;
              final currentTotal = items.fold(0.0, (sum, item) {
                final estimated = (item['estimated_amount'] ?? 0) as num;
                final kurs = (item['currency_exchange'] ?? 1.0) as num;
                final idrStr = item['idr_amount'];
                final idr =
                    (idrStr is num && idrStr > 0) ? idrStr : (estimated * kurs);
                return sum + idr.toDouble();
              });

              final double disbursed = toDouble(adv['disbursed_amount']);
              // Hitung netting: jika approved > disbursed, selisihnya adalah outstanding (saldo virtual/potongan)
              final double outstandingDebt = (approved - disbursed).abs() > 1.0
                  ? (approved - disbursed)
                  : 0.0;

              final cards = [
                SummaryCard(
                  icon: Icons.receipt_long_rounded,
                  label: 'Total',
                  value: AppFormatters.formatCurrency(currentTotal),
                  color: AppTheme.primary,
                ),
                SummaryCard(
                  icon: Icons.verified_rounded,
                  label: 'Approved',
                  value: AppFormatters.formatCurrency(approved),
                  color: AppTheme.success,
                ),
                if (outstandingDebt > 0.01)
                  SummaryCard(
                    icon: Icons.history_rounded,
                    label: 'Outstanding',
                    value: AppFormatters.formatCurrency(outstandingDebt),
                    color: AppTheme.danger,
                  ),
                SummaryCard(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Reimbursement',
                  value: AppFormatters.formatCurrency(disbursed),
                  color: AppTheme.warning,
                ),
                SummaryCard(
                  icon: Icons.list_alt_rounded,
                  label: 'Expense',
                  value: '${items.length} item',
                  color: AppTheme.accent,
                ),
                SummaryCard(
                  icon: Icons.list_alt_rounded,
                  label: 'Expense',
                  value: '${items.length} item',
                  color: AppTheme.accent,
                ),
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cards
                  if (isNarrow)
                    Column(
                      children: cards
                          .expand((c) => [c, const SizedBox(height: 8)])
                          .toList()
                        ..removeLast(),
                    )
                  else
                    Row(
                      children: cards
                          .expand((c) =>
                              [Expanded(child: c), const SizedBox(width: 12)])
                          .toList()
                        ..removeLast(),
                    ),

                  const SizedBox(height: 12),

                  // Detail metadatata
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: secondaryText(context),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Dibuat oleh: ${adv['requester_name'] ?? '-'}',
                            style: TextStyle(color: secondaryText(context)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: secondaryText(context),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            adv['created_at'] != null
                                ? adv['created_at'].toString().substring(0, 10)
                                : '-',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            color: secondaryText(context),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Laporan Tahunan: ${adv['report_year'] ?? '-'}',
                            style: TextStyle(color: secondaryText(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (adv['notes'] != null && adv['notes'].toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: AppTheme.warning, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      adv['notes'],
                      style: TextStyle(color: creamColor(context)),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...warnings.map(buildWarningBox),
          ],

          Builder(builder: (context) {
            final rawCashComposition = adv['cash_composition'];
            // Prioritaskan officeBankBalances (data real terbaru) untuk box biru
            final officeComposition = officeBankBalances.isNotEmpty
                ? officeBankBalances
                : rawCashComposition is Map
                    ? Map<String, dynamic>.from(rawCashComposition)
                    : <String, dynamic>{};

            if (officeComposition.isEmpty &&
                userCashComposition.isEmpty &&
                activeAdvanceBalance <= 0) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (officeComposition.isNotEmpty)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                      Icons.account_balance_wallet_rounded,
                                      size: 18,
                                      color: AppTheme.primary),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Saldo Bank Advance:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppTheme.primary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: officeComposition.entries
                                    .map((e) {
                                      final amount = toDouble(e.value);
                                      if (amount <= 0) {
                                        return const SizedBox.shrink();
                                      }
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: cardColor(context),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: AppTheme.divider
                                                  .withValues(alpha: 0.1)),
                                        ),
                                        child: Text(
                                          '${e.key}: Rp ${AppFormatters.formatCurrencyPlain(amount)}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: primaryText(context),
                                          ),
                                        ),
                                      );
                                    })
                                    .where((w) => w is! SizedBox)
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (officeComposition.isNotEmpty &&
                        activeAdvanceBalance > 0)
                      const SizedBox(width: 12),
                    if (activeAdvanceBalance > 0)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.danger.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppTheme.danger.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      size: 18, color: AppTheme.danger),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Dompet Kasbon / Hutang Anda:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: AppTheme.danger),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (userCashComposition.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: userCashComposition.entries
                                      .map((e) {
                                        final amount = toDouble(e.value);
                                        if (amount <= 0) {
                                          return const SizedBox.shrink();
                                        }
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: cardColor(context),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: AppTheme.divider
                                                    .withValues(alpha: 0.1)),
                                          ),
                                          child: Text(
                                            '${e.key}: Rp ${AppFormatters.formatCurrencyPlain(amount)}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.danger,
                                            ),
                                          ),
                                        );
                                      })
                                      .where((w) => w is! SizedBox)
                                      .toList(),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: cardColor(context),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        color: AppTheme.divider
                                            .withValues(alpha: 0.1)),
                                  ),
                                  child: Text(
                                    'Rp ${AppFormatters.formatCurrencyPlain(activeAdvanceBalance)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.danger,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),

          const SizedBox(height: 28),
          Row(
            children: [
              Text(
                'Rincian Item Kasbon',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor(context),
                ),
              ),
              if (items.isNotEmpty) ...[
                const SizedBox(width: 12),
                Builder(builder: (context) {
                  final mainStatus =
                      (adv['status'] ?? 'draft').toString().toLowerCase();

                  String badgeText = 'PENDING';
                  Color badgeColor = AppTheme.warning;

                  bool hasRejected = items.any((i) =>
                      (i['status'] ?? '').toString().toLowerCase() ==
                      'rejected');
                  bool allApproved = (items.isNotEmpty &&
                          items.every((i) => [
                                'approved',
                                'completed',
                                'in_settlement'
                              ].contains((i['status'] ?? '')
                                  .toString()
                                  .toLowerCase()))) ||
                      ['completed', 'approved'].contains(mainStatus);
                  bool allSubmitted = (items.isNotEmpty &&
                          items.every((i) =>
                              (i['status'] ?? '').toString().toLowerCase() ==
                              'submitted')) ||
                      ['submitted', 'submitted'].contains(mainStatus);

                  if (hasRejected) {
                    badgeText = 'REJECTED';
                    badgeColor = AppTheme.danger;
                  } else if (allApproved) {
                    badgeText = 'APPROVED';
                    badgeColor = AppTheme.success;
                  } else if (allSubmitted) {
                    badgeText = 'SUBMITTED';
                    badgeColor = AppTheme.primary; // Blue (Konsisten)
                  }

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: badgeColor, width: 1),
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
          if (items.isEmpty)
            buildEmptyState(canEditItems)
          else
            buildItemsTable(items, adv, auth),
          const SizedBox(height: 20),
          buildAdvanceFundTransferSection(context, adv, auth),
          SizedBox(
            height: useCompact ? 80 : 100,
          ), // Padding extra agar tidak tertabrak FAB
        ],
      ),
    );
  }
}
