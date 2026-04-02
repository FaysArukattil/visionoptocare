import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/particle_painter.dart';
import '../utils/responsive.dart';
import 'hero_animation_engine.dart';

class HeroSection extends StatefulWidget {
  final double scrollProgress;
  const HeroSection({super.key, required this.scrollProgress});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);
    final safeP = widget.scrollProgress.isFinite && !widget.scrollProgress.isNaN 
        ? widget.scrollProgress.clamp(0.0, 1.0) : 0.0;
        
    // High-precision thresholds for a seamless cross-fade
    // Brand fades out between 0.25 and 0.55
    final brandOpacity = (1.0 - ((safeP - 0.25) / 0.30)).clamp(0.0, 1.0);
    // Dashboard (Phone/Intro) fades in between 0.35 and 0.60
    final dashOpacity  = ((safeP - 0.35) / 0.25).clamp(0.0, 1.0);
    // animP maps the 'dashboard' portion of scroll to the full animation lifecycle
    final animP = ((safeP - 0.35) / 0.65).clamp(0.0, 1.0);

    return Container(
      width: size.width,
      height: size.height * 2.0,
      color: AppColors.background,
      child: Stack(
        children: [
          // ── Background Particles ──
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _particleCtrl,
                builder: (context, _) => CustomPaint(
                  painter: ParticlePainter(
                    animValue: _particleCtrl.value,
                    color: AppColors.accent2.withValues(alpha: 0.08),
                    count: 15,
                  ),
                ),
              ),
            ),
          ),
          
          // ── SCREEN 1: Branding ──
          Positioned(
            top: 0, left: 0, right: 0,
            height: size.height,
            child: RepaintBoundary(
              child: Opacity(
                opacity: brandOpacity.clamp(0.0, 1.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      _buildBrandName(isMob),
                      const SizedBox(height: 24),
                      _buildInnovationHeadline(isMob),
                      const SizedBox(height: 28),
                      _buildMissionQuote(isMob),
                      const SizedBox(height: 40),
                      _buildDescription(isMob),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── SCREEN 2: Phone Animation + Stats Dashboard ──
          Positioned(
            top: size.height,
            left: 0, right: 0,
            height: size.height,
            child: RepaintBoundary(
              child: Opacity(
                opacity: dashOpacity.clamp(0.0, 1.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMob ? 16 : 60),
                  child: isMob 
                    ? _buildMobileDashboard(animP, isMob)
                    : _buildDesktopDashboard(animP, isMob, safeP),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop: Phone animation on the LEFT, Intro on the RIGHT
  Widget _buildDesktopDashboard(double animP, bool isMob, double p) {
    return Row(
      children: [
        // LEFT: The 3D Animation (Snellen → Iris → Phone)
        Expanded(
          flex: 5,
          child: Center(
            child: RepaintBoundary(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450, maxHeight: 600),
                child: HeroAnimationEngine(p: animP, isMob: isMob),
              ),
            ),
          ),
        ),
        const SizedBox(width: 60),
        // RIGHT: What is Visiaxx?
        Expanded(
          flex: 4,
          child: _buildIntroContent(isMob),
        ),
      ],
    );
  }

  /// Mobile: Stacked — Animation on top, Intro below
  Widget _buildMobileDashboard(double animP, bool isMob) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Phone animation
          RepaintBoundary(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280, maxHeight: 380),
              child: HeroAnimationEngine(p: animP, isMob: isMob),
            ),
          ),
          const SizedBox(height: 40),
          // Intro Content
          _buildIntroContent(isMob),
        ],
      ),
    );
  }

  Widget _buildIntroContent(bool isMob) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: isMob ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT IS VISIAXX?',
          style: AppFonts.caption.copyWith(
            color: AppColors.accent2, 
            letterSpacing: 4, 
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'AN APP FOR STANDARDIZED VISION DISEASE DETECTION',
          style: AppFonts.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.6), 
            letterSpacing: 1.5, 
            fontWeight: FontWeight.w700,
            fontSize: isMob ? 10 : 12,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pioneering Digital\nOptometry.',
          style: AppFonts.h2.copyWith(
            color: AppColors.white, 
            fontSize: isMob ? 32 : 56, 
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
          textAlign: isMob ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 32),
        Text(
          'We merge clinical-grade screening with AI-driven analytics to transform your smartphone into a powerful diagnostic tool. Vision Optocare empowers patients and practitioners with accessible, high-precision ocular health tracking.',
          style: AppFonts.bodyLarge.copyWith(
            color: AppColors.muted, 
            height: 1.6,
            fontSize: isMob ? 16 : 18,
          ),
          textAlign: isMob ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 40),
        // CTA Button Placeholder
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.accent2.withValues(alpha: 0.5)),
            color: AppColors.accent2.withValues(alpha: 0.1),
          ),
          child: Text(
            'EXPLORE THE ECOSYSTEM',
            style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandName(bool isMob) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [AppColors.white, Color(0xFFB0B0B0)],
      ).createShader(bounds),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'VISION\nOPTOCARE',
          style: AppFonts.heading(
            fontSize: isMob ? 64 : 110,
            fontWeight: FontWeight.w900,
            height: 0.85,
            letterSpacing: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInnovationHeadline(bool isMob) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (_, v, child) => Opacity(
        opacity: v.clamp(0.0, 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                AppColors.accent2.withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: AppColors.accent2.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Transforming Eye Care through Innovation.',
            style: AppFonts.bodyLarge.copyWith(
              color: AppColors.accent2,
              fontWeight: FontWeight.w600,
              fontSize: isMob ? 16 : 24,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionQuote(bool isMob) {
    return Text(
      '"Your Vision, Our Priority"',
      style: AppFonts.bodyLarge.copyWith(
        color: AppColors.white.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
        fontSize: isMob ? 18 : 26,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildDescription(bool isMob) {
    return SizedBox(
      width: 700,
      child: Text(
        'Vision Optocare is a forward-thinking digital health startup focused on reshaping how primary eye care is delivered. By merging optometric precision with mobile-first technology, we aim to make vision care more accessible and data-driven across the globe.',
        style: AppFonts.bodyLarge.copyWith(
          color: AppColors.muted,
          height: 1.8,
          fontSize: isMob ? 16 : 19,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
