import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/screens/auth/register_widget_portrait_register_content.dart';
import 'package:expense_app/screens/auth/register_widget_landscape_register_content.dart';


class RegisterScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialFullName;
  final String? initialGoogleId;
  final bool lockEmail;

  const RegisterScreen({
    super.key,
    this.initialEmail,
    this.initialFullName,
    this.initialGoogleId,
    this.lockEmail = false,
  });

  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final workplaceController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  String selectedRole = 'staff';
  String selectedCompany = 'EWI Foundation';
  late final AnimationController animController;
  late final Animation<double> fadeAnim;

  // Helper untuk theme-aware colors
  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color creamColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color dividerColor(BuildContext context) =>
      isDark(context) ? AppTheme.divider : AppTheme.lightDivider;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.initialEmail ?? '';
    fullNameController.text = widget.initialFullName ?? '';
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fadeAnim = CurvedAnimation(
      parent: animController,
      curve: Curves.easeOutCubic,
    );
    animController.forward();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    workplaceController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    animController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    FocusScope.of(context).unfocus();

    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final workplace = workplaceController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validasi
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username tidak boleh kosong'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap tidak boleh kosong'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (email.isNotEmpty && !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Format email tidak valid'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (widget.lockEmail && email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email Google wajib tersedia untuk registrasi ini'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak boleh kosong'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password minimal 6 karakter'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password dan konfirmasi password tidak sama'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      username,
      password,
      fullName,
      selectedRole,
      email: email.isEmpty ? null : email,
      googleId: widget.initialGoogleId,
      phoneNumber: phone.isEmpty ? '-' : phone,
      workplace: workplace.isEmpty ? '-' : workplace,
      companyAccess: [selectedCompany],
    );

    if (success && mounted) {
      // Show success dialog
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: cardColor(ctx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          icon:
              const Icon(Icons.check_circle, color: AppTheme.success, size: 64),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Akun Berhasil Dibuat!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: creamColor(ctx),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.initialGoogleId != null
                    ? 'Akun berhasil dibuat. Sekarang kamu bisa login dengan Gmail atau username dan password.'
                    : 'Silakan login dengan akun yang baru dibuat.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx, true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK, Login Sekarang',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true && mounted) {
        // Tunggu hingga dialog sukses selesai pop transition (~300ms)
        // sebelum mem-pop RegisterScreen. Ini mencegah tabrakan transisi pop ganda
        // di dalam Navigator yang dapat membuat layar menjadi blank atau transparan.
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          Navigator.pop(context); // Back to login
        }
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Registrasi gagal'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isMobile = ResponsiveLayout.isMobile(context);
    final isPhoneLandscape = ResponsiveLayout.isPhoneLandscape(context);
    final isCompact = ResponsiveLayout.shouldUseCompactControls(context);

    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);
    final verticalPadding = ResponsiveLayout.verticalPadding(context);

    final cardMaxWidth = isPhoneLandscape
        ? 780.0
        : isMobile
            ? 440.0
            : 520.0;

    final cardPadding = EdgeInsets.symmetric(
      horizontal: isCompact ? 18 : 28,
      vertical: isCompact ? 18 : 28,
    );

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnim,
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ).add(EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardMaxWidth,
                    minWidth: 280, // Minimum width like a phone
                  ),
                  child: Container(
                    padding: cardPadding,
                    decoration: BoxDecoration(
                      color: cardColor(context),
                      borderRadius: BorderRadius.circular(isCompact ? 20 : 24),
                      border: Border.all(color: dividerColor(context)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.08),
                          blurRadius: isCompact ? 24 : 36,
                          spreadRadius: 0,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: isPhoneLandscape
                        ? LandscapeRegisterContent(
                            usernameController: usernameController,
                            emailController: emailController,
                            fullNameController: fullNameController,
                            phoneController: phoneController,
                            workplaceController: workplaceController,
                            passwordController: passwordController,
                            confirmPasswordController:
                                confirmPasswordController,
                            obscurePassword: obscurePassword,
                            obscureConfirmPassword: obscureConfirmPassword,
                            selectedRole: selectedRole,
                            loading: auth.loading,
                            onToggleObscurePassword: () => setState(
                                () => obscurePassword = !obscurePassword),
                            onToggleObscureConfirmPassword: () => setState(() =>
                                obscureConfirmPassword =
                                    !obscureConfirmPassword),
                            onRoleChanged: (value) =>
                                setState(() => selectedRole = value),
                            selectedCompany: selectedCompany,
                            companies: auth.systemCompanies,
                            onCompanyChanged: (value) =>
                                setState(() => selectedCompany = value),
                            onRegister: register,
                            onBack: () => Navigator.pop(context),
                            lockEmail: widget.lockEmail,
                          )
                        : PortraitRegisterContent(
                            usernameController: usernameController,
                            emailController: emailController,
                            fullNameController: fullNameController,
                            phoneController: phoneController,
                            workplaceController: workplaceController,
                            passwordController: passwordController,
                            confirmPasswordController:
                                confirmPasswordController,
                            obscurePassword: obscurePassword,
                            obscureConfirmPassword: obscureConfirmPassword,
                            selectedRole: selectedRole,
                            loading: auth.loading,
                            compact: isCompact,
                            onToggleObscurePassword: () => setState(
                                () => obscurePassword = !obscurePassword),
                            onToggleObscureConfirmPassword: () => setState(() =>
                                obscureConfirmPassword =
                                    !obscureConfirmPassword),
                            onRoleChanged: (value) =>
                                setState(() => selectedRole = value),
                            selectedCompany: selectedCompany,
                            companies: auth.systemCompanies,
                            onCompanyChanged: (value) =>
                                setState(() => selectedCompany = value),
                            onRegister: register,
                            onBack: () => Navigator.pop(context),
                            lockEmail: widget.lockEmail,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
