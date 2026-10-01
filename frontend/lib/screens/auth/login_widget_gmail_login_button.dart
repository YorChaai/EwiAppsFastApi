import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';


class GmailLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool enabled;

  const GmailLoginButton({super.key, 
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        onLongPress: () async {
          // DEBUG BYPASS: Tekan lama untuk debug login
          final auth = context.read<AuthProvider>();
          await auth.debugLogin();
        },
        customBorder: const CircleBorder(),
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppTheme.divider : AppTheme.lightDivider,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Image.network(
                'https://www.gstatic.com/images/branding/product/2x/googleg_96dp.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (ctx, _, error) => Icon(
                  Icons.g_mobiledata_rounded,
                  size: 30,
                  color: enabled ? AppTheme.primary : AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
