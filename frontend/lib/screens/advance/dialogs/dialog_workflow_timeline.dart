import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/widgets/workflow_timeline.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailDialogsGeneralshowWorkflowTimelineDialogExt
    on AdvanceDetailScreenState {
  void showWorkflowTimelineDialog(Map<String, dynamic> advance) {
    final prov = context.read<AdvanceProvider>();

    showDialog(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.of(ctx).size.width;
        return AlertDialog(
          backgroundColor: cardColor(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: SizedBox(
            width: width > 760 ? 720 : width * 0.92,
            child: SingleChildScrollView(
              child: WorkflowTimeline(
                history: prov.workflowHistory,
                currentStage: advance['current_stage']?.toString(),
                expectedCompletionAt:
                    advance['expected_completion_at']?.toString(),
                loading: prov.workflowHistoryLoading,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
