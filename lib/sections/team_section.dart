import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 8: The Team — Founding Engineer and technical leadership.
class TeamSection extends StatefulWidget {
  final bool isActive;
  const TeamSection({super.key, this.isActive = false});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant TeamSection old) {
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

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.background,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: isMob ? 90 : 120),
            Padding(
              padding: Responsive.padding(context),
              child: _SlideHeader(
                ctrl: _ctrl,
                child: Column(
                  children: [
                     Text(
                      'ENGINEERING EXCELLENCE',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.accent2,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The Minds Behind\nthe Platform',
                      style: AppFonts.h2.copyWith(
                        color: AppColors.white,
                        fontSize: isMob ? 32 : 56,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isMob ? 40 : 80),
            Padding(
              padding: Responsive.padding(context),
              child: isMob ? _buildMobile() : _buildDesktop(),
            ),
            SizedBox(height: isMob ? 40 : 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 60,
      runSpacing: 40,
      children: [
        _EngineeringProfile(
          ctrl: _ctrl,
          delay: 0.2,
          name: 'Sherly Mary Daniel',
          role: 'CHIEF TECHNOLOGY OFFICER',
          imagePath: 'assets/images/Team_members/Cto.jpeg',
          bio: 'Overseeing technical strategy and scalable operations.',
          accent: const Color(0xFF9D4EDD),
        ),
        _EngineeringProfile(
          ctrl: _ctrl,
          delay: 0.4,
          name: 'Fays Arukattil',
          role: 'FOUNDING ENGINEER',
          imagePath: 'assets/images/Team_members/Lead_Dev.jpeg',
          bio: 'Architecting the Visiaxx ecosystem with Flutter and R&D.',
          accent: const Color(0xFFF5C842),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _EngineeringProfile(
            ctrl: _ctrl,
            delay: 0.2,
            name: 'Sherly Mary Daniel',
            role: 'CHIEF TECHNOLOGY OFFICER',
            imagePath: 'assets/images/Team_members/Cto.jpeg',
            bio: 'Technical Strategy',
            accent: const Color(0xFF9D4EDD),
            isMobile: true,
          ),
          const SizedBox(height: 40),
          _EngineeringProfile(
            ctrl: _ctrl,
            delay: 0.4,
            name: 'Fays Arukattil',
            role: 'FOUNDING ENGINEER',
            imagePath: 'assets/images/Team_members/Lead_Dev.jpeg',
            bio: 'Flutter Architecture',
            accent: const Color(0xFFF5C842),
            isMobile: true,
          ),
        ],
      ),
    );
  }
}

class _EngineeringProfile extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final String name, role, imagePath, bio;
  final Color accent;
  final bool isMobile;

  const _EngineeringProfile({
    required this.ctrl,
    required this.delay,
    required this.name,
    required this.role,
    required this.imagePath,
    required this.bio,
    required this.accent,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(
      parent: ctrl,
      curve: Interval(delay, (delay + 0.5).clamp(0, 1), curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - anim.value)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? 300 : 340,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Minimal Technical Avatar
                Container(
                  width: isMobile ? 180 : 240,
                  height: isMobile ? 180 : 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                        // Technical ring
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: accent.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Text
                Text(
                  role,
                  style: AppFonts.caption.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: AppFonts.h4.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 22 : 26,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  bio,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.muted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Technology Tag (for Fays)
                if (name.contains('Fays'))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: accent.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      'FLUTTER · PRODUCT ARCHITECTURE',
                      style: AppFonts.caption.copyWith(
                        color: accent,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SlideHeader extends StatelessWidget {
  final AnimationController ctrl;
  final Widget child;
  const _SlideHeader({required this.ctrl, required this.child});

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: ctrl, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, -20 * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }
}
