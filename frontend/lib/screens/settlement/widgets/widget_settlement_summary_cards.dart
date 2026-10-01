import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/settlement_detail_widgets.dart';

class WidgetSettlementSummaryCards extends StatelessWidget {
  final Map<String, dynamic> settlement;
  final List<Map<String, dynamic>> expenses;
  final List<Map<String, dynamic>> userVirtualBalances;
  final NumberFormat currencyFormat;
  final double Function(Map<String, dynamic>) settlementReimbursementAmount;

  const WidgetSettlementSummaryCards({
    super.key,
    required this.settlement,
    required this.expenses,
    required this.userVirtualBalances,
    required this.currencyFormat,
    required this.settlementReimbursementAmount,
  });

  double toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final s = settlement;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;
        final double approvedAmt = toDouble(s['approved_amount']);

        // Hitung total hutang dari semua bank (Dompet Gabungan)
        final double currentTotalDebt = userVirtualBalances.fold(
            0.0, (sum, b) => sum + toDouble(b['balance']));

        final bool isCompleted =
            (s['status'] ?? '').toString().toLowerCase() == 'completed' ||
                (s['status'] ?? '').toString().toLowerCase() == 'approved';

        // Hitung proyeksi sisa per bank
        final Map<String, double> projectedPerBank = {};
        for (var b in userVirtualBalances) {
          projectedPerBank[b['bank_name'] ?? '-'] = toDouble(b['balance']);
        }


        if (!isCompleted) {
          for (var ex in expenses) {
            final st = (ex['status'] ?? '').toString().toLowerCase();
            if (st == 'approved' || st == 'completed') {
              final source =
                  (ex['source_bank_name'] ?? ex['source'] ?? '').toString();
              for (var bankKey in projectedPerBank.keys) {
                if (source.toLowerCase() == bankKey.toLowerCase() ||
                    source.toLowerCase().contains(bankKey.toLowerCase())) {
                  projectedPerBank[bankKey] = projectedPerBank[bankKey]! -
                      toDouble(ex['idr_amount'] ?? ex['amount']);
                  break;
                }
              }
            }
          }

          final returnSource = (s['return_source'] ?? '').toString();
          if (projectedPerBank.containsKey(returnSource)) {
            projectedPerBank[returnSource] = projectedPerBank[returnSource]! -
                toDouble(s['returned_amount']);
          }
        }

        final double projectedTotalDebt = isCompleted
            ? currentTotalDebt
            : projectedPerBank.values
                .fold(0.0, (sum, val) => sum + (val > 0 ? val : 0.0));

        final double totalAmt = expenses.fold<double>(
            0.0,
            (sum, e) =>
                sum + toDouble(e['amount'] ?? e['idr_amount'] ?? 0));
        final double approvedExpensesAmt = expenses
            .where((e) =>
                e['status'] == 'approved' || e['status'] == 'completed')
            .fold<double>(
                0.0,
                (sum, e) =>
                    sum + toDouble(e['amount'] ?? e['idr_amount'] ?? 0));
        final double effectiveApproved =
            approvedAmt > 0 ? approvedAmt : approvedExpensesAmt;
        final double reimbAmt = settlementReimbursementAmount(s);

        final cards = [
          SummaryCard(
            icon: Icons.receipt_long_rounded,
            label: 'Total',
            value: currencyFormat.format(totalAmt),
            color: AppTheme.primary,
          ),
          SummaryCard(
            icon: Icons.check_circle_rounded,
            label: 'Approved',
            value: currencyFormat.format(effectiveApproved),
            color: AppTheme.success,
          ),
          SummaryCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Reimbursement',
            value: currencyFormat.format(reimbAmt),
            color: AppTheme.warning,
          ),
          SummaryCard(
            icon: Icons.list_alt_rounded,
            label: 'Expense',
            value: '${expenses.length} item',
            color: AppTheme.accent,
          ),
          if (currentTotalDebt > 0)
            SummaryCard(
              icon: Icons.warning_amber_rounded,
              label: 'Outstanding Debt',
              value: currencyFormat.format(projectedTotalDebt),
              color: projectedTotalDebt > 0 ? AppTheme.danger : AppTheme.success,
            ),
          if (toDouble(s['returned_amount']) > 0)
            SummaryCard(
              icon: Icons.assignment_return_rounded,
              label: 'Refund',
              value: currencyFormat.format(toDouble(s['returned_amount'])),
              color: AppTheme.success,
            ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards
            if (isNarrow)
              Column(
                children: [
                  ...cards
                      .expand((c) => [c, const SizedBox(height: 8)])
                      .toList()
                    ..removeLast(),
                ],
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: cards
                    .map((c) => SizedBox(
                        width: constraints.maxWidth /
                                (cards.length > 4 ? 3 : cards.length) -
                            16,
                        child: c))
                    .toList(),
              ),

            const SizedBox(height: 12),

            // Metadata
            Wrap(
              spacing: 16,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Dibuat oleh: ${s['user_name'] ?? s['user_full_name'] ?? s['user']?['full_name'] ?? s['creator_name'] ?? '-'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      s['created_at'] != null
                          ? s['created_at'].toString().substring(0, 10)
                          : '-',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Laporan Tahunan: ${s['report_year'] ?? DateTime.now().year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
