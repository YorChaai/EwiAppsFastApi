import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/screens/layout/main_layout.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/widgets/sidebar.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/screens/settlement/settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/layouts/settlement_detail_layout.dart';

import 'package:expense_app/screens/settlement/dialogs/dialog_add_expense.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_edit_disbursement.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_evidence.dart';
import 'package:expense_app/screens/settlement/dialogs/dialog_plain_comments.dart';
import 'package:expense_app/screens/settlement/settlement_detail_previews.dart';
import 'package:expense_app/screens/settlement/widgets/widget_settlement_detail_actions.dart';
import 'package:expense_app/screens/settlement/widgets/widget_insufficient_balance_dialog.dart';
import 'package:expense_app/services/bank_order_preferences.dart';

class SettlementDetailScreen extends StatefulWidget {
  final int settlementId;
  const SettlementDetailScreen({super.key, required this.settlementId});

  @override
  State<SettlementDetailScreen> createState() => SettlementDetailScreenState();
}

class SettlementDetailScreenState extends State<SettlementDetailScreen> {
  final ApiService api = ApiService();
  final currencyFormat = NumberFormat('#,##0', 'id_ID');
  final foreignCurrencyFormat = NumberFormat('#,##0.##', 'en_US');
  final ScrollController expenseTableVerticalCtrl = ScrollController();
  final ScrollController expenseTableHorizontalCtrl = ScrollController();
  final ScrollController mainScrollController = ScrollController();
  final ScrollController subCategoryScrollController = ScrollController();
  final Set<int> selectedExpenses = {}; // tracking multi-delete
  bool isSaving = false; // Lock mechanism untuk prevent double-tap save
  final TextEditingController adminFeeController = TextEditingController(
    text: '',
  );
  final TextEditingController disbursedAmountController =
      TextEditingController();
  final TextEditingController returnedAmountController = TextEditingController(
    text: '',
  );
  final TextEditingController returnDescriptionController =
      TextEditingController();
  final TextEditingController disbursementDescriptionController =
      TextEditingController();
  final TextEditingController disbursementCommentController =
      TextEditingController();
  DateTime? disbursementDate;

  double activeAdvanceBalance = 0.0;
  List<Map<String, dynamic>> userVirtualBalances = [];
  Map<String, dynamic> userCashComposition = {};
  Map<String, dynamic> officeBankBalances = {};

  // Sidebar state (untuk desktop saja)
  bool sidebarExpanded = true;
  int pendingSettlements = 0;
  int pendingAdvances = 0;

  // Helper untuk cek platform
  bool getIsAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;
  bool getIsDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color getSurfaceColor(BuildContext context) =>
      getIsDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color getCardColor(BuildContext context) =>
      getIsDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color getCreamColor(BuildContext context) =>
      getIsDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color getPrimaryText(BuildContext context) =>
      getIsDark(context) ? AppTheme.textPrimary : Colors.black87;
  Color getSecondaryText(BuildContext context) =>
      getIsDark(context) ? AppTheme.textSecondary : Colors.black54;
  Color getDividerColor(BuildContext context) =>
      getIsDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  StreamSubscription? refreshSub;

