import 'package:intl/intl.dart';

/// Centralized date and currency formatting utilities
class AppFormatters {
  // Date formats
  static final DateFormat _apiFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat _filenameFormat = DateFormat('yyyyMMdd');
  static final DateFormat _fullDateTimeFormat =
      DateFormat('dd MMM yyyy, HH:mm');

  // Currency formats
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Menggunakan pattern yang tidak memaksa desimal muncul jika nilainya bulat (.###)
  static final NumberFormat _plainNumberFormat =
      NumberFormat('#,##0.###', 'id_ID');

  /// Format date for API requests
  static String formatDateForApi(DateTime date) {
    return _apiFormat.format(date);
  }

  /// Format date for display
  static String formatDateForDisplay(DateTime date) {
    return _displayFormat.format(date);
  }

  /// Format date for filenames
  static String formatDateForFilename(DateTime date) {
    return _filenameFormat.format(date);
  }

  /// Format full date time for display
  static String formatDateTime(DateTime date) {
    return _fullDateTimeFormat.format(date);
  }

  /// Parse date from API string
  static DateTime? parseDateFromApi(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    return DateTime.tryParse(dateStr);
  }

  /// Format currency with Rp symbol
  static String formatCurrency(dynamic amount, {bool withSymbol = true}) {
    final value = _toDouble(amount);
    if (!withSymbol) return _plainNumberFormat.format(value);

    // For IDR, keep 0 decimals. For others, allow 2.
    // However, since this is formatCurrency (usually with Rp), we'll keep it consistent.
    return _currencyFormat.format(value);
  }

  /// Format currency plain without symbol
  static String formatCurrencyPlain(dynamic amount) {
    return _plainNumberFormat.format(_toDouble(amount));
  }

  /// Convert dynamic value to double safely
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return 0.0;
    String str = value.toString().trim();
    // Strip non-numeric characters (except for dot, comma, minus)
    str = str.replaceAll(RegExp(r'[^0-9.,\-]'), '');
    if (str.isEmpty) return 0.0;

    // Indonesian: 1.234.567,89 -> 1234567.89
    int dots = '.'.allMatches(str).length;
    int commas = ','.allMatches(str).length;

    if (dots > 1) {
      if (commas == 1) {
        str = str.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        // Last dot heuristic
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
    } else if (dots == 1) {
      int dotIdx = str.lastIndexOf('.');
      if (str.length - dotIdx == 4 && str.length > 4) {
        // Thousands, e.g., 1.234
        str = str.replaceAll('.', '');
      }
    } else if (commas == 1) {
      str = str.replaceFirst(',', '.');
    }

    return double.tryParse(str) ?? 0.0;
  }

  /// Format timestamp for filenames
  static String formatTimestamp([DateTime? dateTime]) {
    final now = dateTime ?? DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }
}
