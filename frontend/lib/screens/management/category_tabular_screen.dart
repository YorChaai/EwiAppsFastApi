import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/widget_simple_category_card.dart';
import 'package:expense_app/screens/management/widget_group_management_dialog.dart';


class CategoryTabularScreen extends StatefulWidget {
  const CategoryTabularScreen({super.key});

  @override
  State<CategoryTabularScreen> createState() => CategoryTabularScreenState();
}

class CategoryTabularScreenState extends State<CategoryTabularScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> categoryGroups = [];
  bool isLoading = true;
  bool isSaving = false;
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;
  Color titleColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color primaryText(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
  Color bodyText(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      api.setToken(auth.token!);

      final results = await Future.wait([
        api.getCategories(),
        api.getCategoryGroups(),
      ]);

      final cats =
          List<Map<String, dynamic>>.from(results[0]['categories'] ?? []);
      final groups =
          List<Map<String, dynamic>>.from(results[1]['groups'] ?? []);

      cats.sort(
        (a, b) => (a['sort_order'] ?? 0).compareTo(b['sort_order'] ?? 0),
      );

      setState(() {
        categories = cats;
        categoryGroups = groups;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      showSnackBar('Gagal memuat data: $e', isError: true);
    }
  }

  Future<void> saveChanges() async {
    setState(() => isSaving = true);
    try {
      final auth = context.read<AuthProvider>();
      api.setToken(auth.token!);

      final List<Map<String, dynamic>> payload = [];
      for (int i = 0; i < categories.length; i++) {
        payload.add({
          'id': categories[i]['id'],
          'sort_order': i + 1,
          'main_group':
              categories[i]['main_group'] ?? 'BIAYA ADMINISTRASI DAN UMUM',
        });
      }

      await api.reorderCategories(payload);
      showSnackBar('Data berhasil disimpan ✓');
    } catch (e) {
      showSnackBar('Gagal menyimpan: $e', isError: true);
    } finally {
      setState(() => isSaving = false);
    }
  }

  void showSnackBar(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.danger : AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<SettlementProvider>();
    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: const Text('Kategori Tabular'),
        elevation: 0,
        backgroundColor: surfaceColor(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Tutup',
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: isSaving ? null : saveChanges,
            icon: const Icon(Icons.save_rounded, size: 20),
            label: const Text(
              'Simpan Perubahan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Info & Button Atur Grup
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 700;

                      final headerText = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Urutan Kolom Sheet 1',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: titleColor(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Geser item untuk mengatur urutan kolom di Excel Tahunan.',
                            style: TextStyle(
                              fontSize: 13,
                              color: bodyText(context),
                            ),
                          ),
                        ],
                      );

                      final actionButtons = Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Dropdown Mode Sortir (PopupMenuButton dengan style mirip Cascade Laporan)
                          Theme(
                            data: Theme.of(context).copyWith(
                              cardColor: cardColor(context),
                            ),
                            child: PopupMenuButton<String>(
                              offset: const Offset(0, 44),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    color: dividerColor(context), width: 1.5),
                              ),
                              tooltip: 'Pilih Mode Sortir',
                              onSelected: (String newValue) {
                                prov.setSortMode(newValue);
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'kategori',
                                  height: 48,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.category_rounded,
                                        size: 18,
                                        color: prov.sortMode == 'kategori'
                                            ? AppTheme.accent
                                            : AppTheme.textSecondary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Mode Kategori',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              prov.sortMode == 'kategori'
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color: prov.sortMode == 'kategori'
                                              ? AppTheme.textPrimary
                                              : bodyText(context),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (prov.sortMode == 'kategori')
                                        const Icon(Icons.check_rounded,
                                            size: 16, color: AppTheme.success),
                                    ],
                                  ),
                                ),
                                PopupMenuDivider(color: dividerColor(context)),
                                PopupMenuItem<String>(
                                  value: 'tanggal',
                                  height: 48,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range_rounded,
                                        size: 18,
                                        color: prov.sortMode == 'tanggal'
                                            ? AppTheme.accent
                                            : AppTheme.textSecondary,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Mode Tanggal',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: prov.sortMode == 'tanggal'
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: prov.sortMode == 'tanggal'
                                              ? AppTheme.getTextColor(context)
                                              : bodyText(context),
                                        ),
                                      ),
                                      const Spacer(),
                                      if (prov.sortMode == 'tanggal')
                                        const Icon(Icons.check_rounded,
                                            size: 16, color: AppTheme.success),
                                    ],
                                  ),
                                ),
                              ],
                              child: Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: dividerColor(context),
                                      width: 1.5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      prov.sortMode == 'kategori'
                                          ? 'Mode Kategori'
                                          : 'Mode Tanggal',
                                      style: TextStyle(
                                        color: titleColor(context),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.sort_rounded,
                                      size: 16,
                                      color: titleColor(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // TOMBOL BARU: Atur Grup & Urutan (Membuka Dialog)
                          ElevatedButton.icon(
                            onPressed: () =>
                                showGroupManagementDialog(context),
                            icon: const Icon(
                              Icons.swap_horiz_rounded,
                              color: AppTheme.accent,
                              size: 18,
                            ),
                            label: const Text(
                              'Atur Grup & Urutan',
                              style: TextStyle(
                                color: AppTheme.accent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  dividerColor(context).withValues(alpha: 0.5),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              minimumSize: const Size(0, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerText,
                            const SizedBox(height: 16),
                            actionButtons,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: headerText),
                          const SizedBox(width: 12),
                          actionButtons,
                        ],
                      );
                    },
                  ),
                ),

                // Single Reorderable List
                Expanded(
                  child: AppScrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    child: ReorderableListView.builder(
                      scrollController: scrollController,
                      buildDefaultDragHandles:
                          false, // Matikan handle bawaan agar tidak double
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      itemCount: categories.length,
                      onReorderItem: (oldIdx, newIdx) {
                        setState(() {
                          final item = categories.removeAt(oldIdx);
                          categories.insert(newIdx, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return buildSimpleCategoryCard(
                          cat,
                          index,
                          index + 1,
                          key: ValueKey('row_${cat['id']}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> saveAllGroupsAndCategories(
    List<Map<String, dynamic>> groups,
    List<Map<String, dynamic>> cats,
  ) async {
    setState(() => isSaving = true);
    try {
      final auth = context.read<AuthProvider>();
      api.setToken(auth.token!);

      // 1. Save Groups (CRUD + Reorder)
      // This is a bit complex since some might be new (ID < 0), some updated, some deleted.
      // For simplicity, we can have a specialized bulk API or do it sequentially.
      // According to plan, we use /api/categories/groups/reorder for order,
      // and we need to handle additions/deletions.

      // Let's identify changes
      final List<Map<String, dynamic>> finalGroups = [];

      for (int i = 0; i < groups.length; i++) {
        var g = groups[i];
        if (g['id'] < 0) {
          // New group
          final res = await api.createCategoryGroup(g['name']);
          finalGroups.add({...res['group'], 'sort_order': i});
        } else {
          // Existing group, update if name changed or just track for reorder
          await api.updateCategoryGroup(g['id'],
              name: g['name'], sortOrder: i);
          finalGroups.add({...g, 'sort_order': i});
        }
      }

      // Handle deleted groups (those in categoryGroups but not in groups)
      for (var oldG in categoryGroups) {
        if (!groups.any((g) => g['id'] == oldG['id'])) {
          await api.deleteCategoryGroup(oldG['id']);
        }
      }

      // 2. Save Categories Order & main_group
      final List<Map<String, dynamic>> catPayload = [];
      for (int i = 0; i < cats.length; i++) {
        catPayload.add({
          'id': cats[i]['id'],
          'sort_order': i + 1,
          'main_group': cats[i]['main_group'],
        });
      }
      await api.reorderCategories(catPayload);

      showSnackBar('Pengaturan grup & urutan berhasil disimpan ✓');
      loadData(); // Refresh all
    } catch (e) {
      showSnackBar('Gagal menyimpan: $e', isError: true);
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<bool?> showManageGroupsDialog(
    BuildContext context,
    List<Map<String, dynamic>> groups,
    List<Map<String, dynamic>> cats,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          void addGroup() async {
            final controller = TextEditingController();
            final name = await showDialog<String>(
              context: ctx,
              builder: (c) => AlertDialog(
                title: const Text('Tambah Grup Baru'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Nama Grup'),
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(c, controller.text.trim()),
                    child: const Text('Tambah'),
                  ),
                ],
              ),
            );

            if (name != null && name.isNotEmpty) {
              setDialogState(() {
                groups.add({
                  'id': -DateTime.now().millisecondsSinceEpoch,
                  'name': name,
                  'sort_order': groups.length,
                });
              });
            }
          }

          void editGroup(Map<String, dynamic> group) async {
            final controller = TextEditingController(text: group['name']);
            final name = await showDialog<String>(
              context: ctx,
              builder: (c) => AlertDialog(
                title: const Text('Ubah Nama Grup'),
                content: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Nama Grup'),
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(c),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(c, controller.text.trim()),
                    child: const Text('Simpan'),
                  ),
                ],
              ),
            );

            if (name != null && name.isNotEmpty && name != group['name']) {
              final oldName = group['name'];
              setDialogState(() {
                group['name'] = name;
                for (var cat in cats) {
                  if (cat['main_group'] == oldName) {
                    cat['main_group'] = name;
                  }
                }
              });
            }
          }

          void deleteGroup(Map<String, dynamic> group) {
            final catsInGroup =
                cats.where((c) => c['main_group'] == group['name']);
            if (catsInGroup.isNotEmpty) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    'Grup "${group['name']}" tidak bisa dihapus karena masih berisi kategori.',
                  ),
                  backgroundColor: AppTheme.danger,
                ),
              );
              return;
            }

            setDialogState(() {
              groups.remove(group);
            });
          }

          return AlertDialog(
            title: const Text('Kelola Grup'),
            backgroundColor: cardColor(context),
            content: SizedBox(
              width: 400,
              height: 400,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Tambah Grup'),
                      onPressed: addGroup,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ReorderableListView.builder(
                      itemCount: groups.length,
                      onReorderItem: (oldIdx, newIdx) {
                        setDialogState(() {
                          final item = groups.removeAt(oldIdx);
                          groups.insert(newIdx, item);
                        });
                      },
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return Card(
                          key: ValueKey('group_${group['id']}'),
                          color: surfaceColor(context),
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: dividerColor(context)
                                    .withValues(alpha: 0.5)),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle_rounded,
                                  color: Colors.grey),
                            ),
                            title: Text(group['name'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon:
                                      const Icon(Icons.edit_rounded, size: 18),
                                  onPressed: () => editGroup(group),
                                  tooltip: 'Ubah Nama',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded,
                                      size: 18, color: Colors.red),
                                  onPressed: () => deleteGroup(group),
                                  tooltip: 'Hapus Grup',
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Terapkan'),
              ),
            ],
          );
        },
      ),
    );
  }

  void syncTempCatsOrderDynamic(
    List<Map<String, dynamic>> source,
    List<Map<String, dynamic>> groups,
    Map<String, List<Map<String, dynamic>>> groupData,
  ) {
    source.clear();
    for (var g in groups) {
      final items = groupData[g['name'].toString().toUpperCase()] ?? [];
      source.addAll(items);
    }
    for (int i = 0; i < source.length; i++) {
      source[i]['sort_order'] = i + 1;
    }
  }
}
