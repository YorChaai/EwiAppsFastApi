import 'package:flutter/material.dart';

class ControllerDisposableWrapper extends StatefulWidget {
  final List<ChangeNotifier> controllers;
  final Widget child;

  const ControllerDisposableWrapper({
    super.key,
    required this.controllers,
    required this.child,
  });

  @override
  State<ControllerDisposableWrapper> createState() =>
      _ControllerDisposableWrapperState();
}

class _ControllerDisposableWrapperState
    extends State<ControllerDisposableWrapper> {
  @override
  void dispose() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
