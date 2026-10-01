import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class RegisterLink extends StatelessWidget {
  final VoidCallback onTap;

  const RegisterLink({super.key, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text(
          'Belum punya akun? Daftar sekarang',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.accent,
          ),
        ),
      ),
    );
  }
}
