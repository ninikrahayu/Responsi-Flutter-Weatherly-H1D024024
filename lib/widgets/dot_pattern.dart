import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class DotPattern extends StatelessWidget {
  final double width, height, spacing, dotRadius;
  final Color color;
  const DotPattern({
    super.key,
    this.width = 100,
    this.height = 100,
    this.spacing = 12,
    this.dotRadius = 1,
    this.color = AppTheme.border,
  });
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(width, height),
    painter: DotPatternPainter(spacing, dotRadius, color),
  );
}

class DotPatternPainter extends CustomPainter {
  final double spacing, dotRadius;
  final Color color;
  const DotPatternPainter(this.spacing, this.dotRadius, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DotPatternPainter oldDelegate) =>
      oldDelegate.spacing != spacing ||
      oldDelegate.dotRadius != dotRadius ||
      oldDelegate.color != color;
}
