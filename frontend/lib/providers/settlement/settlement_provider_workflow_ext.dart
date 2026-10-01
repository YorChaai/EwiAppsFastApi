import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderWorkflowExt on SettlementProvider {
  Future<bool> submitSettlement(int id) async {
    try {
      await api.submitSettlement(id);
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

  Future<bool> completeSettlement(int id) async {
    try {
      await api.completeSettlement(id);
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

  Future<bool> approveSettlement(int id) async {
    try {
      await api.approveSettlement(id);
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

  Future<bool> approveExpense(
    int expenseId,
    String action, {
    String notes = '',
  }) async {
    try {
      String finalNotes = notes;
      if (action == 'approve' &&
          finalNotes.isEmpty &&
          currentSettlement != null) {
        final expenses = currentSettlement!['expenses'] as List? ?? [];
        final existing = expenses.firstWhere(
          (e) => e['id'] == expenseId,
          orElse: () => null,
        );
        if (existing != null && existing['notes'] != null) {
          finalNotes = existing['notes'].toString();
        }
      }

      await api.approveExpense(expenseId, action, notes: finalNotes);
      if (currentSettlement != null) {
        await loadSettlement(currentSettlement!['id']);
      }
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> approveAllSettlement(int settlementId) async {
    try {
      await api.approveSettlement(settlementId);
      await loadSettlement(settlementId);
      await loadSettlements();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> rejectAllSettlement(
    int settlementId, {
    String notes = '',
  }) async {
    try {
      await api.rejectAllSettlement(settlementId, notes: notes);
      await loadSettlement(settlementId);
      await loadSettlements();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> rejectAllExpenses(int id, String notes) async {
    try {
      await api.rejectAllExpenses(id, notes: notes);
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

  Future<bool> moveSettlementToDraft(int id) async {
    try {
      await api.moveSettlementToDraft(id);
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

  Future<bool> moveToDraft(int id) => moveSettlementToDraft(id);
}
