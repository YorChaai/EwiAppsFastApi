import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';


extension AnnualReportWidgetsTaxToggleCellExt on AnnualReportScreenState {
  Widget buildTaxToggleCell(String raw, double width, bool useCompact) {
    final parts = raw.split('§');
    // final id = int.tryParse(parts[0]) ?? 0;
    final formattedValue = parts[1];
    // final isSelected = parts[2] == 'true';

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 4 * zoomLevel),
      alignment: Alignment.centerRight,
      child: Text(
        formattedValue,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 11 * zoomLevel,
          color: primaryText(context),
        ),
      ),
    );
  }
}
