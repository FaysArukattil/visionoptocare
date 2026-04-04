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
  final PageController _leadCtrl = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _leadCtrl.dispose();
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
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMob ? 60 : 100,
                      bottom: isMob ? 12 : 24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: ((tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit)).clamp(0.0, 1.0),
                          child: Column(
                            children: [
                              Text(
                                'THE LEADERSHIP',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.accent2,
                                  letterSpacing: 6,
                                  fontWeight: FontWeight.w900,
                                  fontSize: isMob ? 10 : 12,
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
          child: PageView(
            controller: _leadCtrl,
            physics: const BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
            ],
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _leadCtrl,
          builder: (context, _) {
            double page = 0;
            if (_leadCtrl.hasClients) page = _leadCtrl.page ?? 0;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (i) {
                final isCurrent = (page - i).abs() < 0.5;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isCurrent ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.accent2 : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
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
    final entry = Curves.easeOutQuart.transform(progress);
    final opacity = (entry * (1.0 - exitProgress)).clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Container(
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
                const SizedBox(height: 16),
                _buildInfo(),
              ],
            )
          : Row(
              children: isReverse 
                ? [_buildInfo(), const SizedBox(width: 40), _buildImage()]
                : [_buildImage(), const SizedBox(width: 40), _buildInfo()],
            ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: isMobile ? 180 : 220,
      height: isMobile ? 180 : 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
