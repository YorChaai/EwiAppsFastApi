import 'package:expense_app/screens/widgets/widget_scrollable_settlement_header.dart';
import 'package:expense_app/screens/layout/main_layout_widgets.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/utils/app_snackbar.dart';
import 'package:expense_app/screens/widgets/transaction_cards.dart';


class SettlementListView extends StatefulWidget {
  const SettlementListView({super.key});
  @override
  State<SettlementListView> createState() => SettlementListViewState();
}

class SettlementListViewState extends State<SettlementListView> {
  static const Duration _searchDebounceDuration = Duration(milliseconds: 350);
  String? statusFilter;
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = '';
  double? annualSettlementTotal;
  final ScrollController listScrollController = ScrollController();
  final TextEditingController searchCtrl = TextEditingController();
  Timer? searchDebounce;
  Timer? summaryDebounce;
  bool showScrollToTop = false;
  bool selectionMode = false;
  final Set<String> selectedItemKeys = {};
  String selectedType = 'single';
  String filterMode = 'report'; // Default placeholder, will sync in initState
  SettlementProvider? settlementProvider; // ✅ Store reference
  StreamSubscription<void>? refreshSub;

  Color cardColor(BuildContext context) =>
      context.isDark ? AppTheme.card : AppTheme.lightCard;
  Color titleColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color bodyColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color dividerColor(BuildContext context) =>
      context.isDark ? AppTheme.divider : AppTheme.lightDivider;
  Color primaryTextLocal(BuildContext context) =>
      context.isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  void handleListScroll() {
    if (!listScrollController.hasClients) return;
    final shouldShow = listScrollController.offset > 320;
    if (shouldShow != showScrollToTop && mounted) {
      setState(() => showScrollToTop = shouldShow);
    }
  }

