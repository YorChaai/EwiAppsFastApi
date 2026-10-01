import 'package:expense_app/screens/layout/main_layout_settlement_list_dialogs.dart';
import 'package:expense_app/screens/widgets/widget_summary_cards.dart';
import 'package:expense_app/screens/widgets/widget_type_toggle.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/widgets/common_widgets.dart';

import 'package:expense_app/screens/layout/main_layout_settlement_list.dart';

extension MainLayoutWidgetsScrollableSettlementHeaderExt
    on SettlementListViewState {
  Widget buildScrollableSettlementHeader(
    BuildContext context,
    AuthProvider auth,
    SettlementProvider prov,
    bool isNarrow,
    bool isVeryNarrow,
    bool canShowExport,
    EdgeInsets pagePadding,
    bool useCompact,
  ) {
    return Padding(
      padding: pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      auth.isManager ? 'Semua Settlement' : 'Settlement Saya',
                      style: TextStyle(
                        fontSize: useCompact ? 18 : (isNarrow ? 20 : 24),
                        fontWeight: FontWeight.bold,
                        color: titleColorLocal(context),
                      ),
                    ),
                    Text(
                      '${prov.settlements.length} total',
                      style: TextStyle(
                        color: bodyColorLocal(context),
                        fontSize: useCompact ? 10 : 13,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (selectionMode)
                    IconButton(
                      onPressed: () {
                        updateState(() {
                          selectionMode = false;
                          selectedItemKeys.clear();
                        });
                      },
                      icon: Icon(Icons.close_rounded,
                          color: AppTheme.danger, size: useCompact ? 22 : 26),
                      tooltip: 'Batal',
                    ),
                  if (selectionMode) const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {
                      if (!selectionMode) {
                        updateState(() {
                          selectionMode = true;
                        });
                      } else {
                        if (selectedItemKeys.isNotEmpty) {
                          bulkDeleteItems();
                        }
                      }
                    },
                    icon: Icon(
                      selectionMode
                          ? Icons.delete_sweep_rounded
                          : Icons.delete_outline_rounded,
                      color: AppTheme.danger,
                      size: useCompact ? 22 : 26,
                    ),
                    tooltip: selectionMode
                        ? 'Hapus (${selectedItemKeys.length})'
                        : 'Pilih Banyak',
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed:
                        selectionMode ? null : () => showCreateDialog(context),
                    icon: Icon(Icons.add, size: useCompact ? 16 : 20),
                    label: Text(
                      isNarrow ? 'Buat' : 'Buat Settlement',
                      style: TextStyle(fontSize: useCompact ? 12 : 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: useCompact
                          ? const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            )
                          : null,
                      minimumSize: useCompact ? const Size(0, 36) : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: useCompact ? 10 : 16),
          buildSummaryCards(isNarrow, useCompact),
          SizedBox(height: useCompact ? 10 : 16),
          TextField(
            controller: searchCtrl,
            style: TextStyle(fontSize: useCompact ? 13 : 14),
            decoration: InputDecoration(
              isDense: useCompact,
              hintText: 'Cari settlement...',
              prefixIcon: Icon(Icons.search, size: useCompact ? 18 : 24),
              contentPadding:
                  useCompact ? const EdgeInsets.symmetric(vertical: 6) : null,
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: useCompact ? 16 : 20),
                      onPressed: () {
                        searchCtrl.clear();
                        updateState(() => searchQuery = '');
                        reloadSettlements();
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              updateState(() => searchQuery = val);
              scheduleSettlementReload();
            },
          ),
          SizedBox(height: useCompact ? 12 : 16),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SATU TOMBOL UNTUK SEMUA: Periode Data
                  CascadingYearFilter(
                    label: 'Periode Data',
                    selectedYear: prov.filterYear,
                    currentMode: filterMode,
                    useCompact: useCompact,
                    startDate: startDate,
                    endDate: endDate,
                    onSelected: (year, mode) {
                      updateState(() {
                        filterMode = mode;
                      });
                      prov.setFilterYear(year, mode, reload: false);
                      reloadSettlements();
                    },
                    onRangeTap: () => pickDateRange(context),
                  ),
                  const SizedBox(width: 12),
                  CascadingStatusFilter(
                    selectedStatus: statusFilter,
                    useCompact: useCompact,
                    isManager: auth.isManager,
                    onSelected: (val) {
                      updateState(() => statusFilter = val);
                      reloadSettlements();
                    },
                  ),
                  if (auth.isManager && canShowExport) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: exportExcel,
                      icon: const Icon(
                        Icons.table_chart_rounded,
                        color: AppTheme.success,
                      ),
                    ),
                    IconButton(
                      onPressed: exportPdf,
                      icon: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppTheme.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(height: useCompact ? 8 : 12),
          buildTypeToggle(useCompact),
        ],
      ),
    );
  }
}
