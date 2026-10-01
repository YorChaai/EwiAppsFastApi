import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:expense_app/providers/transactions/dividend_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';

class BalanceSheetSettingsScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialFilterMode;

  const BalanceSheetSettingsScreen({
    super.key,
    this.initialYear,
    this.initialFilterMode,
  });

  @override
  State<BalanceSheetSettingsScreen> createState() =>
      BalanceSheetSettingsScreenState();
}

class BalanceSheetSettingsScreenState
    extends State<BalanceSheetSettingsScreen> {
  late int selectedYear;
  late String filterMode;
  final openingCashController = TextEditingController();
  final accountsReceivableController = TextEditingController();
  final prepaidTaxController = TextEditingController();
  final prepaidExpensesController = TextEditingController();
  final otherReceivablesController = TextEditingController();
  final officeInventoryController = TextEditingController();
  final otherAssetsController = TextEditingController();
  final accountsPayableController = TextEditingController();
  final salaryPayableController = TextEditingController();
  final shareholderPayableController = TextEditingController();
  final accruedExpensesController = TextEditingController();
  final shareCapitalController = TextEditingController();
  final retainedEarningsBalanceController = TextEditingController();
  final otherIncomeController = TextEditingController();
  final corporateTaxController = TextEditingController();

  // Helper untuk theme-aware colors
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color textColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear ?? DateTime.now().year;
    filterMode = widget.initialFilterMode ?? 'report';
    Future.microtask(loadData);
  }

  @override
  void dispose() {
    openingCashController.dispose();
    accountsReceivableController.dispose();
    prepaidTaxController.dispose();
    prepaidExpensesController.dispose();
    otherReceivablesController.dispose();
    officeInventoryController.dispose();
    otherAssetsController.dispose();
    accountsPayableController.dispose();
    salaryPayableController.dispose();
    shareholderPayableController.dispose();
    accruedExpensesController.dispose();
    shareCapitalController.dispose();
    retainedEarningsBalanceController.dispose();
    otherIncomeController.dispose();
    corporateTaxController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final provider = context.read<DividendProvider>();
    await provider.fetchDividends(year: selectedYear);
    if (!mounted) return;
    final settings = Map<String, dynamic>.from(
      (provider.summary['settings'] ?? const <String, dynamic>{}) as Map,
    );
    openingCashController.text =
        formatPlain(settings['opening_cash_balance']);
    accountsReceivableController.text = formatPlain(
      settings['accounts_receivable'],
    );
    prepaidTaxController.text = formatPlain(settings['prepaid_tax_pph23']);
    prepaidExpensesController.text =
        formatPlain(settings['prepaid_expenses']);
    otherReceivablesController.text = formatPlain(
      settings['other_receivables'],
    );
    officeInventoryController.text =
        formatPlain(settings['office_inventory']);
    otherAssetsController.text = formatPlain(settings['other_assets']);
    accountsPayableController.text = formatPlain(
      settings['accounts_payable'],
    );
    salaryPayableController.text = formatPlain(settings['salary_payable']);
    shareholderPayableController.text = formatPlain(
      settings['shareholder_payable'],
    );
    accruedExpensesController.text = formatPlain(
      settings['accrued_expenses'],
    );
    shareCapitalController.text = formatPlain(settings['share_capital']);
    retainedEarningsBalanceController.text = formatPlain(
      settings['retained_earnings_balance'],
    );
    otherIncomeController.text = formatPlain(settings['other_income']);
    corporateTaxController.text =
        formatPlain(settings['corporate_tax_pph29']);
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

  String formatPlain(dynamic value) {
    final amount = toDouble(value);
    if (amount == 0) return '';
    return NumberFormat('#,##0', 'id_ID').format(amount);
  }

  Future<void> saveSettings() async {
    try {
      await context.read<DividendProvider>().updateDividendSetting(
        selectedYear,
        {
          'opening_cash_balance': toDouble(openingCashController.text),
          'accounts_receivable': toDouble(accountsReceivableController.text),
          'prepaid_tax_pph23': toDouble(prepaidTaxController.text),
          'prepaid_expenses': toDouble(prepaidExpensesController.text),
          'other_receivables': toDouble(otherReceivablesController.text),
          'office_inventory': toDouble(officeInventoryController.text),
          'other_assets': toDouble(otherAssetsController.text),
          'accounts_payable': toDouble(accountsPayableController.text),
          'salary_payable': toDouble(salaryPayableController.text),
          'shareholder_payable': toDouble(shareholderPayableController.text),
          'accrued_expenses': toDouble(accruedExpensesController.text),
          'share_capital': toDouble(shareCapitalController.text),
          'retained_earnings_balance': toDouble(
            retainedEarningsBalanceController.text,
          ),
          'other_income': toDouble(otherIncomeController.text),
          'corporate_tax_pph29': toDouble(corporateTaxController.text),
        },
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Setting neraca tahunan diupdate'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal update setting neraca: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Widget field(String label, TextEditingController controller) {
    return SizedBox(
      width: 260,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [CurrencyInputFormatter()],
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DividendProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 550;

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: useCompact
            ? const SizedBox.shrink()
            : const Text('Manajemen Neraca'),
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
                await loadData();
              },
              onRangeTap: () {}, // Neraca management tidak mendukung range
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: prov.isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (useCompact) ...[
                  Text(
                    'Manajemen Neraca',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: textColor(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // SEKSI 1: LABA RUGI
                Card(
                  color: cardColor(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setting Laba Rugi',
                          style: TextStyle(
                            color: textColor(context),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            field(
                                'Pendapatan Lainnya', otherIncomeController),
                            field('PPh 29 (Corporate Tax)',
                                corporateTaxController),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // SEKSI 2: NERACA
                Card(
                  color: cardColor(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Setting Neraca Tahunan',
                          style: TextStyle(
                            color: textColor(context),
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            field(
                                'Kas Tahun Sebelumnya', openingCashController),
                            field(
                                'Piutang Usaha', accountsReceivableController),
                            field(
                              'Pajak Bayar di Muka (pph23)',
                              prepaidTaxController,
                            ),
                            field(
                              'Biaya Bayar di Muka',
                              prepaidExpensesController,
                            ),
                            field(
                              'Piutang Lain Lain',
                              otherReceivablesController,
                            ),
                            field('Inventaris Kantor',
                                officeInventoryController),
                            field('Aktiva Lain Lain', otherAssetsController),
                            field('Hutang Usaha', accountsPayableController),
                            field('Hutang Gaji', salaryPayableController),
                            field(
                              'Hutang Pemegang Saham',
                              shareholderPayableController,
                            ),
                            field(
                              'Biaya Masih Harus Dibayar',
                              accruedExpensesController,
                            ),
                            field('Modal Saham', shareCapitalController),
                            field(
                              'Laba Ditahan Awal',
                              retainedEarningsBalanceController,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: prov.isLoading ? null : saveSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan Setting',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
