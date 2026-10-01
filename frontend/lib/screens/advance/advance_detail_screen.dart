import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/screens/layout/main_layout.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/utils/app_dialogs.dart';
import 'package:expense_app/widgets/notification_bell_icon.dart';
import 'package:expense_app/screens/widgets/page_selector.dart';
import 'package:expense_app/screens/widgets/sidebar.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_add_item.dart';
import 'package:expense_app/screens/advance/widgets/widget_advance_detail_actions.dart';
import 'package:expense_app/screens/advance/widgets/widget_content.dart';
import 'package:expense_app/screens/advance/widgets/widget_mobile_advance_action_bar.dart';
import 'package:expense_app/services/bank_order_preferences.dart';


const List<String> advanceFundSourceChoices = <String>[
  'BCA',
  'BCA Giro',
  'BCA Bisnis',
  'BCA TabBis',
  'BCA Valas',
  'BRI',
  'BRI Giro',
  'BRI Bisnis',
  'BRI TabBis',
  'BRI Valas',
  'Mandiri',
  'Mandiri Giro',
  'Mandiri Bisnis',
  'Mandiri TabBis',
  'Mandiri Valas',
  'BNI',
  'BNI Giro',
  'BNI Bisnis',
  'BNI TabBis',
  'BNI Valas',
  'EWI',
  'IDR',
  'Cash',
  'Advance',
  'Lainnya',
];

class AdvanceDetailScreen extends StatefulWidget {
  final int advanceId;
  const AdvanceDetailScreen({super.key, required this.advanceId});

  @override
  State<AdvanceDetailScreen> createState() => AdvanceDetailScreenState();
}

class AdvanceDetailScreenState extends State<AdvanceDetailScreen> {
  final ApiService api = ApiService();
  final currencyFormat = NumberFormat('#,##0', 'id_ID');

  final itemTableHorizontalCtrl = ScrollController();
  final itemTableVerticalCtrl = ScrollController();
  final mainScrollController = ScrollController();
  final checklistScrollController = ScrollController();
  final Set<int> selectedItemIds = {}; // for bulk delete (staf)
  final Set<int> checkedItemIds = {}; // Checklist manager (approval)
  bool isManager = false;
  bool isSaving = false; // Lock mechanism untuk prevent double-tap save
  final adminFeeController = TextEditingController(text: '');
  final disbursedAmountController = TextEditingController();
  final returnedAmountController = TextEditingController(text: '');
  final returnDescriptionController = TextEditingController();
  final disbursementDescriptionController = TextEditingController();
  final disbursementCommentController = TextEditingController();
  DateTime? disbursementDate;
  final List<String> disbursementFilePaths = [];
  final List<String> existingDisbursementPaths = [];
  final List<String> existingDisbursementFilenames = [];
  double activeAdvanceBalance = 0.0;
  Map<String, dynamic> userCashComposition = {};
  Map<String, dynamic> officeBankBalances = {};

  // Sidebar state (untuk desktop saja)
  bool sidebarExpanded = true;
  int pendingSettlements = 0;
  int pendingAdvances = 0;

  // Helper untuk cek platform dan warna
  bool isAndroid(BuildContext context) =>
      Theme.of(context).platform == TargetPlatform.android;
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color creamColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color primaryText(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : Colors.black87;
  Color secondaryText(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : Colors.black54;
  Color bodyColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color titleColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  void handleMobilePageSelection(int index) {
    if (index == 1) {
      Navigator.pop(context);
      return;
    }

    Navigator.popUntil(context, (route) => route.isFirst);
    globalSwitchTab?.call(index);
  }

  StreamSubscription? refreshSub;

  Future<void> confirmLogout() async {
    final confirmed = await AppDialogs.showExitConfirmation(
      context,
      isLogout: true,
    );
    if (confirmed && mounted) {
      context.read<AuthProvider>().logout();
    }
  }

  @override
  void dispose() {
    adminFeeController.dispose();
    disbursedAmountController.dispose();
    returnedAmountController.dispose();
    returnDescriptionController.dispose();
    disbursementDescriptionController.dispose();
    disbursementCommentController.dispose();
    // Remove listeners first to prevent memory leaks
    itemTableHorizontalCtrl.removeListener(() {});
    itemTableVerticalCtrl.removeListener(() {});
    itemTableHorizontalCtrl.dispose();
    itemTableVerticalCtrl.dispose();
    mainScrollController.dispose();
    checklistScrollController.dispose();
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
        setState(() {
          isManager = auth.isManager;
        });
        final prov = context.read<AdvanceProvider>();
        prov.loadAdvance(widget.advanceId).then((_) {
          if (mounted && prov.currentAdvanceMap != null) {
            fetchActiveAdvanceBalance(prov.currentAdvanceMap!['user_id']);
          }
        });
        context.read<SettlementProvider>().loadCategories();
        context
            .read<SettlementProvider>()
            .loadBanks(accountType: 'management'); // Load banks for dialogs
        context
            .read<SettlementProvider>()
            .loadAdvanceBanks(); // Load advance (giro) banks
        fetchBadgeCounts();
      }
    });

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        final prov = context.read<AdvanceProvider>();
        prov.loadAdvance(widget.advanceId).then((_) {
          if (mounted && prov.currentAdvanceMap != null) {
            fetchActiveAdvanceBalance(prov.currentAdvanceMap!['user_id']);
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

  Future<void> handleNotificationTap(String rawPath) async {
    if (!mounted) return;
    final path = rawPath.trim().toLowerCase();

    // Extract ID from path
    final parts = path.split('/');
    int? id;
    for (int i = parts.length - 1; i >= 0; i--) {
      final value = int.tryParse(parts[i]);
      if (value != null) {
        id = value;
        break;
      }
    }

    // Navigate based on path
    if (path.contains('/settlements') && id != null) {
      // Navigate to settlement detail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SettlementDetailScreen(settlementId: id!),
        ),
      );
      return;
    }

    if (path.contains('/advances') && id != null) {
      // Navigate to advance detail
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdvanceDetailScreen(advanceId: id!)),
      );
      return;
    }

