import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // --- Fix Case 2: Backspace tertahan oleh titik ---
    if (oldValue.text.length - newValue.text.length == 1) {
      int oldCursor = oldValue.selection.baseOffset;
      int newCursor = newValue.selection.baseOffset;

      if (oldCursor > 0 && oldCursor - newCursor == 1) {
        // Backspace was pressed
        String deletedChar = oldValue.text[newCursor];
        if (deletedChar == '.') {
          if (newCursor > 0) {
            String updatedText = newValue.text.substring(0, newCursor - 1) +
                newValue.text.substring(newCursor);
            newValue = newValue.copyWith(
              text: updatedText,
              selection: TextSelection.collapsed(offset: newCursor - 1),
            );
          }
        }
      } else if (oldCursor == newCursor && oldCursor < oldValue.text.length) {
        // Forward Delete was pressed
        String deletedChar = oldValue.text[oldCursor];
        if (deletedChar == '.') {
          if (oldCursor < newValue.text.length) {
            String updatedText = newValue.text.substring(0, oldCursor) +
                newValue.text.substring(oldCursor + 1);
            newValue = newValue.copyWith(
              text: updatedText,
              selection: TextSelection.collapsed(offset: oldCursor),
            );
          }
        }
      }
    }

    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // In id_ID locale:
    // - Thousand separator is '.', decimal separator is ','

    String text = newValue.text;
    bool isNegative = text.startsWith('-');
    if (isNegative) {
      text = text.substring(1);
    }
    String integerPart = text;
    String decimalPart = "";

    // Treat ',' as decimal separator
    bool hasDecimal = text.contains(',');
    if (hasDecimal) {
      int sepIdx = text.lastIndexOf(',');
      integerPart = text.substring(0, sepIdx);
      decimalPart = text.substring(sepIdx + 1).replaceAll(RegExp(r'[^\d]'), '');
      if (decimalPart.length > 2) decimalPart = decimalPart.substring(0, 2);
    }

    // Strip non-digits from integer part (removes thousand dots)
    String digitsOnly = integerPart.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty && decimalPart.isEmpty) {
      if (hasDecimal) {
        return newValue.copyWith(
          text: isNegative ? '-0,' : '0,',
          selection: TextSelection.collapsed(offset: isNegative ? 3 : 2),
        );
      }
      return newValue.copyWith(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    }

    // Format the number
    final int intValue = digitsOnly.isEmpty ? 0 : int.parse(digitsOnly);

    // --- Fix Case 1: Angka 0 terbaca sebagai value asli ---
    // Jika nilainya 0 (misal sisa dari penghapusan '5' dari '5000' -> '000'),
    // jadikan kosong saja agar hint text muncul dan mencegah kursor nyangkut di '|0'.
    if (intValue == 0 && decimalPart.isEmpty && !hasDecimal) {
      return newValue.copyWith(
        text: isNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: isNegative ? 1 : 0),
      );
    }

    final String formattedInteger = _formatter.format(intValue).trim();

    String finalResult = formattedInteger;
    if (hasDecimal) {
      finalResult += ",$decimalPart";
    }
    if (isNegative) {
      finalResult = '-$finalResult';
    }

    // ── Robust cursor positioning ──────────────────────────────────────────
    // Strategy: count how many *digits* (0-9) appear before the cursor in
    // newValue.text, then walk through finalResult until we have passed the
    // same number of digits.  This correctly handles:
    //   • deleting a digit in the middle (thousand separators shift)
    //   • select-all then type a single digit (old text fully replaced)

    final int rawCursor =
        newValue.selection.baseOffset.clamp(0, newValue.text.length);

    // Count digits before cursor in the raw new text
    int digitsBeforeCursor = 0;
    for (int i = 0; i < rawCursor; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Find matching position in finalResult
    int newCursor = 0;
    int digitsSeen = 0;
    while (newCursor < finalResult.length && digitsSeen < digitsBeforeCursor) {
      if (RegExp(r'\d').hasMatch(finalResult[newCursor])) {
        digitsSeen++;
      }
      newCursor++;
    }
    // If cursor lands right before a thousand-separator dot, skip past it
    if (newCursor < finalResult.length && finalResult[newCursor] == '.') {
      newCursor++;
    }

    return TextEditingValue(
      text: finalResult,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}
