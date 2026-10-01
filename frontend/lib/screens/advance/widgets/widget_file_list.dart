import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailLayoutFileListExt on AdvanceDetailScreenState {
  Widget buildFileList(
    List<String> paths,
    List<String>? filenames,
    bool isLocal,
    Function(int) onRemove,
    BuildContext ctx,
    StateSetter setDialogState,
  ) {
    if (paths.isEmpty) return const SizedBox.shrink();

    if (!isLocal) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bukti Terpilih:',
              style: TextStyle(
                color: Theme.of(ctx).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            ...paths.asMap().entries.map((entry) {
              final index = entry.key;
              final path = entry.value;
              final name = (filenames != null && filenames.length > index)
                  ? filenames[index]
                  : path.split('/').last;

              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file_rounded,
                      size: 14,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(ctx).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        size: 16,
                        color: AppTheme.danger,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          onRemove(index);
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor(ctx)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terpilih (${paths.length}):',
            style: TextStyle(
              color: Theme.of(ctx).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
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
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.success,
                    size: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Theme.of(ctx).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      size: 16,
                      color: AppTheme.danger,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        onRemove(index);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
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
