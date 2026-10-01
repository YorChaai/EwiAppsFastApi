import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/widget_show_evidence_popup.dart';


extension AnnualReportWidgetsEvidenceButtonExt on AnnualReportScreenState {
  Widget buildEvidenceButton(String rawValue) {
    // Format baru: "path1|path2§filename1|filename2"
    // Format lama (fallback): "path1|path2"
    final parts = rawValue.split('§');
    final rawPaths = parts[0];
    final rawNames = parts.length > 1 ? parts[1] : '';

    final List<String> paths = rawPaths
        .split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != 'null' && e != '-')
        .toList();

    if (paths.isEmpty) {
      return const Text('-', textAlign: TextAlign.center);
    }

    final nameList = rawNames.split('|').map((e) => e.trim()).toList();
    // Build display names: pakai original filename jika ada, jika tidak pakai
    // bagian akhir path (UUID) sebagai fallback
    final List<String> displayNames = List.generate(paths.length, (i) {
      final fn = (i < nameList.length) ? nameList[i] : '';
      if (fn.isNotEmpty && fn != 'null') return fn;
      // Fallback: ambil nama dari path
      return paths[i].split('/').last;
    });

    return IconButton(
      icon: Icon(Icons.image, color: AppTheme.primary, size: 20 * zoomLevel),
      onPressed: () => showEvidencePopup(paths, displayNames),
      tooltip: 'Lihat Bukti',
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}
