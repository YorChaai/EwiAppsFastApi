import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/app_brand_logo.dart';


class LoginBrandIcon extends StatelessWidget {
  final double size;
  final double iconSize;

  const LoginBrandIcon({super.key, 
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Center(
        child: AppBrandLogo(size: iconSize + 10),
      ),
    );
  }
}
