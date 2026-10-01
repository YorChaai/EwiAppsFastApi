import 'dart:io';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';


extension SettlementProviderFinanceExt on SettlementProvider {
  Future<bool> saveDisbursement({
    required int settlementId,
    int? bankId,
    String? disbursementSource,
    int? disbursementSourceId,
    String? disbursementComment,
    double? adminFee,
    double? disbursedAmount,
    DateTime? disbursementDate,
    List<File>? evidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    try {
      await api.saveDisbursementSettlement(
        settlementId: settlementId,
        bankId: bankId,
        disbursementSource: disbursementSource,
        disbursementSourceId: disbursementSourceId,
        disbursementComment: disbursementComment,
        adminFee: adminFee,
        disbursedAmount: disbursedAmount,
        disbursementDate: disbursementDate,
        evidenceFiles: evidenceFiles,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
      );
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> approveDisbursement(int settlementId) async {
    try {
      final result = await api.approveDisbursementSettlement(settlementId);
      if (result['http_status'] == 422) {
        if (result['insufficient_advance_balance'] == true) {
          throw InsufficientAdvanceBalanceException(
            message: result['error'] ?? 'Saldo advance tidak mencukupi.',
            needed: (result['needed'] ?? 0).toDouble(),
            available: (result['available'] ?? 0).toDouble(),
            shortfall: (result['shortfall'] ?? 0).toDouble(),
            userId: (result['user_id'] ?? 0) as int,
            userName: result['user_name'] ?? 'Karyawan',
            cashComposition: result['cash_composition'] != null
                ? Map<String, dynamic>.from(result['cash_composition'])
                : {},
          );
        } else {
          error = result['error'] ?? 'Gagal menyetujui pengiriman';
          notify();
          return false;
        }
      }
      await loadSettlement(settlementId);
      return true;
    } on InsufficientAdvanceBalanceException {
      rethrow;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> saveReturn({
    required int settlementId,
    double? returnedAmount,
    String? returnSource,
    int? returnSourceId,
    String? returnDescription,
    List<File>? returnEvidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    try {
      await api.saveReturnSettlement(
        settlementId: settlementId,
        returnedAmount: returnedAmount,
        returnSource: returnSource,
        returnSourceId: returnSourceId,
        returnDescription: returnDescription,
        returnEvidenceFiles: returnEvidenceFiles,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
      );
      await loadSettlement(settlementId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> finalApproveSettlement(
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
      await api.finalApproveSettlement(
        id,
        bankId ?? 0,
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
      await loadSettlement(id, notifyState: false);
      await loadSettlements(notifyState: false);
      notify();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
