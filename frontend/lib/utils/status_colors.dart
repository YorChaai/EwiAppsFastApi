import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';

/// Centralized status color definitions
class StatusColors {
  /// Get color for settlement/advance status
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppTheme.textSecondary;
      case 'submitted':
        return AppTheme.warning;
      case 'approved':
        return AppTheme.success;
      case 'completed':
        return AppTheme.success;
      case 'rejected':
        return AppTheme.danger;
      case 'revision':
        return AppTheme.warning;

      case 'in_settlement':
        return AppTheme.accent;
      default:
        return AppTheme.textSecondary;
    }
  }

  /// Get status display text
  static String getStatusDisplay(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return 'Draft';
      case 'submitted':
        return 'Submitted';
      case 'approved':
        return 'Approved';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'revision':
        return 'Revision Draft';

      case 'in_settlement':
        return 'In Settlement';
      default:
        return status;
    }
  }

  /// Get background color with alpha for status badge
  static Color getStatusBadgeColor(String status) {
    return getStatusColor(status).withValues(alpha: 0.15);
  }
}
