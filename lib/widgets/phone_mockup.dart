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
            width: width + 20,
            height: height + 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(52),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 80,
                  spreadRadius: -10,
                  offset: const Offset(0, 40),
                ),
                BoxShadow(
                  color: const Color(0xFF00D4C8).withValues(alpha: 0.06),
                  blurRadius: 120,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // ── Right Side: Power Button ──
          Positioned(
            right: -6,
            top: height * 0.28,
            child: _SideButton(width: 5, height: 74, color: const Color(0xFFC8C8D0)),
          ),

          // ── Left Side: Action Button + Volume Up + Volume Down ──
          Positioned(
            left: -6,
            top: height * 0.18,
            child: Column(
              children: [
                _SideButton(width: 5, height: 26, color: const Color(0xFFC8C8D0)), // Action
                const SizedBox(height: 12),
                _SideButton(width: 5, height: 50, color: const Color(0xFFC8C8D0)), // Vol Up
                const SizedBox(height: 10),
                _SideButton(width: 5, height: 50, color: const Color(0xFFC8C8D0)), // Vol Down
              ],
            ),
          ),

          // ── Main Body (Chassis with Wrap-around Frame) ──
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(52),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE2E2E2), // Top edge highlight
                  Color(0xFF242426), // Main dark frame
                  Color(0xFF1C1C1E),
                ],
                stops: [0.0, 0.05, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 1,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4), // Thickness of the metal frame
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                color: Colors.black,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 0.5,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(46),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(46),
                  child: Stack(
                    children: [
                      // ── Screen Background ──
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF0A0F1E), Color(0xFF111830)],
                            ),
                          ),
                          child: screen,
                        ),
                      ),

                      // ── Dynamic Island (top center notch) ──
                      Positioned(
                        top: 14,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 120,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Camera dot
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.1),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // FaceID sensor
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2C2C2E),
                                    shape: BoxShape.circle,
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
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 90,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
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

          // ── Camera Module (back, partially visible at angle) ──
          // Simulated by a subtle gradient in the top corner
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: width * 0.5,
              height: height * 0.15,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(48),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
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
// Side Button (Power / Volume)
// ─────────────────────────────────────────────
class _SideButton extends StatelessWidget {
  final double width, height;
  final Color color;

  const _SideButton({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(width / 2),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withValues(alpha: 0.8),
            color,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 2,
            offset: const Offset(0.5, 0),
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


