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

          // ── Content ──
          Padding(
            padding: EdgeInsets.only(
              top: isMob ? 70 : 90,
              bottom: isMob ? 16 : 24,
              left: isMob ? 16 : 40,
              right: isMob ? 16 : 40,
            ),
            child: Column(
              children: [
                _buildHeader('OUR TEAM', 'The People Behind the Vision', isMob),
                SizedBox(height: isMob ? 16 : 32),
                Expanded(
                  child: isMob ? _buildMobileGrid() : _buildDesktopGrid(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop: 2×2 grid — leaders on top row, engineers on bottom row
  Widget _buildDesktopGrid() {
    return Column(
      children: [
        // ── Row 1: Leadership ──
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _CinematicProfile(
                  ctrl: _ctrl, delay: 0.15,
                  name: 'Aben Thomas Angadiyil',
                  role: 'CHIEF EXECUTIVE OFFICER',
                  imagePath: 'assets/images/Founders/Founder_1.jpeg',
                  credential: 'B.Optom · BMS',
                  experience: '14+ Years in Vision Care',
                  bio: 'Driving global healthcare innovation and the product mission.',
                  accent: AppColors.accent2,
                  isLeader: true,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _CinematicProfile(
                  ctrl: _ctrl, delay: 0.25,
                  name: 'Thomas Angadiyil Philip',
                  role: 'CO-FOUNDER & DIRECTOR',
                  imagePath: 'assets/images/Founders/Founder_2.jpeg',
                  credential: 'Rajan Optics',
                  experience: '44+ Years Optical Expertise',
                  bio: 'Legacy of trust and diagnostic precision at Rajan Optics.',
                  accent: const Color(0xFF4F6AFF),
                  isLeader: true,
                  isReverse: true,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // ── Row 2: Engineering ──
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _CinematicProfile(
                  ctrl: _ctrl, delay: 0.35,
                  name: 'Sherly Mary Daniel',
                  role: 'CHIEF TECHNOLOGY OFFICER',
                  imagePath: 'assets/images/Team_members/Cto.jpeg',
                  credential: 'B.Tech ECE',
                  experience: '9+ Years IT Expertise',
                  bio: 'Scalable Software Ops.',
                  accent: const Color(0xFF9D4EDD),
                  isLeader: false,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _CinematicProfile(
                  ctrl: _ctrl, delay: 0.45,
                  name: 'Fays Arukattil',
                  role: 'SOFTWARE DEVELOPER',
                  imagePath: 'assets/images/Team_members/Software_Dev.jpeg',
                  credential: 'Full-Stack Architect',
                  experience: 'Product · R&D',
                  bio: 'Architecting the Visiaxx core with Flutter.',
                  accent: const Color(0xFFF5C842),
                  isLeader: false,
                  isReverse: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Mobile: compact vertical list of all 4 members
  Widget _buildMobileGrid() {
    final profiles = [
      _CinematicProfile(
        ctrl: _ctrl, delay: 0.15,
        name: 'Aben Thomas Angadiyil', role: 'CEO',
        imagePath: 'assets/images/Founders/Founder_1.jpeg',
        credential: 'B.Optom · BMS', experience: '14+ Years',
        bio: 'Driving global healthcare innovation.',
        accent: AppColors.accent2, isLeader: true,
      ),
      _CinematicProfile(
        ctrl: _ctrl, delay: 0.25,
        name: 'Thomas Angadiyil Philip', role: 'CO-FOUNDER',
        imagePath: 'assets/images/Founders/Founder_2.jpeg',
        credential: 'Rajan Optics', experience: '44+ Years',
        bio: 'Legacy of trust and diagnostic precision.',
        accent: const Color(0xFF4F6AFF), isLeader: true,
      ),
      _CinematicProfile(
        ctrl: _ctrl, delay: 0.35,
        name: 'Sherly Mary Daniel', role: 'CTO',
        imagePath: 'assets/images/Team_members/Cto.jpeg',
        credential: 'B.Tech ECE', experience: '9+ Years',
        bio: 'Scalable Software Ops.',
        accent: const Color(0xFF9D4EDD), isLeader: false,
      ),
      _CinematicProfile(
        ctrl: _ctrl, delay: 0.45,
        name: 'Fays Arukattil', role: 'DEV',
        imagePath: 'assets/images/Team_members/Software_Dev.jpeg',
        credential: 'Full-Stack', experience: 'Product · R&D',
        bio: 'Architecting the Visiaxx core.',
        accent: const Color(0xFFF5C842), isLeader: false,
      ),
    ];

    return Column(
      children: profiles.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: e.value,
          ),
        );
      }).toList(),
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
          const SizedBox(height: 8),
          Text(
            title,
            style: AppFonts.h2.copyWith(
              color: AppColors.white,
              fontSize: isMob ? 24 : 40,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            width: 50,
            height: 2,
            color: AppColors.accent2.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

class _CinematicProfile extends StatelessWidget {
  final AnimationController ctrl;
  final double delay;
  final String name, role, imagePath, credential, experience, bio;
  final Color accent;
  final bool isLeader;
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
    required this.isLeader,
    this.isReverse = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return _FadeIn(
      ctrl: ctrl,
      delay: delay,
      child: Container(
        padding: EdgeInsets.all(isMob ? 12 : 20),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            if (!isReverse) Expanded(flex: 2, child: _buildImage(isMob)),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMob ? 10 : 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Badge(text: role, accent: accent, isSmall: !isLeader),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: AppFonts.h4.copyWith(
                        color: AppColors.white,
                        fontSize: isMob ? 14 : (isLeader ? 20 : 17),
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$credential  ·  $experience',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.muted,
                        fontSize: isMob ? 8 : (isLeader ? 11 : 10),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bio,
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.muted,
                        fontSize: isMob ? 10 : 12,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            if (isReverse) Expanded(flex: 2, child: _buildImage(isMob)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isMob) {
    return AspectRatio(
      aspectRatio: 0.6,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: -6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.center),
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
