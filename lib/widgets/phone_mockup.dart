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

          // ── Left Side: Volume Up + Volume Down + Action Button ──
          Positioned(
            left: -6,
            top: height * 0.21,
            child: Column(
              children: [
                // Action button (smaller, rounded)
                _SideButton(width: 4, height: 32, topRadius: 3, bottomRadius: 3),
                const SizedBox(height: 10),
                // Volume Up
                _SideButton(width: 4, height: 44),
                const SizedBox(height: 10),
                // Volume Down
                _SideButton(width: 4, height: 44),
              ],
            ),
          ),

          // ── Right Side: Power Button + SIM Tray ──
          Positioned(
            right: -6,
            top: height * 0.29,
            child: Column(
              children: [
                // Power button (taller)
                _SideButton(width: 4, height: 72),
                const SizedBox(height: 40),
                // SIM tray (thin, with line detail)
                _SimTray(width: 4, height: 28),
              ],
            ),
          ),

          // ── Main Body (Titanium Chassis) ──
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC8C8D0), // Highlight edge
                  Color(0xFF1C1C1E), // Main titanium dark
                  Color(0xFF2C2C2E),
                  Color(0xFF1C1C1E),
                  Color(0xFFB0B0B8), // Highlight opposite edge
                ],
                stops: [0.0, 0.08, 0.5, 0.92, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0), // Thin bezel gap
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.black,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44),
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
  final double width;
  final double height;
  final double topRadius;
  final double bottomRadius;

  const _SideButton({
    required this.width,
    required this.height,
    this.topRadius = 2,
    this.bottomRadius = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius),
          bottom: Radius.circular(bottomRadius),
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF8A8A96),
            Color(0xFFC8C8D0),
            Color(0xFF8A8A96),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            offset: const Offset(-1, 0),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SIM Tray
// ─────────────────────────────────────────────
class _SimTray extends StatelessWidget {
  final double width;
  final double height;

  const _SimTray({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF6A6A76), Color(0xFFB0B0B8), Color(0xFF6A6A76)],
            ),
          ),
        ),
        // Pinhole
        Positioned(
          right: -1,
          child: Container(
            width: 3,
            height: 3,
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1E),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
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


