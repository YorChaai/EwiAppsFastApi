import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/register_widget_register_brand_icon.dart';
import 'package:expense_app/screens/auth/register_widget_username_field.dart';
import 'package:expense_app/screens/auth/register_widget_full_name_field.dart';
import 'package:expense_app/screens/auth/register_widget_email_field.dart';
import 'package:expense_app/screens/auth/register_widget_phone_field.dart';
import 'package:expense_app/screens/auth/register_widget_workplace_field.dart';
import 'package:expense_app/screens/auth/register_widget_password_field.dart';
import 'package:expense_app/screens/auth/register_widget_confirm_password_field.dart';
import 'package:expense_app/screens/auth/register_widget_role_dropdown.dart';
import 'package:expense_app/screens/auth/register_widget_company_dropdown.dart';
import 'package:expense_app/screens/auth/register_widget_register_button.dart';
import 'package:expense_app/screens/auth/register_widget_back_button.dart';


class PortraitRegisterContent extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController workplaceController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String selectedRole;
  final bool loading;
  final bool compact;
  final VoidCallback onToggleObscurePassword;
  final VoidCallback onToggleObscureConfirmPassword;
  final ValueChanged<String> onRoleChanged;
  final String selectedCompany;
  final List<String> companies;
  final ValueChanged<String> onCompanyChanged;
  final VoidCallback onRegister;
  final VoidCallback onBack;
  final bool lockEmail;

  const PortraitRegisterContent({super.key, 
    required this.usernameController,
    required this.emailController,
    required this.fullNameController,
    required this.phoneController,
    required this.workplaceController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.selectedRole,
    required this.loading,
    required this.compact,
    required this.onToggleObscurePassword,
    required this.onToggleObscureConfirmPassword,
    required this.onRoleChanged,
    required this.selectedCompany,
    required this.companies,
    required this.onCompanyChanged,
    required this.onRegister,
    required this.onBack,
    required this.lockEmail,
  });
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppTheme.cream : AppTheme.lightTextPrimary;
    final subtitleColor =
        isDark ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
    final subtitleSize = compact ? 13.0 : 14.0;
    final iconBox = compact ? 72.0 : 84.0;
    final iconSize = compact ? 34.0 : 40.0;
    final spacingLarge = compact ? 20.0 : 24.0;
    final spacingMedium = compact ? 12.0 : 14.0;
    final spacingXL = compact ? 24.0 : 32.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RegisterBrandIcon(size: iconBox, iconSize: iconSize),
        SizedBox(height: spacingLarge),
        Text(
          'Daftar Akun Baru',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Isi form di bawah untuk membuat akun',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: subtitleColor,
            fontSize: subtitleSize,
          ),
        ),
        SizedBox(height: spacingXL),
        UsernameField(controller: usernameController),
        SizedBox(height: spacingMedium),
        EmailField(controller: emailController, readOnly: lockEmail),
        SizedBox(height: spacingMedium),
        FullNameField(controller: fullNameController),
        SizedBox(height: spacingMedium),
        PhoneField(controller: phoneController),
        SizedBox(height: spacingMedium),
        WorkplaceField(controller: workplaceController),
        SizedBox(height: spacingMedium),
        PasswordField(
          controller: passwordController,
          obscure: obscurePassword,
          onToggleObscure: onToggleObscurePassword,
        ),
        SizedBox(height: spacingMedium),
        ConfirmPasswordField(
          controller: confirmPasswordController,
          obscure: obscureConfirmPassword,
          onToggleObscure: onToggleObscureConfirmPassword,
        ),
        SizedBox(height: spacingMedium),
        RoleDropdown(
          selectedRole: selectedRole,
          onRoleChanged: onRoleChanged,
        ),
        SizedBox(height: spacingMedium),
        CompanyDropdown(
          selectedCompany: selectedCompany,
          companies: companies,
          onCompanyChanged: onCompanyChanged,
        ),
        SizedBox(height: spacingXL),
        RegisterButton(
          loading: loading,
          onPressed: loading ? null : onRegister,
        ),
        SizedBox(height: spacingMedium),
        CustomBackButton(onBack: onBack),
      ],
    );
  }
}
