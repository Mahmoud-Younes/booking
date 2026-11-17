import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wraps content in a centered max-width container on wide viewports so the
/// web build reads as a page instead of a magnified phone. Applied through
/// `MaterialApp.builder` so every route is covered.
class BreakpointShell extends StatelessWidget {
  const BreakpointShell({super.key, required this.child, this.maxWidth = 720});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: math.min(maxWidth, width)),
        child: child,
      ),
    );
  }
}
