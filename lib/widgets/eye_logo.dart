import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EyeLogo extends StatefulWidget {
  final double size;
  final bool showGlow;
  const EyeLogo({super.key, this.size = 36, this.showGlow = true});

  @override
  State<EyeLogo> createState() => _EyeLogoState();
}

class _EyeLogoState extends State<EyeLogo> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final glowVal = _ctrl.value;
          final scale = 1.0 + (0.2 * glowVal); // 1.2x Zoom on hover
          
          return SizedBox(
            height: widget.size,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // ── High-End Bloom Shadow (Explore Style) ──
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: widget.size * 1.5,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.size),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent2.withValues(
                          alpha: widget.showGlow ? (0.25 * glowVal) : 0, // High-impact bloom
                        ),
                        blurRadius: widget.showGlow ? (40 * glowVal) : 0,
                        spreadRadius: widget.showGlow ? (2 * glowVal) : 0,
                      ),
                      BoxShadow(
                        color: AppColors.accent1.withValues(
                          alpha: widget.showGlow ? (0.15 * glowVal) : 0,
                        ),
                        blurRadius: widget.showGlow ? (60 * glowVal) : 0,
                        spreadRadius: widget.showGlow ? (-5 * glowVal) : 0,
                      ),
                    ],
                  ),
                ),

                // ── Subtle Glass Border Glow (Explore Style) ──
                if (glowVal > 0.01)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Color.lerp(
                            Colors.transparent,
                            AppColors.accent2.withValues(alpha: 0.2),
                            glowVal,
                          )!,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                // ── Authoritative Logo Image with Zoom & Parallax ──
                Center(
                  child: Transform.scale(
                    scale: scale,
                    child: Image.asset(
                      'lib/assets/images/app_logo.png',
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      errorBuilder: (context, error, stackTrace) => CustomPaint(
                        size: Size(widget.size * 2.8, widget.size),
                        painter: _EyePainter(
                          pupilDilation: glowVal,
                          parallaxOffset: 3.0 * glowVal, // Internal depth shift
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EyePainter extends CustomPainter {
  final double pupilDilation;
  final double parallaxOffset;
  _EyePainter({required this.pupilDilation, required this.parallaxOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;
    
    // Parallax Shift Offset
    final shift = Offset(parallaxOffset, parallaxOffset * 0.5);

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.accent2.withValues(alpha: 0.3), Colors.transparent],
      ).createShader(Rect.fromCircle(center: center, radius: width / 2))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, width / 2, glowPaint);

    // Eye outline path (almond shape)
    final path = Path();
    path.moveTo(center.dx - width * 0.48, center.dy);
    path.quadraticBezierTo(
      center.dx,
      center.dy - height * 0.45,
      center.dx + width * 0.48,
      center.dy,
    );
    path.quadraticBezierTo(
      center.dx,
      center.dy + height * 0.45,
      center.dx - width * 0.48,
      center.dy,
    );
    path.close();

    // Sclera (White part) with a subtle gradient
    final scleraPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.white, const Color(0xFFE0E0E0)],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    canvas.drawPath(path, scleraPaint);

    // Iris (Glowy, futuristic) - Affected by Parallax
    final irisCenter = center + shift;
    final irisRadius = height * 0.32;
    final irisPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [AppColors.accent2, AppColors.accent1, const Color(0xFF0D1425)],
        stops: const [0.2, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: irisCenter, radius: irisRadius));
    canvas.drawCircle(irisCenter, irisRadius, irisPaint);

    // Pupil (Responsive dilation) - Affected by more Parallax
    final pupilCenter = center + shift * 1.5;
    final pupilRadius = irisRadius * (0.35 + 0.15 * pupilDilation);
    canvas.drawCircle(
      pupilCenter,
      pupilRadius,
      Paint()..color = const Color(0xFF000510),
    );

    // Futuristic lens reflection (Glass effect)
    final reflectionPath = Path();
    reflectionPath.moveTo(center.dx - width * 0.25, center.dy - height * 0.15);
    reflectionPath.quadraticBezierTo(
      center.dx - width * 0.1,
      center.dy - height * 0.25,
      center.dx + width * 0.05,
      center.dy - height * 0.1,
    );

    final reflectionPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(reflectionPath, reflectionPaint);

    // Bright glint
    final glintOffset = Offset(
      center.dx - irisRadius * 0.3,
      center.dy - irisRadius * 0.3,
    );
    canvas.drawCircle(
      glintOffset,
      irisRadius * 0.1,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );

    // Outer lens shine (Top arc)
    final topArcPath = Path();
    topArcPath.addArc(
      Rect.fromCircle(center: center, radius: irisRadius * 0.9),
      -pi * 0.8,
      pi * 0.6,
    );
    canvas.drawPath(
      topArcPath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_EyePainter old) => 
    old.pupilDilation != pupilDilation || 
    old.parallaxOffset != parallaxOffset;
}
