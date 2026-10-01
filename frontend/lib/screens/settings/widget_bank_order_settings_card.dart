import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/dialog_custom_bank_order.dart';

extension SettingsLayoutBankOrderSettingsCardExt on SettingsScreenState {
  Widget buildBankOrderSettingsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: dividerColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.swap_vert_circle_rounded,
                  color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Urutan Tampilan Bank & Advance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: titleColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Kustomisasi posisi atas/bawah untuk setiap kartu Bank Cash (Kas Riil) dan daftar staf Bank Advance (Kas Virtual) sesuai preferensi Anda dengan sistem drag & drop.',
            style: TextStyle(
              fontSize: 13,
              color: bodyColor(context),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const DialogCustomBankOrder(),
              );
            },
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text('Atur Urutan (Drag & Drop)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
