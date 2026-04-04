import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ── Cinematic Section Transition Overlay ──
/// A single, clean, premium crossfade vignette that plays between
/// any two page indices during scroll. Creates a subtle "blink"
/// effect — a dark radial gradient that pulses briefly at ~50%
/// scroll between pages. GPU-friendly single-painter approach.
class SectionTransitionOverlay extends StatelessWidget {
  final double scrollProgress; // raw scroll position in pages
  final int totalPages;

  const SectionTransitionOverlay({
    super.key,
    required this.scrollProgress,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final fromPage = scrollProgress.floor();
    final t = scrollProgress - fromPage; // 0.0 → 1.0 between pages

    // Only render when actually transitioning between pages
    if (t < 0.02 || t > 0.98) return const SizedBox.shrink();
    if (fromPage < 1 || fromPage >= totalPages - 1) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: _CinematicVignettePainter(progress: t),
          ),
        ),
      ),
    );
  }
}

/// A dark radial vignette that peaks at the midpoint of the transition,
/// creating a subtle cinematic "blink" between sections.
class _CinematicVignettePainter extends CustomPainter {
  final double progress;
  _CinematicVignettePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Bell curve: peaks at t=0.5, zero at t=0 and t=1
    final intensity = math.sin(progress * math.pi).clamp(0.0, 1.0);

    // Only paint when visible enough to notice
    if (intensity < 0.01) return;

    final center = size.center(Offset.zero);
    final maxRadius = size.longestSide * 0.9;

    // ── Layer 1: Full-screen dark vignette (the "blink") ──
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.05 * intensity),
          Colors.black.withValues(alpha: 0.25 * intensity),
          Colors.black.withValues(alpha: 0.50 * intensity),
        ],
        stops: const [0.0, 0.35, 0.7, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxRadius),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      vignettePaint,
    );

    // ── Layer 2: Thin horizontal divider line (subtle) ──
    final lineY = size.height * (1.0 - progress);
    final lineOpacity = (intensity * 0.15).clamp(0.0, 0.15);
    final linePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: lineOpacity),
          Colors.white.withValues(alpha: lineOpacity * 0.6),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(
        Rect.fromLTWH(0, lineY - 0.5, size.width, 1.0),
      );
    canvas.drawRect(
      Rect.fromLTWH(0, lineY - 0.5, size.width, 1.0),
      linePaint,
    );

    // ── Layer 3: Corner accent dots (cinematic framing) ──
    if (intensity > 0.3) {
      final dotAlpha = ((intensity - 0.3) * 0.2).clamp(0.0, 0.12);
      final dotPaint = Paint()
        ..color = const Color(0xFF00D4C8).withValues(alpha: dotAlpha)
        ..style = PaintingStyle.fill;

      final margin = 40.0;
      final dotR = 2.0;

      // Four corner dots
      canvas.drawCircle(Offset(margin, margin), dotR, dotPaint);
      canvas.drawCircle(Offset(size.width - margin, margin), dotR, dotPaint);
      canvas.drawCircle(
          Offset(margin, size.height - margin), dotR, dotPaint);
      canvas.drawCircle(
          Offset(size.width - margin, size.height - margin), dotR, dotPaint);

      // Corner bracket lines
      final bracketLen = 16.0;
      final bracketPaint = Paint()
        ..color = const Color(0xFF00D4C8).withValues(alpha: dotAlpha * 0.7)
        ..strokeWidth = 0.8;

      // Top-left
      canvas.drawLine(Offset(margin, margin),
          Offset(margin + bracketLen, margin), bracketPaint);
      canvas.drawLine(Offset(margin, margin),
          Offset(margin, margin + bracketLen), bracketPaint);
      // Top-right
      canvas.drawLine(Offset(size.width - margin, margin),
          Offset(size.width - margin - bracketLen, margin), bracketPaint);
      canvas.drawLine(Offset(size.width - margin, margin),
          Offset(size.width - margin, margin + bracketLen), bracketPaint);
      // Bottom-left
      canvas.drawLine(Offset(margin, size.height - margin),
          Offset(margin + bracketLen, size.height - margin), bracketPaint);
      canvas.drawLine(Offset(margin, size.height - margin),
          Offset(margin, size.height - margin - bracketLen), bracketPaint);
      // Bottom-right
      canvas.drawLine(
          Offset(size.width - margin, size.height - margin),
          Offset(size.width - margin - bracketLen, size.height - margin),
          bracketPaint);
      canvas.drawLine(
          Offset(size.width - margin, size.height - margin),
          Offset(size.width - margin, size.height - margin - bracketLen),
          bracketPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CinematicVignettePainter old) =>
      (old.progress - progress).abs() > 0.005;
}
