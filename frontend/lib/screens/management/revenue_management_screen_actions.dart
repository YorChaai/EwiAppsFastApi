import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/core/cascade_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/transactions/revenue_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/revenue_management_screen.dart';
import 'package:expense_app/screens/management/revenue_management_screen_dialogs.dart';


extension RevenueManagementActionsExt on RevenueManagementScreenState {
  String displayDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(text);
      if (dt == null) return text;
      return displayFmt.format(dt);
    } catch (_) {
      return text;
    }
  }

  Future<void> loadData() async {
    if (!mounted) return;
    final provider = context.read<RevenueProvider>();
    final setProv = context.read<SettlementProvider>();

    // ✅ Sticky Session: Sync with centralized provider
    if (setProv.reportYear != selectedYear) {
      context.read<CascadeProvider>().syncReportYear(context, selectedYear);
    }

    await provider.loadRevenues(
      year: filterMode == 'range' ? null : selectedYear,
      mode: filterMode,
      startDate: filterMode == 'range' ? startDate : null,
      endDate: filterMode == 'range' ? endDate : null,
    );
    // Combine groups biasanya per tahun laporan saja
    if (selectedYear != 0) {
      await provider.fetchRevenueCombineGroups(year: selectedYear);
    }
  }

  Future<void> saveRevenue({
    required Map<String, dynamic> payload,
    int? id,
  }) async {
    final prov = context.read<RevenueProvider>();
    if (id == null) {
      await prov.createRevenue(
        payload,
        startDate: startDate,
        endDate: endDate,
      );
    } else {
      await prov.updateRevenue(
        id,
        payload,
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  double? toDouble(String value) {
    var cleaned = value.trim().replaceAll(' ', '');
    if (cleaned.isEmpty) return null;

    if (cleaned.contains('.') && cleaned.contains(',')) {
      if (cleaned.lastIndexOf(',') > cleaned.lastIndexOf('.')) {
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    } else if (cleaned.contains(',')) {
      final commaCount = ','.allMatches(cleaned).length;
      if (commaCount == 1 && cleaned.split(',').last.length <= 2) {
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    } else if ('.'.allMatches(cleaned).length > 1) {
      cleaned = cleaned.replaceAll('.', '');
    }

    return double.tryParse(cleaned);
  }

  Future<void> deleteRevenue(Map<String, dynamic> item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title:
            Text('Hapus Revenue?', style: TextStyle(color: creamColor(ctx))),
        content: Text(
          item['description'] ?? '-',
          style: TextStyle(color: secondaryTextColor(ctx)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!mounted) return;

    try {
      await context.read<RevenueProvider>().deleteRevenue(
            item['id'] as int,
            startDate: startDate,
            endDate: endDate,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Revenue dihapus'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal hapus: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  int itemId(Map<String, dynamic> item) {
    return int.tryParse('${item['id'] ?? 0}') ?? 0;
  }

  int? selectedCombineGroupId(Map<int, Map<String, dynamic>> groupByRowId) {
    if (selectedRevenueIds.isEmpty) return null;
    final ids = selectedRevenueIds
        .map((rowId) => groupByRowId[rowId]?['id'])
        .where((value) => value != null)
        .map((value) => int.tryParse('$value'))
        .whereType<int>()
        .toSet();
    if (ids.length != 1) return null;
    return ids.first;
  }

  Future<void> manageRevenueCombine() async {
    final provider = context.read<RevenueProvider>();
    final allRevenues = provider.revenues.asMap().entries.map((entry) {
      final map = Map<String, dynamic>.from(entry.value as Map);
      map['display_index'] = entry.key + 1;
      return map;
    }).toList();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setManagerST) {
            final activeGroups = provider.combineGroups;

            return AlertDialog(
              backgroundColor: cardColor(ctx),
              title: Row(
                children: [
                  Text('Manager Gabungan Baris',
                      style: TextStyle(color: creamColor(ctx))),
                  const Spacer(),
                  IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.grey)),
                ],
              ),
              content: SizedBox(
                width: 600,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Gabungan Baru (Wizard)'),
                      onPressed: () async {
                        await startCombineWizard(allRevenues, provider);
                        setManagerST(() {}); // Refresh list
                      },
                    ),
                    const Divider(height: 32),
                    Text('Daftar Gabungan Aktif (${activeGroups.length}):',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (activeGroups.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text('Belum ada baris yang digabungkan.',
                                style: TextStyle(fontStyle: FontStyle.italic))),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: activeGroups.length,
                          itemBuilder: (lCtx, i) {
                            final g = activeGroups[i];
                            final rowIds = (g['row_ids'] as List?) ?? [];
                            final mergedCols =
                                (g['merged_columns'] as List?)?.join(', ') ??
                                    'All';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: surfaceColor(ctx),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppTheme.primary
                                        .withValues(alpha: 0.3)),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppTheme.primary,
                                  child: Text('C${g['id']}',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12)),
                                ),
                                title: Text(
                                    'Gabungan Baris ID: ${rowIds.join(', ')}'),
                                subtitle: Text('Kolom di-merge: $mergedCols',
                                    style: const TextStyle(fontSize: 11)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () async {
                                        await startCombineWizard(
                                            allRevenues, provider,
                                            editGroup: g);
                                        setManagerST(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () async {
                                        final ok = await showConfirmDialog(
                                            'Lepas Gabungan?',
                                            'Data akan dikembalikan ke posisi semula.');
                                        if (ok == true) {
                                          await provider
                                              .deleteRevenueCombineGroup(
                                                  id: g['id'],
                                                  year: selectedYear);
                                          loadData();
                                          setManagerST(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> startCombineWizard(
      List<Map<String, dynamic>> allRevenues, RevenueProvider provider,
      {Map<String, dynamic>? editGroup}) async {
    int step = editGroup != null ? 2 : 0; // Skip to Step 2 if editing
    int? row1Id;
    final List<int?> otherRowIds = [
      null,
      null,
      null,
      null
    ]; // For row 2, 3, 4, 5
    final List<String> selectedCols = [];
    final Map<String, dynamic> overrides = {};

    // If editing, populate data
    if (editGroup != null) {
      final List ids = editGroup['row_ids'] ?? [];
      if (ids.isNotEmpty) row1Id = ids[0];
      for (int i = 1; i < ids.length && i <= 4; i++) {
        otherRowIds[i - 1] = ids[i];
      }
      final List cols = editGroup['merged_columns'] ?? [];
      for (var c in cols) {
        selectedCols.add(c.toString());
      }

      // For editing, we try to get the CURRENT values from the primary row in allRevenues
      final primaryRev =
          allRevenues.firstWhere((r) => itemId(r) == row1Id, orElse: () => {});
      if (primaryRev.isNotEmpty) {
        for (var col in selectedCols) {
          overrides[col] = primaryRev[col]?.toString() ?? '';
        }
      }
    }

    final availableCols = [
      {'label': 'Invoice Date', 'field': 'invoice_date'},
      {'label': 'Detail/Description', 'field': 'description'},
      {'label': 'INVOICE VALUE (child=USD)', 'field': 'invoice_value_usd'},
      {'label': 'INVOICE VALUE (child=IDR)', 'field': 'invoice_value_idr'},
      {'label': 'Currency', 'field': 'currency'},
      {'label': 'Currency Exchange', 'field': 'currency_exchange'},
      {'label': 'INVOICE Number', 'field': 'invoice_number'},
      {'label': 'Client', 'field': 'client'},
      {'label': 'Receive Date', 'field': 'receive_date'},
      {'label': 'AMOUNT RECEIVED (child=IDR)', 'field': 'amount_received_idr'},
      {'label': 'AMOUNT RECEIVED (child=USD)', 'field': 'amount_received_usd'},
      {'label': 'PPN', 'field': 'ppn'},
      {'label': 'PPH 23', 'field': 'pph_23'},
      {'label': 'Biaya Transfer', 'field': 'transfer_fee'},
      {'label': 'Sumber Dana', 'field': 'bank_id'},
      {'label': 'Remark', 'field': 'remark'},
    ];

    final Set<String> numericMergeFields = {
      'invoice_value',
      'invoice_value_usd',
      'invoice_value_idr',
      'currency_exchange',
      'amount_received',
      'amount_received_idr',
      'amount_received_usd',
      'ppn',
      'pph_23',
      'transfer_fee',
    };

    // Get set of all row IDs that are already in ANY merge group
    final Set<int> allMergedRowIds = {};
    for (var g in provider.combineGroups) {
      final List ids = g['row_ids'] ?? [];
      for (var id in ids) {
        if (id is int) allMergedRowIds.add(id);
      }
    }

    // If editing, the rows in the CURRENT group should be allowed
    final Set<int> currentGroupIds = {};
    if (editGroup != null) {
      final List ids = editGroup['row_ids'] ?? [];
      for (var id in ids) {
        if (id is int) currentGroupIds.add(id);
      }
    }

    // Helper to check if a row is available for NEW merge
    bool isRowAvailable(int id) {
      if (currentGroupIds.contains(id)) return true;
      return !allMergedRowIds.contains(id);
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Widget content;
            List<Widget> actions = [];

            if (step == 0) {
              content = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Baris Utama (Data Utama):',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    isExpanded: true,
                    dropdownColor: cardColor(ctx),
                    style: TextStyle(color: textColor(ctx)),
                    initialValue: row1Id,
                    items: allRevenues
                        .where((r) => isRowAvailable(itemId(r)))
                        .map((r) {
                      final seq = r['display_index'];
                      final rid = itemId(r);
                      return DropdownMenuItem(
                          value: rid, child: Text('Baris #$seq'));
                    }).toList(),
                    onChanged: (v) => setDialogState(() => row1Id = v),
                  ),
                ],
              );
              actions = [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Batal')),
                ElevatedButton(
                  onPressed: row1Id == null
                      ? null
                      : () => setDialogState(() => step = 1),
                  child: const Text('Lanjut'),
                ),
              ];
            } else if (step == 1) {
              // Logic for multiple sequential rows
              final List<Widget> rowPickers = [];
              int? lastId = row1Id;

              for (int i = 0; i < 4; i++) {
                if (lastId == null) break;

                final rowRef = allRevenues
                    .firstWhere((r) => itemId(r) == lastId, orElse: () => {});
                if (rowRef.isEmpty) break;

                final idx = allRevenues.indexOf(rowRef);
                final List<Map<String, dynamic>> neighbors = [];
                // Only allow the row immediately AFTER for sequential multi-merge
                if (idx < allRevenues.length - 1) {
                  neighbors.add(allRevenues[idx + 1]);
                }

                if (neighbors.isEmpty) break;

                rowPickers.add(Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              'Gabungkan Baris #${rowRef['display_index']} dengan:',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Spacer(),
                          if (otherRowIds[i] != null)
                            IconButton(
                              icon: const Icon(Icons.close,
                                  size: 18, color: Colors.red),
                              onPressed: () => setDialogState(() {
                                otherRowIds[i] = null;
                                for (int j = i + 1; j < 4; j++) {
                                  otherRowIds[j] = null;
                                }
                              }),
                              tooltip: 'Batal gabung baris ini',
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        isExpanded: true,
                        dropdownColor: cardColor(ctx),
                        style: TextStyle(color: textColor(ctx)),
                        initialValue:
                            neighbors.any((r) => itemId(r) == otherRowIds[i])
                                ? otherRowIds[i]
                                : null,
                        hint: const Text('Pilih Baris Berikutnya'),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('-- Batal / Berhenti di sini --',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          ...neighbors
                              .where((r) => isRowAvailable(itemId(r)))
                              .map((r) {
                            final seq = r['display_index'];
                            final rid = itemId(r);
                            return DropdownMenuItem(
                                value: rid, child: Text('Baris #$seq'));
                          }),
                        ],
                        onChanged: (v) {
                          setDialogState(() {
                            otherRowIds[i] = v;
                            // Reset following picks if this one changes
                            for (int j = i + 1; j < 4; j++) {
                              otherRowIds[j] = null;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ));

                lastId = otherRowIds[i];
              }

              content = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: rowPickers,
              );

              actions = [
                TextButton(
                    onPressed: () => setDialogState(() => step = 0),
                    child: const Text('Kembali')),
                ElevatedButton(
                  onPressed: otherRowIds[0] == null
                      ? null
                      : () => setDialogState(() => step = 2),
                  child: const Text('Lanjut ke Merge Kolom'),
                ),
              ];
            } else {
              final row1 = allRevenues.firstWhere((r) => itemId(r) == row1Id);
              final List<int> allSelectedIds = [
                row1Id!,
                ...otherRowIds.whereType<int>()
              ];

              String? currentField;
              final ctrl = TextEditingController();

              content = StatefulBuilder(builder: (ctx2, setSubState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        'Merge Kolom untuk ${allSelectedIds.length} Baris (${allSelectedIds.map((id) => "#${allRevenues.firstWhere((r) => itemId(r) == id)['display_index']}").join(', ')})',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      dropdownColor: cardColor(ctx),
                      style: TextStyle(color: textColor(ctx)),
                      decoration: const InputDecoration(
                          labelText: 'Pilih Kolom untuk di-Merge'),
                      initialValue: currentField,
                      items: availableCols
                          .where((c) => !selectedCols.contains(c['field']))
                          .map((c) => DropdownMenuItem(
                              value: c['field'] as String,
                              child: Text(c['label']!)))
                          .toList(),
                      onChanged: (v) {
                        setSubState(() {
                          currentField = v;
                          final raw = row1[v];
                          if (v != null && numericMergeFields.contains(v)) {
                            ctrl.text = formatNumericInput(raw);
                          } else {
                            ctrl.text = raw?.toString() ?? '';
                          }
                        });
                      },
                    ),
                    if (currentField != null) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: ctrl,
                        style: TextStyle(color: textColor(ctx)),
                        decoration: InputDecoration(
                          labelText:
                              'Nilai Hasil Merge (Prioritas Baris #${row1['display_index']})',
                          labelStyle:
                              TextStyle(color: secondaryTextColor(ctx)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setDialogState(() {
                            final field = currentField!;
                            selectedCols.add(field);
                            final raw = ctrl.text.trim();
                            overrides[field] =
                                numericMergeFields.contains(field)
                                    ? (toDouble(raw)?.toString() ?? raw)
                                    : raw;
                            currentField = null;
                            ctrl.clear();
                          });
                        },
                        child: const Text('Simpan & Tambah Kolom Lain'),
                      ),
                    ],
                    if (selectedCols.isNotEmpty) ...[
                      const Divider(height: 32),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedCols
                            .map((c) => Container(
                                  decoration: BoxDecoration(
                                    color: surfaceColor(ctx),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: AppTheme.primary
                                            .withValues(alpha: 0.5)),
                                  ),
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          availableCols.firstWhere(
                                              (col) => col['field'] == c,
                                              orElse: () =>
                                                  {'label': c})['label']!,
                                          style: const TextStyle(fontSize: 12)),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        icon: const Icon(Icons.edit,
                                            size: 14, color: Colors.blue),
                                        onPressed: () {
                                          setSubState(() {
                                            currentField = c;
                                            ctrl.text =
                                                overrides[c]?.toString() ?? '';
                                            selectedCols.remove(c);
                                          });
                                        },
                                        tooltip: 'Edit nilai',
                                      ),
                                      IconButton(
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(4),
                                        icon: const Icon(Icons.close,
                                            size: 14, color: Colors.red),
                                        onPressed: () => setDialogState(() {
                                          selectedCols.remove(c);
                                          overrides.remove(c);
                                        }),
                                        tooltip: 'Hapus merge kolom ini',
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ]
                  ],
                );
              });

              bool isSaving = false;
              actions = [
                TextButton(
                    onPressed: () => setDialogState(() => step = 1),
                    child: const Text('Kembali')),
                if (selectedCols.isNotEmpty)
                  StatefulBuilder(builder: (ctx3, setBtnState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.success),
                      onPressed: isSaving
                          ? null
                          : () async {
                              setBtnState(() => isSaving = true);
                              try {
                                // AUTO-ADD current field if selected but not in list
                                if (currentField != null) {
                                  final field = currentField!;
                                  if (!selectedCols.contains(field)) {
                                    selectedCols.add(field);
                                    final raw = ctrl.text.trim();
                                    overrides[field] = numericMergeFields
                                            .contains(field)
                                        ? (toDouble(raw)?.toString() ?? raw)
                                        : raw;
                                  }
                                }

                                if (selectedCols.isEmpty) {
                                  throw Exception(
                                      'Pilih minimal satu kolom untuk di-merge.');
                                }

                                // If editing, delete old group first
                                if (editGroup != null) {
                                  try {
                                    await provider.deleteRevenueCombineGroup(
                                      id: editGroup['id'],
                                      year: selectedYear,
                                    );
                                  } catch (e) {
                                    // If 404, it might be already deleted or sync issue, log and continue
                                    debugPrint(
                                        '[DEBUG] Delete old group info: $e');
                                  }
                                }

                                await provider.createRevenueCombineGroup(
                                  year: selectedYear,
                                  rowIds: allSelectedIds,
                                  mergedColumns: selectedCols,
                                  overrides: overrides,
                                );
                                if (!ctx.mounted) return;
                                Navigator.pop(ctx);
                                await loadData();
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text(
                                          'Gabungan berhasil disimpan.'),
                                      backgroundColor: AppTheme.success),
                                );
                              } catch (e) {
                                if (!ctx.mounted) return;
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                    SnackBar(content: Text('Error: $e')));
                              } finally {
                                if (mounted) {
                                  setBtnState(() => isSaving = false);
                                }
                              }
                            },
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Selesai & Terapkan'),
                    );
                  }),
              ];
            }

            return AlertDialog(
              backgroundColor: cardColor(ctx),
              title: Text('Wizard Gabung Baris (Langkah ${step + 1}/3)',
                  style: TextStyle(color: creamColor(ctx))),
              content: SizedBox(width: 500, child: content),
              actions: actions,
            );
          },
        );
      },
    );
  }

  // ignore: unused_element
  Future<void> releaseSelectedRevenueCombine(
    Map<int, Map<String, dynamic>> groupByRowId,
  ) async {
    final groupId = selectedCombineGroupId(groupByRowId);
    if (groupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Pilih data yang berada dalam satu group combine yang sama.',
          ),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    try {
      await context.read<RevenueProvider>().deleteRevenueCombineGroup(
            id: groupId,
            year: selectedYear,
          );
      if (!mounted) return;
      updateState(() => selectedRevenueIds.clear());
      await loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Combine revenue dilepas.'),
          backgroundColor: AppTheme.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal melepas combine revenue: $e'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  Widget textField(
    TextEditingController controller,
    String label, {
    double width = 230,
    bool required = false,
    String? hintText,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor(context).withValues(alpha: 0.4),
            fontSize: 13,
          ),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null
            : null,
      ),
    );
  }

  Widget numberField(
    TextEditingController controller,
    String label, {
    bool required = false,
    bool enabled = true,
    bool readOnly = false,
    ValueChanged<String>? onChanged,
  }) {
    return SizedBox(
      width: 230,
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        readOnly: readOnly,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: label),
        validator: (v) {
          if (!required && (v == null || v.trim().isEmpty)) return null;
          return toDouble(v ?? '') == null ? 'Angka tidak valid' : null;
        },
      ),
    );
  }

  Widget dateField(
    TextEditingController controller,
    String label,
    Future<void> Function(TextEditingController) pickDate, {
    bool allowEmpty = false,
  }) {
    return SizedBox(
      width: 230,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: () => pickDate(controller),
          ),
        ),
        validator: (v) {
          if (allowEmpty && (v == null || v.trim().isEmpty)) return null;
          if (v == null || v.trim().isEmpty) return 'Wajib diisi';
          return DateTime.tryParse(v.trim()) == null
              ? 'Tanggal tidak valid'
              : null;
        },
      ),
    );
  }

  Widget dropdownField<T>(
    T value,
    String label,
    List<Map<String, dynamic>> options,
    ValueChanged<T?> onChanged, {
    double width = 230,
  }) {
    return SizedBox(
      width: width,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: options.any((o) => o['value'] == value)
                ? value
                : options.first['value'] as T,
            isExpanded: true,
            style: TextStyle(color: textColor(context), fontSize: 16),
            items: options.map((option) {
              return DropdownMenuItem<T>(
                value: option['value'] as T,
                child: Text(
                  option['label']!,
                  style: TextStyle(color: textColor(context)),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            dropdownColor: cardColor(context),
          ),
        ),
      ),
    );
  }
}
