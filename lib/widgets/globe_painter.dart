import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlobePainter extends CustomPainter {
  final double rotation;
  final Color gridColor;

  GlobePainter({this.rotation = 0, this.gridColor = AppColors.accent2});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 * 0.9;

    // Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          gridColor.withOpacity(0.15),
          gridColor.withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));
    canvas.drawCircle(center, radius * 1.5, glowPaint);

    // Globe circle
    final circlePaint = Paint()
      ..color = gridColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, circlePaint);

    final borderPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, borderPaint);

    // Latitude lines
    final dotPaint = Paint()
      ..color = gridColor.withOpacity(0.2)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (int i = 1; i < 6; i++) {
      final latY = center.dy + radius * (i - 3) / 3;
      final halfW = sqrt(max(0, radius * radius - pow(latY - center.dy, 2)));
      canvas.drawLine(
        Offset(center.dx - halfW, latY),
        Offset(center.dx + halfW, latY),
        dotPaint,
      );
    }

    // Longitude lines (curved, rotating)
    for (int i = 0; i < 8; i++) {
      final angle = rotation + (i * pi / 4);
      final xOffset = cos(angle) * radius;
      final path = Path();
      path.moveTo(center.dx, center.dy - radius);
      path.quadraticBezierTo(
        center.dx + xOffset * 0.5,
        center.dy,
        center.dx,
        center.dy + radius,
      );
      canvas.drawPath(path, dotPaint);
    }
  }

  @override
  bool shouldRepaint(GlobePainter old) => old.rotation != rotation;
}
