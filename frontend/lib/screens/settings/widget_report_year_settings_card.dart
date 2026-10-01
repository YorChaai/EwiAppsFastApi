import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';


extension SettingsLayoutReportYearSettingsCardExt on SettingsScreenState {
  Widget buildReportYearSettingsCard() {
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
              const Icon(Icons.calendar_month_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Default Tahun Laporan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: surfaceColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: dividerColor(context)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: currentReportYear,
                isExpanded: true,
                dropdownColor: cardColor(context),
                style: TextStyle(color: titleColor(context)),
                items: [
                  const DropdownMenuItem(
                    value: 0,
                    child: Text('Default (Sesuai Tahun Berjalan)'),
                  ),
                  ...List.generate(21, (index) => 2020 + index).map(
                    (y) =>
                        DropdownMenuItem(value: y, child: Text('Laporan $y')),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    updateState(() => currentReportYear = value);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: loading ? null : saveReportYearSettings,
              icon: const Icon(Icons.save_rounded),
              label: const Text(
                'Simpan Default Tahun',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
