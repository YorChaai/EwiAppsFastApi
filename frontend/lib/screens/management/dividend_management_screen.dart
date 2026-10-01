import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/transactions/dividend_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';

class DividendManagementScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialFilterMode;

  const DividendManagementScreen({
    super.key,
    this.initialYear,
    this.initialFilterMode,
  });

  @override
  State<DividendManagementScreen> createState() =>
      DividendManagementScreenState();
}

class DividendManagementScreenState extends State<DividendManagementScreen> {
  late int selectedYear;
  late String filterMode;
  final dateFmt = DateFormat('yyyy-MM-dd');
  final profitRetainedController = TextEditingController();
  final dividendDistributedController = TextEditingController();

  // Helper untuk theme-aware colors
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
    final prov = context.read<DividendProvider>();
    selectedYear = widget.initialYear ?? prov.reportYear;
    filterMode = widget.initialFilterMode ?? 'report';

    final divProv = context.read<DividendProvider>();

    // ✅ Sync this provider's year with the centralized settings before loading
    Future.microtask(() async {
      await divProv.syncReportYear();
      if (mounted) loadData();
    });
  }

  @override
  void dispose() {
    profitRetainedController.dispose();
    dividendDistributedController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    final provider = context.read<DividendProvider>();
    await provider.fetchDividends(year: selectedYear);
    if (!mounted) return;
    final settings = Map<String, dynamic>.from(
      (provider.summary['settings'] ?? const <String, dynamic>{}) as Map,
    );

    final initialProfitRetained = settings['profit_retained'] ??
        provider.summary['profit_retained'] ??
        0.0;
    final profitAfterTax = toDouble(provider.summary['profit_after_tax']);
    final initialDividendDistributed = profitAfterTax - initialProfitRetained;

    profitRetainedController.text = formatForInput(initialProfitRetained);
    dividendDistributedController.text =
        formatForInput(initialDividendDistributed);
  }

  double toDouble(dynamic value) {
    if (value is num) return value.toDouble();

    final raw = (value ?? '').toString().trim();
    if (raw.isEmpty) return 0;

    var cleaned = raw.replaceAll(' ', '');
    final dotCount = '.'.allMatches(cleaned).length;
    final commaCount = ','.allMatches(cleaned).length;

    if (dotCount > 0 && commaCount == 0) {
      cleaned = cleaned.replaceAll('.', '');
    } else if (cleaned.contains('.') && cleaned.contains(',')) {
      cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
    } else if (cleaned.contains(',')) {
      cleaned = cleaned.replaceAll(',', '.');
    }

    return double.tryParse(cleaned) ?? 0;
  }

  String fmtMoney(dynamic value) {
    final raw = toDouble(value).toStringAsFixed(0);
    final chars = raw.split('');
    final out = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      final reverseIndex = chars.length - i;
      out.write(chars[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        out.write('.');
      }
    }
    return 'Rp $out';
  }

  String formatForInput(dynamic value) {
    final amount = toDouble(value);
    final raw = amount.toStringAsFixed(0);
    final chars = raw.split('');
    final out = StringBuffer();
    for (int i = 0; i < chars.length; i++) {
      final reverseIndex = chars.length - i;
      out.write(chars[i]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) {
        // Jangan tambah titik setelah tanda minus
        if (chars[i] != '-') {
          out.write('.');
        }
      }
    }
    return out.toString();
  }

  Future<void> showRecipientDialog([Map<String, dynamic>? data]) async {
    final formKey = GlobalKey<FormState>();
    final now = DateTime.now();
    final defaultDate = selectedYear == 0 || selectedYear == now.year
        ? now
        : DateTime(selectedYear, 12, 31);
    final date = TextEditingController(
      text: data?['date']?.toString().substring(0, 10) ??
          dateFmt.format(defaultDate),
    );
    final name = TextEditingController(text: data?['name'] ?? '');
    final percentage = TextEditingController(
      text: data?['percentage']?.toString() ?? '',
    );

    Future<void> pickDate(TextEditingController ctrl) async {
      final init =
          DateTime.tryParse(ctrl.text) ?? DateTime(selectedYear, 12, 31);
      final picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2035),
        initialDate: init,
      );
      if (picked != null) {
        ctrl.text = dateFmt.format(picked);
      }
    }

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          data == null ? 'Tambah Penerima Dividen' : 'Edit Penerima Dividen',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: SizedBox(
          width: 560,
          child: Form(
            key: formKey,
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                dateField(date, 'Tanggal', pickDate),
                textField(name, 'Nama Penerima', width: 280, required: true),
                textField(percentage, 'Persentase (%)',
                    width: 150, required: true, isNumber: true),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final payload = <String, dynamic>{
                'date': date.text.trim(),
                'name': name.text.trim(),
                'percentage': double.tryParse(percentage.text) ?? 0.0,
              };
              try {
                final provider = context.read<DividendProvider>();
                if (data == null) {
                  payload['profit_retained'] =
                      toDouble(profitRetainedController.text);
                  await provider.createDividend(payload, year: selectedYear);
                } else {
                  await provider.updateDividend(
                    data['id'] as int,
                    payload,
                    year: selectedYear,
                  );
                }
                if (!mounted || !ctx.mounted) return;
                Navigator.pop(ctx);
                final profitAfterTax =
                    toDouble(provider.summary['profit_after_tax']);
                final pr = toDouble(provider.summary['profit_retained']);
                profitRetainedController.text = formatForInput(pr);
                dividendDistributedController.text =
                    formatForInput(profitAfterTax - pr);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      data == null
                          ? 'Penerima dividen ditambahkan'
                          : 'Penerima dividen diupdate',
                    ),
                    backgroundColor: AppTheme.success,
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal simpan: $e'),
                    backgroundColor: AppTheme.danger,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> saveProfitRetained() async {
    try {
      await context.read<DividendProvider>().updateDividendSetting(
        selectedYear,
        {'profit_retained': toDouble(profitRetainedController.text)},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profit ditahan diupdate'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal update profit ditahan: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Future<void> deleteDividend(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text(
          'Hapus Penerima Dividen?',
          style: TextStyle(color: creamColor(ctx)),
        ),
        content: Text(
          item['name'] ?? '-',
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
    if (ok != true || !mounted) return;

    try {
      await context.read<DividendProvider>().deleteDividend(
            item['id'] as int,
            year: selectedYear,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Penerima dividen dihapus'),
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

  Widget textField(
    TextEditingController controller,
    String label, {
    double width = 230,
    bool required = false,
    bool isNumber = false,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : null,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (v) {
                if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                if (isNumber && double.tryParse(v) == null) {
                  return 'Harus angka';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget dateField(
    TextEditingController controller,
    String label,
    Future<void> Function(TextEditingController) onPick,
  ) {
    return SizedBox(
      width: 230,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => onPick(controller),
          ),
        ),
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
        onTap: () => onPick(controller),
      ),
    );
  }

  Widget buildCalculationCard(Map<String, dynamic> summary) {
    final profitAfterTax = toDouble(summary['profit_after_tax']);
    final profitRetained = toDouble(profitRetainedController.text);

    final totalPercentage = toDouble(summary['total_percentage']);
    final remainingPercentage = (100.0 - totalPercentage).clamp(0.0, 100.0);

    final dividendDistributed = (profitAfterTax - profitRetained).clamp(
      0,
      double.infinity,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget metric(String label, String value, {bool expanded = false}) {
      final child = Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.surface : AppTheme.lightSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDark ? AppTheme.divider : AppTheme.lightDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: isDark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
      return expanded ? Expanded(child: child) : child;
    }

    return Card(
      color: isDark ? AppTheme.card : AppTheme.lightCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hitung Dividen',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            // Form input untuk Profit Ditahan & Dividen Dibagi
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: profitRetainedController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Profit Ditahan',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      hintText: '0',
                    ),
                    onChanged: (v) {
                      final pr = toDouble(v);
                      final dd = profitAfterTax - pr;
                      dividendDistributedController.text = formatForInput(dd);
                      setState(() {}); // Trigger refresh metrics below
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: dividendDistributedController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [CurrencyInputFormatter()],
                    decoration: const InputDecoration(
                      labelText: 'Dividen Dibagi',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      hintText: '0',
                    ),
                    onChanged: (v) {
                      final dd = toDouble(v);
                      final pr = profitAfterTax - dd;
                      profitRetainedController.text = formatForInput(pr);
                      setState(() {}); // Trigger refresh metrics below
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: saveProfitRetained,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  child: const Text('Simpan'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Fix: Gunakan LayoutBuilder agar rapi di layar sempit
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 500;
                if (isCompact) {
                  return Column(
                    children: [
                      metric('Profit After Tax', fmtMoney(profitAfterTax)),
                      const SizedBox(height: 12),
                      metric('Dividen Dibagi', fmtMoney(dividendDistributed)),
                      const SizedBox(height: 12),
                      metric('Total Persen',
                          '${totalPercentage.toStringAsFixed(1)}%'),
                      const SizedBox(height: 12),
                      metric('Sisa Persen',
                          '${remainingPercentage.toStringAsFixed(1)}%'),
                    ],
                  );
                }
                return Row(
                  children: [
                    metric('Profit After Tax', fmtMoney(profitAfterTax),
                        expanded: true),
                    const SizedBox(width: 12),
                    metric('Dividen Dibagi', fmtMoney(dividendDistributed),
                        expanded: true),
                    const SizedBox(width: 12),
                    metric('Total Persen',
                        '${totalPercentage.toStringAsFixed(1)}%',
                        expanded: true),
                    const SizedBox(width: 12),
                    metric('Sisa Persen',
                        '${remainingPercentage.toStringAsFixed(1)}%',
                        expanded: true),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DividendProvider>();
    final items = prov.dividends;
    final summary = prov.summary;

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 550;

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: useCompact
            ? const SizedBox.shrink()
            : const Text('Manajemen Dividen'),
        backgroundColor: cardColor(context),
        titleSpacing: useCompact ? 0 : NavigationToolbar.kMiddleSpacing,
        actions: [
          // Filter Periode Cascading
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CascadingYearFilter(
              selectedYear: selectedYear,
              currentMode: filterMode,
              useCompact: false,
              onSelected: (year, mode) async {
                setState(() {
                  selectedYear = year;
                  filterMode = mode;
                });

                // ✅ Sync all providers with the selected year
                // Sync ke semua provider lain
                context.read<CascadeProvider>().syncReportYear(context, year);
                await loadData();
              },
              onRangeTap:
                  () {}, // Dividen management biasanya tidak mendukung range
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => showRecipientDialog(),
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Penerima',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showRecipientDialog(),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Tambah Penerima'),
      ),
      body: prov.isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                if (useCompact) ...[
                  Text(
                    'Manajemen Dividen',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: creamColor(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                buildCalculationCard(summary),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        'Belum ada penerima dividen.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  ...items.map((rawItem) {
                    final item = Map<String, dynamic>.from(
                      rawItem as Map<dynamic, dynamic>,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        color: cardColor(context),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          title: Text(
                            (item['name'] ?? '-').toString(),
                            style: TextStyle(
                              color: creamColor(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              '${(item['date'] ?? '').toString()} | ${item['percentage']}% | Bagian: ${fmtMoney(item['amount'])}',
                              style: TextStyle(
                                  color: secondaryTextColor(context)),
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 4,
                            children: [
                              IconButton(
                                onPressed: () => showRecipientDialog(item),
                                icon: const Icon(Icons.edit_outlined),
                                color: Colors.amber,
                              ),
                              IconButton(
                                onPressed: () => deleteDividend(item),
                                icon: const Icon(Icons.delete_outline),
                                color: AppTheme.danger,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
