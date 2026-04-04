import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 6: B2B Practitioner Licensing
class B2BPage extends StatefulWidget {
  final bool isActive;
  const B2BPage({super.key, required this.isActive});

  @override
  State<B2BPage> createState() => _B2BPageState();
}

class _B2BPageState extends State<B2BPage> with TickerProviderStateMixin {
  late AnimationController _enterCtrl;
  late AnimationController _card1Ctrl;
  late AnimationController _card2Ctrl;
  late AnimationController _card3Ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _card1Ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _card2Ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _card3Ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant B2BPage old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_hasStarted) _start();
  }

  void _start() async {
    _hasStarted = true;
    // Increased delay for 'Settle Gate' — ensures PageView swipe is done before firing animations.
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _enterCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _card1Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _card2Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _card3Ctrl.forward();
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _card1Ctrl.dispose();
    _card2Ctrl.dispose();
    _card3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _enterCtrl,
      builder: (context, _) {
        final t = CurvedAnimation(
                parent: _enterCtrl, curve: Curves.easeOutCubic)
            .value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                // Subtle grid background
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.3,
                    child: CustomPaint(
                      painter: _GridPainter(
                          color: AppColors.gold.withValues(alpha: 0.04)),
                    ),
                  ),
                ),
                // Main content: Made it fit securely in the viewport to avoid scroll
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      // Header
                      Padding(
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
                              'Power Your Clinic\nwith Visiaxx Pro',
                              style: AppFonts.h2.copyWith(
                                color: AppColors.white,
                                fontSize: isMob ? 28 : 42, // Refined scaling
                                height: 1.1,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: isMob ? double.infinity : 700,
                              child: Text(
                                'Empower your practice with clinical-grade digital diagnostics. License Visiaxx Pro for your clinic, mobile eye camps, and telemedicine workflows.',
                                style: AppFonts.bodyLarge.copyWith(
                                  color: AppColors.muted,
                                  fontSize: isMob ? 14 : 16, // Refined scaling
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Feature Cards
                      Padding(
                        padding: Responsive.padding(context),
                        child: isMob
                            ? Expanded(child: _buildMobileCards())
                            : _buildDesktopCards(),
                      ),
                      const Spacer(flex: 1),
                      // CTA Button ALWAYS VISIBLE
                      _buildCTA(isMob),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopCards() {
    final ctrls = [_card1Ctrl, _card2Ctrl, _card3Ctrl];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _features.asMap().entries.map((entry) {
        final i = entry.key;
        final f = entry.value;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _AnimatedFeatureCard(ctrl: ctrls[i], feature: f),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMobileCards() {
    final ctrls = [_card1Ctrl, _card2Ctrl, _card3Ctrl];
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _features.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AnimatedFeatureCard(ctrl: ctrls[i], feature: _features[i]),
        );
      },
    );
  }

  Widget _buildCTA(bool isMob) {
    return AnimatedBuilder(
      animation: _card3Ctrl,
      builder: (context, _) {
        final t = _card3Ctrl.value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - t)),
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
                          fontSize: isMob ? 14 : 17,
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
      },
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
  final AnimationController ctrl;
  final _Feature feature;
  const _AnimatedFeatureCard({required this.ctrl, required this.feature});
  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return AnimatedBuilder(
      animation: widget.ctrl,
      builder: (context, _) {
        final enter = CurvedAnimation(
                parent: widget.ctrl, curve: Curves.easeOutBack)
            .value
            .clamp(0.0, 1.0);
        return Opacity(
          opacity: enter,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - enter)),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hov = true),
              onExit: (_) => setState(() => _hov = false),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
                builder: (context, v, _) {
                  return Container(
                    padding: EdgeInsets.all(isMob ? 24 : 36),
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
                        SizedBox(height: isMob ? 16 : 24),
                        Text(
                          widget.feature.title,
                          style: AppFonts.h4.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 18 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMob ? 10 : 14),
                        Text(
                          widget.feature.desc,
                          style: AppFonts.bodyLarge.copyWith(
                            color: AppColors.muted,
                            fontSize: isMob ? 13 : 15,
                            height: 1.7,
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
      },
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
