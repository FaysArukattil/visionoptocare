import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 7: Leadership — Cinematic showcase of the visionaries.
class LeadershipSection extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;
  const LeadershipSection({super.key, this.isActive = false, this.scrollProgress});

  @override
  State<LeadershipSection> createState() => _LeadershipSectionState();
}

class _LeadershipSectionState extends State<LeadershipSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        final tEntry = (raw - 6.0).clamp(0.0, 1.0);
        final tExit = (raw - 7.0).clamp(0.0, 1.0);
        final overallOpacity = (Curves.easeOut.transform(tEntry) * (1.0 - tExit)).clamp(0.0, 1.0);

        return Opacity(
          opacity: overallOpacity,
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                // ── Background Accent ──
                Positioned.fill(
                  child: RepaintBoundary(
                    child: Opacity(
                      opacity: 0.05,
                      child: CustomPaint(
                        painter: _GridPainter(),
                      ),
                    ),
                  ),
                ),

                // ── Content ──
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMob ? 80 : 100,
                      bottom: isMob ? 16 : 24,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Header
                                Opacity(
                                  opacity: (tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit),
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
                                  padding: EdgeInsets.symmetric(vertical: isMob ? 20 : 40),
                                  child: isMob 
                                      ? _buildMobileLayout(tEntry, tExit) 
                                      : _buildDesktopLayout(tEntry, tExit),
                                ),
                                SizedBox(height: isMob ? 16 : 40),
                              ],
                            ),
                          ),
                        );
                      },
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
    final entryLX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * -500;
    final exitLX = Curves.easeInCubic.transform(tExit) * -500;

    final entryRX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * 500;
    final exitRX = Curves.easeInCubic.transform(tExit) * 500;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Wrap(
          spacing: 40,
          runSpacing: 40,
          alignment: WrapAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(entryLX + exitLX, 0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: _CinematicProfile(
                  progress: tEntry,
                  exitProgress: tExit,
                  name: 'Aben Thomas Angadiyil',
                  role: 'FOUNDER & CEO',
                  imagePath: 'assets/images/Founders/Founder_1.jpeg',
                  credential: 'B.Optom · BMS',
                  experience: '14+ Years in Vision Care',
                  tagline: 'Driving global healthcare innovation.',
                  accent: AppColors.accent2,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(entryRX + exitRX, 0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: _CinematicProfile(
                  progress: tEntry,
                  exitProgress: tExit,
                  name: 'Thomas Angadiyil Philip',
                  role: 'CO-FOUNDER & DIRECTOR',
                  imagePath: 'assets/images/Founders/Founder_2.jpeg',
                  credential: 'Rajan Optics',
                  experience: '44+ Years Optical Expertise',
                  tagline: 'Legacy of trust and diagnostic precision.',
                  accent: const Color(0xFF4F6AFF),
                  isReverse: true,
                  alignment: Alignment.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(double tEntry, double tExit) {
    return Column(
      children: [
        _CinematicProfile(
          progress: tEntry,
          exitProgress: tExit,
          name: 'Aben Thomas Angadiyil',
          role: 'FOUNDER & CEO',
          imagePath: 'assets/images/Founders/Founder_1.jpeg',
          credential: 'B.Optom · BMS',
          experience: '14+ Years in Vision Care',
          tagline: 'Healthcare Innovation',
          accent: AppColors.accent2,
          isMobile: true,
        ),
        const SizedBox(height: 24),
        _CinematicProfile(
          progress: tEntry,
          exitProgress: tExit,
          name: 'Thomas Angadiyil Philip',
          role: 'CO-FOUNDER & DIRECTOR',
          imagePath: 'assets/images/Founders/Founder_2.jpeg',
          credential: 'Rajan Optics',
          experience: '44+ Years Optical Expertise',
          tagline: 'Legacy of Precision',
          accent: const Color(0xFF4F6AFF),
          isMobile: true,
          alignment: Alignment.center,
        ),
      ],
    );
  }
}

class _CinematicProfile extends StatelessWidget {
  final double progress;
  final double exitProgress;
  final String name, role, imagePath, credential, experience, tagline;
  final Color accent;
  final bool isReverse, isMobile;
  final AlignmentGeometry alignment;

  const _CinematicProfile({
    required this.progress,
    required this.exitProgress,
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

    final enter = Curves.easeOutCubic.transform(progress);

    return Opacity(
      opacity: (enter * (1.0 - exitProgress)).clamp(0.0, 1.0),
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
      width: 240,
      height: 340,
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
    final enter = Curves.easeOutCubic.transform(progress);
    return Opacity(
      opacity: (enter * (1.0 - exitProgress)).clamp(0.0, 1.0),
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
                  alignment: alignment,
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

// Removed _FadeSlide as it's replaced by direct opacity/transform logic

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
