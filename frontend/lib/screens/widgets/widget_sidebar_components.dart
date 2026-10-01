import 'package:expense_app/widgets/notification_bell_icon.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/context_extensions.dart';

class SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final bool expanded;
  final int badge;

  const SidebarNavItem({super.key, 
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    required this.expanded,
    this.badge = 0,
  });

  @override
  State<SidebarNavItem> createState() => SidebarNavItemState();
}

class SidebarNavItemState extends State<SidebarNavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hoverColor = isDark ? AppTheme.cardHover : AppTheme.lightCardHover;
    final textSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final textPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final surfaceColor = isDark ? AppTheme.surface : AppTheme.lightSurface;

    // Responsive sizing untuk HP
    final isCompact = ResponsiveLayout.isCompactPhone(context);
    final iconBoxSize =
        widget.expanded ? (isCompact ? 36.0 : 40.0) : (isCompact ? 42.0 : 48.0);
    final iconSize = isCompact ? 18.0 : (widget.expanded ? 20.0 : 22.0);
    final labelFontSize = isCompact ? 12.5 : 13.5;
    final subtitleFontSize = isCompact ? 10.0 : 11.0;
    final horizontalPadding = isCompact ? 8.0 : 12.0;
    final verticalPadding =
        widget.expanded ? (isCompact ? 9.0 : 11.0) : (isCompact ? 8.0 : 10.0);

    final bgColor = widget.selected
        ? AppTheme.primary.withValues(alpha: 0.14)
        : _hovering
            ? hoverColor
            : hoverColor.withValues(alpha: 0);

    // Use shorter duration for hover exit to feel instant
    final duration = _hovering
        ? const Duration(milliseconds: 150)
        : const Duration(milliseconds: 0);

    final iconColor = widget.selected ? AppTheme.primary : textSecondary;
    final textColor = widget.selected ? textPrimary : textSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 2), // The 'hold' effect gap
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(isCompact ? 10 : 14),
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(
                horizontal: widget.expanded ? horizontalPadding : 0,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(isCompact ? 10 : 14),
                border: Border.all(
                  color: widget.selected
                      ? AppTheme.primary.withValues(alpha: 0.25)
                      : Colors.transparent,
                ),
              ),
              child: widget.expanded
                  ? Row(
                      children: [
                        // icon box
                        Container(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          decoration: BoxDecoration(
                            color: widget.selected
                                ? AppTheme.primary.withValues(alpha: 0.14)
                                : surfaceColor,
                            borderRadius:
                                BorderRadius.circular(isCompact ? 10 : 12),
                          ),
                          child: Icon(widget.icon,
                              color: iconColor, size: iconSize),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: labelFontSize,
                                  fontWeight: widget.selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: subtitleFontSize,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.badge > 0) ...[
                          const SizedBox(width: 6),
                          BadgePill(count: widget.badge, isCompact: isCompact),
                        ],
                      ],
                    )
                  : Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            decoration: BoxDecoration(
                              color: widget.selected
                                  ? AppTheme.primary.withValues(alpha: 0.14)
                                  : Colors.transparent,
                              borderRadius:
                                  BorderRadius.circular(isCompact ? 12 : 14),
                            ),
                            child: Icon(widget.icon,
                                color: iconColor, size: iconSize),
                          ),
                          if (widget.badge > 0)
                            Positioned(top: -2, right: -2, child: BadgeDot()),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// USER PANEL — EXPANDED
// ============================================================
class ExpandedUserPanel extends StatelessWidget {
  final String fullName;
  final String role;
  final String? profileImageUrl;
  final bool isManager;
  final VoidCallback onLogout;
  final ValueChanged<String>? onNotificationTap;
  final bool hasMultipleCompanies;

