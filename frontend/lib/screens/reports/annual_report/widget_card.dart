import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';


extension AnnualReportWidgetsCardExt on AnnualReportScreenState {
  Widget buildCard(String title, double amount, Color color, bool useCompact) {
    return Container(
      padding: EdgeInsets.all(useCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor(context)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: bodyColor(context),
                    fontSize: useCompact ? 10 : 12,
                  ),
                ),
                Text(
                  fmtMoney(amount),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: useCompact ? 15 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.trending_up_rounded,
            color: color.withValues(alpha: 0.3),
            size: useCompact ? 20 : 24,
          ),
        ],
      ),
    );
  }
}
