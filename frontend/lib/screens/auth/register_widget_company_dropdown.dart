import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class CompanyDropdown extends StatelessWidget {
  final String selectedCompany;
  final List<String> companies;
  final ValueChanged<String> onCompanyChanged;

  const CompanyDropdown({super.key, 
    required this.selectedCompany,
    required this.companies,
    required this.onCompanyChanged,
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
          value: selectedCompany,
          isExpanded: true,
          dropdownColor: cardColor,
          style: TextStyle(color: textColor),
          icon: Icon(Icons.arrow_drop_down, color: secondaryTextColor),
          items: companies.map((c) {
            return DropdownMenuItem(value: c, child: Text(c));
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              onCompanyChanged(value);
            }
          },
        ),
      ),
    );
  }
}
