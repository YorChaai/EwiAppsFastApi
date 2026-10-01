import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceAssetsExt on ApiService {
  // assets

  Future<Map<String, dynamic>> getAssets({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? asOfDate,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (asOfDate != null) params.add('as_of_date=$asOfDate');
    final url = ApiService.buildUrl('${ApiService.baseUrl}/assets', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createAsset(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/assets'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateAsset(
    int id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/assets/$id'),
      headers: headers,
      body: jsonEncode(data),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteAsset(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/assets/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }
}
