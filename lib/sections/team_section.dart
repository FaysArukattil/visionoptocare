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
      spacing: 40,
      runSpacing: 40,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.2,
            name: 'Sherly Mary Daniel',
            role: 'CHIEF TECHNOLOGY OFFICER',
            imagePath: 'assets/images/Team_members/Cto.jpeg',
            credential: 'B.Tech ECE',
            experience: '9+ Years IT Expertise',
            tagline: 'Scalable Software Ops.',
            accent: const Color(0xFF9D4EDD),
            alignment: Alignment.topCenter,
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.4,
            name: 'Fays Arukattil',
            role: 'SOFTWARE DEVELOPER',
            imagePath: 'assets/images/Team_members/Software_Dev.jpeg',
            credential: 'Full-Stack Architect',
            experience: 'Product · R&D',
            tagline: 'Architecting the Visiaxx core.',
            accent: const Color(0xFFF5C842),
            isReverse: true,
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.2,
            name: 'Sherly Mary Daniel',
            role: 'CHIEF TECHNOLOGY OFFICER',
            imagePath: 'assets/images/Team_members/Cto.jpeg',
            credential: 'B.Tech ECE',
            experience: '9+ Years IT Expertise',
            tagline: 'Scalable Software Ops.',
            accent: const Color(0xFF9D4EDD),
            isMobile: true,
            alignment: Alignment.topCenter,
          ),
          const SizedBox(height: 40),
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.4,
            name: 'Fays Arukattil',
            role: 'SOFTWARE DEVELOPER',
            imagePath: 'assets/images/Team_members/Software_Dev.jpeg',
            credential: 'Full-Stack Architect',
            experience: 'Product · R&D',
            tagline: 'Architecting the Visiaxx core.',
            accent: const Color(0xFFF5C842),
            isMobile: true,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }
}

class _CinematicProfile extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final String name, role, imagePath, credential, experience, tagline;
  final Color accent;
  final bool isReverse, isMobile;
  final AlignmentGeometry alignment;

  const _CinematicProfile({
    required this.ctrl,
    required this.delay,
    required this.name,
    required this.role,
    required this.imagePath,
    required this.credential,
    required this.experience,
    required this.tagline,
    required this.accent,
    this.isReverse = false,
    this.isMobile = false,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) return _buildMobileCard(context);

    return _FadeSlide(
      ctrl: ctrl,
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isReverse) _buildImage(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment:
                        isReverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      _TitleChip(role: role, accent: accent),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: AppFonts.h3.copyWith(
                          color: AppColors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                        textAlign: isReverse ? TextAlign.right : TextAlign.left,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$credential  ·  $experience',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: isReverse ? TextAlign.right : TextAlign.left,
                      ),
                      const Spacer(),
                      Container(
                        width: 24,
                        height: 2,
                        color: accent.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tagline,
                        style: AppFonts.bodyLarge.copyWith(
                          color: AppColors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          height: 1.5,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: isReverse ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              if (isReverse) _buildImage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 180,
      height: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 30,
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              alignment: alignment,
            ),
            // Accent gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    accent.withValues(alpha: 0.2),
                    AppColors.background.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileCard(BuildContext context) {
    return _FadeSlide(
      ctrl: ctrl,
      delay: delay,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.15),
                    blurRadius: 30,
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 0.85,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    alignment: alignment,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _TitleChip(role: role, accent: accent),
            const SizedBox(height: 12),
            Text(
              name,
              style: AppFonts.h4.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              '$credential  ·  $experience',
              style: AppFonts.caption.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tagline,
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleChip extends StatelessWidget {
  final String role;
  final Color accent;
  const _TitleChip({required this.role, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        role,
        style: AppFonts.caption.copyWith(
          color: accent,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontSize: 8,
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

class _FadeSlide extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final Widget child;

  const _FadeSlide(
      {required this.ctrl, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(
      parent: ctrl,
      curve: Interval(delay, (delay + 0.5).clamp(0, 1), curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }
}
