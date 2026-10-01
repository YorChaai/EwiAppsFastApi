
import 'package:flutter/material.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family

extension SettlementDetailFileListExt on SettlementDetailScreenState {
  Widget buildFileList(
    BuildContext context,
    List<String> paths,
    List<String>? filenames,
    bool isLocal,
    Function(int) onRemove,
  ) {
    if (paths.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: getDividerColor(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLocal
                ? 'Terpilih (${paths.length}):'
                : 'File Lama (${paths.length}):',
            style: TextStyle(
              color: getSecondaryText(context),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...List.generate(paths.length, (index) {
            final name = (filenames != null && filenames.length > index)
                ? filenames[index]
                : paths[index].split('/').last;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(
                    isLocal ? Icons.check_circle : Icons.cloud_done,
                    color: isLocal ? AppTheme.success : AppTheme.primary,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color:
                            isLocal ? AppTheme.success : getPrimaryText(context),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onRemove(index),
                    child: const Icon(
                      Icons.cancel,
                      size: 16,
                      color: AppTheme.danger,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
