import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceCategoriesExt on ApiService {
  // categories

  Future<Map<String, dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/expenses/categories'),
      headers: headers,
    );
    return handleResponse(res);
  }

  // category management

  Future<Map<String, dynamic>> createCategory(
    String name, {
    int? parentId,
  }) async {
    final body = <String, dynamic>{'name': name};
    if (parentId != null) body['parent_id'] = parentId;
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/categories'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateCategory(int id, String name) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/categories/$id'),
      headers: headers,
      body: jsonEncode({'name': name}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> reorderCategories(
    List<Map<String, dynamic>> categories,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/categories/reorder'),
      headers: headers,
      body: jsonEncode({'categories': categories}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteCategory(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/categories/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getPendingCategories() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/categories/pending'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> approveCategory(int id, String action) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/categories/$id/approve'),
      headers: headers,
      body: jsonEncode({'action': action}),
    );
    return handleResponse(res);
  }

  // category groups

  Future<Map<String, dynamic>> getCategoryGroups() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/categories/groups'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createCategoryGroup(String name) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/categories/groups'),
      headers: headers,
      body: jsonEncode({'name': name}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateCategoryGroup(
    int id, {
    String? name,
    int? sortOrder,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (sortOrder != null) body['sort_order'] = sortOrder;
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/categories/groups/$id'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteCategoryGroup(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/categories/groups/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> reorderCategoryGroups(
    List<Map<String, dynamic>> groups,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/categories/groups/reorder'),
      headers: headers,
      body: jsonEncode({'groups': groups}),
    );
    return handleResponse(res);
  }
}
