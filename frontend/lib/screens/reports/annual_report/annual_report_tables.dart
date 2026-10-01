import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';


extension AnnualReportTablesExt on AnnualReportScreenState {
  List<String> getAvailableTableIds(String sheet) {
    switch (sheet) {
      case 'sheet1':
        return [
          't1',
          't2',
          't3',
          't3a',
          't3b',
          't3c',
          't4a',
          't4b',
          't4c',
          't4d',
          't5'
        ];
      case 'sheet2':
        return ['t7', 't8'];
      case 'sheet3':
        return ['t9', 't10'];
      default:
        return [
          't1',
          't2',
          't3',
          't3a',
          't3b',
          't3c',
          't4a',
          't4b',
          't4c',
          't4d',
          't5'
        ];
    }
  }

  List<List<String>> buildTable7Rows() {
    final divData = reportData?['dividend'] ?? {};
    final rawProfitLossExp =
        (reportData?['profit_loss_expenses'] as Map?) ?? {};
    final rawAdvProfitLossExp =
        (reportData?['advance_profit_loss_expenses'] as Map?) ?? {};

    // Merge logic: Combine both sources into a single map grouped by main_group
    final Map<String, List<Map<String, dynamic>>> mergedExp = {};

    void mergeInto(Map<dynamic, dynamic> source) {
      source.forEach((mgKey, items) {
        final String mg = mgKey.toString().toUpperCase();
        mergedExp.putIfAbsent(mg, () => []);
        final List<Map<String, dynamic>> currentList = mergedExp[mg]!;
        final List<dynamic> sourceItems = asListMap(items);

        for (var sItem in sourceItems) {
          final name = sItem['name']?.toString() ?? '-';
          final amount = toDouble(sItem['amount']);
          final sortOrder = sItem['sort_order'] ?? 999;

          final existingIdx = currentList.indexWhere((e) => e['name'] == name);
          if (existingIdx != -1) {
            currentList[existingIdx]['amount'] =
                toDouble(currentList[existingIdx]['amount']) + amount;
          } else {
            currentList.add({
              'name': name,
              'amount': amount,
              'sort_order': sortOrder,
            });
          }
        }
      });
    }

    mergeInto(rawProfitLossExp);
    mergeInto(rawAdvProfitLossExp);

    // Final profitLossExp to use for the rest of the function
    final profitLossExp = mergedExp;

    final revenueDirect = toDouble(divData['revenue_direct'] ?? 0);
    final revenueOtherDb = toDouble(divData['revenue_other_db'] ?? 0);
    final otherIncomeSetting = toDouble(divData['other_income_setting'] ?? 0);

    final List<List<String>> rows = [];
    profitLossBoldRows.clear();

    // PENDAPATAN
    profitLossBoldRows.add(rows.length);
    rows.add(['PENDAPATAN', '']);
    rows.add(['   PENDAPATAN LANGSUNG', fmtMoney(revenueDirect)]);
    rows.add(['   PENDAPATAN LAIN LAIN', fmtMoney(revenueOtherDb)]);
    profitLossBoldRows.add(rows.length);
    rows.add(['TOTAL PENDAPATAN', fmtMoney(revenueDirect + revenueOtherDb)]);
    rows.add(['', '']);

    // Helper to add grouped expenses
    double totalCostSum = 0;
    void addExpenseGroup(String mg) {
      profitLossBoldRows.add(rows.length);
      rows.add([mg, '']);
      final items = profitLossExp[mg.toUpperCase()] ?? [];
      double groupTotal = 0;
      for (var item in items) {
        final name = item['name']?.toString() ?? '-';
        final amount = toDouble(item['amount']);
        rows.add(['   $name', fmtMoney(amount)]);
        groupTotal += amount;
      }
      profitLossBoldRows.add(rows.length);
      rows.add(['TOTAL $mg', fmtMoney(groupTotal)]);
      rows.add(['', '']);
      totalCostSum += groupTotal;
    }

    // Dynamic Expense Groups logic: Follow backend order
    final backendGroupOrder =
        (reportData?['expense_group_order'] as List?)?.cast<String>() ?? [];

    final List<String> finalOrder = [];
    if (backendGroupOrder.isNotEmpty) {
      finalOrder.addAll(backendGroupOrder);
    } else {
      // Fallback to legacy sorting if backend order is missing
      for (final cat in categories) {
        final mg = (cat['main_group'] ?? '').toString().toUpperCase();
        if (mg.isNotEmpty && !finalOrder.contains(mg)) {
          finalOrder.add(mg);
        }
      }
      for (final key in profitLossExp.keys) {
        if (!finalOrder.contains(key.toUpperCase())) {
          finalOrder.add(key.toString());
        }
      }
    }

    if (finalOrder.isNotEmpty) {
      for (var groupName in finalOrder) {
        // Always show the group header if it exists in the mapping or is a standard group
        addExpenseGroup(groupName);
      }
    } else {
      // Emergency Fallback
      addExpenseGroup('BEBAN LANGSUNG');
      addExpenseGroup('BEBAN TIDAK LANGSUNG');
      addExpenseGroup('BIAYA ADMINISTRASI DAN UMUM');
    }

    // TOTAL BIAYA
    profitLossBoldRows.add(rows.length);
    rows.add(['TOTAL BIAYA', fmtMoney(totalCostSum)]);
    rows.add(['', '']);

    // PENDAPATAN/BEBAN LAIN LAIN
    profitLossBoldRows.add(rows.length);
    rows.add(['PENDAPATAN/BEBAN LAIN LAIN', '']);
    rows.add(['   PENDAPATAN LAIN LAIN', fmtMoney(otherIncomeSetting)]);
    rows.add(['', '']);

    // LABA RUGI SEBELUM PAJAK
    final profitBeforeTax = (revenueDirect + revenueOtherDb) - totalCostSum;
    profitLossBoldRows.add(rows.length);
    rows.add(['LABA RUGI SEBELUM PAJAK', fmtMoney(profitBeforeTax)]);
    rows.add(['', '']);

    // CORPORATE TAX
    final pph29Input = toDouble(divData['tax_pph29_input'] ?? 0);
    profitLossBoldRows.add(rows.length);
    rows.add(['CORPORATE TAX (PPh 29)', fmtMoney(pph29Input)]);
    rows.add(['', '']);

    // LABA / RUGI BERSIH
    final profitAfterTaxCash = profitBeforeTax - pph29Input;
    profitLossBoldRows.add(rows.length);
    rows.add(['LABA / RUGI BERSIH', fmtMoney(profitAfterTaxCash)]);

    return rows;
  }

