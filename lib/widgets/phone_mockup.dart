import 'package:flutter/material.dart';

/// A hyper-realistic 3D iPhone mockup with:
/// - Titanium/aluminum side chassis with volume + power buttons
/// - Dynamic Island at top
/// - Action button on left
/// - SIM tray on right
/// - Glass screen with reflection sweep
/// - 3D perspective tilt via Matrix4
class PhoneMockup extends StatelessWidget {
  final Widget screen;
  final double width;
  final double height;
  /// Tilt angle in radians. Default: slight perspective tilt.
  final double tiltX;
  final double tiltY;

  const PhoneMockup({
    super.key,
    required this.screen,
    this.width = 300,
    this.height = 580,
    this.tiltX = -0.08,
    this.tiltY = 0.12,
  });

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(56),
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
              borderRadius: BorderRadius.circular(52),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 0.5,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEFEFF2), // Top edge highly polished highlight
                  Color(0xFFB0B0BB), // Subtle titanium reflection
                  Color(0xFF8A8A96), // Main titanium body
                  Color(0xFFDEDEE2), // Bottom edge reflection
                  Color(0xFF5A5A66), // Deep corner shadow
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
            padding: const EdgeInsets.all(2.0), // Ultra-thin 2px metal edge
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
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
                padding: const EdgeInsets.all(1.5), // Inner uniform bezel
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(48),
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
                            borderRadius: BorderRadius.circular(48),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),

                      // ── Dynamic Island ──
                      Positioned(
                        top: 14,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 105,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 50),
                                // TrueDepth Camera Lens
                                Container(
                                  width: 12,
                                  height: 12,
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
                                      width: 4,
                                      height: 4,
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

                      // ── Home Indicator Bar ──
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 4.5,
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


