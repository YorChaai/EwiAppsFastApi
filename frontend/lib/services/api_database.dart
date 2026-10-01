import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceDatabaseExt on ApiService {
  // settings

  Future<dynamic> getStorageSettings() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/settings/storage'),
      headers: authHeaders,
    );
    return handleResponse(res);
  }

  Future<dynamic> updateStorageSettings(String newDirectory) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settings/storage'),
      headers: headers,
      body: jsonEncode({'new_directory': newDirectory}),
    );
    return handleResponse(res);
  }

  // database management

  Future<Map<String, dynamic>> exportDatabase() async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settings/db/export'),
      headers: authHeaders,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> importDatabasePreview({
    String? filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/settings/db/import-preview'),
    );
    request.headers.addAll(authHeaders);

    if (kIsWeb && fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName ?? 'database.db',
      ));
    } else if (filePath != null) {
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
    } else if (fileBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName ?? 'database.db',
      ));
    } else {
      throw Exception("File database tidak valid atau kosong.");
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> confirmImportDatabase() async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settings/db/import-confirm'),
      headers: authHeaders,
    );
    return handleResponse(res);
  }

  // data cleanup

  Future<Map<String, dynamic>> getCleanupPreview({
    required List<int> years,
    required List<String> modules,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/cleanup/preview'),
      headers: headers,
      body: jsonEncode({
        'years': years.contains(-1) ? ['all'] : years,
        'modules': modules,
      }),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> executeCleanup({
    required List<int> years,
    required List<String> modules,
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/cleanup/execute'),
      headers: headers,
      body: jsonEncode({
        'years': years.contains(-1) ? ['all'] : years,
        'modules': modules,
      }),
    );
    return handleResponse(res);
  }

  Future<void> syncDatabase() async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/cleanup/sync'),
      headers: headers,
    );
    handleResponse(res);
  }
}
