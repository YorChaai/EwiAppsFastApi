import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class RoleDropdown extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const RoleDropdown({super.key, 
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;
    final surfaceColor = isDark ? AppTheme.surface : AppTheme.lightSurface;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final secondaryTextColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final dividerColor = isDark ? AppTheme.divider : AppTheme.lightDivider;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRole,
          isExpanded: true,
          dropdownColor: cardColor,
          style: TextStyle(color: textColor),
          icon: Icon(Icons.arrow_drop_down, color: secondaryTextColor),
          items: const [
            DropdownMenuItem(value: 'staff', child: Text('Staff')),
            DropdownMenuItem(value: 'mitra_eks', child: Text('Mitra')),
          ],
          onChanged: (value) {
            if (value != null) {
              onRoleChanged(value);
            }
          },
        ),
      ),
    );
  }
}
