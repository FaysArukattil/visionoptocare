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
        return RepaintBoundary(
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _GridPainter(),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMob ? 60 : 100,
                      bottom: isMob ? 12 : 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (context) {
                            final headerOp = ((tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit)).clamp(0.0, 1.0);
                            return Column(
                              children: [
                                Text(
                                  'THE LEADERSHIP',
                                  style: AppFonts.caption.copyWith(
                                    color: AppColors.accent2.withValues(alpha: headerOp),
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.w900,
                                    fontSize: isMob ? 10 : 12,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 40,
                                  height: 2,
                                  color: AppColors.accent2.withValues(alpha: 0.3 * headerOp),
                                ),
                              ],
                            );
                          },
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: isMob ? 20 : 40),
                            child: isMob 
                                ? _buildMobileLayout(tEntry, tExit) 
                                : _buildDesktopLayout(tEntry, tExit),
                          ),
                        ),
                        if (!isMob) const SizedBox(height: 40),
                      ],
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CinematicProfile(
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
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _CinematicProfile(
              progress: tEntry,
              exitProgress: tExit,
              name: 'Thomas Angadiyil Philip',
              role: 'CO-FOUNDER & DIRECTOR',
              imagePath: 'assets/images/Founders/Founder_2.jpeg',
              credential: 'Rajan Optics',
              experience: '44+ Years Optical Expertise',
              tagline: 'Legacy of Trust',
              accent: const Color(0xFF4F6AFF),
              isMobile: true,
              isReverse: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _CinematicProfile extends StatelessWidget {
  final double progress, exitProgress;
  final String name, role, imagePath, credential, experience, tagline;
  final Color accent;
  final bool isReverse, isMobile;

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
  });

  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.all(isMobile ? 16 : 30),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: accent.withValues(alpha: 0.15)),
        ),
        child: isMobile 
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImage(),
                const SizedBox(height: 12),
                _buildInfo(),
              ],
            )
          : Row(
              children: isReverse 
                ? [_buildInfo(), const SizedBox(width: 40), _buildImage()]
                : [_buildImage(), const SizedBox(width: 40), _buildInfo()],
            ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: isMobile ? 120 : 220,
      height: isMobile ? 120 : 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 30),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInfo() {
    return Expanded(
      flex: isMobile ? 0 : 1,
      child: Column(
        crossAxisAlignment: isMobile ? CrossAxisAlignment.center : (isReverse ? CrossAxisAlignment.end : CrossAxisAlignment.start),
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(role, style: AppFonts.caption.copyWith(color: accent, letterSpacing: 2, fontSize: isMobile ? 10 : 12)),
          const SizedBox(height: 8),
          Text(name, style: AppFonts.h3.copyWith(color: AppColors.white, fontSize: isMobile ? 18 : 32, fontWeight: FontWeight.w900), textAlign: isMobile ? TextAlign.center : (isReverse ? TextAlign.right : TextAlign.left)),
          const SizedBox(height: 4),
          Text(credential, style: AppFonts.bodyLarge.copyWith(color: accent.withValues(alpha: 0.7), fontWeight: FontWeight.bold, fontSize: isMobile ? 12 : 16)),
          const SizedBox(height: 12),
          Text(experience, style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: isMobile ? 12 : 14)),
          const SizedBox(height: 8),
          Text(tagline, style: AppFonts.bodyLarge.copyWith(color: AppColors.white.withValues(alpha: 0.5), fontStyle: FontStyle.italic, fontSize: isMobile ? 11 : 14), textAlign: isMobile ? TextAlign.center : (isReverse ? TextAlign.right : TextAlign.left)),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white10..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
