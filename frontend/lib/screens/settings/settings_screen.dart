import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart'; // Ganti ke file_picker
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/core/theme_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/image_cropper_dialog.dart';
import 'package:expense_app/utils/event_bus.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';
import 'package:expense_app/screens/settings/widget_profile_card.dart';
import 'package:expense_app/screens/settings/widget_theme_settings_card.dart';
import 'package:expense_app/screens/settings/widget_manager_section.dart';
import 'package:expense_app/screens/settings/widget_report_year_settings_card.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  void updateState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  final ApiService api = ApiService();
  bool loading = true;
  Map<String, dynamic> balanceData = {};
  bool loadingBalance = true;
  bool isBankCardExpanded = false;
  final Map<String, double> bankBreakdown = {}; // Bank saldo (from office)
  final Map<String, double> bankHutangBreakdown =
      {}; // Hutang per bank (virtual)
  List<Map<String, dynamic>> rawHutangBalances = [];
  Set<String> expandedHutangBanks = {};
  String currentDir = '';
  int currentReportYear = 0; // 0 means Default (Current Year)
  final dirController = TextEditingController();
  bool showManagerSection = false;

  double get activeAdvanceBalance =>
      (balanceData['available_budget'] ?? 0.0).toDouble();

  StreamSubscription<void>? refreshSub;

  @override
  void initState() {
    super.initState();

    loadSettings();

    refreshSub = GlobalEventBus.onRefresh.listen((_) {
      if (mounted) {
        loadSettings();
      }
    });
  }

  @override
  void dispose() {
    refreshSub?.cancel();
    dirController.dispose();
    super.dispose();
  }

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;
  Color titleColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color bodyColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Sistem'),
        actions: [
          if (auth.isManager)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: toggleManagerSection,
                icon: Icon(
                  Icons.admin_panel_settings_rounded,
                  color: showManagerSection
                      ? AppTheme.primary
                      : bodyColor(context),
                  size: 20,
                ),
                label: Text(
                  'Manager Panel',
                  style: TextStyle(
                    color: showManagerSection
                        ? AppTheme.primary
                        : bodyColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildProfileCard(),
                  const SizedBox(height: 16),
                  buildThemeSettingsCard(themeProvider),
                  const SizedBox(height: 16),
                  buildReportYearSettingsCard(),
                  if (auth.isManager && showManagerSection)
                    buildManagerSection(),
                ],
              ),
            ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  const EditProfileDialog({super.key, required this.user});
  @override
  State<EditProfileDialog> createState() => EditProfileDialogState();
}

class EditProfileDialogState extends State<EditProfileDialog> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController workplaceController;
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isLoading = false;
  bool showPasswordFields = false;

  String? selectedImagePath; // Simpan path string
  bool removeImage = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.user['full_name']);
    phoneController = TextEditingController(
      text:
          widget.user['phone_number'] == '-' ? '' : widget.user['phone_number'],
    );
    workplaceController = TextEditingController(
      text: widget.user['workplace'] == '-' ? '' : widget.user['workplace'],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    workplaceController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final pickedFile = File(result.files.single.path!);
        if (!mounted) return;

        // Buka dialog "Pencocokan" (Cropper)
        final croppedPath = await showDialog<String>(
          context: context,
          barrierColor: Colors.black54,
          builder: (ctx) => ImageCropperDialog(imageFile: pickedFile),
        );

        if (croppedPath != null) {
          setState(() {
            selectedImagePath = croppedPath;
            removeImage = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> submit() async {
    setState(() => isLoading = true);
    try {
      final auth = context.read<AuthProvider>();
      final success = await auth.updateProfile(
        {
          'full_name': nameController.text.trim(),
          'phone_number': phoneController.text.trim().isEmpty
              ? '-'
              : phoneController.text.trim(),
          'workplace': workplaceController.text.trim().isEmpty
              ? '-'
              : workplaceController.text.trim(),
          'old_password':
              showPasswordFields ? oldPasswordController.text : null,
          'new_password':
              showPasswordFields ? newPasswordController.text : null,
        },
        imagePath: selectedImagePath,
        removeImage: removeImage,
      );
      if (success && mounted) {
        Navigator.pop(context, {'success': true, 'user': auth.user});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    return AlertDialog(
      backgroundColor: isDark ? AppTheme.card : AppTheme.lightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text(
          'Edit Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Picker UI - Centered with floating buttons
            Center(
              child: SizedBox(
                width:
                    220, // Lebar cukup untuk avatar + tombol di kanan (dan dummy di kiri agar center)
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    // Avatar Utama
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      backgroundImage: removeImage
                          ? null
                          : (selectedImagePath != null
                              ? FileImage(File(selectedImagePath!))
                              : (auth.profileImageUrl != null
                                  ? NetworkImage(auth.profileImageUrl!)
                                  : null) as ImageProvider?),
                      child: (removeImage ||
                              (auth.profileImageUrl == null &&
                                  selectedImagePath == null))
                          ? const Icon(
                              Icons.person,
                              size: 48,
                              color: AppTheme.primary,
                            )
                          : null,
                    ),

                    // Overlay Hapus (Notifikasi visual saat akan dihapus)
                    if (removeImage)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                Text(
                                  'Dihapus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Tombol Aksi di Samping Kanan
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Button Ganti Foto
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.card,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Button Hapus Foto
                          if (auth.profileImageUrl != null ||
                              selectedImagePath != null)
                            GestureDetector(
                              onTap: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Hapus Foto Profil?'),
                                    content: const Text(
                                      'Apakah Anda yakin ingin menghapus foto profil ini?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(
                                          foregroundColor: AppTheme.danger,
                                        ),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  setState(() {
                                    selectedImagePath = null;
                                    removeImage = true;
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.danger,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.card,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.delete_rounded,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'No HP',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: workplaceController,
              decoration: const InputDecoration(
                labelText: 'Tempat Kerja',
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              onTap: () =>
                  setState(() => showPasswordFields = !showPasswordFields),
              title: const Text(
                'Ganti Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              trailing: Icon(
                showPasswordFields
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
              contentPadding: EdgeInsets.zero,
            ),
            if (showPasswordFields) ...[
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Saat Ini',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock_reset_rounded),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Password minimal 6 karakter',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: isLoading ? null : submit,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Simpan Perubahan'),
        ),
      ],
    );
  }
}
