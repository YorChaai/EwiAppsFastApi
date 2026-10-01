import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetExpenseFormFields {
  static Widget buildDescriptionField(BuildContext context, TextEditingController ctrl, Color textColor) {
    return TextField(
      controller: ctrl,
      decoration: const InputDecoration(labelText: 'Deskripsi'),
      style: TextStyle(color: textColor),
    );
  }

  static Widget buildAmountField(
    BuildContext context, 
    TextEditingController ctrl, 
    Color textColor, 
    bool isNegative, 
    ValueChanged<bool> onNegativeChanged
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<bool>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            isExpanded: true,
            initialValue: isNegative,
            items: const [
              DropdownMenuItem(value: false, child: Text('+ (Pemasukan)')),
              DropdownMenuItem(value: true, child: Text('- (Pengeluaran)')),
            ],
            onChanged: (v) {
              if (v != null) onNegativeChanged(v);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Jumlah'),
            style: TextStyle(color: textColor),
          ),
        ),
      ],
    );
  }

  static Widget buildExchangeRateField(BuildContext context, TextEditingController ctrl, Color textColor) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: 'Kurs (Exchange Rate)'),
      style: TextStyle(color: textColor),
    );
  }
}
