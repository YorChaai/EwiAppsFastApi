import 'package:flutter/material.dart';

class ReportTableData {
  final List<List<String>> rows;
  final Set<int> boldRows;
  final List<String>? headers; // Null if using fixed headers
  /// Maps rowIndex to groupId for combine group visual merging
  final Map<int, int>? combineGroupMap;

  /// Maps rowIndex to list of field names that are merged
  final Map<int, List<String>>? mergedColumnsMap;

  /// Maps rowIndex to custom row background color (e.g. unallocated bank highlight)
  final Map<int, Color>? rowColors;

  ReportTableData({
    required this.rows,
    this.boldRows = const {},
    this.headers,
    this.combineGroupMap,
    this.mergedColumnsMap,
    this.rowColors,
  });
}
