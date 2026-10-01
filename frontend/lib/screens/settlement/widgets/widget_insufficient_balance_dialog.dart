
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expense_app/screens/settlement/settlement_detail_screen.dart';

import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/screens/layout/main_layout.dart';
import 'package:expense_app/theme/app_theme.dart';

// Auto-injected imports to cover dependencies within the settlement_detail family
import 'package:expense_app/screens/settlement/widgets/widget_insuff_balance_row.dart';

extension SettlementDetailInsufficientBalanceDialogExt
    on SettlementDetailScreenState {
  void showInsufficientBalanceDialog(InsufficientAdvanceBalanceException ex) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: getCardColor(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Saldo Advance Tidak Mencukupi',
                style: TextStyle(
                  color: getPrimaryText(ctx),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saldo Advance ${ex.userName.replaceAll('(Lain-lainnya)', '')} tidak mencukupi untuk menyetujui pengiriman ini.',
              style: TextStyle(color: getSecondaryText(ctx), fontSize: 13),
            ),
            const SizedBox(height: 16),
            insuffBalanceRow(
                ctx, 'Dibutuhkan', fmt.format(ex.needed), getCreamColor(ctx)),
            insuffBalanceRow(
                ctx, 'Tersedia', fmt.format(ex.available), AppTheme.primary),
            Divider(color: getDividerColor(ctx), height: 20),
            insuffBalanceRow(
                ctx, 'Kekurangan', fmt.format(ex.shortfall), Colors.orange,
                bold: true),
            if (ex.cashComposition != null &&
                ex.cashComposition!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Saldo tersedia di bank:',
                style: TextStyle(
                  color: getSecondaryText(ctx),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: getSurfaceColor(ctx),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: getDividerColor(ctx)),
                ),
                child: Column(
                  children: ex.cashComposition!.entries.map((e) {
                    final amt = (e.value as num).toDouble();
                    if (amt <= 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key,
                              style: TextStyle(
                                  color: getPrimaryText(ctx), fontSize: 13)),
                          Text(
                            fmt.format(amt),
                            style: TextStyle(
                              color: getPrimaryText(ctx),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Text(
                '💡 Pergi ke Bank Advance untuk melakukan top-up saldo, lalu kembali dan setujui kembali.',
                style: TextStyle(color: getSecondaryText(ctx), fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: getSecondaryText(ctx))),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              globalSwitchTab?.call(4);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.account_balance_rounded, size: 18),
            label: const Text('Ke Bank Advance'),
          ),
        ],
      ),
    );
  }
}
