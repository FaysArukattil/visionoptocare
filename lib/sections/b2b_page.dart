import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page: B2B Practitioner Licensing
class B2BPage extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;
  const B2BPage({super.key, required this.isActive, this.scrollProgress});

  @override
  State<B2BPage> createState() => _B2BPageState();
}

class _B2BPageState extends State<B2BPage> {
  final PageController _featureCtrl = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _featureCtrl.dispose();
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
        // Entry: 4.0 -> 5.0
        final tEntry = (raw - 4.0).clamp(0.0, 1.0);
        // Exit: 5.0 -> 6.0
        final tExit = (raw - 5.0).clamp(0.0, 1.0);

        return Opacity(
          opacity: (Curves.easeOut.transform(tEntry) * (1.0 - tExit)).clamp(0.0, 1.0),
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: Opacity(
                      opacity: 0.3,
                      child: CustomPaint(
                        painter: _GridPainter(
                            color: AppColors.gold.withValues(alpha: 0.04)),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: isMob ? 60 : 120, // Reduced for mobile
                      bottom: isMob ? 12 : 32,
                    ),
                    child: Column(
                      children: [
                        // Header
                        Opacity(
                          opacity: ((tEntry * 2 - 1).clamp(0.0, 1.0) * (1.0 - tExit)).clamp(0.0, 1.0),
                          child: Padding(
                            padding: Responsive.padding(context),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            AppColors.gold.withValues(alpha: 0.3)),
                                  ),
                                  child: Text(
                                    'FOR CLINICS & HOSPITALS',
                                    style: AppFonts.caption.copyWith(
                                      color: AppColors.gold,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 3,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  isMob ? 'Power Your Clinic with Visiaxx Pro' : 'Power Your Clinic\nwith Visiaxx Pro',
                                  style: AppFonts.h2.copyWith(
                                    color: AppColors.white,
                                    fontSize: isMob ? 22 : 42, // Reduced for mobile
                                    height: 1.1,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: isMob ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isMob ? 16 : 24),
                        Expanded(
                          child: Padding(
                            padding: Responsive.padding(context),
                            child: isMob
                                ? _buildMobileCards(tEntry, tExit)
                                : _buildDesktopCards(tEntry, tExit),
                          ),
                        ),
                        SizedBox(height: isMob ? 12 : 16),
                        _buildCTA(isMob, tEntry, tExit),
                        SizedBox(height: isMob ? 8 : 16),
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

  Widget _buildDesktopCards(double tEntry, double tExit) {
    // Left fly-in: from -500 to 0 on entry, from 0 to -500 on exit.
    final entryLX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * -500;
    final exitLX = Curves.easeInCubic.transform(tExit) * -500;

    // Right fly-in: from 500 to 0 on entry, from 0 to 500 on exit.
    final entryRX = (1.0 - Curves.easeOutCubic.transform(tEntry)) * 500;
    final exitRX = Curves.easeInCubic.transform(tExit) * 500;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.translate(
              offset: Offset(entryLX + exitLX, 0),
              child: _AnimatedFeatureCard(
                  progress: tEntry, exitProgress: tExit, feature: _features[0]),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform(
              transform: Matrix4.diagonal3Values(
                (Curves.easeOutBack.transform(tEntry) * (1.0 - Curves.easeInCubic.transform(tExit))).clamp(0.01, 2.0),
                (Curves.easeOutBack.transform(tEntry) * (1.0 - Curves.easeInCubic.transform(tExit))).clamp(0.01, 2.0),
                1.0,
              ),
              alignment: Alignment.center,
              child: _AnimatedFeatureCard(
                  progress: tEntry,
                  exitProgress: tExit,
                  feature: _features[1],
                  isMiddle: true),
            ),
          ),
        ),
        // Right Card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Transform.translate(
              offset: Offset(entryRX + exitRX, 0),
              child: _AnimatedFeatureCard(
                  progress: tEntry, exitProgress: tExit, feature: _features[2]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCards(double tEntry, double tExit) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _featureCtrl,
            physics: const BouncingScrollPhysics(),
            itemCount: _features.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _AnimatedFeatureCard(
                    progress: tEntry, exitProgress: tExit, feature: _features[i]),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _featureCtrl,
          builder: (context, _) {
            double page = 0;
            if (_featureCtrl.hasClients) page = _featureCtrl.page ?? 0;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_features.length, (i) {
                final isCurrent = (page - i).abs() < 0.5;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: i == 0 ? 0 : 3.0),
                  width: isCurrent ? 12 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isCurrent ? AppColors.gold : Colors.white24,
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

  Widget _buildCTA(bool isMob, double tEntry, double tExit) {
    final enterT = (tEntry * 2 - 1).clamp(0.0, 1.0);
    return Opacity(
      opacity: (enterT * (1.0 - tExit)).clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, 15 * (1 - enterT)),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _launchEnterpriseEmail,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isMob ? 32 : 40, vertical: isMob ? 14 : 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: AppColors.goldGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.business_center,
                      color: AppColors.background, size: isMob ? 18 : 22),
                  SizedBox(width: isMob ? 10 : 14),
                  Text(
                    'Request Enterprise Access',
                    style: AppFonts.body(
                      fontSize: isMob ? 13 : 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.background,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchEnterpriseEmail() async {
    final subject = Uri.encodeComponent('Business Software License Inquiry — Visiaxx Pro');
    final body = Uri.encodeComponent(
      'Dear Visiaxx Team,\n\n'
      'I am interested in purchasing the Visiaxx Pro business software license.\n\n'
      'Full Name: [Your Full Name]\n'
      'Phone Number: [Your Phone Number]\n'
      'Clinic/Business Address: [Your Complete Address]\n'
      'Qualification/Designation: [e.g., Optometrist, Ophthalmologist, Clinic Owner]\n'
      'Workplace/Clinic Name: [Your Workplace Name]\n\n'
      'Additional Notes:\n'
      '[Any additional information or requirements]\n\n'
      'Looking forward to hearing from you.\n\n'
      'Best regards,\n'
      '[Your Name]',
    );
    final mailtoUrl = 'mailto:contact@visionoptocare.co.in?subject=$subject&body=$body';
    final uri = Uri.parse(mailtoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static final _features = [
    _Feature(
      Icons.biotech,
      '12 Clinical Tests',
      'Deploy all 12 clinical-grade vision tests on any device — smartphones, tablets, and desktops.',
      AppColors.accent2,
    ),
    _Feature(
      Icons.folder_shared,
      'Digital Patient Records',
      'Maintain comprehensive digital patient records with full diagnostic history and auto-generated PDF reports.',
      const Color(0xFF4F6AFF),
    ),
    _Feature(
      Icons.campaign,
      'Mobile Eye Camps',
      'Run organized mobile eye screening camps in rural and urban communities with the B2B enterprise license.',
      AppColors.gold,
    ),
  ];
}

class _Feature {
  final IconData icon;
  final String title, desc;
  final Color color;
  const _Feature(this.icon, this.title, this.desc, this.color);
}

class _AnimatedFeatureCard extends StatefulWidget {
  final double progress;
  final double exitProgress;
  final _Feature feature;
  final bool isMiddle;
  const _AnimatedFeatureCard(
      {required this.progress,
      required this.exitProgress,
      required this.feature,
      this.isMiddle = false});
  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final enter = Curves.easeOutBack.transform(widget.progress);

    return Opacity(
      opacity: (enter * (1.0 - widget.exitProgress)).clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(0, widget.isMiddle ? 0 : 30 * (1 - enter)),
        child: MouseRegion(
              onEnter: (_) => setState(() => _hov = true),
              onExit: (_) => setState(() => _hov = false),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
                builder: (context, v, _) {
                  return Container(
                    padding: EdgeInsets.all(isMob ? 20 : 32),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Color.lerp(
                          AppColors.white.withValues(alpha: 0.05),
                          widget.feature.color.withValues(alpha: 0.4),
                          v,
                        )!,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.feature.color
                              .withValues(alpha: 0.08 * v + 0.02),
                          blurRadius: 40,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMob ? 10 : 14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                widget.feature.color.withValues(alpha: 0.1),
                          ),
                          child: Icon(widget.feature.icon,
                              color: widget.feature.color,
                              size: isMob ? 24 : 30),
                        ),
                        SizedBox(height: isMob ? 12 : 20),
                        Text(
                          widget.feature.title,
                          style: AppFonts.h4.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 17 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMob ? 8 : 14),
                        Flexible(
                          child: Text(
                            widget.feature.desc,
                            style: AppFonts.bodyLarge.copyWith(
                              color: AppColors.muted,
                              fontSize: isMob ? 12 : 15,
                              height: 1.7,
                            ),
                            maxLines: isMob ? 3 : 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
