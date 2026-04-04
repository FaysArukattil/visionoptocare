import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

class PhilosophySection extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;
  const PhilosophySection({super.key, this.isActive = false, this.scrollProgress});

  @override
  State<PhilosophySection> createState() => _PhilosophySectionState();
}

class _PhilosophySectionState extends State<PhilosophySection>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 12))..repeat(reverse: true);
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollProgress == null) return const SizedBox.shrink();
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollProgress!,
      builder: (context, raw, _) {
        final tEntry = (raw - 5.0).clamp(0.0, 1.0);
        final tExit = (raw - 6.0).clamp(0.0, 1.0);
        final overallOpacity = (Curves.easeOut.transform(tEntry) * (1.0 - tExit)).clamp(0.0, 1.0);

        return Opacity(
          opacity: overallOpacity,
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
                // Main content — properly constrained
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMob ? 90 : 110,
                      bottom: isMob ? 16 : 32,
                    ),
                    child: RepaintBoundary(
                      child: Column(
                        children: [
                          // Header with float animation
                          Opacity(
                            opacity: (tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit),
                            child: Padding(
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
                                    const SizedBox(height: 16),
                                    Text(
                                      'The Vision Behind\nVision Optocare',
                                      style: AppFonts.h2.copyWith(
                                        color: AppColors.white,
                                        fontSize: isMob ? 28 : 48,
                                        height: 1.1,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: isMob ? 20 : 36),
                          // Cards — fully flexible
                          Expanded(
                            child: RepaintBoundary(
                              child: Padding(
                                padding: Responsive.padding(context),
                                child: isMob
                                    ? _buildMobileLayout(tEntry, tExit)
                                    : _buildDesktopLayout(tEntry, tExit),
                              ),
                            ),
                          ),
                          SizedBox(height: isMob ? 12 : 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(double tEntry, double tExit) {
    // Symmetrical glides
    final entryLX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * -500;
    final exitLX = Curves.easeInCubic.transform(tExit) * -500;

    final entryRX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * 500;
    final exitRX = Curves.easeInCubic.transform(tExit) * 500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.translate(
              offset: Offset(entryLX + exitLX, 0),
              child: _AnimatedCard(
                progress: tEntry,
                exitProgress: tExit,
                floatCtrl: _floatCtrl,
                pulseCtrl: _pulseCtrl,
                step: _steps[0],
                index: 0,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.translate(
              offset: Offset(0, 50 * (1.0 - Curves.easeOutCubic.transform(tEntry)) + 50 * Curves.easeInCubic.transform(tExit)),
              child: _AnimatedCard(
                progress: tEntry,
                exitProgress: tExit,
                floatCtrl: _floatCtrl,
                pulseCtrl: _pulseCtrl,
                step: _steps[1],
                index: 1,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.translate(
              offset: Offset(entryRX + exitRX, 0),
              child: _AnimatedCard(
                progress: tEntry,
                exitProgress: tExit,
                floatCtrl: _floatCtrl,
                pulseCtrl: _pulseCtrl,
                step: _steps[2],
                index: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(double tEntry, double tExit) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _steps.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AnimatedCard(
            progress: tEntry,
            exitProgress: tExit,
            floatCtrl: _floatCtrl,
            pulseCtrl: _pulseCtrl,
            step: _steps[i],
            index: i,
          ),
        );
      },
    );
  }

  static final _steps = [
    _Step('01', 'Our Vision',
        'A world where clinical-grade optometry is accessible to everyone through mobile technology.',
        Icons.visibility, AppColors.accent2),
    _Step('02', 'Our Mission',
        'To decentralize global eye care by delivering AI-driven diagnostics directly to your smartphone.',
        Icons.rocket_launch, const Color(0xFF00D4C8)),
    _Step('03', 'Our Innovation',
        'Fusing medical science with digital convenience — AI precision, hybrid care, and therapy in one platform.',
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
  final double progress;
  final double exitProgress;
  final AnimationController floatCtrl;
  final AnimationController pulseCtrl;
  final _Step step;
  final int index;

  const _AnimatedCard({
    required this.progress,
    required this.exitProgress,
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
    final enter = Curves.easeOutBack.transform(widget.progress);

    return Opacity(
      opacity: (enter * (1.0 - widget.exitProgress)).clamp(0.0, 1.0),
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: Listenable.merge([widget.floatCtrl, widget.pulseCtrl]),
          builder: (context, child) {
            final floatPhase = widget.index * 0.8;
            final floatY = math.sin((widget.floatCtrl.value * math.pi * 2) + floatPhase) * 0.4;
            return Transform.translate(
              offset: Offset(0, floatY),
              child: child,
            );
          },
          child: _buildCardBody(),
        ),
      ),
    );
  }

  Widget _buildCardBody() {
    final isMob = Responsive.isMobile(context);
    return MouseRegion(
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
              padding: EdgeInsets.all(isMob ? 16 : 28),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.05 + 0.03 * v),
                borderRadius: BorderRadius.circular(32),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.step.number,
                        style: AppFonts.h1.copyWith(
                          color: widget.step.color
                              .withValues(alpha: 0.15 + v * 0.1),
                          fontSize: isMob ? 40 : 56,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: widget.pulseCtrl,
                        builder: (context, child) {
                          final iconScale = 1.0 + math.sin((widget.pulseCtrl.value * math.pi * 2) + widget.index) * 0.015;
                          return Transform.scale(
                            scale: iconScale,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(isMob ? 8 : 12),
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
                              color: widget.step.color, size: isMob ? 22 : 28),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isMob ? 12 : 20),
                  Text(
                    widget.step.title,
                    style: AppFonts.h3.copyWith(
                      color: AppColors.white,
                      fontSize: isMob ? 22 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isMob ? 8 : 12),
                  Text(
                    widget.step.subtitle,
                    style: AppFonts.bodyLarge.copyWith(
                      color: AppColors.muted,
                      fontSize: isMob ? 13 : 15,
                      height: 1.6,
                    ),
                    maxLines: isMob ? 3 : 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Ambient glow painter
class _AmbientGlowPainter extends CustomPainter {
  final double pulse;
  _AmbientGlowPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
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