  List<List<String>> buildTable8Rows() {
    final divData = reportData?['dividend'] ?? {};
    final settings = (divData['settings'] as Map?) ?? {};

    final openingCash = toDouble(settings['opening_cash_balance'] ?? 0);
    final profitAfterTaxAccounting = toDouble(
      divData['profit_after_tax_accounting'] ?? 0,
    );

    final ar = toDouble(settings['accounts_receivable'] ?? 0);
    final pph23 = toDouble(settings['prepaid_tax_pph23'] ?? 0);
    final prepaidExp = toDouble(settings['prepaid_expenses'] ?? 0);
    final otherAr = toDouble(settings['other_receivables'] ?? 0);

    // Total cash = opening + current accounting profit
    final totalCash = openingCash + profitAfterTaxAccounting;
    final lancar = totalCash + ar + pph23 + prepaidExp + otherAr;

    final inventory = toDouble(settings['office_inventory'] ?? 0);
    final otherAssets = toDouble(settings['other_assets'] ?? 0);
    final totalAktiva = lancar + inventory + otherAssets;

    final ap = toDouble(settings['accounts_payable'] ?? 0);
    final salary = toDouble(settings['salary_payable'] ?? 0);
    final shareholder = toDouble(settings['shareholder_payable'] ?? 0);
    final accrued = toDouble(settings['accrued_expenses'] ?? 0);
    final totalHutang = ap + salary + shareholder + accrued;

    final capital = toDouble(settings['share_capital'] ?? 0);
    final retained = toDouble(settings['retained_earnings_balance'] ?? 0);

    // Balancing Laba Tahun Berjalan (Plug Figure to match Excel logic)
    final labaTahunBerjalan = totalAktiva - totalHutang - capital - retained;
    final totalModal = capital + retained + labaTahunBerjalan;

    final List<List<String>> rows = [];
    neracaBoldRows.clear();

    neracaBoldRows.add(rows.length);
    rows.add(['AKTIVA', '']);
    rows.add(['   AKTIVA LANCAR', '']);
    rows.add([
      '      KAS DAN SETARA KAS TAHUN SEBELUMNYA',
      fmtMoney(openingCash),
    ]);
    rows.add([
      '      KAS DAN SETARA KAS TAHUN LAPORAN',
      fmtMoney(profitAfterTaxAccounting),
    ]);
    rows.add(['      PIUTANG USAHA', fmtMoney(ar)]);
    rows.add(['      PAJAK BAYAR DI MUKA (pph23)', fmtMoney(pph23)]);
    rows.add(['      BIAYA BAYAR DI MUKA', fmtMoney(prepaidExp)]);
    rows.add(['      PIUTANG LAIN LAIN', fmtMoney(otherAr)]);
    neracaBoldRows.add(rows.length);
    rows.add(['   TOTAL AKTIVA LANCAR', fmtMoney(lancar)]);
    rows.add(['', '']);

    rows.add(['   ACTIVA TETAP', '']);
    rows.add(['      INVENTARIS KANTOR', fmtMoney(inventory)]);
    rows.add(['      AKTIVA LAIN LAIN', fmtMoney(otherAssets)]);
    neracaBoldRows.add(rows.length);
    rows.add(['   TOTAL AKTIVA TETAP', fmtMoney(inventory + otherAssets)]);
    rows.add(['', '']);

    neracaBoldRows.add(rows.length);
    rows.add(['TOTAL AKTIVA', fmtMoney(totalAktiva)]);
    rows.add(['', '']);

    neracaBoldRows.add(rows.length);
    rows.add(['HUTANG DAN MODAL', '']);
    rows.add(['   HUTANG LANCAR', '']);
    rows.add(['      HUTANG USAHA', fmtMoney(ap)]);
    rows.add(['      HUTANG GAJI', fmtMoney(salary)]);
    rows.add(['      HUTANG PEMEGANG SAHAM', fmtMoney(shareholder)]);
    rows.add(['      BIAYA YANG MASIH HARUS DIBAYAR', fmtMoney(accrued)]);
    neracaBoldRows.add(rows.length);
    rows.add(['   TOTAL HUTANG LANCAR', fmtMoney(totalHutang)]);
    rows.add(['', '']);

    rows.add(['   MODAL', '']);
    rows.add(['      MODAL SAHAM', fmtMoney(capital)]);
    rows.add(['      LABA DI TAHAN', fmtMoney(retained)]);
    rows.add(['      LABA TAHUN BERJALAN', fmtMoney(labaTahunBerjalan)]);
    neracaBoldRows.add(rows.length);
    rows.add(['      TOTAL LABA (RUGI) DITAHAN', fmtMoney(totalModal)]);
    neracaBoldRows.add(rows.length);
    rows.add(['   TOTAL MODAL', fmtMoney(totalModal)]);
    rows.add(['', '']);

    neracaBoldRows.add(rows.length);
    rows.add(['TOTAL HUTANG DAN MODAL', fmtMoney(totalHutang + totalModal)]);

    return rows;
  }

