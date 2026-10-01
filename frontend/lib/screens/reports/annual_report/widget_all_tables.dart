import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_state.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_tables.dart';
import 'package:expense_app/screens/reports/annual_report/widget_table4_a_and4_b.dart';
import 'package:expense_app/screens/reports/annual_report/widget_table4_c_and4_d.dart';


extension AnnualReportTablesAllTablesExt on AnnualReportScreenState {
  void processAllTables() {
    if (reportData == null) return;

    tableDataCache.clear();

    // 1. REVENUE (Tabel 1)
    final revenueData = asListMap(reportData?['revenue']?['data']);
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final unallocatedYellow = isDarkTheme
        ? const Color(0xFF5A4D00)
        : const Color(0xFFFFF9C4);

    final Map<int, Color> t1RowColors = {};
    for (int i = 0; i < revenueData.length; i++) {
      if (revenueData[i]['bank_id'] == null) {
        t1RowColors[i] = unallocatedYellow;
      }
    }

    final List<List<String>> revenueRows = revenueData
        .asMap()
        .entries
        .map(
          (e) => [
            fmtDate(e.value['invoice_date']),
            '${e.key + 1}',
            (e.value['description']?.toString() ?? '').isEmpty
                ? '-'
                : e.value['description'].toString(),
            // Dual Value: USD & IDR
            fmtPlain(e.value['invoice_value_usd']),
            fmtPlain(e.value['invoice_value_idr']),
            e.value['currency']?.toString() ?? 'IDR',
            toDouble(e.value['currency_exchange'] ?? 1).toStringAsFixed(0),
            (e.value['invoice_number']?.toString() ?? '').isEmpty
                ? '-'
                : e.value['invoice_number'].toString(),
            (e.value['client']?.toString() ?? '').isEmpty
                ? '-'
                : e.value['client'].toString(),
            fmtDate(e.value['receive_date']),
            // Dual Received: IDR & USD
            fmtPlain(e.value['amount_received_idr']),
            fmtPlain(e.value['amount_received_usd']),
            fmtMoney(e.value['ppn']),
            // Interactive PPH 23 Selection
            '[TOGGLE_TAX]:${e.value['id']}§${fmtMoney(e.value['pph_23'])}§${e.value['is_selected_for_tax_offset'] ?? true}',
            fmtMoney(e.value['transfer_fee']),
            // Sumber Dana (Bank Cash)
            () {
              final raw = e.value['bank_name']?.toString() ??
                  (e.value['bank'] is Map
                      ? (e.value['bank'] as Map)['name']?.toString()
                      : null);
              return (raw == null || raw.trim().isEmpty) ? '-' : raw.trim();
            }(),
            (e.value['remark']?.toString() ?? '').isEmpty
                ? '-'
                : e.value['remark'].toString(),
          ],
        )
        .toList();
    revenueRows.add([
      'TOTAL',
      '',
      '',
      fmtPlain(reportData?['revenue']?['total_invoice_value_usd'] ?? 0),
      fmtPlain(reportData?['revenue']?['total_invoice_value_idr'] ?? 0),
      '',
      '',
      '',
      '',
      '',
      fmtPlain(reportData?['revenue']?['total_amount_received_idr'] ?? 0),
      fmtPlain(reportData?['revenue']?['total_amount_received_usd'] ?? 0),
      fmtMoney(reportData?['revenue']?['total_ppn'] ?? 0),
      fmtMoney(reportData?['revenue']?['total_pph23'] ?? 0),
      '',
      '', // Sumber Dana
      '', // Remark
    ]);
    final revenueCombineGroups =
        reportData?['revenue']?['combine_groups'] as List<dynamic>? ?? [];
    final t1CombineMap =
        buildCombineGroupMap(revenueData, revenueCombineGroups);
    final t1MergedMap =
        buildMergedColumnsMap(revenueData, revenueCombineGroups);
    tableDataCache['t1'] = ReportTableData(
      rows: revenueRows,
      combineGroupMap: t1CombineMap,
      mergedColumnsMap: t1MergedMap,
      rowColors: t1RowColors,
    );

    // 2. TAX (Tabel 2)
    final taxData = asListMap(reportData?['tax']?['data']);
    final List<List<String>> taxRows = taxData.asMap().entries.map((e) {
      final transVal = toDouble(e.value['transaction_value'] ?? 0);
      final invValUsd = toDouble(e.value['invoice_value_usd'] ?? 0);
      final rate = toDouble(e.value['currency_exchange'] ?? 1);

      // Use saved IDR if available (2026 schema), otherwise calculate
      final savedIdr = e.value['transaction_value_idr'];
      final transValIdr =
          (savedIdr != null) ? toDouble(savedIdr) : (transVal * rate);

      final ppn = toDouble(e.value['ppn'] ?? 0);
      final pph21 = toDouble(e.value['pph_21'] ?? 0);
      final pph23 = toDouble(e.value['pph_23'] ?? 0);
      final pph26 = toDouble(e.value['pph_26'] ?? 0);

      final ppnBase = toDouble(e.value['ppn_base'] ?? 0);
      final pph21Base = toDouble(e.value['pph_21_base'] ?? 0);
      final pph23Base = toDouble(e.value['pph_23_base'] ?? 0);
      final pph26Base = toDouble(e.value['pph_26_base'] ?? 0);
      final pemasukanNegaraBase =
          toDouble(e.value['pemasukan_negara_base'] ?? 0);
      final pemasukanNegara = toDouble(e.value['pemasukan_negara'] ?? 0);

      return [
        fmtDate(e.value['date']),
        '${e.key + 1}',
        ((e.value['description']?.toString() ?? '').trim().isEmpty)
            ? ''
            : e.value['description'].toString(),
        invValUsd > 0 ? fmtPlain(invValUsd) : '',
        transVal > 0 ? fmtPlain(transVal) : '',
        e.value['currency']?.toString() ?? 'IDR',
        rate.toStringAsFixed(0),
        (transValIdr > 0 &&
                    (e.value['currency']?.toString() ?? 'IDR').toUpperCase() !=
                        'IDR' ||
                savedIdr != null)
            ? fmtPlain(transValIdr)
            : '',
        ppnBase > 0 ? fmtMoney(ppnBase) : '',
        ppn > 0 ? fmtMoney(ppn) : '',
        pph21Base > 0 ? fmtMoney(pph21Base) : '',
        pph21 > 0 ? fmtMoney(pph21) : '',
        pph23Base > 0 ? fmtMoney(pph23Base) : '',
        pph23 > 0 ? fmtMoney(pph23) : '',
        pph26Base > 0 ? fmtMoney(pph26Base) : '',
        pph26 > 0 ? fmtMoney(pph26) : '',
        pemasukanNegaraBase > 0 ? fmtMoney(pemasukanNegaraBase) : '',
        pemasukanNegara > 0 ? fmtMoney(pemasukanNegara) : '',
      ];
    }).toList();
    taxRows.add([
      'TOTAL',
      '',
      '',
      '',
      '',
      '',
      '',
      fmtPlain(reportData?['tax']?['total_trans_val_idr'] ?? 0),
      fmtMoney(reportData?['tax']?['total_ppn_base'] ?? 0),
      fmtMoney(reportData?['tax']?['total_ppn'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph21_base'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph21'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph23_base'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph23'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph26_base'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pph26'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pemasukan_negara_base'] ?? 0),
      fmtMoney(reportData?['tax']?['total_pemasukan_negara'] ?? 0),
    ]);
    final taxCombineGroups =
        reportData?['tax']?['combine_groups'] as List<dynamic>? ?? [];
    final t2CombineMap = buildCombineGroupMap(taxData, taxCombineGroups);
    final t2MergedMap = buildMergedColumnsMap(taxData, taxCombineGroups);
    tableDataCache['t2'] = ReportTableData(
      rows: taxRows,
      combineGroupMap: t2CombineMap,
      mergedColumnsMap: t2MergedMap,
    );

    // 3. BANK STATUS (Tabel 3)
    tableDataCache['t3'] =
        ReportTableData(rows: buildTable3Rows(), boldRows: table3BoldRows);

    // 3A. BIAYA ADMIN (Tabel 3A)
    tableDataCache['t3a'] = ReportTableData(
      rows: buildTable3aRows(),
      boldRows: table3aBoldRows,
    );

    // 4. EXPENSES (Tabel 4 & 5)
    processTable4AAnd4B();
    processTable4CAnd4D();

    // 6. ASSET REGISTER (Tabel 5)
    tableDataCache['t5'] = ReportTableData(rows: buildTable6Rows());

    // 7 & 8. PROFIT LOSS & NERACA
    tableDataCache['t7'] = ReportTableData(
      rows: buildTable7Rows(),
      boldRows: Set.from(profitLossBoldRows),
    );
    tableDataCache['t8'] = ReportTableData(
      rows: buildTable8Rows(),
      boldRows: Set.from(neracaBoldRows),
    );

    // 9. DEVIDEN (Tabel 10)
    tableDataCache['t10'] = ReportTableData(
      rows: buildTable10Rows(),
      headers: const ['#', 'Nama Lengkap', 'Rp', 'Amount'],
    );

    // 10. BUSINESS SUMMARY
    tableDataCache['t9'] = ReportTableData(rows: buildTable9Rows());

    // 3B. BIAYA ADMIN BANK (DIRECT)
    tableDataCache['t3b'] = ReportTableData(
      rows: buildTable11Rows(),
      boldRows: table3bBoldRows,
    );

    // 3C. RETURNED FUNDS (Tabel 3C)
    final returnedFundsData = asListMap(
      reportData?['returned_funds']?['data'],
    );
    final List<List<String>> returnedFundsRows = [];
    table3cBoldRows.clear();

    if (returnedFundsData.isNotEmpty) {
      // Group by Bank
      final Map<String, List<Map<String, dynamic>>> grouped = {};
      for (var d in returnedFundsData) {
        String bank = (d['bank_name']?.toString() ?? '-').trim();
        if (bank.isEmpty || bank == 'None' || bank.toLowerCase() == 'null') {
          bank = '-';
        }
        grouped.putIfAbsent(bank, () => []).add(d);
      }

      int globalCounter = 0;
      for (var bank in grouped.keys.toList()..sort()) {
        table3cBoldRows.add(returnedFundsRows.length);
        returnedFundsRows.add([
          '',
          '',
          'Bank : $bank',
          '',
          '',
          '',
          '',
          '',
        ]);

        final items = grouped[bank]!;
        for (var item in items) {
          globalCounter++;
          returnedFundsRows.add([
            fmtDate(item['date']),
            '$globalCounter',
            item['title'] ?? '',
            item['bank_name'] ??
                item['return_source'] ??
                item['disbursement_source'] ??
                '',
            fmtMoney(item['approved_amount'] ?? 0).replaceFirst('Rp ', ''),
            fmtMoney(item['disbursed_amount'] ?? 0).replaceFirst('Rp ', ''),
            fmtMoney(item['returned_amount'] ?? 0).replaceFirst('Rp ', ''),
            (item['type'] ?? 'SINGLE').toString().toUpperCase(),
          ]);
        }
      }

      final totalRet = reportData?['returned_funds']?['total_returned'] ?? 0;
      table3cBoldRows.add(returnedFundsRows.length);
      returnedFundsRows.add([
        'TOTAL',
        '',
        '',
        '',
        '',
        '',
        fmtMoney(totalRet).replaceFirst('Rp ', ''),
        '',
      ]);
    }

    tableDataCache['t3c'] = ReportTableData(
      rows: returnedFundsRows,
      boldRows: table3cBoldRows,
    );
  }
}
