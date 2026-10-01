import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_plain_comments.dart';

extension AdvanceDetailDialogsGeneralshowCommentsDialogExt
    on AdvanceDetailScreenState {
  void showCommentsDialog(List<String> comments, bool isDark) {
    showPlainCommentsDialog(
      comments,
      title: 'Komentar Reject',
    );
  }
}
