import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EyeLogo extends StatefulWidget {
  final double size;
  const EyeLogo({super.key, this.size = 36});

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
          final scale = 1.0 + (0.5 * _ctrl.value); // 1.5x dramatic hover burst
          return SizedBox(
            height: widget.size,
            child: Stack(
              clipBehavior: Clip.none, // Allow scale to "stretch" out slightly if needed
              children: [
                // Logo Image
                Center(
                  child: Transform.scale(
                    scale: scale,
                    child: Image.asset(
                      'lib/assets/images/app_logo.png',
                      fit: BoxFit.contain, // Protects brand aspect ratio
                      filterQuality: FilterQuality.high,
                      isAntiAlias: true,
                      errorBuilder: (context, error, stackTrace) => CustomPaint(
                        size: Size(widget.size * 2.8, widget.size),
                        painter: _EyePainter(pupilDilation: _ctrl.value),
                      ),
                    ),
                  ),
                ),
                
                // Subtle Shimmer overlay on hover
                if (_ctrl.value > 0.01)
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.25 * _ctrl.value, // Intensified glow
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.5), // Brighter
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            transform: GradientRotation(_ctrl.value * pi),
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
  _EyePainter({required this.pupilDilation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

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

    // Iris (Glowy, futuristic)
    final irisRadius = height * 0.32;
    final irisPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [AppColors.accent2, AppColors.accent1, const Color(0xFF0D1425)],
        stops: const [0.2, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: irisRadius));
    canvas.drawCircle(center, irisRadius, irisPaint);

    // Pupil (Responsive dilation)
    final pupilRadius = irisRadius * (0.35 + 0.15 * pupilDilation);
    canvas.drawCircle(
      center,
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
  bool shouldRepaint(_EyePainter old) => old.pupilDilation != pupilDilation;
}
