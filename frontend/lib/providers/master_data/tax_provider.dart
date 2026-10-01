import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

class TaxProvider with ChangeNotifier {
  final ApiService _api;

  TaxProvider(this._api);

  List<dynamic> _taxes = [];
  List<dynamic> _combineGroups = [];
  bool _isLoading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  List<dynamic> get taxes => _taxes;
  List<dynamic> get combineGroups => _combineGroups;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  void updateToken(String? token) {
    _api.setToken(token);
    if (token == null) {
      _taxes = [];
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
      loadTaxes(year: year, mode: mode);
    }
  }

  Future<void> loadTaxes({
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
      final data = await _api.getTaxes(
        startDate: startDate,
        endDate: endDate,
        year: targetYear,
        mode: mode,
      );
      _taxes = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> fetchTaxCombineGroups({required int year}) async {
    try {
      final data = await _api.getTaxCombineGroups(year: year);
      _combineGroups = data;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> createTax(
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
      await _api.createTax(data);
      await loadTaxes(
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

  Future<void> updateTax(
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
      await _api.updateTax(id, data);
      await loadTaxes(
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

  Future<void> deleteTax(
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
      await _api.deleteTax(id);
      await loadTaxes(
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

  Future<void> createTaxCombineGroup({
    required int year,
    required List<int> rowIds,
    List<String>? mergedColumns,
    Map<String, dynamic>? overrides,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createTaxCombineGroup(
        year: year,
        rowIds: rowIds,
        mergedColumns: mergedColumns,
        overrides: overrides,
      );
      await fetchTaxCombineGroups(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTaxCombineGroup({
    required int id,
    required int year,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.deleteTaxCombineGroup(id);
      await fetchTaxCombineGroups(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
