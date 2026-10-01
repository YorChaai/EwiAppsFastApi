import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/services/api_service.dart';


extension SettlementProviderCategoryExt on SettlementProvider {
  Future<void> loadCategories() async {
    try {
      final res = await api.getCategories();
      categories = List<Map<String, dynamic>>.from(res['categories']);
      notify();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> loadPendingCategories() async {
    try {
      final res = await api.getPendingCategories();
      pendingCategories = List<Map<String, dynamic>>.from(res['categories']);
      notify();
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<bool> createCategory(String name, {int? parentId}) async {
    try {
      await api.createCategory(name, parentId: parentId);
      await loadCategories();
      await loadPendingCategories();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateCategory(int id, String name) async {
    try {
      await api.updateCategory(id, name);
      await loadCategories();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> reorderCategories(List<Map<String, dynamic>> categories) async {
    try {
      await api.reorderCategories(categories);
      await loadCategories();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      await api.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> approveCategory(int id, String action) async {
    try {
      await api.approveCategory(id, action);
      await loadPendingCategories();
      await loadCategories();
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
