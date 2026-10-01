import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/models/enums.dart';
import 'package:expense_app/models/advance_item_model.dart';

class AdvanceModel {
  final int id;
  final String title;
  final String? description;
  final String? firstItemDescription;
  final AdvanceType advanceType;
  final DateTime? documentDate;
  final int? reportYear;
  final int userId;
  final String? requesterName;
  final String? requesterRole;
  final int? requesterId;
  final String? requesterProfileImage;
  final DocumentStatus status;
  final String? notes;

  final double totalAmount;
  final double approvedAmount;
  final double? approvedAmountOverride;
  final int rejectedCount;
  final int itemCount;
  final double revisionAmount;
  final int approvedRevisionNo;
  final int? activeRevisionNo;
  final int maxRevisionNo;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;

  final String? disbursementSource;
  final int? disbursementSourceId;
  final String? returnSource;
  final int? returnSourceId;
  final double adminFee;
  final double disbursedAmount;
  final double returnedAmount;
  final String? disbursementComment;
  final String? returnDescription;

  final String? disbursementEvidencePath;
  final String? disbursementEvidenceFilename;
  final String? returnEvidencePath;
  final String? returnEvidenceFilename;

  final bool isDisbursementApproved;
  final bool isReturnApproved;
  final String returnStatus;
  final String? returnNotes;

  final bool modifiedT1;
  final bool modifiedT2;
  final bool modifiedT3;
  final String currentStage;
  final DateTime? expectedCompletionAt;

  final int? bankId;
  final String? bankName;
  final List<String> policyWarnings;

  final List<Map<String, dynamic>> revisionSummaries;
  final List<AdvanceItemModel> items;
  final bool isSettled;

  AdvanceModel({
    required this.id,
    required this.title,
    this.description,
    this.firstItemDescription,
    required this.advanceType,
    this.documentDate,
    this.reportYear,
    required this.userId,
    this.requesterName,
    this.requesterRole,
    this.requesterId,
    this.requesterProfileImage,
    required this.status,
    this.notes,
    required this.totalAmount,
    required this.approvedAmount,
    this.approvedAmountOverride,
    required this.rejectedCount,
    required this.itemCount,
    required this.revisionAmount,
    required this.approvedRevisionNo,
    this.activeRevisionNo,
    required this.maxRevisionNo,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.disbursementSource,
    this.disbursementSourceId,
    this.returnSource,
    this.returnSourceId,
    this.adminFee = 0.0,
    required this.disbursedAmount,
    required this.returnedAmount,
    this.disbursementComment,
    this.returnDescription,
    this.disbursementEvidencePath,
    this.disbursementEvidenceFilename,
    this.returnEvidencePath,
    this.returnEvidenceFilename,
    required this.isDisbursementApproved,
    required this.isReturnApproved,
    required this.returnStatus,
    this.returnNotes,
    required this.modifiedT1,
    required this.modifiedT2,
    required this.modifiedT3,
    required this.currentStage,
    this.expectedCompletionAt,
    this.bankId,
    this.bankName,
    required this.policyWarnings,
    required this.revisionSummaries,
    required this.items,
    this.isSettled = false,
  });

