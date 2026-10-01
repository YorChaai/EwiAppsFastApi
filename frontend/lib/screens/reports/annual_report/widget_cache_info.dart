import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';


extension AnnualReportWidgetsCacheInfoExt on AnnualReportScreenState {
  Widget buildCacheInfo(bool useCompact, {bool isCompact = false}) {
    final source = (reportData?['cache_source'] ?? '').toString();
    final generated = (reportData?['cache_generated_at'] ??
            reportData?['generated_at'] ??
            '')
        .toString();
    String label = (source == 'cache')
        ? 'CACHE (tidak hit DB)'
        : (source == 'refresh' ? 'REFRESH (DB terbaru)' : 'INIT');
    return Container(
      width: isCompact ? null : double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 12 : 16,
        vertical: isCompact ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: dividerColor(context)),
      ),
      child: Text(
        isCompact
            ? '$label | Generated: ${generated.length > 10 ? generated.substring(11, 16) : ''}'
            : 'Display Source: $label | Generated: ${fmtDate(generated)} ${generated.length > 10 ? generated.substring(11, 19).trim() : ''}',
        style: TextStyle(
          color: bodyColor(context),
          fontSize: useCompact || isCompact ? 11 : 13,
          height: 1.2,
        ),
      ),
    );
  }
}
