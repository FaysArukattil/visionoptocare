import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A signature, themed eye loading animation for Visiaxx.
/// Features a gentle 4s cycle: look-around, smooth iris transitions, 
/// breathing pupil pulse, and occasional blinks.
class EyeLoader extends StatefulWidget {
  final double size;
  final Color? color;        // Iris color (defaults to AppColors.accent2)
  final Color? scleraColor;  // Sclera color (defaults to AppColors.white)
  final Color? pupilColor;   // Pupil color (defaults to black)
  final double? value;       // Manual progress override (0.0 - 1.0)

  const EyeLoader({
    super.key,
    this.size = 40.0,
    this.color,
    this.scleraColor,
    this.pupilColor,
    this.value,
  });

  /// Responsive constructor that scales based on screen size.
  const EyeLoader.adaptive({
    super.key,
    this.size = 40.0,
    this.color,
    this.scleraColor,
    this.pupilColor,
    this.value,
  });

  /// Larger and more visible constructor for buttons.
  const EyeLoader.button({super.key, this.color})
      : size = 28.0,
        scleraColor = null,
        pupilColor = null,
        value = null;

  /// Even larger constructor for full-screen loading states.
  const EyeLoader.fullScreen({super.key, this.color})
      : size = 80.0,
        scleraColor = null,
        pupilColor = null,
        value = null;

  @override
  State<EyeLoader> createState() => _EyeLoaderState();
}

class _EyeLoaderState extends State<EyeLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(EyeLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      _controller.stop();
    } else if (oldWidget.value != null) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Default theme colors from Visiaxx palette
    final themeColor = widget.color ?? AppColors.accent2;
    const fallbackSclera = AppColors.white;
    const fallbackPupil = Color(0xFF000510); // Rich deep black

    // Responsive sizing: Scale up on desktop screens (> 900px)
    final screenWidth = MediaQuery.of(context).size.width;
    double effectiveSize = widget.size;
    if (screenWidth > 900) {
      if (widget.size >= 80) {
        effectiveSize = 160.0;
      } else if (widget.size > 30) {
        effectiveSize = widget.size * 1.8;
      }
    }

    return SizedBox(
      width: effectiveSize,
      height: effectiveSize,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _PremiumEyePainter(
              progress: widget.value ?? _controller.value,
              color: themeColor,
              scleraColor: widget.scleraColor ?? fallbackSclera,
              pupilColor: widget.pupilColor ?? fallbackPupil,
            ),
          );
        },
      ),
    );
  }
}

class _PremiumEyePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color scleraColor;
  final Color pupilColor;

  _PremiumEyePainter({
    required this.progress,
    required this.color,
    required this.scleraColor,
    required this.pupilColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eyeWidth = size.width * 0.95;
    final baseEyeHeight = size.height * 0.52;

    // ── 1. ANIMATION PHASES ──
    // a) Iris movement (look-around)
    double irisXOffset = 0;
    const lookCurve = Curves.easeInOutCubic;
    if (progress < 0.15) {
      irisXOffset = 0;
    } else if (progress < 0.35) {
      double t = lookCurve.transform((progress - 0.15) / 0.2);
      irisXOffset = -t * (eyeWidth * 0.28);
    } else if (progress < 0.65) {
      double t = lookCurve.transform((progress - 0.35) / 0.3);
      irisXOffset = -(eyeWidth * 0.28) + (t * eyeWidth * 0.56);
    } else if (progress < 0.85) {
      double t = lookCurve.transform((progress - 0.65) / 0.2);
      irisXOffset = (eyeWidth * 0.28) - (t * eyeWidth * 0.28);
    }

    // b) Pupil pulse (breathing)
    double pulseScale = 1.0;
    if (progress < 0.15) {
      final t = progress / 0.15;
      pulseScale = 1.8 - (Curves.easeOutExpo.transform(t) * 0.8);
    } else {
      pulseScale = 1.0 + 0.1 * math.sin(progress * 2 * math.pi);
    }

    // c) Periodic blinks
    double blinkFactor = 1.0;
    final blinkMarkers = [0.2, 0.5, 0.8];
    const blinkWindow = 0.07;
    for (final marker in blinkMarkers) {
      if (progress > marker - blinkWindow && progress < marker + blinkWindow) {
        final t = (progress - (marker - blinkWindow)) / (blinkWindow * 2);
        blinkFactor = 1.0 - math.sin(t * math.pi);
        break;
      }
    }

    // ── 2. PAINTING ──
    final currentHeight = baseEyeHeight * blinkFactor;
    final scleraCenter = center + Offset(irisXOffset * 0.15, 0);

    // Eye shape path
    final eyePath = Path();
    eyePath.moveTo(scleraCenter.dx - eyeWidth / 2, scleraCenter.dy);
    eyePath.quadraticBezierTo(
        scleraCenter.dx, scleraCenter.dy - currentHeight,
        scleraCenter.dx + eyeWidth / 2, scleraCenter.dy);
    eyePath.quadraticBezierTo(
        scleraCenter.dx, scleraCenter.dy + currentHeight,
        scleraCenter.dx - eyeWidth / 2, scleraCenter.dy);
    eyePath.close();

    // 2.1 Draw Sclera
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = scleraColor
        ..style = PaintingStyle.fill,
    );

    // 2.2 Draw Subtle Glow/Shadow Stroke
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 2.3 Draw Internal Content (Iris & Pupil)
    if (blinkFactor > 0.05) {
      canvas.save();
      canvas.clipPath(eyePath);

      final irisCenter = center + Offset(irisXOffset, 0);
      final irisRadius = (size.width / 2) * 0.52;

      // Iris with Radial Gradient (for depth)
      final irisPaint = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 1.0), color.withValues(alpha: 0.7)],
        ).createShader(Rect.fromCircle(center: irisCenter, radius: irisRadius));
      canvas.drawCircle(irisCenter, irisRadius, irisPaint);

      // Pupil with responsive dilation
      canvas.drawCircle(
        irisCenter,
        irisRadius * 0.42 * pulseScale,
        Paint()..color = pupilColor,
      );

      // High-quality reflections
      final reflectPaint = Paint()..color = Colors.white.withValues(alpha: 0.45);
      canvas.drawCircle(
        irisCenter + Offset(irisRadius * 0.3, -irisRadius * 0.3),
        irisRadius * 0.16,
        reflectPaint,
      );
      canvas.drawCircle(
        irisCenter + Offset(-irisRadius * 0.2, irisRadius * 0.2),
        irisRadius * 0.08,
        Paint()..color = Colors.white.withValues(alpha: 0.2),
      );

      canvas.restore();
    }

    // 2.4 Eyelashes (detailed when closing)
    if (blinkFactor < 0.4) {
      final lashPaint = Paint()
        ..color = color.withValues(alpha: 0.8 * (1.0 - blinkFactor))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      final lashRect = Rect.fromCenter(
        center: center,
        width: eyeWidth * 0.8,
        height: size.height * 0.08,
      );
      canvas.drawArc(lashRect, 0.1, math.pi - 0.2, false, lashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumEyePainter old) =>
      old.progress != progress || old.color != color;
}
