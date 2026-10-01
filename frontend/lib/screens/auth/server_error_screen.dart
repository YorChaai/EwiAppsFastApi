import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_brand_logo.dart';

class ServerErrorScreen extends StatefulWidget {
  const ServerErrorScreen({super.key});

  @override
  State<ServerErrorScreen> createState() => ServerErrorScreenState();
}

class ServerErrorScreenState extends State<ServerErrorScreen> {
  final serverUrlController = TextEditingController();
  bool isRetrying = false;

  @override
  void initState() {
    super.initState();
    serverUrlController.text = ApiService.baseUrl;
  }

  @override
  void dispose() {
    serverUrlController.dispose();
    super.dispose();
  }

  Future<void> showServerUrlDialog() async {
    serverUrlController.text = ApiService.baseUrl;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Server URL',
          style: TextStyle(
              color: isDark ? AppTheme.cream : AppTheme.lightTextPrimary),
        ),
        content: TextField(
          controller: serverUrlController,
          decoration: const InputDecoration(
            labelText: 'API Base URL',
            hintText: 'http://192.168.1.8:8000/api',
          ),
          style: TextStyle(
              color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiService.saveBaseUrl('');
              if (!context.mounted) return;
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Default'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.saveBaseUrl(serverUrlController.text);
              if (!context.mounted) return;
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> retry() async {
    setState(() => isRetrying = true);
    final auth = context.read<AuthProvider>();
    await auth.retryInitialization();
    if (!mounted) return;
    setState(() => isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppBrandLogo(size: 80),
                const SizedBox(height: 32),
                const Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: AppTheme.danger,
                ),
                const SizedBox(height: 24),
                Text(
                  'Koneksi Gagal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tidak dapat terhubung ke server.\nPastikan IP Server sudah benar dan Server sudah menyala.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.black : Colors.white)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? AppTheme.divider : AppTheme.lightDivider)
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Server saat ini:',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ApiService.baseUrl,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.accent,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    OutlinedButton.icon(
                      onPressed: showServerUrlDialog,
                      icon: const Icon(Icons.settings_outlined),
                      label: const Text('Ganti IP'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: isRetrying || auth.loading ? null : retry,
                      icon: isRetrying || auth.loading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
