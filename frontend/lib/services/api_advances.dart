import 'dart:convert';
import 'dart:async';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:expense_app/services/api_service.dart';


extension ApiServiceAdvancesExt on ApiService {
  Future<Map<String, dynamic>> getActiveAdvanceBalance(int userId) async {
    final res = await ApiService.retryRequest(
      () => http.get(
        Uri.parse(
            '${ApiService.baseUrl}/auth/users/$userId/active_advance_balance'),
        headers: headers,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getUserBalances(int userId) async {
    final res = await ApiService.retryRequest(
      () => http.get(
        Uri.parse('${ApiService.baseUrl}/advances/user_balances/$userId'),
        headers: headers,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getAllActiveAdvanceBalances() async {
    final res = await ApiService.retryRequest(
      () => http.get(
        Uri.parse(
            '${ApiService.baseUrl}/auth/users/all_active_advance_balances'),
        headers: headers,
      ),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getAdvanceHistory(int id) async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/advances/$id/history'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> initializeAdvanceBalance(
      int userId, String notes, List<Map<String, dynamic>> allocations) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/initialize_balance'),
      headers: headers,
      body: jsonEncode({
        'user_id': userId,
        'notes': notes,
        'allocations': allocations,
      }),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getAdvances({
    String? status,
    String? startDate,
    String? endDate,
    int? reportYear,
    String? mode, // 'report' or 'actual'
    String? type,
    String? search,
  }) async {
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (reportYear != null) params.add('report_year=$reportYear');
    if (mode != null) params.add('mode=$mode');
    if (type != null) params.add('type=$type');
    if (search != null && search.isNotEmpty) {
      params.add('search=${Uri.encodeComponent(search)}');
    }

    final url = ApiService.buildUrl('${ApiService.baseUrl}/advances', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }

  // dashboard summary

  Future<Map<String, dynamic>> createAdvance(
    String title,
    String description, {
    String advanceType = 'single',
    int? reportYear,
    String? documentDate,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'advance_type': advanceType,
    };
    if (documentDate != null) {
      body['document_date'] = documentDate;
    }
    if (reportYear != null) body['report_year'] = reportYear;

    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getAdvance(int id) async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/advances/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateAdvance(
    int id, {
    String? title,
    String? description,
    String? advanceType,
    String? documentDate,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (advanceType != null) body['advance_type'] = advanceType;
    if (documentDate != null) body['document_date'] = documentDate;

    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/advances/$id'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteAdvance(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/advances/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> startAdvanceRevision(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/start_revision'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createSettlementFromAdvance(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/create_settlement'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> addAdvanceItem(
    int advanceId,
    int categoryId,
    String description,
    double estimatedAmount, {
    List<int>? categoryIds,
    List<dynamic>? files,
    String? date,
    String? source,
    String? currency,
    double? currencyExchange,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/advances/$advanceId/items'),
    );
    request.headers.addAll(authHeaders);
    request.fields['advance_id'] = advanceId.toString();
    request.fields['category_id'] = categoryId.toString();
    if (categoryIds != null && categoryIds.isNotEmpty) {
      request.fields['category_ids'] = jsonEncode(categoryIds);
    }
    request.fields['description'] = description;
    request.fields['estimated_amount'] = estimatedAmount.toString();
    if (date != null) request.fields['date'] = date;
    if (source != null) request.fields['source'] = source;
    if (currency != null) request.fields['currency'] = currency;
    if (currencyExchange != null) {
      request.fields['currency_exchange'] = currencyExchange.toString();
    }

    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        if (file is PlatformFile) {
          if (kIsWeb && file.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
                'evidence', file.bytes!,
                filename: file.name));
          } else if (file.path != null) {
            request.files
                .add(await http.MultipartFile.fromPath('evidence', file.path!));
          }
        } else if (file is String) {
          request.files
              .add(await http.MultipartFile.fromPath('evidence', file));
        }
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateAdvanceItem(
    int itemId, {
    int? categoryId,
    List<int>? categoryIds,
    String? description,
    double? estimatedAmount,
    List<dynamic>? files,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
    String? date,
    String? source,
    String? currency,
    double? currencyExchange,
    String? notes,
    String? status,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiService.baseUrl}/advances/items/$itemId'),
    );
    request.headers.addAll(authHeaders);

    if (categoryId != null) {
      request.fields['category_id'] = categoryId.toString();
    }
    if (categoryIds != null) {
      request.fields['category_ids'] = jsonEncode(categoryIds);
    }
    if (description != null) {
      request.fields['description'] = description;
    }
    if (estimatedAmount != null) {
      request.fields['estimated_amount'] = estimatedAmount.toString();
    }
    if (date != null) request.fields['date'] = date;
    if (source != null) request.fields['source'] = source;
    if (currency != null) request.fields['currency'] = currency;
    if (currencyExchange != null) {
      request.fields['currency_exchange'] = currencyExchange.toString();
    }

    if (notes != null) request.fields['notes'] = notes;
    if (status != null) request.fields['status'] = status;

    if (existingFilePaths != null) {
      request.fields['existing_evidence_paths'] = jsonEncode(existingFilePaths);
    }
    if (existingFileNames != null) {
      request.fields['existing_evidence_filenames'] = jsonEncode(
        existingFileNames,
      );
    }

    if (files != null && files.isNotEmpty) {
      for (var file in files) {
        if (file is PlatformFile) {
          if (kIsWeb && file.bytes != null) {
            request.files.add(http.MultipartFile.fromBytes(
                'evidence', file.bytes!,
                filename: file.name));
          } else if (file.path != null) {
            request.files
                .add(await http.MultipartFile.fromPath('evidence', file.path!));
          }
        } else if (file is String) {
          if (file.startsWith('receipts/')) continue; // skip server paths
          request.files
              .add(await http.MultipartFile.fromPath('evidence', file));
        }
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteAdvanceItem(int itemId) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/advances/items/$itemId'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> bulkDeleteAdvanceItems(List<int> itemIds) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/items/bulk-delete'),
      headers: headers,
      body: jsonEncode({'item_ids': itemIds}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> approveAdvanceItem(
    int id,
    String action, {
    String notes = '',
  }) async {
    final ep = action == 'reject' ? 'reject' : 'approve';
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/items/$id/$ep'),
      headers: headers,
      body: jsonEncode({'notes': notes}),
    );
    // 422 = insufficient advance balance â†’ return data so caller can show dialog
    if (res.statusCode == 422) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      body['http_status'] = 422;
      return body;
    }
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> submitAdvance(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/submit'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> approveAdvance(
    int id, {
    String notes = 'Disetujui oleh manager',
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/approve_all'),
      headers: headers,
      body: jsonEncode({'notes': notes}),
    );
    // 422 = insufficient advance balance â†’ return data so caller can show dialog
    if (res.statusCode == 422) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      body['http_status'] = 422;
      return body;
    }
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> saveDisbursementAdvance({
    required int advanceId,
    int? bankId,
    String? disbursementSource,
    int? disbursementSourceId,
    String? disbursementComment,
    double? adminFee,
    double? disbursedAmount,
    List<File>? evidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    await ensureTokenLoaded();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/advances/$advanceId/save-disbursement'),
    );
    if (ApiService.token != null) {
      request.headers['Authorization'] = 'Bearer ${ApiService.token}';
    }

    if (bankId != null) request.fields['bank_id'] = bankId.toString();
    if (disbursementSource != null && disbursementSource.trim().isNotEmpty) {
      request.fields['disbursement_source'] = disbursementSource.trim();
    }
    if (disbursementSourceId != null) {
      request.fields['disbursement_source_id'] =
          disbursementSourceId.toString();
    }
    if (disbursementComment != null && disbursementComment.trim().isNotEmpty) {
      request.fields['disbursement_comment'] = disbursementComment.trim();
    }
    if (adminFee != null) request.fields['admin_fee'] = adminFee.toString();
    if (disbursedAmount != null) {
      request.fields['disbursed_amount'] = disbursedAmount.toString();
    }

    if (existingFilePaths != null) {
      request.fields['existing_disbursement_evidence_paths'] =
          json.encode(existingFilePaths);
    }
    if (existingFileNames != null) {
      request.fields['existing_disbursement_evidence_filenames'] =
          json.encode(existingFileNames);
    }

    if (evidenceFiles != null) {
      for (var file in evidenceFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'evidence',
          file.path,
        ));
      }
    }

    final response = await ApiService.retryRequest(() async {
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    });

    return handleResponse(response);
  }

  Future<Map<String, dynamic>> approveDisbursementAdvance(int advanceId) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse(
              '${ApiService.baseUrl}/advances/$advanceId/approve-disbursement'),
          headers: headers,
        ));
    if (response.statusCode == 422) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      body['http_status'] = 422;
      return body;
    }
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          json.decode(response.body)['error'] ?? 'Gagal menyetujui pengiriman');
    }
  }

  Future<Map<String, dynamic>> saveReturnAdvance({
    required int advanceId,
    double? returnedAmount,
    String? returnSource,
    int? returnSourceId,
    String? returnDescription,
    List<File>? returnEvidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    await ensureTokenLoaded();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/advances/$advanceId/save-return'),
    );
    if (ApiService.token != null) {
      request.headers['Authorization'] = 'Bearer ${ApiService.token}';
    }

    if (returnedAmount != null) {
      request.fields['returned_amount'] = returnedAmount.toString();
    }
    if (returnSource != null && returnSource.trim().isNotEmpty) {
      request.fields['return_source'] = returnSource.trim();
    }
    if (returnSourceId != null) {
      request.fields['return_source_id'] = returnSourceId.toString();
    }
    if (returnDescription != null && returnDescription.trim().isNotEmpty) {
      request.fields['return_description'] = returnDescription.trim();
    }

    if (existingFilePaths != null) {
      request.fields['existing_return_evidence_paths'] =
          json.encode(existingFilePaths);
    }
    if (existingFileNames != null) {
      request.fields['existing_return_evidence_filenames'] =
          json.encode(existingFileNames);
    }

    if (returnEvidenceFiles != null) {
      for (var file in returnEvidenceFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'return_evidence',
          file.path,
        ));
      }
    }

    final response = await ApiService.retryRequest(() async {
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    });

    return handleResponse(response);
  }

  Future<Map<String, dynamic>> submitReturnAdvance(int advanceId) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse('${ApiService.baseUrl}/advances/$advanceId/submit-return'),
          headers: headers,
        ));
    return handleResponse(response);
  }

  Future<Map<String, dynamic>> rejectReturnAdvance(
    int advanceId,
    String notes,
  ) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse('${ApiService.baseUrl}/advances/$advanceId/reject-return'),
          headers: headers,
          body: json.encode({'notes': notes}),
        ));
    return handleResponse(response);
  }

  Future<Map<String, dynamic>> finalApproveAdvance(
    int id, {
    required int bankId,
    double adminFee = 0.0,
    double? disbursedAmount,
    double? returnedAmount,
    String? returnDescription,
    String? disbursementDescription,
    DateTime? disbursementDate,
    DateTime? returnDate,
    List<String>? evidencePaths,
    List<String>? returnEvidencePaths,
    List<String>? existingDisbursementPaths,
    List<String>? existingDisbursementFilenames,
    List<String>? existingReturnPaths,
    List<String>? existingReturnFilenames,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/advances/$id/final_approve'),
    );
    request.headers.addAll(authHeaders);

    request.fields['bank_id'] = bankId.toString();
    request.fields['admin_fee'] = adminFee.toString();
    if (disbursedAmount != null) {
      request.fields['disbursed_amount'] = disbursedAmount.toString();
    }
    if (returnedAmount != null) {
      request.fields['returned_amount'] = returnedAmount.toString();
    }
    if (returnDescription != null) {
      request.fields['return_description'] = returnDescription;
    }
    if (disbursementDescription != null) {
      request.fields['disbursement_description'] = disbursementDescription;
    }
    if (disbursementDate != null) {
      request.fields['disbursement_date'] = disbursementDate.toIso8601String();
    }
    if (returnDate != null) {
      request.fields['return_date'] = returnDate.toIso8601String();
    }

    if (existingDisbursementPaths != null) {
      request.fields['existing_disbursement_evidence_paths'] = jsonEncode(
        existingDisbursementPaths,
      );
    }
    if (existingDisbursementFilenames != null) {
      request.fields['existing_disbursement_evidence_filenames'] = jsonEncode(
        existingDisbursementFilenames,
      );
    }
    if (existingReturnPaths != null) {
      request.fields['existing_return_evidence_paths'] = jsonEncode(
        existingReturnPaths,
      );
    }
    if (existingReturnFilenames != null) {
      request.fields['existing_return_evidence_filenames'] = jsonEncode(
        existingReturnFilenames,
      );
    }

    if (evidencePaths != null && evidencePaths.isNotEmpty) {
      for (var path in evidencePaths) {
        if (path.startsWith('receipts/')) continue;
        request.files.add(await http.MultipartFile.fromPath('evidence', path));
      }
    }

    if (returnEvidencePaths != null && returnEvidencePaths.isNotEmpty) {
      for (var path in returnEvidencePaths) {
        if (path.startsWith('receipts/')) continue;
        request.files.add(
          await http.MultipartFile.fromPath('return_evidence', path),
        );
      }
    }

    final streamedRes = await request.send();
    final res = await http.Response.fromStream(streamedRes);
    // 422 = insufficient advance balance â†’ return data so caller can show dialog
    if (res.statusCode == 422) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      body['http_status'] = 422;
      return body;
    }
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateAdvanceItemsBulk(
    int advanceId,
    List<int> itemIds,
    Map<String, dynamic> updates,
  ) async {
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/advances/$advanceId/items/bulk'),
      headers: headers,
      body: jsonEncode({'item_ids': itemIds, 'updates': updates}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> rejectAdvance(
    int id, {
    String notes = 'Ditolak oleh manager',
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/reject_all'),
      headers: headers,
      body: jsonEncode({'notes': notes}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> moveAdvanceToDraft(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/advances/$id/move_to_draft'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<List<int>> exportAdvanceExcel({
    String? startDate,
    String? endDate,
    int? advanceId,
  }) async {
    final params = <String>[];
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (advanceId != null) params.add('advance_id=$advanceId');

    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/reports/excel_advance', params);
    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal export Kasbon Excel');
  }

  Future<List<int>> getBulkAdvancesPdf({
    String? startDate,
    String? endDate,
  }) async {
    final params = <String>[];
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');

    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/reports/advances/pdf', params);
    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal export Bulk Kasbon PDF');
  }

  Future<List<int>> getAdvanceReceipt(int advanceId) async {
    final res = await http.get(
      Uri.parse('${ApiService.baseUrl}/reports/advance/$advanceId/pdf'),
      headers: authHeaders,
    );
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal generate receipt Kasbon');
  }

  Future<Map<String, dynamic>> getOverrideLogs(
      {String? itemType, int? itemId, int? userId}) async {
    final params = <String>[];
    if (itemType != null) params.add('item_type=$itemType');
    if (itemId != null) params.add('item_id=$itemId');
    if (userId != null) params.add('user_id=$userId');
    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/advances/override_logs', params);
    final res = await http.get(Uri.parse(url), headers: headers);
    return handleResponse(res);
  }
}
