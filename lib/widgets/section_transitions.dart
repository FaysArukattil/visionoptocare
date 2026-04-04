import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ── Cinematic Section Transition Overlay Engine ──
/// Each transition is a lightweight CustomPaint overlay that plays
/// between two page indices during scroll. All GPU-friendly.
class SectionTransitionOverlay extends StatelessWidget {
  final double scrollProgress; // raw scroll position in pages (e.g. 3.5 = halfway between page 3 and 4)
  final int totalPages;

  const SectionTransitionOverlay({
    super.key,
    required this.scrollProgress,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which transition to show
    final fromPage = scrollProgress.floor();
    final t = scrollProgress - fromPage; // 0.0 to 1.0 between pages

    // Only show transitions when actually between pages (not settled)
    if (t < 0.05 || t > 0.95) return const SizedBox.shrink();
    if (fromPage < 1 || fromPage >= totalPages - 1) return const SizedBox.shrink();

    // Map the raw t to a clean curve
    final curved = Curves.easeInOutCubic.transform(t);

    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _getTransitionPainter(fromPage, curved, t),
          ),
        ),
      ),
    );
  }

  CustomPainter _getTransitionPainter(int fromPage, double curved, double raw) {
    switch (fromPage) {
      case 1: // Intro → Clinical Tests: "Digital Scan"
        return _ScanLinePainter(progress: raw, color: AppColors.accent2);
      case 2: // Clinical → Reports: "Data Cascade"
        return _DataCascadePainter(progress: raw, color: const Color(0xFF4F6AFF));
      case 3: // Reports → Consultations: "Ripple Pulse"
        return _RipplePulsePainter(progress: raw, color: const Color(0xFF00D4C8));
      case 4: // Consultations → B2B: "Scale Transform"
        return _ScaleTransformPainter(progress: raw, color: AppColors.gold);
      case 5: // B2B → Philosophy: "Blur Dissolve Lines"
        return _BlurDissolvePainter(progress: raw, color: const Color(0xFFF5C842));
      case 6: // Philosophy → Leadership: "Curtain Reveal"
        return _CurtainRevealPainter(progress: raw, color: AppColors.accent2);
      case 7: // Leadership → Team: "Parallax Lines"
        return _ParallaxLinesPainter(progress: raw, color: const Color(0xFF9D4EDD));
      case 8: // Team → Footer: "Gravity Settle"
        return _GravitySettlePainter(progress: raw, color: AppColors.accent2);
      default:
        return _ScanLinePainter(progress: raw, color: AppColors.accent2);
    }
  }
}

/// ── Transition 1: Digital Scan Line ──
/// A horizontal scan line sweeps top to bottom with trailing glow.
class _ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;
  _ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);
    final yPos = size.height * progress;

    // Main scan line
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6 * bellT)
      ..strokeWidth = 2.0;
    canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), paint);

    // Trailing glow
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.15 * bellT),
          color.withValues(alpha: 0.08 * bellT),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, yPos - 60, size.width, 120));
    canvas.drawRect(Rect.fromLTWH(0, yPos - 60, size.width, 120), glowPaint);

    // Scan dots along the line
    final dotPaint = Paint()..color = color.withValues(alpha: 0.4 * bellT);
    for (int i = 0; i < 20; i++) {
      final x = (size.width / 20) * i + (size.width / 40);
      canvas.drawCircle(Offset(x, yPos), 1.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter old) => old.progress != progress;
}

/// ── Transition 2: Data Cascade ──
/// Cascading vertical data streaks fall like matrix rain.
class _DataCascadePainter extends CustomPainter {
  final double progress;
  final Color color;
  _DataCascadePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);
    final random = math.Random(42);

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final speed = 0.5 + random.nextDouble() * 1.5;
      final startY = -size.height * 0.3 + (progress * speed * size.height * 1.5);
      final length = 30 + random.nextDouble() * 60;

      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: 0.0),
            color.withValues(alpha: 0.3 * bellT),
            color.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(x - 1, startY, 2, length));

      canvas.drawRect(Rect.fromLTWH(x, startY, 1.5, length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DataCascadePainter old) => old.progress != progress;
}

/// ── Transition 3: Ripple Pulse ──
/// Concentric ripple circles emanate from center.
class _RipplePulsePainter extends CustomPainter {
  final double progress;
  final Color color;
  _RipplePulsePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final bellT = _bellCurve(progress);
    final maxRadius = size.longestSide * 0.8;

