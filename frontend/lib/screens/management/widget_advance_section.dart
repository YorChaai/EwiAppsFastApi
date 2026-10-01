import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/dialog_bank_advance_detail.dart';


extension BankManagementLayoutAdvanceSectionExt on BankManagementScreenState {
  Widget buildAdvanceSection() {
    final filteredUsers = advanceUsers.where((u) {
      final fullName = (u['full_name'] ?? '').toString().toLowerCase();
      final username = (u['username'] ?? '').toString().toLowerCase();
      final query = advanceSearchQuery.toLowerCase();
      return fullName.contains(query) || username.contains(query);
    }).toList();

    if (bankAdvanceSortMode == 'highest') {
      filteredUsers.sort((a, b) {
        final balA = advanceBalances[a['id'] as int?] ?? 0.0;
        final balB = advanceBalances[b['id'] as int?] ?? 0.0;
        return balB.compareTo(balA);
      });
    } else if (bankAdvanceSortMode == 'lowest') {
      filteredUsers.sort((a, b) {
        final balA = advanceBalances[a['id'] as int?] ?? 0.0;
        final balB = advanceBalances[b['id'] as int?] ?? 0.0;
        return balA.compareTo(balB);
      });
    } else {
      if (customAdvanceOrder.isNotEmpty) {
        final Map<int, int> orderMap = {
          for (int i = 0; i < customAdvanceOrder.length; i++)
            customAdvanceOrder[i]: i
        };
        filteredUsers.sort((a, b) {
          final idA = a['id'] as int? ?? 0;
          final idB = b['id'] as int? ?? 0;
          final idxA = orderMap[idA] ?? (10000 + idA);
          final idxB = orderMap[idB] ?? (10000 + idB);
          return idxA.compareTo(idxB);
        });
      }
    }

    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return advanceLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppTheme.primary))
        : Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (v) => updateState(() => advanceSearchQuery = v),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, color: AppTheme.primary),
                    hintText: 'Cari karyawan berdasarkan nama...',
                  ),
                ),
              ),
              Expanded(
                child: filteredUsers.isEmpty
                    ? const Center(child: Text('Karyawan tidak ditemukan'))
                    : Builder(builder: (ctx) {
                        final scrollController = ScrollController();
                        return AppScrollbar(
                          controller: scrollController,
                          child: ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final u = filteredUsers[index];
                              final userId = u['id'];
                              final balance = advanceBalances[userId] ?? 0.0;

                              // Card styled exactly like Settlement/Kasbon layout
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () => showBankAdvanceDetailModal(u),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: cardColor(context),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: balance > 0
                                              ? AppTheme.primary
                                                  .withValues(alpha: 0.4)
                                              : (isDark(context)
                                                  ? AppTheme.divider
                                                  : AppTheme.lightDivider),
                                          width: balance > 0 ? 1.5 : 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.02),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          // Settlement colored strip style left border indicator
                                          Container(
                                            width: 4,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: balance > 0
                                                  ? AppTheme.primary
                                                  : AppTheme.textSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          CircleAvatar(
                                            radius: 24,
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
                                                    : (isDark(context)
                                                        ? AppTheme.textSecondary
                                                        : AppTheme
                                                            .lightTextSecondary),
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
                                                  u['full_name'] ?? '-',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark(context)
                                                        ? AppTheme.textPrimary
                                                        : AppTheme
                                                            .lightTextPrimary,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.accent
                                                            .withValues(
                                                                alpha: 0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Text(
                                                        (u['role'] ?? '')
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontSize: 9,
                                                          color:
                                                              AppTheme.accent,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          letterSpacing: 0.5,
                                                        ),
                                                      ),
                                                    ),
                                                    if ((advanceOutstandings[
                                                                userId] ??
                                                            0.0) >
                                                        0) ...[
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 6,
                                                                vertical: 2),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.danger
                                                              .withValues(
                                                                  alpha: 0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: Text(
                                                          'HUTANG: Rp ${NumberFormat('#,##0', 'id_ID').format(advanceOutstandings[userId] ?? 0.0)}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 9,
                                                            color:
                                                                AppTheme.danger,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            letterSpacing: 0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),

                                                // Bank & Hutang Breakdown
                                                Builder(builder: (context) {
                                                  final cashComp =
                                                      advanceCashCompositions[
                                                              userId] ??
                                                          [];
                                                  final hutangComp =
                                                      advanceHutangBreakdowns[
                                                              userId] ??
                                                          [];

                                                  final bankMap =
                                                      <String, double>{};
                                                  for (var item in cashComp) {
                                                    final name =
                                                        (item['bank_name'] ??
                                                                '')
                                                            .toString();
                                                    final bal = double.tryParse(
                                                            item['balance']
                                                                    ?.toString() ??
                                                                '0') ??
                                                        0.0;
                                                    if (name.isNotEmpty) {
                                                      bankMap[name] = bal;
                                                    }
                                                  }

                                                  final hutangMap =
                                                      <String, double>{};
                                                  for (var item in hutangComp) {
                                                    final name =
                                                        (item['bank_name'] ??
                                                                '')
                                                            .toString();
                                                    final bal = double.tryParse(
                                                            item['balance']
                                                                    ?.toString() ??
                                                                '0') ??
                                                        0.0;
                                                    if (name.isNotEmpty) {
                                                      hutangMap[name] = bal;
                                                    }
                                                  }

                                                  final allBankKeys = <String>{
                                                    ...bankMap.keys,
                                                    ...hutangMap.keys
                                                  }.where((k) {
                                                    return (bankMap[k] ??
                                                                0.0) !=
                                                            0 ||
                                                        (hutangMap[k] ?? 0.0) !=
                                                            0;
                                                  }).toList();
                                                  allBankKeys.sort();

                                                  if (allBankKeys.isEmpty) {
                                                    return const SizedBox
                                                        .shrink();
                                                  }

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 12,
                                                            bottom: 4,
                                                            right: 8),
                                                    child: IntrinsicHeight(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        children: [
                                                          SizedBox(
                                                            width: 140,
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Text(
                                                                  'bank',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: AppTheme
                                                                        .primary,
                                                                    letterSpacing:
                                                                        0.4,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 3),
                                                                ...allBankKeys
                                                                    .map(
                                                                        (bank) {
                                                                  final bankBal =
                                                                      bankMap[bank] ??
                                                                          0.0;
                                                                  return bankBal !=
                                                                          0
                                                                      ? Text(
                                                                          '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(bankBal)}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                            color: isDark(context)
                                                                                ? AppTheme.textPrimary
                                                                                : AppTheme.lightTextPrimary,
                                                                          ),
                                                                        )
                                                                      : const Text(
                                                                          '',
                                                                          style:
                                                                              TextStyle(fontSize: 11));
                                                                }),
                                                              ],
                                                            ),
                                                          ),
                                                          if (hutangMap.values
                                                              .any((v) =>
                                                                  v != 0)) ...[
                                                            VerticalDivider(
                                                              width: 24,
                                                              thickness: 1,
                                                              color: (isDark(
                                                                          context)
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)
                                                                  .withValues(
                                                                      alpha:
                                                                          0.5),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const Text(
                                                                    'hutang',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      color: AppTheme
                                                                          .danger,
                                                                      letterSpacing:
                                                                          0.4,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          3),
                                                                  ...allBankKeys
                                                                      .map(
                                                                          (bank) {
                                                                    final hutangBal =
                                                                        hutangMap[bank] ??
                                                                            0.0;
                                                                    return hutangBal !=
                                                                            0
                                                                        ? Text(
                                                                            '${bank.toLowerCase()} : ${NumberFormat('#,##0', 'id_ID').format(hutangBal)}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 11,
                                                                              color: AppTheme.danger,
                                                                            ),
                                                                          )
                                                                        : const Text(
                                                                            '',
                                                                            style:
                                                                                TextStyle(fontSize: 11));
                                                                  }),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Saldo Virtual',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppTheme
                                                      .getSecondaryTextColor(
                                                          context),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                currencyFormat.format(balance),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppTheme.success,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                currencyFormat.format(
                                                    advanceSaldoB[userId] ??
                                                        0.0),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFFFF9800),
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
              ),
            ],
          );
  }
}