  List<List<String>> buildTable9Rows() {
    final divData = reportData?['dividend'] ?? {};

    final revenueTotal = toDouble(divData['revenue_total'] ?? 0);
    final pph23Client = toDouble(divData['pph23_total'] ?? 0);
    final revenueReceived = revenueTotal - pph23Client;

    final totalExpense = toDouble(divData['total_cost'] ?? 0);
    final profitBeforeTax = toDouble(divData['profit_before_tax'] ?? 0);

    final pphBadanAuto = toDouble(divData['tax_corporate_auto'] ?? 0);
    final taxShortfall = toDouble(divData['tax_shortfall'] ?? 0);

    // Safety Status: Safe if Shortfall > 0 (meaning we paid a bit), Danger if restitusi
    final isDanger = pphBadanAuto > 0 && pph23Client > pphBadanAuto;
    final statusText =
        isDanger ? 'BAHAYA (Restitusi/Audit)' : 'AMAN (Kurang Bayar)';

    final profitAfterTaxAccounting = toDouble(
      divData['profit_after_tax_accounting'] ?? 0,
    );
    final dividendDistributed = toDouble(divData['total_amount'] ?? 0);
    final retainedProfit = profitAfterTaxAccounting - dividendDistributed;

    return [
      ['1', 'Revenue', fmtMoney(revenueTotal)],
      ['2', 'Revenue Diterima (Setelah Pajak)', fmtMoney(revenueReceived)],
      ['3', 'Biaya', fmtMoney(totalExpense)],
      ['4', 'Profit Sebelum Tax', fmtMoney(profitBeforeTax)],
      ['5', 'PPh Badan (Rate Terpilih)', fmtMoney(pphBadanAuto)],
      ['6', 'PPh 23 Dipotong client (TERPILIH)', fmtMoney(pph23Client)],
      ['7', 'Kekurangan Bayar PPh Badan', fmtMoney(taxShortfall)],
      ['8', 'Profit After Tax', fmtMoney(profitAfterTaxAccounting)],
      ['9', 'Deviden Dibagi', fmtMoney(dividendDistributed)],
      ['10', 'Profit Ditahan', fmtMoney(retainedProfit)],
      ['11', 'Status Keamanan Pajak', statusText],
    ];
  }

