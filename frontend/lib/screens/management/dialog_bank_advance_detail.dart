import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';
import 'package:expense_app/screens/management/dialog_edit_advance_balance.dart';
import 'package:expense_app/screens/management/dialog_advance_log_book.dart';
import 'package:expense_app/services/bank_order_preferences.dart';

extension BankManagementDialogsshowBankAdvanceDetailModalExt
    on BankManagementScreenState {
  Future<void> showBankAdvanceDetailModal(Map<String, dynamic> user,
      {bool showKelolaButton = true}) async {
    final userId = user['id'];
    await showBankAdvanceDetailModalHelper(
      context,
      user: user,
      balance: advanceBalances[userId] ?? 0.0,
      outstanding: advanceOutstandings[userId] ?? 0.0,
      saldoB: advanceSaldoB[userId] ?? 0.0,
      cashComp: advanceCashCompositions[userId] ?? [],
      hutangComp: advanceHutangBreakdowns[userId] ?? [],
      getBalance: () => advanceBalances[userId] ?? 0.0,
      getOutstanding: () => advanceOutstandings[userId] ?? 0.0,
      getSaldoB: () => advanceSaldoB[userId] ?? 0.0,
      getCashComp: () => advanceCashCompositions[userId] ?? [],
      getHutangComp: () => advanceHutangBreakdowns[userId] ?? [],
      showKelolaButton: showKelolaButton,
      onKelolaTap: () async {
        await showEditAdvanceBalanceDialog(user);
        await loadAdvanceData();
        if (mounted) {
          context.read<BankManagementProvider>().loadBanks();
        }
      },
      onLogbookTap: () => showAdvanceLogBookDialog(user),
    );
  }
}

