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
  late AnimationController _videoCrossFadeCtrl;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..forward();
    _bounceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 30))..repeat();
    
    // Cross-fade between clinic and couch every 8 seconds
    _videoCrossFadeCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _startVideoLoop();
  }

  void _startVideoLoop() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 8));
      if (!mounted) break;
      await _videoCrossFadeCtrl.forward();
      await Future.delayed(const Duration(seconds: 8));
      if (!mounted) break;
      await _videoCrossFadeCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _bounceCtrl.dispose();
    _particleCtrl.dispose();
    _videoCrossFadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          // Background Video 1: Clinic
          const Positioned.fill(
            child: HtmlElementView(viewType: 'clinic_video'),
          ),
          
          // Background Video 2: Couch (Layered on top with opacity for cross-fade)
          Positioned.fill(
            child: FadeTransition(
              opacity: _videoCrossFadeCtrl,
              child: const HtmlElementView(viewType: 'couch_video'),
            ),
          ),

          // Particle overlay
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (_, __) => CustomPaint(
                painter: ParticlePainter(
                  animValue: _particleCtrl.value,
                  color: AppColors.accent2,
                  count: 40,
                ),
              ),
            ),
          ),
          // Dark bottom gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroOverlay),
            ),
          ),
          // Content
          Positioned.fill(
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
              child: Center(
                child: Padding(
                  padding: Responsive.padding(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.accent2.withOpacity(0.4)),
                          color: AppColors.accent2.withOpacity(0.1),
                        ),
                        child: Text('DIGITAL EYE CARE PLATFORM', style: AppFonts.caption.copyWith(color: AppColors.accent2)),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Vision Care.\nReimagined.',
                        style: Responsive.value(
                          context: context,
                          desktop: AppFonts.h1.copyWith(fontSize: 80),
                          tablet: AppFonts.h1,
                          mobile: AppFonts.h2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 500,
                        child: Text(
                          '12 clinical-grade eye tests. From your couch.',
                          style: AppFonts.bodyLarge.copyWith(color: AppColors.muted),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          GradientButton(text: 'Take a Free Test', gradient: AppColors.tealGradient, icon: Icons.visibility, onTap: () {}),
                          GradientButton(text: 'Watch How It Works', isOutline: true, icon: Icons.play_arrow, onTap: () {}),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Bounce arrow
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _bounceCtrl,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _bounceCtrl.value * 12),
                child: child,
              ),
              child: const Icon(Icons.keyboard_double_arrow_down, color: AppColors.muted, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
