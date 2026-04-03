import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 7: Leadership — Cinematic showcase of the visionaries.
class LeadershipSection extends StatefulWidget {
  final bool isActive;
  const LeadershipSection({super.key, this.isActive = false});

  @override
  State<LeadershipSection> createState() => _LeadershipSectionState();
}

class _LeadershipSectionState extends State<LeadershipSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant LeadershipSection old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_hasStarted) _start();
  }

  void _start() async {
    _hasStarted = true;
    await Future.delayed(const Duration(milliseconds: 300));
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
          // ── Background Accent ──
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),
          ),

          // ── Content ──
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                // Header
                SizedBox(height: isMob ? 80 : 100),
                _FadeSlide(
                  ctrl: _ctrl,
                  delay: 0.0,
                  child: Column(
                    children: [
                      Text(
                        'THE LEADERSHIP',
                        style: AppFonts.caption.copyWith(
                          color: AppColors.accent2,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 2,
                        color: AppColors.accent2.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
                
                // Profiles
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: isMob ? _buildMobileLayout() : _buildDesktopLayout(),
                ),
                SizedBox(height: isMob ? 40 : 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Wrap(
          spacing: 40,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: _CinematicProfile(
                ctrl: _ctrl,
                delay: 0.2,
                name: 'Aben Thomas Angadiyil',
                role: 'CHIEF EXECUTIVE OFFICER',
                imagePath: 'assets/images/Founders/Founder_1.jpeg',
                credential: 'B.Optom · BMS',
                experience: '14+ Years in Vision Care',
                tagline: 'Driving global healthcare innovation.',
                accent: AppColors.accent2,
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: _CinematicProfile(
                ctrl: _ctrl,
                delay: 0.4,
                name: 'Thomas Angadiyil Philip',
                role: 'CO-FOUNDER & DIRECTOR',
                imagePath: 'assets/images/Founders/Founder_2.jpeg',
                credential: 'Rajan Optics',
                experience: '44+ Years Optical Expertise',
                tagline: 'Legacy of trust and diagnostic precision.',
                accent: const Color(0xFF4F6AFF),
                isReverse: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(top: 24, bottom: 40),
      child: Column(
        children: [
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.2,
            name: 'Aben Thomas Angadiyil',
            role: 'CHIEF EXECUTIVE OFFICER',
            imagePath: 'assets/images/Founders/Founder_1.jpeg',
            credential: 'B.Optom · BMS',
            experience: '14+ Years in Vision Care',
            tagline: 'Healthcare Innovation',
            accent: AppColors.accent2,
            isMobile: true,
          ),
          const SizedBox(height: 32),
          _CinematicProfile(
            ctrl: _ctrl,
            delay: 0.4,
            name: 'Thomas Angadiyil Philip',
            role: 'CO-FOUNDER & DIRECTOR',
            imagePath: 'assets/images/Founders/Founder_2.jpeg',
            credential: 'Rajan Optics',
            experience: '44+ Years Optical Expertise',
            tagline: 'Legacy of Precision',
            accent: const Color(0xFF4F6AFF),
            isMobile: true,
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
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) return _buildMobileCard(context);

    return _FadeSlide(
      ctrl: ctrl,
      delay: delay,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            if (!isReverse) _buildImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      isReverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    _TitleChip(role: role, accent: accent),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: AppFonts.h3.copyWith(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      textAlign: isReverse ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$credential  ·  $experience',
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: isReverse ? TextAlign.right : TextAlign.left,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 30,
                      height: 2,
                      color: accent.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      tagline,
                      style: AppFonts.bodyLarge.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                        fontSize: 16,
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
    );
  }

  Widget _buildImage() {
    return Container(
      width: 260,
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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
          fontSize: 9,
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

class _GridPainter extends CustomPainter {
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
