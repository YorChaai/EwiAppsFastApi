import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_state.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_helpers.dart';


extension AnnualReportTablesBankExpenseTableExt on AnnualReportScreenState {
  void processBankExpenseTable(
    List<Map<String, dynamic>> allSingles,
    List<List<Map<String, dynamic>>> allBatches,
    List<String> catHeaders,
    int Function(String) getFilteredCatIndex,
    String targetCacheKey,
  ) {
    final List<List<String>> bankRows = <List<String>>[];
    final bankBoldRows = <int>{};
    int rowCounter = 0;
    final List<double> bankCatTotals = List.filled(catHeaders.length, 0.0);

    final Map<String, List<Map<String, dynamic>>> bankSingleMap = {};
    for (final e in allSingles) {
      String bank = (e['bank_name']?.toString() ?? '').trim();
      if (bank.isEmpty ||
          bank == 'None' ||
          bank.toLowerCase() == 'null' ||
          bank == '-') {
        // Fallback to source (BCA, BRI, etc.) if bank_name is empty
        bank = (e['source']?.toString() ?? '').trim();
      }
      if (bank.isEmpty || bank == 'None' || bank.toLowerCase() == 'null') {
        bank = '-';
      }
      bankSingleMap.putIfAbsent(bank, () => []).add(e);
    }
    final sortedBanks = bankSingleMap.keys.toList()..sort();
    double grandTotalBank = 0;

    for (final bank in sortedBanks) {
      final bankItems = bankSingleMap[bank]!;
      final bankLabel = bank == '-' ? '-' : bank;

      final transfers = bankItems.where((e) {
        final sub = expenseSubcategoryLabel(e).toLowerCase();
        final parent = (e['category_name']?.toString() ?? '').toLowerCase();

        // Is it an Admin Fee? (Sub contains 'biaya bank'/'biaya admin' OR Parent is 'administrasi' with 'admin' keyword)
        final isAdmin = sub.contains('biaya bank') ||
            sub.contains('biaya admin') ||
            (parent == 'administrasi' && sub.contains('admin'));

        return !isAdmin;
      }).toList();

      final adminFees = bankItems.where((e) {
        final sub = expenseSubcategoryLabel(e).toLowerCase();
        final parent = (e['category_name']?.toString() ?? '').toLowerCase();

        final isAdmin = sub.contains('biaya bank') ||
            sub.contains('biaya admin') ||
            (parent == 'administrasi' && sub.contains('admin'));

        return isAdmin;
      }).toList();

      if (transfers.isNotEmpty) {
        bankBoldRows.add(bankRows.length);
        bankRows.add([
          '',
          '',
          'Transfer from $bankLabel account',
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
        double groupTotal = 0;
        for (int i = 0; i < transfers.length; i++) {
          final e = transfers[i];
          rowCounter++;
          final rawAmt = toDouble(e['amount']);
          final rate = toDouble(e['currency_exchange'] ?? 1);
          final currency = normalizeCurrency(e['currency']);

          final amt = (currency != 'IDR')
              ? rawAmt * rate
              : toDouble(e['idr_amount'] ?? e['amount']);

          final idx = getFilteredCatIndex(e['category_name'] ?? '');
          final rowCats = List<String>.filled(catHeaders.length, '-');
          if (idx != -1 && idx < catHeaders.length) {
            rowCats[idx] = fmtMoney(amt);
            bankCatTotals[idx] += amt;
          }
          groupTotal += amt;
          grandTotalBank += amt;
          bankRows.add([
            fmtDate(e['date']),
            '$rowCounter',
            e['description']?.toString() ?? '',
            (e['source']?.toString() ?? '').isEmpty
                ? '-'
                : e['source'].toString(),
            fmtAmount(e['amount'], e['currency']),
            currency,
            rate.toStringAsFixed(0),
            ...rowCats,
            fmtMoney(amt),
            (i == transfers.length - 1) ? fmtMoney(groupTotal) : '-',
            (e['from_user']?.toString() ?? e['dari']?.toString() ?? '-').isEmpty
                ? '-'
                : (e['from_user']?.toString() ?? e['dari']?.toString() ?? '-'),
            (e['to_user']?.toString() ?? e['ke']?.toString() ?? '-').isEmpty
                ? '-'
                : (e['to_user']?.toString() ?? e['ke']?.toString() ?? '-'),
            '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
          ]);
        }
      }
      if (adminFees.isNotEmpty) {
        bankBoldRows.add(bankRows.length);
        bankRows.add([
          '',
          '',
          'Biaya Admin $bankLabel',
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
        double groupTotal = 0;
        for (int i = 0; i < adminFees.length; i++) {
          final e = adminFees[i];
          rowCounter++;
          final rawAmt = toDouble(e['amount']);
          final rate = toDouble(e['currency_exchange'] ?? 1);
          final currency = normalizeCurrency(e['currency']);

          final amt = (currency != 'IDR')
              ? rawAmt * rate
              : toDouble(e['idr_amount'] ?? e['amount']);

          final idx = getFilteredCatIndex(e['category_name'] ?? '');
          final rowCats = List<String>.filled(catHeaders.length, '-');
          if (idx != -1 && idx < catHeaders.length) {
            rowCats[idx] = fmtMoney(amt);
            bankCatTotals[idx] += amt;
          }
          groupTotal += amt;
          grandTotalBank += amt;
          bankRows.add([
            fmtDate(e['date']),
            '$rowCounter',
            e['description']?.toString() ?? '',
            (e['source']?.toString() ?? '').isEmpty
                ? '-'
                : e['source'].toString(),
            fmtAmount(e['amount'], e['currency']),
            currency,
            rate.toStringAsFixed(0),
            ...rowCats,
            fmtMoney(amt),
            (i == adminFees.length - 1) ? fmtMoney(groupTotal) : '-',
            (e['from_user']?.toString() ?? e['dari']?.toString() ?? '-').isEmpty
                ? '-'
                : (e['from_user']?.toString() ?? e['dari']?.toString() ?? '-'),
            (e['to_user']?.toString() ?? e['ke']?.toString() ?? '-').isEmpty
                ? '-'
                : (e['to_user']?.toString() ?? e['ke']?.toString() ?? '-'),
            '[EVIDENCE]:${e['evidence'] ?? e['evidence_files'] ?? ''}§${e['evidence_filename'] ?? ''}',
          ]);
        }
      }
    }

    // 2. Header Pengeluaran dan Kantor (As Separator for Tabel 5)
    bankBoldRows.add(bankRows.length);
    bankRows.add([
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

    if (allBatches.isNotEmpty) {
      int batchCounter = 0;
      for (final batch in allBatches) {
        batchCounter++;
        bankBoldRows.add(bankRows.length);
        final settlementTitle =
            (batch.first['settlement_title'] ?? 'Tanpa Settlement').toString();
        bankRows.add([
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

        // Group by Bank -> Subcategory for THIS batch
        final Map<String, Map<String, List<Map<String, dynamic>>>>
            batchByBankSub = {};
        for (var e in batch) {
          String bank = (e['bank_name']?.toString() ?? '').trim();
          if (bank.isEmpty ||
              bank == 'None' ||
              bank.toLowerCase() == 'null' ||
              bank == '-') {
            // Fallback to source (BCA, BRI, etc.) if bank_name is empty
            bank = (e['source']?.toString() ?? '').trim();
          }
          if (bank.isEmpty || bank == 'None' || bank.toLowerCase() == 'null') {
            bank = '-';
          }
          final sub = expenseSubcategoryLabel(e);
          batchByBankSub
              .putIfAbsent(bank, () => {})
              .putIfAbsent(sub, () => [])
              .add(e);
        }

        for (var bank in batchByBankSub.keys.toList()..sort()) {
          bankBoldRows.add(bankRows.length);
          bankRows.add([
            '',
            '',
            'Bank : $bank',
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

          final items = batchByBankSub[bank]!;
          // Flatten items directly without subcategory headers
          final List<Map<String, dynamic>> allBankItems = [];
          for (var sub in items.keys.toList()..sort()) {
            allBankItems.addAll(items[sub]!);
          }

          for (int i = 0; i < allBankItems.length; i++) {
            final e = allBankItems[i];
            rowCounter++;
            final rawAmt = toDouble(e['amount']);
            final rate = toDouble(e['currency_exchange'] ?? 1);
            final currency = normalizeCurrency(e['currency']);

            final amt = (currency != 'IDR')
                ? rawAmt * rate
                : toDouble(e['idr_amount'] ?? e['amount']);

            final idx = getFilteredCatIndex(e['category_name'] ?? '');
            final rowCats = List<String>.filled(catHeaders.length, '');
            if (idx != -1 && idx < catHeaders.length) {
              rowCats[idx] = fmtMoney(amt);
              bankCatTotals[idx] += amt;
            }
            batchTotal += amt;
            grandTotalBank += amt;
            currentItemIndex++;

            bankRows.add([
              fmtDate(e['date']),
              '$rowCounter',
              e['description']?.toString() ?? '',
              (e['source']?.toString() ?? '').isEmpty
                  ? ''
                  : e['source'].toString(),
              fmtAmount(e['amount'], e['currency']),
              currency,
              rate.toStringAsFixed(0),
              ...rowCats,
              fmtMoney(amt),
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

    bankRows.add([
      'TOTAL',
      '',
      '',
      '',
      '',
      '',
      '',
      ...bankCatTotals.map(fmtMoney),
      fmtMoney(grandTotalBank),
      fmtMoney(grandTotalBank),
      '',
      '',
      '-',
    ]);
    tableDataCache[targetCacheKey] = ReportTableData(
      rows: bankRows,
      boldRows: bankBoldRows,
      headers: catHeaders,
    );
  }
}
