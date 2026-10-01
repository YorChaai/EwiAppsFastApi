import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceRevenuesExt on ApiService {
  // revenues

  Future<List<dynamic>> getRevenues({
    String? startDate,
    String? endDate,
    int? year,
    String? mode,
  }) async {
    final params = <String>[];
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');

    final url = ApiService.buildUrl('${ApiService.baseUrl}/revenues', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Gagal memuat revenues');
  }

  Future<Map<String, dynamic>> createRevenue(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/revenues'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateRevenue(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/revenues/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteRevenue(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/revenues/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> toggleTaxOffset(int revenueId) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/revenues/$revenueId/toggle-tax-offset'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<List<dynamic>> getRevenueCombineGroups({required int year}) async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/revenues/combine-groups?year=$year'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Gagal memuat combine revenue');
  }

  Future<Map<String, dynamic>> createRevenueCombineGroup({
    required int year,
    required List<int> rowIds,
    List<String>? mergedColumns,
    Map<String, dynamic>? overrides,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/revenues/combine-groups'),
      headers: headers,
      body: jsonEncode({
        'year': year,
        'row_ids': rowIds,
        'merged_columns': mergedColumns,
        'overrides': overrides,
      }),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteRevenueCombineGroup(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/revenues/combine-groups/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }
}
