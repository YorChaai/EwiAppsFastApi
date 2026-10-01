import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/screens/advance/advances_screen.dart';

extension AdvancesWidgetsYearSummaryCardExt on AdvancesScreenState {
  Widget buildYearSummaryCard(
    BuildContext context,
    int year,
    bool useCompact,
  ) {
    final total = annualAdvanceTotal ?? 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 750;

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
                year == 0 ? 'Permintaan Semua Tahun' : 'Permintaan Tahun $year',
                style: TextStyle(
                  color: bodyColor(context),
                  fontSize: useCompact ? 9 : 11,
                ),
              ),
              Text(
                'Rp ${NumberFormat("#,##0", "id_ID").format(total)}',
                style: TextStyle(
                  color: primaryText(context),
                  fontSize: useCompact ? 14 : 16,
                  fontWeight: FontWeight.w700,
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
