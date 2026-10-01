import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider_list_ext.dart';
export 'settlement_provider_list_ext.dart';
export 'settlement_provider_crud_ext.dart';
export 'settlement_provider_expense_ext.dart';
export 'settlement_provider_workflow_ext.dart';
export 'settlement_provider_finance_ext.dart';
export 'settlement_provider_category_ext.dart';
export 'settlement_provider_bank_ext.dart';

class SettlementProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Map<String, dynamic>> settlements = [];
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> pendingCategories = [];
  List<Map<String, dynamic>> banks = [];
  List<Map<String, dynamic>> advanceBanks = [];
  Map<String, dynamic>? currentSettlement;
  List<Map<String, dynamic>> workflowHistory = [];
  bool workflowHistoryLoading = false;
  bool loading = false;
  String? error;
  bool unsavedDraft = false;

  String? statusFilter;
  int reportYear = DateTime.now().year;
  String filterMode = 'report'; // 'report' or 'actual'
  String? startDate;
  String? endDate;
  String? searchQuery;
  int? filterYearValue; // Local filter year for list
  String filterYearMode = 'report'; // Local filter mode for list
  bool initialized = false;
  String sortMode = 'kategori'; // 'kategori' atau 'tanggal'

  SettlementProvider() {
    syncReportYear();
    _loadSortMode();
  }

  // ✅ Helper to allow extensions to trigger UI updates
  void notify() => notifyListeners();

  Future<void> _loadSortMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSortMode = prefs.getString('report_sort_mode');
      if (savedSortMode != null) {
        sortMode = savedSortMode;
        notify();
      }
    } catch (e) {
      debugPrint('[DEBUG] error loading sort mode: $e');
    }
  }

  void initialize() {
    syncReportYear();
  }

  bool get isInitialized => initialized;

  int get filterYear => filterYearValue ?? reportYear;


  List<Map<String, dynamic>> get flatCategories {
    final flat = <Map<String, dynamic>>[];
    for (final cat in categories) {
      final children = cat['children'] as List? ?? [];
      if (children.isNotEmpty) {
        flat.add({...cat, '_isHeader': true});
        for (final child in children) {
          flat.add({
            ...child,
            'name': '  └ ${child['name']}',
            '_isHeader': false,
            'status': child['status'],
          });
        }
      } else {
        flat.add({...cat, '_isHeader': false});
      }
    }
    return flat;
  }

  bool disposed = false;

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  void updateToken(String? token) {
    api.setToken(token);
    if (token == null) {
      clearData();
    } else {
      syncReportYear(force: true);
      _loadSortMode();
    }
  }

  void clearData() {
    settlements = [];
    currentSettlement = null;
    workflowHistory = [];
    workflowHistoryLoading = false;
    loading = false;
    error = null;
    unsavedDraft = false;
    initialized = false;
    categories = [];
    pendingCategories = [];
    notify();
  }

  void setSortMode(String mode) async {
    if (sortMode == mode) return;
    sortMode = mode;
    notify();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('report_sort_mode', mode);
    } catch (e) {
      debugPrint('[DEBUG] error saving sort mode: $e');
    }
  }

  String getEvidenceUrl(String filename) {
    return api.getEvidenceUrl(filename);
  }

  Future<List<int>> exportExcel({
    int? month,
    int? year,
    String? mode,
    int? categoryId,
    int? settlementId,
    String? startDate,
    String? endDate,
    String? status,
  }) {
    return api.exportExcel(
      month: month,
      year: year,
      mode: mode,
      categoryId: categoryId,
      settlementId: settlementId,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );
  }

  Future<Map<String, dynamic>> getSummary({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
  }) {
    return api.getSummary(
      year: year,
      mode: mode,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<int>> getSummaryPdf({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
  }) {
    return api.getSummaryPdf(
      year: year,
      mode: mode,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<int>> getReceipt(int settlementId) {
    return api.getReceipt(settlementId);
  }

  Future<List<int>> getBulkPdf({
    String? status,
    String? startDate,
    String? endDate,
    int? reportYear,
  }) {
    return api.getBulkSettlementsPdf(
      status: status,
      startDate: startDate,
      endDate: endDate,
      reportYear: reportYear,
    );
  }
}
