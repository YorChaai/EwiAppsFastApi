import 'package:flutter/material.dart';

import 'package:expense_app/widgets/core/_fast_range_picker_dialog.dart';

class AppDateRangePicker {
  static Future<DateTimeRange?> show(
    BuildContext context, {
    DateTimeRange? initialRange,
  }) async {
    return await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => FastRangePickerDialog(initialRange: initialRange),
    );
  }
}
