import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';
import 'package:expense_app/screens/management/dialog_bank_cash_log_book.dart';
import 'package:expense_app/screens/management/dialog_bank_account.dart';


extension BankManagementDialogsshowBankCashDetailModalExt
    on BankManagementScreenState {
  Future<void> showBankCashDetailModal(
      Map<String, dynamic> initialBankData) async {
    final bankId = initialBankData['id'];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Consumer<BankManagementProvider>(
        builder: (context, prov, child) {
          // Find the latest bank data from provider
          final bankData = prov.banks.firstWhere(
            (b) => b['id'] == bankId,
            orElse: () => initialBankData,
          );

          final isUsd = bankData['currency'] == 'USD';
          final bal =
              double.tryParse((bankData['real_balance'] ?? 0.0).toString()) ??
                  0.0;

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
                      color:
                          secondaryTextColor(context).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Wrap(spacing: 8, runSpacing: 8, children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit_rounded, size: 16),
                        label: const Text('Edit Bank Cash'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          showBankAccountDialog(bankData, isEditOnly: true);
                        },
                      ),
                      ElevatedButton.icon(
                        icon:
                            const Icon(Icons.account_balance_wallet, size: 16),
                        label: const Text('Kelola Cash/Uang'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.success,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            textStyle: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        onPressed: () {
                          showBankAccountDialog(bankData, isAdjustOnly: true);
                        },
                      ),
                    ])),
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  bankData['name'] ?? 'Bank Cash',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark(context)
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'No Rekening: ${bankData['account_number'] ?? 'Cash (Fisik)'} | ${bankData['currency'] ?? 'IDR'}',
                  style: TextStyle(
                      color: AppTheme.getSecondaryTextColor(context),
                      fontSize: 14),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      Text('Total Bank Cash',
                          style: TextStyle(
                              color: AppTheme.getSecondaryTextColor(context),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(
                        '${isUsd ? '\$' : 'Rp '}${NumberFormat('#,##0', 'id_ID').format(bal)}',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    showBankCashLogBookDialog(bankData);
                  },
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('Riwayat Aktivitas / Log Book'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:
                        isDark(context) ? AppTheme.card : AppTheme.lightCard,
                    foregroundColor: isDark(context)
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                    side: BorderSide(
                        color: secondaryTextColor(context)
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
}
