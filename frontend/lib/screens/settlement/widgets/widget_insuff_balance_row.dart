
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';


// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailinsuffBalanceRowExt on SettlementDetailScreenState {
  Widget insuffBalanceRow(
      BuildContext ctx, String label, String value, Color valueColor,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: getSecondaryText(ctx), fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