    for (int i = 0; i < 5; i++) {
      final delay = i * 0.15;
      final ringT = ((progress - delay) * 2.0).clamp(0.0, 1.0);
      final radius = ringT * maxRadius;
      final opacity = (1.0 - ringT) * bellT * 0.3;

      if (opacity > 0.01) {
        canvas.drawCircle(
          center,
          radius,
          Paint()
            ..color = color.withValues(alpha: opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePulsePainter old) => old.progress != progress;
}

/// ── Transition 4: Scale Transform ──
/// Content compresses to a point then expands.
class _ScaleTransformPainter extends CustomPainter {
  final double progress;
  final Color color;
  _ScaleTransformPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final bellT = _bellCurve(progress);

    // Diamond/rhombus that scales
    final diamondSize = bellT * size.shortestSide * 0.4;

    final path = Path()
      ..moveTo(center.dx, center.dy - diamondSize) // top
      ..lineTo(center.dx + diamondSize, center.dy) // right
      ..lineTo(center.dx, center.dy + diamondSize) // bottom
      ..lineTo(center.dx - diamondSize, center.dy) // left
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.08 * bellT)
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.3 * bellT)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Corner accents
    final cornerPaint = Paint()
      ..color = color.withValues(alpha: 0.2 * bellT)
      ..strokeWidth = 1.0;
    final offset = diamondSize * 1.2;
    canvas.drawLine(Offset(center.dx - offset, center.dy), Offset(center.dx - offset + 20, center.dy), cornerPaint);
    canvas.drawLine(Offset(center.dx + offset - 20, center.dy), Offset(center.dx + offset, center.dy), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScaleTransformPainter old) => old.progress != progress;
}

/// ── Transition 5: Blur Dissolve Lines ──
/// Horizontal lines fade in/out with staggered timing.
class _BlurDissolvePainter extends CustomPainter {
  final double progress;
  final Color color;
  _BlurDissolvePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);
    final lineCount = 12;

    for (int i = 0; i < lineCount; i++) {
      final y = (size.height / lineCount) * i + (size.height / lineCount / 2);
      final stagger = (i * 0.06);
      final lineT = ((progress - stagger) * 2.0).clamp(0.0, 1.0);
      final lineWidth = size.width * Curves.easeOutCubic.transform(lineT) * 0.8;
      final x = (size.width - lineWidth) / 2;

      canvas.drawLine(
        Offset(x, y),
        Offset(x + lineWidth, y),
        Paint()
          ..color = color.withValues(alpha: 0.15 * bellT * (1 - lineT * 0.5))
          ..strokeWidth = 1.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BlurDissolvePainter old) => old.progress != progress;
}

/// ── Transition 6: Curtain Reveal ──
/// Vertical split that opens like curtains.
class _CurtainRevealPainter extends CustomPainter {
  final double progress;
  final Color color;
  _CurtainRevealPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);
    final halfW = size.width / 2;
    final openAmount = halfW * progress;

    // Left curtain edge
    final leftX = halfW - openAmount;
    canvas.drawLine(
      Offset(leftX, 0),
      Offset(leftX, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.4 * bellT)
        ..strokeWidth = 2.0,
    );

    // Right curtain edge
    final rightX = halfW + openAmount;
    canvas.drawLine(
      Offset(rightX, 0),
      Offset(rightX, size.height),
      Paint()
        ..color = color.withValues(alpha: 0.4 * bellT)
        ..strokeWidth = 2.0,
    );

    // Center glow
    if (bellT > 0.1) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: 0.1 * bellT),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCenter(center: size.center(Offset.zero), width: openAmount * 2, height: size.height),
        );
      canvas.drawRect(
        Rect.fromLTWH(leftX, 0, rightX - leftX, size.height),
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CurtainRevealPainter old) => old.progress != progress;
}

/// ── Transition 7: Parallax Lines ──
/// Multiple layers of horizontal lines move at different speeds.
class _ParallaxLinesPainter extends CustomPainter {
  final double progress;
  final Color color;
  _ParallaxLinesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);

    for (int layer = 0; layer < 4; layer++) {
      final speed = (layer + 1) * 0.5;
      final offset = progress * size.width * speed * 0.3;
      final opacity = (0.1 - layer * 0.02) * bellT;

      if (opacity > 0.005) {
        for (int i = 0; i < 8; i++) {
          final y = (size.height / 8) * i + 20.0 * layer;
          canvas.drawLine(
            Offset(-size.width + offset + (layer * 30), y),
            Offset(offset + (layer * 30), y),
            Paint()
              ..color = color.withValues(alpha: opacity)
              ..strokeWidth = 0.8,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ParallaxLinesPainter old) => old.progress != progress;
}

/// ── Transition 8: Gravity Settle ──
/// Particles drift downward and settle.
class _GravitySettlePainter extends CustomPainter {
  final double progress;
  final Color color;
  _GravitySettlePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final bellT = _bellCurve(progress);
    final random = math.Random(99);

    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height * 0.5;
      final gravity = progress * progress; // quadratic for gravity feel
      final y = baseY + gravity * size.height * 0.6;

      canvas.drawCircle(
        Offset(x, y),
        1.5 + random.nextDouble() * 2,
        Paint()..color = color.withValues(alpha: 0.2 * bellT * (1 - progress)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GravitySettlePainter old) => old.progress != progress;
}

/// Bell curve opacity: peaks in the middle of the transition, fades at edges.
double _bellCurve(double t) {
  return math.sin(t * math.pi).clamp(0.0, 1.0);
}
