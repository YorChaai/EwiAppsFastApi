import 'dart:io';
import 'package:flutter/material.dart';
import 'package:expense_app/models/advance_model.dart';
import 'package:expense_app/models/dto/advance_requests.dart';
export 'package:expense_app/services/api_service.dart';
import 'package:expense_app/services/api_service.dart';
import 'package:expense_app/utils/event_bus.dart';

import 'package:expense_app/providers/advance/advance_provider_list_ext.dart';
export 'advance_provider_list_ext.dart';
import 'package:expense_app/providers/advance/advance_provider_item_ext.dart';
export 'advance_provider_item_ext.dart';
export 'advance_provider_workflow_ext.dart';
export 'advance_provider_finance_ext.dart';

/// Thrown when approve_all fails because the user's advance balance is insufficient.
class InsufficientAdvanceBalanceException implements Exception {
  final String message;
  final double needed;
  final double available;
  final double shortfall;
  final int userId;
  final String userName;
  final Map<String, dynamic>? cashComposition;

  InsufficientAdvanceBalanceException({
    required this.message,
    required this.needed,
    required this.available,
    required this.shortfall,
    required this.userId,
    required this.userName,
    this.cashComposition,
  });

  @override
  String toString() => message;
}

class AdvanceProvider extends ChangeNotifier {
  final ApiService api;

  List<AdvanceModel> advances = [];
  AdvanceModel? currentAdvance;
  List<Map<String, dynamic>> workflowHistory = [];
  bool loading = false;
  bool workflowHistoryLoading = false;
  String? error;
  bool unsavedDraft = false;
  bool initialized = false;
  int reportYear = DateTime.now().year;
  String filterMode = 'report'; // 'report' or 'actual'
  int? filterYearValue; // Local filter year for list
  String filterYearMode = 'report'; // Local filter mode for list
  String? statusFilter;
  String? startDate;
  String? endDate;
  String? searchQuery;

  AdvanceProvider(this.api) {
    syncReportYear();
  }

  // ✅ Helper to allow extensions to trigger UI updates
  void notify() => notifyListeners();

  Map<String, dynamic>? get currentAdvanceMap => currentAdvance?.toJson();
  List<AdvanceModel> get availableAdvances =>
      advances.where((a) => a.status.name == 'approved' && a.id > 0).toList();
  int get filterYear => filterYearValue ?? reportYear;
  bool get isInitialized => initialized;

  void setFilterMode(String mode, {bool reload = true}) {
    if (filterMode == mode) return;
    filterMode = mode;
    notify();
    if (reload) loadAdvances();
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
    advances = [];
    currentAdvance = null;
    workflowHistory = [];
    workflowHistoryLoading = false;
    loading = false;
    error = null;
    unsavedDraft = false;
    initialized = false;
    notify();
  }

  Future<Map<String, dynamic>> checkUserOutstanding() async {
    try {
      final response = await api.get('/auth/me/outstanding');
      return response;
    } catch (e) {
      debugPrint('Error checking outstanding: $e');
      return {'outstanding': 0, 'is_indebted': false};
    }
  }

  Future<bool> submitStandaloneReturn({
    required double amount,
    required String source,
    required String description,
    required int reportYear,
    File? evidence,
    int? advanceId,
  }) async {
    loading = true;
    error = null;
    notify();

    try {
      final Map<String, String> fields = {
        'amount': amount.toString(),
        'source': source,
        'description': description,
        'report_year': reportYear.toString(),
      };

      if (advanceId != null) {
        fields['advance_id'] = advanceId.toString();
      }

      if (evidence != null) {
        await api.postMultipart(
          '/settlements/standalone_return',
          fields: fields,
          files: {'evidence': evidence},
        );
      } else {
        await api.post('/settlements/standalone_return', data: fields);
      }

      await loadAdvances();
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      loading = false;
      notify();
    }
  }

  /// Create advance tanpa auto-load (untuk unsaved draft)
  Future<Map<String, dynamic>?> createUnsavedAdvance(
    String title,
    String desc, {
    String advanceType = 'single',
    int? reportYear,
    String? documentDate,
  }) async {
    try {
      final res = await api.createAdvance(
        title,
        desc,
        advanceType: advanceType,
        reportYear: reportYear,
        documentDate: documentDate,
      );
      currentAdvance = AdvanceModel.fromJson(res['advance']);
      unsavedDraft = true;
      notify();
      return res['advance'];
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return null;
    }
  }

