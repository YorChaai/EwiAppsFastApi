import 'package:flutter/material.dart';


class CascadingMenuItem {
  final String id;
  final String label;
  final IconData? icon;
  final bool selected;

  const CascadingMenuItem({
    required this.id,
    required this.label,
    this.icon,
    this.selected = false,
  });
}
