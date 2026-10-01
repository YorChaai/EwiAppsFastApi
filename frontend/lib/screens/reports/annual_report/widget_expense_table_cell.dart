import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/widget_status_cell.dart';
import 'package:expense_app/screens/reports/annual_report/widget_tax_toggle_cell.dart';
import 'package:expense_app/screens/reports/annual_report/widget_evidence_button.dart';


extension AnnualReportWidgetsExpenseTableCellExt on AnnualReportScreenState {
  Widget buildExpenseTableCell({
    required String value,
    required double width,
    required bool useCompact,
    required bool isBold,
    required TextAlign textAlign,
    required int index,
    double? fontSize,
    bool isLast = false,
    bool noBottomBorder = false,
  }) {
    // 🛡️ FITUR BARU: Handle Toggle Pajak PPH 23
    if (value.startsWith('[TOGGLE_TAX]:')) {
      return buildTaxToggleCell(
          value.replaceFirst('[TOGGLE_TAX]:', ''), width, useCompact);
    }

    // 🛡️ FITUR BARU: Handle Status Keamanan (Green/Red)
    if (value == 'AMAN (Kurang Bayar)') {
      return buildStatusCell(value, width, Colors.green);
    } else if (value == 'BAHAYA (Restitusi/Audit)') {
      return buildStatusCell(value, width, Colors.red);
    }

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(
        horizontal: (useCompact ? 8.0 : 10.0) * zoomLevel,
        vertical: (useCompact ? 8.0 : 10.0) * zoomLevel,
      ),
      alignment: switch (textAlign) {
        TextAlign.right => Alignment.centerRight,
        TextAlign.center => Alignment.center,
        _ => Alignment.centerLeft,
      },
      decoration: BoxDecoration(
        border: Border(
          bottom: (noBottomBorder || isBold)
              ? BorderSide.none
              : BorderSide(
                  color: dividerColor(context).withValues(alpha: 0.4),
                  width: 1.0,
                ),
          left: index == 0
              ? BorderSide(
                  color: dividerColor(context).withValues(alpha: 0.4),
                  width: 1.0,
                )
              : BorderSide.none,
          right: isLast
              ? BorderSide.none
              : BorderSide(
                  color: dividerColor(context).withValues(alpha: 0.4),
                  width: 1.0,
                ),
        ),
      ),
      child: value.startsWith('[EVIDENCE]:')
          ? buildEvidenceButton(value.replaceFirst('[EVIDENCE]:', ''))
          : Tooltip(
              message: value,
              preferBelow: false,
              child: Text(
                value,
                textAlign: textAlign,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontSize: (fontSize ?? 13) * zoomLevel,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? titleColor(context) : primaryText(context),
                  height: 1.1,
                ),
              ),
            ),
    );
  }
}
