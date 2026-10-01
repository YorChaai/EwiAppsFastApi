// import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/transactions/revenue_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';
import 'package:expense_app/screens/management/revenue_management_screen_actions.dart';
import 'package:expense_app/screens/management/revenue_management_screen_dialogs.dart';
import 'package:expense_app/screens/management/revenue_management_screen_tables.dart';


class RevenueManagementScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialFilterMode;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const RevenueManagementScreen({
    super.key,
    this.initialYear,
    this.initialFilterMode,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<RevenueManagementScreen> createState() =>
      RevenueManagementScreenState();
}

class RevenueManagementScreenState extends State<RevenueManagementScreen> {
  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  late int selectedYear;
  late String filterMode;
  DateTime? customStartDate;
  DateTime? customEndDate;
  final dateFmt = DateFormat('yyyy-MM-dd');
  final displayFmt = DateFormat('dd-MMM-yy');
  final numberFmt = NumberFormat('#,##0', 'id_ID');
  final List<int> selectedRevenueIds = <int>[];

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

    final revenueProv = context.read<RevenueProvider>();

    // ✅ Sync this provider's year with the centralized settings before loading
    Future.microtask(() async {
      await revenueProv.syncReportYear();
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
    final prov = context.watch<RevenueProvider>();
    final items = prov.revenues;
    final groupMap = groupByRowId(prov.combineGroups);

    final screenWidth = MediaQuery.of(context).size.width;
    final useCompact = screenWidth < 550;

    final List<String> headers = [
      'Pilih',
      'Group',
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
      'Aksi'
    ];

    final List<double> colWidths = [
      50, // Pilih
      70, // Group
      110, // Invoice Date
      40, // #
      300, // Detail/Description
      150, // USD Val
      150, // IDR Val
      80, // Currency
      100, // Rate
      130, // Inv Num
      130, // Client
      110, // Recv Date
      150, // Recv IDR
      150, // Recv USD
      130, // PPn
      130, // PPh
      120, // Fee
      140, // Sumber Dana
      200, // Remark
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
        // Cek apakah grup ini sudah dimulai
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
        title:
            useCompact ? const SizedBox.shrink() : const Text('Input Revenue'),
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
                  selectedRevenueIds.clear();
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
                    selectedRevenueIds.clear();
                  });
                  if (!context.mounted) return;
                  final provider = context.read<RevenueProvider>();
                  await provider.loadRevenues(
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
        onPressed: () => showRevenueDialog(),
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
                        'Input Revenue',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: creamColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed:
                              prov.isLoading ? null : manageRevenueCombine,
                          icon: const Icon(Icons.merge_type_rounded),
                          label: const Text('Manager Gabungan Baris'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        if (selectedRevenueIds.isNotEmpty)
                          TextButton(
                            onPressed: () =>
                                setState(() => selectedRevenueIds.clear()),
                            child: const Text('Batal Pilih'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manual combine default-nya kosong. Pilih baris berurutan dengan Receive Date yang sama persis, lalu tekan Combine Manual.',
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
                                  'invoice_date': 2,
                                  'description': 4,
                                  'invoice_value': 5,
                                  'invoice_value_usd': 5,
                                  'invoice_value_idr': 6,
                                  'currency': 7,
                                  'currency_exchange': 8,
                                  'invoice_number': 9,
                                  'client': 10,
                                  'receive_date': 11,
                                  'amount_received': 12,
                                  'amount_received_idr': 12,
                                  'amount_received_usd': 13,
                                  'ppn': 14,
                                  'pph_23': 15,
                                  'transfer_fee': 16,
                                  'bank_id': 17,
                                  'bank_name': 17,
                                  'remark': 18,
                                };

                                final List<int> mergeCols = [1]; // Group col
                                if (isGroup) {
                                  if (mergedFields.isEmpty) {
                                    mergeCols.addAll([2, 4, 9, 10, 11, 19]);
                                  } else {
                                    for (var f in mergedFields) {
                                      if (fieldToIndex.containsKey(f)) {
                                        mergeCols.add(fieldToIndex[f]!);
                                      }
                                    }
                                    mergeCols.add(19); // Aksi
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
                                        // Render single cell for the whole group
                                        dynamic val;
                                        Alignment align = Alignment.center;
                                        if (colIdx == 1) {
                                          val = 'C${groupInfo?['id']}';
                                        } else if (colIdx == 2) {
                                          val = displayDate(
                                              primaryItem['invoice_date']);
                                        } else if (colIdx == 4) {
                                          val = primaryItem['description'];
                                          align = Alignment.centerLeft;
                                        } else if (colIdx == 5) {
                                          val = formatNumericInput(
                                              primaryItem['invoice_value_usd']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 6) {
                                          val = formatNumericInput(
                                              primaryItem['invoice_value_idr']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 7) {
                                          val = primaryItem['currency'];
                                        } else if (colIdx == 8) {
                                          val =
                                              primaryItem['currency_exchange'];
                                        } else if (colIdx == 9) {
                                          val = primaryItem['invoice_number'];
                                        } else if (colIdx == 10) {
                                          val = primaryItem['client'];
                                        } else if (colIdx == 11) {
                                          val = displayDate(
                                              primaryItem['receive_date']);
                                        } else if (colIdx == 12) {
                                          val = formatNumericInput(primaryItem[
                                              'amount_received_idr']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 13) {
                                          val = formatNumericInput(primaryItem[
                                              'amount_received_usd']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 14) {
                                          val = formatNumericInput(
                                              primaryItem['ppn']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 15) {
                                          val = formatNumericInput(
                                              primaryItem['pph_23']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 16) {
                                          val = formatNumericInput(
                                              primaryItem['transfer_fee']);
                                          align = Alignment.centerRight;
                                        } else if (colIdx == 17) {
                                          final bName = primaryItem['bank_name'] ??
                                              (primaryItem['bank'] is Map
                                                  ? primaryItem['bank']['name']
                                                  : null);
                                          val = (bName != null &&
                                                  bName.toString().trim().isNotEmpty)
                                              ? bName.toString()
                                              : '-';
                                        } else if (colIdx == 18) {
                                          val = primaryItem['remark'];
                                        } else if (colIdx == 19) {
                                          val = Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () =>
                                                    showRevenueDialog(
                                                        primaryItem),
                                                icon: Icon(Icons.edit,
                                                    color: AppTheme.accent,
                                                    size: 20),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    deleteRevenue(primaryItem),
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
                                        // Render column of individual cells
                                        return Column(
                                          children: groupItems.map((item) {
                                            final rowId = itemId(item);
                                            final isSelected =
                                                selectedRevenueIds
                                                    .contains(rowId);
                                            dynamic val;
                                            Alignment align = Alignment.center;

                                            if (colIdx == 0) {
                                              val = Checkbox(
                                                value: isSelected,
                                                onChanged: (v) {
                                                  setState(() {
                                                    if (v == true) {
                                                      selectedRevenueIds
                                                          .add(rowId);
                                                    } else {
                                                      selectedRevenueIds
                                                          .remove(rowId);
                                                    }
                                                  });
                                                },
                                              );
                                            } else if (colIdx == 1) {
                                              val = '-';
                                            } else if (colIdx == 2) {
                                              val = displayDate(
                                                  item['invoice_date']);
                                            } else if (colIdx == 3) {
                                              // Find overall index in items list
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
                                                  item['invoice_value_idr']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 7) {
                                              val = item['currency'];
                                            } else if (colIdx == 8) {
                                              val = item['currency_exchange'];
                                            } else if (colIdx == 9) {
                                              val = item['invoice_number'];
                                            } else if (colIdx == 10) {
                                              val = item['client'];
                                            } else if (colIdx == 11) {
                                              val = displayDate(
                                                  item['receive_date']);
                                            } else if (colIdx == 12) {
                                              val = formatNumericInput(
                                                  item['amount_received_idr']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 13) {
                                              val = formatNumericInput(
                                                  item['amount_received_usd']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 14) {
                                              val = formatNumericInput(
                                                  item['ppn']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 15) {
                                              val = formatNumericInput(
                                                  item['pph_23']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 16) {
                                              val = formatNumericInput(
                                                  item['transfer_fee']);
                                              align = Alignment.centerRight;
                                            } else if (colIdx == 17) {
                                              final bName = item['bank_name'] ??
                                                  (item['bank'] is Map
                                                      ? item['bank']['name']
                                                      : null);
                                              val = (bName != null &&
                                                      bName.toString().trim().isNotEmpty)
                                                  ? bName.toString()
                                                  : '-';
                                            } else if (colIdx == 18) {
                                              val = item['remark'];
                                            } else if (colIdx == 19) {
                                              val = Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () =>
                                                        showRevenueDialog(
                                                            item),
                                                    icon: Icon(Icons.edit,
                                                        color: AppTheme.accent,
                                                        size: 20),
                                                  ),
                                                  IconButton(
                                                    onPressed: () =>
                                                        deleteRevenue(item),
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
