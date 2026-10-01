import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderListExt on SettlementProvider {
  Future<void> loadSettlements({
    String? status,
    String? startDate,
    String? endDate,
    String? type,
    int? reportYear,
    String? mode,
    String? search,
    bool notifyState = true,
  }) async {
    if (!initialized && reportYear == null) return;

    statusFilter = status;
    startDate = startDate;
    endDate = endDate;

    if (reportYear != null) filterYearValue = reportYear;
    if (mode != null) {
      filterYearMode = mode;
      filterMode = mode;
    }

    searchQuery = search
        ?.replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .replaceAll('&', '')
        .replaceAll(';', '')
        .trim();

    settlements = [];
    loading = true;
    if (notifyState) notify();
    error = null;

    try {
      final data = await api.getSettlements(
        status: statusFilter,
        startDate: startDate,
        endDate: endDate,
        type: type,
        reportYear: filterYearValue ?? reportYear,
        mode: filterYearMode,
        search: searchQuery,
      );

      settlements = List<Map<String, dynamic>>.from(data['settlements']);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    loading = false;
    if (notifyState) notify();
  }

  void clearFilters() {
    statusFilter = null;
    startDate = null;
    endDate = null;
    searchQuery = null;
    loadSettlements();
  }

  Future<void> loadSettlement(int id, {bool notifyState = true}) async {
    loading = true;
    if (notifyState) notify();
    error = null;

    try {
      final res = await api.getSettlement(id);
      currentSettlement = res['settlement'];
      await loadHistory(id, notifyState: false);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    loading = false;
    if (notifyState) notify();
  }

  Future<void> loadHistory(int id, {bool notifyState = true}) async {
    workflowHistoryLoading = true;
    if (notifyState) notify();

    try {
      final res = await api.getSettlementHistory(id);
      workflowHistory = List<Map<String, dynamic>>.from(res['history'] ?? []);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    workflowHistoryLoading = false;
    if (notifyState) notify();
  }

  Future<void> syncReportYear({bool force = false}) async {
    if (initialized && !force) return;

    try {
      final res = await api.getReportYearSettings();
      final dynamic rawYear = res['default_report_year'];
      final year = int.tryParse((rawYear ?? 0).toString());

      if (year != null && year != 0) {
        reportYear = year;
      } else {
        reportYear = DateTime.now().year;
      }
      filterMode = 'report';
      filterYearValue = reportYear;
      filterYearMode = 'report';
      initialized = true;
      notify();
    } catch (_) {}
  }

  void setReportYear(int year, {String? mode, bool reload = true}) {
    reportYear = year;
    initialized = true;
    if (mode != null) filterMode = mode;
    if (reload) loadSettlements();
    notify();
  }

  void setFilterYear(int year, String mode, {bool reload = true}) async {
    filterYearValue = year;
    filterYearMode = mode;
    filterMode = mode;
    if (reload) loadSettlements();
    notify();
  }

  void setFilterMode(String mode, {bool reload = true}) {
    if (filterMode == mode) return;
    filterMode = mode;
    if (reload) loadSettlements();
    notify();
  }
}
