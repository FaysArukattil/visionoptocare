import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/particle_painter.dart';
import '../widgets/eye_logo.dart';
import '../utils/responsive.dart';

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
      constraints: BoxConstraints(minHeight: size.height), // Ensure at least full screen
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
          
          _buildAmbientGlows(),

          // ── Main Centered Content (Stable Centering) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isMob ? 100 : 160), // Safe top margin for navbar
                
                // 1. Authoritative Branding (Massive centerpiece)
                _buildBrandName(p, isMob),
                
                const SizedBox(height: 24),
                
                // 2. Catchy Sub-headline
                _buildInnovationHeadline(p, isMob),
                
                const SizedBox(height: 32),
                
                // 3. Mission Quote
                _buildMissionQuote(p, isMob),
                
                const SizedBox(height: 48),
                
                // 4. Centered Description text
                _buildDescription(p, isMob),
                
                const SizedBox(height: 64),
                
                // 5. Scroll-Synced 3D Animation (Bottom)
                RepaintBoundary(
                  child: _build3DAnimation(p, isMob),
                ),
                
                const SizedBox(height: 120), // Bottom padding
              ],
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
    return Transform.translate(
      offset: Offset(0, 150 * p), // Moves down as you scroll
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Stage 1: Traditional Clinic (Fades out) ──
          Opacity(
            opacity: (1 - p * 3).clamp(0.0, 1.0), // Fades faster
            child: CustomPaint(
              size: const Size(400, 300),
              painter: _TraditionalClinicPainter(),
            ),
          ),

          // ── Stage 2: Mobile Transformation (Fades in) ──
          Opacity(
            opacity: (p * 2 - 0.2).clamp(0.0, 1.0),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(-0.3 * (1 - p)) 
                ..rotateX(0.15 * p) 
                ..multiply(Matrix4.diagonal3Values(
                  0.8 + 0.3 * p, 
                  0.8 + 0.3 * p, 
                  1.0,
                )), // Correct non-deprecated scale
              alignment: Alignment.center,
              child: _SmartphoneWidget(progress: p),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientGlows() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 100,
            left: 200,
            child: _AmbientGlow(color: AppColors.accent2.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: 200,
            right: 150,
            child: _AmbientGlow(color: AppColors.accent1.withValues(alpha: 0.08)),
          ),
        ],
      ),
    );
  }
}

class _SmartphoneWidget extends StatelessWidget {
  final double progress;
  const _SmartphoneWidget({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 500,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF030712),
        borderRadius: BorderRadius.circular(44),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.12), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent2.withValues(alpha: 0.4 * progress),
            blurRadius: 60,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EyeLogo(size: 80),
              const SizedBox(height: 24),
              Text(
                'VISION TEST',
                style: AppFonts.caption.copyWith(
                  color: AppColors.accent2,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 48),
              // Dynamic Indicator
              Container(
                width: 100,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(color: AppColors.accent2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TraditionalClinicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Abstract silhouette of a medical phoropter
    canvas.drawCircle(center - const Offset(55, 20), 45, paint);
    canvas.drawCircle(center + const Offset(55, -20), 45, paint);
    
    final path = Path();
    path.moveTo(center.dx - 10, center.dy - 80);
    path.lineTo(center.dx + 10, center.dy - 80);
    path.moveTo(center.dx, center.dy - 80);
    path.lineTo(center.dx, center.dy + 80);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  const _AmbientGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 450,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
    }
}
