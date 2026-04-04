import 'package:flutter/material.dart';

/// A hyper-realistic 3D iPhone mockup with:
/// - Titanium/aluminum side chassis with volume + power buttons
/// - Optional Dynamic Island at top
/// - Glass screen with reflection sweep
/// - Optional home indicator bar
/// - 3D perspective tilt via Matrix4
class PhoneMockup extends StatelessWidget {
  final Widget screen;
  final double width;
  final double height;
  /// Tilt angle in radians. Default: slight perspective tilt.
  final double tiltX;
  final double tiltY;
  /// Whether to show the Dynamic Island notch
  final bool showNotch;
  /// Whether to show the home indicator bar
  final bool showHomeBar;

  const PhoneMockup({
    super.key,
    required this.screen,
    this.width = 260,
    this.height = 560,
    this.tiltX = -0.08,
    this.tiltY = 0.12,
    this.showNotch = true,
    this.showHomeBar = true,
  });

  @override
  Widget build(BuildContext context) {
    // Proportional corner radius based on phone size
    final outerR = width * 0.12; // ~12% of width for modern look
    final innerR = outerR - 2.0;
    final screenR = innerR - 1.5;
    // Proportional notch dimensions
    final notchW = width * 0.33;
    final notchH = height * 0.04;
    final notchTop = height * 0.02;
    // Proportional home bar
    final homeBarW = width * 0.35;
    final homeBarH = height * 0.007;
    final homeBarBottom = height * 0.015;
    // Proportional camera lens
    final lensSize = notchH * 0.38;
    final innerLensSize = lensSize * 0.35;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(tiltX)
        ..rotateY(tiltY),
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ── Drop Shadow ──
          Container(
            width: width + 30,
            height: height + 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(outerR + 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.8),
                  blurRadius: 90,
                  spreadRadius: -15,
                  offset: const Offset(0, 45),
                ),
                BoxShadow(
                  color: const Color(0xFF00D4C8).withValues(alpha: 0.08),
                  blurRadius: 100,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
          ),

          // ── Main Body (Chassis with Wrap-around Frame) ──
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(outerR),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 0.5,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFEFF2),
                  Color(0xFFB0B0BB),
                  Color(0xFF8A8A96),
                  Color(0xFFDEDEE2),
                  Color(0xFF5A5A66),
                ],
                stops: [0.0, 0.15, 0.5, 0.85, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.15),
                  blurRadius: 2,
                  offset: const Offset(1.5, 1.5),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 2,
                  offset: const Offset(-1, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(innerR),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 2,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenR),
                  child: Stack(
                    children: [
                      // ── Screen Background ──
                      Positioned.fill(
                        child: screen,
                      ),

                      // ── Screen OLED Edge Glow ──
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(screenR),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),

                      // ── Dynamic Island (conditional) ──
                      if (showNotch)
                        Positioned(
                          top: notchTop,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: notchW,
                              height: notchH,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(notchH / 2),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: notchW * 0.45),
                                  // TrueDepth Camera Lens
                                  Container(
                                    width: lensSize,
                                    height: lensSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.blueGrey.shade900,
                                          Colors.black,
                                        ],
                                        stops: const [0.2, 1.0],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(alpha: 0.05),
                                          blurRadius: 1,
                                          spreadRadius: 0.5,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: innerLensSize,
                                        height: innerLensSize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.blueAccent.withValues(alpha: 0.4),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // ── Glass Screen Reflection ──
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _GlassReflectionPainter(),
                          ),
                        ),
                      ),

                      // ── Home Indicator Bar (conditional) ──
                      if (showHomeBar)
                        Positioned(
                          bottom: homeBarBottom,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              width: homeBarW,
                              height: homeBarH.clamp(2.5, 5.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ─────────────────────────────────────────────
// Glass Reflection Painter
// ─────────────────────────────────────────────
class _GlassReflectionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Diagonal shimmer sweep
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.06),
          Colors.transparent,
          Colors.white.withValues(alpha: 0.02),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Edge specular highlight (top edge of screen glass)
    final edgePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.08),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 2));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 2), edgePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


