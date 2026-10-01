import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';

extension ContextExtensions on BuildContext {
  // Theme Helpers
  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // Colors
  Color get surfaceColor => isDark ? AppTheme.surface : AppTheme.lightSurface;
  Color get cardColor => isDark ? AppTheme.card : AppTheme.lightCard;
  Color get creamColor => isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color get primaryText => isDark ? AppTheme.textPrimary : Colors.black87;
  Color get secondaryText => isDark ? AppTheme.textSecondary : Colors.black54;
  Color get bodyColor =>
      isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color get titleColor => isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color get dividerColor => isDark ? AppTheme.divider : AppTheme.lightDivider;

  // Layout Helpers
  double get screenWidth => MediaQuery.of(this).size.width;
  bool get useCompactLayout => screenWidth < 600 || isAndroid;
}
