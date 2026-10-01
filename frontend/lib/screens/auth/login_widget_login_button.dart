import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';


class LoginButton extends StatelessWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const LoginButton({super.key, 
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: () async {
          // DEBUG BYPASS: Tekan lama untuk debug login
          final auth = context.read<AuthProvider>();
          await auth.debugLogin();
        },
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text('Masuk'),
      ),
    );
  }
}
