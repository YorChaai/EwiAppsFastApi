import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/bank_management_screen_actions.dart';
import 'package:expense_app/screens/management/bank_management_screen_tables.dart';


extension BankManagementDialogsshowBankCashLogBookDialogExt
    on BankManagementScreenState {
  Future<void> showBankCashLogBookDialog(Map<String, dynamic> bankData) async {
    final bankId = bankData['id'];

    // Switch filter to this specific bank ID if not already
    if (selectedBankId != bankId) {
      updateState(() => selectedBankId = bankId);
      await loadData();
    }
    if (!mounted) return;

    bool isFullscreen = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      constraints: const BoxConstraints(maxWidth: double.infinity),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return GestureDetector(
            onTap: () => Navigator.pop(ctx),
            behavior: HitTestBehavior.opaque,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // Prevent dismissal when clicking inside content
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: isFullscreen
                      ? MediaQuery.of(ctx).size.width
                      : (MediaQuery.of(ctx).size.width > 640
                          ? 640
                          : MediaQuery.of(ctx).size.width),
                  decoration: BoxDecoration(
                    color: surfaceColor(context),
                    borderRadius: isFullscreen
                        ? BorderRadius.zero
                        : const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 60,
                            height: 5,
                            decoration: BoxDecoration(
                                color: secondaryTextColor(context)
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              tooltip: 'Kembali',
                              onPressed: () => Navigator.pop(ctx),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Riwayat Transaksi - ${bankData['name']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(isFullscreen
                                  ? Icons.fullscreen_exit_rounded
                                  : Icons.fullscreen_rounded),
                              onPressed: () {
                                setModalState(() {
                                  isFullscreen = !isFullscreen;
                                });
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Builder(builder: (ctx) {
                          final scrollController = ScrollController();
                          return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              constraints: BoxConstraints(
                                  minHeight: isFullscreen
                                      ? MediaQuery.of(ctx).size.height * 0.85
                                      : 0,
                                  maxHeight: isFullscreen
                                      ? MediaQuery.of(ctx).size.height * 0.85
                                      : MediaQuery.of(ctx).size.height * 0.6),
                              child: Consumer<BankManagementProvider>(
                                  builder: (context, bankProv, child) {
                                if (bankProv.isLoading) {
                                  return const Center(
                                      child: Padding(
                                          padding: EdgeInsets.all(20),
                                          child: CircularProgressIndicator()));
                                }
                                final transactions =
                                    List<dynamic>.from(bankProv.transactions);
                                transactions.sort((a, b) {
                                  final da =
                                      DateTime.tryParse(a['date'] ?? '') ??
                                          DateTime(2000);
                                  final db =
                                      DateTime.tryParse(b['date'] ?? '') ??
                                          DateTime(2000);
                                  final dateCmp = db.compareTo(da);
                                  if (dateCmp != 0) return dateCmp;
                                  return (b['id'] ?? 0).compareTo(a['id'] ?? 0);
                                });

                                if (transactions.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Center(
                                        child: Text(
                                            'Belum ada transaksi di bank ini.',
                                            style: TextStyle(
                                                color: AppTheme
                                                    .getSecondaryTextColor(
                                                        context),
                                                fontSize: 13))),
                                  );
                                }

                                return AppScrollbar(
                                  controller: scrollController,
                                  child: ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemCount: transactions.length,
                                    itemBuilder: (c, idx) {
                                      final t = transactions[idx];
                                      final isIncome =
                                          t['transaction_type'] == 'income';
                                      final isTransfer =
                                          t['transaction_type'] == 'transfer';
                                      final amt = t['amount_idr'] ?? 0.0;
                                      final usd = t['amount_usd'] ?? 0.0;
                                      final displayAmt = usd > 0
                                          ? '\$ ${NumberFormat('#,##0').format(usd)}'
                                          : 'Rp ${NumberFormat('#,##0', 'id_ID').format(amt)}';

                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            border: Border.all(
                                                color:
                                                    secondaryTextColor(context)
                                                        .withValues(
                                                            alpha: 0.15)),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Material(
                                            color: cardColor(context),
                                            child: Builder(
                                              builder: (ctx) {
                                                String rawDesc =
                                                    t['description'] ?? '-';
                                                rawDesc = rawDesc.replaceAll(
                                                    RegExp(r'\s*\(Ref: #\d+\)'),
                                                    '');
                                                rawDesc = rawDesc.replaceAll(
                                                    RegExp(
                                                        r'\(Settlement #\d+:\s*'),
                                                    '(');
                                                rawDesc = rawDesc.replaceAll(
                                                    RegExp(
                                                        r'Settlement #\d+:\s*'),
                                                    '');

                                                String mainDesc = rawDesc;
                                                String? beforeAfterText;
                                                List<String>? extraInfoLines;
                                                bool isIncrease = true;
                                                if (rawDesc.contains('|')) {
                                                  final parts =
                                                      rawDesc.split('|');
                                                  mainDesc = parts[0];
                                                  if (parts.length >= 3) {
                                                    final before =
                                                        double.tryParse(
                                                                parts[1]) ??
                                                            0.0;
                                                    final after =
                                                        double.tryParse(
                                                                parts[2]) ??
                                                            0.0;
                                                    isIncrease =
                                                        after >= before;
                                                    final isUsd =
                                                        (t['amount_usd'] ??
                                                                0.0) >
                                                            0;
                                                    final curr =
                                                        isUsd ? '\$' : 'Rp';
                                                    final formatStr = isUsd
                                                        ? NumberFormat('#,##0')
                                                        : NumberFormat(
                                                            '#,##0', 'id_ID');
                                                    beforeAfterText =
                                                        '$curr ${formatStr.format(before)} ➔ $curr ${formatStr.format(after)}';
                                                  }
                                                  if (parts.length > 3) {
                                                    extraInfoLines =
                                                        parts.sublist(3);
                                                  }
                                                }

                                                return ExpansionTile(
                                                  key: PageStorageKey(
                                                      t['id'] ?? t.hashCode),
                                                  tilePadding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  childrenPadding:
                                                      const EdgeInsets.only(
                                                          left: 16,
                                                          right: 16,
                                                          bottom: 16),
                                                  title: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  displayDate(
                                                                      t['date']),
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: 12,
                                                                      color: AppTheme
                                                                          .primary),
                                                                ),
                                                                if (t['creator_name'] != null &&
                                                                    t['creator_name']
                                                                        .toString()
                                                                        .trim()
                                                                        .isNotEmpty) ...[
                                                                  const SizedBox(width: 8),
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 6,
                                                                        vertical: 1.5),
                                                                    decoration: BoxDecoration(
                                                                      color: AppTheme.primary
                                                                          .withValues(
                                                                              alpha: 0.1),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(4),
                                                                      border: Border.all(
                                                                        color: AppTheme.primary
                                                                            .withValues(
                                                                                alpha: 0.2),
                                                                        width: 0.5,
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize:
                                                                          MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .person_outline,
                                                                            size: 11,
                                                                            color: AppTheme
                                                                                .primary),
                                                                        const SizedBox(
                                                                            width: 3),
                                                                        Text(
                                                                          t['creator_name']
                                                                              .toString(),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize: 10,
                                                                            fontWeight:
                                                                                FontWeight
                                                                                    .w600,
                                                                            color: AppTheme
                                                                                .primary,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                                mainDesc.split(
                                                                    '\n')[0],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            if (mainDesc
                                                                    .split(
                                                                        '\n')
                                                                    .length >
                                                                1) ...[
                                                              const SizedBox(
                                                                  height: 2),
                                                              Text(
                                                                mainDesc
                                                                    .split(
                                                                        '\n')
                                                                    .sublist(1)
                                                                    .join(
                                                                        '\n'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: secondaryTextColor(
                                                                        context)),
                                                              ),
                                                            ],
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        displayAmt,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: isTransfer
                                                                ? Colors.orange
                                                                : (isIncome
                                                                    ? AppTheme
                                                                        .success
                                                                    : AppTheme
                                                                        .danger),
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  children: [
                                                    Divider(
                                                        color:
                                                            secondaryTextColor(
                                                                    context)
                                                                .withValues(
                                                                    alpha: 0.1),
                                                        height: 16),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              buildLogGridItem(
                                                                  'Kategori',
                                                                  t['group_name'] ??
                                                                      '-'),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              buildLogGridItem(
                                                                  'Dibuat Oleh',
                                                                  (t['creator_name'] !=
                                                                              null &&
                                                                          t['creator_name']
                                                                              .toString()
                                                                              .trim()
                                                                              .isNotEmpty)
                                                                      ? t['creator_name']
                                                                          .toString()
                                                                      : '-'),
                                                              if (beforeAfterText !=
                                                                  null) ...[
                                                                const SizedBox(
                                                                    height: 8),
                                                                buildLogGridItem(
                                                                    'Saldo Berubah',
                                                                    beforeAfterText,
                                                                    valueColor: isIncrease
                                                                        ? AppTheme
                                                                            .success
                                                                        : AppTheme
                                                                            .danger),
                                                              ],
                                                              if (extraInfoLines !=
                                                                  null) ...[
                                                                const SizedBox(
                                                                    height: 8),
                                                                ...extraInfoLines
                                                                    .map(
                                                                  (line) =>
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            2),
                                                                    child: Text(
                                                                      line,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .amber,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }));
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
