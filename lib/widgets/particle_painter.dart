import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ParticlePainter extends CustomPainter {
  final double animValue;
  final Color color;
  final int count;
  final List<_Particle> _particles;

  ParticlePainter({
    required this.animValue,
    this.color = AppColors.accent2,
    this.count = 50,
  }) : _particles = _generateParticles(count);

  static List<_Particle> _generateParticles(int count) {
    final rng = Random(42);
    return List.generate(count, (_) {
      return _Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: rng.nextDouble() * 2.5 + 0.5,
        speed: rng.nextDouble() * 0.3 + 0.1,
        phase: rng.nextDouble() * pi * 2,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final dx = p.x * size.width;
      final dy = ((p.y + animValue * p.speed) % 1.0) * size.height;
      final opacity = (0.15 + 0.25 * sin(animValue * pi * 2 + p.phase)).clamp(0.0, 1.0);
      final paint = Paint()..color = color.withValues(alpha: opacity);
      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.animValue != animValue;
}

class _Particle {
  final double x, y, radius, speed, phase;
  const _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final Color color;
  final int particleCount;

  const ParticleBackground({
    super.key,
    required this.child,
    this.color = AppColors.accent2,
    this.particleCount = 50,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => CustomPaint(
              painter: ParticlePainter(
                animValue: _ctrl.value,
                color: widget.color,
                count: widget.particleCount,
              ),
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
