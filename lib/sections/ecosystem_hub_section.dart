import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';
import '../widgets/animated_counter.dart';
import '../widgets/globe_painter.dart';
import 'tests_section.dart';

class EcosystemHubSection extends StatelessWidget {
  const EcosystemHubSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 160),
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          children: [
            // Section Header
            Padding(
              padding: Responsive.padding(context),
              child: Column(
                children: [
                  Text(
                    'TECHNICAL EXCELLENCE & ECOSYSTEM',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.accent2, 
                      letterSpacing: 4, 
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'The Complete Vision\nTest Application',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.white, 
                      fontSize: isMob ? 32 : 56, 
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Everything you need from clinical screening to offline care booking, consolidated in one unified, easy-to-use platform.',
                    style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            // Bulletproof Layout Grid
            Padding(
              padding: Responsive.padding(context),
              child: isMob ? _buildMobileGrid() : _buildDesktopGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopGrid() {
    // We use explicit heights on Rows to prevent Expanded/RenderFlex crashes in scrolling parents
    return Column(
      children: [
        // Row 1: 12 Clinical Tests (Full Width)
        _FeatureBentoCard(
          title: '12 Clinical Tests',
          subtitle: 'Our platform brings clinical-grade optometry directly to your smartphone, analyzing multiple dimensions of your ocular health using advanced computer vision and AI.',
          icon: Icons.biotech,
          color: AppColors.accent2,
          child: const SizedBox(
            height: 700,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: TestsSection(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Row 2: Smart Medical Reports (Full Width)
        _FeatureBentoCard(
          title: 'Smart Clinical PDF Reports',
          subtitle: 'Visiaxx auto-generates comprehensive, shareable PDF reports featuring detailed diagnostic breakdowns, grayscale maps, prescription data, and clinical risk analysis.',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFF00D4C8),
          child: const SizedBox(
            height: 220,
            width: double.infinity,
            child: _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
          ),
        ),
        const SizedBox(height: 24),

        // Row 3: Reels & Therapy
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _FeatureBentoCard(
                title: 'Education Reels',
                subtitle: 'Read and watch valuable eye care video tips in a TikTok-style feed.',
                icon: Icons.play_circle_outline,
                color: const Color(0xFF4F6AFF),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.video_library, color: const Color(0xFF4F6AFF).withValues(alpha: 0.8), size: 32),
                      const SizedBox(width: 8),
                      Text('VIDEO TIPS', style: AppFonts.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: _FeatureBentoCard(
                title: 'Ocular Wellness',
                subtitle: 'Relax and rehabilitate with interactive eye therapy games accompanied by AI-generated Hindi eye care songs.',
                icon: Icons.headphones_outlined,
                color: const Color(0xFF9D4EDD),
                child: Row(
                  children: [
                    Icon(Icons.music_note, color: const Color(0xFF9D4EDD).withValues(alpha: 0.4), size: 50),
                    const SizedBox(width: 16),
                    Icon(Icons.sports_esports, color: const Color(0xFF9D4EDD).withValues(alpha: 0.4), size: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 4: Consultations & Languages
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _FeatureBentoCard(
                title: 'Hybrid Consultations',
                subtitle: 'Connect with experts seamlessly. Book an online video consultation directly via the app, or request a convenient offline home visit from an optometrist or our dedicated salesperson.',
                icon: Icons.video_call_outlined,
                color: const Color(0xFFF5C842),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _buildConsultBadge(Icons.phone_android, 'Online Booking'),
                    _buildConsultBadge(Icons.health_and_safety, 'Optometrist Visit'),
                    _buildConsultBadge(Icons.support_agent, 'Salesperson Visit'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 4,
              child: _FeatureBentoCard(
                title: '13 Local Languages',
                subtitle: 'Eye health without borders. The App natively supports 13 major languages to bring digital primary optometry to patients worldwide.',
                icon: Icons.public,
                color: const Color(0xFFFF5252),
                child: const SizedBox(
                  height: 180,
                  width: double.infinity,
                   child: _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileGrid() {
    return Column(
      children: [
        _FeatureBentoCard(
          title: '12 Clinical Tests',
          subtitle: 'Our vision test app brings clinical scrutiny directly to your smartphone, analyzing multiple dimensions of your ocular health.',
          icon: Icons.biotech,
          color: AppColors.accent2,
          isMobile: true,
          child: const SizedBox(
            height: 700,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: TestsSection(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Smart Clinical PDF Reports',
          subtitle: 'Instantly download and share your visual health reports as clean PDFs.',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFF00D4C8),
          isMobile: true,
          child: const SizedBox(
            height: 150,
            width: double.infinity,
            child: _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Education Reels',
          subtitle: 'Read and watch valuable eye care video tips in a TikTok-style feed.',
          icon: Icons.play_circle_outline,
          color: const Color(0xFF4F6AFF),
          isMobile: true,
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Ocular Wellness',
          subtitle: 'Eye therapy games accompanied by AI-generated therapeutic Hindi eye care songs.',
          icon: Icons.headphones_outlined,
          color: const Color(0xFF9D4EDD),
          isMobile: true,
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Hybrid Consultations',
          subtitle: 'Book online video consults or request offline home visits by an optometrist or our salesperson.',
          icon: Icons.video_call_outlined,
          color: const Color(0xFFF5C842),
          isMobile: true,
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: '13 Local Languages',
          subtitle: 'The App is natively localized into 13 major languages.',
          icon: Icons.public,
          color: const Color(0xFFFF5252),
          isMobile: true,
          child: const SizedBox(
             height: 150, 
             child: _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
          ),
        ),
      ],
    );
  }



  Widget _buildConsultBadge(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF5C842).withValues(alpha: 0.1),
            border: Border.all(color: const Color(0xFFF5C842).withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: const Color(0xFFF5C842), size: 32),
        ),
        const SizedBox(height: 12),
        Text(label, style: AppFonts.bodySmall.copyWith(color: AppColors.white)),
      ],
    );
  }
}

class _FeatureBentoCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget? child;
  final bool isMobile;

  const _FeatureBentoCard({
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.color,
    this.child,
    this.isMobile = false,
  });

  @override
  State<_FeatureBentoCard> createState() => _FeatureBentoCardState();
}

class _FeatureBentoCardState extends State<_FeatureBentoCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
        builder: (context, v, _) {
          return Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Color.lerp(
                  AppColors.white.withValues(alpha: 0.05),
                  widget.color.withValues(alpha: 0.4),
                  v,
                )!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.1 * v),
                  blurRadius: 40,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: widget.color, size: 40),
            const SizedBox(height: 32),
            Text(
              widget.title, 
              style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: widget.isMobile ? 22 : 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.subtitle,
              style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 15, height: 1.6),
            ),
            if (widget.child != null) ...[
              const SizedBox(height: 32),
              widget.child!,
            ],
          ],
        ),
          );
        },
      ),
    );
  }
}

class _AnimatedLanguageGlobe extends StatefulWidget {
  final Color color;
  const _AnimatedLanguageGlobe({required this.color});
  @override
  State<_AnimatedLanguageGlobe> createState() => _AnimatedLanguageGlobeState();
}

class _AnimatedLanguageGlobeState extends State<_AnimatedLanguageGlobe> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final langs = ['English', 'Hindi', 'Marathi', 'Malayalam', 'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Gujarati', 'Punjabi', 'Odia', 'Urdu', 'Assamese'];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: GlobePainter(rotation: _ctrl.value * math.pi * 2, gridColor: widget.color)),
            ),
            ...langs.asMap().entries.map((e) {
              final angle = (e.key / langs.length) * math.pi * 2 + (_ctrl.value * math.pi * 2);
              final x = math.cos(angle) * 70.0;
              final y = math.sin(angle) * 20.0;
              final z = math.sin(angle); // depth
              final scale = 0.7 + (z * 0.3); // bigger in front
              final opacity = 0.3 + ((z + 1) / 2) * 0.7; // fade in back
              
              return Transform.translate(
                offset: Offset(x, y),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: widget.color.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        e.value,
                        style: AppFonts.caption.copyWith(color: widget.color, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Center(
               child: AnimatedCounter(target: 13, forceStart: true),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedPdfGenerator extends StatefulWidget {
  final Color color;
  const _AnimatedPdfGenerator({required this.color});

  @override
  State<_AnimatedPdfGenerator> createState() => _AnimatedPdfGeneratorState();
}

class _AnimatedPdfGeneratorState extends State<_AnimatedPdfGenerator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final progress = _ctrl.value;
        final isScanning = progress < 0.7;
        final scanPos = progress / 0.7;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Floating background decor
            Positioned(
              left: 20,
              top: 20,
              child: Icon(Icons.picture_as_pdf, color: widget.color.withValues(alpha: 0.1), size: 100),
            ),
            
            // Central Document
            Container(
              width: 140,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: widget.color.withValues(alpha: 0.4), width: 2),
                boxShadow: [
                  BoxShadow(color: widget.color.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Simulated Content lines
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 60, height: 8, color: widget.color.withValues(alpha: 0.3)),
                          const SizedBox(height: 16),
                          Container(width: double.infinity, height: 4, color: widget.color.withValues(alpha: 0.1)),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 4, color: widget.color.withValues(alpha: 0.1)),
                          const SizedBox(height: 8),
                          Container(width: 80, height: 4, color: widget.color.withValues(alpha: 0.1)),
                          const SizedBox(height: 16),
                          // Simulated Data Grid
                          Row(
                            children: [
                              Container(width: 30, height: 30, decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.1), shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(width: 40, height: 4, color: widget.color.withValues(alpha: 0.1)),
                                    const SizedBox(height: 4),
                                    Container(width: 30, height: 4, color: widget.color.withValues(alpha: 0.1)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(width: double.infinity, height: 16, color: widget.color.withValues(alpha: progress > 0.8 ? 0.8 : 0.1)),
                        ],
                      ),
                    ),
                    
                    // Scanning laser effect
                    if (isScanning)
                      Positioned(
                        top: scanPos * 180,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: widget.color,
                            boxShadow: [
                              BoxShadow(color: widget.color, blurRadius: 8, spreadRadius: 2),
                            ],
                          ),
                        ),
                      ),
                      
                    // Processing overlay
                    if (!isScanning)
                      Positioned.fill(
                        child: Container(
                          color: AppColors.background.withValues(alpha: 0.8),
                          child: Center(
                            child: Icon(Icons.check_circle, color: widget.color, size: 40),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
