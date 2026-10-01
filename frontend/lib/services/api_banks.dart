import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceBanksExt on ApiService {
  Future<Map<String, dynamic>> getBanks(
      {bool activeOnly = false, String? accountType}) async {
    String urlStr = '${ApiService.baseUrl}/banks?active_only=$activeOnly';
    if (accountType != null) {
      urlStr += '&account_type=$accountType';
    }
    final url = Uri.parse(urlStr);
    final res = await http.get(url, headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createBankAccount(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/banks'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateBankAccount(
      int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/banks/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getBankTransactions({
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
    bool isBankStatus = false,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (bankId != null) params.add('bank_id=$bankId');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    params.add('is_bank_status=$isBankStatus');
    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/banks/transactions', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createBankTransaction(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/banks/transactions'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateBankTransaction(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/banks/transactions/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteBankTransaction(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/banks/transactions/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  // â”€â”€â”€ BANK MANAGEMENT (Bank Cash) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Endpoint: /api/bank-management/...  â†’ hanya 4 bank utama

  Future<Map<String, dynamic>> getManagementBanks({String? accountType}) async {
    final url = accountType != null
        ? '${ApiService.baseUrl}/bank-management/banks?account_type=$accountType'
        : '${ApiService.baseUrl}/bank-management/banks';
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createManagementBankAccount(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/bank-management/banks'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateManagementBankAccount(
      int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/bank-management/banks/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteManagementBankAccount(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/bank-management/banks/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getManagementTransactions({
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (bankId != null) params.add('bank_id=$bankId');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/bank-management/transactions', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createManagementTransaction(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/bank-management/transactions'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateManagementTransaction(
      int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/bank-management/transactions/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteManagementTransaction(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/bank-management/transactions/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  // â”€â”€â”€ BANK STATUS (Laporan Semua Rekening) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  // Endpoint: /api/bank-status/...  â†’ semua 20 bank

  Future<Map<String, dynamic>> getStatusBanks() async {
    final res = await http.get(
        Uri.parse('${ApiService.baseUrl}/bank-status/banks'),
        headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getStatusTransactions({
    int? year,
    int? bankId,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (bankId != null) params.add('bank_id=$bankId');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/bank-status/transactions', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createStatusTransaction(
      Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/bank-status/transactions'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateStatusTransaction(
      int id, Map<String, dynamic> data) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/bank-status/transactions/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteStatusTransaction(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/bank-status/transactions/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }
}