  List<List<String>> buildTable10Rows() {
    final dividendData = asListMap(reportData?['dividend']?['data']);
    return dividendData
        .asMap()
        .entries
        .map(
          (e) => [
            '${e.key + 1}',
            e.value['name']?.toString() ??
                e.value['recipient_name']?.toString() ??
                '-',
            'Rp',
            fmtMoney(e.value['amount'] ?? 0).replaceFirst('Rp ', ''),
          ],
        )
        .toList();
  }

  List<List<String>> buildTable11Rows() {
    if (reportData == null) return [];
    final allAdminFees = asListMap(reportData!['admin_fees']?['data']);
    final adminFees =
        allAdminFees.where((e) => e['is_admin_fee_extra'] == true).toList();
    if (adminFees.isEmpty) return [];

    final rows = <List<String>>[];
    table3bBoldRows.clear();

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var d in adminFees) {
      String bank = (d['bank_name']?.toString() ?? '-').trim();
      if (bank.isEmpty || bank == 'None' || bank.toLowerCase() == 'null') {
        bank = '-';
      }
      grouped.putIfAbsent(bank, () => []).add(d);
    }

    double grandTotal = 0;
    int globalCounter = 0;

    for (var bank in grouped.keys.toList()..sort()) {
      table3bBoldRows.add(rows.length);
      rows.add(['', '', 'Bank : $bank', '', '', '', '', '']);

      final items = grouped[bank]!;
      for (var item in items) {
        globalCounter++;
        final amt = toDouble(item['amount']);
        grandTotal += amt;

        rows.add([
          fmtDate(item['date']),
          '$globalCounter',
          item['description']?.toString() ?? '',
          item['bank_name']?.toString() ?? '',
          fmtMoney(amt).replaceFirst('Rp ', ''),
          item['currency']?.toString() ?? 'IDR',
          toDouble(item['exchange_rate'] ?? 1).toStringAsFixed(0),
          item['settlement_type']?.toString().toUpperCase() ?? 'SINGLE',
        ]);
      }
    }

