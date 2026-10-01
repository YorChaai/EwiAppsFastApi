enum DocumentStatus {
  draft,
  submitted,
  approved,
  rejected,
  revisionDraft,
  revisionSubmitted,
  revisionRejected,
  inSettlement,
  completed,
  unknown
}

extension DocumentStatusExt on DocumentStatus {
  static DocumentStatus fromString(String? val) {
    if (val == null) return DocumentStatus.unknown;
    switch (val.toLowerCase().replaceAll('_', '')) {
      case 'draft':
        return DocumentStatus.draft;
      case 'submitted':
        return DocumentStatus.submitted;
      case 'approved':
        return DocumentStatus.approved;
      case 'rejected':
        return DocumentStatus.rejected;
      case 'revisiondraft':
        return DocumentStatus.revisionDraft;
      case 'revisionsubmitted':
        return DocumentStatus.revisionSubmitted;
      case 'revisionrejected':
        return DocumentStatus.revisionRejected;
      case 'insettlement':
        return DocumentStatus.inSettlement;
      case 'completed':
        return DocumentStatus.completed;
      default:
        return DocumentStatus.unknown;
    }
  }

  String get apiValue {
    switch (this) {
      case DocumentStatus.revisionDraft:
        return 'revision_draft';
      case DocumentStatus.revisionSubmitted:
        return 'revision_submitted';
      case DocumentStatus.revisionRejected:
        return 'revision_rejected';
      case DocumentStatus.inSettlement:
        return 'in_settlement';
      default:
        return name; // e.g. 'draft', 'approved'
    }
  }

  String get displayName {
    switch (this) {
      case DocumentStatus.revisionDraft:
        return 'Draft Revisi';
      case DocumentStatus.revisionSubmitted:
        return 'Revisi Submitted';
      case DocumentStatus.revisionRejected:
        return 'Revisi Ditolak';
      case DocumentStatus.inSettlement:
        return 'Proses Settlement';
      case DocumentStatus.completed:
        return 'Selesai';
      default:
        return name[0].toUpperCase() + name.substring(1).toLowerCase();
    }
  }
}

enum AdvanceType { single, batch }

extension AdvanceTypeExt on AdvanceType {
  static AdvanceType fromString(String? val) {
    if (val == 'batch') return AdvanceType.batch;
    return AdvanceType.single;
  }

  String get apiValue => name;
}
