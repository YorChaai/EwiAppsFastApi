import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expense_app/screens/widgets/transaction_cards.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/utils/file_helper.dart';
import 'package:expense_app/utils/app_snackbar.dart';

import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/advance/widgets/widget_scrollable_advance_header.dart';



class AdvancesScreen extends StatefulWidget {
  const AdvancesScreen({super.key});

  @override
  State<AdvancesScreen> createState() => AdvancesScreenState();
}

class AdvancesScreenState extends State<AdvancesScreen> {
  static const Duration searchDebounceDuration = Duration(milliseconds: 350);
  String? statusFilter;
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = '';
  double? annualAdvanceTotal;
  final ScrollController listScrollController = ScrollController();
  final TextEditingController searchCtrl = TextEditingController();
  Timer? searchDebounce;
  bool showScrollToTop = false;
  bool selectionMode = false;
  final Set<String> selectedItemKeys = {};
  String selectedType = 'single';
  String filterMode = 'report'; // Initial placeholder
  AdvanceProvider? advanceProvider; // ✅ Store reference

  Color cardColor(BuildContext context) =>
      context.isDark ? AppTheme.card : AppTheme.lightCard;
  Color titleColor(BuildContext context) =>
      context.isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color bodyColor(BuildContext context) =>
      context.isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color dividerColor(BuildContext context) =>
      context.isDark ? AppTheme.divider : AppTheme.lightDivider;
  Color primaryText(BuildContext context) =>
      context.isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  void handleListScroll() {
    if (!listScrollController.hasClients) {
      return;
    }
    final shouldShow = listScrollController.offset > 320;
    if (shouldShow != showScrollToTop && mounted) {
      setState(() => showScrollToTop = shouldShow);
    }
  }

  /// Memaksa daftar scroll kembali ke paling atas
  Future<void> scrollToTop() async {
    if (!listScrollController.hasClients) {
      return;
    }
    await listScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  /// Reset semua filter dan pencarian
  void resetFilters() {
    if (!mounted) return;
    setState(() {
      statusFilter = null;
      startDate = null;
      endDate = null;
      searchQuery = '';
      searchCtrl.clear();
      selectedType = 'single';
    });
    final prov = context.read<AdvanceProvider>();
    prov.clearFilters(); // Ini akan memicu loadAdvances secara internal
    loadAnnualAdvanceSummary();
    scrollToTop();
  }

  void scheduleAdvanceReload() {
    searchDebounce?.cancel();
    searchDebounce = Timer(searchDebounceDuration, reloadAdvances);
  }

  bool canDeleteAdvanceCard(Map<String, dynamic> advance, AuthProvider auth) {
    final status = (advance['status'] ?? '').toString().toLowerCase();
    if (auth.isManager) return true;
    return auth.user?['id'] == advance['user_id'] &&
        !['approved', 'in_settlement', 'completed', 'settled'].contains(status);
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
            child: Text('Batal', style: TextStyle(color: bodyColor(context))),
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

    try {
      final sProv = context.read<SettlementProvider>();
      final aProv = context.read<AdvanceProvider>();
      final keys = selectedItemKeys.toList();

      int successCount = 0;
      int failCount = 0;
      String? lastError;

      for (final key in keys) {
        final parts = key.split('_');
        if (parts.length != 2) continue;
        final type = parts[0];
        final id = int.tryParse(parts[1]);
        if (id == null) continue;

        bool success = false;
        if (type == 's') {
          success = await sProv.deleteSettlement(id, reload: false);
          if (!success) lastError = sProv.error;
        } else {
          success = await aProv.deleteAdvance(id, reload: false);
          if (!success) lastError = aProv.error;
        }

        if (success) {
          successCount++;
        } else {
          failCount++;
        }
      }

      await aProv.loadAdvances();
      await sProv.loadSettlements();

      if (mounted) {
        Navigator.pop(context); // hide loading
        setState(() {
          selectedItemKeys.clear();
          selectionMode = false;
        });

        if (failCount > 0) {
          AppSnackbar.show(
              'Berhasil: $successCount, Gagal: $failCount. ${lastError ?? ""}',
              isError: true);
        } else {
          AppSnackbar.show('Berhasil menghapus $successCount item');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // hide loading
        AppSnackbar.show('Gagal menghapus beberapa item: $e', isError: true);
      }
    }
  }

  Future<void> loadAnnualAdvanceSummary() async {
    try {
      final prov = context.read<AdvanceProvider>();
      final targetYear = prov.filterYear;
      final year = targetYear == 0 ? DateTime.now().year : targetYear;
      final res = await context.read<AuthProvider>().api.getAdvances(
            reportYear: year,
          );
      if (!mounted) return;
      final advances = List<Map<String, dynamic>>.from(res['advances'] ?? []);
      final total = advances.fold<double>(
        0,
        (sum, a) =>
            sum + (double.tryParse(a['total_amount']?.toString() ?? '0') ?? 0),
      );
      setState(() => annualAdvanceTotal = total);
    } catch (_) {}
  }

  void updateState(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  void reloadAdvances() {
    searchDebounce?.cancel();
    searchDebounce = null;
    final aProv = context.read<AdvanceProvider>();
    final sProv = context.read<SettlementProvider>();

    final effectiveStartDate = filterMode == 'range' && startDate != null
        ? DateFormat('yyyy-MM-dd').format(startDate!)
        : null;
    final effectiveEndDate = filterMode == 'range' && endDate != null
        ? DateFormat('yyyy-MM-dd').format(endDate!)
        : null;

    final targetYear = aProv.filterYear;

    aProv.loadAdvances(
      status: statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: filterMode,
      search: searchQuery.isEmpty ? null : searchQuery,
    );

    // ✅ ALWAYS sync Settlement to Kasbon to ensure they are fully synchronized as requested
    sProv.loadSettlements(
      status: statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: filterMode,
      search: searchQuery.isEmpty ? null : searchQuery,
    );

    loadAnnualAdvanceSummary();
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
        filterMode = 'range'; // Aktifkan mode range
      });
      reloadAdvances();
    }
  }

