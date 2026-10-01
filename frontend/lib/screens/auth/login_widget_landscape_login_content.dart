import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/login_widget_landscape_intro_panel.dart';
import 'package:expense_app/screens/auth/login_widget_username_field.dart';
import 'package:expense_app/screens/auth/login_widget_password_field.dart';
import 'package:expense_app/screens/auth/login_widget_login_button.dart';
import 'package:expense_app/screens/auth/login_widget_register_link.dart';


class LandscapeLoginContent extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool loading;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onToggleObscure;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;
  final VoidCallback onRegister;
  final String serverUrl;
  final VoidCallback onConfigureServer;

  const LandscapeLoginContent({super.key, 
    required this.usernameController,
    required this.passwordController,
    required this.obscure,
    required this.loading,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: LandscapeIntroPanel(
              serverUrl: serverUrl,
              onConfigureServer: onConfigureServer,
            ),
          ),
        ),
        Container(
          width: 1,
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: AppTheme.divider.withValues(alpha: 0.5),
        ),
        Expanded(
          flex: 11,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                UsernameField(controller: usernameController),
                const SizedBox(height: 14),
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
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: rememberMe,
                              onChanged: onRememberMeChanged,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('Ingat Saya',
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    // Forgot Password
                    TextButton(
                      onPressed: onForgotPassword,
                      child: const Text('Lupa password?',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                LoginButton(
                  loading: loading,
                  onPressed: loading ? null : onLogin,
                ),
                const SizedBox(height: 14),
                RegisterLink(onTap: onRegister),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
