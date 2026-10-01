import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_status_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';

class BankStatusScreen extends StatefulWidget {
  final int? initialYear;

  const BankStatusScreen({super.key, this.initialYear});

  @override
  State<BankStatusScreen> createState() => BankStatusScreenState();
}

class BankStatusScreenState extends State<BankStatusScreen> {
  late int selectedYear;
  int? selectedBankId;
  String filterMode = 'report';
  DateTime? startDate;
  DateTime? endDate;
  final dateFmt = DateFormat('yyyy-MM-dd');
  final displayFmt = DateFormat('dd-MMM-yy');
  final numberFmt = NumberFormat('#,##0', 'id_ID');

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color secondaryTextColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color creamColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear ?? DateTime.now().year;
    Future.microtask(() {
      if (!mounted) return;
      context
          .read<BankStatusProvider>()
          .loadBanks(); // Load ALL 20 banks for Bank Status
      loadData();
    });
  }

  Future<void> loadData() async {
    final prov = context.read<BankStatusProvider>();
    // If currently selected bank not in all banks list, reset
    if (selectedBankId != null && prov.banks.isNotEmpty) {
      final ids = prov.banks.map((b) => b['id'] as int?).toSet();
      if (!ids.contains(selectedBankId)) {
        setState(() => selectedBankId = null);
      }
    }
    await prov.loadTransactions(
      year: selectedYear,
      bankId: selectedBankId,
      mode: filterMode,
      startDate: startDate != null
          ? DateFormat('yyyy-MM-dd').format(startDate!)
          : null,
      endDate:
          endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null,
    );
  }

  String displayDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(text);
      if (dt == null) return text;
      return displayFmt.format(dt);
    } catch (_) {
      return text;
    }
  }

  int getBankSortIndex(String name) {
    name = name.toLowerCase();
    if (name == 'cash') {
      return 1000;
    }

    int groupScore = 0;
    if (name.contains('giro')) {
      groupScore = 200;
    } else if (name.contains('bisnis')) {
      groupScore = 300;
    } else if (name.contains('tabbis')) {
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
      bankScore = 5;
    }

    return groupScore + bankScore;
  }

  Future<void> showTransactionDialog([Map<String, dynamic>? data]) async {
    final prov = context.read<BankStatusProvider>();
    if (prov.banks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Belum ada data bank. Silakan buat bank terlebih dahulu.')),
      );
      return;
    }

    // --- CLEANUP & SORT BANKS ---
    final Map<String, Map<String, dynamic>> uniqueBanksMap = {};
    for (final b in prov.banks) {
      final name = b['name'].toString();
      // Skip unwanted
      if (name.toUpperCase().contains('BCA EWI (IDR)')) continue;

      // Deduplicate by name (ignore case/extra spaces)
      final key = name.trim().toLowerCase();
      if (!uniqueBanksMap.containsKey(key)) {
        uniqueBanksMap[key] = b;
      }
    }

    final sortedBanks = uniqueBanksMap.values.toList();
    sortedBanks.sort((a, b) =>
        getBankSortIndex(a['name']).compareTo(getBankSortIndex(b['name'])));

    final formKey = GlobalKey<FormState>();
    final dateCtrl = TextEditingController(
        text: data != null && data['date'] != null
            ? data['date'].toString().substring(0, 10)
            : dateFmt.format(DateTime.now()));
    final descCtrl = TextEditingController(text: data?['description'] ?? '');
    final amountIdrCtrl =
        TextEditingController(text: data?['amount_idr']?.toString() ?? '');
    final amountUsdCtrl =
        TextEditingController(text: data?['amount_usd']?.toString() ?? '');
    int? bankId = data?['bank_id'] ??
        (sortedBanks.isNotEmpty ? sortedBanks.first['id'] : null);
    int? toBankId = data?['to_bank_id'];
    String transType = data?['transaction_type'] ?? 'income';

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: cardColor(ctx),
          title: Text(
              data == null ? 'Tambah Transaksi Bank' : 'Edit Transaksi Bank',
              style: TextStyle(color: creamColor(ctx))),
          content: SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: transType,
                      items: const [
                        DropdownMenuItem(
                            value: 'income', child: Text('Income / Masuk')),
                        DropdownMenuItem(
                            value: 'expense', child: Text('Expense / Keluar')),
                        DropdownMenuItem(
                            value: 'transfer',
                            child: Text('Transfer (Pemindahbukuan)')),
                      ],
                      onChanged: (v) => setState(() => transType = v!),
                      decoration:
                          const InputDecoration(labelText: 'Jenis Transaksi'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: bankId,
                      items: sortedBanks.map<DropdownMenuItem<int>>((b) {
                        return DropdownMenuItem<int>(
                          value: b['id'],
                          child: Text(b['name']),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => bankId = v),
                      decoration: InputDecoration(
                        labelText: transType == 'transfer'
                            ? 'Pilih Bank Asal'
                            : 'Sumber Bank',
                      ),
                      validator: (v) => v == null ? 'Wajib pilih bank' : null,
                    ),
                    if (transType == 'transfer') ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: toBankId,
                        items: sortedBanks.map<DropdownMenuItem<int>>((b) {
                          return DropdownMenuItem<int>(
                            value: b['id'],
                            child: Text(b['name']),
                          );
                        }).toList(),
                        onChanged: (v) => setState(() => toBankId = v),
                        decoration: const InputDecoration(
                            labelText: 'Pilih Bank Tujuan'),
                        validator: (v) =>
                            v == null ? 'Wajib pilih bank tujuan' : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: dateCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Tanggal',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              dateCtrl.text = dateFmt.format(picked);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountIdrCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Nominal IDR'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: amountUsdCtrl,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Nominal USD'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                String? finalGroupName;
                final bank = sortedBanks.firstWhere((b) => b['id'] == bankId);
                final bankName = bank['name'];

                if (transType == 'income') {
                  finalGroupName = 'Bank Interest ($bankName)';
                } else if (transType == 'expense') {
                  finalGroupName = 'Bank Interest Expense ($bankName)';
                } else if (transType == 'transfer' && toBankId != null) {
                  final toBank =
                      sortedBanks.firstWhere((b) => b['id'] == toBankId);
                  final toBankName = toBank['name'];
                  finalGroupName =
                      'Pemindahbukuan dari $bankName ke $toBankName';
                }

                final payload = {
                  'bank_id': bankId,
                  'to_bank_id': toBankId,
                  'date': dateCtrl.text,
                  'description': descCtrl.text,
                  'amount_idr': double.tryParse(amountIdrCtrl.text) ?? 0.0,
                  'amount_usd': double.tryParse(amountUsdCtrl.text) ?? 0.0,
                  'transaction_type': transType,
                  'group_name': finalGroupName,
                  'report_year': selectedYear,
                };
                try {
                  if (data == null) {
                    await prov.createTransaction(
                      payload,
                      year: selectedYear,
                      bankId: selectedBankId,
                      mode: filterMode,
                      startDate: startDate != null
                          ? DateFormat('yyyy-MM-dd').format(startDate!)
                          : null,
                      endDate: endDate != null
                          ? DateFormat('yyyy-MM-dd').format(endDate!)
                          : null,
                    );
                  } else {
                    await prov.updateTransaction(
                      data['id'],
                      payload,
                      year: selectedYear,
                      bankId: selectedBankId,
                      mode: filterMode,
                      startDate: startDate != null
                          ? DateFormat('yyyy-MM-dd').format(startDate!)
                          : null,
                      endDate: endDate != null
                          ? DateFormat('yyyy-MM-dd').format(endDate!)
                          : null,
                    );
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> deleteTransaction(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title:
            Text('Hapus Transaksi?', style: TextStyle(color: creamColor(ctx))),
        content: Text(
          item['description'] ?? '-',
          style: TextStyle(color: secondaryTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!mounted) return;

    try {
      await context.read<BankStatusProvider>().deleteTransaction(
            item['id'] as int,
            year: selectedYear,
            bankId: selectedBankId,
            mode: filterMode,
            startDate: startDate != null
                ? DateFormat('yyyy-MM-dd').format(startDate!)
                : null,
            endDate: endDate != null
                ? DateFormat('yyyy-MM-dd').format(endDate!)
                : null,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaksi dihapus'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal hapus: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<BankStatusProvider>();
    final transactions = prov.transactions;

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: const Text('Manajemen Bank Status'),
        backgroundColor: cardColor(context),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CascadingYearFilter(
              selectedYear: selectedYear,
              currentMode: filterMode,
              useCompact: false,
              startDate: startDate,
              endDate: endDate,
              onSelected: (year, mode) {
                setState(() {
                  selectedYear = year;
                  filterMode = mode;
                });
                loadData();
              },
              onRangeTap: () async {
                final range = await AppDateRangePicker.show(context);
                if (range != null) {
                  setState(() {
                    filterMode = 'range';
                    startDate = range.start;
                    endDate = range.end;
                  });
                  loadData();
                }
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTransactionDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildBankFilter(prov),
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(child: Text('Belum ada transaksi.'))
                      : SizedBox.expand(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 32,
                                ),
                                child: DataTable(
                                  headingRowColor: WidgetStateProperty.all(
                                      cardColor(context)),
                                  columns: const [
                                    DataColumn(label: Text('Tanggal')),
                                    DataColumn(label: Text('#')),
                                    DataColumn(label: Text('Deskripsi')),
                                    DataColumn(
                                        label: Text('Value USD'),
                                        numeric: true),
                                    DataColumn(
                                        label: Text('Value IDR'),
                                        numeric: true),
                                    DataColumn(label: Text('Bank')),
                                    DataColumn(label: Text('Grup')),
                                    DataColumn(label: Text('Aksi')),
                                  ],
                                  rows:
                                      transactions.asMap().entries.map((entry) {
                                    final idx = entry.key;
                                    final t = entry.value;
                                    final usd = t['amount_usd'] ?? 0.0;
                                    final idr = t['amount_idr'] ?? 0.0;

                                    String bankDisplay = t['bank_name'] ?? '-';
                                    if (t['transaction_type'] == 'transfer' &&
                                        t['to_bank_name'] != null) {
                                      bankDisplay =
                                          '${t['bank_name']} ➔ ${t['to_bank_name']}';
                                    }

                                    return DataRow(cells: [
                                      DataCell(Text(displayDate(t['date']))),
                                      DataCell(Text('${idx + 1}')),
                                      DataCell(
                                        SizedBox(
                                          width: 200,
                                          child: Text(t['description'] ?? '-',
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      DataCell(Text(usd > 0
                                          ? numberFmt.format(usd)
                                          : '-')),
                                      DataCell(Text(idr > 0
                                          ? numberFmt.format(idr)
                                          : '-')),
                                      DataCell(Text(bankDisplay)),
                                      DataCell(Text(t['group_name'] ?? '-')),
                                      DataCell(Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.orange),
                                            onPressed: () =>
                                                showTransactionDialog(t),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red),
                                            onPressed: () =>
                                                deleteTransaction(t),
                                          ),
                                        ],
                                      )),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget buildBankFilter(BankStatusProvider prov) {
    // --- CLEANUP & SORT BANKS FOR FILTER ---
    final Map<String, Map<String, dynamic>> uniqueBanksMap = {};
    for (final b in prov.banks) {
      final name = b['name'].toString();
      if (name.toUpperCase().contains('BCA EWI (IDR)')) continue;
      final key = name.trim().toLowerCase();
      if (!uniqueBanksMap.containsKey(key)) {
        uniqueBanksMap[key] = b;
      }
    }
    final sortedBanks = uniqueBanksMap.values.toList();
    sortedBanks.sort((a, b) =>
        getBankSortIndex(a['name']).compareTo(getBankSortIndex(b['name'])));

    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor(context),
      child: Row(
        children: [
          const Text('Filter Bank: '),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<int?>(
              value: selectedBankId,
              isExpanded: true,
              dropdownColor: cardColor(context),
              hint: const Text('Semua Bank'),
              items: [
                const DropdownMenuItem<int?>(
                    value: null, child: Text('Semua Bank')),
                ...sortedBanks.map((b) => DropdownMenuItem<int?>(
                    value: b['id'], child: Text(b['name']))),
              ],
              onChanged: (v) {
                setState(() => selectedBankId = v);
                loadData();
              },
            ),
          ),
        ],
      ),
    );
  }
}
