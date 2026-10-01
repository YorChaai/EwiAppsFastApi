import 'package:intl/intl.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

extension AdvanceDetailLayoutExt on AdvanceDetailScreenState {
  String formatItemAmount(Map<String, dynamic> item) {
    final currency = (item['currency'] ?? 'IDR').toString().toUpperCase();
    final estimated = (item['estimated_amount'] ?? 0) as num;
    final kurs = (item['currency_exchange'] ?? 1.0) as num;
    final idrStr = item['idr_amount'];
    final idr = (idrStr is num && idrStr > 0) ? idrStr : (estimated * kurs);

    if (currency == 'IDR') {
      return 'Rp ${currencyFormat.format(estimated)}';
    }
    final foreignFormat = NumberFormat('#,##0.##', 'en_US');
    return '$currency ${foreignFormat.format(estimated)} (Rp ${currencyFormat.format(idr)})';
  }

  bool hasUncheckedChecklist(Map<String, dynamic> item) {
    final checklist = parseChecklist(item['notes']);
    return checklist.isNotEmpty &&
        checklist.any((entry) => entry['checked'] != true);
  }
}
