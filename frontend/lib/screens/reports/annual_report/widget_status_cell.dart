import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';


extension AnnualReportWidgetsStatusCellExt on AnnualReportScreenState {
  Widget buildStatusCell(String text, double width, Color color) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11 * zoomLevel),
        ),
      ),
    );
  }
}
