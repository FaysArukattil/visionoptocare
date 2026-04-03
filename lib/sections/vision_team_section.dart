import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 7: Visionary Team — Combined Leadership and Engineering Team.
/// Features a clear visual hierarchy with Large and Small cinematic profiles.
class VisionTeamSection extends StatefulWidget {
  final bool isActive;
  const VisionTeamSection({super.key, this.isActive = false});

  @override
  State<VisionTeamSection> createState() => _VisionTeamSectionState();
}

class _VisionTeamSectionState extends State<VisionTeamSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant VisionTeamSection old) {
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
      child: Stack(
        children: [
          // ── Background Grid ──
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: CustomPaint(painter: _ArchitecturalGridPainter()),
            ),
          ),

          // ── Scrollable Content ──
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: isMob ? 80 : 110),
                
                // ── 1. The Leadership (Large) ──
                _buildHeader('THE LEADERSHIP', 'Visionaries Behind the Care', isMob),
                SizedBox(height: isMob ? 40 : 60),
                Center(child: _buildLeadershipRow(isMob)),
                
                SizedBox(height: isMob ? 80 : 120),
                
                // ── 2. The Engineering Team (Small) ──
                _buildHeader('FOUNDING TEAM', 'Engineering the Future', isMob),
                SizedBox(height: isMob ? 40 : 60),
                Center(child: _buildEngineeringRow(isMob)),

                SizedBox(height: isMob ? 100 : 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String caption, String title, bool isMob) {
    return _FadeIn(
      ctrl: _ctrl,
      delay: 0.1,
      child: Column(
        children: [
          Text(
            caption,
            style: AppFonts.caption.copyWith(
              color: AppColors.accent2,
              letterSpacing: 6,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppFonts.h2.copyWith(
              color: AppColors.white,
              fontSize: isMob ? 28 : 48,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            width: 50,
            height: 2,
            color: AppColors.accent2.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildLeadershipRow(bool isMob) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 40,
        runSpacing: 40,
        alignment: WrapAlignment.center,
        children: [
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.2,
            name: 'Aben Thomas Angadiyil',
            role: 'CHIEF EXECUTIVE OFFICER',
            imagePath: 'assets/images/Founders/Founder_1.jpeg',
            credential: 'B.Optom · BMS',
            experience: '14+ Years in Vision Care',
            bio: 'Driving global healthcare innovation and the product mission.',
            accent: AppColors.accent2,
            sizeScale: 1.3, // Size boost
          ),
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.3,
            name: 'Thomas Angadiyil Philip',
            role: 'CO-FOUNDER & DIRECTOR',
            imagePath: 'assets/images/Founders/Founder_2.jpeg',
            credential: 'Rajan Optics',
            experience: '44+ Years Optical Expertise',
            bio: 'Legacy of trust and diagnostic precision at Rajan Optics.',
            accent: const Color(0xFF4F6AFF),
            sizeScale: 1.3, // Size boost
            isReverse: !isMob,
          ),
        ],
      ),
    );
  }

  Widget _buildEngineeringRow(bool isMob) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        alignment: WrapAlignment.center,
        children: [
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.4,
            name: 'Sherly Mary Daniel',
            role: 'CHIEF TECHNOLOGY OFFICER',
            imagePath: 'assets/images/Team_members/Cto.jpeg',
            credential: 'B.Tech ECE',
            experience: '9+ Years IT Expertise',
            bio: 'Scalable Software Ops.',
            accent: const Color(0xFF9D4EDD),
            sizeScale: 1.15, // Size boost (previously 0.95)
          ),
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.5,
            name: 'Fays Arukattil',
            role: 'SOFTWARE DEVELOPER',
            imagePath: 'assets/images/Team_members/Lead_Dev.jpeg',
            credential: 'Full-Stack Architect',
            experience: 'Product · R&D',
            bio: 'Architecting the Visiaxx core with Flutter.', // Refined text
            accent: const Color(0xFFF5C842),
            sizeScale: 1.15, // Size boost (previously 0.95)
            isReverse: !isMob, // Symmetrical spread
          ),
        ],
      ),
    );
  }
}

class _CinematicProfile extends StatelessWidget {
  final AnimationController ctrl;
  final double delay, sizeScale;
  final String name, role, imagePath, credential, experience, bio;
  final Color accent;
  final bool isReverse;

  const _CinematicProfile({
    required this.ctrl,
    required this.delay,
    required this.name,
    required this.role,
    required this.imagePath,
    required this.credential,
    required this.experience,
    required this.bio,
    required this.accent,
    required this.sizeScale,
    this.isReverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmall = sizeScale < 1.0;
    
    return _FadeIn(
      ctrl: ctrl,
      delay: delay,
      child: Container(
        width: isSmall ? 520 : 680,
        padding: EdgeInsets.all(isSmall ? 28 : 36),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(isSmall ? 32 : 40),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isReverse) _buildImage(isSmall),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 16 : 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Badge(text: role, accent: accent, isSmall: isSmall),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: AppFonts.h4.copyWith(
                        color: AppColors.white,
                        fontSize: isSmall ? 20 : 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$credential  ·  $experience',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.muted,
                        fontSize: isSmall ? 11 : 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bio,
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.muted,
                        fontSize: isSmall ? 13 : 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            if (isReverse) _buildImage(isSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isSmall) {
    final double w = isSmall ? 200 : 260; // Increased image size
    final double h = isSmall ? 280 : 380; // Increased image size
    
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmall ? 24 : 32),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isSmall ? 22 : 30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.topCenter),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, accent.withValues(alpha: 0.2)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color accent;
  final bool isSmall;
  const _Badge({required this.text, required this.accent, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 10 : 14, vertical: isSmall ? 4 : 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: AppFonts.caption.copyWith(
          color: accent,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontSize: isSmall ? 7 : 9,
        ),
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final Widget child;
  const _FadeIn({required this.ctrl, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(
      parent: ctrl,
      curve: Interval(delay, (delay + 0.4).clamp(0, 1), curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, 30 * (1 - anim.value)), child: child),
      ),
    );
  }
}

class _ArchitecturalGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
