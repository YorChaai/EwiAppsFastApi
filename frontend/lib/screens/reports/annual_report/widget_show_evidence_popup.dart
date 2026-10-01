import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';


extension AnnualReportWidgetsshowEvidencePopupExt on AnnualReportScreenState {
  void showEvidencePopup(List<String> paths, List<String> displayNames) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: cardColor(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width > 700
                ? 700
                : MediaQuery.of(context).size.width * 0.95,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bukti (${paths.length} file)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: titleColor(context),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        for (final p in paths) {
                          await FileHelper.openFile(p);
                          // Jeda kecil agar Windows tidak "menelan" perintah berikutnya
                          await Future.delayed(
                              const Duration(milliseconds: 400));
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Buka Semua'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  child: Center(
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: paths.asMap().entries.map((entry) {
                        final i = entry.key;
                        final path = entry.value;
                        // Gunakan nama asli; fallback ke nama dari path
                        final name = (i < displayNames.length &&
                                displayNames[i].isNotEmpty)
                            ? displayNames[i]
                            : path.split('/').last;
                        final pLower = path.toLowerCase();
                        final isPdf = pLower.endsWith('.pdf');
                        final isImage = pLower.endsWith('.jpg') ||
                            pLower.endsWith('.jpeg') ||
                            pLower.endsWith('.png') ||
                            pLower.endsWith('.webp') ||
                            pLower.endsWith('.gif');

                        return Semantics(
                          button: true,
                          label: 'Buka File $name',
                          child: InkWell(
                            onTap: () => FileHelper.openFile(path),
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: cardColor(context).withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      titleColor(context).withValues(alpha: 0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      isPdf
                                          ? Icons.picture_as_pdf_rounded
                                          : (isImage
                                              ? Icons.image_rounded
                                              : Icons.insert_drive_file_rounded),
                                      size: 48,
                                      color: isPdf
                                          ? AppTheme.danger
                                          : AppTheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      color: titleColor(context),
                                      fontSize: 10,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
