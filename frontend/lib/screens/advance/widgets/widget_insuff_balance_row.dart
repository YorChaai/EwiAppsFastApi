import 'package:flutter/material.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailLayoutinsuffBalanceRowExt on AdvanceDetailScreenState {
  Widget insuffBalanceRow(
      BuildContext ctx, String label, String value, Color valueColor,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: secondaryText(ctx), fontSize: 13)),
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
