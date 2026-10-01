import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_state.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';
import 'package:expense_app/screens/reports/annual_report/widget_bank_expense_table.dart';


extension AnnualReportTablesTable4CAnd4DExt on AnnualReportScreenState {
  void processTable4CAnd4D() {
    final expenseGroups = cachedGroupedAdvanceExpenses;
    if (expenseGroups == null || expenseGroups.isEmpty) {
      tableDataCache['t4c'] = ReportTableData(rows: [], headers: ['Expenses']);
      tableDataCache['t4d'] = ReportTableData(rows: [], headers: ['Expenses']);
      return;
    }

    final Map<int, double> tempTotals = {};
    for (final group in expenseGroups) {
      for (final e in group) {
        final catName = (e['category_name'] ?? '').toString();
        final amount = toDouble(e['idr_amount'] ?? e['amount']);
        int catId = -1;
        for (final c in categories) {
          if ((c['name'] ?? '').toString().toLowerCase() ==
              catName.toLowerCase()) {
            catId = c['id'];
            break;
          }
        }
        if (catId != -1) {
          tempTotals[catId] = (tempTotals[catId] ?? 0) + amount;
        }
      }
    }

    final filteredCategories = categories.where((c) {
      final id = c['id'];
      return (tempTotals[id] ?? 0) > 0;
    }).toList();

    final catHeaders = filteredCategories.isNotEmpty
        ? filteredCategories.map((c) => (c['name'] ?? '').toString()).toList()
        : ['Expenses'];
    final catTotals = List<double>.filled(catHeaders.length, 0);
    double grandTotalExpense = 0;

    int getFilteredCatIndex(String categoryName) {
      final target = categoryName.toLowerCase().trim();
      for (int i = 0; i < filteredCategories.length; i++) {
        final name =
            (filteredCategories[i]['name'] ?? '').toString().toLowerCase();
        if (name == target) return i;
      }
      return -1;
    }

    final List<List<String>> expenseRows = <List<String>>[];
    final expenseBoldRows = <int>{};

    final List<Map<String, dynamic>> allSingles = [];
    final List<List<Map<String, dynamic>>> allBatches = [];
    for (final group in expenseGroups) {
      if (isBatchSettlement(group.first)) {
        allBatches.add(group);
      } else {
        allSingles.addAll(group);
      }
    }

    allBatches.sort((a, b) {
      DateTime minDateA = a
          .map((e) => parseDate(e['date']))
          .reduce((d1, d2) => d1.isBefore(d2) ? d1 : d2);
      DateTime minDateB = b
          .map((e) => parseDate(e['date']))
          .reduce((d1, d2) => d1.isBefore(d2) ? d1 : d2);
      if (minDateA != minDateB) return minDateA.compareTo(minDateB);
      return (int.tryParse(a.first['settlement_id']?.toString() ?? '0') ?? 0)
          .compareTo(
              int.tryParse(b.first['settlement_id']?.toString() ?? '0') ?? 0);
    });

    int singleCounter = 0;

    if (sortMode == 'tanggal') {
      // 1. Single Expenses (MODE TANGGAL)
      allSingles.sort((a, b) {
        final da = parseDate(a['date']);
        final db = parseDate(b['date']);
        if (da != db) return da.compareTo(db);
        return (int.tryParse(a['id']?.toString() ?? '0') ?? 0)
            .compareTo(int.tryParse(b['id']?.toString() ?? '0') ?? 0);
      });

      for (final e in allSingles) {
        singleCounter++;
        final amt = toDouble(e['amount']);
        final rate = toDouble(e['currency_exchange'] ?? 1);
        final currency = normalizeCurrency(e['currency']);

        final idrAmount = (currency != 'IDR')
            ? amt * rate
            : toDouble(e['idr_amount'] ?? e['amount']);

        final idx = getFilteredCatIndex(e['category_name'] ?? '');
        final rowCats = List<String>.filled(catHeaders.length, '');
        if (idx != -1 && idx < catHeaders.length) {
          rowCats[idx] = fmtMoney(idrAmount);
          catTotals[idx] += idrAmount;
        }
        grandTotalExpense += idrAmount;
        expenseRows.add([
          fmtDate(e['date']),
          '$singleCounter',
          e['description']?.toString() ?? '',
          (e['source']?.toString() ?? '').isEmpty ? '' : e['source'].toString(),
          fmtAmount(e['amount'], e['currency']),
          currency,
          rate.toStringAsFixed(0),
          ...rowCats,
          fmtMoney(idrAmount),
          '',
          (e['from_user']?.toString() ?? e['dari']?.toString() ?? '').isEmpty
              ? ''
              : (e['from_user']?.toString() ?? e['dari']?.toString() ?? ''),
          (e['to_user']?.toString() ?? e['ke']?.toString() ?? '').isEmpty
              ? ''
              : (e['to_user']?.toString() ?? e['ke']?.toString() ?? ''),
          '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
        ]);
      }
    } else {
      // 1. Single Expenses (MODE KATEGORI)
      final Map<String, List<Map<String, dynamic>>> singleMap = {};
      for (final e in allSingles) {
        final sub = expenseSubcategoryLabel(e);
        singleMap.putIfAbsent(sub, () => []).add(e);
      }
      final sortedSingleSubs = singleMap.keys.toList()
        ..sort((a, b) {
          final aExpense = singleMap[a]!.first;
          final bExpense = singleMap[b]!.first;
          final aCatIdx = getFilteredCatIndex(aExpense['category_name'] ?? '');
          final bCatIdx = getFilteredCatIndex(bExpense['category_name'] ?? '');
          if (aCatIdx != bCatIdx) return aCatIdx.compareTo(bCatIdx);
          return a.toLowerCase().compareTo(b.toLowerCase());
        });

      for (final sub in sortedSingleSubs) {
        expenseBoldRows.add(expenseRows.length);
        expenseRows.add([
          '',
          '',
          sub,
          '',
          '',
          '',
          '',
          ...List.filled(catHeaders.length, ''),
          '',
          '',
          '',
          '',
          '',
        ]);
        for (final e in singleMap[sub]!) {
          singleCounter++;
          final amt = toDouble(e['amount']);
          final rate = toDouble(e['currency_exchange'] ?? 1);
          final currency = normalizeCurrency(e['currency']);

          final idrAmount = (currency != 'IDR')
              ? amt * rate
              : toDouble(e['idr_amount'] ?? e['amount']);

          final idx = getFilteredCatIndex(e['category_name'] ?? '');
          final rowCats = List<String>.filled(catHeaders.length, '');
          if (idx != -1 && idx < catHeaders.length) {
            rowCats[idx] = fmtMoney(idrAmount);
            catTotals[idx] += idrAmount;
          }
          grandTotalExpense += idrAmount;
          expenseRows.add([
            fmtDate(e['date']),
            '$singleCounter',
            e['description']?.toString() ?? '',
            (e['source']?.toString() ?? '').isEmpty
                ? ''
                : e['source'].toString(),
            fmtAmount(e['amount'], e['currency']),
            currency,
            rate.toStringAsFixed(0),
            ...rowCats,
            fmtMoney(idrAmount),
            '',
            (e['from_user']?.toString() ?? e['dari']?.toString() ?? '').isEmpty
                ? ''
                : (e['from_user']?.toString() ?? e['dari']?.toString() ?? ''),
            (e['to_user']?.toString() ?? e['ke']?.toString() ?? '').isEmpty
                ? ''
                : (e['to_user']?.toString() ?? e['ke']?.toString() ?? ''),
            '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
          ]);
        }
      }
    }

    // 2. Header Pengeluaran dan Kantor (As Separator)
    if (allSingles.isNotEmpty || allBatches.isNotEmpty) {
      expenseBoldRows.add(expenseRows.length);
      expenseRows.add([
        '',
        '',
        'Pengeluaran dan Kantor - Expenses Report',
        '',
        '',
        '',
        '',
        ...List.filled(catHeaders.length, ''),
        '',
        '',
        '',
        '',
        '',
      ]);
    }

    // 3. Batch Expenses (Expense#1, #2...)
    int batchCounter = 0;
    for (final batch in allBatches) {
      batchCounter++;
      expenseBoldRows.add(expenseRows.length);
      final settlementTitle =
          (batch.first['settlement_title'] ?? 'Tanpa Settlement').toString();
      expenseRows.add([
        'Expense#$batchCounter',
        ':',
        settlementTitle,
        '',
        '',
        '',
        '',
        ...List.filled(catHeaders.length, ''),
        '',
        '',
        '',
        '',
        '',
      ]);

      double batchTotal = 0;
      int totalItemsInBatch = batch.length;
      int currentItemIndex = 0;

      if (sortMode == 'tanggal') {
        batch.sort((a, b) {
          final da = parseDate(a['date']);
          final db = parseDate(b['date']);
          if (da != db) return da.compareTo(db);
          return (int.tryParse(a['id']?.toString() ?? '0') ?? 0)
              .compareTo(int.tryParse(b['id']?.toString() ?? '0') ?? 0);
        });

        for (final e in batch) {
          singleCounter++;
          final amt = toDouble(e['amount']);
          final rate = toDouble(e['currency_exchange'] ?? 1);
          final currency = normalizeCurrency(e['currency']);

          final idrAmount = (currency != 'IDR')
              ? amt * rate
              : toDouble(e['idr_amount'] ?? e['amount']);

          final idx = getFilteredCatIndex(e['category_name'] ?? '');
          final rowCats = List<String>.filled(catHeaders.length, '');
          if (idx != -1 && idx < catHeaders.length) {
            rowCats[idx] = fmtMoney(idrAmount);
            catTotals[idx] += idrAmount;
          }
          batchTotal += idrAmount;
          grandTotalExpense += idrAmount;
          currentItemIndex++;

          expenseRows.add([
            fmtDate(e['date']),
            '$singleCounter',
            e['description']?.toString() ?? '',
            (e['source']?.toString() ?? '').isEmpty
                ? ''
                : e['source'].toString(),
            fmtAmount(e['amount'], e['currency']),
            currency,
            rate.toStringAsFixed(0),
            ...rowCats,
            fmtMoney(idrAmount),
            (currentItemIndex == totalItemsInBatch)
                ? fmtMoney(batchTotal)
                : '',
            (e['from_user']?.toString() ?? e['dari']?.toString() ?? '').isEmpty
                ? ''
                : (e['from_user']?.toString() ?? e['dari']?.toString() ?? ''),
            (e['to_user']?.toString() ?? e['ke']?.toString() ?? '').isEmpty
                ? ''
                : (e['to_user']?.toString() ?? e['ke']?.toString() ?? ''),
            '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
          ]);
        }
      } else {
        final Map<String, List<Map<String, dynamic>>> subMap = {};
        for (final e in batch) {
          final sub = expenseSubcategoryLabel(e);
          subMap.putIfAbsent(sub, () => []).add(e);
        }
        final sortedSubs = subMap.keys.toList()
          ..sort((a, b) {
            final aExpense = subMap[a]!.first;
            final bExpense = subMap[b]!.first;
            final aCatIdx =
                getFilteredCatIndex(aExpense['category_name'] ?? '');
            final bCatIdx =
                getFilteredCatIndex(bExpense['category_name'] ?? '');
            if (aCatIdx != bCatIdx) return aCatIdx.compareTo(bCatIdx);
            return a.toLowerCase().compareTo(b.toLowerCase());
          });

        for (final sub in sortedSubs) {
          expenseBoldRows.add(expenseRows.length);
          expenseRows.add([
            '',
            '',
            sub,
            '',
            '',
            '',
            '',
            ...List.filled(catHeaders.length, ''),
            '',
            '',
            '',
            '',
            '',
          ]);
          final items = subMap[sub]!;
          for (int i = 0; i < items.length; i++) {
            final e = items[i];
            singleCounter++;
            final amt = toDouble(e['amount']);
            final rate = toDouble(e['currency_exchange'] ?? 1);
            final currency = normalizeCurrency(e['currency']);

            final idrAmount = (currency != 'IDR')
                ? amt * rate
                : toDouble(e['idr_amount'] ?? e['amount']);

            final idx = getFilteredCatIndex(e['category_name'] ?? '');
            final rowCats = List<String>.filled(catHeaders.length, '');
            if (idx != -1 && idx < catHeaders.length) {
              rowCats[idx] = fmtMoney(idrAmount);
              catTotals[idx] += idrAmount;
            }
            batchTotal += idrAmount;
            grandTotalExpense += idrAmount;
            currentItemIndex++;

            expenseRows.add([
              fmtDate(e['date']),
              '$singleCounter',
              e['description']?.toString() ?? '',
              (e['source']?.toString() ?? '').isEmpty
                  ? ''
                  : e['source'].toString(),
              fmtAmount(e['amount'], e['currency']),
              currency,
              rate.toStringAsFixed(0),
              ...rowCats,
              fmtMoney(idrAmount),
              (currentItemIndex == totalItemsInBatch)
                  ? fmtMoney(batchTotal)
                  : '',
              (e['from_user']?.toString() ?? e['dari']?.toString() ?? '')
                      .isEmpty
                  ? ''
                  : (e['from_user']?.toString() ?? e['dari']?.toString() ?? ''),
              (e['to_user']?.toString() ?? e['ke']?.toString() ?? '').isEmpty
                  ? ''
                  : (e['to_user']?.toString() ?? e['ke']?.toString() ?? ''),
              '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
            ]);
          }
        }
      }
    }

    expenseRows.add([
      'TOTAL',
      '',
      '',
      '',
      '',
      '',
      '',
      ...catTotals.map(fmtMoney),
      fmtMoney(grandTotalExpense),
      fmtMoney(grandTotalExpense),
      '',
      '',
      '-',
    ]);
    tableDataCache['t4c'] = ReportTableData(
      rows: expenseRows,
      boldRows: expenseBoldRows,
      headers: catHeaders,
    );

    processBankExpenseTable(
      allSingles,
      allBatches,
      catHeaders,
      getFilteredCatIndex,
      't4d',
    );
  }
}
