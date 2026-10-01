import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceCompaniesExt on ApiService {
  Future<List<Map<String, dynamic>>> getCompanies() async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/companies'),
          headers: headers),
    );
    final decoded = handleResponse(res);
    if (decoded['success'] == true) {
      return List<Map<String, dynamic>>.from(decoded['data'] ?? []);
    }
    return [];
  }

  Future<Map<String, dynamic>> createCompany(String name) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/companies'),
        headers: headers,
        body: jsonEncode({'name': name}),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateCompany(int id, String newName) async {
    final res = await ApiService.retryRequest(
      () => http.put(
        Uri.parse('${ApiService.baseUrl}/companies/$id'),
        headers: headers,
        body: jsonEncode({'name': newName}),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteCompany(int id) async {
    final res = await ApiService.retryRequest(
      () => http.delete(
        Uri.parse('${ApiService.baseUrl}/companies/$id'),
        headers: headers,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> reorderCompanies(
    List<Map<String, dynamic>> companies,
  ) async {
    final res = await ApiService.retryRequest(
      () => http.put(
        Uri.parse('${ApiService.baseUrl}/companies/reorder'),
        headers: headers,
        body: jsonEncode({'companies': companies}),
      ),
    );
    return handleResponse(res);
  }
}
