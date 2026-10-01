import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

class RevenueProvider with ChangeNotifier {
  final ApiService _api;

  RevenueProvider(this._api);

  List<dynamic> _revenues = [];
  List<dynamic> _combineGroups = [];
  bool _isLoading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  List<dynamic> get revenues => _revenues;
  List<dynamic> get combineGroups => _combineGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  void updateToken(String? token) {
    _api.setToken(token);
    if (token == null) {
      _revenues = [];
      _combineGroups = [];
      _initialized = false;
      notifyListeners();
    } else {
      syncReportYear(force: true);
    }
  }

  Future<void> syncReportYear({bool force = false}) async {
    if (_initialized && !force) return;
    try {
      final res = await _api.getReportYearSettings();
      final dynamic rawYear = res['default_report_year'];
      final year = int.tryParse((rawYear ?? 0).toString());

      if (year != null && year != 0) {
        _reportYear = year;
      } else {
        _reportYear = DateTime.now().year;
      }
      _initialized = true;
      notifyListeners();
    } catch (_) {
      // Allow retry
    }
  }

  void setReportYear(int year, {String? mode, bool reload = true}) {
    _reportYear = year;
    _initialized = true;
    notifyListeners();
    if (reload) {
      loadRevenues(year: year, mode: mode);
    }
  }

  Future<void> loadRevenues({
    String? startDate,
    String? endDate,
    int? year,
    String? mode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final targetYear = year ?? _reportYear;
      final data = await _api.getRevenues(
        startDate: startDate,
        endDate: endDate,
        year: targetYear,
        mode: mode,
      );
      _revenues = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> fetchRevenueCombineGroups({required int year}) async {
    try {
      final data = await _api.getRevenueCombineGroups(year: year);
      _combineGroups = data;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createRevenue(
    Map<String, dynamic> data, {
    String? startDate,
    String? endDate,
    int? year,
    String? mode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createRevenue(data);
      await loadRevenues(
        startDate: startDate,
        endDate: endDate,
        year: year,
        mode: mode,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateRevenue(
    int id,
    Map<String, dynamic> data, {
    String? startDate,
    String? endDate,
    int? year,
    String? mode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.updateRevenue(id, data);
      await loadRevenues(
        startDate: startDate,
        endDate: endDate,
        year: year,
        mode: mode,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRevenue(
    int id, {
    String? startDate,
    String? endDate,
    int? year,
    String? mode,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.deleteRevenue(id);
      await loadRevenues(
        startDate: startDate,
        endDate: endDate,
        year: year,
        mode: mode,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createRevenueCombineGroup({
    required int year,
    required List<int> rowIds,
    List<String>? mergedColumns,
    Map<String, dynamic>? overrides,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createRevenueCombineGroup(
        year: year,
        rowIds: rowIds,
        mergedColumns: mergedColumns,
        overrides: overrides,
      );
      await fetchRevenueCombineGroups(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteRevenueCombineGroup({
    required int id,
    required int year,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.deleteRevenueCombineGroup(id);
      await fetchRevenueCombineGroups(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
