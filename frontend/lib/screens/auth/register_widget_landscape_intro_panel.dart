import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/register_widget_register_brand_icon.dart';


class LandscapeIntroPanel extends StatelessWidget {
  const LandscapeIntroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const RegisterBrandIcon(size: 58, iconSize: 30),
        const SizedBox(height: 18),
        const Text(
          'Daftar Akun Baru',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppTheme.cream,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Buat akun baru untuk mengakses aplikasi Exspan. Isi form dengan benar dan pilih role sesuai kebutuhan.',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Setelah daftar, kamu akan diarahkan ke halaman login.',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
