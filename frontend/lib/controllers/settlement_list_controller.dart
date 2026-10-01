import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';

class SettlementListController extends ChangeNotifier {
  final SettlementProvider settlementProvider;
  final AdvanceProvider advanceProvider;

  SettlementListController({
    required this.settlementProvider,
    required this.advanceProvider,
  });

  String? statusFilter;
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = '';
  String selectedType = 'single';
  String filterMode = 'report';

  bool selectionMode = false;
  final Set<String> selectedItemKeys = {};

  static const Duration _searchDebounceDuration = Duration(milliseconds: 350);
  Timer? _searchDebounce;

  void setFilterMode(String mode) {
    filterMode = mode;
    notifyListeners();
  }

  void setStatusFilter(String? status) {
    statusFilter = status;
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    startDate = start;
    endDate = end;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      reloadSettlements();
    });
    notifyListeners();
  }

  void setSelectionType(String type) {
    selectedType = type;
    notifyListeners();
  }

  void toggleItemSelection(int id, bool isSettlement, bool selected) {
    final key = isSettlement ? 's_$id' : 'a_$id';
    if (selected) {
      selectedItemKeys.add(key);
      selectionMode = true;
    } else {
      selectedItemKeys.remove(key);
    }
    if (selectedItemKeys.isEmpty) selectionMode = false;
    notifyListeners();
  }

  void clearSelection() {
    selectedItemKeys.clear();
    selectionMode = false;
    notifyListeners();
  }

  void resetFilters() {
    statusFilter = null;
    searchQuery = '';
    startDate = null;
    endDate = null;
    selectedType = 'single';
    settlementProvider.clearFilters();
    notifyListeners();
  }

  Future<void> reloadSettlements() async {
    await settlementProvider.loadSettlements(
      status: statusFilter,
      search: searchQuery,
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
    );
    await advanceProvider.loadAdvances(
      status: statusFilter,
      search: searchQuery,
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
    );
  }

  Future<Map<String, dynamic>> bulkDeleteSelected() async {
    int successCount = 0;
    List<String> failures = [];

    final keys = selectedItemKeys.toList();
    for (final key in keys) {
      final parts = key.split('_');
      if (parts.length != 2) continue;
      final type = parts[0];
      final id = int.tryParse(parts[1]);
      if (id == null) continue;

      bool success = false;
      if (type == 's') {
        success = await settlementProvider.deleteSettlement(id, reload: false);
      } else {
        success = await advanceProvider.deleteAdvance(id, reload: false);
      }

      if (success) {
        successCount++;
      } else {
        failures.add(id.toString());
      }
    }

    await reloadSettlements();
    clearSelection();
    return {
      'successCount': successCount,
      'failures': failures,
    };
  }
}
