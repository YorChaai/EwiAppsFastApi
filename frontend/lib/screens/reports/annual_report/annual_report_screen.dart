
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/screens/settings/balance_sheet_settings_screen.dart';
import 'package:expense_app/screens/management/category_tabular_screen.dart';
import 'package:expense_app/screens/management/dividend_management_screen.dart';
import 'package:expense_app/screens/management/revenue_management_screen.dart';
import 'package:expense_app/screens/management/tax_management_screen.dart';
import 'package:expense_app/screens/management/bank_status_screen.dart';
import 'package:expense_app/screens/management/asset_management_screen.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';

import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_state.dart';

import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_tables.dart';
import 'package:expense_app/screens/reports/annual_report/widget_cache_info.dart';
import 'package:expense_app/screens/reports/annual_report/widget_report_header.dart';
import 'package:expense_app/screens/reports/annual_report/widget_display_tables.dart';
import 'package:expense_app/screens/reports/annual_report/widget_summary_cards.dart';
import 'package:expense_app/screens/reports/annual_report/widget_all_tables.dart';


/// Data structure to hold pre-processed table data for performance optimization.

class AnnualReportScreen extends StatefulWidget {
  const AnnualReportScreen({super.key});

  @override
  State<AnnualReportScreen> createState() => AnnualReportScreenState();
}

class AnnualReportScreenState extends State<AnnualReportScreen> {
  late int selectedYear;
  late String filterMode;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;
  Map<String, dynamic>? reportData;
  List<Map<String, dynamic>> categories = [];
  final ScrollController scrollController = ScrollController();
  final Map<String, ScrollController> hControllers = {};
  final Map<String, ScrollController> vControllers = {};