Future<void> showBankAdvanceDetailModalHelper(
  BuildContext context, {
  required Map<String, dynamic> user,
  double balance = 0.0,
  double outstanding = 0.0,
  double saldoB = 0.0,
  List<dynamic> cashComp = const [],
  List<dynamic> hutangComp = const [],
  double Function()? getBalance,
  double Function()? getOutstanding,
  double Function()? getSaldoB,
  List<dynamic> Function()? getCashComp,
  List<dynamic> Function()? getHutangComp,
  bool showKelolaButton = true,
  Future<void> Function()? onKelolaTap,
  Future<void> Function()? onLogbookTap,
}) async {
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final dark = Theme.of(context).brightness == Brightness.dark;
  final expandedHutangBanks = <String>{};

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: dark ? AppTheme.surface : AppTheme.lightSurface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) {
        final currentBalance =
            getBalance != null ? getBalance() : balance;
        final currentOutstanding =
            getOutstanding != null ? getOutstanding() : outstanding;
        final currentSaldoB =
            getSaldoB != null ? getSaldoB() : saldoB;
        final currentCashComp =
            getCashComp != null ? getCashComp() : cashComp;
        final currentHutangComp =
            getHutangComp != null ? getHutangComp() : hutangComp;

        final bankMap = <String, double>{};
        for (var item in currentCashComp) {
          if (item is Map) {
            final name = (item['bank_name'] ?? '').toString();
            final bal =
                double.tryParse(item['balance']?.toString() ?? '0') ?? 0.0;
            if (name.isNotEmpty) bankMap[name] = bal;
          }
        }

        final hutangMap = <String, double>{};
        for (var item in currentHutangComp) {
          if (item is Map) {
            final name = (item['bank_name'] ?? '').toString();
            final bal =
                double.tryParse(item['balance']?.toString() ?? '0') ?? 0.0;
            if (name.isNotEmpty) hutangMap[name] = bal;
          }
        }

        final allBankKeys =
            <String>{...bankMap.keys, ...hutangMap.keys}.where((k) {
          return (bankMap[k] ?? 0.0) != 0 || (hutangMap[k] ?? 0.0) != 0;
        }).toList();
        allBankKeys.sort(BankOrderPreferences.compareBankNames);

        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              left: 24,
              right: 24,
              top: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 5,
                  decoration: BoxDecoration(
                    color: (dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (showKelolaButton)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.account_balance_wallet, size: 16),
                            label: const Text('Kelola Advance/Uang'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              if (onKelolaTap != null) {
                                await onKelolaTap();
                                if (ctx.mounted) setModalState(() {});
                              }
                            },
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'Tutup',
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                user['full_name'] ?? 'Karyawan',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: dark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Role: ${(user['role'] ?? '').toString().toUpperCase()}',
                style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
                ),
                child: Column(
                  children: [
                    Text('Total Bank Advance',
                        style: TextStyle(
                            color: dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(currentBalance),
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primary),
                    ),
                    if (allBankKeys.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  ...allBankKeys.map((bank) {
                                    final bankBal = bankMap[bank] ?? 0.0;
                                    return bankBal != 0
                                        ? Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(bank,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                    currencyFormat.format(bankBal),
                                                    style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppTheme.primary)),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink();
                                  }),
                                ],
                              ),
                            ),
                            if (hutangMap.values.any((v) => v != 0) || hutangComp.isNotEmpty) ...[
                              VerticalDivider(
                                width: 24,
                                thickness: 1,
                                color: (dark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    ...allBankKeys.map((bank) {
                                      final hutangBal = hutangMap[bank] ?? 0.0;
                                      Map<String, dynamic> matchingItem = {};
                                      for (var item in hutangComp) {
                                        if (item is Map && (item['bank_name'] ?? '').toString() == bank) {
                                          matchingItem = Map<String, dynamic>.from(item);
                                          break;
                                        }
                                      }
                                      final advList = (matchingItem['advances'] as List? ?? []);
                                      final activeAdvs = advList.where((a) => (double.tryParse((a['amount'] ?? 0).toString()) ?? 0.0) > 0.01).toList();

                                      final isExpanded = expandedHutangBanks.contains(bank);

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          if (hutangBal != 0)
                                            InkWell(
                                              onTap: activeAdvs.isNotEmpty
                                                  ? () {
                                                      setModalState(() {
                                                        if (isExpanded) {
                                                          expandedHutangBanks.remove(bank);
                                                        } else {
                                                          expandedHutangBanks.add(bank);
                                                        }
                                                      });
                                                    }
                                                  : null,
                                              borderRadius: BorderRadius.circular(4),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            bank,
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w600,
                                                              color: dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary,
                                                            ),
                                                          ),
                                                          if (activeAdvs.isNotEmpty) ...[
                                                            const SizedBox(width: 2),
                                                            Icon(
                                                              isExpanded
                                                                  ? Icons.keyboard_arrow_up_rounded
                                                                  : Icons.keyboard_arrow_down_rounded,
                                                              size: 16,
                                                              color: AppTheme.danger,
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      currencyFormat.format(hutangBal),
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        color: AppTheme.danger,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          if (isExpanded && activeAdvs.isNotEmpty) ...[
                                            ...activeAdvs.map((adv) {
                                              final title = (adv['title'] ?? 'Kasbon').toString();
                                              final amt = double.tryParse((adv['amount'] ?? 0).toString()) ?? 0.0;
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 3),
                                                child: Text(
                                                  '• $title: ${currencyFormat.format(amt)}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppTheme.danger.withValues(alpha: 0.85),
                                                  ),
                                                  textAlign: TextAlign.right,
                                                ),
                                              );
                                            }),
                                          ],
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Outstanding (Hutang Berjalan)',
                            style: TextStyle(
                                fontSize: 13,
                                color: dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
                        Text(currencyFormat.format(currentOutstanding),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.danger)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Settled (Saldo B)',
                            style: TextStyle(
                                fontSize: 13,
                                color: dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)),
                        Text(currencyFormat.format(currentSaldoB),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.warning)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  if (onLogbookTap != null) {
                    await onLogbookTap();
                  }
                },
                icon: const Icon(Icons.history_rounded),
                label: const Text('Riwayat Aktivitas / Log Book'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: dark ? AppTheme.card : AppTheme.lightCard,
                  foregroundColor: dark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                  side: BorderSide(
                      color: (dark ? AppTheme.textSecondary : AppTheme.lightTextSecondary)
                          .withValues(alpha: 0.2)),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}
