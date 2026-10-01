import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/models/advance_model.dart';


extension AdvanceProviderListExt on AdvanceProvider {
  Future<void> loadAdvances({
    String? status,
    String? startDate,
    String? endDate,
    int? reportYear,
    String? mode,
    String? type,
    String? search,
  }) async {
    if (!initialized && reportYear == null) return;

    if (reportYear != null) filterYearValue = reportYear;
    if (mode != null) {
      filterYearMode = mode;
      filterMode = mode;
    }
    statusFilter = status;
    startDate = startDate;
    endDate = endDate;
    final yearToUse =
        (filterYearValue ?? reportYear) == 0 ? null : (filterYearValue ?? reportYear);

    // ✅ Centralized Sanitization
    final cleanSearch = search
        ?.replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .replaceAll('&', '')
        .replaceAll(';', '')
        .trim();

    searchQuery = cleanSearch;

    advances =
        []; // ✅ Clear existing to prevent "data leak" from previous filter year
    loading = true;
    error = null;
    notify();

    try {
      final res = await api.getAdvances(
        status: status,
        startDate: startDate,
        endDate: endDate,
        reportYear: yearToUse,
        mode: filterYearMode,
        type: type,
        search: cleanSearch,
      );
      advances = (res['advances'] as List)
          .map((e) => AdvanceModel.fromJson(e))
          .toList();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    loading = false;
    notify();
  }

  void clearFilters() {
    statusFilter = null; // ✅ Reset status filter if any
    loadAdvances();
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
      filterMode = 'report'; // ✅ Default to report mode
      filterYearValue = reportYear;
      filterYearMode = 'report';
      initialized = true;
      notify();
    } catch (_) {
      // If fails, don't mark as initialized so it can be retried later
    }
  }

  void setReportYear(int year, {String? mode, bool reload = true}) {
    reportYear = year;
    initialized = true;
    if (mode != null) {
      filterMode = mode;
    }
    if (reload) loadAdvances();
    notify();
  }

  void setFilterYear(int year, String mode, {bool reload = true}) async {
    filterYearValue = year;
    filterYearMode = mode;
    filterMode = mode;
    if (reload) loadAdvances();
    notify();

    try {
      final prefs = await SharedPreferences.getInstance();
      final isCombined = prefs.getBool('isCombined_unified') ?? true;
      if (isCombined) {
        await prefs.setInt('last_filter_year_unified', year);
        await prefs.setString('last_filter_mode_unified', mode);
      }
    } catch (_) {}
  }

  Future<void> loadAdvance(int id) async {
    loading = true;
    error = null;
    notify();

    try {
      final res = await api.getAdvance(id);
      currentAdvance = AdvanceModel.fromJson(res['advance']);
      await loadHistory(id, notifyState: false);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    loading = false;
    notify();
  }

  Future<void> loadHistory(int id, {bool notifyState = true}) async {
    workflowHistoryLoading = true;
    if (notifyState) notify();

    try {
      final res = await api.getAdvanceHistory(id);
      workflowHistory = List<Map<String, dynamic>>.from(res['history'] ?? []);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }

    workflowHistoryLoading = false;
    if (notifyState) notify();
  }
}
