import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';

class AppDialogs {
  static void showEvidenceDialog(BuildContext context, String path,
      String? filename, String Function(String) getUrl) {
    final paths = path.split('|').where((p) => p.isNotEmpty).toList();
    final filenames =
        (filename ?? '').split('|').where((f) => f.isNotEmpty).toList();
    if (paths.isEmpty) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;
    final creamColor = isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Expanded(
              child: Text(
                paths.length > 1
                    ? 'Bukti ( file)'
                    : (filenames.isNotEmpty ? filenames[0] : 'Evidence'),
                style: TextStyle(color: creamColor, fontSize: 18),
              ),
            ),
            if (paths.length > 1)
              ElevatedButton.icon(
                onPressed: () async {
                  for (final p in paths) {
                    final url = getUrl(p);
                    final uri = Uri.parse(url);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri,
                          mode: LaunchMode.externalApplication);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  final url = getUrl(p);
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
                        await launchUrl(uri,
                            mode: LaunchMode.externalApplication);
                      }
                    },
                    child: Container(
                      width: 140,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: creamColor.withValues(alpha: 0.2)),
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
                                      headers: {'Authorization': 'Bearer '},
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2));
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
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
                            style: TextStyle(color: creamColor, fontSize: 10),
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

  static Future<bool> showExitConfirmation(
    BuildContext context, {
    required bool isLogout,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Helper colors
    final titleColor = isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
    final bodyColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 48, 8),
              child: Row(
                children: [
                  Icon(
                    isLogout ? Icons.logout_rounded : Icons.exit_to_app_rounded,
                    color: AppTheme.danger,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isLogout ? 'Logout' : 'Keluar Aplikasi',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(ctx, false),
                color: bodyColor.withValues(alpha: 0.5),
                splashRadius: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLogout
                  ? 'Apakah Anda yakin ingin keluar dari akun Anda?'
                  : 'Apakah Anda yakin ingin menutup aplikasi Exspan?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: bodyColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: AppTheme.danger.withValues(alpha: 0.4),
                ),
                child: Text(
                  isLogout ? 'Keluar Sekarang' : 'Tutup Aplikasi',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    return result ?? false;
  }

  static Future<bool> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Ya, Lanjutkan',
    String cancelLabel = 'Batal',
    Color confirmColor = AppTheme.primary,
    IconData icon = Icons.help_outline_rounded,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
    final bodyColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Row(
            children: [
              Icon(icon, color: confirmColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: bodyColor,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              cancelLabel,
              style: TextStyle(color: bodyColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
