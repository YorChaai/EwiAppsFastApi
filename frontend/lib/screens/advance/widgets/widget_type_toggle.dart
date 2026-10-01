import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advances_screen.dart';
import 'package:expense_app/screens/advance/widgets/widget_toggle_button.dart';

extension AdvancesWidgetsTypeToggleExt on AdvancesScreenState {
  Widget buildTypeToggle(bool useCompact) {
    final aProv = context.watch<AdvanceProvider>();

    final itemsForCounts = aProv.advances;

    final singlesCount =
        itemsForCounts.where((i) => i.advanceType.name == 'single').length;
    final batchesCount =
        itemsForCounts.where((i) => i.advanceType.name == 'batch').length;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: cardColor(context).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    (Theme.of(context).brightness == Brightness.dark) ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildToggleButton(
                  label: 'Single',
                  count: singlesCount,
                  value: 'single',
                  useCompact: useCompact,
                ),
                const SizedBox(width: 4),
                buildToggleButton(
                  label: 'Batch',
                  count: batchesCount,
                  value: 'batch',
                  useCompact: useCompact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
