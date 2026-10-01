import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

class AssetProvider with ChangeNotifier {
  final ApiService _api;

  AssetProvider(this._api);

  List<dynamic> _assets = [];
  bool _isLoading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  // New fields for 3-Mode Valuation (Smart UI)
  String _valuationMode = 'recent'; // 'recent', 'projection', 'absolute'

  // Mode 2 State (Projection)
  String _projYears = '';
  String _projMonths = '';

  // Mode 3 State (Absolute)
  String _absYYYY = '';
  String _absMM = '';
  String _absDD = '';

  String? _asOfDate; // Final YY-MM-DD for API

  List<dynamic> get assets => _assets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  String get valuationMode => _valuationMode;
  String get projYears => _projYears;
  String get projMonths => _projMonths;
  String get absYYYY => _absYYYY;
  String get absMM => _absMM;
  String get absDD => _absDD;
  String? get asOfDate => _asOfDate;

  List<Map<String, dynamic>> getGlobalMonthlyBreakdown() {
    final Map<String, Map<String, dynamic>> aggregated = {};
    final assetNames = _assets.map((a) => a['name'] as String).toList();

    for (final asset in _assets) {
      final String name = asset['name'] ?? '-';
      final List<dynamic> breakdown = asset['monthly_breakdown'] ?? [];
      for (final month in breakdown) {
        final String period = month['period'];
        if (!aggregated.containsKey(period)) {
          aggregated[period] = {
            'period': period,
            'total_depreciation': 0.0,
            'total_book_value': 0.0,
            'is_future': month['is_future'] ?? false,
            'assets': {
              for (var n in assetNames) n: 0.0
            } // Initial values for matrix
          };
        }

        aggregated[period]!['total_depreciation'] +=
            (month['depreciation'] ?? 0.0).toDouble();
        aggregated[period]!['total_book_value'] +=
            (month['book_value'] ?? 0.0).toDouble();
        (aggregated[period]!['assets'] as Map<String, double>)[name] =
            (month['book_value'] ?? 0.0).toDouble();
      }
    }

    final result = aggregated.values.toList();
    result.sort((a, b) => a['period'].compareTo(b['period']));
    return result;
  }

  void resetToRecent() {
    _valuationMode = 'recent';
    _projYears = '';
    _projMonths = '';
    _absYYYY = '';
    _absMM = '';
    _absDD = '';
    _asOfDate = null;
    notifyListeners();
    loadAssets();
  }

  void updateProjection({String? years, String? months}) {
    _valuationMode = 'projection';
    if (years != null) _projYears = years;
    if (months != null) _projMonths = months;

    // Calculate Mode 3 values automatically
    final y = int.tryParse(_projYears) ?? 0;
    final m = int.tryParse(_projMonths) ?? 0;
    final totalMonths = (y * 12) + m;

    final now = DateTime.now();
    // Use last day of the calculated month to be safe
    final target = DateTime(now.year, now.month + totalMonths + 1, 0);

    _absYYYY = target.year.toString();
    _absMM = target.month.toString().padLeft(2, '0');
    _absDD = target.day.toString().padLeft(2, '0');
    _asOfDate = '${target.year}-$_absMM-$_absDD';

    notifyListeners();
    loadAssets();
  }

  void updateAbsolute({String? y, String? m, String? d}) {
    _valuationMode = 'absolute';
    if (y != null) _absYYYY = y;
    if (m != null) _absMM = m;
    if (d != null) _absDD = d;

    // Reset Mode 2 when Mode 3 is edited manually
    _projYears = '';
    _projMonths = '';

    // Update API target date if valid
    if (_absYYYY.length == 4 && _absMM.isNotEmpty && _absDD.isNotEmpty) {
      _asOfDate =
          '$_absYYYY-${_absMM.padLeft(2, '0')}-${_absDD.padLeft(2, '0')}';
    }

    notifyListeners();
    loadAssets();
  }

  void updateToken(String? token) {
    _api.setToken(token);
    if (token == null) {
      _assets = [];
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
      loadAssets(year: year);
    }
  }

  Future<void> loadAssets({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? asOfDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final targetYear = year ?? _reportYear;
      final res = await _api.getAssets(
        year: targetYear,
        mode: mode,
        startDate: startDate,
        endDate: endDate,
        asOfDate: asOfDate ?? _asOfDate,
      );
      _assets = res['assets'] ?? [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> createAsset(
    Map<String, dynamic> data, {
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? asOfDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.createAsset(data);
      await loadAssets(
        year: year,
        mode: mode,
        startDate: startDate,
        endDate: endDate,
        asOfDate: asOfDate,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateAsset(
    int id,
    Map<String, dynamic> data, {
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? asOfDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.updateAsset(id, data);
      await loadAssets(
        year: year,
        mode: mode,
        startDate: startDate,
        endDate: endDate,
        asOfDate: asOfDate,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAsset(
    int id, {
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? asOfDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _api.deleteAsset(id);
      await loadAssets(
        year: year,
        mode: mode,
        startDate: startDate,
        endDate: endDate,
        asOfDate: asOfDate,
      );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
