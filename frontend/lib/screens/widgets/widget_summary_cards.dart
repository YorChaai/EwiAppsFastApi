import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';

import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

extension MainLayoutWidgetsSummaryCardsExt on SettlementListViewState {
  Widget buildSummaryCards(bool isNarrow, bool useCompact) {
    final prov = context.read<SettlementProvider>();
    final targetYear = prov.filterYear;
    final total = annualSettlementTotal ?? 0.0;
    final card = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: useCompact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor(context)),
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
                  color: bodyColorLocal(context),
                ),
              ),
              Text(
                'Rp ${formatNumber(total)}',
                style: TextStyle(
                  fontSize: useCompact ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: titleColorLocal(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Gunakan Row + Expanded hanya jika layar lebar (desktop) untuk memenuhi ruang horizontal
    if (!isNarrow) {
      return Row(children: [Expanded(child: card)]);
    }
    return card;
  }
}
