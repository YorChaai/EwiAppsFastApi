import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderCrudExt on SettlementProvider {
  Future<Map<String, dynamic>?> createSettlement(
    String title,
    String description, {
    int? advanceId,
    int? copyFromAdvanceId,
    String settlementType = 'single',
    int? reportYear,
    String? documentDate,
  }) async {
    loading = true;
    error = null;
    notify();
    try {
      final res = await api.createSettlement(
        title,
        description,
        advanceId: advanceId,
        copyFromAdvanceId: copyFromAdvanceId,
        settlementType: settlementType,
        reportYear: reportYear,
        documentDate: documentDate,
      );

      final newSettlement = res['settlement'];
      currentSettlement = newSettlement;
      unsavedDraft = true;

      loading = false;
      notify();
      return newSettlement;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      loading = false;
      notify();
      return null;
    }
  }

  Future<bool> updateSettlement(
    int id, {
    String? title,
    String? description,
    String? documentDate,
  }) async {
    try {
      await api.updateSettlement(id,
          title: title, description: description, documentDate: documentDate);
      await loadSettlement(id, notifyState: false);
      notify();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> deleteSettlement(int id, {bool reload = true}) async {
    try {
      await api.deleteSettlement(id);
      if (reload) {
        await loadSettlements();
      }
      GlobalEventBus
          .triggerRefresh(); // Refresh balances in Bank Advance and Settings
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
