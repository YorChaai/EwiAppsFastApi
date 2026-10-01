import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';
import 'package:expense_app/screens/reports/annual_report/widget_card.dart';


extension AnnualReportWidgetsSummaryCardsExt on AnnualReportScreenState {
  Widget buildSummaryCards(bool useCompact) {
    final revTotal = toDouble(
      reportData?['revenue']?['total_amount_received'] ?? 0,
    );
    final taxTotal = toDouble(reportData?['tax']?['total_ppn'] ?? 0) +
        toDouble(reportData?['tax']?['total_pph21'] ?? 0) +
        toDouble(reportData?['tax']?['total_pph23'] ?? 0) +
        toDouble(reportData?['tax']?['total_pph26'] ?? 0);
    final opTotal = toDouble(
      reportData?['operation_cost']?['total_expenses'] ?? 0,
    );
    final cards = [
      buildCard('Pemasukan', revTotal, Colors.green, useCompact),
      buildCard('Pajak', taxTotal, Colors.orange, useCompact),
      buildCard('Pengeluaran', opTotal, AppTheme.primary, useCompact),
    ];
    return useCompact
        ? Column(
            children: cards
                .map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: c,
                  ),
                )
                .toList(),
          )
        : Row(
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
  }
}
