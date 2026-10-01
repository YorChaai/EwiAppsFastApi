import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';

/// Provider khusus untuk Bank Status (Laporan Mutasi Semua Rekening)
/// Mengelola semua 20 bank (4 utama + 16 varian: Giro, Bisnis, TabBis, Valas)
/// Endpoint: /api/bank-status/...
class BankStatusProvider with ChangeNotifier {
  final ApiService _api;

  BankStatusProvider(this._api);

  List<dynamic> _banks = []; // Semua 20 bank untuk dropdown/filter
  List<dynamic> _transactions = [];
  bool _isLoading = false;
  String? _error;
  int _reportYear = DateTime.now().year;
  bool _initialized = false;

  List<dynamic> get banks => _banks;
  List<dynamic> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get reportYear => _reportYear;
  bool get isInitialized => _initialized;

  void updateToken(String? token) {
    _api.setToken(token);
    if (token == null) {
      _banks = [];
      _transactions = [];
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
      _reportYear = (year != null && year != 0) ? year : DateTime.now().year;
      _initialized = true;
      notifyListeners();
    } catch (_) {}
  }

  void setReportYear(int year) {
    _reportYear = year;
    _initialized = true;
    notifyListeners();
  }

  Future<void> loadBanks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _api.getStatusBanks();
      _banks = res['banks'] ?? [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTransactions({
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.getStatusTransactions(
        year: year,
        bankId: bankId,
        mode: mode,
        startDate: startDate,
        endDate: endDate,
      );
      _transactions = data['transactions'] ?? [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTransaction(
    Map<String, dynamic> data, {
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.createStatusTransaction(data);
      await loadTransactions(
          year: year,
          bankId: bankId,
          mode: mode,
          startDate: startDate,
          endDate: endDate);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction(
    int id,
    Map<String, dynamic> data, {
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.updateStatusTransaction(id, data);
      await loadTransactions(
          year: year,
          bankId: bankId,
          mode: mode,
          startDate: startDate,
          endDate: endDate);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteTransaction(
    int id, {
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.deleteStatusTransaction(id);
      await loadTransactions(
          year: year,
          bankId: bankId,
          mode: mode,
          startDate: startDate,
          endDate: endDate);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
