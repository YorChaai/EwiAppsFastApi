import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/context_extensions.dart';
import 'package:expense_app/screens/layout/main_layout.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to allow the initial build to complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.accessibleCompanies.length == 1) {
        auth.setActiveCompany(auth.accessibleCompanies.first);
      } else if (auth.activeCompany.isNotEmpty) {
        // If a company was already selected (e.g. going back from settings), just show it
      }
    });
  }

  void _selectCompany(String company) {
    final auth = context.read<AuthProvider>();
    auth.setActiveCompany(company);
  }

  @override
  Widget build(BuildContext context) {
    // If a company is selected or bypassed, render MainLayout directly!
    // This avoids messing with the Navigator stack and works perfectly with auth.logout().
    final auth = context.watch<AuthProvider>();
    if (auth.activeCompany.isNotEmpty) {
      return const MainLayout();
    }
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo or Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      size: 64,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Pilih Perusahaan',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color:
                          isDark ? AppTheme.cream : AppTheme.lightTextPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Pilih perusahaan yang ingin Anda kelola hari ini',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Company Cards
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: auth.accessibleCompanies.map((company) {
                      return _buildCompanyCard(
                        company,
                        company == 'EWI Foundation'
                            ? Icons.foundation
                            : Icons.wifi_tethering,
                        isDark,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 48),

                  // Logout Button
                  TextButton.icon(
                    onPressed: () {
                      context.read<AuthProvider>().logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.redAccent, fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(String companyName, IconData icon, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectCompany(companyName),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          width: 320,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surface : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppTheme.divider : AppTheme.lightDivider,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                companyName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.cream : AppTheme.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Masuk Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
