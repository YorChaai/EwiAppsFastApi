import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});
  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _workplaceController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedRole = 'staff';
  bool _isLoading = false;
  bool _obscurePassword = true;
  final List<String> _selectedCompanies = [];
  List<Map<String, dynamic>> _companiesList = [];
  bool _isLoadingCompanies = true;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    try {
      final companies = await ApiService().getCompanies();
      if (mounted) {
        setState(() {
          _companiesList = companies;
          if (companies.isNotEmpty) {
            _selectedCompanies.add(companies[0]['name']);
          }
          _isLoadingCompanies = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingCompanies = false);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _workplaceController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  Future<void> _submit() async {
    final username = _usernameController.text.trim();
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || fullName.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Field utama wajib diisi'),
          backgroundColor: AppTheme.danger));
      return;
    }
    if (password != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password tidak cocok'),
          backgroundColor: AppTheme.danger));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final success = await context.read<AuthProvider>().createUser(
            username: username,
            password: password,
            fullName: fullName,
            role: _selectedRole,
            phoneNumber: _phoneController.text.trim().isEmpty
                ? '-'
                : _phoneController.text.trim(),
            workplace: _workplaceController.text.trim().isEmpty
                ? '-'
                : _workplaceController.text.trim(),
            companyAccess: _selectedCompanies,
          );
      if (success && mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: $e'), backgroundColor: AppTheme.danger));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    return AlertDialog(
      backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Tambah Akun Baru',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(
          width: screenWidth > 450 ? 400 : screenWidth * 0.9,
          child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 8),
            TextField(
                controller: _usernameController,
                decoration: _inputDeco('Username', Icons.person_outline)),
            const SizedBox(height: 16),
            TextField(
                controller: _fullNameController,
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
                obscureText: _obscurePassword,
                decoration: _inputDeco('Password', Icons.lock_outline).copyWith(
                    suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword)))),
            const SizedBox(height: 16),
            TextField(
                controller: _confirmPasswordController,
                obscureText: _obscurePassword,
                decoration:
                    _inputDeco('Konfirmasi Password', Icons.lock_rounded)),
          ]))),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal')),
        ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Buat Akun')),
      ],
    );
  }
}
