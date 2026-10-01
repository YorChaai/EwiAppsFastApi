import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/widget_table_card.dart';


extension AnnualReportWidgetsDisplayTablesExt on AnnualReportScreenState {
  List<Widget> buildDisplayTables(bool useCompact) {
    if (tableDataCache.isEmpty) {
      return [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: CircularProgressIndicator(color: AppTheme.primary),
          ),
        )
      ];
    }

    final t1 = tableDataCache['t1']!;
    final t2 = tableDataCache['t2']!;
    final t3 = tableDataCache['t3']!;
    final t3a = tableDataCache['t3a']!;
    final t3b = tableDataCache['t3b']!;
    final t4a = tableDataCache['t4a']!;
    final t4b = tableDataCache['t4b']!;
    final t4c = tableDataCache['t4c']!;
    final t4d = tableDataCache['t4d']!;
    final t5 = tableDataCache['t5']!;
    final t7 = tableDataCache['t7']!;
    final t8 = tableDataCache['t8']!;
    final t9 = tableDataCache['t9']!;
    final t10 = tableDataCache['t10']!;

    return [
      if (activeSheet == 'sheet1') ...[
        if (visibleTables.contains('t1'))
          buildTableCard(
            title: 'Tabel 1: PEMASUKAN',
            headers: const [
              'Invoice Date',
              '#',
              'Detail/Description',
              'INVOICE VALUE(child=USD)',
              'INVOICE VALUE(child=IDR)',
              'Currency',
              'Currency Exchange',
              'INVOICE Number',
              'Client',
              'Receive Date',
              'AMOUNT RECEIVED(child=IDR)',
              'AMOUNT RECEIVED(child=USD)',
              'PPn(child=11%)',
              'PPH (Pasal 23)(child=2%)',
              'Biaya transfer',
              'Sumber Dana',
              'Remark',
            ],
            rows: t1.rows,
            boldRows: t1.boldRows,
            controller: hControllers['1']!,
            verticalController: vControllers['1']!,
            useCompact: useCompact,
            combineGroupMap: t1.combineGroupMap,
            mergedColumnsMap: t1.mergedColumnsMap,
            rowColors: t1.rowColors,
          ),
        if (visibleTables.contains('t2'))
          buildTableCard(
            title: 'Tabel 2: PAJAK',
            combineGroupMap: t2.combineGroupMap,
            mergedColumnsMap: t2.mergedColumnsMap,
            headers: const [
              'Date',
              '#',
              'Detail/Description',
              'INVOICE VALUE(child=USD)',
              'Transaction Value',
              'Currency',
              'Currency Exchange',
              'Transaction Value(child=IDR)',
              'PPN(child=Transaction)',
              'PPN(child=PPN)',
              'PPh (pasal 21)(child=Transaction)',
              'PPh (child=PPh - 21)',
              'PPh (pasal 23)(child=Transaction)',
              'PPh (child=PPh - 23)',
              'PPh (pasal 26)(child=Transaction)',
              'PPh (child=PPh - 26)',
              'Pemasukan Negara (pasal ???)(child=Transaction)',
              'Pemasukan Negara (child=Pajak)',
            ],
            rows: t2.rows,
            boldRows: t2.boldRows,
            controller: hControllers['2']!,
            verticalController: vControllers['2']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t3'))
          buildTableCard(
            title: 'Tabel 3: BANK STATUS',
            headers: const [
              'Invoice Date',
              '#',
              'Detail/Description',
              'Value USD',
              'Value IDR',
            ],
            rows: t3.rows,
            boldRows: t3.boldRows,
            controller: hControllers['3']!,
            verticalController: vControllers['3']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t3a'))
          buildTableCard(
            title: 'Tabel 3A: Bank Admin (Detail Item)',
            headers: const [
              'Date',
              '#',
              'Activity',
              'Source',
              'Amount',
              'Cur',
              'Rate',
              'Type',
            ],
            rows: t3a.rows,
            boldRows: t3a.boldRows,
            controller: hControllers['3a']!,
            verticalController: vControllers['3a']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t3b'))
          buildTableCard(
            title: 'Tabel 3B: Bank Admin (Pengiriman Dana)',
            headers: const [
              'Date',
              '#',
              'Activity',
              'Source',
              'Amount',
              'Cur',
              'Rate',
              'Type',
            ],
            rows: t3b.rows,
            boldRows: t3b.boldRows,
            controller: hControllers['3b']!,
            verticalController: vControllers['3b']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t3c'))
          buildTableCard(
            title: 'Tabel 3C: PENGEMBALIAN DANA (RETURNS)',
            headers: const [
              'Date',
              '#',
              'Activity',
              'Source',
              'Approved',
              'Disbursed',
              'Returned',
              'Type',
            ],
            rows: tableDataCache['t3c']!.rows,
            boldRows: tableDataCache['t3c']!.boldRows,
            controller:
                ScrollController(), // Add controllers if needed for sync
            verticalController: ScrollController(),
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t4a'))
          buildTableCard(
            title: 'Tabel 4A: PENGELUARAN',
            headers: [
              'Date',
              '#',
              'Activity',
              'Src',
              'Amount',
              'Cur',
              'Rate',
              ...(t4a.headers ?? []),
              'Sub Total',
              'Total',
              'From',
              'To',
              'Evidence',
            ],
            rows: t4a.rows,
            boldRows: t4a.boldRows,
            controller: hControllers['4a']!,
            verticalController: vControllers['4a']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t4b'))
          buildTableCard(
            title: 'Tabel 4B: PENGELUARAN (BANK)',
            headers: [
              'Date',
              '#',
              'Activity',
              'Src',
              'Amount',
              'Cur',
              'Rate',
              ...(t4b.headers ?? []),
              'Sub Total',
              'Total',
              'From',
              'To',
              'Evidence',
            ],
            rows: t4b.rows,
            boldRows: t4b.boldRows,
            controller: hControllers['4b']!,
            verticalController: vControllers['4b']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t4c'))
          buildTableCard(
            title: 'Tabel 4C: PENGELUARAN KASBON',
            headers: [
              'Date',
              '#',
              'Activity',
              'Src',
              'Amount',
              'Cur',
              'Rate',
              ...(t4c.headers ?? []),
              'Sub Total',
              'Total',
              'From',
              'To',
              'Evidence',
            ],
            rows: t4c.rows,
            boldRows: t4c.boldRows,
            controller: hControllers['4c']!,
            verticalController: vControllers['4c']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t4d'))
          buildTableCard(
            title: 'Tabel 4D: PENGELUARAN KASBON (BANK)',
            headers: [
              'Date',
              '#',
              'Activity',
              'Src',
              'Amount',
              'Cur',
              'Rate',
              ...(t4d.headers ?? []),
              'Sub Total',
              'Total',
              'From',
              'To',
              'Evidence',
            ],
            rows: t4d.rows,
            boldRows: t4d.boldRows,
            controller: hControllers['4d']!,
            verticalController: vControllers['4d']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t5'))
          buildTableCard(
            title: 'Tabel 5: ASSET REGISTER',
            headers: const [
              'Date',
              '#',
              'Code',
              'Asset Name',
              'Status',
              'Price',
              'Life',
              'Month Depr',
              'Acc Depr',
              'Book Value',
            ],
            rows: t5.rows,
            boldRows: t5.boldRows,
            controller: hControllers['5']!,
            verticalController: vControllers['5']!,
            useCompact: useCompact,
          ),
      ] else if (activeSheet == 'sheet2') ...[
        if (visibleTables.contains('t7'))
          buildTableCard(
            title: 'Tabel 7: LABA RUGI',
            headers: const ['Keterangan', 'Nilai'],
            rows: t7.rows,
            boldRows: t7.boldRows,
            controller: hControllers['7'] ?? ScrollController(),
            verticalController: vControllers['7'] ?? ScrollController(),
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t8'))
          buildTableCard(
            title: 'Tabel 8: NERACA',
            headers: const ['Keterangan', 'Nilai'],
            rows: t8.rows,
            boldRows: t8.boldRows,
            controller: hControllers['8'] ?? ScrollController(),
            verticalController: vControllers['8'] ?? ScrollController(),
            useCompact: useCompact,
          ),
      ] else if (activeSheet == 'sheet3') ...[
        if (visibleTables.contains('t9'))
          buildTableCard(
            title: 'Tabel 9: Business Summary',
            headers: const ['#', 'Items', 'Amount'],
            rows: t9.rows,
            controller: hControllers['9']!,
            verticalController: vControllers['9']!,
            useCompact: useCompact,
          ),
        if (visibleTables.contains('t10'))
          buildTableCard(
            title: 'Tabel 10: DEVIDEN',
            headers: t10.headers ?? [],
            rows: t10.rows,
            boldRows: t10.boldRows,
            controller: hControllers['10']!,
            verticalController: vControllers['10']!,
            useCompact: useCompact,
          ),
      ],
    ];
  }
}
