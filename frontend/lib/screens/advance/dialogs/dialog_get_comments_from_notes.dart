import 'dart:convert';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailDialogsGeneralgetCommentsFromNotesExt
    on AdvanceDetailScreenState {
  List<String> getCommentsFromNotes(String notes) {
    if (notes.isEmpty) return [];

    final systemPrefixes = [
      'Disetujui oleh',
      'Imported from',
      'Subcategory:',
      'Approved by',
      'System:',
    ];

    try {
      final decoded = json.decode(notes);
      if (decoded is List) {
        final List<String> comments = [];
        for (var item in decoded) {
          final text = (item is Map ? item['text'] : item).toString();

          bool isSystem = false;
          for (var prefix in systemPrefixes) {
            if (text.trim().startsWith(prefix)) {
              isSystem = true;
              break;
            }
          }

          if (!isSystem && text.trim().isNotEmpty) {
            comments.add(text.trim());
          }
        }
        return comments;
      }
      return [];
    } catch (_) {
      bool isSystem = false;
      for (var prefix in systemPrefixes) {
        if (notes.trim().startsWith(prefix)) {
          isSystem = true;
          break;
        }
      }
      return isSystem || notes.trim().isEmpty ? [] : [notes.trim()];
    }
  }
}
