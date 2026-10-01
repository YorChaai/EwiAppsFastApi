import 'package:intl/intl.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';


extension AnnualReportHelpersExt on AnnualReportScreenState {
  List<Map<String, dynamic>> asListMap(dynamic data) {
    if (data is! List) return [];
    return data
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  double toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return 0.0;
    String str = value.toString().trim();
    if (str.isEmpty) return 0.0;

    int dots = '.'.allMatches(str).length;
    int commas = ','.allMatches(str).length;

    if (dots > 1) {
      if (commas == 1) {
        str = str.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        int lastDotIdx = str.lastIndexOf('.');
        if (str.length - lastDotIdx != 4) {
          String integerPart = str.substring(0, lastDotIdx).replaceAll('.', '');
          String decimalPart = str.substring(lastDotIdx + 1);
          str = "$integerPart.$decimalPart";
        } else {
          str = str.replaceAll('.', '');
        }
      }
    } else if (dots == 1 && commas == 1) {
      int dotIdx = str.indexOf('.');
      int commaIdx = str.indexOf(',');
      if (dotIdx < commaIdx) {
        str = str.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        str = str.replaceAll(',', '');
      }
    } else if (commas > 1) {
      str = str.replaceAll(',', '');
    } else if (commas == 1) {
      str = str.replaceFirst(',', '.');
    }

    return double.tryParse(str) ?? 0.0;
  }

  String fmtMoney(dynamic value) {
    final v = toDouble(value);
    if (v == 0) return '';
    return 'Rp ${currencyFormat.format(v)}';
  }

  String fmtPlain(dynamic value) {
    final v = toDouble(value);
    if (v == 0) return '';
    return currencyFormat.format(v);
  }

  String fmtAmount(dynamic amount, dynamic currency) {
    final a = toDouble(amount);
    if (a == 0) return '';
    final c = normalizeCurrency(currency);
    if (c == 'IDR') {
      return currencyFormat.format(a);
    } else {
      // For foreign currency, show up to 2 decimals if needed
      final fmt = NumberFormat('#,##0.###', 'en_US');
      return fmt.format(a);
    }
  }

  String normalizeCurrency(dynamic currency) {
    final c = (currency?.toString() ?? 'IDR').trim().toUpperCase();
    if (c == '\$' || c == 'USD') return 'USD';
    return c;
  }

  String fmtDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(text);
      return dt == null ? text : DateFormat('dd-MMM-yy').format(dt);
    } catch (_) {
      return text;
    }
  }

  int extractBatchNumber(String text) {
    final match = RegExp(
      r'\bbatch\s*#?\s*(\d+)\b',
      caseSensitive: false,
    ).firstMatch(text);
    return match == null
        ? (1 << 30)
        : (int.tryParse(match.group(1) ?? '') ?? (1 << 30));
  }

  bool isBatchSettlement(Map<String, dynamic> item) {
    final stype =
        (item['settlement_type'] ?? '').toString().toLowerCase().trim();
    if (stype == 'batch') return true;
    if (stype == 'single') return false;
    final title = (item['settlement_title'] ?? '').toString().toLowerCase();
    return title.contains('batch');
  }

  String extractNoteSubcategory(Map<String, dynamic> item) {
    final notes = (item['notes'] ?? '').toString().trim();
    if (notes.isEmpty) return '';
    final match = RegExp(
      r'\bSubcategory:\s*([^|]+)',
      caseSensitive: false,
    ).firstMatch(notes);
    return match?.group(1)?.trim() ?? '';
  }

  int subcategorySortBucket(String label) {
    final text = label.trim();
    if (text.isEmpty || text == '-') return 2;
    if (text.contains(',')) return 0;
    return 1;
  }

  String expenseSubcategoryLabel(Map<String, dynamic> item) {
    final backendSub = (item['subcategory_name'] ?? '').toString().trim();
    if (backendSub.isNotEmpty && backendSub != '-') return backendSub;
    final rawDesc = (item['description'] ?? '').toString();
    final extracted = RegExp(r'^\[(.*?)\]\s*(.*)$').firstMatch(rawDesc);
    if (extracted?.group(1) != null) return extracted!.group(1)!.trim();
    final noteSub = extractNoteSubcategory(item);
    if (noteSub.isNotEmpty) return noteSub;
    return backendSub;
  }
}