  final currencyFormat = NumberFormat('#,##0', 'id_ID');
  String activeSheet = 'sheet1';
  Set<String> visibleTables = {
    't1',
    't2',
    't3',
    't3a',
    't3b',
    't3c',
    't4a',
    't4b',
    't4c',
    't4d',
    't5',
    't6',
  };
  final ValueNotifier<double> zoomLevelNotifier = ValueNotifier<double>(1.0);
  double get zoomLevel => zoomLevelNotifier.value;
  set zoomLevel(double val) => zoomLevelNotifier.value = val;
  bool isSyncing = false;
  bool showBackToTop = false;

  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  // Cache untuk optimasi performa
  String sortMode = 'kategori'; // 'kategori' atau 'tanggal'
  List<List<Map<String, dynamic>>>? cachedGroupedExpenses;
  List<List<Map<String, dynamic>>>? cachedGroupedAdvanceExpenses;
  final Map<int, String> subcategoryLabelCache = {};
  final Map<String, ReportTableData> tableDataCache = {};
  late final TextEditingController zoomController;
  SettlementProvider? settlementProvider; // ✅ Store reference

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;
  Color titleColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
  Color bodyColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color primaryText(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  final Set<int> profitLossBoldRows = {};

  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  final Set<int> neracaBoldRows = {};
  final Set<int> table3aBoldRows = {};
  final Set<int> table3bBoldRows = {};
  final Set<int> table3cBoldRows = {};

  // Diagonal scrolling state

  @override
  void initState() {
    super.initState();
    scrollController.addListener(syncScroll);
    final tKeys = [
      '1',
      '2',
      '3',
      '3a',
      '3b',
      '3c',
      '4a',
      '4b',
      '4c',
      '4d',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10'
    ];
    for (var k in tKeys) {
      hControllers[k] = ScrollController()
        ..addListener(() => syncHorizontal(hControllers[k]!));
      vControllers[k] = ScrollController();
    }
    zoomController = TextEditingController(text: '100');

    // ✅ Initialize from provider state
    final sProv = context.read<SettlementProvider>();
    selectedYear = sProv.reportYear;
    filterMode = sProv.filterMode;
    sortMode = sProv.sortMode;

    // ✅ Listen for global year/mode changes
    settlementProvider = context.read<SettlementProvider>();
    settlementProvider!.addListener(onProviderChange);

    loadDefaultReportYearAndFetch();
    fetchCategories();
  }

  void onProviderChange() {
    if (!mounted) return;
    final prov = context.read<SettlementProvider>();
    if (selectedYear != prov.reportYear ||
        filterMode != prov.filterMode ||
        sortMode != prov.sortMode) {
      setState(() {
        selectedYear = prov.reportYear;
        filterMode = prov.filterMode;
        sortMode = prov.sortMode;
      });
      fetchReport();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    for (var c in hControllers.values) {
      c.dispose();
    }
    for (var c in vControllers.values) {
      c.dispose();
    }
    settlementProvider?.removeListener(onProviderChange);
    zoomController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void syncScroll() {
    if (!mounted) return;
    final show = scrollController.offset > 300;
    if (show != showBackToTop) {
      setState(() => showBackToTop = show);
    }
  }

  void syncHorizontal(ScrollController controller) {
    if (!controller.hasClients || isSyncing) return;
    final offset = controller.offset;
    isSyncing = true;

    // Performance Optimization: Only sync tables that are currently visible
    for (final entry in hControllers.entries) {
      final other = entry.value;
      final id = entry.key;

      if (visibleTables.contains(id) &&
          other.hasClients &&
          other != controller) {
        final max = other.position.maxScrollExtent;
        if (max <= 0) continue;
        final targetOffset = offset.clamp(0.0, max);
        if ((other.offset - targetOffset).abs() > 0.5) {
          other.jumpTo(targetOffset);
        }
      }
    }
    isSyncing = false;
  }

  Future<void> fetchCategories() async {
    try {
      final api = context.read<AuthProvider>().api;
      final res = await api.getCategories();
      if (res.containsKey('categories')) {
        final cats = (res['categories'] as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
        cats.sort(
          (a, b) => (a['sort_order'] ?? 999).compareTo(b['sort_order'] ?? 999),
        );
        if (mounted) setState(() => categories = cats);
      }
    } catch (_) {}
  }

  Future<void> loadDefaultReportYearAndFetch() async {
    try {
      final sProv = context.read<SettlementProvider>();
      // ✅ Sync with all providers via CascadeProvider
      context.read<CascadeProvider>().syncReportYear(context, sProv.reportYear);
      if (mounted) {
        setState(() {
          selectedYear = sProv.reportYear;
          filterMode = sProv.filterMode;
          sortMode = sProv.sortMode;
        });
      }
    } catch (_) {}
    await fetchReport();
  }

  Future<void> fetchReport() async {
    if (isLoading) return; // Prevent concurrent fetches

    final prov = context.read<SettlementProvider>();
    // ✅ Sync local selection with all providers BEFORE fetching
    // We use reload: false to prevent providers from triggering their own fetch listeners
    if (prov.reportYear != selectedYear || prov.filterMode != filterMode) {
      context
          .read<CascadeProvider>()
          .syncReportYear(context, selectedYear, mode: filterMode);
    }

    setState(() {
      isLoading = true;
      cachedGroupedExpenses = null;
      cachedGroupedAdvanceExpenses = null;
      subcategoryLabelCache.clear();
    });

    try {
      await fetchCategories();

      final controllers = <ScrollController>[
        scrollController,
        ...hControllers.values,
        ...vControllers.values,
      ];
      for (final c in controllers) {
        if (c.hasClients) c.jumpTo(0);
      }

      if (!mounted) return;
      final api = context.read<AuthProvider>().api;

      // Persiapkan parameter tanggal untuk mode range
      final effectiveStartDate = filterMode == 'range' && startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null;
      final effectiveEndDate = filterMode == 'range' && endDate != null
          ? DateFormat('yyyy-MM-dd').format(endDate!)
          : null;

      final data = await api.getAnnualReport(
        year: filterMode == 'range' ? null : selectedYear,
        mode: filterMode,
        startDate: effectiveStartDate,
        endDate: effectiveEndDate,
        sortMode: sortMode,
      );

      if (mounted) {
        setState(() {
          reportData = data;
          final rawExpenses = asListMap(data['operation_cost']?['data']);
          if (rawExpenses.isNotEmpty) {
            cachedGroupedExpenses = groupAnnualExpenses(rawExpenses);
          }
          final rawAdvanceExpenses =
              asListMap(data['advance_operation_cost']?['data']);
          if (rawAdvanceExpenses.isNotEmpty) {
            cachedGroupedAdvanceExpenses =
                groupAnnualExpenses(rawAdvanceExpenses);
          }
          processAllTables();
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Build a map from row index to group ID from combine_groups API data.
  /// [dataList] is the revenue/tax data list, [combineGroups] is the combine_groups list.

  Future<void> pickDateRange() async {
    final range = await AppDateRangePicker.show(
      context,
      initialRange: (startDate != null && endDate != null)
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );
    if (range != null) {
      setState(() {
        startDate = range.start;
        endDate = range.end;
        filterMode = 'range';
      });
      fetchReport();
    }
  }

  Future<void> exportExcel() async {
    setState(() => isLoading = true);
    try {
      final api = context.read<AuthProvider>().api;

      final effectiveStartDate = filterMode == 'range' && startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null;
      final effectiveEndDate = filterMode == 'range' && endDate != null
          ? DateFormat('yyyy-MM-dd').format(endDate!)
          : null;

      final bytes = await api.getAnnualReportExcel(
        year: filterMode == 'range' ? null : selectedYear,
        mode: filterMode,
        startDate: effectiveStartDate,
        endDate: effectiveEndDate,
        sortMode: sortMode,
      );
      if (!mounted) return;
      final suffix = filterMode == 'range'
          ? '${DateFormat('yyyyMMdd').format(startDate!)}-${DateFormat('yyyyMMdd').format(endDate!)}'
          : '$selectedYear';
      await FileHelper.saveAndOpenFile(
        context: context,
        bytes: bytes,
        filename: 'Pemasukan-Biaya_$suffix.xlsx',
        subFolder: 'Reports/Annual/Excel',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Set<String> defaultVisibleTablesForSheet(String sheet) {
    switch (sheet) {
      case 'sheet2':
        return {'t7', 't8'};
      case 'sheet3':
        return {'t9', 't10'};
      case 'sheet1':
      default:
        return {
          't1',
          't2',
          't3',
          't3a',
          't3b',
          't3c',
          't4a',
          't4b',
          't4c',
          't4d',
          't5',
          't6'
        };
    }
  }

  void applySheet(String sheet) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          activeSheet = sheet;
          visibleTables = defaultVisibleTablesForSheet(sheet);
        });
      }
    });
  }

  void toggleTableVisibility(String tableId) {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          if (tableId == 'all') {
            final currentConfigs = getAvailableTableIds(activeSheet);
            bool allVisible = currentConfigs.every(
              (id) => visibleTables.contains(id),
            );
            if (allVisible) {
              for (var id in currentConfigs) {
                visibleTables.remove(id);
              }
            } else {
              for (var id in currentConfigs) {
                visibleTables.add(id);
              }
            }
          } else {
            if (visibleTables.contains(tableId)) {
              visibleTables.remove(tableId);
            } else {
              visibleTables.add(tableId);
            }
          }
        });
      }
    });
  }

  void showUnavailableInputMessage(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label belum tersedia di frontend saat ini.'),
        backgroundColor: AppTheme.warning,
      ),
    );
  }

  final Set<int> table3BoldRows = {};

  void handleInputMenuSelection(String id) {
    switch (id) {
      case 'input_income':
        navTo(
          RevenueManagementScreen(
            initialYear: selectedYear,
            initialFilterMode: filterMode,
            initialStartDate: startDate,
            initialEndDate: endDate,
          ),
        );
        break;
      case 'input_tax':
        navTo(
          TaxManagementScreen(
            initialYear: selectedYear,
            initialFilterMode: filterMode,
            initialStartDate: startDate,
            initialEndDate: endDate,
          ),
        );
        break;
      case 'input_bank':
        navTo(BankStatusScreen(initialYear: selectedYear));
        break;
      case 'input_asset':
        navTo(
          AssetManagementScreen(
            initialYear: selectedYear,
            initialFilterMode: filterMode,
            initialStartDate: startDate,
            initialEndDate: endDate,
          ),
        );
        break;
      case 'input_balance':
        navTo(
          BalanceSheetSettingsScreen(
            initialYear: selectedYear,
            initialFilterMode: filterMode,
          ),
        );
        break;
      case 'input_dividend':
        navTo(
          DividendManagementScreen(
            initialYear: selectedYear,
            initialFilterMode: filterMode,
          ),
        );
        break;
      default:
        showUnavailableInputMessage('Menu ini');
    }
  }

  void navToDetail(String type, String id) {
    final intId = int.tryParse(id);
    if (intId == null) return;

    if (type.toLowerCase().contains('settlement')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettlementDetailScreen(settlementId: intId),
        ),
      );
    } else if (type.toLowerCase().contains('advance') ||
        type.toLowerCase().contains('kasbon')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvanceDetailScreen(advanceId: intId),
        ),
      );
    }
  }

  DateTime parseDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return DateTime(selectedYear, 1, 1);
    return DateTime.tryParse(text) ?? DateTime(selectedYear, 1, 1);
  }

  int? extractImportedRow(dynamic text) {
    final raw = (text ?? '').toString();
    if (raw.isEmpty) return null;
    final m = RegExp(
      r'Imported from row\s+(\d+)',
      caseSensitive: false,
    ).firstMatch(raw);
    return m == null ? null : int.tryParse(m.group(1) ?? '');
  }

  List<List<Map<String, dynamic>>> groupAnnualExpenses(
    List<Map<String, dynamic>> expenses,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final e in expenses) {
      final sid = (e['settlement_id'] ?? '').toString();
      final key = sid.isNotEmpty
          ? 'id:$sid'
          : 'title:${(e['settlement_title'] ?? '').toString()}';
      grouped.putIfAbsent(key, () => <Map<String, dynamic>>[]).add(e);
    }
    final groups = grouped.values.toList();
    for (final g in groups) {
      g.sort((a, b) {
        final bucketCmp = subcategorySortBucket(
          expenseSubcategoryLabel(a),
        ).compareTo(subcategorySortBucket(expenseSubcategoryLabel(b)));
        if (bucketCmp != 0) return bucketCmp;
        final aSub = expenseSubcategoryLabel(a).toLowerCase();
        final bSub = expenseSubcategoryLabel(b).toLowerCase();
        if (aSub != bSub) return aSub.compareTo(bSub);
        final aImported = extractImportedRow(a['notes']);
        final bImported = extractImportedRow(b['notes']);
        if (aImported != null || bImported != null) {
          final ai = aImported ?? (1 << 30);
          final bi = bImported ?? (1 << 30);
          if (ai != bi) return ai.compareTo(bi);
        }
        final da = parseDate(a['date']);
        final db = parseDate(b['date']);
        if (da != db) return da.compareTo(db);
        return (int.tryParse((a['id'] ?? '0').toString()) ?? 0).compareTo(
          int.tryParse((b['id'] ?? '0').toString()) ?? 0,
        );
      });
    }
    groups.sort((a, b) {
      final af = a.first;
      final bf = b.first;
      final aSub = expenseSubcategoryLabel(af);
      final bSub = expenseSubcategoryLabel(bf);
      final subBucketCmp = subcategorySortBucket(
        aSub,
      ).compareTo(subcategorySortBucket(bSub));
      if (subBucketCmp != 0) return subBucketCmp;
      if (aSub.toLowerCase() != bSub.toLowerCase()) {
        return aSub.toLowerCase().compareTo(bSub.toLowerCase());
      }
      final aBatch = isBatchSettlement(af);
      final bBatch = isBatchSettlement(bf);
      if (aBatch != bBatch) return aBatch ? 1 : -1;
      final aDate = a
          .map((x) => parseDate(x['date']))
          .reduce((x, y) => x.isBefore(y) ? x : y);
      final bDate = b
          .map((x) => parseDate(x['date']))
          .reduce((x, y) => x.isBefore(y) ? x : y);
      if (aBatch && bBatch) {
        final aNum = extractBatchNumber(
          (af['settlement_title'] ?? '').toString(),
        );
        final bNum = extractBatchNumber(
          (bf['settlement_title'] ?? '').toString(),
        );
        if (aNum != bNum) return aNum.compareTo(bNum);
      }
      final dateCmpVal = aDate.compareTo(bDate);
      return dateCmpVal != 0
          ? dateCmpVal
          : (int.tryParse((af['settlement_id'] ?? '0').toString()) ?? 0)
              .compareTo(
              int.tryParse((bf['settlement_id'] ?? '0').toString()) ?? 0,
            );
    });
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SettlementProvider>();
    sortMode = prov.sortMode;
    processAllTables();

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 650;
    final showMainScrollbar = screenWidth > (useCompact ? 650 : 800);

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          // Ctrl + Scroll untuk Zoom
          if (HardwareKeyboard.instance.isControlPressed) {
            if (pointerSignal.scrollDelta.dy > 0) {
              zoomLevel = (zoomLevel - 0.05).clamp(0.52, 1.0);
            } else {
              zoomLevel = (zoomLevel + 0.05).clamp(0.52, 1.0);
            }
            zoomController.text = '${(zoomLevel * 100).toInt()}';
          }
        }
      },
      child: Scaffold(
        backgroundColor: surfaceColor(context),
        floatingActionButton: showBackToTop
            ? FloatingActionButton.small(
                heroTag: 'annual_report_scroll_to_top',
                onPressed: () {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                },
                backgroundColor: cardColor(context).withValues(alpha: 0.9),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppTheme.primary,
                ),
              )
            : null,
        appBar: AppBar(
          title: useCompact
              ? const SizedBox.shrink() // Sembunyikan judul di layar sempit
              : const Text(
                  'Laporan Tahunan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          backgroundColor: cardColor(context),
          titleSpacing: useCompact ? 0 : NavigationToolbar.kMiddleSpacing,
          actions: [
            // Filter Periode Cascading (Laporan, Year, Range)
            if (!useCompact)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CascadingYearFilter(
                  selectedYear: selectedYear,
                  currentMode: filterMode,
                  useCompact: useCompact,
                  startDate: startDate,
                  endDate: endDate,
                  onSelected: (year, mode) {
                    setState(() {
                      selectedYear = year;
                      filterMode = mode;
                    });

                    // ✅ Sync all providers with the selected year and mode
                    context
                        .read<CascadeProvider>()
                        .syncReportYear(context, year, mode: mode);

                    fetchReport();
                  },
                  onRangeTap: pickDateRange,
                ),
              ),

            // Zoom Controls
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: surfaceColor(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: dividerColor(context)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16),
                    onPressed: () {
                      zoomLevel = (zoomLevel - 0.1).clamp(0.52, 1.0);
                      zoomController.text = '${(zoomLevel * 100).toInt()}';
                    },
                    tooltip: 'Zoom Out',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      cursorColor: AppTheme.primary,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: true,
                        counterText: "",
                      ),
                      controller: zoomController,
                      onSubmitted: (val) {
                        final numValue = double.tryParse(val);
                        if (numValue != null) {
                          zoomLevel = (numValue / 100).clamp(0.52, 1.0);
                          zoomController.text =
                              '${(zoomLevel * 100).toInt()}';
                        }
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  const Text(
                    '%',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16),
                    onPressed: () {
                      zoomLevel = (zoomLevel + 0.1).clamp(0.52, 1.0);
                      zoomController.text = '${(zoomLevel * 100).toInt()}';
                    },
                    tooltip: 'Zoom In',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.sort, color: AppTheme.primary),
              onPressed: () => navTo(const CategoryTabularScreen()),
              tooltip: 'Kategori Tabular',
            ),
            IconButton(
              icon: const Icon(Icons.table_view, color: Colors.green),
              onPressed: isLoading ? null : exportExcel,
              tooltip: 'Export Excel',
            ),
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
            : reportData == null
                ? Center(
                    child: Text(
                      'Tidak ada data.',
                      style: TextStyle(color: titleColor(context)),
                    ),
                  )
                : ValueListenableBuilder<double>(
                    valueListenable: zoomLevelNotifier,
                    builder: (context, zoom, _) {
                      return AppScrollbar(
                        controller: scrollController,
                        thumbVisibility: showMainScrollbar,
                        trackVisibility: showMainScrollbar,
                        interactive: true,
                        child: CustomScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.fromLTRB(
                                useCompact ? 12 : 16,
                                16,
                                useCompact ? 12 : 16,
                                12,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  if (useCompact) ...[
                                    Text(
                                      'Laporan Tahunan',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: titleColor(context),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: CascadingYearFilter(
                                        selectedYear: selectedYear,
                                        currentMode: filterMode,
                                        useCompact: useCompact,
                                        startDate: startDate,
                                        endDate: endDate,
                                        onSelected: (year, mode) {
                                          setState(() {
                                            selectedYear = year;
                                            filterMode = mode;
                                          });

                                          context
                                              .read<CascadeProvider>()
                                              .syncReportYear(context, year,
                                                  mode: mode);

                                          fetchReport();
                                        },
                                        onRangeTap: pickDateRange,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  buildSummaryCards(useCompact),
                                  const SizedBox(height: 16),
                                  buildCacheInfo(useCompact),
                                  const SizedBox(height: 12),
                                  buildReportHeader(useCompact),
                                  const SizedBox(height: 12),
                                ]),
                              ),
                            ),
                            // Tables as individual slivers for better lazy loading
                            ...buildDisplayTables(useCompact).map(
                              (w) => SliverPadding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: useCompact ? 12 : 16,
                                ),
                                sliver: SliverToBoxAdapter(child: w),
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 96)),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void navTo(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    fetchReport();
  }
}
