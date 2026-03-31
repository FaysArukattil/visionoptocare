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
      onEnter: (_) {
        _ctrl.forward();
      },
      onExit: (_) {
        _ctrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            size: Size(widget.size, widget.size * 0.6),
            painter: _EyePainter(
              pupilDilation: _ctrl.value,
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
    final eyeW = size.width * 0.9;
    final eyeH = size.height * 0.8;

    // Eye outline (almond shape)
    final path = Path();
    path.moveTo(center.dx - eyeW / 2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy - eyeH / 1.2, center.dx + eyeW / 2, center.dy);
    path.quadraticBezierTo(center.dx, center.dy + eyeH / 1.2, center.dx - eyeW / 2, center.dy);
    path.close();

    final outlinePaint = Paint()
      ..color = AppColors.accent2
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path, outlinePaint);

    // Iris
    final irisRadius = eyeH * 0.38;
    final irisPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.accent1, AppColors.accent2],
      ).createShader(Rect.fromCircle(center: center, radius: irisRadius));
    canvas.drawCircle(center, irisRadius, irisPaint);

    // Pupil (dilates on hover)
    final pupilRadius = irisRadius * (0.35 + 0.2 * pupilDilation);
    canvas.drawCircle(center, pupilRadius, Paint()..color = const Color(0xFF050A18));

    // Glint
    final glintOffset = Offset(center.dx - irisRadius * 0.25, center.dy - irisRadius * 0.25);
    canvas.drawCircle(glintOffset, irisRadius * 0.12, Paint()..color = Colors.white.withOpacity(0.8));
  }

  @override
  bool shouldRepaint(_EyePainter old) => old.pupilDilation != pupilDilation;
}
