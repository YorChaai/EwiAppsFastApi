import 'package:expense_app/screens/widgets/widget_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/context_extensions.dart';

import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

extension MainLayoutWidgetsTypeToggleExt on SettlementListViewState {
  Widget buildTypeToggle(bool useCompact) {
    final sProv = context.watch<SettlementProvider>();

    final itemsForCounts = sProv.settlements;

    final singlesCount = itemsForCounts
        .where((i) => (i['settlement_type'] ?? 'single') == 'single')
        .length;
    final batchesCount = itemsForCounts
        .where((i) => (i['settlement_type'] ?? 'single') == 'batch')
        .length;

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
                    context.isDark ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
          ),
        ],
      ),
    );
  }
}