    table3bBoldRows.add(rows.length);
    rows.add([
      'Total',
      '',
      '',
      '',
      fmtMoney(grandTotal).replaceFirst('Rp ', ''),
      '',
      '',
      '',
    ]);

    return rows;
  }

  List<List<String>> buildTable3aRows() {
    final adminFeesRoot = reportData?['admin_fees'] ?? {};
    final allAdminFeesData = asListMap(adminFeesRoot['data']);
    final adminFeesData =
        allAdminFeesData.where((e) => e['is_admin_fee_extra'] != true).toList();

    final rows = <List<String>>[];
    table3aBoldRows.clear();
    if (adminFeesData.isEmpty) return [];

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var d in adminFeesData) {
      String bank = (d['bank_name']?.toString() ?? '-').trim();
      if (bank.isEmpty || bank == 'None' || bank.toLowerCase() == 'null') {
        bank = '-';
      }
      grouped.putIfAbsent(bank, () => []).add(d);
    }

    double grandTotal = 0;
    int globalCounter = 0;

    for (var bank in grouped.keys.toList()..sort()) {
      table3aBoldRows.add(rows.length);
      rows.add(['', '', 'Bank : $bank', '', '', '', '', '']);

      final items = grouped[bank]!;
      for (var item in items) {
        globalCounter++;
        final adminVal = toDouble(item['idr_amount'] ?? item['amount']);
        grandTotal += adminVal;

        rows.add([
          fmtDate(item['date']),
          '$globalCounter',
          (item['description'] ?? '').toString(),
          (item['bank_name'] ?? '').toString(),
          fmtMoney(adminVal).replaceFirst('Rp ', ''),
          (item['currency'] ?? 'IDR').toString(),
          currencyFormat.format(toDouble(item['exchange_rate'] ?? 1)),
          (item['settlement_type'] ?? 'single').toString().toUpperCase(),
        ]);
      }
    }

    table3aBoldRows.add(rows.length);
    rows.add([
      'Total',
      '',
      '',
      '',
      fmtMoney(grandTotal).replaceFirst('Rp ', ''),
      '',
      '',
      '',
    ]);

    return rows;
  }

  List<List<String>> buildTable3Rows() {
    final bankStatusRoot = reportData?['bank_status'];
    final bankData = asListMap(
      bankStatusRoot?['data'] ??
          reportData?['bank_transactions']?['data'] ??
          bankStatusRoot,
    );

    final List<List<String>> rows = [];
    table3BoldRows.clear();

    double totalUsd = 0;
    double totalIdr = 0;

    if (bankData.isNotEmpty && bankData.first.containsKey('group_name')) {
      for (final group in bankData) {
        String groupName = group['group_name'] ?? 'Lain-lain';

        // Ensure "Interest" becomes "Bank Interest" for consistency
        if (groupName.startsWith('Interest (')) {
          groupName = groupName.replaceFirst('Interest (', 'Bank Interest (');
        }

        final items = asListMap(group['items']);

        // Group Header Row (Bold, in Detail/Description column)
        table3BoldRows.add(rows.length);
        rows.add(['', '', groupName, '', '']);

        int itemIndex = 1;
        for (final row in items) {
          final usdVal = toDouble(row['amount_usd']);
          final idrVal = toDouble(
              row['amount_idr'] ?? row['amount'] ?? row['nominal'] ?? 0);

          totalUsd += usdVal;
          totalIdr += idrVal;

          rows.add([
            fmtDate(row['date'] ?? row['transaction_date']),
            '$itemIndex',
            (row['description'] ?? row['remark'] ?? '').toString(),
            usdVal > 0 ? currencyFormat.format(usdVal) : '',
            idrVal > 0 ? currencyFormat.format(idrVal) : '',
          ]);
          itemIndex++;
        }
      }
    } else {
      // Fallback if old flat format
      for (int i = 0; i < bankData.length; i++) {
        final row = bankData[i];
        final usdVal = toDouble(row['amount_usd']);
        final idrVal = toDouble(
            row['amount_idr'] ?? row['amount'] ?? row['nominal'] ?? 0);

        totalUsd += usdVal;
        totalIdr += idrVal;

        rows.add([
          fmtDate(row['date'] ?? row['transaction_date']),
          '${i + 1}',
          (row['description'] ?? row['remark'] ?? '').toString(),
          usdVal > 0 ? fmtPlain(usdVal) : '',
          fmtPlain(idrVal),
        ]);
      }
    }

    rows.add([
      'TOTAL',
      '',
      '',
      totalUsd > 0 ? currencyFormat.format(totalUsd) : '',
      currencyFormat.format(totalIdr),
    ]);

    return rows;
  }

  List<List<String>> buildTable6Rows() {
    final assetData = asListMap(reportData?['assets']?['data']);
    return assetData.asMap().entries.map((entry) {
      final row = entry.value;
      return [
        fmtDate(row['purchase_date']),
        '${entry.key + 1}',
        (row['asset_code'] ?? '-').toString(),
        (row['name'] ?? '-').toString(),
        (row['status'] ?? 'Active').toString(),
        fmtMoney(row['purchase_price'] ?? 0),
        '${row['useful_life_months'] ?? 0} bln',
        fmtMoney(row['monthly_depreciation'] ?? 0),
        fmtMoney(row['accumulated_depreciation'] ?? 0),
        fmtMoney(row['book_value'] ?? 0),
      ];
    }).toList();
  }

  List<double> getColumnWidths(String title, int colCount, bool useCompact) {
    List<double> widths;
    if (title.contains('Tabel 10')) {
      widths = [50, 250, 50, 180];
    } else if (title.contains('Tabel 9')) {
      widths = [50, 300, 180];
    } else if (title.contains('Tabel 1')) {
      widths = [
        100, // Invoice Date
        50, // #
        350, // Detail/Description
        150, // INVOICE VALUE(child=USD)
        150, // INVOICE VALUE(child=IDR)
        80, // Currency
        100, // Currency Exchange
        130, // INVOICE Number
        130, // Client
        100, // Receive Date
        150, // AMOUNT RECEIVED(child=IDR)
        150, // AMOUNT RECEIVED(child=USD)
        120, // PPn(child=11%)
        120, // PPH (Pasal 23)(child=2%)
        120, // Biaya transfer
        140, // Sumber Dana
        200, // Remark
      ];
    } else if (title.contains('Tabel 2')) {
      widths = [
        100, // Date
        50, // #
        300, // Detail/Description
        150, // INVOICE VALUE(child=USD)
        150, // Transaction Value
        80, // Currency
        80, // Currency Exchange
        150, // Transaction Value
        150, // PPN(child=Transaction)
        120, // PPN(child=PPN)
        150, // PPh (pasal 21)(child=Transaction)
        120, // PPh (child=PPh - 21)
        150, // PPh (pasal 23)(child=Transaction)
        120, // PPh (child=PPh - 23)
        150, // PPh (pasal 26)(child=Transaction)
        120, // PPh (child=PPh - 26)
        150, // Pemasukan Negara (pasal ???)(child=Transaction)
        120, // Pemasukan Negara (child=Pajak)
      ];
    } else if (title.contains('Tabel 3:')) {
      widths = [110, 50, 400, 160, 160];
    } else if (title.contains('Tabel 3C')) {
      widths = [100, 50, 350, 150, 150, 150, 150, 150];
    } else if (title.contains('Tabel 3A') || title.contains('Tabel 3B')) {
      widths = [100, 50, 350, 150, 150, 60, 80, 160, 110];
    } else if (title.contains('Tabel 4')) {
      widths = [
        120, // Date/#
        50, // #
        400, // Activity
        100, // Src
        160, // Amount
        80, // Cur
        80, // Rate
        ...List<double>.filled(math.max(colCount - 12, 0), 200),
        190, // Sub Total
        190, // Total
        150, // From
        150, // To
        100, // Evidence
      ];
    } else if (title.contains('Tabel 6')) {
      widths = [
        100, // Date
        50, // #
        120, // Code
        350, // Asset Name
        110, // Status
        160, // Price
        80, // Life
        140, // Month Depr
        140, // Acc Depr
        140, // Book Value
      ];
    } else if (title.contains('Tabel 7') || title.contains('Tabel 8')) {
      final sw = MediaQuery.of(context).size.width;
      widths = [sw > 800 ? 350.0 : 250.0, 200.0];
    } else {
      widths = List<double>.filled(colCount, 150);
    }
    return widths.map((w) => w * zoomLevel).toList();
  }

  bool isNumericLikeCell(String header, int index, [String? value]) {
    final text = header.toLowerCase().trim();
    if (text == '#') return true; // # column

    // Keywords for right-alignment
    final isNumericHeader = text.contains('amount') ||
        text.contains('amnt') ||
        text.contains('rate') ||
        text.contains('value') ||
        text.contains('val') ||
        text.contains('ppn') ||
        text.contains('pph') ||
        text.contains('dpp') ||
        text.contains('fee') ||
        text.contains('price') ||
        text.contains('life') ||
        text.contains('depr') ||
        text.contains('saldo') ||
        text.contains('mutasi') ||
        text.contains('nilai') ||
        text.contains('total') ||
        text.contains('base') ||
        text.contains('distributed') ||
        text.contains('retained') ||
        text.contains('person');

    if (isNumericHeader) return true;

    // Fallback: check if content looks like a formatted number
    // It should be mostly digits, dots, and commas, not long text.
    final cleanValue =
        (value ?? '').replaceAll(RegExp(r'[Rp\s.]'), '').replaceAll(',', '.');
    if (cleanValue.isNotEmpty && double.tryParse(cleanValue) != null) {
      return true;
    }

    return false;
  }

  Map<int, int> buildCombineGroupMap(
      List<Map<String, dynamic>> dataList, List<dynamic> combineGroups) {
    final map = <int, int>{};
    if (combineGroups.isEmpty || dataList.isEmpty) return map;
    final idToIndex = <int, int>{};
    for (int i = 0; i < dataList.length; i++) {
      final id = int.tryParse(dataList[i]['id']?.toString() ?? '');
      if (id != null) idToIndex[id] = i;
    }
    for (final raw in combineGroups) {
      final group = Map<String, dynamic>.from(raw as Map);
      final groupId = int.tryParse(group['id']?.toString() ?? '') ?? 0;
      final rowIds = (group['row_ids'] as List?) ?? const [];
      for (final rowId in rowIds) {
        final parsed = int.tryParse(rowId.toString());
        if (parsed != null && idToIndex.containsKey(parsed)) {
          map[idToIndex[parsed]!] = groupId;
        }
      }
    }
    return map;
  }

  Map<int, List<String>> buildMergedColumnsMap(
      List<Map<String, dynamic>> dataList, List<dynamic> combineGroups) {
    final Map<int, List<String>> map = {};
    if (combineGroups.isEmpty || dataList.isEmpty) return map;
    final idToIndex = <int, int>{};
    for (int i = 0; i < dataList.length; i++) {
      final id = int.tryParse(dataList[i]['id']?.toString() ?? '');
      if (id != null) idToIndex[id] = i;
    }
    for (final raw in combineGroups) {
      final group = Map<String, dynamic>.from(raw as Map);
      final merged = (group['merged_columns'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [];
      final rowIds = (group['row_ids'] as List?) ?? const [];
      for (final rowId in rowIds) {
        final parsed = int.tryParse(rowId.toString());
        if (parsed != null && idToIndex.containsKey(parsed)) {
          map[idToIndex[parsed]!] = merged;
        }
      }
    }
    return map;
  }
}
