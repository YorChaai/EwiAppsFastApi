import 'dart:convert';
import 'dart:async';
import 'dart:io' show SocketException;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:expense_app/utils/app_logger.dart';
import 'package:expense_app/services/api_service.dart';


extension ApiServiceAuthExt on ApiService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final targetUrl = '${ApiService.baseUrl}/auth/login';
    appLogger.i('Attempting login to: $targetUrl');

    try {
      // Use a fresh client for login to avoid connection pool issues after IP change
      final client = http.Client();
      try {
        final res = await client
            .post(
              Uri.parse(targetUrl),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'username': username, 'password': password}),
            )
            .timeout(const Duration(seconds: 7)); // 7 seconds timeout for login

        return handleResponse(res);
      } finally {
        client.close();
      }
    } on TimeoutException {
      throw Exception(
          'Gagal terhubung ke server (Timeout). Periksa koneksi dan IP Server.');
    } on SocketException catch (e) {
      throw Exception('Tidak dapat menjangkau server: ${e.message}');
    } catch (e) {
      appLogger.e('Login error', error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> linkGoogleAccount(String idToken) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/link-google'),
        headers: headers,
        body: jsonEncode({'id_token': idToken}),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> unlinkGoogleAccount() async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/unlink-google'),
        headers: headers,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final res = await ApiService.retryRequest(
      () => http.post(
        Uri.parse('${ApiService.baseUrl}/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> register(
    String username,
    String password,
    String fullName,
    String role, {
    String? email,
    String? googleId,
    String? phoneNumber,
    String? workplace,
    List<String>? companyAccess,
  }) async {
    try {
      final res = await ApiService.retryRequest(
        () => http.post(
          Uri.parse('${ApiService.baseUrl}/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': username,
            'password': password,
            'full_name': fullName,
            'email': email,
            'google_id': googleId,
            'role': role,
            'phone_number': phoneNumber,
            'workplace': workplace,
            'company_access': companyAccess,
          }),
        ),
      );
      return handleResponse(res);
    } on TimeoutException {
      throw Exception(networkHint('Koneksi ke server timeout'));
    } on http.ClientException {
      throw Exception(networkHint('Tidak bisa terhubung ke server'));
    }
  }

  Future<List<String>> getSystemCompanies() async {
    try {
      final res = await ApiService.retryRequest(
        () => http.get(Uri.parse('${ApiService.baseUrl}/settings/companies'),
            headers: {'Content-Type': 'application/json'}),
      );
      final body = handleResponse(res);
      if (body['companies'] != null) {
        return List<String>.from(body['companies']);
      }
      return ['EWI Foundation', 'Exspan Wireless Indo'];
    } catch (e) {
      debugPrint('Error getting system companies: $e');
      return ['EWI Foundation', 'Exspan Wireless Indo'];
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/auth/me'),
          headers: headers),
    );
    return handleResponse(res);
  }
}
