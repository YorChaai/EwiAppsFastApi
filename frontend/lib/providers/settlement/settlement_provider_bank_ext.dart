import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderBankExt on SettlementProvider {
  Future<void> loadBanks({String? accountType}) async {
    try {
      final res = await api.getManagementBanks(accountType: accountType);
      banks = List<Map<String, dynamic>>.from(res['banks']);
      notify();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> loadAdvanceBanks() async {
    try {
      final res = await api.getManagementBanks(accountType: 'advance');
      advanceBanks = List<Map<String, dynamic>>.from(res['banks']);
      notify();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserVirtualBalances(
      int userId) async {
    return await api.getUserVirtualBalances(userId);
  }
}
