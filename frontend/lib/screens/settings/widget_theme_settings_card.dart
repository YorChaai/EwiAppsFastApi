import 'package:flutter/material.dart';
import 'package:expense_app/providers/core/theme_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';


extension SettingsLayoutThemeSettingsCardExt on SettingsScreenState {
  Widget buildThemeSettingsCard(ThemeProvider themeProvider) {
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
              const Icon(Icons.palette_rounded, color: AppTheme.primary),
              const SizedBox(width: 12),
              Text(
                'Tema Aplikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: titleColor(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode_rounded, size: 16),
                  label: Text(
                    'Light',
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode_rounded, size: 16),
                  label: Text(
                    'Dark',
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  icon: Icon(Icons.settings_suggest_rounded, size: 16),
                  label: Text(
                    'System',
                    overflow: TextOverflow.visible,
                    softWrap: false,
                  ),
                ),
              ],
              selected: {themeProvider.themeMode},
              onSelectionChanged: (selection) =>
                  themeProvider.setThemeMode(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}
