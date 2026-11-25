import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

class DotWeatherIcon extends StatelessWidget {
  final int weatherCode;
  final double size;
  final Color color, accentColor;
  const DotWeatherIcon({
    super.key,
    required this.weatherCode,
    this.size = 100,
    this.color = AppTheme.textPrimary,
    this.accentColor = AppTheme.primary,
  });
  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size),
    painter: DotWeatherPainter(weatherCode, color, accentColor),
  );
}

class DotWeatherPainter extends CustomPainter {
  final int weatherCode;
  final Color color, accentColor;
  const DotWeatherPainter(this.weatherCode, this.color, this.accentColor);
  void _dots(
    Canvas canvas,
    Path path,
    Color color, {
    double spacing = 4,
    double radius = 1.6,
  }) {
    final paint = Paint()..color = color;
    for (double x = 2; x < 100; x += spacing) {
      for (double y = 2; y < 100; y += spacing) {
        final point = Offset(x, y);
        if (path.contains(point)) canvas.drawCircle(point, radius, paint);
      }
    }
  }

  Path _cloud(double top) => Path()
    ..moveTo(24, top + 42)
    ..cubicTo(2, top + 42, 2, top + 13, 24, top + 13)
    ..cubicTo(29, top - 9, 58, top - 9, 68, top + 13)
    ..cubicTo(95, top + 8, 99, top + 42, 76, top + 42)
    ..close();
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final scale = size.shortestSide / 100;
    canvas.translate(
      (size.width - 100 * scale) / 2,
      (size.height - 100 * scale) / 2,
    );
    canvas.scale(scale);
    canvas.saveLayer(const Rect.fromLTWH(0, 0, 100, 100), Paint());
    final accent = Paint()..color = accentColor;
    final ink = Paint()..color = color;
    if (weatherCode == 0 || [1, 2].contains(weatherCode)) {
      final center = weatherCode == 0
          ? const Offset(50, 50)
          : const Offset(67, 30);
      final radius = weatherCode == 0 ? 24.0 : 19.0;
      _dots(
        canvas,
        Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
        accentColor,
      );
      if (weatherCode == 0) {
        for (int i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          for (double d = 31; d <= 41; d += 5) {
            canvas.drawCircle(
              Offset(50 + math.cos(angle) * d, 50 + math.sin(angle) * d),
              1.9,
              accent,
            );
          }
        }
      }
    }
    if (weatherCode != 0) {
      final partly = [1, 2].contains(weatherCode);
      final path = _cloud(
        partly
            ? 30
            : weatherCode == 3
            ? 22
            : 10,
      );
      if (partly) canvas.drawPath(path, Paint()..blendMode = BlendMode.clear);
      for (final metric in path.computeMetrics()) {
        for (double d = 0; d < metric.length; d += 4) {
          final tangent = metric.getTangentForOffset(d);
          if (tangent != null) canvas.drawCircle(tangent.position, 1.8, ink);
        }
      }
      _dots(
        canvas,
        path,
        color.withValues(alpha: 0.18),
        spacing: 6,
        radius: 0.7,
      );
      if ([45, 48].contains(weatherCode)) {
        for (int row = 0; row < 3; row++) {
          for (double x = 15; x <= 85; x += 5) {
            canvas.drawCircle(Offset(x, 64.0 + row * 9), 1.6, ink);
          }
        }
      } else if ([
        51,
        53,
        55,
        56,
        57,
        61,
        63,
        65,
        66,
        67,
        80,
        81,
        82,
      ].contains(weatherCode)) {
        final count = [51, 53, 55, 56, 57].contains(weatherCode) ? 3 : 4;
        for (int i = 0; i < count; i++) {
          for (int j = 0; j < 4; j++) {
            canvas.drawCircle(
              Offset(26.0 + i * 15 - j * 2, 63.0 + j * 5),
              1.7,
              accent,
            );
          }
        }
      } else if ([71, 73, 75, 77, 85, 86].contains(weatherCode)) {
        for (int i = 0; i < 3; i++) {
          final center = Offset(25.0 + i * 25, 72);
          canvas.drawCircle(center, 2, accent);
          for (int j = 0; j < 6; j++) {
            final angle = j * math.pi / 3;
            canvas.drawCircle(
              Offset(
                center.dx + math.cos(angle) * 5,
                center.dy + math.sin(angle) * 5,
              ),
              1.6,
              accent,
            );
          }
        }
      } else if ([95, 96, 99].contains(weatherCode)) {
        final bolt = Path()
          ..moveTo(49, 56)
          ..lineTo(65, 56)
          ..lineTo(53, 72)
          ..lineTo(65, 72)
          ..lineTo(37, 97)
          ..lineTo(46, 78)
          ..lineTo(35, 78)
          ..close();
        _dots(canvas, bolt, accentColor, spacing: 3, radius: 1.3);
      }
    }
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DotWeatherPainter oldDelegate) =>
      oldDelegate.weatherCode != weatherCode ||
      oldDelegate.color != color ||
      oldDelegate.accentColor != accentColor;
}
