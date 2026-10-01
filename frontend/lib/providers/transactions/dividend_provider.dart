import 'package:flutter/material.dart';

export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

class DividendProvider with ChangeNotifier {
  final ApiService _api;

  DividendProvider(this._api);

  List<dynamic> _dividends = [];
  Map<String, dynamic> _summary = {};
  bool _isLoading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  List<dynamic> get dividends => _dividends;
  Map<String, dynamic> get summary => _summary;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  void updateToken(String? token) {
    _api.setToken(token);
    if (token == null) {
      _dividends = [];
      _summary = {};
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
      fetchDividends(year: year);
    }
  }

  Future<void> fetchDividends({int? year}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final targetYear = year ?? _reportYear;
      final result = await _api.getDividends(year: targetYear);
      _summary = result;
      _dividends = List<dynamic>.from(result['data'] ?? const []);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> createDividend(Map<String, dynamic> data, {int? year}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createDividend(data);
      await fetchDividends(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDividend(
    int id,
    Map<String, dynamic> data, {
    int? year,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.updateDividend(id, data);
      await fetchDividends(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteDividend(int id, {int? year}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.deleteDividend(id);
      await fetchDividends(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateDividendSetting(
    int year,
    Map<String, dynamic> data,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.updateDividendSetting(year, data);
      await fetchDividends(year: year);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
