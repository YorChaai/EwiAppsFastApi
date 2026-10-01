import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';


class RegisterBrandIcon extends StatelessWidget {
  final double size;
  final double iconSize;

  const RegisterBrandIcon({super.key, 
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
        child: Icon(
          Icons.person_add_rounded,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
