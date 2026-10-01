import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/utils/app_formatters.dart';
import 'package:expense_app/screens/management/asset_management_screen.dart';

Future<void> showNdpvTable(BuildContext context, AssetManagementScreenState parentState, Map<String, dynamic> a, {bool isGlobal = false}) async {
    final prov = context.read<AssetProvider>();
    final List<dynamic> breakdown = isGlobal
        ? prov.getGlobalMonthlyBreakdown()
        : (a['monthly_breakdown'] ?? []);

    final assetNames = prov.assets.map((as) => as['name'] as String).toList();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: parentState.cardColor(ctx),
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isGlobal
                  ? 'Rekapitulasi NDPV Matrix (Seluruh Aset)'
                  : 'Tabel NDPV (Nilai Sisa)',
              style: TextStyle(
                  color: parentState.creamColor(ctx), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              isGlobal
                  ? 'Rincian Per Barang - Selalu 5 Tahun ke Depan'
                  : 'Jadwal Penyusutan: ${a['name']}',
              style: TextStyle(fontSize: 12, color: parentState.secondaryTextColor(ctx)),
            ),
          ],
        ),
        content: SizedBox(
          width: isGlobal ? 1000 : 650,
          height: MediaQuery.of(ctx).size.height * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                          Colors.blue.withValues(alpha: 0.1)),
                      columns: [
                        const DataColumn(
                            label: Text('Periode',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        if (!isGlobal) ...[
                          const DataColumn(
                              label: Text('Penyusutan',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const DataColumn(
                              label: Text('Akumulasi',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const DataColumn(
                              label: Text('Nilai Sisa',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        if (isGlobal) ...[
                          const DataColumn(
                              label: Text('TOTAL NILAI',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green))),
                          // Dynamic columns for each asset
                          ...assetNames.map((name) => DataColumn(
                              label: Text(name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)))),
                        ],
                      ],
                      rows: breakdown.map((item) {
                        final bool isFuture = item['is_future'] ?? false;
                        final Color rowColor = isFuture
                            ? parentState.secondaryTextColor(ctx).withValues(alpha: 0.7)
                            : parentState.textColor(ctx);

                        return DataRow(
                          cells: [
                            DataCell(Text(item['period'].toString(),
                                style: TextStyle(
                                    color: rowColor,
                                    fontWeight: isFuture
                                        ? FontWeight.normal
                                        : FontWeight.bold))),
                            if (!isGlobal) ...[
                              DataCell(Text(
                                  AppFormatters.formatCurrency(
                                      item['depreciation']),
                                  style: TextStyle(color: rowColor))),
                              DataCell(Text(
                                  AppFormatters.formatCurrency(
                                      item['accumulated']),
                                  style: TextStyle(color: rowColor))),
                              DataCell(Text(
                                  AppFormatters.formatCurrency(
                                      item['book_value']),
                                  style: TextStyle(
                                      color: isFuture ? rowColor : Colors.green,
                                      fontWeight: FontWeight.bold))),
                            ],
                            if (isGlobal) ...[
                              DataCell(Text(
                                  AppFormatters.formatCurrency(
                                      item['total_book_value']),
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))),
                              // Value for each specific asset in this month
                              ...assetNames.map((name) {
                                final val = (item['assets']
                                        as Map<String, dynamic>)[name] ??
                                    0.0;
                                return DataCell(Text(
                                    AppFormatters.formatCurrency(val),
                                    style: TextStyle(
                                        color: val > 0
                                            ? rowColor
                                            : rowColor.withValues(
                                                alpha: 0.3))));
                              }),
                            ],
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
