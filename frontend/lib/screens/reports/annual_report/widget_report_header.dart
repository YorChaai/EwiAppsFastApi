import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_tables.dart';


extension AnnualReportWidgetsReportHeaderExt on AnnualReportScreenState {
  Widget buildReportHeader(bool useCompact) {
    final inputItems = [
      const CascadingMenuItem(
        id: 'input_income',
        label: 'Pemasukan',
        icon: Icons.payments_outlined,
      ),
      const CascadingMenuItem(
        id: 'input_tax',
        label: 'Pajak',
        icon: Icons.account_balance_outlined,
      ),
      const CascadingMenuItem(
        id: 'input_bank',
        label: 'Bank Status',
        icon: Icons.swap_horiz_rounded,
      ),
      const CascadingMenuItem(
        id: 'input_balance',
        label: 'Laba Rugi / Neraca',
        icon: Icons.assessment_outlined,
      ),
      const CascadingMenuItem(
        id: 'input_dividend',
        label: 'Dividen',
        icon: Icons.wallet_outlined,
      ),
      const CascadingMenuItem(
        id: 'input_asset',
        label: 'Input Aset Baru',
        icon: Icons.inventory_2_outlined,
      ),
    ];

    final sheetItems = [
      CascadingMenuItem(
        id: 'sheet1',
        label: '1. Operasional (Pemasukan & Biaya)',
        icon: Icons.table_rows_rounded,
        selected: activeSheet == 'sheet1',
      ),
      CascadingMenuItem(
        id: 'sheet2',
        label: '2. Keuangan (Laba Rugi & Neraca)',
        icon: Icons.analytics_outlined,
        selected: activeSheet == 'sheet2',
      ),
      CascadingMenuItem(
        id: 'sheet3',
        label: '3. Analisis (Business Summary)',
        icon: Icons.summarize_outlined,
        selected: activeSheet == 'sheet3',
      ),
    ];

    final columnConfigs = switch (activeSheet) {
      'sheet1' => [
          ('t1', 'Tabel 1: Pemasukan'),
          ('t2', 'Tabel 2: Pajak'),
          ('t3', 'Tabel 3: Bank Status'),
          ('t3a', 'Tabel 3A: Bank Admin (Detail Item)'),
          ('t3b', 'Tabel 3B: Bank Admin (Pengiriman Dana)'),
          ('t3c', 'Tabel 3C: Pengembalian Dana'),
          ('t4a', 'Tabel 4A: Pengeluaran'),
          ('t4b', 'Tabel 4B: Pengeluaran (Bank)'),
          ('t4c', 'Tabel 4C: Pengeluaran Kasbon'),
          ('t4d', 'Tabel 4D: Pengeluaran Kasbon (Bank)'),
          ('t5', 'Tabel 5: Asset Register'),
        ],
      'sheet2' => [('t7', 'Tabel 7: Laba Rugi'), ('t8', 'Tabel 8: Neraca')],
      'sheet3' => [
          ('t9', 'Tabel 9: Business Summary'),
          ('t10', 'Tabel 10: Dividen'),
        ],
      _ => [
          ('t1', 'Tabel 1: Pemasukan'),
          ('t2', 'Tabel 2: Pajak'),
          ('t3', 'Tabel 3: Bank Status'),
          ('t3a', 'Tabel 3A: Bank Admin (Detail Item)'),
          ('t3b', 'Tabel 3B: Bank Admin (Pengiriman Dana)'),
          ('t3c', 'Tabel 3C: Pengembalian Dana'),
          ('t4a', 'Tabel 4A: Pengeluaran'),
          ('t4b', 'Tabel 4B: Pengeluaran (Bank)'),
          ('t4c', 'Tabel 4C: Pengeluaran Kasbon'),
          ('t4d', 'Tabel 4D: Pengeluaran Kasbon (Bank)'),
          ('t5', 'Tabel 5: Asset Register'),
        ],
    };

    final currentConfigs = getAvailableTableIds(activeSheet);
    final allSelected = currentConfigs.isNotEmpty &&
        currentConfigs.every((id) => visibleTables.contains(id));

    final columnItems = [
      CascadingMenuItem(
        id: 'all',
        label: 'Semua',
        icon: Icons.select_all_rounded,
        selected: allSelected,
      ),
      ...columnConfigs.map(
        (config) => CascadingMenuItem(
          id: config.$1,
          label: config.$2,
          icon: Icons.view_column_rounded,
          selected: visibleTables.contains(config.$1),
        ),
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        CascadingMenuCustom(
          label: 'Input',
          icon: Icons.input_rounded,
          useCompact: useCompact,
          items: inputItems,
          onSelected: (id) => Future.delayed(Duration.zero, () {
            handleInputMenuSelection(id);
          }),
        ),
        CascadingMenuCustom(
          label: 'Sheet',
          icon: Icons.layers_outlined,
          useCompact: useCompact,
          items: sheetItems,
          onSelected: (id) => applySheet(id),
        ),
        CascadingMenuCustom(
          label: 'Kolom',
          icon: Icons.view_column_outlined,
          useCompact: useCompact,
          items: columnItems,
          onSelected: (id) => toggleTableVisibility(id),
          closeOnSelect: false,
        ),
        SizedBox(
          width: useCompact ? double.infinity : 250,
          height: useCompact ? 36 : 40,
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              updateState(() {
                searchQuery = val;
              });
            },
            style: TextStyle(
                color: titleColor(context), fontSize: useCompact ? 13 : 14),
            decoration: InputDecoration(
              hintText: 'Cari tabel (teks/tanggal)...',
              hintStyle: TextStyle(color: bodyColor(context), fontSize: 13),
              prefixIcon:
                  Icon(Icons.search, color: bodyColor(context), size: 18),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear,
                          size: 16, color: bodyColor(context)),
                      tooltip: 'Hapus Pencarian',
                      onPressed: () {
                        searchController.clear();
                        updateState(() {
                          searchQuery = '';
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: surfaceColor(context),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: dividerColor(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: dividerColor(context)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
