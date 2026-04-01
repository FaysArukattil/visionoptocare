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
      height: size.height, // Explicit height for Stack bounds
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

          // ── Main Centered Content (Scale Down to Fit) ──
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: isMob ? 80 : 120), // Adjusted top margin
                    
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
                    
                    // 5. Scroll-Synced 3D Animation (Snellen to Mobile)
                    RepaintBoundary(
                      child: _build3DAnimation(p, isMob),
                    ),
                    
                    const SizedBox(height: 60), // Bottom padding
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
    return Transform.translate(
      offset: Offset(0, 80 * p), // Moves down slightly as you scroll
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Stage 1: Traditional Snellen Chart (Fades out) ──
          Opacity(
            opacity: (1 - p * 3).clamp(0.0, 1.0), // Fades out by 0.33 progress
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-0.1 * p)
                ..multiply(Matrix4.diagonal3Values(
                  1.0 - 0.2 * p, 
                  1.0 - 0.2 * p, 
                  1.0,
                )),
              alignment: Alignment.center,
              child: CustomPaint(
                size: const Size(300, 420),
                painter: _SnellenChartPainter(),
              ),
            ),
          ),

          // ── Stage 2: Mobile Transformation (Fades in) ──
          Opacity(
            opacity: (p * 2.5 - 0.4).clamp(0.0, 1.0), // Starts appearing after 0.16 progress
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(-0.25 * (1 - p)) 
                ..rotateX(0.12 * p) 
                ..multiply(Matrix4.diagonal3Values(
                  0.75 + 0.3 * p, 
                  0.75 + 0.3 * p, 
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

/// ── Smartphone Mockup for Stage 2 ──
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
        border: Border.all(color: AppColors.white.withValues(alpha: 0.15), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent2.withValues(alpha: 0.4 * progress.clamp(0.0, 1.0)),
            blurRadius: 70,
            spreadRadius: 5,
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
              // Visiaxx Logo Visibility
              const EyeLogo(size: 85),
              const SizedBox(height: 32),
              Text(
                'VISIAXX',
                style: AppFonts.heading(
                  fontSize: 28, 
                  letterSpacing: 6,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Digital Diagnostic',
                style: AppFonts.caption.copyWith(
                  color: AppColors.accent2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 56),
              // Progress Bar
              Container(
                width: 120,
                height: 4,
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

/// ── Traditional Snellen E-Chart Painter for Stage 1 ──
class _SnellenChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Paper/Chart Material
    final paperPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), paperPaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    void drawRow(String text, double fontSize, double yOffset) {
      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.95),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace', // Classic chart look
          letterSpacing: fontSize * 0.4,
        ),
      );
      textPainter.layout(maxWidth: size.width);
      textPainter.paint(canvas, Offset(0, yOffset));
    }

    // Traditional Rows
    drawRow('E', 80, 40);
    drawRow('F P', 45, 130);
    drawRow('T O Z', 30, 190);
    drawRow('L P E D', 22, 240);
    drawRow('P E C F D', 16, 280);
    drawRow('E D F C Z P', 12, 315);
    drawRow('F E L O P Z D', 10, 345);
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