  Future<void> scrollToTop() async {
    if (!listScrollController.hasClients) return;
    await listScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void scheduleSettlementReload() {
    searchDebounce?.cancel();
    searchDebounce = Timer(_searchDebounceDuration, reloadSettlements);
  }

  /// Reset semua filter dan pencarian
  void resetFilters() {
    if (!mounted) return;
    setState(() {
      statusFilter = null;
      searchQuery = '';
      searchCtrl.clear();
      startDate = null;
      endDate = null;
      selectedType = 'single';
    });
    context.read<SettlementProvider>().clearFilters();
    scrollToTop();
  }

  void toggleItemSelection(int id, bool isSettlement, bool selected) {
    final key = isSettlement ? 's_$id' : 'a_$id';
    setState(() {
      if (selected) {
        selectedItemKeys.add(key);
        selectionMode = true;
      } else {
        selectedItemKeys.remove(key);
      }
      if (selectedItemKeys.isEmpty) selectionMode = false;
    });
  }

  Future<void> bulkDeleteItems() async {
    if (selectedItemKeys.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(context),
        title: const Text('Hapus Masal'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${selectedItemKeys.length} item terpilih?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(color: bodyColorLocal(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    int successCount = 0;
    List<String> failures = [];

    try {
      final sProv = context.read<SettlementProvider>();
      final aProv = context.read<AdvanceProvider>();
      final keys = selectedItemKeys.toList();

      for (final key in keys) {
        final parts = key.split('_');
        if (parts.length != 2) continue;
        final type = parts[0];
        final id = int.tryParse(parts[1]);
        if (id == null) continue;

        bool success = false;
        if (type == 's') {
          success = await sProv.deleteSettlement(id, reload: false);
        } else {
          success = await aProv.deleteAdvance(id, reload: false);
        }

        if (success) {
          successCount++;
        } else {
          failures.add(id.toString());
        }
      }

      await sProv.loadSettlements();
      await aProv.loadAdvances();

      if (mounted) {
        Navigator.pop(context); // hide loading
        setState(() {
          selectedItemKeys.clear();
          selectionMode = false;
        });

        if (failures.isEmpty) {
          AppSnackbar.show('Berhasil menghapus $successCount item');
        } else {
          AppSnackbar.show(
            'Berhasil: $successCount, Gagal: ${failures.length}. (Staff hanya bisa hapus Draft)',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // hide loading
        AppSnackbar.show(
          'Gagal menghapus beberapa item: $e',
          isError: true,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(handleListScroll);
    settlementProvider = context.read<SettlementProvider>();
    statusFilter = settlementProvider!.statusFilter;
    filterMode = settlementProvider!.filterMode; // ✅ Sync mode
    searchQuery = settlementProvider!.searchQuery ?? '';
    searchCtrl.text = searchQuery;
    if (settlementProvider!.startDate != null) {
      startDate = DateTime.tryParse(settlementProvider!.startDate!);
    }
    if (settlementProvider!.endDate != null) {
      endDate = DateTime.tryParse(settlementProvider!.endDate!);
    }

    // ✅ Add listener to reload summary when year changes from other screens (e.g. ReportScreen)
    settlementProvider!.addListener(onProviderChange);

    loadDefaultReportYearAndReload();

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        reloadSettlements();
      }
    });
  }

  void onProviderChange() {
    if (!mounted) return;

    final prov = context.read<SettlementProvider>();
    bool changed = false;

    if (statusFilter != prov.statusFilter) {
      statusFilter = prov.statusFilter;
      changed = true;
    }
    if (filterMode != prov.filterMode) {
      filterMode = prov.filterMode;
      changed = true;
    }

    final provStart =
        prov.startDate != null ? DateTime.tryParse(prov.startDate!) : null;
    if (startDate != provStart) {
      startDate = provStart;
      changed = true;
    }

    final provEnd =
        prov.endDate != null ? DateTime.tryParse(prov.endDate!) : null;
    if (endDate != provEnd) {
      endDate = provEnd;
      changed = true;
    }

    final provSearch = prov.searchQuery ?? '';
    if (searchQuery != provSearch) {
      searchQuery = provSearch;
      searchCtrl.text = provSearch;
      changed = true;
    }

    if (changed) {
      setState(() {});
    }

    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn || !auth.isManager) return;
    loadAnnualSettlementSummary();
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    searchDebounce?.cancel();
    summaryDebounce?.cancel();
    settlementProvider?.removeListener(onProviderChange);
    listScrollController.removeListener(handleListScroll);
    listScrollController.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> loadDefaultReportYearAndReload() async {
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();
    await Future.wait([sProv.syncReportYear(), aProv.syncReportYear()]);
    if (!mounted) return;
    reloadSettlements();
    loadDashboardSummary();
  }

  Future<void> loadDashboardSummary() async {
    try {
      final auth = context.read<AuthProvider>();
      if (!auth.isLoggedIn) return;
      await auth.api.getDashboardSummary();
      if (!mounted) return;
    } catch (e) {
      debugPrint('ERROR dashboard summary: $e');
    }
  }

  Future<void> loadAnnualSettlementSummary() async {
    if (!mounted) return;
    summaryDebounce?.cancel();
    summaryDebounce = Timer(const Duration(milliseconds: 1000), () async {
      try {
        if (!mounted) return;
        final auth = context.read<AuthProvider>();
        if (!auth.isLoggedIn || !auth.isManager) return;

        final prov = context.read<SettlementProvider>();
        if (prov.disposed) return;

        final targetYear = prov.filterYear;

        final data = await prov.getSummary(
          year: targetYear,
        );
        if (mounted) {
          setState(
            () => annualSettlementTotal =
                ((data['grand_total'] ?? 0) as num).toDouble(),
          );
        }
      } catch (e) {
        debugPrint('ERROR annual summary: $e');
      }
    });
  }

  void updateState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  void reloadSettlements() {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;

    searchDebounce?.cancel();
    searchDebounce = null;
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();

    final effectiveStartDate = filterMode == 'range' && startDate != null
        ? DateFormat('yyyy-MM-dd').format(startDate!)
        : null;
    final effectiveEndDate = filterMode == 'range' && endDate != null
        ? DateFormat('yyyy-MM-dd').format(endDate!)
        : null;

    final targetYear = sProv.filterYear;

    sProv.loadSettlements(
      status: statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: filterMode,
      search: searchQuery,
    );

    // ✅ ALWAYS sync Advance to Settlement to ensure they are fully synchronized as requested
    aProv.loadAdvances(
      status: statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: filterMode,
      search: searchQuery,
    );

    loadAnnualSettlementSummary();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await AppDateRangePicker.show(
      context,
      initialRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
        filterMode = 'range'; // Tambahkan ini agar label berubah
      });
      reloadSettlements();
    }
  }

  Future<void> exportExcel() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.exportExcel(
        status: statusFilter,
        startDate: startDate != null
            ? DateFormat('yyyy-MM-dd').format(startDate!)
            : null,
        endDate:
            endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
      );
      final timestamp = FileHelper.formatTimestamp();
      if (!mounted) return;
      await FileHelper.saveAndOpenFolder(
        context: context,
        bytes: bytes,
        filename: 'Laporan_Settlement_$timestamp.xlsx',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show('Gagal export Excel: $e', isError: true);
    }
  }

  Future<void> exportPdf() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.getBulkPdf(
        status: statusFilter,
        startDate: startDate != null
            ? DateFormat('yyyy-MM-dd').format(startDate!)
            : null,
        endDate:
            endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
        reportYear: prov.reportYear,
      );
      final timestamp = FileHelper.formatTimestamp();
      if (!mounted) return;
      await FileHelper.saveAndOpenFile(
        context: context,
        bytes: bytes,
        filename: 'Laporan_Settlement_$timestamp.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show('Gagal export PDF: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<SettlementProvider>();
    final canShowExport = statusFilter == 'completed';
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 750;
        final isVeryNarrow = constraints.maxWidth < 450;
        final useCompact = constraints.maxWidth < 500;
        final pagePadding = EdgeInsets.fromLTRB(
          isNarrow ? 16 : 24,
          useCompact ? 16 : 24,
          isNarrow ? 16 : 24,
          16,
        );
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: AppScrollbar(
                          controller: listScrollController,
                          thumbVisibility: true,
                          interactive: true,
                          child: RefreshIndicator(
                            onRefresh: () async => reloadSettlements(),
                            child: Builder(
                              builder: (context) {
                                final sList = List<Map<String, dynamic>>.from(
                                    prov.settlements);
                                // Mark as settlement for list builder compatibility if needed
                                for (var item in sList) {
                                  item['is_settlement'] = true;
                                }

                                // Sorting kronologis (terlama di atas) berdasarkan created_at atau ID
                                sList.sort((a, b) {
                                  final dateA = DateTime.tryParse(
                                          a['created_at']?.toString() ?? '') ??
                                      DateTime(2000);
                                  final dateB = DateTime.tryParse(
                                          b['created_at']?.toString() ?? '') ??
                                      DateTime(2000);
                                  return dateA.compareTo(dateB);
                                });

                                final topStatuses = [
                                  'draft',
                                  'submitted',
                                  'revision',
                                  'rejected',
                                  'approved',
                                ];
                                final items = <dynamic>[];

                                final displayList = sList.where((item) {
                                  final type =
                                      (item['settlement_type'] ?? 'single')
                                          .toString()
                                          .toLowerCase();
                                  return type == selectedType;
                                }).toList();

                                final topItems = displayList
                                    .where(
                                      (i) => topStatuses.contains(
                                        (i['status'] ?? '')
                                            .toString()
                                            .toLowerCase(),
                                      ),
                                    )
                                    .toList();
                                final bottomItems = displayList
                                    .where(
                                      (i) => !topStatuses.contains(
                                        (i['status'] ?? '')
                                            .toString()
                                            .toLowerCase(),
                                      ),
                                    )
                                    .toList();

                                if (topItems.isNotEmpty) {
                                  items.addAll(topItems);
                                  if (bottomItems.isNotEmpty) {
                                    items.add({'is_separator': true});
                                  }
                                }
                                items.addAll(bottomItems);

                                return CustomScrollView(
                                  key: const PageStorageKey('settlement_list'),
                                  controller: listScrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: buildScrollableSettlementHeader(
                                        context,
                                        auth,
                                        prov,
                                        isNarrow,
                                        isVeryNarrow,
                                        canShowExport,
                                        pagePadding,
                                        useCompact,
                                      ),
                                    ),
                                    if (prov.loading &&
                                        prov.settlements.isEmpty)
                                      const SliverFillRemaining(
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppTheme.primary,
                                          ),
                                        ),
                                      )
                                    else if (items.isEmpty)
                                      SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.inbox_rounded,
                                                size: 64,
                                                color: bodyColorLocal(
                                                  context,
                                                ).withValues(alpha: 0.3),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                selectedType == 'single'
                                                    ? 'Belum ada pengeluaran sendiri'
                                                    : 'Belum ada pengeluaran batch',
                                                style: TextStyle(
                                                  color: bodyColorLocal(
                                                    context,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      SliverPadding(
                                        padding: EdgeInsets.only(
                                          left: isNarrow ? 16 : 24,
                                          right: isNarrow ? 16 : 24,
                                          bottom: selectionMode
                                              ? 100
                                              : (isNarrow ? 16 : 24),
                                        ),
                                        sliver: SliverList(
                                          delegate: SliverChildBuilderDelegate((
                                            context,
                                            i,
                                          ) {
                                            final item = items[i]
                                                as Map<String, dynamic>;

                                            // Handle Status Separator
                                            if (item['is_separator'] == true) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 20,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Divider(
                                                        color: dividerColor(
                                                          context,
                                                        ),
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 16,
                                                      ),
                                                      child: Text(
                                                        'SINGLE',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: bodyColorLocal(
                                                            context,
                                                          ).withValues(
                                                            alpha: 0.5,
                                                          ),
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Divider(
                                                        color: dividerColor(
                                                          context,
                                                        ),
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            // Handle Type Separator (BATCH)
                                            if (item['is_type_separator'] ==
                                                true) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 40,
                                                  bottom: 20,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 4,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          2,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      item['label'] ?? 'BATCH',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: titleColorLocal(
                                                          context,
                                                        ),
                                                        letterSpacing: 2.0,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Divider(
                                                        color: dividerColor(
                                                          context,
                                                        ),
                                                        thickness: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }

                                            final isSettlement =
                                                item['is_settlement'] ?? true;
                                            final id = item['id'];

                                            if (isSettlement) {
                                              return RepaintBoundary(
                                                child: SettlementCard(
                                                  key: ValueKey(
                                                    'settlement_$id',
                                                  ),
                                                  settlement: item,
                                                  canSelect: auth.isManager ||
                                                      (item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'approved' &&
                                                          item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'completed'),
                                                  onDelete: selectionMode
                                                      ? null
                                                      : () => deleteSettlement(
                                                            id,
                                                          ),
                                                  selectionMode: selectionMode,
                                                  selected: selectedItemKeys
                                                      .contains('s_$id'),
                                                  onSelectionChanged: (v) =>
                                                      toggleItemSelection(
                                                    id,
                                                    true,
                                                    v,
                                                  ),
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          SettlementDetailScreen(
                                                        settlementId: id,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return RepaintBoundary(
                                                child: AdvanceCard(
                                                  key: ValueKey('advance_$id'),
                                                  advance: item,
                                                  isManager: auth.isManager,
                                                  canSelect: auth.isManager ||
                                                      (item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'approved' &&
                                                          item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'completed'),
                                                  selectionMode: selectionMode,
                                                  selected: selectedItemKeys
                                                      .contains('a_$id'),
                                                  onSelectionChanged: (v) =>
                                                      toggleItemSelection(
                                                    id,
                                                    false,
                                                    v,
                                                  ),
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AdvanceDetailScreen(
                                                        advanceId: id,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }, childCount: items.length),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (showScrollToTop)
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: FloatingActionButton.small(
                        heroTag: 'settlement_scroll_to_top',
                        onPressed: scrollToTop,
                        backgroundColor: cardColor(
                          context,
                        ).withValues(alpha: 0.9),
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
