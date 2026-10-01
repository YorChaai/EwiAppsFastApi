import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';

class EditUserByManagerDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditUserByManagerDialog({super.key, required this.user});
  @override
  State<EditUserByManagerDialog> createState() =>
      _EditUserByManagerDialogState();
}

class _EditUserByManagerDialogState extends State<EditUserByManagerDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _workplaceController;
  final _passwordController = TextEditingController();
  late String _selectedRole;
  bool _isLoading = false;
  late List<String> _selectedCompanies;
  List<Map<String, dynamic>> _companiesList = [];
  bool _isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['full_name']);
    _phoneController = TextEditingController(
        text: widget.user['phone_number'] == '-'
            ? ''
            : widget.user['phone_number']);
    _workplaceController = TextEditingController(
        text: widget.user['workplace'] == '-' ? '' : widget.user['workplace']);
    _selectedRole = widget.user['role'] ?? 'staff';
    _selectedCompanies = List<String>.from(widget.user['company_access'] ?? []);
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final companies = await ApiService().getCompanies();
      if (mounted) {
        setState(() {
          _companiesList = companies;
          _isLoadingCompanies = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCompanies = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _workplaceController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildCompanyCheckboxes(List<String> selectedList) {
    if (_isLoadingCompanies) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_companiesList.isEmpty) {
      return const Text('Belum ada perusahaan. Tambahkan di Kelola Perusahaan.',
          style: TextStyle(color: AppTheme.danger, fontSize: 12));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Akses Perusahaan:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._companiesList.map((company) {
          final String name = company['name'];
          return CheckboxListTile(
            title: Text(name, style: const TextStyle(fontSize: 13)),
            value: selectedList.contains(name),
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  if (!selectedList.contains(name)) selectedList.add(name);
                } else {
                  selectedList.remove(name);
                }
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
          );
        }),
      ],
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Manage User: @${widget.user['username']}',
          style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
          width: screenWidth > 450 ? 400 : screenWidth * 0.9,
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            TextField(
                controller: _nameController,
                decoration: _inputDeco('Nama Lengkap', Icons.badge_outlined)),
            const SizedBox(height: 16),
            TextField(
                controller: _phoneController,
                decoration: _inputDeco('No HP', Icons.phone_outlined),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 16),
            TextField(
                controller: _workplaceController,
                decoration: _inputDeco('Tempat Kerja', Icons.work_outline)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              dropdownColor: isDark ? AppTheme.card : AppTheme.lightCard,
              items: [
                const DropdownMenuItem(value: 'staff', child: Text('Staff')),
                const DropdownMenuItem(
                    value: 'mitra_eks', child: Text('Mitra')),
                const DropdownMenuItem(
                    value: 'manager', child: Text('Manager')),
                if (context.read<AuthProvider>().user?['role'] ==
                    'super_manager')
                  const DropdownMenuItem(
                      value: 'super_manager', child: Text('Super Manager')),
              ],
              onChanged: (v) => setState(() => _selectedRole = v!),
              decoration:
                  _inputDeco('Role', Icons.admin_panel_settings_outlined),
            ),
            const SizedBox(height: 16),
            _buildCompanyCheckboxes(_selectedCompanies),
            const SizedBox(height: 16),
            TextField(
                controller: _passwordController,
                decoration:
                    _inputDeco('Reset Password', Icons.lock_reset_rounded)
                        .copyWith(hintText: 'Kosongkan jika tidak ubah')),
          ]))),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    final auth = context.read<AuthProvider>();
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);
                    setState(() => _isLoading = true);
                    try {
                      final success = await auth.updateUser(widget.user['id'], {
                        'full_name': _nameController.text.trim(),
                        'phone_number': _phoneController.text.trim().isEmpty
                            ? '-'
                            : _phoneController.text.trim(),
                        'workplace': _workplaceController.text.trim().isEmpty
                            ? '-'
                            : _workplaceController.text.trim(),
                        'role': _selectedRole,
                        'password': _passwordController.text.trim().isEmpty
                            ? null
                            : _passwordController.text.trim(),
                        'company_access': _selectedCompanies,
                      });
                      if (!mounted) return;
                      if (success) {
                        navigator.pop(true);
                      }
                    } catch (e) {
                      messenger.showSnackBar(SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: AppTheme.danger));
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Simpan Perubahan')),
      ],
    );
  }
}
