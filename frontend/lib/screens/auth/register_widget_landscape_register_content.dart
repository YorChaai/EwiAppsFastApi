import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/auth/register_widget_landscape_intro_panel.dart';
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


class LandscapeRegisterContent extends StatelessWidget {
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
  final VoidCallback onToggleObscurePassword;
  final VoidCallback onToggleObscureConfirmPassword;
  final ValueChanged<String> onRoleChanged;
  final String selectedCompany;
  final List<String> companies;
  final ValueChanged<String> onCompanyChanged;
  final VoidCallback onRegister;
  final VoidCallback onBack;
  final bool lockEmail;

  const LandscapeRegisterContent({super.key, 
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 9,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: LandscapeIntroPanel(),
          ),
        ),
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: AppTheme.divider,
        ),
        Expanded(
          flex: 13,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UsernameField(controller: usernameController),
                  const SizedBox(height: 12),
                  EmailField(controller: emailController, readOnly: lockEmail),
                  const SizedBox(height: 12),
                  FullNameField(controller: fullNameController),
                  const SizedBox(height: 12),
                  PhoneField(controller: phoneController),
                  const SizedBox(height: 12),
                  WorkplaceField(controller: workplaceController),
                  const SizedBox(height: 12),
                  PasswordField(
                    controller: passwordController,
                    obscure: obscurePassword,
                    onToggleObscure: onToggleObscurePassword,
                  ),
                  const SizedBox(height: 12),
                  ConfirmPasswordField(
                    controller: confirmPasswordController,
                    obscure: obscureConfirmPassword,
                    onToggleObscure: onToggleObscureConfirmPassword,
                  ),
                  const SizedBox(height: 12),
                  RoleDropdown(
                    selectedRole: selectedRole,
                    onRoleChanged: onRoleChanged,
                  ),
                  const SizedBox(height: 12),
                  CompanyDropdown(
                    selectedCompany: selectedCompany,
                    companies: companies,
                    onCompanyChanged: onCompanyChanged,
                  ),
                  const SizedBox(height: 20),
                  RegisterButton(
                    loading: loading,
                    onPressed: loading ? null : onRegister,
                  ),
                  const SizedBox(height: 12),
                  CustomBackButton(onBack: onBack, compact: true),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
