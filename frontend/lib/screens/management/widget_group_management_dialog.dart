import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/category_tabular_screen.dart';
import 'package:expense_app/screens/management/widget_kanban_column_dynamic.dart';


extension CategoryTabularScreenGroupManagementDialogExt
    on CategoryTabularScreenState {
  void showGroupManagementDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1200; // Increased breakpoint for N columns

    // Clone data untuk dialog
    List<Map<String, dynamic>> tempCats = List<Map<String, dynamic>>.from(
      categories.map((c) => {...c}),
    );
    List<Map<String, dynamic>> tempGroups = List<Map<String, dynamic>>.from(
      categoryGroups.map((g) => {...g}),
    );

    // Track scroll controllers for dynamic columns
    final Map<int, ScrollController> controllers = {};

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          // Map categories to groups
          final Map<String, List<Map<String, dynamic>>> groupData = {};
          for (var g in tempGroups) {
            final gName = g['name'].toString().toUpperCase();
            groupData[gName] = tempCats
                .where((c) =>
                    (c['main_group'] ?? '').toString().toUpperCase() == gName)
                .toList();
          }

          // Catch categories that don't match any group
          final List<Map<String, dynamic>> uncategorized = tempCats.where((c) {
            final cGroup = (c['main_group'] ?? '').toString().toUpperCase();
            return !tempGroups
                .any((g) => g['name'].toString().toUpperCase() == cGroup);
          }).toList();

          if (uncategorized.isNotEmpty) {
            groupData['LAINNYA'] = uncategorized;
          }

          void moveItem(Map<String, dynamic> cat, String currentGroup) {
            final List<String> groupNames = tempGroups
                .map((g) => g['name'].toString().toUpperCase())
                .toList();

            // If we are in "LAINNYA", the next group is the first real group
            int currentIdx = groupNames.indexOf(currentGroup.toUpperCase());
            String nextGroup;
            if (currentIdx == -1) {
              nextGroup = groupNames.isNotEmpty
                  ? groupNames[0]
                  : 'BIAYA ADMINISTRASI DAN UMUM';
            } else {
              int nextIdx = (currentIdx + 1) % groupNames.length;
              nextGroup = groupNames[nextIdx];
            }

            setDialogState(() {
              cat['main_group'] = nextGroup;

              // Perbaikan: Pindahkan item ke posisi paling akhir di daftar utama (tempCats)
              // agar saat difilter ulang oleh builder, dia otomatis berada di paling bawah grup tujuan.
              tempCats.remove(cat);
              tempCats.add(cat);

              // Update sort_order secara massal berdasarkan urutan baru di tempCats
              for (int i = 0; i < tempCats.length; i++) {
                tempCats[i]['sort_order'] = i + 1;
              }
            });
          }

          Widget buildKanbanContent() {
            final List<Widget> columns = [];

            // Show real groups
            for (int i = 0; i < tempGroups.length; i++) {
              final group = tempGroups[i];
              final gName = group['name'].toString().toUpperCase();
              final items = groupData[gName] ?? [];

              if (!controllers.containsKey(group['id'])) {
                controllers[group['id']] = ScrollController();
              }

              columns.add(
                buildKanbanColumnDynamic(
                  group,
                  items,
                  i % 2 == 0 ? AppTheme.accent : AppTheme.primary,
                  controllers[group['id']]!,
                  (cat) => moveItem(cat, gName),
                  (oldIdx, newIdx) {
                    setDialogState(() {
                      final item = items.removeAt(oldIdx);
                      items.insert(newIdx, item);
                      syncTempCatsOrderDynamic(
                          tempCats, tempGroups, groupData);
                    });
                  },
                ),
              );

              if (i < tempGroups.length - 1 || uncategorized.isNotEmpty) {
                columns.add(const SizedBox(width: 16));
              }
            }

            // Show "LAINNYA" column if there are stray categories
            if (uncategorized.isNotEmpty) {
              if (!controllers.containsKey(-999)) {
                controllers[-999] = ScrollController();
              }
              columns.add(
                buildKanbanColumnDynamic(
                  {'id': -999, 'name': 'LAINNYA'},
                  uncategorized,
                  Colors.grey,
                  controllers[-999]!,
                  (cat) => moveItem(cat, 'LAINNYA'),
                  (oldIdx, newIdx) {
                    setDialogState(() {
                      final item = uncategorized.removeAt(oldIdx);
                      uncategorized.insert(newIdx, item);
                      syncTempCatsOrderDynamic(
                          tempCats, tempGroups, groupData);
                    });
                  },
                ),
              );
            }

            if (isMobile) {
              return SingleChildScrollView(
                child: Column(children: columns),
              );
            }

            final horizontalController = ScrollController();
            return AppScrollbar(
              controller: horizontalController, // Horizontal scroll
              thumbVisibility: true,
              interactive: true,
              child: SingleChildScrollView(
                controller: horizontalController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columns,
                ),
              ),
            );
          }

          return AlertDialog(
            backgroundColor: cardColor(context),
            title: Row(
              children: [
                const Text('Atur Grup & Urutan'),
                const Spacer(),
                // NEW: Edit Groups Button
                IconButton(
                  icon: const Icon(Icons.edit_note_rounded, size: 22),
                  tooltip: 'Kelola Grup (Tambah/Ubah/Hapus)',
                  onPressed: () async {
                    final result = await showManageGroupsDialog(
                        ctx, tempGroups, tempCats);
                    if (result != null) {
                      setDialogState(() {
                        // tempGroups and tempCats are updated inside the helper
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.help_outline_rounded, size: 20),
                  tooltip: 'Bantuan',
                  onPressed: () {
                    showSnackBar(
                      'Drag item untuk urutan. Klik panah untuk pindah grup cepat.',
                    );
                  },
                ),
              ],
            ),
            content: SizedBox(
              width: screenWidth * 0.95,
              height: isMobile ? MediaQuery.of(context).size.height * 0.8 : 550,
              child: buildKanbanContent(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Dispose temporary controllers
                  for (var c in controllers.values) {
                    c.dispose();
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Final sync before saving
                  syncTempCatsOrderDynamic(tempCats, tempGroups, groupData);

                  // Dispose temporary controllers
                  for (var c in controllers.values) {
                    c.dispose();
                  }

                  Navigator.pop(ctx);
                  saveAllGroupsAndCategories(tempGroups, tempCats);
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }
}
