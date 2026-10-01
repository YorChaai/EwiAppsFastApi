import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/utils/app_formatters.dart';

class WidgetSummaryCards extends StatelessWidget {
  final double annualSettlementTotal;
  final bool isNarrow;
  final bool useCompact;

  const WidgetSummaryCards({
    super.key,
    required this.annualSettlementTotal,
    required this.isNarrow,
    required this.useCompact,
  });

  Color _dividerColor(BuildContext context) =>
      context.isDark ? AppTheme.divider : AppTheme.lightDivider;
  Color _titleColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color _bodyColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

  @override
  Widget build(BuildContext context) {
    final prov = context.read<SettlementProvider>();
    final targetYear = prov.filterYear;
    final total = annualSettlementTotal;

    final card = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: useCompact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerColor(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(useCompact ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.teal,
              size: useCompact ? 18 : 20,
            ),
          ),
          SizedBox(width: useCompact ? 10 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                targetYear == 0
                    ? 'Pengeluaran Semua Tahun'
                    : 'Pengeluaran Tahun $targetYear',
                style: TextStyle(
                  fontSize: useCompact ? 9 : 11,
                  color: _bodyColorLocal(context),
                ),
              ),
              Text(
                'Rp ${AppFormatters.formatCurrencyPlain(total)}',
                style: TextStyle(
                  fontSize: useCompact ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: _titleColorLocal(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (!isNarrow) {
      return Row(children: [Expanded(child: card)]);
    }
    return card;
  }
}
