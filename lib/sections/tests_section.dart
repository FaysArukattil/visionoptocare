import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/particle_painter.dart';

class TestData {
  final String number, name, desc;
  final bool isPro;
  final IconData icon;
  const TestData(this.number, this.name, this.desc, this.isPro, this.icon);
}

const _tests = [
  TestData('01', 'Visual Acuity', 'Snellen & Tumbling E chart.\nSharpness and clarity at distance.', false, Icons.visibility),
  TestData('02', 'Color Vision', 'Ishihara plates.\nDetect red-green deficiencies.', false, Icons.palette),
  TestData('03', 'Amsler Grid', 'Central vision distortion.\nEarly macular degeneration detection.', false, Icons.grid_on),
  TestData('04', 'Short Distance Reading', 'Near vision and\nPresbyopia screening.', false, Icons.menu_book),
  TestData('05', 'Contrast Sensitivity', 'Object vs background distinction.\nNight driving ability.', false, Icons.contrast),
  TestData('06', 'Mobile Refractometry', 'Myopia/Hyperopia screening\nusing proprietary camera logic.', false, Icons.camera_alt),
  TestData('07', 'Eye Hydration', 'Front camera blink tracking.\nDetects Digital Eye Strain.', false, Icons.water_drop),
  TestData('08', 'Shadow Test', 'Iris-lens relationship.\nCataract progression screening.', true, Icons.dark_mode),
  TestData('09', 'Stereopsis', 'Depth perception and\nbinocular vision.', true, Icons.view_in_ar),
  TestData('10', 'Visual Field', 'Peripheral blind spot detection.\nGlaucoma screening.', true, Icons.radar),
  TestData('11', 'Cover Uncover', 'Strabismus and eye\nalignment assessment.', true, Icons.flip),
  TestData('12', 'Torchlight Exam', 'External ocular structure\nand pupillary reflex.', true, Icons.flashlight_on),
];

class TestsSectionDelegate extends SliverPersistentHeaderDelegate {
  final double screenHeight;
  final double screenWidth;
  TestsSectionDelegate({required this.screenHeight, required this.screenWidth});

  @override
  double get maxExtent => screenHeight * 13;
  @override
  double get minExtent => screenHeight;
  @override
  bool shouldRebuild(covariant TestsSectionDelegate old) =>
      old.screenHeight != screenHeight || old.screenWidth != screenWidth;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final idx = (progress * 12).floor().clamp(0, 11);
    final testProgress = ((progress * 12) - idx).clamp(0.0, 1.0);
    return _TestsContent(currentIndex: idx, progress: testProgress, screenWidth: screenWidth);
  }
}

