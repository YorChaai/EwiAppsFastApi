  

// ---- main_layout.dart ----

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/settlement_provider.dart';
import '../providers/advance_provider.dart';
import '../providers/revenue_provider.dart';
import '../providers/tax_provider.dart';
import '../providers/dividend_provider.dart';
import '../providers/asset_provider.dart';
import '../providers/bank_management_provider.dart';
import '../providers/bank_status_provider.dart';
import '../theme/app_theme.dart';
import '../utils/file_helper.dart';
import '../utils/context_extensions.dart';
import '../utils/app_dialogs.dart';
import '../utils/app_formatters.dart';
import '../utils/currency_formatter.dart';
import '../utils/event_bus.dart';
import '../widgets/notification_bell_icon.dart';
import 'settlement/settlement_detail_screen.dart';
import 'reports/report_screen.dart';
import 'advance/advances_screen.dart';
import 'advance/advance_detail_screen.dart';
import 'settings/settings_screen.dart';
import 'management/category_management_screen.dart';
import 'management/bank_management_screen.dart';
import '../utils/responsive_layout.dart';
import 'widgets/sidebar.dart';
import 'widgets/page_selector.dart';
import 'widgets/common_widgets.dart';
import '../widgets/app_scrollbar.dart';
import '../utils/app_snackbar.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';

import 'widgets/transaction_cards.dart';

part 'main_layout_widgets.dart';
part 'widget_type_toggle.dart';
part 'widget_toggle_button.dart';
part 'widget_scrollable_settlement_header.dart';
part 'widget_summary_cards.dart';
part 'main_layout_settlement_list.dart';
part 'main_layout_settlement_list_dialogs.dart';

typedef TabSwitchCallback = void Function(int index);
TabSwitchCallback? globalSwitchTab;

class MainLayout extends StatefulWidget {
  final int initialTabIndex;

  const MainLayout({super.key, this.initialTabIndex = 0});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _navIndex = 0;
  int _pendingSettlements = 0;
  int _pendingAdvances = 0;
  bool _sidebarExpanded = true;
  int? _lastNotificationId;
  Key _reportPageKey = UniqueKey();
  Key _settingsPageKey = UniqueKey();

  void switchToTab(int index) {
    if (!mounted) return;
    setState(() {
      _navIndex = index;
    });
  }

  // GlobalKeys to control child scroll positions
  final GlobalKey<_SettlementListViewState> _settlementListKey = GlobalKey();
  final GlobalKey<AdvancesScreenState> _advancesListKey = GlobalKey();

  Color _surfaceColor(BuildContext context) =>
      context.isDark ? AppTheme.surface : AppTheme.lightSurface;
  Color _dividerColor(BuildContext context) =>
      context.isDark ? AppTheme.divider : AppTheme.lightDivider;
  Color _titleColor(BuildContext context) =>
      context.isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color _bodyColor(BuildContext context) =>
      context.isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

  @override
  void initState() {
    super.initState();
    _navIndex = widget.initialTabIndex;
    globalSwitchTab = switchToTab;
    Future.microtask(() async {
      if (!mounted) return;
      final settlementProvider = context.read<SettlementProvider>();
      final advanceProvider = context.read<AdvanceProvider>();
      final notificationProvider = context.read<NotificationProvider>();

      // Sync report years from settings first
      await Future.wait([
        settlementProvider.syncReportYear(force: true),
        advanceProvider.syncReportYear(force: true),
        context.read<RevenueProvider>().syncReportYear(force: true),
        context.read<TaxProvider>().syncReportYear(force: true),
        context.read<DividendProvider>().syncReportYear(force: true),
        context.read<AssetProvider>().syncReportYear(force: true),
        context.read<BankManagementProvider>().syncReportYear(force: true),
        context.read<BankStatusProvider>().syncReportYear(force: true),
      ]);

      if (!mounted) return;

      await Future.wait([
        settlementProvider.loadCategories(),
        settlementProvider.loadSettlements(),
        advanceProvider.loadAdvances(),
        _fetchBadgeCounts(),
      ]);
      if (mounted) {
        notificationProvider.startPolling();
        _setupNotificationListener();
      }
    });
  }

  void _setupNotificationListener() {
    final provider = context.read<NotificationProvider>();
    provider.removeListener(_onNotificationUpdate);
    provider.addListener(_onNotificationUpdate);
  }

  void _onNotificationUpdate() {
    if (!mounted) return;
    final provider = context.read<NotificationProvider>();
    if (provider.notifications.isNotEmpty) {
      final latest = provider.notifications.first;
      if (_lastNotificationId == null) {
        _lastNotificationId = latest.id;
      } else if (latest.id > _lastNotificationId!) {
        _lastNotificationId = latest.id;
        _showNotificationSnackBar(latest);
      }
    }
  }

