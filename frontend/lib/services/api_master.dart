import 'dart:convert';
import 'dart:async';
import 'dart:io' show File, Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceMasterExt on ApiService {
  void setToken(String? token) {
    ApiService.token = token;
  }

  void setCompany(String? company) {
    ApiService.activeCompany = company;
  }

  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        if (ApiService.token != null)
          'Authorization': 'Bearer ${ApiService.token}',
        if (ApiService.activeCompany != null)
          'X-Company': ApiService.activeCompany!,
      };

  Map<String, String> get authHeaders => {
        if (ApiService.token != null)
          'Authorization': 'Bearer ${ApiService.token}',
        if (ApiService.activeCompany != null)
          'X-Company': ApiService.activeCompany!,
      };

  // Public getter for auth headers

  Map<String, String> getAuthHeaders() => authHeaders;

  // --- Generic Helpers ---
  Future<Map<String, dynamic>> get(String endpoint) async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}$endpoint'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> post(String endpoint, {dynamic data}) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}$endpoint'),
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('${ApiService.baseUrl}$endpoint'));
    request.headers.addAll(authHeaders);

    if (fields != null) request.fields.addAll(fields);
    if (files != null) {
      for (var entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
        );
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }
  // ------------------------

  // evidence

  String getEvidenceUrl(String filename) {
    return '${ApiService.baseUrl}/expenses/evidence/$filename';
  }

  Map<String, dynamic> handleResponse(http.Response res) {
    // GLOBAL LOGGING: Tampilkan semua error backend ke terminal otomatis, kecuali 401 (Auth) agar tidak berisik saat restart
    if ((res.statusCode < 200 || res.statusCode >= 300) &&
        res.statusCode != 401) {
      debugPrint('\\n${'=' * 50}');
      debugPrint('[BACKEND ERROR] Detected at ${DateTime.now()}');
      debugPrint('Endpoint: ${res.request?.method} ${res.request?.url}');
      debugPrint('Status Code: ${res.statusCode}');
      debugPrint('Error Body: ${res.body}');
      debugPrint('=' * 50 + '\\n');
    }

    if (res.statusCode == 429) {
      String msg = 'Terlalu banyak permintaan. Mohon tunggu sebentar.';
      try {
        final body = jsonDecode(res.body);
        msg = body['error'] ?? body['message'] ?? msg;
      } catch (_) {}
      throw Exception(msg);
    }

    if (res.statusCode == 413) {
      throw Exception('File terlalu besar (Maks 16MB)');
    }

    // Handle 401 Unauthorized - token expired or wrong credentials
    if (res.statusCode == 401) {
      String? errorMessage;
      try {
        final body = jsonDecode(res.body);
        errorMessage = body['error'];
      } catch (_) {}

      if (errorMessage != null) {
        throw Exception(errorMessage);
      }
      throw Exception('Sesi expired. Silakan login kembali.');
    }

    // Handle empty body
    if (res.body.trim().isEmpty) {
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return {};
      }
      throw Exception('Server Error: ${res.statusCode}');
    }

    try {
      final body = jsonDecode(res.body);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return body;
      }
      throw Exception(body['error'] ?? 'Terjadi kesalahan: ${res.statusCode}');
    } on FormatException {
      throw Exception('Server Error ${res.statusCode}: Respon tidak valid');
    }
  }

  String networkHint(String message) {
    if (!kIsWeb && Platform.isAndroid) {
      if (ApiService.configuredBaseUrl.isEmpty) {
        return '$message. Pastikan: (1) Backend FastAPI aktif, (2) HP & PC di WiFi yang sama, (3) IP address benar';
      }
      return '$message. Periksa: (1) Backend FastAPI aktif, (2) WiFi sama, (3) Firewall tidak memblokir port 8000';
    }
    return '$message. Periksa backend aktif di ${ApiService.baseUrl}';
  }
}
