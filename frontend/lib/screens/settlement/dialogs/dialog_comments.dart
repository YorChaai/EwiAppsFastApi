

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';


// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/dialogs/dialog_plain_comments.dart';

extension SettlementDetailDialogsGeneralshowCommentsDialogExt
    on SettlementDetailScreenState {
  void showCommentsDialog(List<String> comments, bool isDark) {
    showPlainCommentsDialog(
      comments,
      title: 'Komentar Reject',
    );
  }
}
