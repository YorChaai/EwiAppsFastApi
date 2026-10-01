
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailDialogsGeneralshowPlainCommentsDialogExt
    on SettlementDetailScreenState {
  void showPlainCommentsDialog(
    List<String> comments, {
    String title = 'Riwayat Komentar',
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: getCardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.comment_rounded, color: AppTheme.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(title, overflow: TextOverflow.ellipsis),
            ),
            IconButton(
              onPressed: () => Navigator.pop(ctx),
              tooltip: 'Tutup',
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: comments.length,
            separatorBuilder: (c, i) => const Divider(),
            itemBuilder: (c, i) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      (i + 1).toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      comments[i],
                      style: TextStyle(
                        color: getCreamColor(ctx),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
