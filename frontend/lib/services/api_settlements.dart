import 'dart:convert';
import 'dart:async';
import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:expense_app/services/api_service.dart';


extension ApiServiceSettlementsExt on ApiService {
  Future<Map<String, dynamic>> getSettlements({
    String? status,
    String? startDate,
    String? endDate,
    String? type,
    int? reportYear,
    String? mode, // 'report' or 'actual'
    String? search,
  }) async {
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (type != null) params.add('type=$type');
    if (reportYear != null) params.add('report_year=$reportYear');
    if (mode != null) params.add('mode=$mode');
    if (search != null && search.isNotEmpty) {
      params.add('search=${Uri.encodeComponent(search)}');
    }

    final url =
        ApiService.buildUrl('${ApiService.baseUrl}/settlements', params);
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse(url), headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getSettlement(int id) async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/settlements/$id'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> getSettlementHistory(int id) async {
    final res = await ApiService.retryRequest(
      () => http.get(Uri.parse('${ApiService.baseUrl}/settlements/$id/history'),
          headers: headers),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> createSettlement(
    String title,
    String description, {
    int? advanceId,
    int? copyFromAdvanceId,
    String settlementType = 'single',
    int? reportYear,
    String? documentDate,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'settlement_type': settlementType,
    };
    if (advanceId != null) {
      body['advance_id'] = advanceId;
    }
    if (copyFromAdvanceId != null) {
      body['copy_from_advance_id'] = copyFromAdvanceId;
    }
    if (documentDate != null) {
      body['document_date'] = documentDate;
    }
    if (reportYear != null) {
      body['report_year'] = reportYear;
    }
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> updateSettlement(
    int id, {
    String? title,
    String? description,
    String? documentDate,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (documentDate != null) body['document_date'] = documentDate;
    final res = await http.put(
      Uri.parse('${ApiService.baseUrl}/settlements/$id'),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> deleteSettlement(int id) async {
    final res = await http.delete(
      Uri.parse('${ApiService.baseUrl}/settlements/$id'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> submitSettlement(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$id/submit'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> approveSettlement(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$id/approve'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> finalApproveSettlement(
    int id,
    int bankId, {
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
      Uri.parse('${ApiService.baseUrl}/settlements/$id/final_approve'),
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
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> moveSettlementToDraft(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$id/move_to_draft'),
      headers: headers,
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> rejectAllSettlement(
    int id, {
    String notes = '',
  }) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$id/reject_all'),
      headers: headers,
      body: jsonEncode({'notes': notes}),
    );
    return handleResponse(res);
  }

  Future<Map<String, dynamic>> completeSettlement(int id) async {
    final res = await http.post(
      Uri.parse('${ApiService.baseUrl}/settlements/$id/complete'),
      headers: headers,
    );
    return handleResponse(res);
  }

  // banks

  Future<Map<String, dynamic>> saveDisbursementSettlement({
    required int settlementId,
    int? bankId,
    String? disbursementSource,
    int? disbursementSourceId,
    String? disbursementComment,
    double? adminFee,
    double? disbursedAmount,
    DateTime? disbursementDate,
    List<File>? evidenceFiles,
    List<String>? existingFilePaths,
    List<String>? existingFileNames,
  }) async {
    await ensureTokenLoaded();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
          '${ApiService.baseUrl}/settlements/$settlementId/save-disbursement'),
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
    if (disbursementDate != null) {
      request.fields['disbursement_date'] = disbursementDate.toIso8601String();
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

  Future<Map<String, dynamic>> approveDisbursementSettlement(
      int settlementId) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse(
              '${ApiService.baseUrl}/settlements/$settlementId/approve-disbursement'),
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

  Future<Map<String, dynamic>> saveReturnSettlement({
    required int settlementId,
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
      Uri.parse('${ApiService.baseUrl}/settlements/$settlementId/save-return'),
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

  Future<Map<String, dynamic>> submitReturnSettlement(int settlementId) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse(
              '${ApiService.baseUrl}/settlements/$settlementId/submit-return'),
          headers: headers,
        ));
    return handleResponse(response);
  }

  Future<Map<String, dynamic>> rejectReturnSettlement(
    int settlementId,
    String notes,
  ) async {
    await ensureTokenLoaded();
    final response = await ApiService.retryRequest(() => http.post(
          Uri.parse(
              '${ApiService.baseUrl}/settlements/$settlementId/reject-return'),
          headers: headers,
          body: json.encode({'notes': notes}),
        ));
    return handleResponse(response);
  }

  Future<List<int>> getBulkSettlementsPdf({
    String? status,
    String? startDate,
    String? endDate,
    int? reportYear,
  }) async {
    final params = <String>[];
    if (status != null) params.add('status=$status');
    if (startDate != null) params.add('start_date=$startDate');
    if (endDate != null) params.add('end_date=$endDate');
    if (reportYear != null) params.add('report_year=$reportYear');

    final url = ApiService.buildUrl(
        '${ApiService.baseUrl}/reports/settlements/pdf', params);
    final res = await http.get(Uri.parse(url), headers: authHeaders);
    if (res.statusCode == 200) {
      return res.bodyBytes.toList();
    }
    throw Exception('Gagal export Bulk Settlement PDF');
  }

  Future<Map<String, dynamic>> updateExpensesBulk(
    int settlementId,
    Map<String, dynamic> updates,
    List<int> ids,
  ) async {
    final res = await ApiService.retryRequest(
      () => http.put(
        Uri.parse(
            '${ApiService.baseUrl}/settlements/$settlementId/expenses/bulk'),
        headers: headers,
        body: jsonEncode({'updates': updates, 'ids': ids}),
      ),
    );
    return handleResponse(res);
  }
}
