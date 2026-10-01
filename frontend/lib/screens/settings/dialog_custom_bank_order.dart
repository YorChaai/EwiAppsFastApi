import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/services/bank_order_preferences.dart';
import 'package:expense_app/utils/event_bus.dart';

class DialogCustomBankOrder extends StatefulWidget {
  const DialogCustomBankOrder({super.key});

  @override
  State<DialogCustomBankOrder> createState() => _DialogCustomBankOrderState();
}

class _DialogCustomBankOrderState extends State<DialogCustomBankOrder>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;
  bool _saving = false;

  // Bank Cash List
  List<Map<String, dynamic>> _bankCashList = [];

  // Bank Advance List
  List<Map<String, dynamic>> _bankAdvanceList = [];
  final Map<int, double> _advanceBalances = {};

  final _numberFmt = NumberFormat('#,##0', 'id_ID');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      if (mounted) _loadData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => _loading = true);
    try {
      final bankProv = context.read<BankManagementProvider>();
      final auth = context.read<AuthProvider>();
      await bankProv.loadBanks();
      final allBanks = List<Map<String, dynamic>>.from(
          bankProv.banks.map((e) => Map<String, dynamic>.from(e)));

      // Load custom order for Bank Cash
      final savedCashOrder = await BankOrderPreferences.getBankCashOrder();
      if (savedCashOrder.isNotEmpty) {
        final Map<int, int> orderMap = {
          for (int i = 0; i < savedCashOrder.length; i++) savedCashOrder[i]: i
        };
        allBanks.sort((a, b) {
          final idxA = orderMap[a['id'] as int?] ?? 99999;
          final idxB = orderMap[b['id'] as int?] ?? 99999;
          return idxA.compareTo(idxB);
        });
      } else {
        allBanks.sort((a, b) => _getTemplateSortIndex(a['name'] ?? '', a['id'] as int? ?? 0)
            .compareTo(_getTemplateSortIndex(b['name'] ?? '', b['id'] as int? ?? 0)));
      }
      _bankCashList = allBanks;

      // Load Bank Advance Users
      final advanceApi = ApiService();
      advanceApi.setToken(auth.token);
      advanceApi.setCompany(
          auth.activeCompany.isEmpty ? null : auth.activeCompany);

      final userRes = await advanceApi.getUsers();
      final loadedUsers = List<Map<String, dynamic>>.from(
          (userRes['users'] ?? []).map((e) => Map<String, dynamic>.from(e)));

      try {
        final allBalancesRes = await advanceApi.getAllActiveAdvanceBalances();
        final balancesMap =
            allBalancesRes['balances'] as Map<String, dynamic>? ?? {};
        for (var u in loadedUsers) {
          final userId = u['id'] as int?;
          if (userId != null) {
            final userBalData =
                balancesMap[userId.toString()] as Map<String, dynamic>?;
            if (userBalData != null) {
              _advanceBalances[userId] =
                  (userBalData['available_budget'] ?? 0.0).toDouble();
            }
          }
        }
      } catch (_) {}

      // Load custom order for Bank Advance
      final savedAdvanceOrder =
          await BankOrderPreferences.getBankAdvanceOrder();
      if (savedAdvanceOrder.isNotEmpty) {
        final Map<int, int> orderMap = {
          for (int i = 0; i < savedAdvanceOrder.length; i++)
            savedAdvanceOrder[i]: i
        };
        loadedUsers.sort((a, b) {
          final idxA = orderMap[a['id'] as int?] ?? 99999;
          final idxB = orderMap[b['id'] as int?] ?? 99999;
          return idxA.compareTo(idxB);
        });
      }
      _bankAdvanceList = loadedUsers;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data urutan: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveOrder() async {
    setState(() => _saving = true);
    try {
      final cashIds = _bankCashList
          .map((e) => e['id'] as int?)
          .whereType<int>()
          .toList();
      final advanceIds = _bankAdvanceList
          .map((e) => e['id'] as int?)
          .whereType<int>()
          .toList();

      await BankOrderPreferences.saveBankCashOrder(cashIds);
      await BankOrderPreferences.saveBankAdvanceOrder(advanceIds);

      // Trigger global refresh
      GlobalEventBus.triggerRefresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Urutan Bank & Advance berhasil disimpan!'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan urutan: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _resetOrder() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Urutan ke Default?'),
        content: const Text(
            'Urutan tampilan akan dikembalikan sesuai urutan template standar aplikasi.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset Default'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _saving = true);
    try {
      await BankOrderPreferences.resetBankCashOrder();
      await BankOrderPreferences.resetBankAdvanceOrder();
      GlobalEventBus.triggerRefresh();
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Urutan berhasil direset ke template bawaan.'),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mereset urutan: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final isDark = _isDark(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
      child: Container(
        width: 750,
        height: 680,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.swap_vert_circle_rounded,
                      color: AppTheme.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atur Urutan Tampilan Bank & Advance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppTheme.textPrimary
                              : AppTheme.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tekan dan geser (drag & drop) kartu untuk mengatur posisi atas/bawah.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surface : AppTheme.lightSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? AppTheme.textSecondary
                    : AppTheme.lightTextSecondary,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.account_balance_rounded, size: 18),
                    text: 'Urutan Bank Cash (Kas Riil)',
                  ),
                  Tab(
                    icon: Icon(Icons.person_pin_rounded, size: 18),
                    text: 'Urutan Bank Advance (Staf)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tab Views with ReorderableListView
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppTheme.primary))
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildCashReorderList(isDark),
                        _buildAdvanceReorderList(isDark),
                      ],
                    ),
            ),
            const SizedBox(height: 16),

            // Footer Actions
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _saving ? null : _resetOrder,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Reset ke Template Bawaan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.danger,
                    side: BorderSide(
                        color: AppTheme.danger.withValues(alpha: 0.5)),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _saving ? null : _saveOrder,
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.check_rounded, size: 18),
                  label: Text(_saving ? 'Menyimpan...' : 'Simpan Urutan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCashReorderList(bool isDark) {
    if (_bankCashList.isEmpty) {
      return const Center(child: Text('Tidak ada rekening bank ditemukan.'));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _bankCashList.length,
        onReorderItem: (oldIndex, newIndex) {
          setState(() {
            final item = _bankCashList.removeAt(oldIndex);
            _bankCashList.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final bank = _bankCashList[index];
          final name = bank['name'] ?? '-';
          final accNum = bank['account_number'] ?? 'Cash (Fisik)';
          final curr = bank['currency'] ?? 'IDR';
          final realBal =
              double.tryParse((bank['real_balance'] ?? 0.0).toString()) ?? 0.0;

          return Container(
            key: ValueKey(bank['id']),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      (name.isNotEmpty ? name[0] : '?').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.textPrimary
                      : AppTheme.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                '[$curr] No: $accNum • Saldo: ${curr == 'USD' ? '\$' : 'Rp'}${_numberFmt.format(realBal)}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
              trailing: const Icon(
                Icons.drag_handle_rounded,
                color: AppTheme.primary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdvanceReorderList(bool isDark) {
    if (_bankAdvanceList.isEmpty) {
      return const Center(child: Text('Tidak ada staf/user ditemukan.'));
    }

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      child: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _bankAdvanceList.length,
        onReorderItem: (oldIndex, newIndex) {
          setState(() {
            final item = _bankAdvanceList.removeAt(oldIndex);
            _bankAdvanceList.insert(newIndex, item);
          });
        },
        itemBuilder: (context, index) {
          final user = _bankAdvanceList[index];
          final userId = user['id'] as int?;
          final fullName = user['full_name'] ?? user['username'] ?? '-';
          final role = user['role'] ?? 'staff';
          final balance =
              userId != null ? (_advanceBalances[userId] ?? 0.0) : 0.0;

          return Container(
            key: ValueKey(user['id']),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surface : AppTheme.lightSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppTheme.divider : AppTheme.lightDivider,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppTheme.accent.withValues(alpha: 0.2),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.accent.withValues(alpha: 0.1),
                    child: Text(
                      (fullName.isNotEmpty ? fullName[0] : '?').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                fullName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark
                      ? AppTheme.textPrimary
                      : AppTheme.lightTextPrimary,
                ),
              ),
              subtitle: Text(
                'Role: ${role.toUpperCase()} • Kas Virtual: Rp${_numberFmt.format(balance)}',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppTheme.textSecondary
                      : AppTheme.lightTextSecondary,
                ),
              ),
              trailing: const Icon(
                Icons.drag_handle_rounded,
                color: AppTheme.accent,
              ),
            ),
          );
        },
      ),
    );
  }

  int _getTemplateSortIndex(String name, [int id = 0]) {
    return BankOrderPreferences.getTemplateSortIndex(name, id);
  }
}