    if (path.contains('/categories')) {
      // Navigate to dashboard categories tab
      if (context.read<AuthProvider>().isManager) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
          arguments: {'initialTabIndex': 3},
        );
      }
      return;
    }

    if (path.contains('/reports')) {
      // Navigate to dashboard reports tab
      if (context.read<AuthProvider>().isManager) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          (route) => false,
          arguments: {'initialTabIndex': 2},
        );
      }
      return;
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return AppTheme.textSecondary;
      case 'submitted':
        return AppTheme.primary; // Blue (Konsisten)
      case 'approved':
        return AppTheme.success;
      case 'revision':
        return AppTheme.warning; // Orange
      case 'rejected':
        return AppTheme.danger;
      case 'in_settlement':
      case 'completed':
      case 'settled':
        return AppTheme.success;
      case 'pending':
        return AppTheme.warning; // Orange
      default:
        return AppTheme.textSecondary;
    }
  }

  Color advanceStatusColor(Map<String, dynamic> advance) {
    final status = (advance['status'] ?? 'draft').toString().toLowerCase();
    if (status == 'in_settlement') {
      final settlementStatus =
          (advance['settlement_status'] ?? '').toString().toLowerCase();
      final isSettlementApproved =
          settlementStatus == 'approved' || settlementStatus == 'completed';
      return isSettlementApproved ? AppTheme.success : AppTheme.danger;
    }
    return statusColor(status);
  }

  List<Map<String, dynamic>> approvedAdvanceItems(
    Map<String, dynamic> advance,
  ) {
    final items = asMapList(advance['items']);
    return items.where((item) {
      final status = (item['status'] ?? '').toString().toLowerCase();
      return status == 'approved' || status == 'completed';
    }).toList();
  }

  String advanceFundSource(Map<String, dynamic> item) {
    for (final key in const [
      'source_bank_name',
      'source_bank',
      'bank_name',
      'bank',
      'source',
    ]) {
      final value = (item[key] ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }
    return '-';
  }

  String advanceDisbursementSourceLabel(Map<String, dynamic> advance) {
    final saved = (advance['disbursement_source'] ?? '').toString().trim();
    if (saved.isNotEmpty && saved.toLowerCase() != 'null') return saved;
    final approvedItems = approvedAdvanceItems(advance);
    if (approvedItems.isEmpty) return '-';
    final firstSource = advanceFundSource(approvedItems.first);
    final allSame =
        approvedItems.every((item) => advanceFundSource(item) == firstSource);
    return allSame &&
            firstSource.isNotEmpty &&
            firstSource.toLowerCase() != 'null'
        ? firstSource
        : '-';
  }

  List<String> advanceFundSourceOptions(Map<String, dynamic> advance) {
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
                  value != '-') {
                options.add(value);
                break;
              }
            }
          } else {
            final value = item.toString().trim();
            if (value.isNotEmpty &&
                value.toLowerCase() != 'null' &&
                value != '-') {
              options.add(value);
            }
          }
        }
      }
    }

    collect(advance['fund_sources']);
    collect([advance['disbursement_source'], advance['return_source']]);

    for (final item in approvedAdvanceItems(advance)) {
      final source = advanceFundSource(item);
      if (source.isNotEmpty &&
          source.toLowerCase() != 'null' &&
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

  String displayAdvanceStatus(Map<String, dynamic>? a) {
    if (a == null) return 'draft';
    final status = (a['status'] ?? 'draft').toString().toLowerCase();
    final returnStatus = (a['return_status'] ?? '').toString().toLowerCase();
    final items = asMapList(a['items']);
    final hasRejectedItem = items
        .any((e) => (e['status'] ?? '').toString().toLowerCase() == 'rejected');

    if (status == 'submitted' &&
        (returnStatus == 'rejected' || hasRejectedItem)) {
      return 'revision';
    }
    return status;
  }

  Widget headerText(String label) {
    return Text(
      label,
      style:
          TextStyle(fontWeight: FontWeight.w600, color: creamColor(context)),
    );
  }

  String displayAdvanceTitle(Map<String, dynamic> advance) {
    final type = (advance['advance_type'] ?? 'single').toString().toLowerCase();
    final title = (advance['title'] ?? '').toString();

    if (type == 'single') {
      final allItems = List<Map<String, dynamic>>.from(
        advance['items'] as List? ?? [],
      );
      if (allItems.isNotEmpty) {
        // Use workflowItems to get the items for the current revision
        final currentItems = workflowItems(advance, allItems);
        final relevantItems = currentItems.isNotEmpty ? currentItems : allItems;

        // Sort by ID descending to get the latest item
        relevantItems.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
        final latestItem = relevantItems.first;
        final desc = latestItem['description']?.toString() ?? '';
        return desc.isNotEmpty
            ? desc
            : (title.isNotEmpty ? title : 'Kasbon Mandiri');
      }
      return title.isNotEmpty ? title : 'Kasbon Mandiri';
    }
    return title.isEmpty ? 'Detail Kasbon' : title;
  }

  List<Map<String, dynamic>> workflowItems(
    Map<String, dynamic> advance,
    List<Map<String, dynamic>> items,
  ) {
    final status = (advance['status'] ?? '').toString().toLowerCase();
    final activeRevisionNo =
        int.tryParse('${advance['active_revision_no'] ?? ''}') ?? -1;

    if (status == 'revision' || status == 'rejected' || status == 'submitted') {
      return items
          .where(
            (item) =>
                (int.tryParse('${item['revision_no'] ?? 0}') ?? 0) ==
                activeRevisionNo,
          )
          .toList();
    }

    return items
        .where(
          (item) => (int.tryParse('${item['revision_no'] ?? 0}') ?? 0) == 0,
        )
        .toList();
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

  Future<List<String>?> pickDisbursementEvidence() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'webp'],
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((f) => f.path != null)
            .map((f) => f.path!)
            .toList();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memilih file: $e')));
      }
    }
    return null;
  }

  void updateState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<AdvanceProvider>();
    final adv = prov.currentAdvanceMap;
    final advanceStatus = (adv?['status'] ?? '').toString().toLowerCase();

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAndroidVal = isAndroid(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 600 || isAndroidVal;
    final showSidebar = !useCompact;
    final canShowDownloadButtons = [
      'approved',
      'in_settlement',
      'completed',
    ].contains(advanceStatus);
    final canEditHeader = adv != null &&
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
        (adv['status'] == 'draft' || adv['status'] == 'rejected') &&
        adv['advance_type'] == 'batch';
    final canSubmit = adv != null &&
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
        [
          'draft',
          'rejected',
          'revision',
          'rejected',
        ].contains(adv['status']);
    final canEditItems = adv != null &&
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
        [
          'draft',
          'rejected',
          'revision',
          'rejected',
        ].contains(adv['status']);
    final isSingleAdvance =
        (adv?['advance_type'] ?? 'single').toString().toLowerCase() == 'single';
    final canCreateSettlement = adv != null &&
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
        ['completed', 'in_settlement'].contains(adv['status']) &&
        adv['is_disbursement_approved'] == true &&
        adv['settlement_id'] == null;
    final canStartRevision = adv != null &&
        (auth.user?['id'] == adv['user_id'] || auth.isManager) &&
        ['completed', 'in_settlement'].contains(adv['status']) &&
        adv['active_revision_no'] == null &&
        ![
          'submitted',
          'approved',
          'completed',
        ].contains(adv['settlement_status']);

    final items = adv != null
        ? List<Map<String, dynamic>>.from(adv['items'] ?? [])
        : <Map<String, dynamic>>[];
    final canAddItems = canEditItems && !(isSingleAdvance && items.isNotEmpty);
    final workflowItemsList =
        adv != null ? workflowItems(adv, items) : <Map<String, dynamic>>[];

    Future<void> handlePop(bool didPop) async {
      if (didPop) return;

      // Cleanup empty draft - jika belum ada item dan masih unsaved
      if (prov.unsavedDraft && adv != null) {
        final items = adv['items'] as List? ?? [];
        if (items.isEmpty) {
          // Tampilkan dialog konfirmasi
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: cardColor(ctx),
              title: Text(
                'Hapus Kasbon Kosong?',
                style: TextStyle(color: creamColor(ctx)),
              ),
              content: Text(
                'Kasbon ini belum memiliki item. Hapus kasbon kosong ini?',
                style: TextStyle(color: secondaryText(ctx)),
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
            await prov.cleanupEmptyDraft(adv['id']);
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
                currentIndex: 1,
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
              Container(width: 1, color: dividerColor(context)),
            ],
            // Content detail advance
            Expanded(
              child: Scaffold(
                appBar: isAndroidVal
                    ? AppBar(
                        elevation: 0,
                        backgroundColor: surfaceColor(context),
                        centerTitle: false,
                        title: Row(
                          children: [
                            // User badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                auth.fullName.isNotEmpty
                                    ? auth.fullName[0].toUpperCase()
                                    : 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // User name - Expanded untuk avoid overflow
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    auth.fullName.split(' ').first,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: titleColor(context),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    adv != null
                                        ? displayAdvanceTitle(adv)
                                        : 'Detail Kasbon',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: bodyColor(context),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            PageSelector(
                              currentIndex: 1,
                              isManager: auth.isManager,
                              compact: true,
                              onChanged: handleMobilePageSelection,
                            ),
                          ],
                        ),
                        actions: [
                          if (adv != null)
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: advanceStatusColor(
                                  adv,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                displayAdvanceStatus(adv).toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: advanceStatusColor(adv),
                                ),
                              ),
                            ),
                          // Notification Bell
                          NotificationBellIcon(
                            onNotificationTap: handleNotificationTap,
                          ),
                          const SizedBox(width: 4),
                          // Logout Button
                          IconButton(
                            icon: const Icon(Icons.logout_rounded, size: 20),
                            onPressed: confirmLogout,
                            color: bodyColor(context),
                            tooltip: 'Logout',
                          ),
                          const SizedBox(width: 8),
                        ],
                      )
                    : AppBar(
                        title: Text(
                          adv != null
                              ? displayAdvanceTitle(adv)
                              : 'Detail Kasbon',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: creamColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        actions: [
                          if (adv != null) ...[
                            if (selectedItemIds.isNotEmpty)
                              IconButton(
                                onPressed: bulkDeleteItems,
                                icon: const Icon(
                                  Icons.delete_sweep_rounded,
                                  color: AppTheme.danger,
                                ),
                                tooltip:
                                    'Hapus ${selectedItemIds.length} item pilihan',
                              ),
                            Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: advanceStatusColor(
                                  adv,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                displayAdvanceStatus(adv).toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  color: advanceStatusColor(adv),
                                ),
                              ),
                            ),
                            if (!ResponsiveLayout.isMobile(context))
                              ...buildAdvanceDetailActions(
                                context,
                                adv,
                                auth,
                                workflowItemsList,
                                canEditHeader,
                                canSubmit,
                                canCreateSettlement,
                                canStartRevision,
                                canShowDownloadButtons,
                              ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                body: prov.loading || adv == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primary,
                        ),
                      )
                    : ResponsiveLayout.isMobile(context)
                        ? AppScrollbar(
                            controller: mainScrollController,
                            thumbVisibility: true,
                            interactive: true,
                            child: SingleChildScrollView(
                              controller: mainScrollController,
                              child: Column(
                                children: [
                                  buildMobileAdvanceActionBar(
                                    context,
                                    adv,
                                    auth,
                                    workflowItemsList,
                                    canEditHeader,
                                    canSubmit,
                                    canCreateSettlement,
                                    canStartRevision,
                                    canShowDownloadButtons,
                                  ),
                                  buildContent(
                                      context, adv, auth, prov, items),
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
                              child: buildContent(
                                  context, adv, auth, prov, items),
                            ),
                          ),
                floatingActionButton: canAddItems
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16, right: 8),
                        child: ElevatedButton.icon(
                          onPressed: () => showAddItemDialog(context),
                          icon: const Icon(Icons.add),
                          label: Text(
                            adv['status'] == 'revision' ||
                                    adv['status'] == 'rejected'
                                ? 'Tambah Item Revisi'
                                : 'Tambah Item Kasbon',
                          ),
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

  List<Map<String, dynamic>> asMapList(dynamic list) {
    if (list == null || list is! List) return [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  List<Map<String, dynamic>> uniqueById(List<Map<String, dynamic>> list) {
    final seen = <dynamic>{};
    return list.where((item) => seen.add(item['id'])).toList();
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
