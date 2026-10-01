import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceTaxesExt on ApiService {
  // taxes

  Future<List<dynamic>> getTaxes({
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

    final url = ApiService.buildUrl('${ApiService.baseUrl}/taxes', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Gagal memuat pajak(taxes)');
  }

  Future<Map<String, dynamic>> createTax(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/taxes'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateTax(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/taxes/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteTax(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/taxes/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<List<dynamic>> getTaxCombineGroups({required int year}) async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/taxes/combine-groups?year=$year'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Gagal memuat combine pajak');
  }

  Future<Map<String, dynamic>> createTaxCombineGroup({
    required int year,
    required List<int> rowIds,
    List<String>? mergedColumns,
    Map<String, dynamic>? overrides,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/taxes/combine-groups'),
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

  Future<Map<String, dynamic>> deleteTaxCombineGroup(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/taxes/combine-groups/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }
}