  void _showNotificationSnackBar(NotificationModel notification) {
    AppSnackbar.show(
      notification.message,
      isSuccess: true,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    try {
      if (mounted) {
        context.read<NotificationProvider>().removeListener(
              _onNotificationUpdate,
            );
      }
    } catch (_) {}
    if (globalSwitchTab == switchToTab) {
      globalSwitchTab = null;
    }
    super.dispose();
  }

  Future<void> _fetchBadgeCounts() async {
    try {
      final auth = context.read<AuthProvider>();
      if (!auth.isLoggedIn) return;
      final api = auth.api;
      final data = await api.getDashboardSummary();
      if (mounted) {
        setState(() {
          _pendingSettlements = data['pending_settlements'] ?? 0;
          _pendingAdvances = data['pending_advances'] ?? 0;
        });
      }
    } catch (e) {
      debugPrint('Failed to fetch badge counts: $e');
    }
  }

  int? _extractIdFromPath(String path) {
    final parts = path.split('/');
    for (int i = parts.length - 1; i >= 0; i--) {
      final value = int.tryParse(parts[i]);
      if (value != null) return value;
    }
    return null;
  }

  Future<void> _handleNotificationTap(String rawPath) async {
    if (!mounted) return;
    final path = rawPath.trim().toLowerCase();
    final id = _extractIdFromPath(path);
    if (path.contains('/settlements')) {
      setState(() => _navIndex = 0);
      if (id != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SettlementDetailScreen(settlementId: id),
          ),
        );
      }
      return;
    }
    if (path.contains('/advances')) {
      setState(() => _navIndex = 1);
      if (id != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdvanceDetailScreen(advanceId: id)),
        );
      }
      return;
    }
    if (path.contains('/categories')) {
      if (context.read<AuthProvider>().isManager) setState(() => _navIndex = 3);
      return;
    }
    if (path.contains('/reports')) {
      if (context.read<AuthProvider>().isManager) setState(() => _navIndex = 2);
      return;
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await AppDialogs.showExitConfirmation(
      context,
      isLogout: true,
    );
    if (confirmed && mounted) {
      // Tunggu hingga transisi penutupan dialog selesai sepenuhnya (~300ms)
      // sebelum memicu logout. Ini mencegah MaterialApp/Navigator dihancurkan
      // di tengah-tengah transisi pop, yang dapat mengakibatkan layar blank
      // atau transparan akibat error siklus hidup internal Flutter.
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        context.read<AuthProvider>().logout();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return const SizedBox.shrink();
    }
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    // UI Scaling for mobile-like windows
    final safeWidth = ResponsiveLayout.safeWidth(context);
    final isMobile =
        ResponsiveLayout.isMobile(context) || isAndroid || safeWidth < 600;
    final isPhoneLandscape = ResponsiveLayout.isPhoneLandscape(context);
    final isTablet = ResponsiveLayout.isTablet(context) && safeWidth >= 800;

    final compactAppBar = safeWidth < 430;
    final showSidebar = !isMobile && !isAndroid && safeWidth >= 600;
    final sidebarWidth =
        showSidebar ? (isTablet || !_sidebarExpanded ? 80.0 : 240.0) : 0.0;
    final pages = [
      _SettlementListView(key: _settlementListKey),
      AdvancesScreen(key: _advancesListKey),
      if (auth.isManager) ReportScreen(key: _reportPageKey),
      if (auth.isManager) const CategoryManagementView(),
      if (auth.isManager) const BankManagementScreen(),
      if (auth.isManager) const BankManagementScreen(initialSection: 'advance'),
      SettingsScreen(key: _settingsPageKey),
    ];
    final currentIndex = _navIndex.clamp(0, pages.length - 1);

    // UI Scaling for mobile-like windows
    final useCompact = isMobile || safeWidth < 500;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final confirmed = await AppDialogs.showExitConfirmation(
          context,
          isLogout: false,
        );
        if (confirmed && mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Row(
          children: [
            if (showSidebar)
              SizedBox(
                width: sidebarWidth,
                child: DashboardSidebar(
                  currentIndex: currentIndex,
                  isManager: auth.isManager,
                  fullName: auth.fullName,
                  role: auth.roleDisplayName,
                  profileImageUrl: auth.profileImageUrl,
                  onNotificationTap: _handleNotificationTap,
                  onNavTap: (i) {
                    // Hanya reset jika klik menu yang sama (sebagai shortcut refresh/reset)
                    if (i == _navIndex) {
                      if (i == 0) {
                        _settlementListKey.currentState?.resetFilters();
                      } else if (i == 1) {
                        _advancesListKey.currentState?.resetFilters();
                      }
                    } else {
                      // ✅ Reload target tab with its current year to prevent data leakage
                      if (i == 0) {
                        _settlementListKey.currentState?.reloadSettlements();
                      } else if (i == 1) {
                        _advancesListKey.currentState?.reloadAdvances();
                      }
                    }

                    setState(() {
                      _navIndex = i;
                      if (i == 2) _reportPageKey = UniqueKey();
                      if (i == (auth.isManager ? 6 : 2)) {
                        _settingsPageKey = UniqueKey();
                      }
                    });
                  },
                  onLogout: _confirmLogout,
                  isMini: isTablet,
                  isExpanded: _sidebarExpanded,
                  onToggleExpand: isTablet
                      ? null
                      : () => setState(
                            () => _sidebarExpanded = !_sidebarExpanded,
                          ),
                  pendingSettlements: auth.isManager ? _pendingSettlements : 0,
                  pendingAdvances: auth.isManager ? _pendingAdvances : 0,
                ),
              ),
            if (showSidebar) Container(width: 1, color: _dividerColor(context)),
            Expanded(
              child: Scaffold(
                appBar: (isMobile || isAndroid || safeWidth < 500)
                    ? AppBar(
                        toolbarHeight:
                            isPhoneLandscape ? 50 : (useCompact ? 56 : 64),
                        elevation: 0,
                        backgroundColor: _surfaceColor(context),
                        centerTitle: false,
                        titleSpacing: compactAppBar ? 8 : 16,
                        title: Row(
                          children: [
                            Container(
                              width: useCompact ? 32 : 36,
                              height: useCompact ? 32 : 36,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black.withValues(alpha: 0.4)
                                      : Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                image: auth.profileImageUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          auth.profileImageUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: auth.profileImageUrl == null
                                  ? Center(
                                      child: Text(
                                        auth.fullName.isNotEmpty
                                            ? auth.fullName[0].toUpperCase()
                                            : 'U',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: useCompact ? 11 : 12,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
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
                                      color: _titleColor(context),
                                      fontSize: useCompact
                                          ? 13
                                          : (compactAppBar ? 13 : 15),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (!compactAppBar && safeWidth > 380)
                                    Text(
                                      auth.roleDisplayName,
                                      style: TextStyle(
                                        color: _bodyColor(context),
                                        fontSize: 9,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            PageSelector(
                              currentIndex: currentIndex,
                              isManager: auth.isManager,
                              compact: true,
                              onChanged: (index) {
                                // Hanya reset jika klik tab yang sama
                                if (index == currentIndex) {
                                  if (index == 0) {
                                    _settlementListKey.currentState
                                        ?.resetFilters();
                                  } else if (index == 1) {
                                    _advancesListKey.currentState
                                        ?.resetFilters();
                                  }
                                }
                                setState(() => _navIndex = index);
                              },
                            ),
                          ],
                        ),
                        actions: [
                          NotificationBellIcon(
                            onNotificationTap: _handleNotificationTap,
                          ),
                          SizedBox(width: compactAppBar ? 2 : 4),
                          if (auth.accessibleCompanies.length > 1)
                            IconButton(
                              icon: Icon(
                                Icons.dashboard_rounded,
                                size: useCompact ? 18 : 20,
                              ),
                              onPressed: () => context
                                  .read<AuthProvider>()
                                  .clearActiveCompany(),
                              color: _bodyColor(context),
                              tooltip: 'Pilih Perusahaan Lain',
                            ),
                          IconButton(
                            icon: Icon(
                              Icons.logout_rounded,
                              size: useCompact ? 18 : 20,
                            ),
                            onPressed: _confirmLogout,
                            color: AppTheme.danger,
                            tooltip: 'Logout',
                          ),
                          SizedBox(width: compactAppBar ? 4 : 8),
                        ],
                      )
                    : null,
                body: SafeArea(
                  top: false,
                  child: IndexedStack(index: currentIndex, children: pages),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ---- main_layout_widgets.dart ----

part of 'main_layout.dart';

extension _DashboardWidgetsExt on _SettlementListViewState {








  Future<void> _deleteSettlement(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: const Text('Hapus Settlement'),
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
      await context.read<SettlementProvider>().deleteSettlement(id);
    }
  }
}

class _FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isMobile;
  final VoidCallback onTap;

  const _FilterChipWidget({
    required this.label,
    required this.selected,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final textColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 10 : 14,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppTheme.primary : borderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppTheme.primary : textColor,
          ),
        ),
      ),
    );
  }
}

class StatusFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isMobile;
  final VoidCallback onTap;
  const StatusFilterChip({
    super.key,
    required this.label,
    required this.selected,
    this.isMobile = false,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return _FilterChipWidget(
      label: label,
      selected: selected,
      isMobile: isMobile,
      onTap: onTap,
    );
  }
}


// ---- widget_type_toggle.dart ----

part of 'main_layout.dart';

extension _MainLayoutWidgetsTypeToggleExt on _SettlementListViewState {
  Widget _buildTypeToggle(bool useCompact) {
    final sProv = context.watch<SettlementProvider>();

    final itemsForCounts = sProv.settlements;

    final singlesCount = itemsForCounts
        .where((i) => (i['settlement_type'] ?? 'single') == 'single')
        .length;
    final batchesCount = itemsForCounts
        .where((i) => (i['settlement_type'] ?? 'single') == 'batch')
        .length;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _cardColor(context).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    context.isDark ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildToggleButton(
                    label: 'Single',
                    count: singlesCount,
                    value: 'single',
                    useCompact: useCompact,
                  ),
                  const SizedBox(width: 4),
                  _buildToggleButton(
                    label: 'Batch',
                    count: batchesCount,
                    value: 'batch',
                    useCompact: useCompact,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ---- widget_toggle_button.dart ----

part of 'main_layout.dart';

extension _MainLayoutWidgetsToggleButtonExt on _SettlementListViewState {
  Widget _buildToggleButton({
    required String label,
    required int count,
    required String value,
    required bool useCompact,
  }) {
    final isActive = _selectedType == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => updateState(() => _selectedType = value),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: useCompact
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: useCompact ? 11 : 13,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : (context.isDark
                            ? AppTheme.textSecondary
                            : AppTheme.lightTextSecondary),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.2)
                        : (context.isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.black.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: useCompact ? 10 : 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ---- widget_scrollable_settlement_header.dart ----

part of 'main_layout.dart';

extension _MainLayoutWidgetsScrollableSettlementHeaderExt on _SettlementListViewState {
  Widget _buildScrollableSettlementHeader(
    BuildContext context,
    AuthProvider auth,
    SettlementProvider prov,
    bool isNarrow,
    bool isVeryNarrow,
    bool canShowExport,
    EdgeInsets pagePadding,
    bool useCompact,
  ) {
    return Padding(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.isManager ? 'Semua Settlement' : 'Settlement Saya',
                      style: TextStyle(
                        fontSize: useCompact ? 18 : (isNarrow ? 20 : 24),
                        fontWeight: FontWeight.bold,
                        color: _titleColorLocal(context),
                      ),
                    ),
                    Text(
                      '${prov.settlements.length} total',
                      style: TextStyle(
                        color: _bodyColorLocal(context),
                        fontSize: useCompact ? 10 : 13,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (_selectionMode)
                    IconButton(
                      onPressed: () {
                        updateState(() {
                          _selectionMode = false;
                          _selectedItemKeys.clear();
                        });
                      },
                      icon: Icon(Icons.close_rounded,
                          color: AppTheme.danger, size: useCompact ? 22 : 26),
                      tooltip: 'Batal',
                    ),
                  if (_selectionMode) const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {
                      if (!_selectionMode) {
                        updateState(() {
                          _selectionMode = true;
                        });
                      } else {
                        if (_selectedItemKeys.isNotEmpty) {
                          _bulkDeleteItems();
                        }
                      }
                    },
                    icon: Icon(
                      _selectionMode
                          ? Icons.delete_sweep_rounded
                          : Icons.delete_outline_rounded,
                      color: AppTheme.danger,
                      size: useCompact ? 22 : 26,
                    ),
                    tooltip: _selectionMode
                        ? 'Hapus (${_selectedItemKeys.length})'
                        : 'Pilih Banyak',
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: _selectionMode
                        ? null
                        : () => _showCreateDialog(context),
                    icon: Icon(Icons.add, size: useCompact ? 16 : 20),
                    label: Text(
                      isNarrow ? 'Buat' : 'Buat Settlement',
                      style: TextStyle(fontSize: useCompact ? 12 : 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: useCompact
                          ? const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            )
                          : null,
                      minimumSize: useCompact ? const Size(0, 36) : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: useCompact ? 10 : 16),
          _buildSummaryCards(isNarrow, useCompact),
          SizedBox(height: useCompact ? 10 : 16),
          TextField(
            controller: _searchCtrl,
            style: TextStyle(fontSize: useCompact ? 13 : 14),
            decoration: InputDecoration(
              isDense: useCompact,
              hintText: 'Cari settlement...',
              prefixIcon: Icon(Icons.search, size: useCompact ? 18 : 24),
              contentPadding:
                  useCompact ? const EdgeInsets.symmetric(vertical: 6) : null,
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: useCompact ? 16 : 20),
                      onPressed: () {
                        _searchCtrl.clear();
                        updateState(() => _searchQuery = '');
                        _reloadSettlements();
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              updateState(() => _searchQuery = val);
              _scheduleSettlementReload();
            },
          ),
          SizedBox(height: useCompact ? 12 : 16),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SATU TOMBOL UNTUK SEMUA: Periode Data
                  CascadingYearFilter(
                    label: 'Periode Data',
                    selectedYear: prov.filterYear,
                    currentMode: _filterMode,
                    useCompact: useCompact,
                    startDate: _startDate,
                    endDate: _endDate,
                    onSelected: (year, mode) {
                      updateState(() {
                        _filterMode = mode;
                      });
                      prov.setFilterYear(year, mode, reload: false);
                      _reloadSettlements();
                    },
                    onRangeTap: () => _pickDateRange(context),
                  ),
                  const SizedBox(width: 12),
                  CascadingStatusFilter(
                    selectedStatus: _statusFilter,
                    useCompact: useCompact,
                    isManager: auth.isManager,
                    onSelected: (val) {
                      updateState(() => _statusFilter = val);
                      _reloadSettlements();
                    },
                  ),
                  if (auth.isManager && canShowExport) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _exportExcel,
                      icon: const Icon(
                        Icons.table_chart_rounded,
                        color: AppTheme.success,
                      ),
                    ),
                    IconButton(
                      onPressed: _exportPdf,
                      icon: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppTheme.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: useCompact ? 8 : 12),
          _buildTypeToggle(useCompact),
        ],
      ),
    );
  }
}


// ---- widget_summary_cards.dart ----

part of 'main_layout.dart';

extension _MainLayoutWidgetsSummaryCardsExt on _SettlementListViewState {
  Widget _buildSummaryCards(bool isNarrow, bool useCompact) {
    final prov = context.read<SettlementProvider>();
    final targetYear = prov.filterYear;
    final total = _annualSettlementTotal ?? 0.0;
    final card = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: useCompact ? 8 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dividerColor(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(useCompact ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.teal.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.teal,
              size: useCompact ? 18 : 20,
            ),
          ),
          SizedBox(width: useCompact ? 10 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                targetYear == 0
                    ? 'Pengeluaran Semua Tahun'
                    : 'Pengeluaran Tahun $targetYear',
                style: TextStyle(
                  fontSize: useCompact ? 9 : 11,
                  color: _bodyColorLocal(context),
                ),
              ),
              Text(
                'Rp ${formatNumber(total)}',
                style: TextStyle(
                  fontSize: useCompact ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: _titleColorLocal(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Gunakan Row + Expanded hanya jika layar lebar (desktop) untuk memenuhi ruang horizontal
    if (!isNarrow) {
      return Row(children: [Expanded(child: card)]);
    }
    return card;
  }
}


// ---- main_layout_settlement_list.dart ----

part of 'main_layout.dart';

class _SettlementListView extends StatefulWidget {
  const _SettlementListView({super.key});
  @override
  State<_SettlementListView> createState() => _SettlementListViewState();
}

class _SettlementListViewState extends State<_SettlementListView> {
  static const Duration _searchDebounceDuration = Duration(milliseconds: 350);
  String? _statusFilter;
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';
  double? _annualSettlementTotal;
  final ScrollController _listScrollController = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _searchDebounce;
  Timer? _summaryDebounce;
  bool _showScrollToTop = false;
  bool _selectionMode = false;
  final Set<String> _selectedItemKeys = {};
  String _selectedType = 'single';
  String _filterMode = 'report'; // Default placeholder, will sync in initState
  SettlementProvider? _settlementProvider; // ✅ Store reference
  StreamSubscription<void>? _refreshSub;

  Color _cardColor(BuildContext context) =>
      context.isDark ? AppTheme.card : AppTheme.lightCard;
  Color _titleColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color _bodyColorLocal(BuildContext context) =>
      context.isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color _dividerColor(BuildContext context) =>
      context.isDark ? AppTheme.divider : AppTheme.lightDivider;
  Color _primaryTextLocal(BuildContext context) =>
      context.isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  void _handleListScroll() {
    if (!_listScrollController.hasClients) return;
    final shouldShow = _listScrollController.offset > 320;
    if (shouldShow != _showScrollToTop && mounted) {
      setState(() => _showScrollToTop = shouldShow);
    }
  }

  Future<void> scrollToTop() async {
    if (!_listScrollController.hasClients) return;
    await _listScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _scheduleSettlementReload() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, _reloadSettlements);
  }

  /// Reset semua filter dan pencarian
  void resetFilters() {
    if (!mounted) return;
    setState(() {
      _statusFilter = null;
      _searchQuery = '';
      _searchCtrl.clear();
      _startDate = null;
      _endDate = null;
      _selectedType = 'single';
    });
    context.read<SettlementProvider>().clearFilters();
    scrollToTop();
  }

  void _toggleItemSelection(int id, bool isSettlement, bool selected) {
    final key = isSettlement ? 's_$id' : 'a_$id';
    setState(() {
      if (selected) {
        _selectedItemKeys.add(key);
        _selectionMode = true;
      } else {
        _selectedItemKeys.remove(key);
      }
      if (_selectedItemKeys.isEmpty) _selectionMode = false;
    });
  }

  Future<void> _bulkDeleteItems() async {
    if (_selectedItemKeys.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: const Text('Hapus Masal'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${_selectedItemKeys.length} item terpilih?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(color: _bodyColorLocal(context)),
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
      final keys = _selectedItemKeys.toList();

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
          _selectedItemKeys.clear();
          _selectionMode = false;
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
    _listScrollController.addListener(_handleListScroll);
    _settlementProvider = context.read<SettlementProvider>();
    _statusFilter = _settlementProvider!.statusFilter;
    _filterMode = _settlementProvider!.filterMode; // ✅ Sync mode
    _searchQuery = _settlementProvider!.searchQuery ?? '';
    _searchCtrl.text = _searchQuery;
    if (_settlementProvider!.startDate != null) {
      _startDate = DateTime.tryParse(_settlementProvider!.startDate!);
    }
    if (_settlementProvider!.endDate != null) {
      _endDate = DateTime.tryParse(_settlementProvider!.endDate!);
    }

    // ✅ Add listener to reload summary when year changes from other screens (e.g. ReportScreen)
    _settlementProvider!.addListener(_onProviderChange);

    _loadDefaultReportYearAndReload();

    _refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        _reloadSettlements();
      }
    });
  }

  void _onProviderChange() {
    if (!mounted) return;

    final prov = context.read<SettlementProvider>();
    bool changed = false;

    if (_statusFilter != prov.statusFilter) {
      _statusFilter = prov.statusFilter;
      changed = true;
    }
    if (_filterMode != prov.filterMode) {
      _filterMode = prov.filterMode;
      changed = true;
    }

    final provStart =
        prov.startDate != null ? DateTime.tryParse(prov.startDate!) : null;
    if (_startDate != provStart) {
      _startDate = provStart;
      changed = true;
    }

    final provEnd =
        prov.endDate != null ? DateTime.tryParse(prov.endDate!) : null;
    if (_endDate != provEnd) {
      _endDate = provEnd;
      changed = true;
    }

    final provSearch = prov.searchQuery ?? '';
    if (_searchQuery != provSearch) {
      _searchQuery = provSearch;
      _searchCtrl.text = provSearch;
      changed = true;
    }

    if (changed) {
      setState(() {});
    }

    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn || !auth.isManager) return;
    _loadAnnualSettlementSummary();
  }

  @override
  void dispose() {
    _refreshSub?.cancel();
    _searchDebounce?.cancel();
    _summaryDebounce?.cancel();
    _settlementProvider?.removeListener(_onProviderChange);
    _listScrollController.removeListener(_handleListScroll);
    _listScrollController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDefaultReportYearAndReload() async {
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();
    await Future.wait([sProv.syncReportYear(), aProv.syncReportYear()]);
    if (!mounted) return;
    _reloadSettlements();
    _loadDashboardSummary();
  }

  Future<void> _loadDashboardSummary() async {
    try {
      final auth = context.read<AuthProvider>();
      if (!auth.isLoggedIn) return;
      await auth.api.getDashboardSummary();
      if (!mounted) return;
    } catch (e) {
      debugPrint('ERROR dashboard summary: $e');
    }
  }

  Future<void> _loadAnnualSettlementSummary() async {
    if (!mounted) return;
    _summaryDebounce?.cancel();
    _summaryDebounce = Timer(const Duration(milliseconds: 1000), () async {
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
            () => _annualSettlementTotal =
                ((data['grand_total'] ?? 0) as num).toDouble(),
          );
        }
      } catch (e) {
        debugPrint('ERROR annual summary: $e');
      }
    });
  }

  void updateState(VoidCallback fn) {
    setState(fn);
  }

  void reloadSettlements() {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;

    _searchDebounce?.cancel();
    _searchDebounce = null;
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();

    final effectiveStartDate = _filterMode == 'range' && _startDate != null
        ? DateFormat('yyyy-MM-dd').format(_startDate!)
        : null;
    final effectiveEndDate = _filterMode == 'range' && _endDate != null
        ? DateFormat('yyyy-MM-dd').format(_endDate!)
        : null;

    final targetYear = sProv.filterYear;

    sProv.loadSettlements(
      status: _statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: _filterMode,
      search: _searchQuery,
    );

    // ✅ ALWAYS sync Advance to Settlement to ensure they are fully synchronized as requested
    aProv.loadAdvances(
      status: _statusFilter,
      startDate: effectiveStartDate,
      endDate: effectiveEndDate,
      reportYear: targetYear,
      mode: _filterMode,
      search: _searchQuery,
    );

    _loadAnnualSettlementSummary();
  }

  void _reloadSettlements() => reloadSettlements();

  Future<void> _pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await AppDateRangePicker.show(
      context,
      initialRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _filterMode = 'range'; // Tambahkan ini agar label berubah
      });
      _reloadSettlements();
    }
  }

  Future<void> _exportExcel() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.exportExcel(
        status: _statusFilter,
        startDate: _startDate != null
            ? DateFormat('yyyy-MM-dd').format(_startDate!)
            : null,
        endDate: _endDate != null
            ? DateFormat('yyyy-MM-dd').format(_endDate!)
            : null,
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

  Future<void> _exportPdf() async {
    try {
      final prov = context.read<SettlementProvider>();
      final bytes = await prov.getBulkPdf(
        status: _statusFilter,
        startDate: _startDate != null
            ? DateFormat('yyyy-MM-dd').format(_startDate!)
            : null,
        endDate: _endDate != null
            ? DateFormat('yyyy-MM-dd').format(_endDate!)
            : null,
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
    final canShowExport = _statusFilter == 'completed';
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
                          controller: _listScrollController,
                          thumbVisibility: true,
                          interactive: true,
                          child: RefreshIndicator(
                            onRefresh: () async => _reloadSettlements(),
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
                                  return type == _selectedType;
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
                                  controller: _listScrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  slivers: [
                                    SliverToBoxAdapter(
                                      child: _buildScrollableSettlementHeader(
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
                                                color: _bodyColorLocal(
                                                  context,
                                                ).withValues(alpha: 0.3),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                _selectedType == 'single'
                                                    ? 'Belum ada pengeluaran sendiri'
                                                    : 'Belum ada pengeluaran batch',
                                                style: TextStyle(
                                                  color: _bodyColorLocal(
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
                                          bottom: _selectionMode
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
                                                        color: _dividerColor(
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
                                                          color:
                                                              _bodyColorLocal(
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
                                                        color: _dividerColor(
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
                                                        color: _titleColorLocal(
                                                          context,
                                                        ),
                                                        letterSpacing: 2.0,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Divider(
                                                        color: _dividerColor(
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
                                                  onDelete: _selectionMode
                                                      ? null
                                                      : () => _deleteSettlement(
                                                            id,
                                                          ),
                                                  selectionMode: _selectionMode,
                                                  selected: _selectedItemKeys
                                                      .contains('s_$id'),
                                                  onSelectionChanged: (v) =>
                                                      _toggleItemSelection(
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
                                                  selectionMode: _selectionMode,
                                                  selected: _selectedItemKeys
                                                      .contains('a_$id'),
                                                  onSelectionChanged: (v) =>
                                                      _toggleItemSelection(
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
                  if (_showScrollToTop)
                    Positioned(
                      bottom: 24,
                      right: 24,
                      child: FloatingActionButton.small(
                        heroTag: 'settlement_scroll_to_top',
                        onPressed: scrollToTop,
                        backgroundColor: _cardColor(
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


// ---- main_layout_settlement_list_dialogs.dart ----

part of 'main_layout.dart';

extension _SettlementListDialogs on _SettlementListViewState {

  void _showStandaloneReturnDialog(BuildContext context, double outstanding) {
    final aProv = context.read<AdvanceProvider>();
    final auth = context.read<AuthProvider>();
    final userId = auth.user?['id'] ?? 0;

    final amountCtrl =
        TextEditingController(text: AppFormatters.formatCurrencyPlain(outstanding));
    final descCtrl = TextEditingController();
    
    String? selectedSource;
    bool isSaving = false;
    File? evidence;

    bool isLoadingBanks = true;
    List<Map<String, dynamic>> bankList = [];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          if (isLoadingBanks && bankList.isEmpty) {
            isLoadingBanks = false; // Prevent re-fetching
            Future.wait<dynamic>([
              auth.api.getManagementBanks(),
              auth.api.getUserVirtualBalances(userId),
              auth.api.getActiveAdvanceBalance(userId),
            ]).then((results) {
              final mBanks = (results[0] as Map<String, dynamic>)['banks'] as List? ?? [];
              final virtualBalances = results[1] as List? ?? [];
              final advanceRes = results[2] as Map<String, dynamic>? ?? {};
              final advanceBreakdown = advanceRes['breakdown'] as List? ?? [];

              final Map<String, Map<String, dynamic>> combinedBanks = {};

              // 1. Add all management banks
              for (var b in mBanks) {
                final name = b['name']?.toString() ?? '';
                if (name.isNotEmpty) {
                  combinedBanks[name] = {
                    'name': name,
                    'hutang': 0.0,
                    'advance': 0.0,
                  };
                }
              }

              // 2. Add Hutang (Virtual Balances)
              for (var b in virtualBalances) {
                final name = b['bank_name']?.toString() ?? '';
                final bal = double.tryParse(b['balance']?.toString() ?? '0') ?? 0.0;
                if (name.isNotEmpty) {
                  if (!combinedBanks.containsKey(name)) {
                    combinedBanks[name] = {'name': name, 'hutang': 0.0, 'advance': 0.0};
                  }
                  combinedBanks[name]!['hutang'] = bal;
                }
              }

              // 3. Add Advance (Sisa Kasbon)
              for (var b in advanceBreakdown) {
                final name = b['bank_name']?.toString() ?? '';
                final bal = (b['balance'] is num)
                    ? (b['balance'] as num).toDouble()
                    : (double.tryParse(b['balance']?.toString() ?? '0') ?? 0.0);
                if (name.isNotEmpty) {
                  if (!combinedBanks.containsKey(name)) {
                    combinedBanks[name] = {'name': name, 'hutang': 0.0, 'advance': 0.0};
                  }
                  combinedBanks[name]!['advance'] = bal;
                }
              }

              final sortedBanks = combinedBanks.values.toList();
              // Sort alphabetically
              sortedBanks.sort((a, b) =>
                  (a['name'] as String).compareTo(b['name'] as String));

              if (ctx.mounted) {
                setDialogState(() {
                  bankList = sortedBanks;
                  if (bankList.isNotEmpty) {
                    selectedSource = bankList.first['name'] as String;
                  }
                });
              }
            });
          }

          return AlertDialog(
            backgroundColor: _cardColor(ctx),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Pengembalian Dana Langsung',
                style: TextStyle(color: _titleColorLocal(ctx))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: amountCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: InputDecoration(
                      labelText: 'Nominal Pengembalian',
                      labelStyle: TextStyle(color: _primaryTextLocal(ctx)),
                    ),
                    style: TextStyle(color: _primaryTextLocal(ctx)),
                  ),
                  const SizedBox(height: 16),
                  if (bankList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedSource,
                      dropdownColor: _cardColor(ctx),
                      decoration: InputDecoration(
                        labelText: 'Sumber Bank',
                        labelStyle: TextStyle(color: _primaryTextLocal(ctx)),
                      ),
                      style: TextStyle(color: _primaryTextLocal(ctx)),
                      items: bankList.map((b) {
                        final name = b['name'] as String;
                        final hutang = b['hutang'] as double;
                        final advance = b['advance'] as double;

                        return DropdownMenuItem<String>(
                          value: name,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hutang > 0)
                                Text(
                                  AppFormatters.formatCurrency(hutang),
                                  style: const TextStyle(
                                    color: AppTheme.danger,
                                    fontSize: 13,
                                  ),
                                )
                              else if (advance > 0)
                                Text(
                                  AppFormatters.formatCurrency(advance),
                                  style: const TextStyle(
                                    color: AppTheme.accent,
                                    fontSize: 13,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (v) => setDialogState(() => selectedSource = v),
                    ),
                  const SizedBox(height: 16),
                TextFormField(
                  controller: descCtrl,
                  decoration: InputDecoration(
                    labelText: 'Keterangan',
                    hintText: 'Pengembalian Dana Mandiri (Standalone)',
                    hintStyle: const TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(color: _primaryTextLocal(ctx)),
                  ),
                  style: TextStyle(color: _primaryTextLocal(ctx)),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await FilePicker.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                      allowMultiple: false,
                    );
                    if (result != null && result.files.single.path != null) {
                      setDialogState(
                          () => evidence = File(result.files.single.path!));
                    }
                  },
                  icon: const Icon(Icons.upload_file_rounded),
                  label: Text(evidence == null
                      ? 'Upload Bukti Transfer'
                      : 'Terpilih: ${evidence!.path.split(RegExp(r"[\\/]")).last}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        evidence == null ? AppTheme.primary : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      final amountRaw = amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
                      final amount = double.tryParse(amountRaw) ?? 0;
                      if (amount <= 0) {
                        AppSnackbar.show('Nominal tidak valid', isError: true);
                        return;
                      }
                      if (evidence == null) {
                        AppSnackbar.show('Bukti transfer wajib diunggah',
                            isError: true);
                        return;
                      }

                      setDialogState(() => isSaving = true);
                      final success = await aProv.submitStandaloneReturn(
                        amount: amount,
                        source: selectedSource ?? '',
                        description: descCtrl.text.trim().isEmpty
                            ? 'Pengembalian Dana Mandiri (Standalone)'
                            : descCtrl.text.trim(),
                        reportYear: DateTime.now().year,
                        evidence: evidence,
                      );

                      if (ctx.mounted) {
                        setDialogState(() => isSaving = false);
                        if (success) {
                          Navigator.pop(ctx);
                          AppSnackbar.show(
                              'Pengembalian dana berhasil dicatat');
                          await auth.retryInitialization();
                          await aProv.loadAdvances();
                          _reloadSettlements();
                          GlobalEventBus.triggerRefresh();
                        } else {
                          AppSnackbar.show(
                              aProv.error ?? 'Gagal mencatat pengembalian',
                              isError: true);
                        }
                      }
                    },
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Simpan'),
            ),
          ],
        );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context) async {
    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();

    // Check outstanding debt before showing dialog
    final outstandingData = await aProv.checkUserOutstanding();
    final double outstanding =
        (outstandingData['outstanding'] ?? 0.0).toDouble();

    if (!context.mounted) return;

    if (outstanding > 0.01) {
      final String formattedDebt = AppFormatters.formatCurrency(outstanding);
      final bool? proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: _cardColor(context),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Perhatian: Outstanding Kasbon',
              style: TextStyle(color: AppTheme.danger)),
          content: Text(
            'Anda masih memiliki saldo kasbon (outstanding) sebesar $formattedDebt.\n\nJika Anda ingin membuat Settlement untuk Kasbon tersebut, mohon buka menu Kasbon, pilih Kasbon Anda, dan klik tombol "Buat Settlement".\n\nKlik "Buat Reimbursement" jika Anda ingin membuat settlement dana pribadi (Standalone).',
            style: TextStyle(color: _primaryTextLocal(context)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
                _showStandaloneReturnDialog(context, outstanding);
              },
              child: const Text('Kembalikan Dana Sekarang',
                  style: TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
              child: const Text('Buat Reimbursement',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (proceed != true) return;
    }

    final titleCtrl = TextEditingController();
    String selectedType = 'single';
    int selectedYear = sProv.reportYear;
    if (selectedYear < 2020 || selectedYear > 2040) {
      selectedYear = DateTime.now().year;
      if (selectedYear < 2020) selectedYear = 2020;
      if (selectedYear > 2040) selectedYear = 2040;
    }
    DateTime? selectedDate = DateTime.now();
    bool creating = false;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: _cardColor(ctx),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Buat Settlement Baru',
            style: TextStyle(color: _titleColorLocal(ctx)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pemilihan Tahun
              DropdownButtonFormField<int>(
                initialValue: selectedYear,
                dropdownColor: _cardColor(ctx),
                decoration: InputDecoration(
                  labelText: 'Tahun Laporan',
                  labelStyle: TextStyle(color: _primaryTextLocal(ctx)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: _primaryTextLocal(ctx).withValues(alpha: 0.3),
                    ),
                  ),
                ),
                style: TextStyle(color: _primaryTextLocal(ctx)),
                items: List.generate(21, (index) => 2020 + index)
                    .map(
                      (year) => DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setDialogState(() => selectedYear = v!),
              ),
              const SizedBox(height: 16),
              // Pilihan Single / Batch
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Single', style: TextStyle(fontSize: 13, color: _primaryTextLocal(ctx))),
                      value: 'single',
                      // ignore: deprecated_member_use
                      groupValue: selectedType,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setDialogState(() => selectedType = v!),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppTheme.primary,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Batch', style: TextStyle(fontSize: 13, color: _primaryTextLocal(ctx))),
                      value: 'batch',
                      // ignore: deprecated_member_use
                      groupValue: selectedType,
                      // ignore: deprecated_member_use
                      onChanged: (v) => setDialogState(() => selectedType = v!),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedType == 'batch') ...[
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul Pengeluaran / Reimbursement',
                  ),
                  style: TextStyle(color: _primaryTextLocal(ctx)),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tanggal Batch (Mandatory)',
                      labelStyle: TextStyle(color: _primaryTextLocal(ctx)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: _primaryTextLocal(ctx).withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      selectedDate == null
                          ? 'Pilih Tanggal'
                          : AppFormatters.formatDateForApi(selectedDate!),
                      style: TextStyle(color: _primaryTextLocal(ctx)),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: creating
                  ? null
                  : () async {
                      final title = selectedType == 'single'
                          ? 'Settlement Mandiri'
                          : titleCtrl.text.trim();
                          
                      if (selectedType == 'batch') {
                        if (title.isEmpty) {
                          AppSnackbar.show('Judul Pengeluaran wajib diisi',
                              isError: true);
                          return;
                        }
                        if (selectedDate == null) {
                          AppSnackbar.show('Tanggal Batch wajib diisi',
                              isError: true);
                          return;
                        }
                      }

                      // Capture Navigator and SettlementProvider early
                      final navigator = Navigator.of(context);
                      final sProv = context.read<SettlementProvider>();

                      setDialogState(() => creating = true);
                      final result = await sProv.createSettlement(
                        title,
                        "",
                        settlementType: selectedType,
                        reportYear: selectedYear,
                        documentDate: selectedDate != null
                            ? AppFormatters.formatDateForApi(selectedDate!)
                            : null,
                      );

                      if (!ctx.mounted) return;

                      if (result != null) {
                        // Tutup dialog
                        Navigator.pop(ctx);

                        // Berpindah ke detail screen (gunakan navigator yang sudah dicapture)
                        navigator.push(
                          MaterialPageRoute(
                            builder: (_) => SettlementDetailScreen(
                              settlementId: result['id'],
                            ),
                          ),
                        );
                      } else {
                        setDialogState(() => creating = false);
                        AppSnackbar.show(
                          sProv.error ?? 'Gagal membuat settlement',
                          isError: true,
                        );
                      }
                    },
              child: creating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Buat'),
            ),
          ],
        ),
      ),
    );
  }

}
