import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_evidence.dart';

extension AdvanceDetailDialogsGeneralbuildDisbursementEvidenceCellExt
    on AdvanceDetailScreenState {
  Widget buildDisbursementEvidenceCell(
    Map<String, dynamic> adv,
  ) {
    final hasExisting = adv['disbursement_evidence_path'] != null;

    if (hasExisting) {
      return IconButton(
        icon: const Icon(
          Icons.image_rounded,
          color: AppTheme.accent,
        ),
        onPressed: () {
          final path = adv['disbursement_evidence_path'];
          final name =
              adv['disbursement_evidence_filename'] ?? 'Bukti Transfer';
          if (path != null && path.isNotEmpty) {
            showEvidence(path, name);
          }
        },
        tooltip: 'Lihat Bukti Transfer',
      );
    }

    return const Text('-');
  }
}
