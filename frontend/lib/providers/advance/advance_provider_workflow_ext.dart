import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/models/advance_model.dart';


extension AdvanceProviderWorkflowExt on AdvanceProvider {
  Future<bool> submitAdvance(int id) async {
    try {
      await api.submitAdvance(id);
      await loadAdvance(id);
      await loadAdvances();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> approveAdvance(int id, {String notes = ''}) async {
    try {
      final result = await api.approveAdvance(id, notes: notes);
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

  Future<bool> approveAdvanceItem(
    int itemId,
    String action, {
    String notes = '',
  }) async {
    try {
      String finalNotes = notes;
      if (action == 'approve' &&
          finalNotes.isEmpty &&
          currentAdvance != null) {
        final items = currentAdvance!.items;
        try {
          final existing = items.firstWhere((e) => e.id == itemId);
          if (existing.notes != null) {
            finalNotes = existing.notes!;
          }
        } catch (_) {}
      }

      final result =
          await api.approveAdvanceItem(itemId, action, notes: finalNotes);

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

      if (currentAdvance != null) {
        await loadAdvance(currentAdvance!.id);
      }

      return true;
    } on InsufficientAdvanceBalanceException {
      rethrow;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> rejectAdvance(int id, String notes) async {
    try {
      await api.rejectAdvance(id, notes: notes);
      await loadAdvance(id);
      await loadAdvances();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> startRevision(int id) async {
    try {
      final res = await api.startAdvanceRevision(id);
      currentAdvance = AdvanceModel.fromJson(res['advance']);
      await loadAdvances();
      notify();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
