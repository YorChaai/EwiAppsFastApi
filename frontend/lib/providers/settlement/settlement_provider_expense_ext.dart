import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderExpenseExt on SettlementProvider {
  Future<bool> saveFirstExpenseAndCommitSettlement({
    required int settlementId,
    required int categoryId,
    List<int>? categoryIds,
    required String description,
    required double amount,
    required String date,
    String? source,
    String currency = 'IDR',
    double currencyExchange = 1,
    List<String>? filePaths,
  }) async {
    try {
      await api.createExpense(
        settlementId: settlementId,
        categoryId: categoryId,
        categoryIds: categoryIds,
        description: description,
        amount: amount,
        date: date,
        source: source,
        currency: currency,
        currencyExchange: currencyExchange,
        filePaths: filePaths,
      );

      await loadSettlement(settlementId);
      await loadSettlements(
        status: statusFilter,
        startDate: startDate,
        endDate: endDate,
        reportYear: reportYear,
        search: searchQuery,
      );
      unsavedDraft = false;
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<void> cleanupEmptyDraft(int settlementId) async {
    if (!unsavedDraft) return;

    try {
      await deleteSettlement(settlementId, reload: true);
      unsavedDraft = false;
    } catch (e) {
      unsavedDraft = false;
      notify();
    }
  }

  Future<bool> addExpense({
    required int settlementId,
    required int categoryId,
    List<int>? categoryIds,
    required String description,
    required double amount,
    required String date,
    String? source,
    String currency = 'IDR',
    double currencyExchange = 1,
    List<String>? filePaths,
  }) async {
    try {
      await api.createExpense(
        settlementId: settlementId,
        categoryId: categoryId,
        categoryIds: categoryIds,
        description: description,
        amount: amount,
        date: date,
        source: source,
        currency: currency,
        currencyExchange: currencyExchange,
        filePaths: filePaths,
      );
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateExpense({
    required int expenseId,
    required int settlementId,
    int? categoryId,
    List<int>? categoryIds,
    String? description,
    double? amount,
    String? date,
    String? source,
    String? currency,
    double? currencyExchange,
    List<String>? filePaths,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
    String? notes,
    String? status,
  }) async {
    try {
      await api.updateExpense(
        expenseId,
        categoryId: categoryId,
        categoryIds: categoryIds,
        description: description,
        amount: amount,
        date: date,
        source: source,
        currency: currency,
        currencyExchange: currencyExchange,
        filePaths: filePaths,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
        notes: notes,
        status: status,
      );
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateExpenseData(
    int expenseId,
    int settlementId,
    Map<String, dynamic> data,
  ) async {
    try {
      await updateExpense(
        expenseId: expenseId,
        settlementId: settlementId,
        categoryId: data['category_id'],
        description: data['description'],
        amount: data['amount'],
        date: data['date'],
        source: data['source'],
        currency: data['currency'],
        currencyExchange: data['currency_exchange'],
        filePaths: data['file_paths'],
        notes: data['notes'],
        status: data['status'],
      );
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateExpensesBulk(
    int settlementId,
    Map<String, dynamic> updates,
    List<int> ids,
  ) async {
    try {
      await api.updateExpensesBulk(settlementId, updates, ids);
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> deleteExpense(int expenseId, int settlementId) async {
    try {
      await api.deleteExpense(expenseId);
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> bulkDeleteExpenses(
    List<int> expenseIds,
    int settlementId,
  ) async {
    try {
      await api.bulkDeleteExpenses(expenseIds);
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
