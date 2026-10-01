import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/login_screen.dart';
import 'package:expense_app/screens/auth/login_widget_login_brand_icon.dart';
import 'package:expense_app/screens/auth/login_widget_username_field.dart';
import 'package:expense_app/screens/auth/login_widget_password_field.dart';
import 'package:expense_app/screens/auth/login_widget_login_button.dart';
import 'package:expense_app/screens/auth/login_widget_register_link.dart';


class PortraitLoginContent extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool loading;
  final bool compact;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
  final String serverUrl;
  final VoidCallback onConfigureServer;

  const PortraitLoginContent({super.key, 
    required this.usernameController,
    required this.passwordController,
    required this.obscure,
    required this.loading,
    required this.compact,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onToggleObscure,
    required this.onLogin,
    required this.onForgotPassword,
    required this.onRegister,
    required this.serverUrl,
    required this.onConfigureServer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleSize = compact ? 21.0 : 24.0;
    final subtitleSize = compact ? 13.0 : 14.0;
    final iconBox = compact ? 72.0 : 84.0;
    final iconSize = compact ? 34.0 : 40.0;
    final spacingLarge = compact ? 20.0 : 24.0;
    final spacingMedium = compact ? 14.0 : 16.0;
    final spacingXL = compact ? 24.0 : 32.0;
    // Warna teks yang jelas untuk Light & Dark mode
    final titleColor = isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
    final subtitleColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LoginBrandIcon(size: iconBox, iconSize: iconSize),
        SizedBox(height: spacingLarge),
        Text(
          'ExspanApp',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Masuk untuk melanjutkan',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subtitleColor,
            fontSize: subtitleSize,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onConfigureServer,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              serverLabel(serverUrl),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.accent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: spacingXL),
        UsernameField(controller: usernameController),
        SizedBox(height: spacingMedium),
        PasswordField(
          controller: passwordController,
          obscure: obscure,
          onToggleObscure: onToggleObscure,
          onSubmitted: onLogin,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Remember Me
            InkWell(
              onTap: () => onRememberMeChanged(!rememberMe),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: onRememberMeChanged,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Ingat Saya',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Forgot Password
            TextButton(
              onPressed: onForgotPassword,
              child: const Text(
                'Lupa password?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: compact ? 12 : 16),
        LoginButton(
          loading: loading,
          onPressed: loading ? null : onLogin,
        ),
        SizedBox(height: spacingMedium),
        RegisterLink(onTap: onRegister),
      ],
    );
  }
}
