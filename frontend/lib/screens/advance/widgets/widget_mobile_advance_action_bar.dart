import 'package:flutter/material.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/widgets/widget_advance_detail_actions.dart';

extension AdvanceDetailLayoutMobileAdvanceActionBarExt
    on AdvanceDetailScreenState {
  Widget buildMobileAdvanceActionBar(
    BuildContext context,
    Map<String, dynamic> adv,
    AuthProvider auth,
    List<Map<String, dynamic>> workflowItems,
    bool canEditHeader,
    bool canSubmit,
    bool canCreateSettlement,
    bool canStartRevision,
    bool canShowDownloadButtons,
  ) {
    final actions = buildAdvanceDetailActions(
      context,
      adv,
      auth,
      workflowItems,
      canEditHeader,
      canSubmit,
      canCreateSettlement,
      canStartRevision,
      canShowDownloadButtons,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: surfaceColor(context),
        border: Border(
          bottom:
              BorderSide(color: dividerColor(context).withValues(alpha: 0.6)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (selectedItemIds.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: bulkDeleteItems,
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    color: AppTheme.danger,
                  ),
                  tooltip: 'Hapus ${selectedItemIds.length} item pilihan',
                ),
              ),
            ...actions.map(
              (action) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: action,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
