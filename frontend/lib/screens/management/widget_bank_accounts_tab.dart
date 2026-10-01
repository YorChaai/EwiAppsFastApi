import 'package:flutter/material.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';
import 'package:expense_app/screens/management/dialog_bank_cash_detail.dart';
import 'package:expense_app/screens/management/dialog_bank_account.dart';


extension BankManagementLayoutBankAccountsTabExt
    on BankManagementScreenState {
  Widget buildBankAccountsTab(BankManagementProvider prov) {
    final sortedBanks = List<dynamic>.from(prov.banks);

    if (bankCashSortMode == 'highest') {
      sortedBanks.sort((a, b) {
        final balA = double.tryParse((a['real_balance'] ?? 0.0).toString()) ?? 0.0;
        final balB = double.tryParse((b['real_balance'] ?? 0.0).toString()) ?? 0.0;
        return balB.compareTo(balA);
      });
    } else if (bankCashSortMode == 'lowest') {
      sortedBanks.sort((a, b) {
        final balA = double.tryParse((a['real_balance'] ?? 0.0).toString()) ?? 0.0;
        final balB = double.tryParse((b['real_balance'] ?? 0.0).toString()) ?? 0.0;
        return balA.compareTo(balB);
      });
    } else {
      // Default Mode: Respect custom drag-and-drop order if available, otherwise template order
      if (customCashOrder.isNotEmpty) {
        final Map<int, int> orderMap = {
          for (int i = 0; i < customCashOrder.length; i++) customCashOrder[i]: i
        };
        sortedBanks.sort((a, b) {
          final idA = a['id'] as int? ?? 0;
          final idB = b['id'] as int? ?? 0;
          final idxA = orderMap[idA] ?? (10000 + idA); // New accounts placed at the bottom
          final idxB = orderMap[idB] ?? (10000 + idB);
          return idxA.compareTo(idxB);
        });
      } else {
        sortedBanks.sort((a, b) => getBankSortIndex(a['name'] ?? '', a['id'] as int? ?? 0)
            .compareTo(getBankSortIndex(b['name'] ?? '', b['id'] as int? ?? 0)));
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showBankAccountDialog(null),
        icon: const Icon(Icons.add_card_rounded),
        label: const Text('Tambah Rekening'),
      ),
      body: sortedBanks.isEmpty
          ? const Center(child: Text('Belum ada rekening bank terdaftar.'))
          : Builder(builder: (ctx) {
              final scrollController = ScrollController();
              return AppScrollbar(
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: sortedBanks.length,
                  itemBuilder: (ctx, idx) {
                    final b = sortedBanks[idx];
                    final name = b['name'] ?? '-';
                    final accNum = b['account_number'] ?? 'Cash (Fisik)';
                    final realBal = double.tryParse(
                            (b['real_balance'] ?? 0.0).toString()) ??
                        0.0;
                    final curr = b['currency'] ?? 'IDR';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => showBankCashDetailModal(b),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor(context),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: realBal > 0
                                    ? AppTheme.primary.withValues(alpha: 0.4)
                                    : (realBal < 0
                                        ? AppTheme.danger.withValues(alpha: 0.4)
                                        : (isDark(context)
                                            ? AppTheme.divider
                                            : AppTheme.lightDivider)),
                                width: realBal != 0 ? 1.5 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: realBal > 0
                                        ? AppTheme.primary
                                        : (realBal < 0
                                            ? AppTheme.danger
                                            : AppTheme.textSecondary),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: realBal > 0
                                      ? AppTheme.primary.withValues(alpha: 0.15)
                                      : (realBal < 0
                                          ? AppTheme.danger.withValues(alpha: 0.15)
                                          : Colors.grey.withValues(alpha: 0.15)),
                                  child: Text(
                                    (name.isNotEmpty ? name[0] : '?')
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: realBal > 0
                                          ? AppTheme.primary
                                          : (realBal < 0
                                              ? AppTheme.danger
                                              : (isDark(context)
                                                  ? AppTheme.textSecondary
                                                  : AppTheme.lightTextSecondary)),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: isDark(context)
                                              ? AppTheme.textPrimary
                                              : AppTheme.lightTextPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppTheme.accent
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              curr.toUpperCase(),
                                              style: const TextStyle(
                                                fontSize: 9,
                                                color: AppTheme.accent,
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'No: $accNum',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppTheme
                                                  .getSecondaryTextColor(
                                                      context),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Saldo Saat Ini (Riil)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.getSecondaryTextColor(
                                            context),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${curr == 'USD' ? '\$' : 'Rp'}${numberFmt.format(realBal)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: realBal > 0
                                            ? AppTheme.primary
                                            : (realBal < 0
                                                ? AppTheme.danger
                                                : (isDark(context)
                                                    ? AppTheme.textPrimary
                                                    : AppTheme.lightTextPrimary)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: isDark(context)
                                      ? AppTheme.textSecondary
                                      : AppTheme.lightTextSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
    );
  }
}
