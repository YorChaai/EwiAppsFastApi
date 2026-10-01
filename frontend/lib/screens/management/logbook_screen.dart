import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/services/api_service.dart';
import 'package:expense_app/theme/app_theme.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => LogbookScreenState();
}

class LogbookScreenState extends State<LogbookScreen> {
  final ApiService api = ApiService();
  bool isLoading = true;
  List<dynamic> logs = [];

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    try {
      final res = await api.getOverrideLogs(itemType: 'advance');
      if (mounted) {
        setState(() {
          logs = res['logs'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat logbook: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color secondaryTextColor(BuildContext context) =>
      AppTheme.getSecondaryTextColor(context);
  Color textColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;

  Widget buildLogGridItem(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: valueColor ?? textColor(context))),
      ],
    );
  }

  Widget buildAuditTrailLogItem(
      Map<String, dynamic> log, NumberFormat currencyFormat) {
    final rawNotes = (log['notes'] ?? '').toString();
    final dateStr = log['changed_at'] != null
        ? DateFormat('dd MMM yy, HH:mm')
            .format(DateTime.parse(log['changed_at']))
        : '-';

    if (rawNotes.startsWith('JSON:')) {
      try {
        final payload =
            jsonDecode(rawNotes.substring(5)) as Map<String, dynamic>;
        final double startingBal = ((payload['starting_balance'] ??
                log['original_amount'] ??
                0.0) as num)
            .toDouble();
        final double givenAmt =
            ((payload['given_amount'] ?? payload['amount'] ?? 0.0) as num)
                .toDouble();
        final double revisedAmt =
            ((payload['revised_amount'] ?? (startingBal + givenAmt)) as num)
                .toDouble();
        final double requestedAmt = ((payload['requested_amount'] ??
                payload['amount'] ??
                givenAmt) as num)
            .toDouble();
        final String recipient =
            (payload['recipient_name'] ?? payload['target_user'] ?? '-')
                .toString();
        final String manager =
            (payload['manager_name'] ?? payload['performer'] ?? '-').toString();
        String reason =
            (payload['reason'] ?? payload['notes'] ?? '-').toString();
        reason = reason.replaceAll(RegExp(r'\s*\(Ref: #\d+\)'), '');
        reason = reason.replaceAll(RegExp(r'\(Settlement #\d+:\s*'), '(');
        reason = reason.replaceAll(RegExp(r'Settlement #\d+:\s*'), '');
        final List<dynamic>? allocations = payload['allocations'];
        String? bankName = (payload['source_bank'] ??
                payload['hutang_bank_name'] ??
                payload['bank_name'] ??
                payload['target_bank'])
            ?.toString();

        if (bankName == null ||
            bankName.contains('Plafon Virtual') ||
            bankName.contains('Bank Virtual') ||
            bankName.contains('Lain-lainnya') ||
            bankName == '-') {
          if (allocations != null && allocations.isNotEmpty) {
            final allocBanks = allocations
                .map((a) => (a is Map ? (a['bank_name'] ?? '') : '').toString())
                .where((n) =>
                    n.isNotEmpty &&
                    !n.contains('Plafon Virtual') &&
                    !n.contains('Lain-lainnya') &&
                    n != '-')
                .toList();
            if (allocBanks.isNotEmpty) {
              bankName = allocBanks.join(', ');
            }
          }
          if (bankName == null ||
              bankName.contains('Plafon Virtual') ||
              bankName.contains('Lain-lainnya') ||
              bankName == '-') {
            if (payload['source_bank'] != null &&
                !payload['source_bank'].toString().contains('Plafon Virtual') &&
                !payload['source_bank'].toString().contains('Lain-lainnya') &&
                payload['source_bank'] != '-') {
              bankName = payload['source_bank'].toString();
            } else if (payload['hutang_bank_name'] != null &&
                !payload['hutang_bank_name'].toString().contains('Plafon Virtual') &&
                payload['hutang_bank_name'] != '-') {
              bankName = payload['hutang_bank_name'].toString();
            } else if (payload['target_bank'] != null &&
                !payload['target_bank'].toString().contains('Plafon Virtual') &&
                payload['target_bank'] != '-') {
              bankName = payload['target_bank'].toString();
            }
          }
        }

        String titleText = reason;
        final docName = payload['document_name']?.toString();
        if (docName != null && docName.isNotEmpty) {
          if (reason.toLowerCase().contains('kasbon') && !titleText.contains(docName)) {
            titleText = '$reason: $docName';
          } else if (!titleText.contains(docName)) {
            titleText = '$reason ($docName)';
          }
        }

        final String type = (payload['type'] ?? '').toString();

        String flowHeader = '';
        Color amtColor = AppTheme.primary;
        String displayAmtPrefix = '';

        if (type == 'rebalance') {
          if (givenAmt >= 0) {
            flowHeader = 'Bank Cash ➔ Saldo Virtual (Top Up)';
            amtColor = AppTheme.success;
            displayAmtPrefix = '+';
          } else {
            flowHeader = 'Saldo Virtual ➔ Bank Cash (Penarikan)';
            amtColor = AppTheme.danger;
            displayAmtPrefix = '-';
          }
        } else if (type == 'disbursement') {
          flowHeader = bankName != null && bankName.isNotEmpty
              ? 'Bank Advance ($bankName) ➔ Pencairan Kasbon'
              : 'Bank Advance ➔ Pencairan Kasbon';
          amtColor = AppTheme.danger;
          displayAmtPrefix = '-';
        } else if (type == 'return') {
          flowHeader = 'Pengembalian Sisa Kasbon ➔ Saldo Advance';
          amtColor = AppTheme.success;
          displayAmtPrefix = '+';
        } else if (type == 'netting') {
          flowHeader = 'Hutang Karyawan ➔ Settlement ➔ Bank Cash';
          amtColor = AppTheme.danger;
          displayAmtPrefix = '-';
        } else if (type == 'withdrawal') {
          flowHeader = 'Saldo Virtual ➔ Bank Cash (Penarikan)';
          amtColor = AppTheme.danger;
          displayAmtPrefix = '-';
        } else if (type == 'reversal') {
          flowHeader = 'Pembatalan ➔ Kembali ke Draft';
          amtColor = Colors.orange;
          displayAmtPrefix = '+';
        } else if (type == 'settlement_combined') {
          final double nettingDeduction =
              (payload['netting_deduction'] as num?)?.toDouble() ?? 0.0;
          final double cashDisbursed =
              (payload['cash_disbursed'] as num?)?.toDouble() ?? 0.0;

          final bLabel = (bankName != null && bankName.isNotEmpty) ? ' ($bankName)' : '';

          if (nettingDeduction > 0 && cashDisbursed > 0) {
            flowHeader = 'Hutang Karyawan$bLabel & Kas Riil ➔ Settlement';
          } else if (nettingDeduction > 0 && cashDisbursed <= 0) {
            flowHeader = 'Hutang Karyawan$bLabel ➔ Settlement';
          } else {
            flowHeader = 'Reimbursement Pribadi ➔ Settlement ➔ Bank Cash$bLabel';
          }

          amtColor = AppTheme.danger;
          displayAmtPrefix = '-';
        }

        double mainDisplayAmt = givenAmt;
        if (type == 'settlement_combined') {
          mainDisplayAmt =
              (payload['total_settlement'] as num?)?.toDouble() ?? 0.0;
        }

        final double? exRate = payload['exchange_rate'] != null
            ? (payload['exchange_rate'] as num).toDouble()
            : null;

        final List<Widget> detailRows = [];

        if (type == 'settlement_combined') {
          detailRows.add(Text(
              'Total Settlement: ${currencyFormat.format(payload['total_settlement'] ?? 0)}',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold)));
          detailRows.add(const SizedBox(height: 4));
          if (allocations != null && allocations.isNotEmpty) {
            for (var alloc in allocations) {
              if (alloc is! Map) continue;
              final String bName = (alloc['bank_name'] ?? 'Bank').toString();
              final double ded = (alloc['deduction'] as num?)?.toDouble() ?? 0.0;
              final double? startH = (alloc['starting_hutang'] as num?)?.toDouble();
              final double? remH = (alloc['remaining_hutang'] as num?)?.toDouble();

              detailRows.add(Text(
                'Potong $bName: ${currencyFormat.format(ded)}',
                style: const TextStyle(fontSize: 11, color: AppTheme.danger),
              ));
              if (startH != null && remH != null) {
                detailRows.add(Text(
                  'Sisa Hutang ($bName): ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(remH)}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                ));
              } else {
                detailRows.add(Text(
                  'Sisa Hutang ($bName): ${currencyFormat.format(ded)} ➔ Rp 0',
                  style: const TextStyle(fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                ));
              }
              detailRows.add(const SizedBox(height: 2));
            }
          } else if ((payload['netting_deduction'] ?? 0) > 0) {
            detailRows.add(Text(
                'Potong Hutang Kasbon: ${currencyFormat.format(payload['netting_deduction'])}',
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.danger)));
          }
          if ((payload['cash_disbursed'] ?? 0) > 0) {
            detailRows.add(Text(
                'Diberikan Tunai: ${currencyFormat.format(payload['cash_disbursed'])}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('starting_hutang') &&
              payload['starting_hutang'] != null &&
              payload['remaining_hutang'] != null) {
            final startH = (payload['starting_hutang'] as num).toDouble();
            final remH = (payload['remaining_hutang'] as num).toDouble();
            detailRows.add(Text(
                'Total Hutang Keseluruhan: ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(remH)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          } else if (payload.containsKey('hutang') &&
              payload['hutang'] != null &&
              payload['hutang'] > 0.01) {
            final currentH = (payload['hutang'] as num).toDouble();
            final netting = (payload['netting_deduction'] as num?)?.toDouble() ?? 0.0;
            if (netting > 0) {
              final startH = currentH + netting;
              detailRows.add(Text(
                  'Total Hutang Keseluruhan: ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(currentH)}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.danger,
                      fontWeight: FontWeight.bold)));
            } else {
              detailRows.add(Text(
                  'Total Hutang Keseluruhan: ${currencyFormat.format(currentH)}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.danger,
                      fontWeight: FontWeight.bold)));
            }
          }
        } else if (type == 'reversal') {
          detailRows.add(Text(
              'Total Dibatalkan: ${currencyFormat.format(givenAmt + ((payload['cash_restored'] as num?)?.toDouble() ?? 0.0))}',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold)));
          detailRows.add(const SizedBox(height: 4));
          if (allocations != null && allocations.isNotEmpty) {
            for (var alloc in allocations) {
              if (alloc is! Map) continue;
              final String bName = (alloc['bank_name'] ?? 'Bank').toString();
              final double amt = (alloc['amount'] ?? alloc['deduction'] ?? 0.0).toDouble();
              final double? startH = (alloc['starting_hutang'] as num?)?.toDouble();
              final double? remH = (alloc['remaining_hutang'] as num?)?.toDouble();

              if (startH != null && remH != null) {
                detailRows.add(Text(
                  'Hutang Kasbon Kembali ($bName): ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(remH)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                ));
              } else {
                detailRows.add(Text(
                  'Hutang Kasbon Kembali ($bName): Rp 0 ➔ ${currencyFormat.format(amt)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                ));
              }
              detailRows.add(const SizedBox(height: 2));
            }
          } else if (((payload['hutang_restored'] as num?)?.toDouble() ?? 0.0) > 0) {
            final double hutangRestored = (payload['hutang_restored'] as num).toDouble();
            final bName = (bankName != null && bankName.isNotEmpty && !bankName.contains('Plafon Virtual')) ? ' ($bankName)' : '';
            detailRows.add(Text(
                'Hutang Kasbon Kembali$bName: Rp 0 ➔ ${currencyFormat.format(hutangRestored)}',
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold)));
          }
          if (((payload['cash_restored'] as num?)?.toDouble() ?? 0.0) > 0) {
            detailRows.add(Text(
                'Uang Kembali ke Kas Perusahaan: ${currencyFormat.format((payload['cash_restored'] as num?)?.toDouble())}',
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('starting_hutang') &&
              payload['starting_hutang'] != null &&
              payload['remaining_hutang'] != null) {
            final startH = (payload['starting_hutang'] as num).toDouble();
            final remH = (payload['remaining_hutang'] as num).toDouble();
            detailRows.add(Text(
                'Total Hutang Keseluruhan: ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(remH)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          } else if (payload.containsKey('hutang') &&
              payload['hutang'] != null &&
              payload['hutang'] > 0.01) {
            final currentH = (payload['hutang'] as num).toDouble();
            final hutangRestored = (payload['hutang_restored'] as num?)?.toDouble() ?? 0.0;
            if (hutangRestored > 0) {
              final startH = currentH > hutangRestored ? (currentH - hutangRestored) : 0.0;
              detailRows.add(Text(
                  'Total Hutang Keseluruhan: ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(currentH)}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.danger,
                      fontWeight: FontWeight.bold)));
            } else {
              detailRows.add(Text(
                  'Total Hutang Keseluruhan: ${currencyFormat.format(currentH)}',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.danger,
                      fontWeight: FontWeight.bold)));
            }
          }
        } else if (allocations != null && allocations.isNotEmpty) {
          detailRows.addAll(allocations.map((alloc) => Text(
              'Potong ${alloc['bank_name'] ?? 'Bank'}: ${currencyFormat.format((alloc['deduction'] ?? 0.0).toDouble())}',
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.danger))));
        } else {
          if (type != 'reversal' &&
              requestedAmt > 0 &&
              requestedAmt != givenAmt) {
            detailRows.add(Text(
                'Diminta: ${currencyFormat.format(requestedAmt)}',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('hutang_bank') &&
              payload['hutang_bank'] != null) {
            final double hBank = (payload['hutang_bank'] as num).toDouble();
            final String hBankName =
                (payload['hutang_bank_name'] ?? bankName ?? 'Bank').toString();
            detailRows.add(Text(
                'Sisa Hutang ($hBankName): ${currencyFormat.format(hBank)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('hutang') &&
              payload['hutang'] != null &&
              payload['hutang'] > 0.01) {
            final String label = payload.containsKey('hutang_bank')
                ? 'Total Hutang Keseluruhan: '
                : 'Total Hutang Menyeluruh: ';
            detailRows.add(Text(
                '$label${currencyFormat.format(payload['hutang'])}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          }
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppTheme.getSecondaryTextColor(context)
                      .withValues(alpha: 0.15)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Material(
              color: cardColor(context),
              child: ExpansionTile(
                key: PageStorageKey(log['id'] ?? log.hashCode),
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                childrenPadding:
                    const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dateStr,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: AppTheme.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            titleText,
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          if (payload.containsKey('document_name') &&
                              payload['document_name'] != null &&
                              !titleText.contains(payload['document_name'].toString())) ...[
                            const SizedBox(height: 2),
                            Text(
                              payload['document_name'].toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppTheme.getSecondaryTextColor(context)),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$displayAmtPrefix ${currencyFormat.format(mainDisplayAmt.abs())}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: amtColor,
                          fontSize: 14),
                    ),
                  ],
                ),
                children: [
                  Divider(
                      color:
                          secondaryTextColor(context).withValues(alpha: 0.1),
                      height: 16),
                  const SizedBox(height: 4),
                  if (flowHeader.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: amtColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border:
                            Border.all(color: amtColor.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            type.contains('reversal')
                                ? Icons.refresh
                                : Icons.swap_horiz,
                            size: 16,
                            color: amtColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              flowHeader,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: amtColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLogGridItem('Pemberi', manager),
                            const SizedBox(height: 8),
                            buildLogGridItem('Penerima', recipient),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (bankName != null) ...[
                              buildLogGridItem('Bank Cash', bankName),
                              const SizedBox(height: 8),
                            ],
                            buildLogGridItem('Saldo Berubah',
                                '${currencyFormat.format(startingBal)} ➔ ${currencyFormat.format(revisedAmt)}',
                                valueColor: (revisedAmt >= startingBal)
                                    ? AppTheme.success
                                    : AppTheme.danger),
                            if (exRate != null && exRate != 1.0) ...[
                              const SizedBox(height: 8),
                              buildLogGridItem('Kurs',
                                  '${currencyFormat.format(exRate)}/USD',
                                  valueColor: Colors.amber),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (detailRows.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.getSecondaryTextColor(context)
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailRows,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      } catch (_) {}
    }

    // Default Legacy logbook rendering
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: AppTheme.getSecondaryTextColor(context)
                .withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Oleh: ${log['changed_by_name'] ?? 'Manager'}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                dateStr,
                style: TextStyle(
                    color: AppTheme.getSecondaryTextColor(context),
                    fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: TextStyle(
                  color: isDark(context)
                      ? AppTheme.textPrimary
                      : AppTheme.lightTextPrimary,
                  fontSize: 12),
              children: [
                const TextSpan(text: 'Mengubah nominal: '),
                TextSpan(
                  text: currencyFormat.format(log['original_amount'] ?? 0),
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: AppTheme.danger),
                ),
                const TextSpan(text: ' ➔ '),
                TextSpan(
                  text: currencyFormat.format(log['revised_amount'] ?? 0),
                  style: const TextStyle(
                      color: AppTheme.success, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (rawNotes.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Alasan: "$rawNotes"',
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.accent,
                  fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor:
          isDark(context) ? AppTheme.surface : AppTheme.lightSurface,
      appBar: AppBar(
        title: const Text('Logbook Bank Advance',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: isDark(context) ? AppTheme.card : AppTheme.lightCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada riwayat override nominal.',
                    style:
                        TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    return buildAuditTrailLogItem(
                        logs[index], currencyFormat);
                  },
                ),
    );
  }
}
