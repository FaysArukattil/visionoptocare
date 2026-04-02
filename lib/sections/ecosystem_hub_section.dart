import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';
import '../widgets/animated_counter.dart';
import '../widgets/globe_painter.dart';

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
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(
                flex: 3,
                child: _FeatureBentoCard(
                  title: '12 Clinical Tests',
                  subtitle: 'Our vision test app brings clinical scrutiny directly to your smartphone. Track your ocular health with a comprehensive suite of AI-graded diagnostic tests.',
                  icon: Icons.biotech,
                  color: AppColors.accent2,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedCounter(target: 12, label: 'CLINICAL TESTS', forceStart: true),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 2,
                child: _FeatureBentoCard(
                  title: 'Smart Medical Reports',
                  subtitle: 'Instantly download and share your comprehensive visual health reports as clean, readable PDFs with your doctor or family.',
                  icon: Icons.picture_as_pdf_outlined,
                  color: const Color(0xFF00D4C8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(Icons.download_rounded, color: const Color(0xFF00D4C8).withValues(alpha: 0.2), size: 100),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 24),
        
        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Expanded(
                flex: 2,
                child: _FeatureBentoCard(
                  title: 'Education Reels',
                  subtitle: 'Scroll through our TikTok-like reels section to read and watch valuable eye care video tips in a fun, short-form format.',
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
                flex: 3,
                child: _FeatureBentoCard(
                  title: 'Ocular Wellness & Audio',
                  subtitle: 'Relax and rehabilitate. Engage with interactive eye therapy games accompanied by AI-generated therapeutic Hindi songs about eye care.',
                  icon: Icons.headphones_outlined,
                  color: const Color(0xFF9D4EDD),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.music_note, color: const Color(0xFF9D4EDD).withValues(alpha: 0.4), size: 64),
                      const SizedBox(width: 16),
                      Icon(Icons.gamepad, color: const Color(0xFF9D4EDD).withValues(alpha: 0.4), size: 64),
                    ],
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 24),

        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _FeatureBentoCard(
                title: 'Hybrid Consultations',
                subtitle: 'Connect with experts seamlessly. Book an online video consultation directly via the app, or request a convenient offline home visit. Upon request, an optometrist or our dedicated salesperson will come directly to your door to provide personalized care and assistance.',
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
          subtitle: 'Our vision test app brings clinical scrutiny directly to your smartphone.',
          icon: Icons.biotech,
          color: AppColors.accent2,
          isMobile: true,
          child: const AnimatedCounter(target: 12, label: 'CLINICAL TESTS', forceStart: true),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Smart Medical Reports',
          subtitle: 'Instantly download and share your visual health reports as clean PDFs.',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFF00D4C8),
          isMobile: true,
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
          title: 'Therapy & Audio',
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