  @override
  void dispose() {
    adminFeeController.dispose();
    disbursedAmountController.dispose();
    returnedAmountController.dispose();
    returnDescriptionController.dispose();
    disbursementDescriptionController.dispose();
    disbursementCommentController.dispose();
    expenseTableVerticalCtrl.dispose();
    expenseTableHorizontalCtrl.dispose();
    mainScrollController.dispose();
    subCategoryScrollController.dispose();
    refreshSub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        final auth = context.read<AuthProvider>();
        api.setToken(auth.token);
        api.setCompany(auth.activeCompany.isEmpty ? null : auth.activeCompany);
        final prov = context.read<SettlementProvider>();
        prov.loadSettlement(widget.settlementId).then((_) {
          if (mounted && prov.currentSettlement != null) {
            fetchActiveAdvanceBalance(prov.currentSettlement!['user_id']);
          }
        });
        prov.loadCategories();
        prov.loadBanks(accountType: 'management'); // Load banks for dialogs
        prov.loadAdvanceBanks(); // Load advance (giro) banks
        fetchBadgeCounts();
      }
    });

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        final prov = context.read<SettlementProvider>();
        prov.loadSettlement(widget.settlementId).then((_) {
          if (mounted && prov.currentSettlement != null) {
            fetchActiveAdvanceBalance(prov.currentSettlement!['user_id']);
          }
        });
      }
    });
  }

  int? getBankIdFromSourceName(String? name) {
    if (name == null || name.isEmpty || name == '-') return null;
    try {
      final sProv = context.read<SettlementProvider>();
      final lowerName = name.trim().toLowerCase();

      // Kasbon/Settlement disbursement or return source should ALWAYS be a main bank (office bank).
      // We ONLY check managementBanks (Reguler) to prevent name collisions with advanceBanks.
      for (var b in sProv.banks) {
        if ((b['name'] ?? '').toString().trim().toLowerCase() == lowerName) {
          return int.tryParse(b['id']?.toString() ?? '');
        }
      }
    } catch (_) {}
    return null;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppTheme.textSecondary;
      case 'submitted':
        return AppTheme.primary; // Blue (Konsisten dengan Kasbon)
      case 'approved':
        return AppTheme.success;
      case 'completed':
        return AppTheme.success;
      case 'rejected':
        return AppTheme.danger;
      case 'pending':
        return AppTheme.warning;
      case 'revision':
        return AppTheme.warning;
      default:
        return AppTheme.textSecondary;
    }
  }

  double toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return 0.0;
    String str = value.toString().trim();
    if (str.isEmpty) return 0.0;

    // Handle Indonesian format: 1.234.567,89 -> 1234567.89
    // Or our new formatter output: 1.234.567.89 -> 1234567.89

    int dots = '.'.allMatches(str).length;
    int commas = ','.allMatches(str).length;

    if (dots > 1) {
      // Multiple dots. In our project, the last one is likely the decimal separator
      // added by our new formatter, OR they are all thousands separators.
      // If there's a comma, the comma is definitely the decimal.
      if (commas == 1) {
        str = str.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        // Check if the last dot looks like a decimal (not followed by exactly 3 digits, or only 1-2 digits)
        int lastDotIdx = str.lastIndexOf('.');
        if (str.length - lastDotIdx != 4) {
          // Last dot is decimal
          String integerPart = str.substring(0, lastDotIdx).replaceAll('.', '');
          String decimalPart = str.substring(lastDotIdx + 1);
          str = "$integerPart.$decimalPart";
        } else {
          // All dots are thousands
          str = str.replaceAll('.', '');
        }
      }
    } else if (dots == 1 && commas == 1) {
      int dotIdx = str.indexOf('.');
      int commaIdx = str.indexOf(',');
      if (dotIdx < commaIdx) {
        str = str.replaceAll('.', '').replaceFirst(',', '.');
      } else {
        str = str.replaceAll(',', '');
      }
    } else if (commas > 1) {
      str = str.replaceAll(',', '');
    } else if (dots == 1) {
      // Single dot.
      int dotIdx = str.lastIndexOf('.');
      // If exactly 3 digits follow and it's not the ONLY digits, it might be thousands.
      if (str.length - dotIdx == 4 && str.length > 4) {
        // Likely thousands, e.g., 1.234 or 10.234
        str = str.replaceAll('.', '');
      }
    } else if (commas == 1) {
      str = str.replaceFirst(',', '.');
    }

    return double.tryParse(str) ??
        double.tryParse(str.replaceAll(RegExp(r'[^\d.]'), '')) ??
        0.0;
  }

  String formatExpenseAmount(Map<String, dynamic> expense) {
    final currency = (expense['currency'] ?? 'IDR').toString().toUpperCase();
    final amount = toDouble(expense['amount']);
    final kurs = toDouble(expense['currency_exchange']);
    final idrAmount = toDouble(expense['idr_amount']) > 0
        ? toDouble(expense['idr_amount'])
        : (amount * (kurs > 0 ? kurs : 1.0));

    if (currency == 'IDR') {
      return 'Rp ${currencyFormat.format(amount)}';
    }

    return '$currency ${foreignCurrencyFormat.format(amount)}\n(Rp ${currencyFormat.format(idrAmount)})';
  }

  String displaySettlementStatus(Map<String, dynamic>? s) {
    if (s == null) return 'draft';
    final status = (s['status'] ?? 'draft').toString().toLowerCase();
    final returnStatus = (s['return_status'] ?? '').toString().toLowerCase();
    final expenses = asMapList(s['expenses']);
    final hasRejectedExpense = expenses
        .any((e) => (e['status'] ?? '').toString().toLowerCase() == 'rejected');

    if (status == 'submitted' &&
        (returnStatus == 'rejected' || hasRejectedExpense)) {
      return 'revision';
    }
    return status;
  }

  List<Map<String, dynamic>> approvedSettlementExpenses(
    Map<String, dynamic> settlement,
  ) {
    final expenses = asMapList(settlement['expenses']);
    return expenses.where((expense) {
      final status = (expense['status'] ?? '').toString().toLowerCase();
      return status == 'approved' ||
          status == 'completed' ||
          status == 'in_settlement';
    }).toList();
  }

  String expenseFundSource(Map<String, dynamic> expense) {
    for (final key in const [
      'source_bank_name',
      'source_bank',
      'bank_name',
      'bank',
    ]) {
      final value = (expense[key] ?? '').toString().trim();
      if (value.isNotEmpty && value.toLowerCase() != 'null' && value != '-') {
        return value;
      }
    }

    final rawSource = (expense['source'] ?? '').toString().trim();
    if (rawSource.isNotEmpty &&
        rawSource.toLowerCase() != 'null' &&
        rawSource != '-') {
      if (rawSource.toLowerCase().contains('reimbursement')) {
        return 'Reimbursement';
      }

      // 1. Check if rawSource contains any known bank name in userVirtualBalances
      for (var b in userVirtualBalances) {
        final bName = (b['bank_name'] ?? '').toString().trim();
        if (bName.isNotEmpty &&
            (rawSource.toLowerCase() == bName.toLowerCase() ||
                rawSource.toLowerCase().contains(bName.toLowerCase()))) {
          return bName;
        }
      }

      // 2. If formatted as adv_<id>_<bankName>
      if (rawSource.startsWith('adv_')) {
        final parts = rawSource.split('_');
        if (parts.length >= 3) {
          return parts.sublist(2).join('_');
        }
      }

      return rawSource;
    }
    return 'Reimbursement';
  }

  String settlementDisbursementSourceLabel(Map<String, dynamic> settlement) {
    final saved = (settlement['disbursement_source'] ?? '').toString().trim();
    if (saved.isNotEmpty &&
        saved.toLowerCase() != 'null' &&
        saved.toLowerCase() != 'reimbursement' &&
        saved != '-' &&
        saved != 'Lainnya' &&
        saved != 'Lain-lainnya') {
      return saved;
    }
    return '-';
  }

  List<String> fundSourceOptions(Map<String, dynamic> settlement) {
    final options = <String>{};

    void collect(dynamic raw) {
      if (raw is List) {
        for (final item in raw) {
          if (item == null) continue;
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            for (final key in const ['name', 'bank_name', 'label', 'code']) {
              final value = (map[key] ?? '').toString().trim();
              if (value.isNotEmpty &&
                  value.toLowerCase() != 'null' &&
                  value.toLowerCase() != 'reimbursement' &&
                  value != '-') {
                options.add(value);
                break;
              }
            }
          } else {
            final value = item.toString().trim();
            if (value.isNotEmpty &&
                value.toLowerCase() != 'null' &&
                value.toLowerCase() != 'reimbursement' &&
                value != '-') {
              options.add(value);
            }
          }
        }
      }
    }

    collect(settlement['fund_sources']);
    collect([settlement['disbursement_source'], settlement['return_source']]);

    for (final expense in approvedSettlementExpenses(settlement)) {
      final source = expenseFundSource(expense);
      if (source.isNotEmpty &&
          source.toLowerCase() != 'null' &&
          source.toLowerCase() != 'reimbursement' &&
          source != '-') {
        options.add(source);
      }
    }

    // HANYA tambahkan rekening yang memiliki saldo > 0 pada user ini
    for (final entry in officeBankBalances.entries) {
      final bal = double.tryParse(entry.value.toString()) ?? 0.0;
      if (bal > 0 && entry.key.toString().trim().isNotEmpty) {
        options.add(entry.key.toString().trim());
      }
    }
    for (final entry in userCashComposition.entries) {
      final bal = double.tryParse(entry.value.toString()) ?? 0.0;
      if (bal > 0 && entry.key.toString().trim().isNotEmpty) {
        options.add(entry.key.toString().trim());
      }
    }

    // Urutkan: '-' selalu di paling atas, disusul bank berurutan sesuai urutan Bank Cash
    final sortedOptions = options.toList();
    sortedOptions.sort(BankOrderPreferences.compareBankNames);

    return ['-', ...sortedOptions];
  }

  double settlementReimbursementAmount(Map<String, dynamic> settlement) {
    final bool isModifiedT2 = settlement['modified_t2'] == true;
    final double dbDisbursed = toDouble(settlement['disbursed_amount']);
    if (isModifiedT2 && dbDisbursed > 0.01) {
      return dbDisbursed;
    }

    final expenses = (settlement['expenses'] as List<dynamic>?) ?? [];
    double usageReimbursement = 0;
    final Map<String, double> usagePerBank = {};

    for (var e in expenses) {
      final amt = toDouble(e['amount'] ?? e['idr_amount'] ?? 0);
      final src = (e['source_bank_name'] ?? e['source'] ?? '').toString().trim();
      if (src.isEmpty || src == '-') {
        usageReimbursement += amt;
      } else {
        // Match bank name
        String matchedBank = src;
        for (var b in userVirtualBalances) {
          final bName = b['bank_name']?.toString() ?? '';
          if (bName.isNotEmpty &&
              (src.toLowerCase() == bName.toLowerCase() ||
                  src.toLowerCase().contains(bName.toLowerCase()))) {
            matchedBank = bName;
            break;
          }
        }
        usagePerBank[matchedBank] = (usagePerBank[matchedBank] ?? 0.0) + amt;
      }
    }

    double totalShortfall = 0.0;
    for (var entry in usagePerBank.entries) {
      final bankKey = entry.key;
      final usedAmt = entry.value;

      double available = 0.0;
      final matchingBank = userVirtualBalances.firstWhere(
        (b) =>
            (b['bank_name']?.toString() ?? '').toLowerCase() ==
            bankKey.toLowerCase(),
        orElse: () => {},
      );

      if (matchingBank.isNotEmpty) {
        available = toDouble(matchingBank['balance']);
      } else if (userVirtualBalances.isNotEmpty) {
        // userVirtualBalances is loaded but this specific bank is not found
        final advanceId = settlement['advance_id'];
        if (advanceId != null && advanceId != 0) {
          available = toDouble(settlement['available_fund']);
        }
      } else {
        // userVirtualBalances is still loading / not loaded yet:
        // Assume kasbon is available equal to usedAmt so Table 2 doesn't flash
        available = usedAmt;
      }

      if (usedAmt > available) {
        totalShortfall += (usedAmt - available);
      }
    }

    return usageReimbursement + totalShortfall;
  }

  DataRow buildDisbursementDataRow(
    Map<String, dynamic> settlement,
    List<Map<String, dynamic>> approvedExpenses,
    String initialSource,
    double totalApproved,
    bool isDisbursementApproved,
    AuthProvider auth,
    List<String> options,
  ) {
    final isBatch = settlement['settlement_type'] == 'batch';
    final title = settlement['title']?.toString() ?? '';
    final firstDesc = approvedExpenses.isNotEmpty
        ? approvedExpenses[0]['description']?.toString() ?? ''
        : '';
    final displayDescription = isBatch ? title : firstDesc;

    // Selalu sinkronkan nilai turunan antar tabel
    final int? reportYear = settlement['report_year'] as int?;

    disbursementDate ??= AppFormatters.parseDateFromApi(
          settlement['disbursement_date'],
        ) ??
        AppFormatters.parseDateFromApi(
          settlement['created_at'],
        ) ??
        DateTime.now();

    if (settlement['disbursement_date'] == null &&
        reportYear != null &&
        disbursementDate!.year != reportYear) {
      disbursementDate = DateTime(
          reportYear, disbursementDate!.month, disbursementDate!.day);
    }

    final descFormatted = displayDescription;
    if (disbursementDescriptionController.text != descFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursementDescriptionController.text != descFormatted) {
          disbursementDescriptionController.text = descFormatted;
          disbursementDescriptionController.selection =
              TextSelection.collapsed(offset: descFormatted.length);
        }
      });
    }

    final disbursementComment =
        (settlement['disbursement_comment'] ?? '').toString();
    final commentFormatted = disbursementComment;
    if (disbursementCommentController.text != commentFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursementCommentController.text != commentFormatted) {
          disbursementCommentController.text = commentFormatted;
          disbursementCommentController.selection =
              TextSelection.collapsed(offset: commentFormatted.length);
        }
      });
    }

    final dbAdminFee = toDouble(settlement['admin_fee']);
    final targetAdminFee = AppFormatters.formatCurrencyPlain(dbAdminFee);
    final adminFeeFormatted = targetAdminFee == '0' ? '' : targetAdminFee;
    if (adminFeeController.text != adminFeeFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (adminFeeController.text != adminFeeFormatted) {
          adminFeeController.text = adminFeeFormatted;
          adminFeeController.selection =
              TextSelection.collapsed(offset: adminFeeFormatted.length);
        }
      });
    }

    final dbDisbursed = toDouble(settlement['disbursed_amount']);

    final reimbAmt = settlementReimbursementAmount(settlement);
    final targetDisbursed = dbDisbursed > 0 ? dbDisbursed : reimbAmt;

    final targetDisbursedText =
        AppFormatters.formatCurrencyPlain(targetDisbursed);
    final disbursedFormatted =
        targetDisbursedText == '0' ? '' : targetDisbursedText;
    if (disbursedAmountController.text != disbursedFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (disbursedAmountController.text != disbursedFormatted) {
          disbursedAmountController.text = disbursedFormatted;
          disbursedAmountController.selection =
              TextSelection.collapsed(offset: disbursedFormatted.length);
        }
      });
    }

    final dbReturned = toDouble(settlement['returned_amount']);
    final targetReturnedText = AppFormatters.formatCurrencyPlain(dbReturned);
    final returnedFormatted =
        targetReturnedText == '0' ? '' : targetReturnedText;
    if (returnedAmountController.text != returnedFormatted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (returnedAmountController.text != returnedFormatted) {
          returnedAmountController.text = returnedFormatted;
          returnedAmountController.selection =
              TextSelection.collapsed(offset: returnedFormatted.length);
        }
      });
    }

    final displaySource =
        initialSource == '-' ? 'Pilih Sumber Dana' : initialSource;

    return DataRow(
      cells: [
        DataCell(Text('1')),
        DataCell(
          Text(
            AppFormatters.formatDateForApi(disbursementDate!),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              displaySource,
              style: TextStyle(
                color: initialSource != '-'
                    ? getPrimaryText(context)
                    : getSecondaryText(context),
              ),
            ),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(displayDescription),
          ),
        ),
        DataCell(
          Text(
            AppFormatters.formatCurrency(targetDisbursed),
          ),
        ),
        DataCell(
          Text(
            AppFormatters.formatCurrency(dbAdminFee),
          ),
        ),
        DataCell(
          settlement['disbursement_evidence_path'] != null
              ? IconButton(
                  icon: const Icon(
                    Icons.image_rounded,
                    color: AppTheme.accent,
                    size: 18,
                  ),
                  tooltip: 'Lihat Bukti Transfer',
                  onPressed: () {
                    // Prioritaskan evidence dari settlement level
                    if (settlement['disbursement_evidence_path'] != null) {
                      showEvidence(
                        settlement['disbursement_evidence_path'],
                        'Bukti Transfer',
                      );
                    }
                  },
                )
              : const Text('-'),
        ),
        DataCell(
          Builder(builder: (context) {
            final mainStatus =
                (settlement['status'] ?? 'draft').toString().toLowerCase();
            final isSubmitted =
                mainStatus == 'submitted' || mainStatus == 'revision_submitted';

            String statusText = 'PENDING';
            Color statusColor = AppTheme.warning;

            if (isDisbursementApproved) {
              statusText = 'APPROVED';
              statusColor = AppTheme.success;
            } else if (isSubmitted) {
              statusText = 'SUBMITTED';
              statusColor = AppTheme.primary; // Blue (Konsisten dengan Kasbon)
            }

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            );
          }),
        ),
        DataCell(
          Builder(builder: (context) {
            final comments = parsePlainComments(
              settlement['disbursement_comment'],
            );
            if (comments.isEmpty) return const Text('-');

            return TextButton.icon(
              onPressed: () => showPlainCommentsDialog(
                comments,
                title: 'Riwayat Komentar',
              ),
              icon: const Icon(Icons.comment_rounded, size: 14),
              label: const Text(
                'Lihat Komentar',
                style: TextStyle(fontSize: 11),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            );
          }),
        ),
        DataCell(
          Builder(builder: (context) {
            final mainStatus =
                (settlement['status'] ?? 'draft').toString().toLowerCase();
            final isSubmittedDoc =
                mainStatus == 'submitted' || mainStatus == 'approved' || mainStatus == 'revision_submitted';
            final isInDraftDoc = mainStatus == 'draft';
            final isDisbursementApproved =
                (settlement['is_disbursement_approved'] ?? false) == true ||
                    mainStatus == 'completed';
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded,
                      size: 18, color: AppTheme.primary),
                  onPressed: () => showDisbursementPreview(settlement),
                  tooltip: 'Pratinjau Pengiriman Dana',
                ),
                if (auth.isManager && isInDraftDoc && !isDisbursementApproved)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: AppTheme.primary,
                    ),
                    onPressed: () => showEditDisbursementDialog(
                      settlement,
                      options,
                    ),
                    tooltip: 'Edit Rincian Pengiriman',
                  ),
                if (auth.isManager &&
                    isSubmittedDoc &&
                    !isDisbursementApproved &&
                    (() {
                      final isSourceValid =
                          settlementDisbursementSourceLabel(settlement) !=
                                  '-' &&
                              settlementDisbursementSourceLabel(settlement) !=
                                  'Pilih Sumber Dana';
                      final isEvidenceValid =
                          settlement['disbursement_evidence_path'] != null &&
                              settlement['disbursement_evidence_path']
                                  .toString()
                                  .trim()
                                  .isNotEmpty;
                      final isAmountValid =
                          toDouble(settlement['disbursed_amount']) > 0 ||
                              settlementReimbursementAmount(settlement) > 0;
                      return isSourceValid && isEvidenceValid && isAmountValid;
                    })())
                  IconButton(
                    icon: const Icon(Icons.check_circle_rounded,
                        size: 20, color: AppTheme.success),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final prov = context.read<SettlementProvider>();

                      // FIX: Sinkronisasi data ke DB sebelum approve jika berbeda
                      final syncedSource =
                          settlementDisbursementSourceLabel(settlement);
                      final dbSource =
                          (settlement['disbursement_source'] ?? '').toString();

                      if (syncedSource != dbSource && syncedSource != '-') {
                        await prov.saveDisbursement(
                          settlementId: widget.settlementId,
                          disbursementSource: syncedSource,
                        );
                      }

                      try {
                        final success =
                            await prov.approveDisbursement(widget.settlementId);
                        if (!mounted) return;
                        if (success) {
                          GlobalEventBus.triggerRefresh();
                          messenger.showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Tabel Pengiriman Dana disetujui ✓'),
                                backgroundColor: AppTheme.success),
                          );
                          prov.loadSettlement(widget.settlementId);
                        } else {
                          messenger.showSnackBar(
                            SnackBar(
                                content: Text(prov.error ??
                                    'Gagal menyetujui pengiriman'),
                                backgroundColor: AppTheme.danger),
                          );
                        }
                      } on InsufficientAdvanceBalanceException catch (e) {
                        if (!mounted) return;
                        showInsufficientBalanceDialog(e);
                      }
                    },
                    tooltip: 'Setujui Pengiriman',
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  String displaySettlementTitle(Map<String, dynamic>? s) {
    if (s == null) return 'Detail Settlement';
    final type = (s['settlement_type'] ?? 'batch').toString().toLowerCase();
    final title = s['title'] ?? '';

    if (type == 'single') {
      final expenses = s['expenses'] as List? ?? [];
      if (expenses.isNotEmpty) {
        final firstExp = Map<String, dynamic>.from(expenses.first);
        return firstExp['description'] ?? title;
      }
    }
    return title.isEmpty ? 'Settlement' : title;
  }

  List<Map<String, dynamic>> asMapList(dynamic list) {
    if (list == null || list is! List) return [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  List<Map<String, dynamic>> uniqueById(List<Map<String, dynamic>> list) {
    final seen = <dynamic>{};
    return list.where((item) => seen.add(item['id'])).toList();
  }

  bool hasUncheckedChecklist(Map<String, dynamic> expense) {
    final checklist = parseChecklist(expense['notes']);
    return checklist.isNotEmpty &&
        checklist.any((item) => item['checked'] != true);
  }

  bool canSubmitSettlementItems(
      List<Map<String, dynamic>> items, Map<String, dynamic> s) {
    if (items.isEmpty) return false;

    // 1. Validasi Tabel 1 (Selalu Wajib)
    final itemsOk = !items.any(hasUncheckedChecklist);
    if (!itemsOk) return false;

    // Cek apakah Tabel 1 sudah Full Approved (Siap ke Tabel 2)
    final allApproved = items.isNotEmpty &&
        items.every((item) =>
            item['status'] == 'approved' || item['status'] == 'completed');

    final mainStatus = (s['status'] ?? 'draft').toString().toLowerCase();

    // 2. Validasi Tabel 2 (HANYA jika Tabel 1 sudah Approved DAN status BUKAN draft)
    if (allApproved && mainStatus != 'draft') {
      final isSourceValid = settlementDisbursementSourceLabel(s) != '-' &&
          settlementDisbursementSourceLabel(s) != 'Pilih Sumber Dana';
      final isEvidenceValid = s['disbursement_evidence_path'] != null &&
          s['disbursement_evidence_path'].toString().trim().isNotEmpty;
      final isAmountValid = toDouble(s['disbursed_amount']) > 0;
      final isDisbursementComplete =
          isSourceValid && isEvidenceValid && isAmountValid;
      if (!isDisbursementComplete) return false;
    }

    return true;
  }

  bool canApproveSettlementItems(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return false;
    return items.every(
      (item) {
        final st = (item['status'] ?? 'pending').toString().toLowerCase();
        return st == 'approved' || st == 'completed';
      },
    );
  }

  void updateState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<SettlementProvider>();
    final s = prov.currentSettlement;
    final settlementStatus = (s?['status'] ?? '').toString().toLowerCase();

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final isAndroid = getIsAndroid(context);
    final expenses = s != null
        ? List<Map<String, dynamic>>.from(s['expenses'] ?? [])
        : <Map<String, dynamic>>[];
    final isSingleSettlement =
        (s?['settlement_type'] ?? 'single').toString().toLowerCase() ==
            'single';
    final canAddExpenses = s != null &&
        (auth.user?['id']?.toString() == s['user_id']?.toString() ||
            auth.isManager) &&
        (s['status'] == 'draft' || s['status'] == 'rejected') &&
        !(isSingleSettlement && expenses.isNotEmpty);

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 600 || isAndroid;
    final showSidebar = !useCompact;

    Future<void> handlePop(bool didPop) async {
      if (didPop) return;

      // Cleanup empty draft - jika belum ada expense dan masih unsaved
      if (prov.unsavedDraft && s != null) {
        final expenses = s['expenses'] as List? ?? [];
        if (expenses.isEmpty) {
          // Tampilkan dialog konfirmasi
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: getCardColor(ctx),
              title: Text(
                'Hapus Settlement Kosong?',
                style: TextStyle(color: getCreamColor(ctx)),
              ),
              content: Text(
                'Settlement ini belum memiliki expense. Hapus settlement kosong ini?',
                style: TextStyle(color: getSecondaryText(ctx)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                  ),
                  child: const Text('Hapus'),
                ),
              ],
            ),
          );

          if (confirm == true && mounted) {
            // User confirm - delete empty draft
            await prov.cleanupEmptyDraft(s['id']);
          }
        }
      }

      if (!context.mounted) return;
      Navigator.of(context).pop();
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        await handlePop(didPop);
      },
      child: Scaffold(
        body: Row(
          children: [
            // Sidebar - HANYA untuk desktop/Windows
            if (showSidebar) ...[
              DashboardSidebar(
                currentIndex: 0,
                isManager: auth.isManager,
                fullName: auth.fullName,
                role: auth.roleDisplayName,
                onNavTap: (index) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  globalSwitchTab?.call(index);
                },
                onNotificationTap: (path) async {
                  // Handle notification tap - navigate ke path yang dituju
                  await handleNotificationTap(path);
                },
                onLogout: confirmLogout,
                isMini: false,
                isExpanded: sidebarExpanded,
                onToggleExpand: () {
                  setState(() {
                    sidebarExpanded = !sidebarExpanded;
                  });
                },
                pendingSettlements: pendingSettlements,
                pendingAdvances: pendingAdvances,
              ),
              Container(width: 1, color: getDividerColor(context)),
            ],
            // Content detail settlement
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    displaySettlementTitle(s),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: getCreamColor(context),
                    ),
                  ),
                  actions: [
                    if (selectedExpenses.isNotEmpty)
                      IconButton(
                        onPressed: bulkDeleteExpenses,
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: AppTheme.danger,
                        ),
                        tooltip:
                            'Hapus ${selectedExpenses.length} item pilihan',
                      ),
                    if (s != null) ...[
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(
                            displaySettlementStatus(s),
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          displaySettlementStatus(s).toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: getStatusColor(displaySettlementStatus(s)),
                          ),
                        ),
                      ),
                      // Only show actions in AppBar if NOT mobile to prevent overflow
                      if (!ResponsiveLayout.isMobile(context))
                        ...buildSettlementDetailActions(
                          context,
                          s,
                          auth,
                          settlementStatus,
                        ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
                body: prov.loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      )
                    : s == null
                        ? const Center(child: Text('Data tidak ditemukan'))
                        : ResponsiveLayout.isMobile(context)
                            ? AppScrollbar(
                                controller: mainScrollController,
                                thumbVisibility: true,
                                interactive: true,
                                child: SingleChildScrollView(
                                  controller: mainScrollController,
                                  child: Column(
                                    children: [
                                      buildMobileSettlementActionBar(
                                        context,
                                        s,
                                        auth,
                                        settlementStatus,
                                      ),
                                      buildContent(context, s, auth, prov),
                                    ],
                                  ),
                                ),
                              )
                            : AppScrollbar(
                                controller: mainScrollController,
                                thumbVisibility: true,
                                interactive: true,
                                child: SingleChildScrollView(
                                  controller: mainScrollController,
                                  child: buildContent(context, s, auth, prov),
                                ),
                              ),
                floatingActionButton: canAddExpenses
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16, right: 8),
                        child: ElevatedButton.icon(
                          onPressed: () => showAddExpenseDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Tambah Expense'),
                        ),
                      )
                    : null,
              ), // End inner Scaffold
            ), // End Expanded
          ], // End Row
        ), // End Row
      ), // End Scaffold
    ); // End PopScope
  }

  List<String> getCommentsFromNotes(String notes) {
    if (notes.isEmpty) return [];

    final systemPrefixes = [
      'Disetujui oleh',
      'Imported from',
      'Subcategory:',
      'Approved by',
      'System:',
    ];

    try {
      final decoded = json.decode(notes);
      if (decoded is List) {
        final List<String> comments = [];
        for (var item in decoded) {
          final text = (item is Map ? item['text'] : item).toString();

          bool isSystem = false;
          for (var prefix in systemPrefixes) {
            if (text.trim().startsWith(prefix)) {
              isSystem = true;
              break;
            }
          }

          if (!isSystem && text.trim().isNotEmpty) {
            comments.add(text.trim());
          }
        }
        return comments;
      }
      return [];
    } catch (_) {
      bool isSystem = false;
      for (var prefix in systemPrefixes) {
        if (notes.trim().startsWith(prefix)) {
          isSystem = true;
          break;
        }
      }
      return isSystem || notes.trim().isEmpty ? [] : [notes.trim()];
    }
  }

  List<String> parsePlainComments(dynamic raw) {
    if (raw == null) return [];
    final text = raw.toString().trim();
    if (text.isEmpty) return [];

    try {
      final decoded = jsonDecode(text);
      if (decoded is List) {
        return decoded
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    } catch (_) {}

    return text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> parseChecklist(dynamic checklist) {
    List<Map<String, dynamic>> local = [];
    try {
      dynamic parsed = checklist is String ? jsonDecode(checklist) : checklist;
      if (parsed is List) {
        for (final e in parsed) {
          String text = '';
          bool checked = false;

          if (e is Map) {
            text = (e['text'] ?? '').toString();
            checked = e['checked'] == true;
          } else if (e is String) {
            text = e;
          }

          if (text.isNotEmpty) {
            local.add({'text': text, 'checked': checked});
          }
        }
      }
    } catch (_) {}
    return local;
  }
}
