import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/widgets/user_detail_dialog.dart';

import 'package:expense_app/widgets/manage_companies_dialog.dart';
import 'package:expense_app/widgets/dialog_create_user.dart';
import 'package:expense_app/widgets/dialog_edit_user.dart';

class AccountListDialog extends StatefulWidget {
  const AccountListDialog({super.key});

  @override
  State<AccountListDialog> createState() => _AccountListDialogState();
}

class _AccountListDialogState extends State<AccountListDialog> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color _cardColor(BuildContext context) =>
      _isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color _surfaceColor(BuildContext context) =>
      _isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color _textColor(BuildContext context) =>
      _isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
  Color _secondaryTextColor(BuildContext context) =>
      _isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color _creamColor(BuildContext context) =>
      _isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color _dividerColor(BuildContext context) =>
      _isDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final users = await auth.getUsers();
      if (mounted) setState(() => _users = users);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCreateUserDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const CreateUserDialog(),
    );
    if (result == true) _loadUsers();
  }

  void _showEditUserByManager(Map<String, dynamic> user) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => EditUserByManagerDialog(user: user),
    );
    if (result == true) _loadUsers();
  }

  void _showManageCompaniesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const ManageCompaniesDialog(),
    );
    if (result == true) {
      _loadUsers(); // Refresh users in case their company access was updated
    }
  }

  bool _canEdit(BuildContext context, Map<String, dynamic> targetUser) {
    final auth = context.read<AuthProvider>();
    final currentUserRole = auth.user?['role'] ?? 'staff';
    final targetRole = targetUser['role'] ?? 'staff';

    if (currentUserRole == 'super_manager') {
      if (targetRole == 'super_manager' &&
          targetUser['id'] != auth.user?['id']) {
        return false;
      }
      return true;
    }
    if (currentUserRole == 'manager') {
      if (targetRole == 'super_manager' || targetRole == 'manager') {
        if (targetUser['id'] != auth.user?['id']) return false;
      }
      return true;
    }
    return false;
  }

  void _showUserDetail(Map<String, dynamic> user) {
    showDialog(
        context: context, builder: (ctx) => UserDetailDialog(user: user));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? 1100 : double.infinity,
        height: isDesktop ? 750 : double.infinity,
        margin: EdgeInsets.all(isDesktop ? 24 : 16),
        decoration: BoxDecoration(
            color: _cardColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _dividerColor(context))),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _users.isEmpty
                      ? Center(
                          child: Text('Belum ada user',
                              style: TextStyle(
                                  color: _secondaryTextColor(context))))
                      : isDesktop
                          ? _buildDesktopTable()
                          : _buildMobileListWithRefresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (!isMobile) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.people_outline_rounded,
                  color: AppTheme.primary, size: 24),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Account List',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: _creamColor(context),
                  ),
                ),
                Text(
                  '${_users.length} user',
                  style: TextStyle(
                      fontSize: 11, color: _secondaryTextColor(context)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            color: _secondaryTextColor(context),
            onPressed: _loadUsers,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
          const SizedBox(width: 4),
          if (isMobile)
            IconButton(
              onPressed: _showCreateUserDialog,
              icon: const Icon(Icons.add_box_rounded,
                  color: AppTheme.primary, size: 28),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            ElevatedButton.icon(
              onPressed: _showCreateUserDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah Akun'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          const SizedBox(width: 4),
          if (!isMobile)
            ElevatedButton.icon(
              onPressed: _showManageCompaniesDialog,
              icon: const Icon(Icons.business_rounded, size: 18),
              label: const Text('Kelola Perusahaan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.close,
                color: _secondaryTextColor(context), size: 20),
            onPressed: () => Navigator.pop(context),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: _dividerColor(context))),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                  AppTheme.primary.withValues(alpha: 0.1)),
              columns: const [
                DataColumn(
                    label: Text('User',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('No HP',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Kantor',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Role',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Last Login',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Status',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Aksi',
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: _users.map((user) {
                return DataRow(cells: [
                  DataCell(Row(children: [
                    GestureDetector(
                        onTap: () => _showUserDetail(user),
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: CircleAvatar(
                                radius: 16,
                                backgroundColor: AppTheme.primary,
                                child: Text(
                                    ((user['full_name'] as String?)
                                                    ?.isNotEmpty ==
                                                true
                                            ? user['full_name'][0]
                                            : 'U')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12))))),
                    const SizedBox(width: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(user['full_name'] ?? '-',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _creamColor(context))),
                          Text('@${user['username']}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: _secondaryTextColor(context))),
                        ]),
                  ])),
                  DataCell(Text(user['phone_number'] ?? '-',
                      style: TextStyle(color: _textColor(context)))),
                  DataCell(Text(user['workplace'] ?? '-',
                      style: TextStyle(color: _textColor(context)))),
                  DataCell(_buildRoleBadge(user['role'] ?? 'staff')),
                  DataCell(Text(user['last_login_formatted'] ?? '-',
                      style:
                          TextStyle(color: _textColor(context), fontSize: 12))),
                  DataCell(_buildStatusIndicator(user['is_online'] ?? false)),
                  DataCell(_canEdit(context, user)
                      ? IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              size: 18, color: AppTheme.primary),
                          onPressed: () => _showEditUserByManager(user))
                      : const SizedBox.shrink()),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileListWithRefresh() => RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _users.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final user = _users[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: _surfaceColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _dividerColor(context))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                GestureDetector(
                    onTap: () => _showUserDetail(user),
                    child: CircleAvatar(
                        backgroundColor: AppTheme.primary,
                        child: Text(
                            ((user['full_name'] as String?)?.isNotEmpty == true
                                    ? user['full_name'][0]
                                    : 'U')
                                .toUpperCase(),
                            style: const TextStyle(color: Colors.white)))),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(user['full_name'] ?? '-',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: _creamColor(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text('@${user['username']}',
                          style: TextStyle(
                              fontSize: 12,
                              color: _secondaryTextColor(context)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ])),
                const SizedBox(width: 4),
                _buildStatusIndicator(user['is_online'] ?? false),
                if (_canEdit(context, user))
                  IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          size: 18, color: AppTheme.primary),
                      onPressed: () => _showEditUserByManager(user)),
              ]),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                _InfoChip(
                    icon: Icons.badge_outlined,
                    label: 'Role',
                    value: _getRoleName(user['role'] ?? 'staff')),
                _InfoChip(
                    icon: Icons.phone_outlined,
                    label: 'No HP',
                    value: user['phone_number'] ?? '-'),
                _InfoChip(
                    icon: Icons.work_outline,
                    label: 'Kantor',
                    value: user['workplace'] ?? '-'),
              ]),
            ]),
          );
        },
      ));

  Widget _buildRoleBadge(String role) {
    Color color = role == 'super_manager'
        ? Colors.deepPurple
        : (role == 'manager'
            ? AppTheme.primary
            : (role == 'staff' ? AppTheme.success : AppTheme.warning));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Text(_getRoleName(role),
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatusIndicator(bool isOnline, {bool showLabel = false}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
              color: isOnline ? AppTheme.success : AppTheme.textSecondary,
              shape: BoxShape.circle)),
      if (showLabel) ...[
        const SizedBox(width: 4),
        Text(isOnline ? 'Online' : 'Offline',
            style: TextStyle(
                fontSize: 11,
                color: isOnline ? AppTheme.success : AppTheme.textSecondary))
      ],
    ]);
  }

  String _getRoleName(String role) {
    if (role == 'super_manager') return 'Super Manager';
    if (role == 'manager') return 'Manager';
    if (role == 'mitra_eks') return 'Mitra';
    return 'Staff';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoChip(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isDark ? AppTheme.card : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isDark ? AppTheme.divider : AppTheme.lightDivider)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 12, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style:
                  const TextStyle(fontSize: 10, color: AppTheme.textSecondary))
        ]),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
