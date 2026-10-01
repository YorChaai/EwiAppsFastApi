export 'api_master.dart';
export 'api_auth.dart';
export 'api_users.dart';
export 'api_advances.dart';
export 'api_banks.dart';
export 'api_categories.dart';
export 'api_companies.dart';
export 'api_database.dart';
export 'api_dividends.dart';
export 'api_expenses.dart';
export 'api_reports.dart';
export 'api_revenues.dart';
export 'api_settlements.dart';
export 'api_taxes.dart';
export 'api_assets.dart';

import 'dart:async';
import 'dart:io' show Platform, HttpException, SocketException;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:expense_app/utils/app_logger.dart';
import 'package:expense_app/services/api_master.dart';


class ApiService {
  static const String configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const String baseUrlPrefsKey = 'api_base_url';
  static String? runtimeBaseUrl;

  static const Duration requestTimeout = Duration(seconds: 10);
  static const int maxRetries = 1;

  /// Helper untuk build URL dengan query parameters menggunakan StringBuffer
  static String buildUrl(String baseUrl, List<String> params) {
    if (params.isEmpty) return baseUrl;
    final buffer = StringBuffer(baseUrl);
    buffer.write('?');
    buffer.write(params.join('&'));
    return buffer.toString();
  }

  /// Helper untuk retry request jika terjadi connection reset
  static Future<http.Response> retryRequest(
    Future<http.Response> Function() requestFn,
  ) async {
    int attempts = 0;
    Exception lastException = Exception('Unknown error');

    while (attempts <= maxRetries) {
      try {
        return await requestFn().timeout(requestTimeout);
      } on http.ClientException catch (e) {
        lastException = Exception('Connection error: ${e.message}');
        attempts++;
      } on TimeoutException catch (e) {
        lastException = Exception('Request timeout: ${e.message}');
        attempts++;
      } on HttpException catch (e) {
        lastException = Exception('HTTP error: ${e.message}');
        attempts++;
      } on SocketException catch (e) {
        lastException = Exception('Network error: ${e.message}');
        attempts++;
      } catch (e) {
        appLogger.e('Unexpected error during API request', error: e);
        lastException = Exception('Unexpected error: $e');
        rethrow;
      }

      if (attempts <= maxRetries) {
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      }
    }

    throw lastException;
  }

  static String get baseUrl {
    try {
      if (dotenv.isInitialized) {
        final envUrl = dotenv.env['API_BASE_URL'];
        if (envUrl != null && envUrl.isNotEmpty) {
          return envUrl;
        }
      }
    } catch (_) {}

    if (kIsWeb) return 'http://127.0.0.1:8000/api';

    // Prioritaskan URL yang disimpan oleh user (jika ada)
    if (runtimeBaseUrl != null && runtimeBaseUrl!.isNotEmpty) {
      return runtimeBaseUrl!.replaceAll('`', '').trim();
    }

    try {
      if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Laptop/Desktop otomatis pakai localhost, tidak perlu ganti IP
        return 'http://127.0.0.1:8000/api';
      } else if (Platform.isAndroid) {
        // Gunakan 10.0.2.2 jika di Android Emulator,
        // atau ganti dengan IP WiFi laptop Anda (misal 192.168.x.x) jika pakai HP fisik
        // return 'http://192.168.68.55:8000/api'; // Contoh HP Fisik
        return 'http://10.0.2.2:8000/api'; // Default Emulator
      }
    } catch (_) {}

    // Fallback default
    return 'http://127.0.0.1:8000/api';
  }

  static Future<void> loadSavedBaseUrl() async {
    if (configuredBaseUrl.isNotEmpty) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    runtimeBaseUrl = prefs.getString(baseUrlPrefsKey);
  }

  static Future<void> saveBaseUrl(String url) async {
    if (configuredBaseUrl.isNotEmpty) {
      return;
    }
    final normalized = url.trim().replaceAll(RegExp(r'/$'), '');
    final prefs = await SharedPreferences.getInstance();
    if (normalized.isEmpty) {
      runtimeBaseUrl = null;
      await prefs.remove(baseUrlPrefsKey);
      return;
    }
    runtimeBaseUrl = normalized;
    await prefs.setString(baseUrlPrefsKey, normalized);
    appLogger.i('API Base URL updated to: $normalized');
  }

  /// Check if the server is reachable with a short timeout
  static Future<bool> checkConnectivity() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/health'),
          )
          .timeout(const Duration(seconds: 3));
      return res.statusCode == 200;
    } catch (e) {
      appLogger.w('Connectivity check failed', error: e);
      return false;
    }
  }

  static String? token;
  static String? activeCompany;
  static Future<void>? tokenLoadingFuture;

  ApiService() {
    // Start loading token in background, but don't wait
    tokenLoadingFuture ??= loadTokenFromStorage();
  }

  static Future<void> loadTokenFromStorage() async {
    if (token != null) return; // Already loaded
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');

      // ✅ FIX: Hanya set token dari storage jika belum ada token yang diset secara eksternal
      // (misal via updateToken saat login) saat fungsi ini sedang "await".
      // Ini mencegah token valid ditimpa menjadi null jika login tanpa "Remember Me".
      token ??= savedToken;
    } catch (_) {
      // Silent fail if SharedPreferences not available
    }
  }

  // Ensure token is loaded (public method for services)
  Future<void> ensureTokenLoaded() async {
    if (tokenLoadingFuture != null) {
      await tokenLoadingFuture;
    }
  }

  Future<List<Map<String, dynamic>>> getUserVirtualBalances(int userId) async {
    try {
      final json = await get('/advances/user_balances/$userId');
      final list = json['balances'] as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Gagal memuat saldo virtual: $e');
    }
  }
}
