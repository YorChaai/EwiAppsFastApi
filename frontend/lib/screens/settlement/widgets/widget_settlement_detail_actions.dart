
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/settlement_detail_widgets.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_edit_settlement.dart';
import 'package:expense_app/screens/settlement/settlement_detail_previews.dart';

extension SettlementDetailSettlementDetailActionsExt
    on SettlementDetailScreenState {
  List<Widget> buildSettlementDetailActions(
    BuildContext context,
    Map<String, dynamic> s,
    AuthProvider auth,
    String settlementStatus,
  ) {
    final actions = <Widget>[];

    final expenses = asMapList(s['expenses']);
    if (expenses.isNotEmpty) {
      actions.add(
        SettlementActionButton(
          onPressed: () => showAllItemsPreview(expenses, s),
          icon: Icons.list_alt_rounded,
          label: 'Pratinjau List',
          isOutlined: true,
          color: AppTheme.accent,
        ),
      );
    }

    actions.add(
      SettlementActionButton(
        onPressed: () => showWorkflowTimelineDialog(s),
        icon: Icons.timeline_rounded,
        label: 'Timeline',
        isOutlined: true,
        color: AppTheme.primary,
      ),
    );

    final currentUserIdStr = auth.user?['id']?.toString();
    final documentUserIdStr = s['user_id']?.toString();
    final userIsOwnerOrManager =
        currentUserIdStr == documentUserIdStr || auth.isManager;

    if (userIsOwnerOrManager &&
        (s['status'] == 'draft' || s['status'] == 'rejected') &&
        s['settlement_type'] == 'batch') {
      actions.add(
        SettlementActionButton(
          onPressed: () => showEditSettlementDialog(context, s),
          icon: Icons.edit_rounded,
          label: 'Edit',
          isOutlined: true,
        ),
      );
    }

    if (userIsOwnerOrManager && s['status'] == 'draft') {
      actions.add(
        Builder(
          builder: (context) {
            final items = asMapList(s['expenses']);
            return SettlementActionButton(
              onPressed: canSubmitSettlementItems(items, s)
                  ? () => submitSettlement()
                  : null,
              icon: Icons.send_rounded,
              label: 'Submit',
            );
          },
        ),
      );
    }

    if (auth.isManager &&
        (s['status'] == 'submitted' || s['status'] == 'approved')) {
      final isDisbursementApproved = s['is_disbursement_approved'] == true;
      final isReturnApproved = s['is_return_approved'] == true;

      actions.add(
        Builder(
          builder: (context) {
            final items = asMapList(s['expenses']);
            final itemsApproved = canApproveSettlementItems(items);

            final reimbAmt = settlementReimbursementAmount(s);
            final dbDisbursed = toDouble(s['disbursed_amount']);
            final isModifiedT2 = s['modified_t2'] == true;
            final needsTable2 = (isModifiedT2 && dbDisbursed > 0.01) || reimbAmt > 0.01;

            final dbReturned = toDouble(s['returned_amount']);
            final needsTable3 = dbReturned > 0.01;

            final isT2Done = !needsTable2 || isDisbursementApproved;
            final isT3Done = !needsTable3 || isReturnApproved;

            final isFullyApproved = itemsApproved && isT2Done && isT3Done;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isFullyApproved) ...[
                  SettlementActionButton(
                    onPressed: () => approveSettlement(),
                    icon: Icons.verified_rounded,
                    label: 'Complete',
                    backgroundColor: AppTheme.success,
                  ),
                  const SizedBox(width: 8),
                ],
                SettlementActionButton(
                  onPressed: () => rejectSettlement(),
                  icon: Icons.cancel_rounded,
                  label: 'Reject',
                  backgroundColor: AppTheme.danger,
                ),
              ],
            );
          },
        ),
      );
    }

    final isOwner = auth.user?['id']?.toString() == s['user_id']?.toString();
    final isManager = auth.isManager;

    bool canMoveToDraft = false;
    final status = s['status'];
    if (isOwner || isManager) {
      if (['submitted', 'rejected', 'approved'].contains(status)) {
        canMoveToDraft = true;
      }
      if (['approved_final', 'completed'].contains(status)) {
        if (isManager) canMoveToDraft = true;
      }
    }

    if (canMoveToDraft) {
      actions.add(
        SettlementActionButton(
          onPressed: () => moveToDraft(),
          icon: Icons.undo_rounded,
          label: 'Move to Draft',
          isOutlined: true,
          color: AppTheme.warning,
        ),
      );
    }

    if (settlementStatus == 'approved' || settlementStatus == 'completed') {
      actions.add(
        SettlementActionButton(
          onPressed: () => downloadReceipt(),
          icon: Icons.print_rounded,
          label: 'Cetak',
          isOutlined: true,
        ),
      );
      actions.add(
        SettlementActionButton(
          onPressed: () => exportSettlementExcel(),
          icon: Icons.table_chart_rounded,
          label: 'Excel',
          isOutlined: true,
        ),
      );
    }

    return actions;
  }
}
