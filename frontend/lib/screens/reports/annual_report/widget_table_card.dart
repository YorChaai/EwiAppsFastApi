import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_screen.dart';
import 'package:expense_app/screens/reports/annual_report/annual_report_tables.dart';
import 'package:expense_app/screens/reports/annual_report/widget_expense_table_cell.dart';


extension AnnualReportWidgetsTableCardExt on AnnualReportScreenState {
  Widget buildTableCard({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
    required ScrollController controller,
    required ScrollController verticalController,
    Set<int> boldRows = const {},
    bool useCompact = false,
    Map<int, int>? combineGroupMap,
    Map<int, List<String>>? mergedColumnsMap,
    Map<int, Color>? rowColors,
  }) {
    final colWidths = getColumnWidths(title, headers.length, useCompact);
    final totalWidth = colWidths.fold<double>(0, (sum, w) => sum + w);
    const double leftScrollbarSpace = 14;

    // Extract TOTAL row if it exists (usually the last row)
    List<String>? totalRow;
    List<List<String>> dataRows = List.from(rows);
    if (rows.isNotEmpty &&
        (rows.last.first == 'TOTAL' || rows.last.first == 'Total')) {
      totalRow = rows.last;
      dataRows.removeLast();
    }

    return Card(
      color: cardColor(context),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: dividerColor(context)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: useCompact ? 6 : 10,
          vertical: useCompact ? 8 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor(context),
                fontWeight: FontWeight.bold,
                fontSize: useCompact ? 14 : 15,
              ),
            ),
            const SizedBox(height: 6),
            AppScrollbar(
              controller: verticalController,
              thumbVisibility: true,
              interactive: true,
              scrollbarOrientation: ScrollbarOrientation.left,
              notificationPredicate: (notification) =>
                  notification.metrics.axis == Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: leftScrollbarSpace),
                child: AppScrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  interactive: true,
                  scrollDirection: Axis.horizontal,
                  notificationPredicate: (notification) =>
                      notification.metrics.axis == Axis.horizontal,
                  child: SingleChildScrollView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    child: SizedBox(
                      width: totalWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row (STAY/FIXED)
                          Container(
                            width: totalWidth,
                            height: (useCompact ? 48.0 : 56.0) * zoomLevel,
                            decoration: BoxDecoration(
                              color: surfaceColor(context),
                              border: Border(
                                bottom: BorderSide(
                                  color: dividerColor(
                                    context,
                                  ).withValues(alpha: 0.5),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: headers.asMap().entries.map((e) {
                                return buildExpenseTableCell(
                                  value: e.value,
                                  width: colWidths[e.key],
                                  useCompact: useCompact,
                                  isBold: true,
                                  index: e.key,
                                  textAlign: (e.key == 0 &&
                                          (title.contains('Tabel 9') ||
                                              title.contains('Tabel 10')))
                                      ? TextAlign.center
                                      : (e.key == 2 &&
                                              title.contains('Tabel 10'))
                                          ? TextAlign.center
                                          : (e.key == 1 &&
                                                  !title.contains('Tabel 9') &&
                                                  !title.contains('Tabel 10'))
                                              ? TextAlign.center
                                              : (isNumericLikeCell(
                                                  headers[e.key],
                                                  e.key,
                                                  e.value,
                                                )
                                                  ? TextAlign.right
                                                  : TextAlign.left),
                                  fontSize: 13,
                                  isLast: e.key == headers.length - 1,
                                );
                              }).toList(),
                            ),
                          ),
                          // Body
                          Builder(
                            builder: (context) {
                              final stableRowHeight =
                                  title.contains('Tabel 4') ? 60.0 : 52.0;
                              final viewportHeight = math
                                  .min(
                                    dataRows.length * stableRowHeight,
                                    useCompact ? 650.0 : 800.0,
                                  )
                                  .toDouble()
                                  .clamp(100.0, 800.0);
                              return SizedBox(
                                height: viewportHeight,
                                child: RepaintBoundary(
                                  child:
                                      NotificationListener<ScrollNotification>(
                                    onNotification: (notification) {
                                      if (notification.metrics.axis ==
                                              Axis.vertical &&
                                          scrollController.hasClients) {
                                        final m = notification.metrics;
                                        if (notification
                                                is ScrollUpdateNotification &&
                                            notification.scrollDelta != null) {
                                          final d = notification.scrollDelta!;
                                          if ((d > 0 &&
                                                  m.pixels >=
                                                      m.maxScrollExtent) ||
                                              (d < 0 && m.pixels <= 0)) {
                                            scrollController.position.jumpTo(
                                              (scrollController.offset + d)
                                                  .clamp(
                                                0,
                                                scrollController
                                                    .position.maxScrollExtent,
                                              ),
                                            );
                                          }
                                        } else if (notification
                                            is OverscrollNotification) {
                                          scrollController.position.jumpTo(
                                            (scrollController.offset +
                                                    notification.overscroll)
                                                .clamp(
                                              0,
                                              scrollController
                                                  .position.maxScrollExtent,
                                            ),
                                          );
                                        }
                                      }
                                      return false;
                                    },
                                    child: () {
                                      // Pre-process items into groups for rendering
                                      final List<List<int>>
                                          renderedGroupIndices = [];
                                      final query = searchQuery.toLowerCase();
                                      final matchSet = <int>{};

                                      // Step 1: Direct matching & Total rows
                                      for (int i = 0;
                                          i < dataRows.length;
                                          i++) {
                                        final row = dataRows[i];
                                        final isTotal = row.isNotEmpty &&
                                            row.first
                                                .toUpperCase()
                                                .contains('TOTAL');
                                        if (isTotal) {
                                          matchSet.add(i);
                                        } else if (query.isEmpty ||
                                            row.any((cell) => cell
                                                .toLowerCase()
                                                .contains(query))) {
                                          matchSet.add(i);
                                        }
                                      }

                                      // Step 2: Combine Groups - if any matches, all match
                                      if (query.isNotEmpty &&
                                          combineGroupMap != null) {
                                        final groupMatchIds = <int>{};
                                        for (int i = 0;
                                            i < dataRows.length;
                                            i++) {
                                          if (matchSet.contains(i)) {
                                            final gId = combineGroupMap[i];
                                            if (gId != null && gId > 0) {
                                              groupMatchIds.add(gId);
                                            }
                                          }
                                        }
                                        for (int i = 0;
                                            i < dataRows.length;
                                            i++) {
                                          final gId = combineGroupMap[i];
                                          if (gId != null &&
                                              groupMatchIds.contains(gId)) {
                                            matchSet.add(i);
                                          }
                                        }
                                      }

                                      // Step 3: Bold Header rows - if any child matches, header matches
                                      if (query.isNotEmpty) {
                                        int lastHeaderIdx = -1;
                                        bool headerHasMatchingChild = false;
                                        for (int i = 0;
                                            i < dataRows.length;
                                            i++) {
                                          if (boldRows.contains(i)) {
                                            if (lastHeaderIdx != -1 &&
                                                headerHasMatchingChild) {
                                              matchSet.add(lastHeaderIdx);
                                            }
                                            lastHeaderIdx = i;
                                            headerHasMatchingChild = false;
                                          } else {
                                            if (matchSet.contains(i)) {
                                              headerHasMatchingChild = true;
                                            }
                                          }
                                        }
                                        if (lastHeaderIdx != -1 &&
                                            headerHasMatchingChild) {
                                          matchSet.add(lastHeaderIdx);
                                        }
                                      }

                                      for (int i = 0;
                                          i < dataRows.length;
                                          i++) {
                                        if (query.isNotEmpty &&
                                            !matchSet.contains(i)) {
                                          continue;
                                        }

                                        final groupId = combineGroupMap?[i];
                                        if (groupId != null && groupId > 0) {
                                          bool exists = false;
                                          for (var g in renderedGroupIndices) {
                                            if (g.isNotEmpty &&
                                                combineGroupMap?[g[0]] ==
                                                    groupId) {
                                              g.add(i);
                                              exists = true;
                                              break;
                                            }
                                          }
                                          if (!exists) {
                                            renderedGroupIndices.add([i]);
                                          }
                                        } else {
                                          renderedGroupIndices.add([i]);
                                        }
                                      }

                                      return ListView.builder(
                                        controller: verticalController,
                                        itemCount: renderedGroupIndices.length,
                                        scrollCacheExtent:
                                            const ScrollCacheExtent.pixels(400),
                                        padding: EdgeInsets.zero,
                                        physics: const ClampingScrollPhysics(),
                                        itemBuilder: (context, groupIdx) {
                                          final List<int> rowIndices =
                                              renderedGroupIndices[groupIdx];
                                          final firstRowIdx = rowIndices[0];
                                          final firstRow =
                                              dataRows[firstRowIdx];
                                          final isBold =
                                              boldRows.contains(firstRowIdx);
                                          final groupId =
                                              combineGroupMap?[firstRowIdx];
                                          final isCombineGroup =
                                              groupId != null && groupId > 0;
                                          final mergedFields =
                                              mergedColumnsMap?[firstRowIdx] ??
                                                  [];

                                          Color? groupColor;
                                          if (rowColors != null &&
                                              rowColors.containsKey(firstRowIdx)) {
                                            groupColor = rowColors[firstRowIdx];
                                          } else if (isCombineGroup) {
                                            final isEvenGroup =
                                                (groupId % 2) == 0;
                                            groupColor = isDark(context)
                                                ? (isEvenGroup
                                                    ? AppTheme.divider
                                                    : AppTheme.card)
                                                : (isEvenGroup
                                                    ? AppTheme.lightDivider
                                                        .withValues(alpha: 0.1)
                                                    : AppTheme.lightCardHover);
                                          }

                                          final List<int> mergeCols = [];
                                          if (title.contains('Tabel 1')) {
                                            final fieldToIndex = {
                                              // Core fields
                                              'invoice_date': 0,
                                              'description': 2,
                                              'invoice_number': 7,

                                              // Invoice values
                                              'invoice_value':
                                                  4, // master fallback -> IDR column
                                              'invoice_value_usd': 3,
                                              'invoice_value_idr': 4,

                                              // Currency
                                              'currency': 5,
                                              'currency_exchange': 6,

                                              // Party/date
                                              'client': 8,
                                              'receive_date': 9,

                                              // Amount received
                                              'amount_received':
                                                  10, // master fallback -> IDR column
                                              'amount_received_idr': 10,
                                              'amount_received_usd': 11,

                                              // Tax/fee/bank/remark
                                              'ppn': 12,
                                              'pph_23': 13,
                                              'transfer_fee': 14,
                                              'bank_id': 15,
                                              'bank_name': 15,
                                              'remark': 16,
                                            };
                                            for (var f in mergedFields) {
                                              if (fieldToIndex.containsKey(f)) {
                                                mergeCols.add(fieldToIndex[f]!);
                                              }
                                            }
                                            if (mergedFields.isEmpty) {
                                              mergeCols.addAll([0, 2, 7, 8, 9]);
                                            }
                                          } else if (title
                                              .contains('Tabel 2')) {
                                            final fieldToIndex = {
                                              'date': 0,
                                              'description': 2,
                                              'invoice_value_usd': 3,
                                              'transaction_value': 4,
                                              'currency': 5,
                                              'currency_exchange': 6,
                                              'transaction_value_idr': 7,
                                              'ppn_base': 8,
                                              'ppn': 9,
                                              'pph_21_base': 10,
                                              'pph_21': 11,
                                              'pph_23_base': 12,
                                              'pph_23': 13,
                                              'pph_26_base': 14,
                                              'pph_26': 15,
                                              'pemasukan_negara_base': 16,
                                              'pemasukan_negara': 17,
                                            };
                                            for (var f in mergedFields) {
                                              if (fieldToIndex.containsKey(f)) {
                                                mergeCols.add(fieldToIndex[f]!);
                                              }
                                            }
                                            if (mergedFields.isEmpty) {
                                              mergeCols.addAll([0, 2]);
                                            }
                                          }

                                          final groupHeight =
                                              rowIndices.length *
                                                  stableRowHeight *
                                                  zoomLevel;

                                          return InkWell(
                                            onTap: title.contains('Tabel 3C')
                                                ? () => navToDetail(
                                                    firstRow[3], firstRow[8])
                                                : null,
                                            child: Container(
                                              width: totalWidth,
                                              height: groupHeight,
                                              decoration: BoxDecoration(
                                                color: groupColor ??
                                                    (isBold
                                                        ? surfaceColor(context)
                                                        : (firstRowIdx.isEven
                                                            ? AppTheme
                                                                .getSurfaceColor(
                                                                    context)
                                                            : AppTheme
                                                                .getCardColor(
                                                                    context))),
                                                border: isCombineGroup
                                                    ? const Border(
                                                        left: BorderSide(
                                                            color: AppTheme
                                                                .primary,
                                                            width: 4.0))
                                                    : null,
                                              ),
                                              child: Row(
                                                children: firstRow
                                                    .asMap()
                                                    .entries
                                                    .map((e) {
                                                  final colIdx = e.key;
                                                  final bool isMergedCol =
                                                      mergeCols
                                                          .contains(colIdx);

                                                  if (isMergedCol) {
                                                    return Container(
                                                      width: (isCombineGroup &&
                                                              colIdx == 0)
                                                          ? colWidths[colIdx] -
                                                              4.0
                                                          : colWidths[colIdx],
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  dividerColor(
                                                                      context),
                                                              width: 0.5),
                                                          bottom: BorderSide(
                                                              color:
                                                                  dividerColor(
                                                                      context),
                                                              width: 0.5),
                                                        ),
                                                      ),
                                                      child: Align(
                                                        alignment: (colIdx == 2 &&
                                                                (title.contains(
                                                                        'Tabel 1') ||
                                                                    title.contains(
                                                                        'Tabel 2')))
                                                            ? Alignment
                                                                .centerLeft
                                                            : Alignment.center,
                                                        child:
                                                            buildExpenseTableCell(
                                                          value: e.value,
                                                          width:
                                                              colWidths[colIdx],
                                                          useCompact:
                                                              useCompact,
                                                          isBold: isBold,
                                                          index: colIdx,
                                                          textAlign: (colIdx ==
                                                                      2 &&
                                                                  (title.contains(
                                                                          'Tabel 1') ||
                                                                      title.contains(
                                                                          'Tabel 2')))
                                                              ? TextAlign.left
                                                              : TextAlign
                                                                  .center,
                                                          fontSize:
                                                              isBold ? 13 : 12,
                                                          isLast: colIdx ==
                                                              firstRow.length -
                                                                  1,
                                                          noBottomBorder: true,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return Column(
                                                      children: rowIndices
                                                          .map((rIdx) {
                                                        final row =
                                                            dataRows[rIdx];
                                                        return Container(
                                                          width: (isCombineGroup &&
                                                                  colIdx == 0)
                                                              ? colWidths[
                                                                      colIdx] -
                                                                  4.0
                                                              : colWidths[
                                                                  colIdx],
                                                          height:
                                                              stableRowHeight *
                                                                  zoomLevel,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: rowColors?[rIdx],
                                                            border: Border(
                                                              left: BorderSide(
                                                                  color: dividerColor(
                                                                      context),
                                                                  width: 0.5),
                                                              bottom: BorderSide(
                                                                  color: dividerColor(
                                                                      context),
                                                                  width: 0.5),
                                                            ),
                                                          ),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child:
                                                                buildExpenseTableCell(
                                                              value:
                                                                  row[colIdx],
                                                              width: colWidths[
                                                                  colIdx],
                                                              useCompact:
                                                                  useCompact,
                                                              isBold: isBold,
                                                              index: colIdx,
                                                              textAlign: (colIdx ==
                                                                          0 &&
                                                                      (title.contains('Tabel 9') ||
                                                                          title.contains(
                                                                              'Tabel 10')))
                                                                  ? TextAlign
                                                                      .center
                                                                  : (colIdx ==
                                                                              2 &&
                                                                          title.contains(
                                                                              'Tabel 10'))
                                                                      ? TextAlign
                                                                          .center
                                                                      : (colIdx == 1 &&
                                                                              !title.contains(
                                                                                  'Tabel 9') &&
                                                                              !title.contains(
                                                                                  'Tabel 10'))
                                                                          ? TextAlign
                                                                              .center
                                                                          : (isNumericLikeCell(headers[colIdx], colIdx, row[colIdx])
                                                                              ? TextAlign.right
                                                                              : TextAlign.left),
                                                              fontSize: isBold
                                                                  ? 13
                                                                  : 12,
                                                              isLast: colIdx ==
                                                                  row.length -
                                                                      1,
                                                              noBottomBorder:
                                                                  true,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    );
                                                  }
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }(),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Sticky Total Row
                          if (totalRow != null)
                            Container(
                              width: totalWidth,
                              height: (useCompact ? 48.0 : 56.0) * zoomLevel,
                              decoration: BoxDecoration(
                                color: surfaceColor(context),
                                border: Border(
                                  top: BorderSide(
                                    color: dividerColor(context),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: totalRow.asMap().entries.map((e) {
                                  return buildExpenseTableCell(
                                    value: e.value,
                                    width: colWidths[e.key],
                                    useCompact: useCompact,
                                    isBold: true,
                                    index: e.key,
                                    textAlign: (e.key == 0)
                                        ? TextAlign.center
                                        : (isNumericLikeCell(
                                                headers[e.key], e.key, e.value)
                                            ? TextAlign.right
                                            : TextAlign.left),
                                    fontSize: 13,
                                    isLast: e.key == totalRow!.length - 1,
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