  /// Save item pertama sekaligus commit advance ke list
  Future<bool> saveFirstItemAndCommitAdvance({
    required int advanceId,
    required AdvanceItemRequest request,
    List<dynamic>? files,
    String? source,
  }) async {
    try {
      final itemSaved = await addAdvanceItem(
        advanceId,
        request,
        files: files,
        source: source,
      );

      if (itemSaved) {
        await loadAdvances();
        unsavedDraft = false;
        return true;
      }
      return false;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  /// Cleanup - delete draft yang tidak ada item
  Future<void> cleanupEmptyDraft(int advanceId) async {
    if (!unsavedDraft) return;

    try {
      await deleteAdvance(advanceId, reload: true);
      unsavedDraft = false;
    } catch (e) {
      unsavedDraft = false;
      notify();
    }
  }

  Future<void> updateAdvance(
    int id,
    String title,
    String desc, {
    String? advanceType,
    String? documentDate,
  }) async {
    try {
      await api.updateAdvance(
        id,
        title: title,
        description: desc,
        advanceType: advanceType,
        documentDate: documentDate,
      );
      await loadAdvances();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
    }
  }

  Future<bool> deleteAdvance(int id, {bool reload = true}) async {
    try {
      await api.deleteAdvance(id);
      if (reload) {
        await loadAdvances();
      }
      GlobalEventBus.triggerRefresh();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateItemPartial(int itemId, Map<String, dynamic> data) async {
    try {
      await api.updateAdvanceItem(
        itemId,
        categoryId: data['category_id'],
        description: data['description'],
        estimatedAmount: data['estimated_amount'],
        files: data['file_paths'],
        date: data['date'],
        source: data['source'],
        currency: data['currency'],
        currencyExchange: data['currency_exchange'],
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

  Future<List<int>> getAdvanceReceipt(int advanceId) async {
    try {
      return await api.getAdvanceReceipt(advanceId);
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> createSettlementFromAdvance(int id) async {
    try {
      final res = await api.createSettlementFromAdvance(id);
      await loadAdvance(id);
      await loadAdvances();
      return res['settlement'];
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return null;
    }
  }

  Future<List<int>> exportExcel({
    String? startDate,
    String? endDate,
    int? advanceId,
  }) {
    return api.exportAdvanceExcel(
      startDate: startDate,
      endDate: endDate,
      advanceId: advanceId,
    );
  }

  Future<List<int>> getBulkPdf({String? startDate, String? endDate}) {
    return api.getBulkAdvancesPdf(startDate: startDate, endDate: endDate);
  }

  Future<List<Map<String, dynamic>>> fetchUserVirtualBalances(
      int userId) async {
    return await api.getUserVirtualBalances(userId);
  }

  Future<bool> moveAdvanceToDraft(int id) async {
    try {
      await api.moveAdvanceToDraft(id);
      await loadAdvance(id);
      await loadAdvances();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> moveToDraft(int id) => moveAdvanceToDraft(id);

  String getEvidenceUrl(String filename) {
    return api.getEvidenceUrl(filename);
  }

  Future<bool> finalApproveAdvance(
    int id, {
    int? bankId,
    double adminFee = 0.0,
    double? disbursedAmount,
    double? returnedAmount,
    String? returnDescription,
    String? disbursementDescription,
    DateTime? disbursementDate,
    DateTime? returnDate,
    List<String>? evidencePaths,
    List<String>? returnEvidencePaths,
    List<String>? existingDisbursementPaths,
    List<String>? existingDisbursementFilenames,
    List<String>? existingReturnPaths,
    List<String>? existingReturnFilenames,
  }) async {
    try {
      final result = await api.finalApproveAdvance(
        id,
        bankId: bankId ?? 0,
        adminFee: adminFee,
        disbursedAmount: disbursedAmount,
        returnedAmount: returnedAmount,
        returnDescription: returnDescription,
        disbursementDescription: disbursementDescription,
        disbursementDate: disbursementDate,
        returnDate: returnDate,
        evidencePaths: evidencePaths,
        returnEvidencePaths: returnEvidencePaths,
        existingDisbursementPaths: existingDisbursementPaths,
        existingDisbursementFilenames: existingDisbursementFilenames,
        existingReturnPaths: existingReturnPaths,
        existingReturnFilenames: existingReturnFilenames,
      );
      if (result['http_status'] == 422 &&
          result['insufficient_advance_balance'] == true) {
        throw InsufficientAdvanceBalanceException(
          message: result['error'] ?? 'Saldo advance tidak mencukupi',
          needed: (result['needed'] ?? 0).toDouble(),
          available: (result['available'] ?? 0).toDouble(),
          shortfall: (result['shortfall'] ?? 0).toDouble(),
          userId: (result['user_id'] ?? 0) as int,
          userName: result['user_name'] ?? 'Karyawan',
          cashComposition: result['cash_composition'] != null
              ? Map<String, dynamic>.from(result['cash_composition'])
              : {},
        );
      }
      await loadAdvance(id);
      await loadAdvances();
      return true;
    } on InsufficientAdvanceBalanceException {
      rethrow;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
