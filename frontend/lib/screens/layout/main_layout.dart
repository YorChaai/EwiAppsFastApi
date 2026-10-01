import 'dart:async';
import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/transactions/revenue_provider.dart';
import 'package:expense_app/providers/master_data/tax_provider.dart';
import 'package:expense_app/providers/transactions/dividend_provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/master_data/bank_status_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/utils/app_dialogs.dart';
import 'package:expense_app/widgets/notification_bell_icon.dart';
import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';
import 'package:expense_app/screens/reports/report_screen.dart';
import 'package:expense_app/screens/advance/advances_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/management/category_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/screens/widgets/sidebar.dart';
import 'package:expense_app/screens/widgets/page_selector.dart';
import 'package:expense_app/utils/app_snackbar.dart';
import 'package:expense_app/providers/core/notification_provider.dart';
import 'package:expense_app/models/notification_model.dart';


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
  final GlobalKey<SettlementListViewState> _settlementListKey = GlobalKey();
  final GlobalKey<AdvancesScreenState> _advancesListKey = GlobalKey();

  Color _surfaceColor(BuildContext context) =>
      context.isDark ? AppTheme.surface : AppTheme.lightSurface;
  Color dividerColor(BuildContext context) =>
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
      if (context.read<AuthProvider>().isManager) setState(() => _navIndex = 2);
      return;
    }
    if (path.contains('/reports')) {
      if (context.read<AuthProvider>().isManager) setState(() => _navIndex = 5);
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
      SettlementListView(key: _settlementListKey),           // 0
      AdvancesScreen(key: _advancesListKey),                 // 1
      if (auth.isManager) const CategoryManagementView(),   // 2
      if (auth.isManager) const BankManagementScreen(),     // 3
      if (auth.isManager) const BankManagementScreen(initialSection: 'advance'), // 4
      if (auth.isManager) ReportScreen(key: _reportPageKey),// 5
      SettingsScreen(key: _settingsPageKey),                 // 6 (manager) or 2 (staff)
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
                      if (i == 5) _reportPageKey = UniqueKey();
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
            if (showSidebar) Container(width: 1, color: dividerColor(context)),
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
