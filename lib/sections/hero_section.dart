import 'dart:ui_web' as ui_web;
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/gradient_button.dart';
import '../widgets/particle_painter.dart';
import '../utils/responsive.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});
  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late AnimationController _bounceCtrl;
  late AnimationController _particleCtrl;
  final String _heroViewId = 'hero_video_bg';

  @override
  void initState() {
    super.initState();
    _registerHeroVideo();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
  }

  void _registerHeroVideo() {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_heroViewId, (int viewId) {
      return html.VideoElement()
        ..src = 'assets/videos/hero.mp4'
        ..autoplay = true
        ..muted = true
        ..loop = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.pointerEvents = 'none';
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _bounceCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          Positioned.fill(
            child: HtmlElementView(viewType: _heroViewId),
          ),
          
          // Particle overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (context, _) => CustomPaint(
                painter: ParticlePainter(
                  animValue: _particleCtrl.value,
                  color: AppColors.accent2,
                  count: 40,
                ),
              ),
            ),
          ),
          // Dark bottom gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.0),
                    AppColors.background.withValues(alpha: 0.4),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
              child: SingleChildScrollView(
                child: Padding(
                  padding: Responsive.padding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.15), // Initial spacing
                      // Badge
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1000),
                        builder: (_, v, child) => Transform.translate(
                          offset: Offset(0, 20 * (1 - v)),
                          child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.accent2.withValues(alpha: 0.3)),
                            gradient: LinearGradient(
                              colors: [AppColors.accent2.withValues(alpha: 0.1), Colors.transparent],
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.verified_user, color: AppColors.accent2, size: 14),
                              const SizedBox(width: 8),
                              Text(
                                'VISION CARE. REIMAGINED.',
                                style: AppFonts.caption.copyWith(
                                  color: AppColors.accent2,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Redefined Centerpiece: minimalist and large brand statement
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1500),
                        builder: (_, v, child) => Transform.scale(
                          scale: 0.9 + (0.1 * v),
                          child: Opacity(
                            opacity: v,
                            child: Text(
                              'VISIAXX',
                              style: AppFonts.heading(
                                fontSize: isMob ? 56 : 120,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 10 + (10 * v),
                                color: AppColors.white,
                              ).copyWith(
                                shadows: [
                                  Shadow(
                                    color: AppColors.accent2.withValues(alpha: 0.6 * v),
                                    blurRadius: 50 * v,
                                  ),
                                  Shadow(
                                    color: AppColors.accent1.withValues(alpha: 0.3 * v),
                                    blurRadius: 100 * v,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOut,
                        builder: (_, v, child) => Transform.translate(
                          offset: Offset(0, 10 * (1 - v)),
                          child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
                        ),
                        child: SizedBox(
                          width: 800,
                          child: Text(
                            '12 clinical-grade eye tests. Accessible anywhere, anytime.\nExperience the future of digital ophthalmology.',
                            style: AppFonts.bodyLarge.copyWith(
                              color: AppColors.muted,
                              height: 1.8,
                              fontSize: isMob ? 17 : 20,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 56),
                      // Floating CTA Buttons
                      _buildHeroActions(context),
                      SizedBox(height: 100), // Space for scroll indicator
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Scroll indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _bounceCtrl,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _bounceCtrl.value * 10),
                child: child,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('SCROLL TO EXPLORE', style: AppFonts.caption.copyWith(fontSize: 10)),
                  const SizedBox(height: 8),
                  const Icon(Icons.keyboard_double_arrow_down, color: AppColors.accent2, size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroActions(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        GradientButton(
          text: 'Take a Free Test',
          gradient: AppColors.tealGradient,
          icon: Icons.bolt,
          onTap: () {},
        ),
        GradientButton(
          text: 'Watch How It Works',
          isOutline: true,
          icon: Icons.play_arrow,
          onTap: () {},
        ),
      ],
    );
  }
}