  Future<void> exportExcel() async {
    try {
      final bytes = await context.read<AdvanceProvider>().exportExcel(
            startDate: startDate != null
                ? DateFormat('yyyy-MM-dd').format(startDate!)
                : null,
            endDate: endDate != null
                ? DateFormat('yyyy-MM-dd').format(endDate!)
                : null,
          );
      if (!mounted) return;
      await FileHelper.saveAndOpenFolder(
        context: context,
        bytes: bytes,
        filename: 'Laporan_Kasbon_${FileHelper.formatTimestamp()}.xlsx',
        subFolder: 'Reports/Advances/Excel',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal export Excel: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> exportPdf() async {
    try {
      final bytes = await context.read<AdvanceProvider>().getBulkPdf(
            startDate: startDate != null
                ? DateFormat('yyyy-MM-dd').format(startDate!)
                : null,
            endDate: endDate != null
                ? DateFormat('yyyy-MM-dd').format(endDate!)
                : null,
          );
      if (!mounted) return;
      await FileHelper.saveAndOpenFile(
        context: context,
        bytes: bytes,
        filename: 'Laporan_Kasbon_${FileHelper.formatTimestamp()}.pdf',
        subFolder: 'Reports/Advances/PDF',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal export PDF: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  StreamSubscription<void>? refreshSub;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(handleListScroll);
    advanceProvider = context.read<AdvanceProvider>();
    filterMode = advanceProvider!.filterMode; // ✅ Sync mode
    advanceProvider!.addListener(onProviderChange);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AdvanceProvider>().syncReportYear();
      if (!mounted) return;
      reloadAdvances();
    });

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        reloadAdvances();
      }
    });
  }

