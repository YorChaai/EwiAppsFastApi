import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_state.dart';

void main() {
  group('ReportTableData Tests', () {
    test('ReportTableData initializes with rowColors and properties', () {
      final rows = [
        ['2026-03-01', '1', 'Invoice Alpha', '1000', '16000000'],
        ['2026-03-02', '2', 'Invoice Beta', '2000', '32000000'],
      ];
      final rowColors = {
        0: const Color(0xFFFFF9C4), // Yellow highlight for unallocated bank
      };

      final tableData = ReportTableData(
        rows: rows,
        boldRows: const {},
        combineGroupMap: const {0: 1},
        mergedColumnsMap: const {0: ['description']},
        rowColors: rowColors,
      );

      expect(tableData.rows.length, 2);
      expect(tableData.rowColors, isNotNull);
      expect(tableData.rowColors?[0], const Color(0xFFFFF9C4));
      expect(tableData.rowColors?[1], isNull);
      expect(tableData.combineGroupMap?[0], 1);
      expect(tableData.mergedColumnsMap?[0], contains('description'));
    });
  });
}
