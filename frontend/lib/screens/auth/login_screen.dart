import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/responsive_layout.dart';
import 'package:expense_app/screens/auth/register_screen.dart';
import 'package:expense_app/screens/auth/login_widget_login_hint_card.dart';
import 'package:expense_app/screens/auth/login_widget_portrait_login_content.dart';
import 'package:expense_app/screens/auth/login_widget_gmail_login_button.dart';
import 'package:expense_app/screens/auth/login_widget_landscape_login_content.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final serverUrlController = TextEditingController();

  bool obscure = true;
  bool rememberMe = false;
  String currentServerUrl = ApiService.baseUrl;
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
    // ✅ Reset loading state whenever entering Login Screen to prevent infinite loading bug
    Future.microtask(() {
      if (mounted) {
        context.read<AuthProvider>().resetLoading();
      }
    });
    loadSavedCredentials();
    loadServerUrl();
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

  Future<void> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('saved_username');
    final savedPassword = prefs.getString('saved_password');
    final remember = prefs.getBool('remember_me') ?? false;

    if (remember && mounted) {
      setState(() {
        rememberMe = true;
        if (savedUsername != null) usernameController.text = savedUsername;
        if (savedPassword != null) passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    serverUrlController.dispose();
    animController.dispose();
    super.dispose();
  }

  Future<void> loadServerUrl() async {
    await ApiService.loadSavedBaseUrl();
    if (!mounted) return;
    setState(() {
      currentServerUrl = ApiService.baseUrl;
      serverUrlController.text = currentServerUrl;
    });
  }

  Future<void> showServerUrlDialog() async {
    serverUrlController.text = currentServerUrl;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Server URL',
          style: TextStyle(color: creamColor(context)),
        ),
        content: TextField(
          controller: serverUrlController,
          decoration: const InputDecoration(
            labelText: 'API Base URL',
            hintText: 'http://192.168.1.8:8000/api',
          ),
          style: TextStyle(
              color: isDark(context)
                  ? AppTheme.textPrimary
                  : AppTheme.lightTextPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await ApiService.saveBaseUrl('');
              if (!mounted) return;
              setState(() => currentServerUrl = ApiService.baseUrl);
              Navigator.of(this.context).pop();
            },
            child: const Text('Default'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ApiService.saveBaseUrl(serverUrlController.text);
              if (!mounted) return;
              setState(() => currentServerUrl = ApiService.baseUrl);
              Navigator.of(this.context).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    // Validate input
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username tidak boleh kosong'),
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

    final auth = context.read<AuthProvider>();
    final success =
        await auth.login(username, password, rememberMe: rememberMe);

    if (success) {
      final prefs = await SharedPreferences.getInstance();
      if (rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('saved_username', username);
        await prefs.setString('saved_password', password);
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('saved_username');
        await prefs.remove('saved_password');
      }
    } else if (mounted) {
      String errorMessage = auth.error ?? 'Login gagal';

      // Jika error mengandung indikasi kegagalan jaringan
      if (errorMessage.toLowerCase().contains('timeout') ||
          errorMessage.toLowerCase().contains('semaphore') ||
          errorMessage.toLowerCase().contains('socket') ||
          errorMessage.toLowerCase().contains('refused')) {
        errorMessage =
            "Gagal terhubung ke Server. Pastikan Alamat Server (IP) sudah benar.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppTheme.danger,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'CEK IP',
            textColor: Colors.white,
            onPressed: () {
              // Scroll ke widget server setting jika ada
            },
          ),
        ),
      );
    }
  }

  void navigateToRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  void showMessage(
    String message, {
    Color backgroundColor = AppTheme.danger,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  Future<void> handleGoogleLogin() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isGoogleSignInSupported) {
      showMessage(
        'Login Gmail belum tersedia di perangkat ini. Gunakan username dan password.',
      );
      return;
    }

    final result = await auth.loginWithGoogle(rememberMe: rememberMe);
    if (!mounted) return;

    if (result != null && result['new_user'] == true) {
      // User belum terdaftar, tanya dulu mau daftar atau tidak
      if (!mounted) return;
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: cardColor(ctx),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Akun Tidak Ditemukan'),
          content: Text(
            'Email ${result['email']} belum terdaftar di aplikasi. Apakah Anda ingin membuat akun baru menggunakan Gmail ini?',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Ya, Daftar Sekarang'),
            ),
          ],
        ),
      );

      if (confirm == true && mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RegisterScreen(
              initialEmail: result['email']?.toString(),
              initialFullName: result['full_name']?.toString(),
              initialGoogleId: result['google_id']?.toString(),
              lockEmail: true,
            ),
          ),
        );
      }
      return;
    }

    if (result == null && auth.error != null) {
      // Tampilkan error aslinya saja (misal: plugin tidak didukung di Windows)
      // Kita hapus bypass Debug Login karena menyebabkan error 422 di backend (token palsu)
      showMessage(auth.error!);
    }
  }

  Future<void> showForgotPasswordDialog() async {
    final auth = context.read<AuthProvider>();
    final emailController = TextEditingController();
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();

    var otpSent = false;
    var obscureNewPassword = true;
    var busy = false;

    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (dialogContext, setModalState) {
              Future<void> submit() async {
                final navigator = Navigator.of(dialogContext);
                final email = emailController.text.trim();
                final otp = otpController.text.trim();
                final newPassword = newPasswordController.text;

                if (email.isEmpty) {
                  showMessage('Email wajib diisi.');
                  return;
                }

                if (!email.contains('@')) {
                  showMessage('Masukkan email yang valid.');
                  return;
                }

                if (otpSent) {
                  if (otp.isEmpty) {
                    showMessage('Kode OTP wajib diisi.');
                    return;
                  }
                  if (newPassword.length < 6) {
                    showMessage('Password baru minimal 6 karakter.');
                    return;
                  }
                }

                setModalState(() => busy = true);

                if (!otpSent) {
                  // DEBUG BYPASS: Gunakan email 'debug@ewiapps.com' untuk bypass
                  bool success;
                  if (email == 'debug@ewiapps.com') {
                    success = await auth.debugForgotPassword(email);
                  } else {
                    success = await auth.forgotPassword(email);
                  }

                  if (!mounted) return;

                  setModalState(() {
                    busy = false;
                    if (success) {
                      otpSent = true;
                    }
                  });

                  if (success) {
                    showMessage(
                      email == 'debug@ewiapps.com'
                          ? 'MODE DEBUG: OTP Berhasil dikirim.'
                          : 'Jika email terdaftar, kode OTP akan dikirim ke email tersebut.',
                      backgroundColor: AppTheme.accent,
                    );
                  } else {
                    showMessage(auth.error ?? 'Gagal mengirim kode OTP.');
                  }
                  return;
                }

                // DEBUG BYPASS
                bool success;
                if (email == 'debug@ewiapps.com') {
                  success = await auth.debugResetPassword();
                } else {
                  success = await auth.resetPassword(
                    email: email,
                    otp: otp,
                    newPassword: newPassword,
                  );
                }

                if (!mounted) return;

                setModalState(() => busy = false);

                if (success) {
                  navigator.pop();
                  showMessage(
                    'Password berhasil diganti (Mode Debug). Silakan login kembali.',
                    backgroundColor: AppTheme.success,
                  );
                } else {
                  showMessage(auth.error ?? 'Reset password gagal.');
                }
              }

              return AlertDialog(
                backgroundColor: cardColor(dialogContext),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text(
                  otpSent ? 'Reset Password' : 'Lupa Password',
                  style: TextStyle(color: creamColor(dialogContext)),
                ),
                content: SizedBox(
                  width: 380,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otpSent
                            ? 'Masukkan OTP dari email dan password baru Anda.'
                            : 'Masukkan email yang terdaftar pada akun Anda untuk menerima OTP.',
                        style: TextStyle(
                          color: isDark(dialogContext)
                              ? AppTheme.textSecondary
                              : AppTheme.lightTextSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: emailController,
                        enabled: !busy,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: otpSent
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      if (otpSent) ...[
                        const SizedBox(height: 12),
                        TextField(
                          controller: otpController,
                          enabled: !busy,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Kode OTP',
                            prefixIcon: Icon(Icons.verified_user_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: newPasswordController,
                          enabled: !busy,
                          obscureText: obscureNewPassword,
                          decoration: InputDecoration(
                            labelText: 'Password Baru',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              onPressed: busy
                                  ? null
                                  : () => setModalState(
                                        () => obscureNewPassword =
                                            !obscureNewPassword,
                                      ),
                              icon: Icon(
                                obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => submit(),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed:
                        busy ? null : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: busy ? null : submit,
                    child: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(otpSent ? 'Reset Password' : 'Kirim OTP'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      emailController.dispose();
      otpController.dispose();
      newPasswordController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isMobile = ResponsiveLayout.isMobile(context);
    final isCompact = ResponsiveLayout.shouldUseCompactControls(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = ResponsiveLayout.horizontalPadding(context);

    final cardMaxWidth = isMobile
        ? 440.0
        : 760.0; // Izinkan lebih lebar di Desktop/Tablet agar dua kolom muat

    final cardPadding = EdgeInsets.symmetric(
      horizontal: isCompact ? 18 : 32,
      vertical: isCompact ? 18 : 32,
    );

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnim,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ).add(EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: cardMaxWidth,
                    minWidth: 300,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor(context),
                      borderRadius: BorderRadius.circular(isCompact ? 20 : 28),
                      border: Border.all(
                          color: dividerColor(context).withValues(alpha: 0.8)),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.12),
                          blurRadius: isCompact ? 24 : 40,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: cardPadding.copyWith(bottom: 0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // LOGIKA PINTAR:
                              // Jika Lebar > 500 ATAU Tinggi Layar < 600, gunakan mode Samping-sampingan (Tab)
                              // Ini agar footer tidak terpotong saat jendela pendek.
                              if (constraints.maxWidth > 500 ||
                                  screenHeight < 600) {
                                return LandscapeLoginContent(
                                  usernameController: usernameController,
                                  passwordController: passwordController,
                                  obscure: obscure,
                                  loading: auth.loading,
                                  rememberMe: rememberMe,
                                  onRememberMeChanged: (v) =>
                                      setState(() => rememberMe = v ?? false),
                                  onToggleObscure: () =>
                                      setState(() => obscure = !obscure),
                                  onLogin: login,
                                  onForgotPassword: showForgotPasswordDialog,
                                  onRegister: () =>
                                      navigateToRegister(context),
                                  serverUrl: currentServerUrl,
                                  onConfigureServer: showServerUrlDialog,
                                );
                              }
                              // Mode Portrait Standar untuk layar HP yang tinggi
                              return PortraitLoginContent(
                                usernameController: usernameController,
                                passwordController: passwordController,
                                obscure: obscure,
                                loading: auth.loading,
                                compact: isCompact || screenHeight < 700,
                                rememberMe: rememberMe,
                                onRememberMeChanged: (v) =>
                                    setState(() => rememberMe = v ?? false),
                                onToggleObscure: () =>
                                    setState(() => obscure = !obscure),
                                onLogin: login,
                                onForgotPassword: showForgotPasswordDialog,
                                onRegister: () => navigateToRegister(context),
                                serverUrl: currentServerUrl,
                                onConfigureServer: showServerUrlDialog,
                              );
                            },
                          ),
                        ),
                        // Tidak ada Divider di sini
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Atau masuk dengan",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark(context)
                                      ? AppTheme.textSecondary
                                      : Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GmailLoginButton(
                                onPressed: handleGoogleLogin,
                                enabled: auth.isGoogleSignInSupported,
                              ),
                              const SizedBox(height: 14),
                              const LoginHintCard(),
                            ],
                          ),
                        ),
                      ],
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

String serverLabel(String serverUrl) => 'Server: $serverUrl (tap untuk ubah)';
