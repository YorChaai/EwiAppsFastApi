import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/screens/management/dialog_bank_advance_detail.dart';
import 'package:expense_app/screens/management/dialog_advance_log_book.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';


extension SettingsLayoutBankAdvanceWidgetExt on SettingsScreenState {
  Widget buildBankAdvanceWidget() {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dark = Theme.of(context).brightness == Brightness.dark;
    final double hutang =
        (balanceData['active_advance_balance'] ?? 0.0).toDouble();
    final double pengeluaran =
        (balanceData['total_settled'] ?? 0.0).toDouble();

    if (!loadingBalance &&
        activeAdvanceBalance.abs() < 0.01 &&
        hutang <= 0.01 &&
        pengeluaran <= 0.01) {
      return const SizedBox.shrink();
    }

    final allBankKeys = <String>{
      ...bankBreakdown.keys,
      ...bankHutangBreakdown.keys,
    }.toList()
      ..sort();

    return GestureDetector(
      onTap: () async {
        final auth = context.read<AuthProvider>();
        final userId = auth.user?['id'];
        final currentUser = auth.user ?? {
          'id': 0,
          'full_name': 'Karyawan',
          'role': 'STAFF',
        };

        if (userId != null) {
          try {
            final results = await Future.wait([
              api.getActiveAdvanceBalance(userId),
              api.getUserBalances(userId),
            ]);
            final balanceRes = results[0];
            final hutangRes = results[1];

            final freshHutang =
                (balanceRes['active_advance_balance'] ?? 0.0).toDouble();
            final freshPengeluaran =
                (balanceRes['total_settled'] ?? 0.0).toDouble();
            final freshActiveAdvanceBalance =
                (balanceRes['available_budget'] ?? 0.0).toDouble();
            final List<dynamic> freshRawHutang =
                List<dynamic>.from(hutangRes['balances'] ?? []);

            if (!mounted) return;
            await showBankAdvanceDetailModalHelper(
              context,
              user: currentUser,
              balance: freshActiveAdvanceBalance,
              outstanding: freshHutang,
              saldoB: freshPengeluaran,
              cashComp: balanceRes['cash_composition'] ?? balanceRes['breakdown'] ?? [],
              hutangComp: freshRawHutang,
              showKelolaButton: false,
              onLogbookTap: () => showAdvanceLogBookDialogHelper(context, currentUser),
            );
            return;
          } catch (e) {
            debugPrint('Failed to load fresh balance for modal: $e');
          }
        }

        await loadSettings();
        if (!mounted) return;
        final double freshHutang =
            (balanceData['active_advance_balance'] ?? 0.0).toDouble();
        final double freshPengeluaran =
            (balanceData['total_settled'] ?? 0.0).toDouble();

        await showBankAdvanceDetailModalHelper(
          context,
          user: currentUser,
          balance: activeAdvanceBalance,
          outstanding: freshHutang,
          saldoB: freshPengeluaran,
          cashComp: balanceData['cash_composition'] ?? balanceData['breakdown'] ?? [],
          hutangComp: rawHutangBalances,
          showKelolaButton: false,
          onLogbookTap: () => showAdvanceLogBookDialogHelper(context, currentUser),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: dark
                ? [
                    AppTheme.primary.withValues(alpha: 0.15),
                    AppTheme.accent.withValues(alpha: 0.05)
                  ]
                : [
                    AppTheme.primary.withValues(alpha: 0.08),
                    AppTheme.accent.withValues(alpha: 0.03)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bank Advance (Saldo Virtual)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                            color: AppTheme.primary,
                          ),
                        ),
                        if (hutang > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.danger.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'HUTANG: Rp ${NumberFormat('#,##0', 'id_ID').format(hutang)}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppTheme.danger,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  loadingBalance
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                        )
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  currencyFormat.format(activeAdvanceBalance),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: titleColor(context),
                                  ),
                                ),
                                if (pengeluaran > 0)
                                  Text(
                                    'Total Pengeluaran: ${currencyFormat.format(pengeluaran)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isBankCardExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                          ],
                        ),
                ],
              ),
            ),
            if (isBankCardExpanded &&
                !loadingBalance &&
                allBankKeys.isNotEmpty)
              Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dark
                      ? AppTheme.surface.withValues(alpha: 0.5)
                      : AppTheme.lightSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'bank',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...allBankKeys.map((bank) {
                              final bal = bankBreakdown[bank] ?? 0.0;
                              return bal != 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(bal)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: bodyColor(context),
                                        ),
                                      ),
                                    )
                                  : const Text('',
                                      style: TextStyle(fontSize: 12));
                            }),
                          ],
                        ),
                      ),
                      if (bankHutangBreakdown.values.any((v) => v != 0)) ...[
                        VerticalDivider(
                          width: 24,
                          thickness: 1,
                          color:
                              (dark ? Colors.white : Colors.black)
                                  .withValues(alpha: 0.5),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'hutang',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.danger,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...allBankKeys.map((bank) {
                                final hutangBal =
                                    bankHutangBreakdown[bank] ?? 0.0;
                                Map<String, dynamic> matchingRaw = {};
                                for (var item in rawHutangBalances) {
                                  if ((item['bank_name'] ?? '').toString() == bank) {
                                    matchingRaw = Map<String, dynamic>.from(item);
                                    break;
                                  }
                                }
                                final advList = (matchingRaw['advances'] as List? ?? []);
                                final activeAdvs = advList.where((a) => (double.tryParse((a['amount'] ?? 0).toString()) ?? 0.0) > 0.01).toList();
                                final isExpanded = expandedHutangBanks.contains(bank);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (hutangBal != 0)
                                      InkWell(
                                        onTap: activeAdvs.isNotEmpty
                                            ? () {
                                                updateState(() {
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
                                          padding: const EdgeInsets.only(bottom: 4, right: 4),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(hutangBal)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppTheme.danger,
                                                  fontWeight: FontWeight.bold,
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
                                      ),
                                    if (isExpanded && activeAdvs.isNotEmpty) ...[
                                      ...activeAdvs.map((adv) {
                                        final title = (adv['title'] ?? 'Kasbon').toString();
                                        final amt = double.tryParse((adv['amount'] ?? 0).toString()) ?? 0.0;
                                        return Padding(
                                          padding: const EdgeInsets.only(left: 6, bottom: 3),
                                          child: Text(
                                            '• $title : ${NumberFormat('#,##0', 'id_ID').format(amt)}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: AppTheme.danger.withValues(alpha: 0.85),
                                              fontWeight: FontWeight.w500,
                                            ),
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
              ),
          ],
        ),
      ),
    );
  }
}
