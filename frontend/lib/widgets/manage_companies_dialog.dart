import 'package:flutter/material.dart';
import 'package:expense_app/services/api_service.dart';
import 'package:expense_app/theme/app_theme.dart';

class ManageCompaniesDialog extends StatefulWidget {
  const ManageCompaniesDialog({super.key});

  @override
  State<ManageCompaniesDialog> createState() => _ManageCompaniesDialogState();
}

class _ManageCompaniesDialogState extends State<ManageCompaniesDialog> {
  List<Map<String, dynamic>> _companies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() => _isLoading = true);
    try {
      final companies = await ApiService().getCompanies();
      if (mounted) setState(() => _companies = companies);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error loading companies: $e'),
              backgroundColor: AppTheme.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addCompany() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Perusahaan'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama Perusahaan'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        final res = await ApiService().createCompany(name);
        if (!mounted) return;
        if (res['success']) {
          await _loadCompanies();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res['error'] ?? 'Gagal'),
              backgroundColor: AppTheme.danger));
          setState(() => _isLoading = false);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'), backgroundColor: AppTheme.danger));
        setState(() => _isLoading = false);
      }
    }
  }

  void _editCompany(Map<String, dynamic> company) async {
    final controller = TextEditingController(text: company['name']);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Nama Perusahaan'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nama Perusahaan'),
          autofocus: true,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );

    if (name != null && name.isNotEmpty && name != company['name']) {
      setState(() => _isLoading = true);
      try {
        final res = await ApiService().updateCompany(company['id'], name);
        if (!mounted) return;
        if (res['success']) {
          await _loadCompanies();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res['error'] ?? 'Gagal'),
              backgroundColor: AppTheme.danger));
          setState(() => _isLoading = false);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'), backgroundColor: AppTheme.danger));
        setState(() => _isLoading = false);
      }
    }
  }

  void _deleteCompany(Map<String, dynamic> company) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Perusahaan?'),
        content: Text(
            'Apakah Anda yakin ingin menghapus "${company['name']}"?\nAkses pengguna ke perusahaan ini juga akan dihapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        final res = await ApiService().deleteCompany(company['id']);
        if (!mounted) return;
        if (res['success']) {
          await _loadCompanies();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res['error'] ?? 'Gagal'),
              backgroundColor: AppTheme.danger));
          setState(() => _isLoading = false);
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'), backgroundColor: AppTheme.danger));
        setState(() => _isLoading = false);
      }
    }
  }

  void _saveReorder() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService().reorderCompanies(_companies);
      if (res['success']) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Urutan berhasil disimpan'),
              backgroundColor: Colors.green));
        }
        await _loadCompanies();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(res['error'] ?? 'Gagal menyimpan urutan'),
              backgroundColor: AppTheme.danger));
        }
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'), backgroundColor: AppTheme.danger));
      }
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.card : AppTheme.lightCard;
    final surfaceColor = isDark ? AppTheme.surface : AppTheme.lightSurface;
    final dividerColor = isDark ? AppTheme.divider : AppTheme.lightDivider;

    return AlertDialog(
      title: Row(
        children: [
          const Text('Kelola Perusahaan'),
          const Spacer(),
          TextButton.icon(
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Tambah'),
            onPressed: _isLoading ? null : _addCompany,
          ),
        ],
      ),
      backgroundColor: cardColor,
      content: SizedBox(
        width: 400,
        height: 400,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ReorderableListView.builder(
                onReorderItem: (oldIndex, newIndex) {
                  setState(() {
                    final item = _companies.removeAt(oldIndex);
                    _companies.insert(newIndex, item);
                  });
                },
                itemCount: _companies.length,
                itemBuilder: (context, index) {
                  final company = _companies[index];
                  return Card(
                    key: ValueKey(company['id']),
                    color: surfaceColor,
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: dividerColor.withValues(alpha: 0.5)),
                    ),
                    child: ListTile(
                      title: Text(company['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded, size: 18),
                            onPressed: () => _editCompany(company),
                            tooltip: 'Ubah Nama',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                size: 18, color: Colors.red),
                            onPressed: () => _deleteCompany(company),
                            tooltip: 'Hapus Perusahaan',
                          ),
                          const Icon(Icons.drag_handle_rounded,
                              color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Tutup'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveReorder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}