  factory AdvanceModel.fromJson(Map<String, dynamic> json) {
    return AdvanceModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      firstItemDescription: json['first_item_description']?.toString(),
      advanceType: AdvanceTypeExt.fromString(json['advance_type']?.toString()),
      documentDate:
          AppFormatters.parseDateFromApi(json['document_date']?.toString()),
      reportYear: json['report_year'] != null
          ? int.tryParse(json['report_year'].toString())
          : null,
      userId: json['user_id'] ?? 0,
      requesterName: json['requester_name']?.toString(),
      requesterRole: json['requester_role']?.toString(),
      requesterId: json['requester_id'],
      requesterProfileImage: json['requester_profile_image']?.toString(),
      status: DocumentStatusExt.fromString(json['status']?.toString()),
      notes: json['notes']?.toString(),
      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      approvedAmount:
          double.tryParse(json['approved_amount']?.toString() ?? '0') ?? 0.0,
      approvedAmountOverride: json['approved_amount_override'] != null
          ? double.tryParse(json['approved_amount_override'].toString())
          : null,
      rejectedCount: json['rejected_count'] ?? 0,
      itemCount: json['item_count'] ?? 0,
      revisionAmount:
          double.tryParse(json['revision_amount']?.toString() ?? '0') ?? 0.0,
      approvedRevisionNo: json['approved_revision_no'] ?? 0,
      activeRevisionNo: json['active_revision_no'],
      maxRevisionNo: json['max_revision_no'] ?? 0,
      createdAt: AppFormatters.parseDateFromApi(json['created_at']?.toString()),
      updatedAt: AppFormatters.parseDateFromApi(json['updated_at']?.toString()),
      approvedAt:
          AppFormatters.parseDateFromApi(json['approved_at']?.toString()),
      disbursementSource: json['disbursement_source']?.toString(),
      disbursementSourceId: json['disbursement_source_id'] != null
          ? int.tryParse(json['disbursement_source_id'].toString())
          : null,
      returnSource: json['return_source']?.toString(),
      returnSourceId: json['return_source_id'] != null
          ? int.tryParse(json['return_source_id'].toString())
          : null,
      adminFee: double.tryParse(json['admin_fee']?.toString() ?? '0') ?? 0.0,
      disbursedAmount:
          double.tryParse(json['disbursed_amount']?.toString() ?? '0') ?? 0.0,
      returnedAmount:
          double.tryParse(json['returned_amount']?.toString() ?? '0') ?? 0.0,
      disbursementComment: json['disbursement_comment']?.toString(),
      returnDescription: json['return_description']?.toString(),
      disbursementEvidencePath: json['disbursement_evidence_path']?.toString(),
      disbursementEvidenceFilename:
          json['disbursement_evidence_filename']?.toString(),
      returnEvidencePath: json['return_evidence_path']?.toString(),
      returnEvidenceFilename: json['return_evidence_filename']?.toString(),
      isDisbursementApproved: json['is_disbursement_approved'] ?? false,
      isReturnApproved: json['is_return_approved'] ?? false,
      returnStatus: json['return_status']?.toString() ?? 'pending',
      returnNotes: json['return_notes']?.toString(),
      modifiedT1: json['modified_t1'] ?? false,
      modifiedT2: json['modified_t2'] ?? false,
      modifiedT3: json['modified_t3'] ?? false,
      currentStage: json['current_stage']?.toString() ?? 'draft',
      expectedCompletionAt: AppFormatters.parseDateFromApi(
          json['expected_completion_at']?.toString()),
      bankId: json['bank_id'],
      bankName: json['bank_name']?.toString(),
      policyWarnings: (json['policy_warnings'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      revisionSummaries: (json['revision_summaries'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      items: (json['items'] as List?)
              ?.map((e) => AdvanceItemModel.fromJson(e))
              .toList() ??
          [],
      isSettled: json['is_settled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'first_item_description': firstItemDescription,
      'advance_type': advanceType.apiValue,
      'document_date': documentDate != null
          ? AppFormatters.formatDateForApi(documentDate!)
          : null,
      'report_year': reportYear,
      'user_id': userId,
      'requester_name': requesterName,
      'requester_role': requesterRole,
      'requester_id': requesterId,
      'requester_profile_image': requesterProfileImage,
      'status': status.apiValue,
      'notes': notes,
      'total_amount': totalAmount,
      'approved_amount': approvedAmount,
      'approved_amount_override': approvedAmountOverride,
      'rejected_count': rejectedCount,
      'item_count': itemCount,
      'revision_amount': revisionAmount,
      'approved_revision_no': approvedRevisionNo,
      'active_revision_no': activeRevisionNo,
      'max_revision_no': maxRevisionNo,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'disbursement_source': disbursementSource,
      'disbursement_source_id': disbursementSourceId,
      'return_source': returnSource,
      'return_source_id': returnSourceId,
      'admin_fee': adminFee,
      'disbursed_amount': disbursedAmount,
      'returned_amount': returnedAmount,
      'disbursement_comment': disbursementComment,
      'return_description': returnDescription,
      'disbursement_evidence_path': disbursementEvidencePath,
      'disbursement_evidence_filename': disbursementEvidenceFilename,
      'return_evidence_path': returnEvidencePath,
      'return_evidence_filename': returnEvidenceFilename,
      'is_disbursement_approved': isDisbursementApproved,
      'is_return_approved': isReturnApproved,
      'return_status': returnStatus,
      'return_notes': returnNotes,
      'modified_t1': modifiedT1,
      'modified_t2': modifiedT2,
      'modified_t3': modifiedT3,
      'current_stage': currentStage,
      'expected_completion_at': expectedCompletionAt?.toIso8601String(),
      'bank_id': bankId,
      'bank_name': bankName,
      'policy_warnings': policyWarnings,
      'revision_summaries': revisionSummaries,
      'items': items.map((e) => e.toJson()).toList(),
      'is_settled': isSettled,
    };
  }
}
