import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/models/enums.dart';

class AdvanceItemModel {
  final int id;
  final int advanceId;
  final int categoryId;
  final List<int> subcategoryIds;
  final String? subcategoryName;
  final String? categoryName;
  final String? categoryCode;
  final String description;
  final double estimatedAmount;
  final int revisionNo;
  final String? evidencePath;
  final String? evidenceFilename;
  final DateTime? date;
  final String? source;
  final String currency;
  final double currencyExchange;
  final double idrAmount;
  final DocumentStatus status;
  final String? notes;

  AdvanceItemModel({
    required this.id,
    required this.advanceId,
    required this.categoryId,
    required this.subcategoryIds,
    this.subcategoryName,
    this.categoryName,
    this.categoryCode,
    required this.description,
    required this.estimatedAmount,
    required this.revisionNo,
    this.evidencePath,
    this.evidenceFilename,
    this.date,
    this.source,
    required this.currency,
    required this.currencyExchange,
    required this.idrAmount,
    required this.status,
    this.notes,
  });

  factory AdvanceItemModel.fromJson(Map<String, dynamic> json) {
    return AdvanceItemModel(
      id: json['id'] ?? 0,
      advanceId: json['advance_id'] ?? 0,
      categoryId: json['category_id'] ?? 0,
      subcategoryIds: (json['subcategory_ids'] as List?)
              ?.map((e) => int.parse(e.toString()))
              .toList() ??
          [],
      subcategoryName: json['subcategory_name']?.toString(),
      categoryName: json['category_name']?.toString(),
      categoryCode: json['category_code']?.toString(),
      description: json['description']?.toString() ?? '',
      estimatedAmount:
          double.tryParse(json['estimated_amount']?.toString() ?? '0') ?? 0.0,
      revisionNo: json['revision_no'] ?? 0,
      evidencePath: json['evidence_path']?.toString(),
      evidenceFilename: json['evidence_filename']?.toString(),
      date: AppFormatters.parseDateFromApi(json['date']?.toString()),
      source: json['source']?.toString(),
      currency: json['currency']?.toString() ?? 'IDR',
      currencyExchange:
          double.tryParse(json['currency_exchange']?.toString() ?? '1') ?? 1.0,
      idrAmount: double.tryParse(json['idr_amount']?.toString() ?? '0') ?? 0.0,
      status: DocumentStatusExt.fromString(json['status']?.toString()),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advance_id': advanceId,
      'category_id': categoryId,
      'subcategory_ids': subcategoryIds,
      'subcategory_name': subcategoryName,
      'category_name': categoryName,
      'category_code': categoryCode,
      'description': description,
      'estimated_amount': estimatedAmount,
      'revision_no': revisionNo,
      'evidence_path': evidencePath,
      'evidence_filename': evidenceFilename,
      'date': date != null ? AppFormatters.formatDateForApi(date!) : null,
      'source': source,
      'currency': currency,
      'currency_exchange': currencyExchange,
      'idr_amount': idrAmount,
      'status': status.apiValue,
      'notes': notes,
    };
  }
}
