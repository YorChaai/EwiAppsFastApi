import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/screens/layout/main_layout.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/widgets/widget_insuff_balance_row.dart';

extension AdvanceDetailDialogsGeneralshowInsufficientBalanceDialogExt
    on AdvanceDetailScreenState {
  void showInsufficientBalanceDialog(InsufficientAdvanceBalanceException ex) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Cari target bank dari message untuk display dan pencarian di composition
    String targetBankName = '';
    final match = RegExp(r'\((.*?)\)').firstMatch(ex.message);
    if (match != null) {
      targetBankName = (match.group(1) ?? '').trim();
    }

    // Jika ex.available adalah 0 tapi banknya ada di composition,
    // gunakan nilai dari composition untuk membantu user.
    double displayAvailable = ex.available;

    if (ex.cashComposition != null) {
      final matches = RegExp(r'\((.*?)\)').allMatches(ex.message);
      bool found = false;

      for (final m in matches) {
        final candidate = (m.group(1) ?? '').trim().toLowerCase();
        if (candidate.isEmpty) continue;

        // Cari match case-insensitive di composition
        for (var entry in ex.cashComposition!.entries) {
          final bankKey = entry.key.toString().trim().toLowerCase();
          if (bankKey == candidate) {
            displayAvailable = (entry.value as num).toDouble();
            found = true;
            break;
          }
        }
        if (found) break;
      }

      // Fallback: Jika tidak ada di kurung, coba cari nama bank yang ada di composition secara langsung di message
      if (!found) {
        for (var entry in ex.cashComposition!.entries) {
          final bankKey = entry.key.toString().trim();
          if (bankKey.isNotEmpty &&
              ex.message.toLowerCase().contains(bankKey.toLowerCase())) {
            displayAvailable = (entry.value as num).toDouble();
            found = true;
            break;
          }
        }
      }
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
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
                  color: titleColor(ctx),
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
              'Saldo ${isManager ? 'Kas' : 'Advance'} ${ex.userName.replaceAll('(Lain-lainnya)', '')}${targetBankName.isNotEmpty ? ' ($targetBankName)' : ''} tidak mencukupi untuk menyetujui kasbon ini.',
              style: TextStyle(color: secondaryText(ctx), fontSize: 13),
            ),
            const SizedBox(height: 16),
            insuffBalanceRow(
                ctx, 'Dibutuhkan', fmt.format(ex.needed), creamColor(ctx)),
            insuffBalanceRow(
                ctx,
                'Kas Anda (Tersedia)',
                fmt.format(ex.available),
                ex.available >= ex.needed ? AppTheme.success : AppTheme.danger),

            // Tampilkan saldo bank sebagai informasi tambahan untuk top-up
            if (displayAvailable > ex.available)
              insuffBalanceRow(ctx, 'Saldo Bank Perusahaan',
                  fmt.format(displayAvailable), AppTheme.primary),

            Divider(color: dividerColor(ctx), height: 20),
            insuffBalanceRow(ctx, 'Kekurangan di Kas Anda',
                fmt.format(ex.shortfall), Colors.orange,
                bold: true),
            if (ex.cashComposition != null &&
                ex.cashComposition!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Saldo tersedia di bank:',
                style: TextStyle(
                  color: secondaryText(ctx),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: surfaceColor(ctx),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: dividerColor(ctx)),
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
                                  color: titleColor(ctx), fontSize: 13)),
                          Text(
                            fmt.format(amt),
                            style: TextStyle(
                              color: titleColor(ctx),
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
                style: TextStyle(color: secondaryText(ctx), fontSize: 12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: secondaryText(ctx))),
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
