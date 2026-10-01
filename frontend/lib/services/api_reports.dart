import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceReportsExt on ApiService {
  Future<Map<String, dynamic>> getAnnualReport({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? sortMode,
  }) async {
    String url = '${ApiService.baseUrl}/reports/annual';
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (sortMode != null) params.add('sort_mode=$sortMode');

    if (params.isNotEmpty) {
      url = ApiService.buildUrl(url, params);
    }

    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<dynamic> getReportYearSettings() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/settings/report-year'),
      headers: authHeaders,
    );
    return handleResponse(res);
  }

  Future<dynamic> updateReportYearSettings(int defaultReportYear) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settings/report-year'),
      headers: headers,
      body: jsonEncode({'default_report_year': defaultReportYear}),
    );
    return handleResponse(res);
  }

  Future<List<int>> getAnnualReportPdf({int? year, String? mode}) async {
    String url = '${ApiService.baseUrl}/reports/annual/pdf';
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');

    if (params.isNotEmpty) {
      url = ApiService.buildUrl(url, params);
    }

    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    String pdfMsg = 'Gagal export Laporan Tahunan PDF';
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is Map && body['error'] != null) {
        pdfMsg = '$pdfMsg: ${body['error']}';
      } else if (body is Map && body['message'] != null) {
        pdfMsg = '$pdfMsg: ${body['message']}';
      }
    } catch (_) {
      pdfMsg = '$pdfMsg (HTTP ${res.statusCode})';
    }
    throw Exception(pdfMsg);
  }

  Future<List<int>> getAnnualReportExcel({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
    String? sortMode,
  }) async {
    String url = '${ApiService.baseUrl}/reports/annual/excel';
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (sortMode != null) params.add('sort_mode=$sortMode');

    if (params.isNotEmpty) {
      url = ApiService.buildUrl(url, params);
    }

    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    String excelMsg = 'Gagal export Laporan Tahunan Excel';
    try {
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (body is Map && body['error'] != null) {
        excelMsg = '$excelMsg: ${body['error']}';
      } else if (body is Map && body['message'] != null) {
        excelMsg = '$excelMsg: ${body['message']}';
      }
    } catch (_) {
      excelMsg = '$excelMsg (HTTP ${res.statusCode})';
    }
    throw Exception(excelMsg);
  }

  // helpers
  // reports

  Future<Map<String, dynamic>> getDashboardSummary() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/dashboard/summary'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> rejectAllExpenses(
    int settlementId, {
    String notes = 'Ditolak oleh manager',
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$settlementId/reject_all'),
      headers: authHeaders,
      body: jsonEncode({'notes': notes}),
    );
    return handleResponse(res);
  }

  Future<List<int>> exportExcel({
    int? month,
    int? year,
    String? mode,
    int? categoryId,
    int? settlementId,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    final params = <String>[];
    if (month != null) params.add('month=$month');
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (categoryId != null) params.add('category_id=$categoryId');
    if (settlementId != null) params.add('settlement_id=$settlementId');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (status != null) params.add('status=$status');

    final url =
        ApiService.buildUrl('${ApiService.baseUrl}/reports/excel', params);
    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    String errorDetail = 'Status ${res.statusCode}';
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map && decoded['error'] != null) {
        errorDetail = decoded['error'].toString();
      }
    } catch (_) {}
    throw Exception('Gagal export Excel ($errorDetail)');
  }

  Future<Map<String, dynamic>> getSummary({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');

    final url =
        ApiService.buildUrl('${ApiService.baseUrl}/reports/summary', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  Future<List<int>> getSummaryPdf({
    int? year,
    String? mode,
    String? startDate,
    String? endDate,
  }) async {
    final params = <String>[];
    if (year != null) params.add('year=$year');
    if (mode != null) params.add('mode=$mode');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');

    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/reports/summary/pdf', params);
    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal export Summary PDF');
  }

  Future<List<int>> getReceipt(int settlementId) async {
    final res = await http.get(
      Uri.parse(
          '${ApiService.baseUrl}/reports/settlement/$settlementId/receipt'),
      headers: authHeaders,
    );
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal generate receipt');
  }

  // annual reports

  Future<Map<String, dynamic>> getDeadlineSettings() async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/settings/deadline'),
      headers: authHeaders,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateDeadlineSetting(
    String ruleKey,
    List<int> days,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/settings/deadline'),
      headers: headers,
      body: jsonEncode({'rule_key': ruleKey, 'days': days}),
    );
    return handleResponse(res);
  }
}
