import 'package:flutter/material.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailLayoutAddCommentButtonExt on AdvanceDetailScreenState {
  Widget buildAddCommentButton(
    List<Map<String, dynamic>> list,
    StateSetter setModalState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: OutlinedButton.icon(
        onPressed: () {
          final focusNode = FocusNode();
          setModalState(() {
            list.add({
              'text': '',
              'checked': false,
              'focusNode': focusNode,
            });
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            focusNode.requestFocus();
          });
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Tambah komentar'),
      ),
    );
  }
}
