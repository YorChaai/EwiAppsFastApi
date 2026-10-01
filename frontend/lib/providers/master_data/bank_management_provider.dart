import 'package:flutter/material.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/bank_order_preferences.dart';

/// Provider khusus untuk Bank Management (Bank Cash / Kas Riil)
/// Hanya mengelola 4 bank utama: BRI, BNI, Mandiri, BCA
/// Endpoint: /api/bank-management/...
class BankManagementProvider with ChangeNotifier {
  final ApiService _api;

  BankManagementProvider(this._api);

  List<dynamic> _banks = [];
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
      final res = await _api.getManagementBanks();
      final list = List<dynamic>.from(res['banks'] ?? []);
      final customOrder = await BankOrderPreferences.getBankCashOrder();
      BankOrderPreferences.sortBankMaps(list, customOrderIds: customOrder);
      _banks = list;
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
      final data = await _api.getManagementTransactions(
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
      await _api.createManagementTransaction(data);
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
      await _api.updateManagementTransaction(id, data);
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
      await _api.deleteManagementTransaction(id);
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

  Future<void> createBankAccount(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.createManagementBankAccount(data);
      await loadBanks();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateBankAccount(int id, Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.updateManagementBankAccount(id, data);
      await loadBanks();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteBankAccount(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _api.deleteManagementBankAccount(id);
      await loadBanks();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