class _TestsContent extends StatelessWidget {
  final int currentIndex;
  final double progress;
  final double screenWidth;
  const _TestsContent({required this.currentIndex, required this.progress, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final test = _tests[currentIndex];
    final isPro = test.isPro;
    final isMob = screenWidth <= 768;
    
    // Aesthetic Switch: User (Teal) vs. Pro (Gold)
    final themeColor = isPro ? const Color(0xFFFFD700) : AppColors.accent2;
    final bgColor = isPro ? const Color(0xFF0A080D) : AppColors.background;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
      color: bgColor,
      child: Stack(
        children: [
          // 1. Cinematic Background (Glow + Particles)
          Center(
            child: Container(
              width: isMob ? 350 : 700,
              height: isMob ? 350 : 700,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    themeColor.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(
                animValue: currentIndex * 0.1 + progress * 0.05,
                color: themeColor.withValues(alpha: 0.4),
                count: 40,
              ),
            ),
          ),
          
          // 2. 3D Test Stage (Depth Swap Translation)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMob ? 24 : 100),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0015)
                ..setTranslationRaw(0.0, 0.0, -150 * progress) // Sink away
                ..rotateX(-0.1 * progress), // Tilt away
              child: Opacity(
                opacity: (1 - progress).clamp(0.0, 1.0),
                child: isMob 
                    ? _buildMobile(context, test, themeColor) 
                    : _buildDesktop(context, test, themeColor),
              ),
            ),
          ),

          // 3. Status Bar (Diagnostic Progress)
          Positioned(
            bottom: 40, left: 0, right: 0,
            child: Center(child: _buildDiagnosticStatus(currentIndex, themeColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, TestData test, Color themeColor) {
    return Row(
      children: [
        // A. Information Column
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBadge(test.isPro, themeColor),
              const SizedBox(height: 32),
              Text(
                test.number,
                style: AppFonts.heading(
                  fontSize: 24, 
                  color: themeColor.withValues(alpha: 0.6), 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                test.name.toUpperCase(),
                style: AppFonts.h1.copyWith(
                  color: AppColors.white, 
                  height: 1, 
                  fontSize: 72, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                test.desc,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted, 
                  fontSize: 20, 
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        
        // B. Holographic Smartphone Column
        Expanded(
          flex: 5,
          child: Center(
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.15)
                ..rotateX(0.1),
              alignment: Alignment.center,
              child: _buildPhone(test, themeColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, TestData test, Color themeColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBadge(test.isPro, themeColor),
        const SizedBox(height: 32),
        Text(
          test.name.toUpperCase(),
          style: AppFonts.h2.copyWith(color: AppColors.white, fontWeight: FontWeight.w900, fontSize: 36),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        SizedBox(
          height: 380,
          child: _buildPhone(test, themeColor),
        ),
        const SizedBox(height: 40),
        Text(
          test.desc,
          style: AppFonts.bodySmall.copyWith(color: AppColors.muted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBadge(bool isPro, Color themeColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: themeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        isPro ? 'PRACTITIONER LICENSE REQUIRED' : 'PERSONAL VISION TIER',
        style: AppFonts.caption.copyWith(
          color: themeColor, 
          fontWeight: FontWeight.w900, 
          fontSize: 10,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildPhone(TestData test, Color themeColor) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.2),
            blurRadius: 100,
            spreadRadius: -20,
          )
        ],
      ),
      child: PhoneMockup(
        width: 260,
        height: 520,
        screen: _TestScreen(test: test),
      ),
    );
  }

  Widget _buildDiagnosticStatus(int currentIndex, Color themeColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(12, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 40 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active ? themeColor : themeColor.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class _TestScreen extends StatefulWidget {
  final TestData test;
  const _TestScreen({required this.test});
  @override
  State<_TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<_TestScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isPro = widget.test.isPro;
    final themeColor = isPro ? const Color(0xFFFFD700) : AppColors.accent2;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1218),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          // A. Scanning Grid
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: _DiagnosticGridPainter(color: themeColor)),
            ),
          ),
          
          // B. Scanning Laser Line
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) => Positioned(
              top: _ctrl.value * 500,
              left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: themeColor.withValues(alpha: 0.8), blurRadius: 10, spreadRadius: 1),
                  ],
                  gradient: LinearGradient(
                    colors: [Colors.transparent, themeColor, Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          
          // C. Diagnostic Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, v, child) => Transform.scale(
                    scale: 0.8 + (v * 0.2),
                    child: Opacity(opacity: v, child: child),
                  ),
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: themeColor.withValues(alpha: 0.2), width: 1.5),
                    ),
                    child: Center(
                      child: Icon(widget.test.icon, size: 48, color: themeColor),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  isPro ? 'CLINICAL ANALYSIS' : 'VISUAL SCREENING',
                  style: AppFonts.caption.copyWith(color: themeColor, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 10),
                ),
                const SizedBox(height: 8),
                Text(
                  'SCANNING...',
                  style: AppFonts.caption.copyWith(color: themeColor.withValues(alpha: 0.4), fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticGridPainter extends CustomPainter {
  final Color color;
  _DiagnosticGridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    const step = 30.0;
    for (double i = 0; i < size.width; i += step) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += step) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(_DiagnosticGridPainter old) => old.color != color;
}
