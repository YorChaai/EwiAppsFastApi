import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

abstract class BaseTransactionProvider extends ChangeNotifier {
  final ApiService api = ApiService();

  bool _loading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  bool get loading => _loading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  set error(String? val) {
    _error = val;
    notifyListeners();
  }

  void updateToken(String? token) {
    api.setToken(token);
    if (token == null) {
      clearData();
    } else {
      syncReportYear(force: true);
    }
  }

  void clearData() {
    _loading = false;
    _error = null;
    _initialized = false;
    notifyListeners();
  }

  Future<void> syncReportYear({bool force = false}) async {
    try {
      final settings = await api.getReportYearSettings();
      _reportYear = settings['default_report_year'] != null
          ? int.parse(settings['default_report_year'].toString())
          : DateTime.now().year;
      _initialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Sync Year Error: $e');
    }
  }
}
