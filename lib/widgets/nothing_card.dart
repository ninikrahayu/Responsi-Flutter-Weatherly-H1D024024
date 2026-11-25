import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class NothingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius, borderWidth;
  final Color backgroundColor, borderColor;
  const NothingCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
    this.backgroundColor = AppTheme.surface,
    this.borderColor = AppTheme.textPrimary,
    this.borderWidth = 1,
  });
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor, width: borderWidth),
    ),
    child: child,
  );
}
