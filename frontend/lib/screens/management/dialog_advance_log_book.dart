import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/services/api_service.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';

extension BankManagementDialogsshowAdvanceLogBookDialogExt
    on BankManagementScreenState {
  Future<void> showAdvanceLogBookDialog(Map<String, dynamic> user) =>
      showAdvanceLogBookDialogHelper(context, user);
}

Future<void> showAdvanceLogBookDialogHelper(
  BuildContext context,
  Map<String, dynamic> user,
) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    constraints: const BoxConstraints(maxWidth: double.infinity),
    builder: (ctx) => AdvanceLogBookModal(user: user),
  );
}

class AdvanceLogBookModal extends StatefulWidget {
  final Map<String, dynamic> user;

  const AdvanceLogBookModal({super.key, required this.user});

  @override
  State<AdvanceLogBookModal> createState() => _AdvanceLogBookModalState();
}

class _AdvanceLogBookModalState extends State<AdvanceLogBookModal> {
  final ApiService api = ApiService();
  bool isFetchingLogs = true;
  bool isFullscreen = false;
  List<dynamic> logs = [];
  final ScrollController scrollController = ScrollController();
  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchLogs() async {
    try {
      final res = await api.getOverrideLogs(
        itemType: 'advance',
        userId: widget.user['id'],
      );
      if (mounted) {
        final List<dynamic> loaded = res['logs'] ?? [];
        loaded.sort((a, b) {
          final da = DateTime.tryParse(a['changed_at'] ?? '') ?? DateTime(2000);
          final db = DateTime.tryParse(b['changed_at'] ?? '') ?? DateTime(2000);
          return db.compareTo(da);
        });
        setState(() {
          logs = loaded;
          isFetchingLogs = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          isFetchingLogs = false;
        });
      }
    }
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
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

  Widget buildAuditTrailLogItem(Map<String, dynamic> log) {
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

        final String docName = (payload['document_name'] ?? '').toString();
        final String type = (payload['type'] ?? '').toString();
        final String sourceBank =
            (payload['source_bank'] ?? payload['source'] ?? '').toString();
        final String targetBank =
            (payload['target_bank'] ?? payload['target'] ?? '').toString();
        final String bankName = (payload['bank_name'] ?? '').toString();
        final allocations = payload['allocations'] as List<dynamic>?;

        final bool isTransfer =
            type == 'transfer' || type == 'topup' || type == 'return';
        final bool isDeduction = type == 'deduction' || type == 'pencairan';
        final bool isReversal = type == 'reversal';
        final bool isSettlement = type == 'settlement_combined';

        Color badgeColor = AppTheme.primary;
        String badgeText = reason;
        if (isTransfer) {
          badgeColor = Colors.teal;
          badgeText = '$sourceBank ➔ $targetBank';
        } else if (isDeduction) {
          badgeColor = AppTheme.danger;
          badgeText = '$sourceBank ➔ $targetBank';
        } else if (isSettlement) {
          badgeColor = AppTheme.danger;
          badgeText = sourceBank.isNotEmpty && !sourceBank.contains('Plafon Virtual')
              ? 'Hutang Karyawan ($sourceBank) & Kas Riil ➔ Settlement'
              : 'Reimbursement Pribadi ➔ Settlement ➔ Bank Cash ($targetBank)';
        } else if (isReversal) {
          badgeColor = Colors.orange;
          badgeText = 'Pembatalan ➔ Kembali ke Draft';
        }

        final dark = isDark(context);

        List<Widget> detailRows = [];
        if (type == 'settlement_combined') {
          detailRows.add(Text(
              'Total Settlement: ${currencyFormat.format(givenAmt + ((payload['cash_disbursed'] as num?)?.toDouble() ?? 0.0))}',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold)));
          detailRows.add(const SizedBox(height: 4));
          if (allocations != null && allocations.isNotEmpty) {
            for (var alloc in allocations) {
              if (alloc is! Map) continue;
              final String bName = (alloc['bank_name'] ?? 'Bank').toString();
              final double amt = (alloc['deduction'] ?? alloc['amount'] ?? 0.0).toDouble();
              final double? startH = (alloc['starting_hutang'] as num?)?.toDouble();
              final double? remH = (alloc['remaining_hutang'] as num?)?.toDouble();

              detailRows.add(Text(
                'Potong $bName: ${currencyFormat.format(amt)}',
                style: const TextStyle(fontSize: 11, color: AppTheme.danger),
              ));
              if (startH != null && remH != null) {
                detailRows.add(Text(
                  'Sisa Hutang ($bName): ${currencyFormat.format(startH)} ➔ ${currencyFormat.format(remH)}',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.danger, fontWeight: FontWeight.bold),
                ));
              }
              detailRows.add(const SizedBox(height: 2));
            }
          }
          if (((payload['cash_disbursed'] as num?)?.toDouble() ?? 0.0) > 0) {
            detailRows.add(Text(
                'Diberikan Tunai: ${currencyFormat.format((payload['cash_disbursed'] as num?)?.toDouble())}',
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
            detailRows.add(Text(
                'Total Hutang Keseluruhan: ${currencyFormat.format(currentH)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
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
            final bName = (bankName.isNotEmpty && !bankName.contains('Plafon Virtual')) ? ' ($bankName)' : '';
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
          if (requestedAmt != givenAmt && requestedAmt > 0) {
            detailRows.add(Text(
                'Diajukan: ${currencyFormat.format(requestedAmt)}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    decoration: TextDecoration.lineThrough)));
          }
          if (payload.containsKey('plafon_restored') &&
              payload['plafon_restored'] != null &&
              payload['plafon_restored'] > 0.01) {
            detailRows.add(Text(
                'Plafon Kembali: ${currencyFormat.format((payload['plafon_restored'] as num).toDouble())}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.success,
                    fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('hutang_restored') &&
              payload['hutang_restored'] != null &&
              payload['hutang_restored'] > 0.01) {
            detailRows.add(Text(
                'Hutang Kasbon Kembali: ${currencyFormat.format((payload['hutang_restored'] as num).toDouble())}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          }
          if (payload.containsKey('hutang') &&
              payload['hutang'] != null &&
              payload['hutang'] > 0.01) {
            detailRows.add(Text(
                'Total Hutang Keseluruhan: ${currencyFormat.format((payload['hutang'] as num).toDouble())}',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.danger,
                    fontWeight: FontWeight.bold)));
          }
        }

        final double amountToDisplay = isReversal
            ? ((payload['plafon_restored'] ?? 0.0) as num).toDouble()
            : givenAmt;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: (dark
                        ? AppTheme.textSecondary
                        : AppTheme.lightTextSecondary)
                    .withValues(alpha: 0.15)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: dark ? AppTheme.card : AppTheme.lightCard,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  docName.isNotEmpty ? '$reason ($docName)' : reason,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: dark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                  ),
                ),
                trailing: Text(
                  (isDeduction || isSettlement
                          ? '- '
                          : (isTransfer || isReversal ? '+ ' : '')) +
                      currencyFormat.format(amountToDisplay),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isDeduction || isSettlement
                        ? AppTheme.danger
                        : (isTransfer || isReversal
                            ? (amountToDisplay == 0
                                ? AppTheme.textSecondary
                                : Colors.orange)
                            : AppTheme.success),
                  ),
                ),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: badgeColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                            isReversal
                                ? Icons.restart_alt_rounded
                                : (isTransfer
                                    ? Icons.swap_horiz_rounded
                                    : (isSettlement
                                        ? Icons.sync_alt_rounded
                                        : Icons.account_balance_wallet_outlined)),
                            size: 14,
                            color: badgeColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            badgeText,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: badgeColor),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
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
                            if (bankName.isNotEmpty &&
                                !bankName.contains('Plafon Virtual')) ...[
                              buildLogGridItem('Bank Cash', bankName),
                              const SizedBox(height: 8),
                            ],
                            buildLogGridItem('Saldo Berubah',
                                '${currencyFormat.format(startingBal)} ➔ ${currencyFormat.format(revisedAmt)}',
                                valueColor: isReversal
                                    ? Colors.orange
                                    : (isDeduction
                                        ? AppTheme.danger
                                        : AppTheme.success)),
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
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {}, // Prevent dismissal when clicking inside content
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isFullscreen
                ? MediaQuery.of(context).size.width
                : (MediaQuery.of(context).size.width > 640
                    ? 640
                    : MediaQuery.of(context).size.width),
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
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                            'Riwayat Aktivitas / Log Book (Advance)',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16)),
                      ),
                      IconButton(
                        icon: Icon(isFullscreen
                            ? Icons.fullscreen_exit_rounded
                            : Icons.fullscreen_rounded),
                        onPressed: () {
                          setState(() {
                            isFullscreen = !isFullscreen;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isFetchingLogs)
                    const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator()))
                  else if (logs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Center(
                          child: Text(
                              'Belum ada riwayat aktivitas kasbon.',
                              style: TextStyle(
                                  color: AppTheme.getSecondaryTextColor(
                                      context),
                                  fontSize: 13))),
                    )
                  else
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      constraints: BoxConstraints(
                          minHeight: isFullscreen
                              ? MediaQuery.of(context).size.height * 0.85
                              : 0,
                          maxHeight: isFullscreen
                              ? MediaQuery.of(context).size.height * 0.85
                              : MediaQuery.of(context).size.height * 0.6),
                      child: AppScrollbar(
                        controller: scrollController,
                        child: ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: logs.length,
                          itemBuilder: (c, idx) =>
                              buildAuditTrailLogItem(logs[idx]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
