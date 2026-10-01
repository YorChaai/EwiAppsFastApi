import 'package:expense_app/utils/event_bus.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/management/logbook_screen.dart';

class BankAdvanceScreen extends StatefulWidget {
  const BankAdvanceScreen({super.key});

  @override
  State<BankAdvanceScreen> createState() => BankAdvanceScreenState();
}

class BankAdvanceScreenState extends State<BankAdvanceScreen> {
  final ApiService api = ApiService();
  bool isLoading = true;
  List<Map<String, dynamic>> users = [];
  Map<int, double> balances = {}; // Saldo Virtual A (Available Budget)
  Map<int, double> outstandings = {}; // Hutang Berjalan (Outstanding)
  Map<int, double> saldoB = {}; // Saldo Virtual B (Total Settled)
  final Map<int, Map<String, double>> bankBreakdowns = {};
  final Map<int, Map<String, double>> hutangBreakdowns = {};
  String searchQuery = '';
  StreamSubscription? refreshSub;
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;
  Color textColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  @override
  void initState() {
    super.initState();
    loadData();
    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) loadData();
    });
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    final auth = context.read<AuthProvider>();
    api.setToken(auth.token);
    api.setCompany(auth.activeCompany.isEmpty ? null : auth.activeCompany);

    try {
      final userRes = await api.getUsers();
      final List<Map<String, dynamic>> loadedUsers =
          List<Map<String, dynamic>>.from(userRes['users'] ?? []);

      // Fetch balances + breakdown in parallel
      final Map<int, double> loadedBalances = {};
      final Map<int, double> loadedOutstandings = {};
      final Map<int, double> loadedSaldoB = {};
      final Map<int, Map<String, double>> loadedBankBreakdowns = {};
      final Map<int, Map<String, double>> loadedHutangBreakdowns = {};

      await Future.wait(loadedUsers.map((u) async {
        final userId = u['id'];
        if (userId != null) {
          try {
            final balanceRes = await api.getActiveAdvanceBalance(userId);
            loadedBalances[userId] =
                (balanceRes['available_budget'] ?? 0.0).toDouble();
            loadedOutstandings[userId] =
                (balanceRes['active_advance_balance'] ?? 0.0).toDouble();
            loadedSaldoB[userId] =
                (balanceRes['total_settled'] ?? balanceRes['saldo_b'] ?? 0.0)
                    .toDouble();
            // Extract bank breakdown from advance balance
            final Map<String, double> bankMap = {};
            final breakdownRaw = balanceRes['breakdown'];
            if (breakdownRaw != null && breakdownRaw is List) {
              for (var item in breakdownRaw) {
                final name = item['bank_name']?.toString() ?? '';
                final bal = (item['balance'] is num)
                    ? (item['balance'] as num).toDouble()
                    : double.tryParse(item['balance']?.toString() ?? '0') ??
                        0.0;
                if (name.isNotEmpty) bankMap[name] = bal;
              }
            }
            loadedBankBreakdowns[userId] = bankMap;
          } catch (e) {
            loadedBalances[userId] = 0.0;
            loadedOutstandings[userId] = 0.0;
            loadedSaldoB[userId] = 0.0;
            loadedBankBreakdowns[userId] = {};
          }
          // Fetch hutang per bank (virtual balances = outstanding per source)
          try {
            final hutangList = await api.getUserVirtualBalances(userId);
            final Map<String, double> hutangMap = {};
            for (var item in hutangList) {
              final name = item['bank_name']?.toString() ?? '';
              final bal = (item['balance'] is num)
                  ? (item['balance'] as num).toDouble()
                  : double.tryParse(item['balance']?.toString() ?? '0') ?? 0.0;
              if (name.isNotEmpty) hutangMap[name] = bal;
            }
            loadedHutangBreakdowns[userId] = hutangMap;
          } catch (_) {
            loadedHutangBreakdowns[userId] = {};
          }
        }
      }));

      if (mounted) {
        setState(() {
          users = loadedUsers;
          balances = loadedBalances;
          outstandings = loadedOutstandings;
          saldoB = loadedSaldoB;
          bankBreakdowns.addAll(loadedBankBreakdowns);
          hutangBreakdowns.addAll(loadedHutangBreakdowns);
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat saldo virtual: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  Future<void> showManageBalanceDialog(Map<String, dynamic> user) async {
    final formKey = GlobalKey<FormState>();
    final notesCtrl =
        TextEditingController(text: 'Penyesuaian Saldo (Virtual)');

    List<Map<String, dynamic>> allocations = [
      {
        'bank_id': null,
        'controller': TextEditingController(),
        'isPositive': true
      }
    ];

    StateSetter? dialogStateSetter;
    bool isFetchingBanks = true;
    List<dynamic> banks = [];

    // Fetch banks — only main 4 banks (BRI, BNI, Mandiri, BCA)
    api.getManagementBanks().then((res) {
      if (mounted) {
        final List<dynamic> fetchedBanks = res['banks'] ?? [];
        fetchedBanks.sort((a, b) {
          int getBankSortIndex(String name) {
            name = name.toLowerCase();

            int groupScore = 0;
            if (name.contains('giro')) {
              groupScore = 200;
            } else if (name.contains('bisnis')) {
              groupScore = 300;
            } else if (name.contains('tabbis') || name.contains('tabis')) {
              groupScore = 400;
            } else if (name.contains('valas')) {
              groupScore = 500;
            } else {
              groupScore = 100; // Polos
            }

            int bankScore = 0;
            if (name.contains('bri')) {
              bankScore = 1;
            } else if (name.contains('bni')) {
              bankScore = 2;
            } else if (name.contains('mandiri')) {
              bankScore = 3;
            } else if (name.contains('bca')) {
              bankScore = 4;
            } else {
              bankScore = 99;
            }

            return groupScore + bankScore;
          }

          int scoreA = getBankSortIndex(a['name'] ?? '');
          int scoreB = getBankSortIndex(b['name'] ?? '');
          return scoreA.compareTo(scoreB);
        });

        banks = fetchedBanks;
        isFetchingBanks = false;
        if (dialogStateSetter != null) dialogStateSetter!(() {});
      }
    }).catchError((_) {
      if (mounted) {
        isFetchingBanks = false;
        if (dialogStateSetter != null) dialogStateSetter!(() {});
      }
    });

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    double getTotalAllocation() {
      double total = 0;
      for (var alloc in allocations) {
        final text = alloc['controller'].text.replaceAll('.', '');
        double amt = (text.isEmpty ? 0 : (double.tryParse(text) ?? 0));
        if (alloc['isPositive'] == false) amt = -amt;
        total += amt;
      }
      return total;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          dialogStateSetter = setDialogState;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: dividerColor(context),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kelola Uang Virtual - ${user['full_name']}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor(context),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Saldo Virtual (Saldo A): ${currencyFormat.format(balances[user['id']] ?? 0.0)}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Outstanding (Hutang Berjalan): ${currencyFormat.format(outstandings[user['id']] ?? 0.0)}',
                    style: const TextStyle(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total Settled (Saldo B): ${currencyFormat.format(saldoB[user['id']] ?? 0.0)}',
                    style: const TextStyle(
                      color: AppTheme.warning,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  Divider(color: dividerColor(context)),
                  const SizedBox(height: 10),
                  const Text(
                    'Inisialisasi / Sesuaikan Saldo Awal Karyawan',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  if (isFetchingBanks)
                    const Center(child: CircularProgressIndicator())
                  else
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...allocations.asMap().entries.map((entry) {
                            int index = entry.key;
                            var alloc = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: dividerColor(context)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sumber Dana ${index + 1}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                      if (allocations.length > 1)
                                        InkWell(
                                          onTap: () {
                                            setDialogState(() {
                                              alloc['controller'].dispose();
                                              allocations.removeAt(index);
                                            });
                                          },
                                          child: const Icon(Icons.close,
                                              color: AppTheme.danger, size: 20),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<int>(
                                    isExpanded: true,
                                    initialValue: alloc['bank_id'],
                                    decoration: InputDecoration(
                                      labelText: 'Pilih Bank Cash ${index + 1}',
                                      isDense: true,
                                    ),
                                    items: banks
                                        .map<DropdownMenuItem<int>>((bank) {
                                      final rb = double.tryParse(
                                              (bank['real_balance'] ?? 0.0)
                                                  .toString()) ??
                                          0.0;
                                      String title = bank['name'] ?? '';
                                      return DropdownMenuItem<int>(
                                        value: bank['id'],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                title,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              'Rp ${currencyFormat.format(rb).replaceAll("Rp ", "")}',
                                              style: const TextStyle(
                                                color: AppTheme.accent,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setDialogState(() {
                                        alloc['bank_id'] = val;
                                      });
                                    },
                                    validator: (val) =>
                                        val == null ? 'Pilih bank' : null,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Semantics(
                                        button: true,
                                        label: 'Ubah Positif Negatif ${index + 1}',
                                        child: InkWell(
                                          onTap: () {
                                            setDialogState(() {
                                              alloc['isPositive'] =
                                                  !(alloc['isPositive'] as bool);
                                            });
                                          },
                                          child: Container(
                                            height: 52,
                                            width: 52,
                                            margin:
                                                const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: (alloc['isPositive'] as bool)
                                                  ? AppTheme.success
                                                      .withValues(alpha: 0.1)
                                                  : AppTheme.danger
                                                      .withValues(alpha: 0.1),
                                              border: Border.all(
                                                color:
                                                    (alloc['isPositive'] as bool)
                                                        ? AppTheme.success
                                                        : AppTheme.danger,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                (alloc['isPositive'] as bool)
                                                    ? Icons.add
                                                    : Icons.remove,
                                                color:
                                                    (alloc['isPositive'] as bool)
                                                        ? AppTheme.success
                                                        : AppTheme.danger,
                                                size: 24,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: alloc['controller'],
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            CurrencyInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Jumlah Penyesuaian ${index + 1}',
                                            hintText: '0',
                                            isDense: true,
                                            prefixText:
                                                (alloc['isPositive'] as bool)
                                                    ? '+ '
                                                    : '- ',
                                            prefixStyle: TextStyle(
                                              color:
                                                  (alloc['isPositive'] as bool)
                                                      ? AppTheme.success
                                                      : AppTheme.danger,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onChanged: (val) =>
                                              setDialogState(() {}),
                                          validator: (v) {
                                            if (v != null && v.isNotEmpty) {
                                              final cleanText = v
                                                  .replaceAll('.', '')
                                                  .replaceAll(',', '.');
                                              if (double.tryParse(cleanText) ==
                                                  null) {
                                                return 'Harus angka valid';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          OutlinedButton.icon(
                            onPressed: () {
                              setDialogState(() {
                                allocations.add({
                                  'bank_id': null,
                                  'controller': TextEditingController(),
                                  'isPositive': true
                                });
                              });
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Tambah Sumber Dana'),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Total Penyesuaian',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      (getTotalAllocation() >= 0 ? '+' : '') +
                                          currencyFormat
                                              .format(getTotalAllocation()),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: getTotalAllocation() >= 0
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: surfaceColor(context),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                          'Saldo Virtual Baru (Prediksi)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary)),
                                      Text(
                                        currencyFormat.format(
                                            (balances[user['id']] ?? 0.0) +
                                                getTotalAllocation()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primary,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: notesCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Catatan / Alasan Penyesuaian',
                            ),
                            validator: (v) =>
                                v!.trim().isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;

                              List<Map<String, dynamic>> allocData =
                                  allocations.map((a) {
                                final text =
                                    a['controller'].text.replaceAll('.', '');
                                double amt = text.isEmpty
                                    ? 0.0
                                    : (double.tryParse(text) ?? 0.0);
                                if (a['isPositive'] == false) amt = -amt;
                                return {
                                  'bank_id': a['bank_id'],
                                  'amount': amt,
                                };
                              }).toList();

                              try {
                                await api.initializeAdvanceBalance(user['id'],
                                    notesCtrl.text.trim(), allocData);
                                await loadData();
                                if (ctx.mounted) {
                                  Navigator.pop(ctx);
                                }
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Saldo virtual berhasil disesuaikan!'),
                                      backgroundColor: AppTheme.success,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Gagal menyesuaikan saldo: $e'),
                                      backgroundColor: AppTheme.danger,
                                    ),
                                  );
                                }
                              }
                            },
                            icon:
                                const Icon(Icons.check_circle_outline_rounded),
                            label: const Text('Simpan Penyesuaian Saldo'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                  Divider(color: dividerColor(context)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LogbookScreen()));
                    },
                    icon: const Icon(Icons.history_rounded),
                    label: const Text('Lihat Riwayat (Logbook)'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor:
                          isDark(context) ? AppTheme.card : AppTheme.lightCard,
                      foregroundColor: isDark(context)
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary,
                      side: BorderSide(
                        color: (isDark(context)
                                ? AppTheme.textSecondary
                                : AppTheme.lightTextSecondary)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((u) {
      final fullName = (u['full_name'] ?? '').toString().toLowerCase();
      final username = (u['username'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();
      return fullName.contains(query) || username.contains(query);
    }).toList();

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: const Text('Bank Advance (Kas Virtual)'),
        backgroundColor: cardColor(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primary))
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    onChanged: (v) => setState(() => searchQuery = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                      hintText: 'Cari karyawan berdasarkan nama...',
                    ),
                  ),
                ),
                Expanded(
                  child: filteredUsers.isEmpty
                      ? const Center(child: Text('Karyawan tidak ditemukan'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final u = filteredUsers[index];
                            final userId = u['id'] as int;
                            final balance = balances[userId] ?? 0.0;
                            final outstanding = outstandings[userId] ?? 0.0;
                            final saldoBValue = saldoB[userId] ?? 0.0;
                            final bankMap = bankBreakdowns[userId] ?? {};
                            final hutangMap = hutangBreakdowns[userId] ?? {};
                            final allBankKeys = <String>{
                              ...bankMap.keys,
                              ...hutangMap.keys
                            }.where((k) {
                              final b = bankMap[k] ?? 0.0;
                              final h = hutangMap[k] ?? 0.0;
                              return b != 0 || h != 0;
                            }).toList();
                            allBankKeys.sort(); // Optional: sort alphabetically
                            final hasData = allBankKeys.isNotEmpty;

                            return GestureDetector(
                              onTap: () => showManageBalanceDialog(u),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: cardColor(context),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: balance > 0
                                        ? AppTheme.primary
                                            .withValues(alpha: 0.3)
                                        : dividerColor(context),
                                    width: balance > 0 ? 1.5 : 1,
                                  ),
                                ),
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Blue vertical bar
                                      Container(
                                        width: 4,
                                        decoration: BoxDecoration(
                                          color: balance > 0
                                              ? AppTheme.primary
                                              : Colors.grey.shade300,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(14),
                                            bottomLeft: Radius.circular(14),
                                          ),
                                        ),
                                      ),
                                      // Avatar
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: balance > 0
                                              ? AppTheme.primary
                                                  .withValues(alpha: 0.15)
                                              : Colors.grey
                                                  .withValues(alpha: 0.15),
                                          child: Text(
                                            (u['full_name'] ?? '?')[0]
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: balance > 0
                                                  ? AppTheme.primary
                                                  : AppTheme.textSecondary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Info block (left)
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Name
                                              Text(
                                                u['full_name'] ?? '-',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor(context),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Role + hutang badges
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.primary
                                                          .withValues(
                                                              alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      (u['role'] ?? '')
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 9,
                                                        color: AppTheme.primary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  // if (outstanding > 0) ...[
                                                  const SizedBox(width: 6),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: outstanding > 0
                                                          ? AppTheme.danger
                                                              .withValues(
                                                                  alpha: 0.1)
                                                          : Colors.grey
                                                              .withValues(
                                                                  alpha: 0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    child: Text(
                                                      'HUTANG: Rp ${NumberFormat.compact(locale: "id_ID").format(outstanding)}',
                                                      style: TextStyle(
                                                        fontSize: 9,
                                                        color: outstanding > 0
                                                            ? AppTheme.danger
                                                            : AppTheme
                                                                .textSecondary,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        letterSpacing: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  // ],
                                                ],
                                              ),
                                              if (hasData) ...[
                                                const SizedBox(height: 8),
                                                // 2-column breakdown per Row to ensure alignment
                                                Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Expanded(
                                                          child: Text(
                                                            'bank',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppTheme
                                                                  .primary,
                                                              letterSpacing:
                                                                  0.4,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        if (hutangMap.values
                                                            .any((v) => v != 0))
                                                          const Expanded(
                                                            child: Text(
                                                              'hutang',
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: AppTheme
                                                                    .danger,
                                                                letterSpacing:
                                                                    0.4,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    ...allBankKeys.map((bank) {
                                                      final bankBal =
                                                          bankMap[bank] ?? 0.0;
                                                      final hutangBal =
                                                          hutangMap[bank] ??
                                                              0.0;
                                                      return Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(bankBal)}',
                                                              style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    textColor(
                                                                        context),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 20),
                                                          if (hutangMap.values
                                                              .any((v) =>
                                                                  v != 0))
                                                            Expanded(
                                                              child: hutangBal !=
                                                                      0
                                                                  ? Text(
                                                                      '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(hutangBal)}',
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: AppTheme
                                                                            .danger,
                                                                      ),
                                                                    )
                                                                  : const SizedBox
                                                                      .shrink(),
                                                            ),
                                                        ],
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Right: green saldo box
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: balance > 0
                                              ? AppTheme.success
                                                  .withValues(alpha: 0.1)
                                              : Colors.grey
                                                  .withValues(alpha: 0.07),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: balance > 0
                                                ? AppTheme.success
                                                    .withValues(alpha: 0.3)
                                                : Colors.grey
                                                    .withValues(alpha: 0.2),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text(
                                              'Saldo Virtual',
                                              style: TextStyle(
                                                fontSize: 9,
                                                color: AppTheme.textSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  currencyFormat
                                                      .format(balance),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppTheme.success,
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                                const Icon(
                                                  Icons.chevron_right_rounded,
                                                  color: AppTheme.textSecondary,
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                            if (saldoBValue > 0) ...[
                                              const SizedBox(height: 4),
                                              Text(
                                                currencyFormat.format(saldoBValue),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.warning,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
