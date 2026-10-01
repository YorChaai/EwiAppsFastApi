import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceDividendsExt on ApiService {
  // dividends

  Future<Map<String, dynamic>> getDividends({int? year}) async {
    String url = '${ApiService.baseUrl}/dividends';
    if (year != null) {
      url += '?year=$year';
    }

    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createDividend(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/dividends'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateDividend(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/dividends/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteDividend(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/dividends/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateDividendSetting(
    int year,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/dividends/settings/$year'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }
}
