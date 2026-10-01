import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/models/dto/advance_requests.dart';


extension AdvanceProviderItemExt on AdvanceProvider {
  Future<bool> addAdvanceItem(
    int advanceId,
    AdvanceItemRequest request, {
    List<dynamic>? files,
    String? source,
  }) async {
    try {
      await api.addAdvanceItem(
        advanceId,
        request.categoryId,
        request.description,
        request.estimatedAmount,
        categoryIds: request.subcategoryIds,
        files: files,
        date: request.date,
        source: source,
        currency: request.currency,
        currencyExchange: request.currencyExchange,
      );
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateAdvanceItem(
    int itemId,
    AdvanceItemRequest request, {
    List<dynamic>? files,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
    String? source,
    String? status,
  }) async {
    try {
      await api.updateAdvanceItem(
        itemId,
        categoryId: request.categoryId,
        categoryIds: request.subcategoryIds,
        description: request.description,
        estimatedAmount: request.estimatedAmount,
        files: files,
        existingFilePaths: existingFilePaths,
        existingFileNames: existingFileNames,
        date: request.date,
        source: source,
        currency: request.currency,
        currencyExchange: request.currencyExchange,
        notes: request.notes,
        status: status,
      );
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> deleteAdvanceItem(int itemId) async {
    try {
      await api.deleteAdvanceItem(itemId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> bulkDeleteAdvanceItems(List<int> itemIds, int advanceId) async {
    try {
      await api.bulkDeleteAdvanceItems(itemIds);
      await loadAdvance(advanceId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }

  Future<bool> updateAdvanceItemsBulk(
    int advanceId,
    List<int> itemIds,
    Map<String, dynamic> updates,
  ) async {
    try {
      await api.updateAdvanceItemsBulk(advanceId, itemIds, updates);
      await loadAdvance(advanceId);
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      notify();
      return false;
    }
  }
}
