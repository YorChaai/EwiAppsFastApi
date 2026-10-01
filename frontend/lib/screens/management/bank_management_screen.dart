import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';
import 'package:expense_app/screens/management/widget_section_toggle.dart';
import 'package:expense_app/screens/management/widget_advance_section.dart';
import 'package:expense_app/screens/management/widget_bank_accounts_tab.dart';
import 'package:expense_app/services/bank_order_preferences.dart';


class BankManagementScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialSection;

  const BankManagementScreen(
      {super.key, this.initialYear, this.initialSection});

  @override
  State<BankManagementScreen> createState() => BankManagementScreenState();
}

class BankManagementScreenState extends State<BankManagementScreen>
    with SingleTickerProviderStateMixin {
  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  late int selectedYear;
  int? selectedBankId;
  final String filterMode = 'report';
  DateTime? startDate;
  DateTime? endDate;
  final numberFmt = NumberFormat('#,##0', 'id_ID');

  // Unified Bank Section Toggles
  String activeSection = 'cash'; // 'cash' or 'advance'

  // Sorting & Custom Order States
  String bankCashSortMode = 'default'; // 'default', 'highest', 'lowest'
  String bankAdvanceSortMode = 'default'; // 'default', 'highest', 'lowest'
  List<int> customCashOrder = [];
  List<int> customAdvanceOrder = [];

  // Bank Advance states
  final ApiService advanceApi = ApiService();
  bool advanceLoading = true;
  List<Map<String, dynamic>> advanceUsers = [];
  Map<int, double> advanceBalances = {};
  Map<int, double> advanceOutstandings = {};
  Map<int, double> advanceSaldoB = {};
  Map<int, List<dynamic>> advanceCashCompositions = {};
  Map<int, List<dynamic>> advanceHutangBreakdowns = {};
  String advanceSearchQuery = '';

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

  StreamSubscription<void>? refreshSub;

  Future<void> loadPreferenceOrders() async {
    final cashOrder = await BankOrderPreferences.getBankCashOrder();
    final advanceOrder = await BankOrderPreferences.getBankAdvanceOrder();
    final cashSort = await BankOrderPreferences.getBankCashSortMode();
    final advanceSort = await BankOrderPreferences.getBankAdvanceSortMode();
    if (mounted) {
      updateState(() {
        customCashOrder = cashOrder;
        customAdvanceOrder = advanceOrder;
        bankCashSortMode = cashSort;
        bankAdvanceSortMode = advanceSort;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    selectedYear = widget.initialYear ?? DateTime.now().year;
    if (widget.initialSection != null) {
      activeSection = widget.initialSection!;
    }
    Future.microtask(() {
      if (!mounted) return;
      loadPreferenceOrders();
      context.read<BankManagementProvider>().loadBanks();
      loadData();
      loadAdvanceData();
    });

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        loadPreferenceOrders();
        context.read<BankManagementProvider>().loadBanks();
        loadData();
        loadAdvanceData();
      }
    });
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<BankManagementProvider>();

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: Text(activeSection == 'cash'
            ? 'Kelola Bank Cash (Kas Riil)'
            : 'Kelola Bank Advance (Kas Virtual)'),
        backgroundColor: cardColor(context),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          buildSectionToggle(),
          const SizedBox(height: 10),
          Expanded(
            child: activeSection == 'cash'
                ? (prov.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildBankAccountsTab(prov))
                : buildAdvanceSection(),
          ),
        ],
      ),
    );
  }
}
