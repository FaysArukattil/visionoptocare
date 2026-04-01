import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/particle_painter.dart';
import '../utils/responsive.dart';
import 'hero_animation_engine.dart'; // Import the cinematic engine
import 'stats_section.dart';

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
    final p = widget.scrollProgress; // 0.0 to 1.0

    return Container(
      width: size.width,
      height: size.height * 2.2, // Massive theatrical runway for sink + stats
      color: AppColors.background,
      child: Stack(
        children: [
          // ── Background Glows & Particles ──
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _particleCtrl,
                builder: (context, _) => CustomPaint(
                  painter: ParticlePainter(
                    animValue: _particleCtrl.value,
                    color: AppColors.accent2.withValues(alpha: 0.1),
                    count: 25,
                  ),
                ),
              ),
            ),
          ),
          
          // ── Main Content (Aligned Top) ──
          Align(
            alignment: Alignment.topCenter,
            child: OverflowBox(
              maxHeight: double.infinity, // Allow the 3D Stage to draw without overflow warnings
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isMob ? 150 : 260), // Clear Navbar line initially
                    
                    // 1. Authoritative Branding (Massive centerpiece) - Sinks with scroll for parallax
                    Transform.translate(
                      offset: Offset(0, p * 150), // Parallax 'hold' to keep below Navbar line
                      child: _buildBrandName(p, isMob),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 2. Catchy Sub-headline
                    _buildInnovationHeadline(p, isMob),
                    
                    const SizedBox(height: 32),
                    
                    // 3. Mission Quote
                    _buildMissionQuote(p, isMob),
                    
                    const SizedBox(height: 48),
                    
                    // 4. Centered Description text
                    _buildDescription(p, isMob),
                    
                    const SizedBox(height: 100), 
                    
                    // 5. THE 3D LANDING STAGE (Phone + Stats sink together)
                    Transform.translate(
                      offset: Offset(0, p * size.height * 0.90), // Very deep cinematic sink
                      child: Column(
                        children: [
                          // A. The Smartphone Animation
                          RepaintBoundary(
                            child: _build3DAnimation(p, isMob),
                          ),
                          
                          const SizedBox(height: 140), // Gap exactly where the phone lands
                          
                          // B. The Stats Dashboard (Reveals when phone reaches final depth)
                          StatsSection(scrollProgress: p),
                          
                          const SizedBox(height: 200), // Grounded bottom padding within stage
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandName(double p, bool isMob) {
    return Opacity(
      opacity: (1 - p * 0.5).clamp(0.0, 1.0),
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [AppColors.white, Color(0xFFB0B0B0)],
        ).createShader(bounds),
        child: Text(
          'VISION\nOPTOCARE',
          style: AppFonts.heading(
            fontSize: isMob ? 56 : 110,
            fontWeight: FontWeight.w900,
            height: 0.85,
            letterSpacing: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInnovationHeadline(double p, bool isMob) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      builder: (_, v, child) => Opacity(
        opacity: (v * (1 - p)).clamp(0.0, 1.0),
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

  Widget _buildMissionQuote(double p, bool isMob) {
    return Text(
      '“Your Vision, Our Priority”',
      style: AppFonts.bodyLarge.copyWith(
        color: AppColors.white.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
        fontSize: isMob ? 18 : 26,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildDescription(double p, bool isMob) {
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

  Widget _build3DAnimation(double p, bool isMob) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isMob ? 320 : 500,
        maxHeight: isMob ? 550 : 750,
      ),
      child: HeroAnimationEngine(p: p, isMob: isMob),
    );
  }
}
