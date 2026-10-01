import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_brand_logo.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/screens/widgets/widget_sidebar_components.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';

class DashboardSidebar extends StatelessWidget {
  final int currentIndex;
  final bool isManager;
  final String fullName;
  final String role;
  final String? profileImageUrl;
  final ValueChanged<int> onNavTap;
  final VoidCallback onLogout;
  final bool isMini;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final int pendingSettlements;
  final int pendingAdvances;
  final ValueChanged<String>? onNotificationTap;

  const DashboardSidebar({
    super.key,
    required this.currentIndex,
    required this.isManager,
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    required this.onNavTap,
    required this.onLogout,
    this.isMini = false,
    this.isExpanded = true,
    this.onToggleExpand,
    this.pendingSettlements = 0,
    this.pendingAdvances = 0,
    this.onNotificationTap,
  });

  bool get _showFull => !isMini && isExpanded;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final panelColor = isDark ? AppTheme.card : AppTheme.lightCard;
    final dividerColor = isDark ? AppTheme.divider : AppTheme.lightDivider;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      width: _showFull ? 240 : 80,
      decoration: BoxDecoration(
        color: panelColor,
        border: Border(right: BorderSide(color: dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ===== toggle button =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: _showFull
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                SquareIconBtn(
                  icon:
                      _showFull ? Icons.menu_open_rounded : Icons.menu_rounded,
                  tooltip:
                      _showFull ? 'Sembunyikan sidebar' : 'Tampilkan sidebar',
                  onTap: onToggleExpand,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ===== brand / logo =====
          _showFull
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppBrandLogo(size: 30, padding: 5),
                        const SizedBox(width: 12),
                        if (_showFull)
                          const Expanded(
                            child: Text(
                              'ExspanApp',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primary, AppTheme.primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: AppBrandLogo(size: 34, padding: 5),
                    ),
                  ),
                ),

          // ===== nav items (scrollable) =====
          Expanded(
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  SidebarNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Settlements',
                    subtitle: 'Daftar pengajuan',
                    selected: currentIndex == 0,
                    onTap: () => onNavTap(0),
                    expanded: _showFull,
                    badge: pendingSettlements,
                  ),
                  SidebarNavItem(
                    icon: Icons.money_rounded,
                    label: 'Kasbon',
                    subtitle: 'Pengajuan uang muka',
                    selected: currentIndex == 1,
                    onTap: () => onNavTap(1),
                    expanded: _showFull,
                    badge: pendingAdvances,
                  ),
                  if (isManager) ...[
                    SidebarNavItem(
                      icon: Icons.category_rounded,
                      label: 'Kategori',
                      subtitle: 'Kelola kategori biaya',
                      selected: currentIndex == 2,
                      onTap: () => onNavTap(2),
                      expanded: _showFull,
                    ),
                    SidebarNavItem(
                      icon: Icons.account_balance_rounded,
                      label: 'BANK',
                      subtitle: 'Kas Riil & Virtual',
                      selected: currentIndex == 3 || currentIndex == 4,
                      onTap: () => onNavTap(3),
                      expanded: _showFull,
                    ),
                    SidebarNavItem(
                      icon: Icons.bar_chart_rounded,
                      label: 'Laporan',
                      subtitle: 'Ringkasan & export',
                      selected: currentIndex == 5,
                      onTap: () => onNavTap(5),
                      expanded: _showFull,
                    ),
                  ],
                  // Settings untuk semua role
                  SidebarNavItem(
                    icon: Icons.settings_rounded,
                    label: 'Pengaturan',
                    subtitle: 'Konfigurasi aplikasi',
                    selected: currentIndex == (isManager ? 6 : 2),
                    onTap: () => onNavTap(isManager ? 6 : 2),
                    expanded: _showFull,
                  ),
                ],
              ),
            ),
          ),

          // ===== user panel =====
          Divider(height: 1, color: dividerColor),
          _showFull
              ? ExpandedUserPanel(
                  fullName: fullName,
                  role: role,
                  profileImageUrl: profileImageUrl,
                  isManager: isManager,
                  onLogout: onLogout,
                  onNotificationTap: onNotificationTap,
                  hasMultipleCompanies: context.select((AuthProvider auth) =>
                      auth.accessibleCompanies.length > 1),
                )
              : MiniUserPanel(
                  fullName: fullName,
                  isManager: isManager,
                  role: role,
                  profileImageUrl: profileImageUrl,
                  onLogout: onLogout,
                  onNotificationTap: onNotificationTap,
                  hasMultipleCompanies: context.select((AuthProvider auth) =>
                      auth.accessibleCompanies.length > 1),
                ),
        ],
      ),
    );
  }
}

// ============================================================
// NAV ITEM
// ============================================================
