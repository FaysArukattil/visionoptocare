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
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
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
    if (mounted) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic).value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - t)),
            child: Container(
              width: size.width,
              height: size.height,
              color: AppColors.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isMob ? 80 : 90),
                  // Header
                  Padding(
                    padding: Responsive.padding(context),
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
                  const SizedBox(height: 48),
                  // Cards
                  Flexible(
                    child: Padding(
                      padding: Responsive.padding(context),
                      child: isMob
                          ? _buildMobileLayout()
                          : _buildDesktopLayout(),
                    ),
                  ),
                  SizedBox(height: isMob ? 20 : 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _steps.map((s) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _PhilosophyCard(step: s),
        ),
      )).toList(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: _steps.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PhilosophyCard(step: s),
        )).toList(),
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

class _PhilosophyCard extends StatefulWidget {
  final _Step step;
  const _PhilosophyCard({required this.step});
  @override
  State<_PhilosophyCard> createState() => _PhilosophyCardState();
}

class _PhilosophyCardState extends State<_PhilosophyCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
        builder: (context, v, _) => Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.05),
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
                color: widget.step.color.withValues(alpha: 0.08 * v),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.step.number,
                    style: AppFonts.h1.copyWith(
                      color: widget.step.color.withValues(alpha: 0.15 + v * 0.1),
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -2,
                    ),
                  ),
                  Icon(widget.step.icon, color: widget.step.color, size: 36),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                widget.step.title,
                style: AppFonts.h4.copyWith(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.step.subtitle,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
