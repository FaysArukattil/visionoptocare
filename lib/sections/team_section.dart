import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 8: The Team — Founding Engineer and technical leadership.
class TeamSection extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;
  const TeamSection({super.key, this.isActive = false, this.scrollProgress});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection> {
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
        final tEntry = (raw - 7.0).clamp(0.0, 1.0);
        final tExit = (raw - 8.0).clamp(0.0, 1.0);
        final overallOpacity = (Curves.easeOut.transform(tEntry) * (1.0 - tExit)).clamp(0.0, 1.0);

        return Opacity(
          opacity: overallOpacity,
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
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
                          Opacity(
                            opacity: ((tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit)).clamp(0.0, 1.0),
                            child: Column(
                              children: [
                                Text(
                                  'TEAM MEMBERS',
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
                          SizedBox(height: isMob ? 24 : 60),
                          Padding(
                            padding: Responsive.padding(context),
                            child: isMob 
                                ? _buildMobile(tEntry, tExit) 
                                : _buildDesktop(tEntry, tExit),
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
        );
      },
    );
  }

  Widget _buildDesktop(double tEntry, double tExit) {
    final entryLX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * -500;
    final exitLX = Curves.easeInCubic.transform(tExit) * -500;

    final entryRX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * 500;
    final exitRX = Curves.easeInCubic.transform(tExit) * 500;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 40,
      runSpacing: 40,
      children: [
        Transform.translate(
          offset: Offset(entryLX + exitLX, 0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _CinematicProfile(
              progress: tEntry,
              exitProgress: tExit,
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
        ),
        Transform.translate(
          offset: Offset(entryRX + exitRX, 0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: _CinematicProfile(
              progress: tEntry,
              exitProgress: tExit,
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
        ),
      ],
    );
  }

  Widget _buildMobile(double tEntry, double tExit) {
    return Column(
      children: [
        _CinematicProfile(
          progress: tEntry,
          exitProgress: tExit,
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
        const SizedBox(height: 24),
        _CinematicProfile(
          progress: tEntry,
          exitProgress: tExit,
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
    final enter = Curves.easeOutCubic.transform(progress);
    return Opacity(
      opacity: (enter * (1.0 - exitProgress)).clamp(0.0, 1.0),
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


// Removed _FadeSlide as it's replaced by direct opacity/transform logic
