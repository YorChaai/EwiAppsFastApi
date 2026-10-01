// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/master_data/tax_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/screens/management/tax_management_screen_actions.dart';
import 'package:expense_app/screens/management/tax_management_screen_dialogs.dart';
import 'package:expense_app/screens/management/tax_management_screen_tables.dart';


class TaxManagementScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialFilterMode;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const TaxManagementScreen({
    super.key,
    this.initialYear,
    this.initialFilterMode,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<TaxManagementScreen> createState() => TaxManagementScreenState();
}

class TaxManagementScreenState extends State<TaxManagementScreen> {
  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  late int selectedYear;
  late String filterMode;
  DateTime? customStartDate;
  DateTime? customEndDate;
  final dateFmt = DateFormat('yyyy-MM-dd');
  final displayFmt = DateFormat('dd-MMM-yy');
  final List<int> selectedTaxIds = <int>[];

  // Helper untuk theme-aware colors
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color textColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
  Color secondaryTextColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color creamColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  @override
  void initState() {
    super.initState();
    final prov = context.read<SettlementProvider>();
    selectedYear = widget.initialYear ?? prov.reportYear;
    filterMode = widget.initialFilterMode ?? 'report';
    customStartDate = widget.initialStartDate;
    customEndDate = widget.initialEndDate;

    final taxProv = context.read<TaxProvider>();

    // ✅ Sync this provider's year with the centralized settings before loading
    Future.microtask(() async {
      await taxProv.syncReportYear();
      if (mounted) loadData();
    });
  }

  String get startDate => filterMode == 'range' && customStartDate != null
      ? dateFmt.format(customStartDate!)
      : '$selectedYear-01-01';
  String get endDate => filterMode == 'range' && customEndDate != null
      ? dateFmt.format(customEndDate!)
      : '$selectedYear-12-31';

  Map<int, Map<String, dynamic>> groupByRowId(List<dynamic> groups) {
    final map = <int, Map<String, dynamic>>{};
    for (final raw in groups) {
      final group = Map<String, dynamic>.from(raw as Map);
      final rowIds = (group['row_ids'] as List?) ?? const [];
      for (final rowId in rowIds) {
        final parsed = int.tryParse('$rowId');
        if (parsed != null) {
          map[parsed] = group;
        }
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<TaxProvider>();
    final items = prov.taxes;
    final groupMap = groupByRowId(prov.combineGroups);

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 550;

    final List<String> headers = [
      'Pilih',
      'Group',
      'Date',
      '#',
      'Detail/Description',
      'Inv Value USD',
      'Transaction Value',
      'Currency',
      'Rate',
      'Transaction Value(child=IDR)',
      'PPN Base',
      'PPN',
      'PPh 21 Base',
      'PPh 21',
      'PPh 23 Base',
      'PPh 23',
      'PPh 26 Base',
      'PPh 26',
      'Pemasukan Negara Base',
      'Pajak (Pemasukan Negara)',
      'Aksi'
    ];

    final List<double> colWidths = [
      50, // Pilih
      70, // Group
      110, // Date
      40, // #
      300, // Detail
      150, // Inv USD
      150, // Trans Master
      80, // Currency
      100, // Rate
      150, // Trans IDR
      130, // PPN Base
      120, // PPN
      130, // PPh 21 Base
      120, // PPh 21
      130, // PPh 23 Base
      120, // PPh 23
      130, // PPh 26 Base
      120, // PPh 26
      130, // PN Base
      120, // PN Pajak
      100, // Aksi
    ];

    final double outerBorderWidth = 1.0;
    final totalWidth = colWidths.fold<double>(0, (sum, w) => sum + w);

    // Pre-process items into groups for rendering
    final List<List<Map<String, dynamic>>> renderedGroups = [];
    for (int i = 0; i < items.length; i++) {
      final item = Map<String, dynamic>.from(items[i] as Map);
      final rowId = itemId(item);
      final group = groupMap[rowId];

      if (group != null) {
        final groupId = int.tryParse(group['id']?.toString() ?? '') ?? 0;
        bool exists = false;
        for (var g in renderedGroups) {
          if (g.isNotEmpty) {
            final firstInG = g[0];
            final gId = int.tryParse(
                    groupMap[itemId(firstInG)]?['id']?.toString() ?? '') ??
                0;
            if (gId == groupId) {
              g.add(item);
              exists = true;
              break;
            }
          }
        }
        if (!exists) renderedGroups.add([item]);
      } else {
        renderedGroups.add([item]);
      }
    }

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: useCompact
            ? const SizedBox.shrink()
            : const Text('Input Pajak Pengeluaran'),
        backgroundColor: cardColor(context),
        titleSpacing: useCompact ? 0 : NavigationToolbar.kMiddleSpacing,
        actions: [
          // Filter Periode Cascading (Laporan, Year, Range)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CascadingYearFilter(
              selectedYear: selectedYear,
              currentMode: filterMode,
              useCompact: false,
              onSelected: (year, mode) {
                setState(() {
                  selectedYear = year;
                  filterMode = mode;
                  selectedTaxIds.clear();
                });

                // ✅ Sync all providers with the selected year
                context.read<CascadeProvider>().syncReportYear(context, year);

                loadData();
              },
              onRangeTap: () async {
                final range = await AppDateRangePicker.show(context);
                if (range != null) {
                  if (!mounted) return;
                  setState(() {
                    filterMode = 'range';
                    selectedTaxIds.clear();
                  });
                  if (!context.mounted) return;
                  final provider = context.read<TaxProvider>();
                  await provider.loadTaxes(
                    year: null,
                    mode: 'range',
                    startDate: DateFormat('yyyy-MM-dd').format(range.start),
                    endDate: DateFormat('yyyy-MM-dd').format(range.end),
                  );
                }
              },
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showTaxDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: prov.isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : RefreshIndicator(
              onRefresh: loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (useCompact) ...[
                      Text(
                        'Input Pajak Pengeluaran',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: textColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: prov.isLoading ? null : manageTaxCombine,
                          icon: const Icon(Icons.merge_type_rounded),
                          label: const Text('Manager Gabungan Pajak'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        if (selectedTaxIds.isNotEmpty)
                          TextButton(
                            onPressed: () =>
                                setState(() => selectedTaxIds.clear()),
                            child: const Text('Batal Pilih'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manual combine default-nya kosong. Pilih baris berurutan dengan tanggal yang sama persis, lalu tekan Combine Manual.',
                      style: TextStyle(color: secondaryTextColor(context)),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: totalWidth + (outerBorderWidth * 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: dividerColor(context),
                              width: outerBorderWidth),
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              height: 48,
                              color: cardColor(context),
                              child: Row(
                                children: headers.asMap().entries.map((e) {
                                  return buildCell(
                                    e.value,
                                    colWidths[e.key],
                                    isHeader: true,
                                    isLast: e.key == headers.length - 1,
                                  );
                                }).toList(),
                              ),
                            ),
                            // Body
                            Column(
                              children: renderedGroups.map((groupItems) {
                                final isGroup = groupItems.length > 1;
                                final firstItem = groupItems[0];
                                final groupInfo =
                                    groupMap[itemId(firstItem)];
                                final List<dynamic> groupRowIds =
                                    (groupInfo?['row_ids'] as List?) ??
                                        const [];
                                final int? primaryRowId = groupRowIds.isNotEmpty
                                    ? int.tryParse('${groupRowIds.first}')
                                    : null;
                                final Map<String, dynamic> primaryItem =
                                    primaryRowId != null
                                        ? (groupItems.firstWhere(
                                            (it) => itemId(it) == primaryRowId,
                                            orElse: () => firstItem,
                                          ))
                                        : firstItem;
                                final List<String> mergedFields =
                                    groupInfo != null
                                        ? List<String>.from(
                                            groupInfo['merged_columns'] ?? [])
                                        : [];

                                final fieldToIndex = {
                                  'date': 2,
                                  'description': 4,
                                  'invoice_value_usd': 5,
                                  'transaction_value': 6,
                                  'currency': 7,
                                  'currency_exchange': 8,
                                  'transaction_value_idr': 9,
                                  'ppn_base': 10,
                                  'ppn': 11,
                                  'pph_21_base': 12,
                                  'pph_21': 13,
                                  'pph_23_base': 14,
                                  'pph_23': 15,
                                  'pph_26_base': 16,
                                  'pph_26': 17,
                                  'pemasukan_negara_base': 18,
                                  'pemasukan_negara': 19,
                                };

                                final List<int> mergeCols = [1];
                                if (isGroup) {
                                  if (mergedFields.isEmpty) {
                                    mergeCols.addAll([2, 4, 20]);
                                  } else {
                                    for (var f in mergedFields) {
                                      if (fieldToIndex.containsKey(f)) {
                                        mergeCols.add(fieldToIndex[f]!);
                                      }
                                    }
                                    mergeCols.add(20);
                                  }
                                }

                                const double rowHeight = 48.0;
                                final groupHeight =
                                    groupItems.length * rowHeight;

                                return Container(
                                  height: groupHeight + 0.5,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: dividerColor(context),
                                          width: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    children:
                                        headers.asMap().entries.map((header) {
                                      final colIdx = header.key;
                                      final isMerged =
                                          mergeCols.contains(colIdx);

                                      if (isMerged) {
                                        dynamic val;
                                        Alignment align = Alignment.center;
                                        if (colIdx == 1) {
                                          val = 'C${groupInfo?['id']}';
                                        } else if (colIdx == 2) {
                                          val =
                                              displayDate(primaryItem['date']);
                                        } else if (colIdx == 4) {
                                          val = primaryItem['description'];
                                          align = Alignment.centerLeft;
                                        } else if (colIdx == 5) {
                                          val = formatNumericInput(
                                              primaryItem['invoice_value_usd']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 6) {
                                          val = formatNumericInput(
                                              primaryItem['transaction_value']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 7) {
                                          val = primaryItem['currency'];
                                        } else if (colIdx == 8) {
                                          val =
                                              primaryItem['currency_exchange'];
                                        } else if (colIdx == 9) {
                                          final v = double.tryParse(primaryItem[
                                                          'transaction_value']
                                                      ?.toString() ??
                                                  '0') ??
                                              0;
                                          val = fmtMoney((primaryItem[
                                                  'transaction_value_idr'] ??
                                              (v *
                                                  (double.tryParse(primaryItem[
                                                                  'currency_exchange']
                                                              ?.toString() ??
                                                          '1') ??
                                                      1))));
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 10) {
                                          val = formatNumericInput(primaryItem[
                                                  'ppn_base'] ??
                                              primaryItem['transaction_value']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 11) {
                                          val = formatNumericInput(
                                              primaryItem['ppn']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 12) {
                                          val = formatNumericInput(primaryItem[
                                                  'pph_21_base'] ??
                                              primaryItem['transaction_value']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 13) {
                                          val = formatNumericInput(
                                              primaryItem['pph_21']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 14) {
                                          val = formatNumericInput(primaryItem[
                                                  'pph_23_base'] ??
                                              primaryItem['transaction_value']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 15) {
                                          val = formatNumericInput(
                                              primaryItem['pph_23']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 16) {
                                          val = formatNumericInput(primaryItem[
                                                  'pph_26_base'] ??
                                              primaryItem['transaction_value']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 17) {
                                          val = formatNumericInput(
                                              primaryItem['pph_26']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 18) {
                                          val = formatNumericInput(primaryItem[
                                              'pemasukan_negara_base']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 19) {
                                          val = formatNumericInput(
                                              primaryItem['pemasukan_negara']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 20) {
                                          val = Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () =>
                                                    showTaxDialog(primaryItem),
                                                icon: Icon(Icons.edit,
                                                    color: AppTheme.accent,
                                                    size: 20),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    deleteTax(primaryItem),
                                                icon: Icon(Icons.delete_outline,
                                                    color: AppTheme.danger,
                                                    size: 20),
                                              ),
                                            ],
                                          );
                                        }

                                        return buildCell(
                                          val ?? '',
                                          colWidths[colIdx],
                                          alignment: align,
                                          isLast: colIdx == headers.length - 1,
                                          noBottomBorder: true,
                                        );
                                      } else {
                                        return Column(
                                          children: groupItems.map((item) {
                                            final rowId = itemId(item);
                                            final isSelected =
                                                selectedTaxIds.contains(rowId);
                                            dynamic val;
                                            Alignment align = Alignment.center;

                                            if (colIdx == 0) {
                                              val = Checkbox(
                                                value: isSelected,
                                                onChanged: (v) {
                                                  setState(() {
                                                    if (v == true) {
                                                      selectedTaxIds
                                                          .add(rowId);
                                                    } else {
                                                      selectedTaxIds
                                                          .remove(rowId);
                                                    }
                                                  });
                                                },
                                              );
                                            } else if (colIdx == 1) {
                                              val = '-';
                                            } else if (colIdx == 2) {
                                              val = displayDate(item['date']);
                                            } else if (colIdx == 3) {
                                              final overallIdx =
                                                  items.indexWhere((it) =>
                                                      itemId(it) == rowId);
                                              val = '${overallIdx + 1}';
                                            } else if (colIdx == 4) {
                                              val = item['description'];
                                              align = Alignment.centerLeft;
                                            } else if (colIdx == 5) {
                                              val = formatNumericInput(
                                                  item['invoice_value_usd']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 6) {
                                              val = formatNumericInput(
                                                  item['transaction_value']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 7) {
                                              val = item['currency'];
                                            } else if (colIdx == 8) {
                                              val = item['currency_exchange'];
                                            } else if (colIdx == 9) {
                                              final v = double.tryParse(
                                                      item['transaction_value']
                                                              ?.toString() ??
                                                          '0') ??
                                                  0;
                                              val = fmtMoney((item[
                                                      'transaction_value_idr'] ??
                                                  (v *
                                                      (double.tryParse(item[
                                                                      'currency_exchange']
                                                                  ?.toString() ??
                                                              '1') ??
                                                          1))));
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 10) {
                                              val = formatNumericInput(item[
                                                      'ppn_base'] ??
                                                  item['transaction_value']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 11) {
                                              val = formatNumericInput(
                                                  item['ppn']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 12) {
                                              val = formatNumericInput(item[
                                                      'pph_21_base'] ??
                                                  item['transaction_value']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 13) {
                                              val = formatNumericInput(
                                                  item['pph_21']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 14) {
                                              val = formatNumericInput(item[
                                                      'pph_23_base'] ??
                                                  item['transaction_value']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 15) {
                                              val = formatNumericInput(
                                                  item['pph_23']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 16) {
                                              val = formatNumericInput(item[
                                                      'pph_26_base'] ??
                                                  item['transaction_value']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 17) {
                                              val = formatNumericInput(
                                                  item['pph_26']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 18) {
                                              val = formatNumericInput(item[
                                                  'pemasukan_negara_base']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 19) {
                                              val = formatNumericInput(
                                                  item['pemasukan_negara']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 20) {
                                              val = Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () =>
                                                        showTaxDialog(item),
                                                    icon: Icon(Icons.edit,
                                                        color: AppTheme.accent,
                                                        size: 20),
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        deleteTax(item),
                                                    icon: Icon(
                                                        Icons.delete_outline,
                                                        color: AppTheme.danger,
                                                        size: 20),
                                                  ),
                                                ],
                                              );
                                            }

                                            return Container(
                                              height: rowHeight,
                                              width: colWidths[colIdx],
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? (isDark(context)
                                                        ? AppTheme.cardHover
                                                        : AppTheme
                                                            .lightCardHover)
                                                    : null,
                                              ),
                                              child: buildCell(
                                                val ?? '',
                                                colWidths[colIdx],
                                                alignment: align,
                                                isLast: colIdx ==
                                                    headers.length - 1,
                                                noLeftBorder: true,
                                                noBottomBorder:
                                                    item == groupItems.last,
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                    }).toList(),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }
}