  const ExpandedUserPanel({super.key, 
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    required this.isManager,
    required this.onLogout,
    this.onNotificationTap,
    this.hasMultipleCompanies = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppTheme.surface : AppTheme.lightSurface;
    final dividerColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final textPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
    final textSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

    return Column(
      children: [
        // Notification Bell
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: NotificationBellIcon(onNotificationTap: onNotificationTap),
        ),
        Divider(height: 1, thickness: 1, color: dividerColor),
        // User Profile
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: dividerColor),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.primary.withValues(alpha: 0.18),
                  backgroundImage: profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
                  child: profileImageUrl == null
                      ? Text(
                          fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.accent,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasMultipleCompanies)
                    IconButton(
                      icon: Icon(
                        Icons.dashboard_rounded,
                        size: 18,
                        color: textSecondary,
                      ),
                      onPressed: () =>
                          context.read<AuthProvider>().clearActiveCompany(),
                      tooltip: 'Pilih Perusahaan Lain',
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 36),
                      padding: EdgeInsets.zero,
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout_rounded,
                      size: 18,
                      color: AppTheme.danger,
                    ),
                    onPressed: onLogout,
                    tooltip: 'Logout',
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// USER PANEL — MINI
// ============================================================
class MiniUserPanel extends StatelessWidget {
  final String fullName;
  final String role;
  final String? profileImageUrl;
  final bool isManager;
  final VoidCallback onLogout;
  final ValueChanged<String>? onNotificationTap;
  final bool hasMultipleCompanies;

  const MiniUserPanel({super.key, 
    required this.fullName,
    required this.role,
    this.profileImageUrl,
    required this.isManager,
    required this.onLogout,
    this.onNotificationTap,
    this.hasMultipleCompanies = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
      child: Column(
        children: [
          NotificationBellIcon(onNotificationTap: onNotificationTap),
          const SizedBox(height: 8),
          Tooltip(
            message: fullName,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.18),
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? Text(
                        fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (hasMultipleCompanies) ...[
            Tooltip(
              message: 'Pilih Perusahaan',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      context.read<AuthProvider>().clearActiveCompany(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white10
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.dashboard_rounded,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black87,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Tooltip(
            message: 'Logout',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.danger,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// BADGE
// ============================================================
class BadgePill extends StatelessWidget {
  final int count;
  final bool isCompact;

  const BadgePill({super.key, required this.count, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final paddingHorizontal = isCompact ? 5.0 : 7.0;
    final paddingVertical = isCompact ? 2.0 : 3.0;
    final fontSize = isCompact ? 9.0 : 10.0;
    final borderRadius = isCompact ? 8.0 : 10.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class BadgeDot extends StatelessWidget {
  const BadgeDot({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final panelColor = isDark ? AppTheme.card : AppTheme.lightCard;
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        border: Border.all(color: panelColor, width: 1.5),
      ),
    );
  }
}

// ============================================================
// SQUARE ICON BUTTON (toggle)
// ============================================================
class SquareIconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  const SquareIconBtn({super.key, 
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final surfaceColor = isDark ? AppTheme.surface : AppTheme.lightSurface;
    final dividerColor = isDark ? AppTheme.divider : AppTheme.lightDivider;
    final textColor = isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

    // Responsive button size untuk HP
    final isCompact = ResponsiveLayout.isCompactPhone(context);
    final btnSize = isCompact ? 36.0 : 42.0;
    final iconSize = isCompact ? 18.0 : 20.0;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: btnSize,
            height: btnSize,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: dividerColor),
            ),
            child: Icon(icon, color: textColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}

class SidebarParentNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool expanded;
  final List<Widget> children;

  const SidebarParentNavItem({super.key, 
    required this.icon,
    required this.label,
    required this.expanded,
    required this.children,
  });

  @override
  State<SidebarParentNavItem> createState() => SidebarParentNavItemState();
}

class SidebarParentNavItemState extends State<SidebarParentNavItem> {
  bool _isExpanded = false;
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hoverColor = isDark ? AppTheme.cardHover : AppTheme.lightCardHover;
    final textSecondary =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final textPrimary =
        isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

    if (!widget.expanded) {
      return Column(
        children: widget.children,
      );
    }

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovering = true),
          onExit: (_) => setState(() => _hovering = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: _hovering ? hoverColor : hoverColor.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              dense: true,
              leading: Icon(widget.icon, color: textSecondary, size: 20),
              title: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
              trailing: Icon(
                _isExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: textSecondary,
                size: 18,
              ),
              onTap: () => setState(() => _isExpanded = !_isExpanded),
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Column(children: widget.children),
          ),
      ],
    );
  }
}
