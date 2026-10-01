import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailDialogsGeneralshowEvidenceExt
    on AdvanceDetailScreenState {
  void showEvidence(String path, String? filename) {
    final paths = path.split('|').where((p) => p.isNotEmpty).toList();
    final filenames =
        (filename ?? '').split('|').where((f) => f.isNotEmpty).toList();
    if (paths.isEmpty) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final prov = context.read<AdvanceProvider>();
    final token = context.read<AuthProvider>().token;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Expanded(
              child: Text(
                paths.length > 1
                    ? 'Bukti (${paths.length} file)'
                    : (filenames.isNotEmpty ? filenames[0] : 'Evidence'),
                style: TextStyle(color: creamColor(ctx), fontSize: 18),
              ),
            ),
            if (paths.length > 1)
              ElevatedButton.icon(
                onPressed: () async {
                  for (final p in paths) {
                    final url = prov.getEvidenceUrl(p);
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: const Text('Buka Semua'),
              ),
          ],
        ),
        content: SizedBox(
          width: screenWidth > 700 ? 700 : screenWidth * 0.95,
          child: SingleChildScrollView(
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: List.generate(paths.length, (index) {
                  final p = paths[index];
                  final name = filenames.length > index
                      ? filenames[index]
                      : p.split('/').last;
                  final url = prov.getEvidenceUrl(p);
                  final pLower = p.toLowerCase();
                  final isPdf = pLower.endsWith('.pdf');
                  final isImage = pLower.endsWith('.jpg') ||
                      pLower.endsWith('.jpeg') ||
                      pLower.endsWith('.png') ||
                      pLower.endsWith('.webp') ||
                      pLower.endsWith('.gif');

                  return InkWell(
                    onTap: () async {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor(ctx).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: creamColor(ctx).withValues(alpha: 0.2),
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
                            child: isImage
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      url,
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                      },
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                      errorBuilder: (ctx, error, stack) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  )
                                : Icon(
                                    isPdf
                                        ? Icons.picture_as_pdf_rounded
                                        : Icons.insert_drive_file_rounded,
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
                              color: creamColor(ctx),
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
