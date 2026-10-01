import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/settings/settings_screen.dart';
import 'package:expense_app/screens/settings/settings_screen_actions.dart';
import 'package:expense_app/screens/settings/settings_screen_dialogs.dart';
import 'package:expense_app/screens/settings/widget_logbook_button.dart';
import 'package:expense_app/screens/settings/widget_bank_advance_widget.dart';


extension SettingsLayoutProfileCardExt on SettingsScreenState {
  Widget buildProfileCard() {
    final auth = context.watch<AuthProvider>();
    final user = auth.user ?? {};
    final isGoogleLinked = user['google_id'] != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: cardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor(context)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppTheme.primary,
                  backgroundImage: auth.profileImageUrl != null
                      ? NetworkImage(auth.profileImageUrl!)
                      : null,
                  child: auth.profileImageUrl == null
                      ? Text(
                          (auth.fullName.isNotEmpty ? auth.fullName[0] : 'U')
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: showEditProfileDialog,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            auth.fullName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: titleColor(context),
            ),
          ),
          Text(
            '@${user['username'] ?? '-'}',
            style: TextStyle(fontSize: 14, color: bodyColor(context)),
          ),
          const SizedBox(height: 12),
          // Google Link Status Button
          SizedBox(
            height: 36,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isGoogleLinked ? AppTheme.success : AppTheme.danger,
                ),
                foregroundColor:
                    isGoogleLinked ? AppTheme.success : AppTheme.danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                if (isGoogleLinked) {
                  // Tampilkan dialog konfirmasi Unlink
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: cardColor(context),
                      title: const Text('Putuskan Google'),
                      content: const Text(
                        'Apakah Anda yakin ingin memutuskan hubungan akun Google dari aplikasi ini?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.danger,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Ya, Putuskan'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && mounted) {
                    final ok = await auth.unlinkGoogleAccount();
                    if (mounted) {
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Koneksi Google telah dihapus'),
                            backgroundColor: AppTheme.success,
                          ),
                        );
                      }
                    }
                  }
                } else {
                  // Cek dukungan platform saat diklik
                  final ok = await auth.linkGoogleAccount();
                  if (mounted) {
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil menghubungkan Google'),
                          backgroundColor: AppTheme.success,
                        ),
                      );
                    } else if (auth.error != null) {
                      // DEBUG BYPASS: Tampilkan pilihan jika gagal
                      final debug = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Mode Debug (Bypass)'),
                          content: const Text(
                            'Gagal menghubungkan Google. Apakah Anda ingin mensimulasikan koneksi berhasil untuk keperluan testing?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Ya, Simulasikan'),
                            ),
                          ],
                        ),
                      );

                      if (debug == true && mounted) {
                        await auth.debugLinkGoogle();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Berhasil menghubungkan Google (MODE DEBUG)',
                              ),
                              backgroundColor: AppTheme.success,
                            ),
                          );
                        }
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(auth.error!),
                            backgroundColor: AppTheme.danger,
                          ),
                        );
                      }
                    }
                  }
                }
              },
              icon: Icon(
                isGoogleLinked ? Icons.check_circle : Icons.link_rounded,
                size: 18,
              ),
              label: Text(
                isGoogleLinked ? 'Google Terhubung' : 'Hubungkan Google',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Wrap(
            spacing: 40,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              profileColumn(
                'Role',
                auth.roleDisplayName,
                Icons.badge_outlined,
              ),
              profileColumn(
                'No HP',
                user['phone_number'] ?? '-',
                Icons.phone_outlined,
              ),
              profileColumn(
                'Tempat Kerja',
                user['workplace'] ?? '-',
                Icons.work_outline,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 20),
          buildBankAdvanceWidget(),
          const SizedBox(height: 16),
          buildLogbookButton(),
        ],
      ),
    );
  }
}
