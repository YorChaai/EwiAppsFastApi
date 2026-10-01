import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/layout/main_layout.dart';
import 'package:expense_app/screens/manager/manager_settlement_detail_screen.dart';
import 'package:expense_app/models/advance_model.dart';
import 'package:expense_app/models/enums.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen>
    with SingleTickerProviderStateMixin {
  static const Set<String> _pendingAdvanceStatuses = {
    'submitted',
    'revision_submitted',
  };

  late TabController _tabController;

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
  Color _dividerColor(BuildContext context) =>
      _isDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettlementProvider>().loadSettlements(status: 'submitted');
      context.read<AdvanceProvider>().loadAdvances();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfaceColor(context),
      appBar: AppBar(
        title: const Text('Panel Manager'),
        backgroundColor: _cardColor(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Unduh Laporan Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur unduh laporan akan segera hadir'),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Persetujuan Settlement'),
            Tab(text: 'Persetujuan Kasbon'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSettlementsForApproval(), _buildAdvancesForApproval()],
      ),
    );
  }

  Widget _buildSettlementsForApproval() {
    return Consumer<SettlementProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                ElevatedButton(
                  onPressed: () =>
                      provider.loadSettlements(status: 'submitted'),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final settlements = provider.settlements
            .where((s) => s['status'] == 'submitted')
            .toList();
        if (settlements.isEmpty) {
          return const Center(
            child: Text('Tidak ada settlement yang butuh persetujuan.'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadSettlements(status: 'submitted'),
          child: ListView.builder(
            itemExtent: 72.0,
            scrollCacheExtent: const ScrollCacheExtent.pixels(288),
            itemCount: settlements.length,
            itemBuilder: (context, index) {
              final s = settlements[index];
              return ListTile(
                title: Text(s['title'],
                    style: TextStyle(color: _textColor(context))),
                subtitle: Text(
                  'Oleh: ${s['creator_name']} - Total: ${s['total_amount']}',
                  style: TextStyle(color: _secondaryTextColor(context)),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ManagerSettlementDetailScreen(settlementId: s['id']),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAdvancesForApproval() {
    return Consumer<AdvanceProvider>(
      builder: (context, provider, _) {
        if (provider.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                ElevatedButton(
                  onPressed: () => provider.loadAdvances(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final advances = provider.advances
            .where(
              (a) => _pendingAdvanceStatuses.contains(
                a.status.apiValue.toLowerCase(),
              ),
            )
            .toList();
        if (advances.isEmpty) {
          return const Center(
            child: Text('Tidak ada kasbon yang menunggu persetujuan.'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadAdvances(),
          child: ListView.builder(
            itemExtent: 72.0,
            scrollCacheExtent: const ScrollCacheExtent.pixels(288),
            itemCount: advances.length,
            itemBuilder: (context, index) {
              final a = advances[index];
              final status = a.status.apiValue.toLowerCase();
              final isRevision = status == 'revision_submitted';
              return ListTile(
                title:
                    Text(a.title, style: TextStyle(color: _textColor(context))),
                subtitle: Text(
                  'Oleh: ${a.requesterName} - Jumlah: ${a.totalAmount}'
                  '${isRevision ? ' - Revisi' : ''}',
                  style: TextStyle(color: _secondaryTextColor(context)),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showAdvanceApprovalDialog(a, provider),
              );
            },
          ),
        );
      },
    );
  }

  void _showAdvanceApprovalDialog(
    AdvanceModel advance,
    AdvanceProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardColor(context),
        title: Text("Proses Permintaan",
            style: TextStyle(color: _textColor(context))),
        content: Text(
          "Proses ${(advance.status.apiValue.toLowerCase() == 'revision_submitted') ? 'revisi kasbon' : 'permintaan kasbon'} untuk '${advance.title}'?",
          style: TextStyle(color: _textColor(context)),
        ),
        actions: [
          TextButton(
            child: const Text("Tolak"),
            onPressed: () async {
              final controller = TextEditingController();
              try {
                final notes = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: _cardColor(context),
                    title: Text('Alasan Penolakan',
                        style: TextStyle(color: _textColor(context))),
                    content: TextField(
                      controller: controller,
                      style: TextStyle(color: _textColor(context)),
                      decoration: const InputDecoration(hintText: 'Alasan...'),
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, controller.text),
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                );
                if (notes != null && context.mounted) {
                  await provider.rejectAdvance(advance.id, notes);
                  if (context.mounted) Navigator.of(context).pop();
                }
              } finally {
                controller.dispose();
              }
            },
          ),
          TextButton(
            child: const Text("Setujui"),
            onPressed: () async {
              Navigator.of(context).pop(); // close confirm dialog first
              try {
                await provider.approveAdvance(advance.id);
              } on InsufficientAdvanceBalanceException catch (ex) {
                if (mounted) _showInsufficientBalanceDialog(ex);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showInsufficientBalanceDialog(InsufficientAdvanceBalanceException ex) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _cardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Saldo Advance Tidak Mencukupi',
                style: TextStyle(
                  color: _textColor(ctx),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Advance ${ex.userName} tidak mencukupi untuk menyetujui kasbon ini.',
              style: TextStyle(color: _secondaryTextColor(ctx), fontSize: 13),
            ),
            const SizedBox(height: 16),
            _balanceRow(
                ctx, 'Dibutuhkan', fmt.format(ex.needed), _textColor(ctx)),
            _balanceRow(
                ctx, 'Tersedia', fmt.format(ex.available), AppTheme.primary),
            Divider(color: _dividerColor(ctx), height: 20),
            _balanceRow(
                ctx, 'Kekurangan', fmt.format(ex.shortfall), Colors.orange,
                bold: true),
            if (ex.cashComposition != null &&
                ex.cashComposition!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Saldo tersedia di bank:',
                style: TextStyle(
                  color: _secondaryTextColor(ctx),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _surfaceColor(ctx),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _dividerColor(ctx)),
                ),
                child: Column(
                  children: ex.cashComposition!.entries.map((e) {
                    final amt = (e.value as num).toDouble();
                    if (amt <= 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key,
                              style: TextStyle(
                                  color: _textColor(ctx), fontSize: 13)),
                          Text(
                            fmt.format(amt),
                            style: TextStyle(
                              color: _textColor(ctx),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                '💡 Pergi ke Bank Advance untuk melakukan top-up saldo, lalu kembali ke detail kasbon dan setujui kembali.',
                style: TextStyle(color: _secondaryTextColor(ctx), fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal',
                style: TextStyle(color: _secondaryTextColor(ctx))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.popUntil(context, (route) => route.isFirst);
              globalSwitchTab?.call(4);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.account_balance_rounded, size: 18),
            label: const Text('Ke Bank Advance'),
          ),
        ],
      ),
    );
  }

  Widget _balanceRow(
      BuildContext context, String label, String value, Color valueColor,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  TextStyle(color: _secondaryTextColor(context), fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
