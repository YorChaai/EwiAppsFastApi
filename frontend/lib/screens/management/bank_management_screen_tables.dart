import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';


extension BankManagementTablesExt on BankManagementScreenState {
  Widget buildLogGridItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 10, color: AppTheme.getSecondaryTextColor(context))),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.getTextColor(context))),
      ],
    );
  }
}
