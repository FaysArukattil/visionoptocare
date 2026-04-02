import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

class FoundersSection extends StatefulWidget {
  final bool isActive;
  const FoundersSection({super.key, this.isActive = false});

  @override
  State<FoundersSection> createState() => _FoundersSectionState();
}

class _FoundersSectionState extends State<FoundersSection>
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
  void didUpdateWidget(covariant FoundersSection old) {
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
            offset: Offset(0, 15 * (1 - t)),
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
                          'THE LEADERSHIP',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.accent2,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Visionaries Behind\nVisiaxx',
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
                      child: isMob ? _buildMobileLayout() : _buildDesktopLayout(isMob),
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

  static final _founders = [
    _FounderData(
      name: 'John Doe',
      role: 'CEO & Founder',
      bio: 'Visionary leader with a decade of expertise in digital health transformation.',
      icon: Icons.person_outline,
    ),
    _FounderData(
      name: 'Jane Smith',
      role: 'CTO & Co-Founder',
      bio: 'Leading a team of world-class engineers to push the boundaries of AI optometry.',
      icon: Icons.code,
    ),
  ];

  Widget _buildDesktopLayout(bool isMob) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 32,
          runSpacing: 32,
          children: _founders.map((f) => SizedBox(
            width: 380,
            child: _FounderCard(founder: f),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        children: _founders.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: _FounderCard(founder: f),
        )).toList(),
      ),
    );
  }
}

class _FounderData {
  final String name, role, bio;
  final IconData icon;
  const _FounderData({
    required this.name,
    required this.role,
    required this.bio,
    required this.icon,
  });
}

class _FounderCard extends StatefulWidget {
  final _FounderData founder;
  const _FounderCard({required this.founder});
  @override
  State<_FounderCard> createState() => _FounderCardState();
}

class _FounderCardState extends State<_FounderCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
        builder: (context, v, _) => Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Color.lerp(
                AppColors.white.withValues(alpha: 0.05),
                AppColors.accent2.withValues(alpha: 0.3),
                v,
              )!,
              width: 1.5,
            ),
            boxShadow: [
              if (_hov)
                BoxShadow(
                  color: AppColors.accent2.withValues(alpha: 0.08),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent2.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.accent2.withValues(alpha: 0.2 + v * 0.2),
                  ),
                ),
                child: Icon(widget.founder.icon, color: AppColors.accent2, size: 44),
              ),
              const SizedBox(height: 28),
              Text(
                widget.founder.name,
                style: AppFonts.h4.copyWith(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.founder.role,
                style: AppFonts.caption.copyWith(
                  color: AppColors.accent2,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.founder.bio,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted,
                  fontSize: 15,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialIcon(icon: Icons.link),
                  const SizedBox(width: 16),
                  _SocialIcon(icon: Icons.alternate_email),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.05),
      ),
      child: Icon(icon, color: AppColors.white.withValues(alpha: 0.4), size: 18),
    );
  }
}