  void onProviderChange() {
    if (!mounted) return;
    final prov = context.read<AdvanceProvider>();
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

    loadAnnualAdvanceSummary();
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    searchDebounce?.cancel();
    advanceProvider?.removeListener(onProviderChange);
    listScrollController.removeListener(handleListScroll);
    listScrollController.dispose();
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prov = context.watch<AdvanceProvider>();
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
                            onRefresh: () async => reloadAdvances(),
                            child: Builder(
                              builder: (context) {
                                final aList = prov.advances
                                    .map((a) => a.toJson())
                                    .toList();
                                // Mark as advance (not settlement) for list builder compatibility if needed
                                for (var item in aList) {
                                  item['is_settlement'] = false;
                                }

                                aList.sort((a, b) {
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
                                  'approved'
                                ];
                                final items = <dynamic>[];

                                final displayList = aList.where((item) {
                                  final type =
                                      (item['advance_type'] ?? 'single')
                                          .toString()
                                          .toLowerCase();
                                  return type == selectedType;
                                }).toList();

                                final topItems = displayList
                                    .where((i) => topStatuses.contains(
                                        (i['status'] ?? '')
                                            .toString()
                                            .toLowerCase()))
                                    .toList();
                                final bottomItems = displayList
                                    .where((i) => !topStatuses.contains(
                                        (i['status'] ?? '')
                                            .toString()
                                            .toLowerCase()))
                                    .toList();

                                if (topItems.isNotEmpty) {
                                  items.addAll(topItems);
                                  if (bottomItems.isNotEmpty) {
                                    items.add({'is_separator': true});
                                  }
                                }
                                items.addAll(bottomItems);

                                return CustomScrollView(
                                  key: const PageStorageKey('advance_list'),
                                  controller: listScrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: buildScrollableAdvanceHeader(
                                        context,
                                        auth,
                                        prov,
                                        isNarrow,
                                        isVeryNarrow,
                                        statusFilter == 'completed',
                                        pagePadding,
                                        useCompact,
                                      ),
                                    ),
                                    if (prov.loading && prov.advances.isEmpty)
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
                                                color: bodyColor(
                                                  context,
                                                ).withValues(alpha: 0.3),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                selectedType == 'single'
                                                    ? 'Belum ada kasbon mandiri'
                                                    : 'Belum ada kasbon batch',
                                                style: TextStyle(
                                                  color: bodyColor(context),
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
                                                        vertical: 20),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Divider(
                                                            color:
                                                                dividerColor(
                                                                    context),
                                                            thickness: 1)),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      child: Text(
                                                        'SINGLE',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: bodyColor(
                                                                  context)
                                                              .withValues(
                                                                  alpha: 0.5),
                                                          letterSpacing: 1.2,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Divider(
                                                            color:
                                                                dividerColor(
                                                                    context),
                                                            thickness: 1)),
                                                  ],
                                                ),
                                              );
                                            }

                                            // Handle Type Separator (BATCH)
                                            if (item['is_type_separator'] ==
                                                true) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 40, bottom: 20),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 4,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(2),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      item['label'] ?? 'BATCH',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: titleColor(
                                                            context),
                                                        letterSpacing: 2.0,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                        child: Divider(
                                                            color:
                                                                dividerColor(
                                                                    context),
                                                            thickness: 2)),
                                                  ],
                                                ),
                                              );
                                            }

                                            final isSettlement =
                                                item['is_settlement'] ?? false;
                                            final id = item['id'];

                                            if (isSettlement) {
                                              return RepaintBoundary(
                                                child: SettlementCard(
                                                  key: ValueKey(
                                                      'settlement_$id'),
                                                  settlement: item,
                                                  isManager: auth.isManager,
                                                  selectionMode: selectionMode,
                                                  selected: selectedItemKeys
                                                      .contains('s_$id'),
                                                  canSelect: auth.isManager ||
                                                      (item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'approved' &&
                                                          item['status']
                                                                  ?.toString()
                                                                  .toLowerCase() !=
                                                              'completed'),
                                                  onSelectionChanged: (v) =>
                                                      toggleItemSelection(
                                                          id, true, v),
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          SettlementDetailScreen(
                                                              settlementId: id),
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
                                                  onDelete: selectionMode
                                                      ? null
                                                      : () =>
                                                          deleteAdvance(id),
                                                  selectionMode: selectionMode,
                                                  selected: selectedItemKeys
                                                      .contains('a_$id'),
                                                  canSelect:
                                                      canDeleteAdvanceCard(
                                                          item, auth),
                                                  onSelectionChanged: (v) =>
                                                      toggleItemSelection(
                                                          id, false, v),
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AdvanceDetailScreen(
                                                              advanceId: id),
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

  Future<void> deleteAdvance(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(context),
        title: const Text('Hapus Kasbon'),
        content: const Text('Apakah Anda yakin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      if (!mounted) return;
      await context.read<AdvanceProvider>().deleteAdvance(id);
    }
  }
}
