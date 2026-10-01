import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceExpensesExt on ApiService {
  // expenses

  Future<Map<String, dynamic>> createExpense({
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
    var request = http.MultipartRequest(
        'POST', Uri.parse('${ApiService.baseUrl}/expenses'));
    request.headers.addAll(authHeaders);
    request.fields['settlement_id'] = settlementId.toString();
    request.fields['category_id'] = categoryId.toString();
    if (categoryIds != null && categoryIds.isNotEmpty) {
      request.fields['category_ids'] = jsonEncode(categoryIds);
    }
    request.fields['description'] = description;
    request.fields['amount'] = amount.toString();
    request.fields['date'] = date;
    if (source != null && source.isNotEmpty) {
      request.fields['source'] = source;
    }
    request.fields['currency'] = currency;
    request.fields['currency_exchange'] = currencyExchange.toString();

    if (filePaths != null && filePaths.isNotEmpty) {
      for (var path in filePaths) {
        request.files.add(await http.MultipartFile.fromPath('evidence', path));
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateExpense(
    int id, {
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
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiService.baseUrl}/expenses/$id'),
    );
    request.headers.addAll(authHeaders);

    if (categoryId != null) {
      request.fields['category_id'] = categoryId.toString();
    }
    if (categoryIds != null) {
      request.fields['category_ids'] = jsonEncode(categoryIds);
    }
    if (description != null) {
      request.fields['description'] = description;
    }
    if (amount != null) {
      request.fields['amount'] = amount.toString();
    }
    if (date != null) {
      request.fields['date'] = date;
    }
    if (source != null) {
      request.fields['source'] = source;
    }
    if (currency != null) {
      request.fields['currency'] = currency;
    }
    if (currencyExchange != null) {
      request.fields['currency_exchange'] = currencyExchange.toString();
    }
    if (notes != null) {
      request.fields['notes'] = notes;
    }
    if (status != null) {
      request.fields['status'] = status;
    }

    if (existingFilePaths != null) {
      request.fields['existing_evidence_paths'] = jsonEncode(existingFilePaths);
    }
    if (existingFileNames != null) {
      request.fields['existing_evidence_filenames'] = jsonEncode(
        existingFileNames,
      );
    }

    if (filePaths != null && filePaths.isNotEmpty) {
      for (var path in filePaths) {
        if (path.startsWith('receipts/')) continue; // skip server paths
        request.files.add(await http.MultipartFile.fromPath('evidence', path));
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteExpense(int expenseId) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/expenses/$expenseId'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> bulkDeleteExpenses(List<int> expenseIds) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/expenses/bulk-delete'),
      headers: headers,
      body: jsonEncode({'expense_ids': expenseIds}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> approveExpense(
    int id,
    String action, {
    String notes = '',
  }) async {
    final ep = action == 'reject' ? 'reject' : 'approve';
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/expenses/$id/$ep'),
      headers: headers,
      body: jsonEncode({'notes': notes}),
    );
    return handleResponse(res);
  }
}
