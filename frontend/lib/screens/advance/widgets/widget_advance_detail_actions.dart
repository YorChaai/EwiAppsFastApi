import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/advance_detail_previews.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_edit_advance.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_workflow_timeline.dart';
import 'package:expense_app/screens/widgets/settlement_detail_widgets.dart';

extension AdvanceDetailLayoutAdvanceDetailActionsExt
    on AdvanceDetailScreenState {
  List<Widget> buildAdvanceDetailActions(
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
    final actions = <Widget>[];

    final items = asMapList(adv['items']);
    if (items.isNotEmpty) {
      actions.add(
        SettlementActionButton(
          onPressed: () => showAllItemsPreview(items, adv),
          icon: Icons.list_alt_rounded,
          label: 'Pratinjau List',
          isOutlined: true,
          color: AppTheme.accent,
        ),
      );
    }

    actions.add(
      SettlementActionButton(
        onPressed: () => showWorkflowTimelineDialog(adv),
        icon: Icons.timeline_rounded,
        label: 'Timeline',
        isOutlined: true,
        color: AppTheme.primary,
      ),
    );

    if (canEditHeader) {
      actions.add(
        SettlementActionButton(
          onPressed: () => showEditAdvanceDialog(context, adv),
          icon: Icons.edit_rounded,
          label: 'Edit',
          isOutlined: true,
        ),
      );
    }

    if (canSubmit) {
      final label = adv['status'] == 'revision' || adv['status'] == 'rejected'
          ? 'Submit Revisi'
          : 'Submit';
      actions.add(
        SettlementActionButton(
          onPressed: canSubmitAdvanceItems(workflowItems, adv)
              ? () => submitAdvance()
              : null,
          icon: Icons.send_rounded,
          label: label,
        ),
      );
    }

    final isOwner = auth.user?['id'] == adv['user_id'];
    final isManager = auth.isManager;

    bool canMoveToDraft = false;
    final status = adv['status'];
    if (isOwner || isManager) {
      if (['submitted', 'rejected', 'submitted', 'rejected', 'approved']
          .contains(status)) {
        canMoveToDraft = true;
      }
      if (['approved_final', 'completed'].contains(status)) {
        if (isManager) canMoveToDraft = true;
      }
    }

    if (canMoveToDraft) {
      actions.add(
        SettlementActionButton(
          onPressed: moveToDraft,
          icon: Icons.undo_rounded,
          label: 'Move to Draft',
          isOutlined: true,
          color: AppTheme.warning,
        ),
      );
    }

    if (isManager && adv['status'] == 'approved') {
      final label =
          adv['active_revision_no'] != null && adv['active_revision_no'] > 0
              ? 'Complete Revisi ${adv['active_revision_no']}'
              : 'Complete';

      final isDisbursementApproved = adv['is_disbursement_approved'] ?? false;

      // Gating logic for showing the button
      final itemsApproved = canApproveAdvanceItems(workflowItems);
      // Logic for showing & clickability: Require Table 1 and Table 2 only.
      final shouldShowFinalApprove = itemsApproved && isDisbursementApproved;
      final canFinalApproveGating = shouldShowFinalApprove;

      if (shouldShowFinalApprove) {
        actions.add(
          SettlementActionButton(
            onPressed: canFinalApproveGating ? () => approveAdvance() : null,
            icon: Icons.check_circle_outline,
            label: label,
            color: AppTheme.success,
          ),
        );
      }
    }

    // if (canStartRevision) {
    //   final label = 'Tambah Revisi ${(adv['approved_revision_no'] ?? 0) + 1}';
    //   actions.add(
    //     SettlementActionButton(
    //       onPressed: () => startRevision(),
    //       icon: Icons.add_circle_outline,
    //       label: label,
    //       color: AppTheme.accent,
    //     ),
    //   );
    // }

    if (canCreateSettlement) {
      actions.add(
        SettlementActionButton(
          onPressed: () async {
            final sProv = context.read<SettlementProvider>();

            final advType = adv['advance_type'] == 'batch' ? 'batch' : 'single';
            final title = advType == 'single'
                ? 'Settlement Mandiri'
                : (adv['title'] ?? 'Settlement Batch');

            // Tampilkan loading dialog agar UI tidak frozen
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) =>
                  const Center(child: CircularProgressIndicator()),
            );

            final result = await sProv.createSettlement(
              title,
              '',
              copyFromAdvanceId: adv['id'],
              settlementType: advType,
              reportYear: adv['report_year'] ?? DateTime.now().year,
              documentDate: adv['document_date'],
            );

            if (!context.mounted) return;
            Navigator.pop(context); // Tutup loading dialog

            if (result != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettlementDetailScreen(settlementId: result['id']),
                ),
              );
            }
          },
          icon: Icons.receipt_long_rounded,
          label: 'Buat Settlement',
          color: AppTheme.accent,
        ),
      );
    }

    if (canShowDownloadButtons) {
      actions.add(
        SettlementActionButton(
          onPressed: () => downloadReceipt(),
          icon: Icons.picture_as_pdf_rounded,
          label: 'PDF',
          isOutlined: true,
        ),
      );
      actions.add(
        SettlementActionButton(
          onPressed: () => exportAdvanceExcel(),
          icon: Icons.table_chart_rounded,
          label: 'Excel',
          isOutlined: true,
        ),
      );
    }

    return actions;
  }
}
