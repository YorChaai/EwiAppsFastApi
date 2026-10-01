import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/category_tabular_screen.dart';


extension CategoryTabularScreenSimpleCategoryCardExt
    on CategoryTabularScreenState {
  Widget buildSimpleCategoryCard(
    Map<String, dynamic> cat,
    int index,
    int displayIndex, {
    required Key key,
  }) {
    final childrenCount = (cat['children'] as List?)?.length ?? 0;
    final isLangsung = cat['main_group'] == 'BEBAN LANGSUNG';

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dividerColor(context)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              displayIndex.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              '${cat['name'] ?? ''} (${cat['code'] ?? ''})',
              style: TextStyle(
                color: primaryText(context),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            // Tag kecil untuk grup
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: (isLangsung ? AppTheme.accent : Colors.grey).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isLangsung ? AppTheme.accent : Colors.grey,
                  width: 0.5,
                ),
              ),
              child: Text(
                isLangsung ? 'Beban Langsung' : 'Administrasi',
                style: TextStyle(
                  fontSize: 9,
                  color: isLangsung ? AppTheme.accent : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '$childrenCount sub-kategori',
          style: TextStyle(
            color: bodyText(context),
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.drag_handle_rounded,
              color: Colors.grey,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
