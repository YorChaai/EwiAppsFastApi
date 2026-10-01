import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class CustomBackButton extends StatelessWidget {
  final VoidCallback onBack;
  final bool compact;

  const CustomBackButton({super.key, 
    required this.onBack,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back, size: 18),
        label: Text(
          compact ? 'Kembali ke Login' : 'Sudah punya akun? Kembali ke Login',
          style: const TextStyle(fontSize: 14),
        ),
        style: TextButton.styleFrom(
          foregroundColor: AppTheme.textSecondary,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
