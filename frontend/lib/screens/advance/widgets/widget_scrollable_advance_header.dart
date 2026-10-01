import 'package:flutter/material.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/core/cascading_year_filter.dart';
import 'package:expense_app/widgets/core/cascading_status_filter.dart';
import 'package:expense_app/screens/advance/advances_screen.dart';
import 'package:expense_app/screens/advance/advances_screen_dialogs.dart';
import 'package:expense_app/screens/advance/widgets/widget_type_toggle.dart';
import 'package:expense_app/screens/advance/widgets/widget_year_summary_card.dart';

extension AdvancesWidgetsScrollableAdvanceHeaderExt on AdvancesScreenState {
  Widget buildScrollableAdvanceHeader(
    BuildContext context,
    AuthProvider auth,
    AdvanceProvider prov,
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
                      auth.isManager ? 'Semua Kasbon' : 'Kasbon Saya',
                      style: TextStyle(
                        fontSize: useCompact ? 18 : (isNarrow ? 20 : 24),
                        fontWeight: FontWeight.bold,
                        color: titleColor(context),
                      ),
                    ),
                    Text(
                      '${prov.advances.length} total',
                      style: TextStyle(
                        color: bodyColor(context),
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
                    onPressed: selectionMode
                        ? null
                        : () => showCreateDialog(context),
                    icon: Icon(Icons.add, size: useCompact ? 16 : 20),
                    label: Text(
                      isNarrow ? 'Buat' : 'Buat Kasbon',
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
          buildYearSummaryCard(
            context,
            prov.filterYear,
            useCompact,
          ),
          SizedBox(height: useCompact ? 10 : 16),
          TextField(
            controller: searchCtrl,
            style: TextStyle(fontSize: useCompact ? 13 : 14),
            decoration: InputDecoration(
              isDense: useCompact,
              hintText: 'Cari kasbon...',
              prefixIcon: Icon(Icons.search, size: useCompact ? 18 : 24),
              contentPadding:
                  useCompact ? const EdgeInsets.symmetric(vertical: 6) : null,
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: useCompact ? 16 : 20),
                      onPressed: () {
                        searchCtrl.clear();
                        updateState(() => searchQuery = '');
                        reloadAdvances();
                      },
                    )
                  : null,
            ),
            onChanged: (v) {
              updateState(() => searchQuery = v);
              scheduleAdvanceReload();
            },
          ),
          SizedBox(height: useCompact ? 12 : 16),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                      reloadAdvances();
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
                      reloadAdvances();
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
