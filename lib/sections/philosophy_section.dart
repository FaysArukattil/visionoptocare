import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

class PhilosophySection extends StatefulWidget {
  final bool isActive;
  const PhilosophySection({super.key, this.isActive = false});

  @override
  State<PhilosophySection> createState() => _PhilosophySectionState();
}

class _PhilosophySectionState extends State<PhilosophySection>
    with TickerProviderStateMixin {
  late AnimationController _enterCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _pulseCtrl;
  late AnimationController _card1Ctrl;
  late AnimationController _card2Ctrl;
  late AnimationController _card3Ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
    _card1Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _card2Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _card3Ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant PhilosophySection old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_hasStarted) _start();
  }

  void _start() async {
    _hasStarted = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _enterCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _card1Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _card2Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _card3Ctrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    _card1Ctrl.dispose();
    _card2Ctrl.dispose();
    _card3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _enterCtrl,
      builder: (context, _) {
        final t = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic).value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                // Background ambient glow
                Positioned.fill(
                  child: RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (context, _) {
                        final pulse = _pulseCtrl.value;
                        return CustomPaint(
                          painter: _AmbientGlowPainter(pulse: pulse),
                        );
                      },
                    ),
                  ),
                ),
                // Main content
                // Main content
                RepaintBoundary(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isMob ? 100 : 120),
                      // Header with float animation (RepaintBoundary helps here)
                      Padding(
                        padding: Responsive.padding(context),
                        child: AnimatedBuilder(
                          animation: _floatCtrl,
                          builder: (context, child) {
                            final y = math.sin(_floatCtrl.value * math.pi) * 0.4;
                            return Transform.translate(
                              offset: Offset(0, y),
                              child: child,
                            );
                          },
                          child: Column(
                            children: [
                              Text(
                                'OUR PHILOSOPHY',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.accent2,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                                ),
                              const SizedBox(height: 20),
                              Text(
                                'The Vision Behind\nVision Optocare',
                                style: AppFonts.h2.copyWith(
                                  color: AppColors.white,
                                  fontSize: isMob ? 30 : 52,
                                  height: 1.1,
                                  fontWeight: FontWeight.w800,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Cards with staggered animation
                      Flexible(
                        child: RepaintBoundary(
                          child: Padding(
                            padding: Responsive.padding(context),
                            child: isMob
                                ? _buildMobileLayout()
                                : _buildDesktopLayout(),
                          ),
                        ),
                      ),
                      SizedBox(height: isMob ? 20 : 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    final ctrls = [_card1Ctrl, _card2Ctrl, _card3Ctrl];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _steps.asMap().entries.map((entry) {
        final i = entry.key;
        final s = entry.value;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _AnimatedCard(
              ctrl: ctrls[i],
              floatCtrl: _floatCtrl,
              pulseCtrl: _pulseCtrl,
              step: s,
              index: i,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileLayout() {
    final ctrls = [_card1Ctrl, _card2Ctrl, _card3Ctrl];
    return SingleChildScrollView(
      child: Column(
        children: _steps.asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _AnimatedCard(
              ctrl: ctrls[i],
              floatCtrl: _floatCtrl,
              pulseCtrl: _pulseCtrl,
              step: s,
              index: i,
            ),
          );
        }).toList(),
      ),
    );
  }

  static final _steps = [
    _Step('01', 'Our Vision',
        'A world where clinical-grade optometry is not a luxury, but a fundamental right accessible to everyone through mobile technology.',
        Icons.visibility, AppColors.accent2),
    _Step('02', 'Our Mission',
        'To decentralize global eye care by delivering an AI-driven, highly accurate diagnostic ecosystem directly to your smartphone.',
        Icons.rocket_launch, const Color(0xFF00D4C8)),
    _Step('03', 'Our Innovation',
        'Fusing medical science with digital convenience. We integrate AI precision, hybrid care, and therapeutic engagement in one platform.',
        Icons.lightbulb_outline, const Color(0xFFF5C842)),
  ];
}

class _Step {
  final String number, title, subtitle;
  final IconData icon;
  final Color color;
  const _Step(this.number, this.title, this.subtitle, this.icon, this.color);
}

class _AnimatedCard extends StatefulWidget {
  final AnimationController ctrl;
  final AnimationController floatCtrl;
  final AnimationController pulseCtrl;
  final _Step step;
  final int index;

  const _AnimatedCard({
    required this.ctrl,
    required this.floatCtrl,
    required this.pulseCtrl,
    required this.step,
    required this.index,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.ctrl, widget.floatCtrl, widget.pulseCtrl]),
      builder: (context, _) {
        final enter = CurvedAnimation(parent: widget.ctrl, curve: Curves.easeOutBack).value.clamp(0.0, 1.0);
        // Each card floats with a phase offset
        final floatPhase = widget.index * 0.8;
        final floatY = math.sin((widget.floatCtrl.value * math.pi * 2) + floatPhase) * 0.4;
        // Icon pulse
        final iconScale = 1.0 + math.sin((widget.pulseCtrl.value * math.pi * 2) + widget.index) * 0.015;

        return Opacity(
          opacity: enter,
          child: Transform.translate(
            offset: Offset(0, (30 * (1 - enter)) + floatY),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hov = true),
              onExit: (_) => setState(() => _hov = false),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
                builder: (context, v, _) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(-0.02 * v)
                      ..rotateY(0.02 * v),
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 32),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.05 + 0.03 * v),
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(
                          color: Color.lerp(
                            AppColors.white.withValues(alpha: 0.05),
                            widget.step.color.withValues(alpha: 0.4),
                            v,
                          )!,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.step.color.withValues(alpha: 0.08 * v + 0.02),
                            blurRadius: 40 + 20 * v,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.step.number,
                                    style: AppFonts.h1.copyWith(
                                      color: widget.step.color
                                          .withValues(alpha: 0.15 + v * 0.1),
                                      fontSize: 60,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -2,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: iconScale,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.step.color
                                            .withValues(alpha: 0.08 + 0.08 * v),
                                        boxShadow: [
                                          BoxShadow(
                                            color: widget.step.color
                                                .withValues(alpha: 0.2 * v),
                                            blurRadius: 20,
                                            spreadRadius: -5,
                                          ),
                                        ],
                                      ),
                                      child: Icon(widget.step.icon,
                                          color: widget.step.color, size: 28),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                widget.step.title,
                                style: AppFonts.h3.copyWith(
                                  // Increased to h3 for 'Big'
                                  color: AppColors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.step.subtitle,
                                style: AppFonts.bodyLarge.copyWith(
                                  color: AppColors.muted,
                                  fontSize: 16, // Increased to 16 for 'Readable'
                                  height: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// Ambient glow painter for philosophic feeling
class _AmbientGlowPainter extends CustomPainter {
  final double pulse;
  _AmbientGlowPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle orb glows
    final colors = [AppColors.accent2, const Color(0xFF00D4C8), const Color(0xFFF5C842)];
    final positions = [
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.3),
    ];

    for (int i = 0; i < 3; i++) {
      final r = 80.0 + math.sin(pulse * math.pi + i * 1.2) * 30;
      final paint = Paint()
        ..color = colors[i].withValues(alpha: 0.03 + math.sin(pulse * math.pi + i) * 0.01)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 60);
      canvas.drawCircle(positions[i], r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmbientGlowPainter oldDelegate) =>
      (oldDelegate.pulse - pulse).abs() > 0.05;
}

