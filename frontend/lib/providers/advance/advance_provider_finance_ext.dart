import 'dart:io';
import 'package:expense_app/providers/advance/advance_provider.dart';


extension AdvanceProviderFinanceExt on AdvanceProvider {
  Future<bool> saveDisbursement({
    required int advanceId,
    int? bankId,
    String? disbursementSource,
    int? disbursementSourceId,
    String? disbursementComment,
    double? adminFee,
    double? disbursedAmount,
    List<File>? evidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    try {
      await api.saveDisbursementAdvance(
        advanceId: advanceId,
        bankId: bankId,
        disbursementSource: disbursementSource,
        disbursementSourceId: disbursementSourceId,
        disbursementComment: disbursementComment,
        adminFee: adminFee,
        disbursedAmount: disbursedAmount,
        evidenceFiles: evidenceFiles,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
      );
      await loadAdvance(advanceId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> approveDisbursement(int advanceId) async {
    try {
      final result = await api.approveDisbursementAdvance(advanceId);
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
      await loadAdvance(advanceId);
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
    required int advanceId,
    double? returnedAmount,
    String? returnSource,
    int? returnSourceId,
    String? returnDescription,
    List<File>? returnEvidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    try {
      await api.saveReturnAdvance(
        advanceId: advanceId,
        returnedAmount: returnedAmount,
        returnSource: returnSource,
        returnSourceId: returnSourceId,
        returnDescription: returnDescription,
        returnEvidenceFiles: returnEvidenceFiles,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
      );
      await loadAdvance(advanceId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
