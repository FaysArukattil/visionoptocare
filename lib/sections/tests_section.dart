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
    final bgColor = isPro ? const Color(0xFF150F1E) : AppColors.background;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuart,
      color: bgColor,
      child: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: isMob ? 300 : 600,
              height: isMob ? 300 : 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isPro ? AppColors.gold : AppColors.accent2).withValues(alpha: 0.08),
                    blurRadius: 120,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),
          // Particle bg
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(
                animValue: (currentIndex * 0.08 + progress * 0.08),
                color: isPro ? AppColors.gold : AppColors.accent2,
                count: 35,
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMob ? 24 : 80, vertical: 40),
            child: isMob ? _buildMobile(context, test) : _buildDesktop(context, test),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, TestData test) {
    return Row(
      children: [
        // Left info
        Expanded(
          flex: 5,
          child: _buildInfo(test),
        ),
        const SizedBox(width: 80),
        // Right phone
        Expanded(
          flex: 4,
          child: Center(child: _buildPhone(test)),
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, TestData test) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfo(test),
        const SizedBox(height: 48),
        SizedBox(height: 380, child: _buildPhone(test)),
      ],
    );
  }

  Widget _buildInfo(TestData test) {
    final isPro = test.isPro;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (isPro ? AppColors.gold : AppColors.accent1).withValues(alpha: 0.1),
            border: Border.all(color: (isPro ? AppColors.gold : AppColors.accent1).withValues(alpha: 0.3)),
          ),
          child: Text(
            isPro ? 'PRACTITIONER LICENSE' : 'PERSONAL TIER',
            style: AppFonts.caption.copyWith(color: isPro ? AppColors.gold : AppColors.accent1, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
        const SizedBox(height: 40),
        // Number & Title
        Stack(
          children: [
            Opacity(
              opacity: 0.15,
              child: Text(
                test.number,
                style: AppFonts.displayNumber.copyWith(
                  color: isPro ? AppColors.gold : AppColors.accent1,
                  fontSize: 120,
                  height: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                test.name, 
                style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          test.desc, 
          style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, height: 1.8),
        ),
      ],
    );
  }

  Widget _buildPhone(TestData test) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      key: ValueKey(currentIndex),
      curve: Curves.easeOutQuart,
      builder: (_, v, child) => Transform.scale(
        scale: v,
        child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: (test.isPro ? AppColors.gold : AppColors.accent2).withValues(alpha: 0.2),
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
      ),
    );
  }
}

class _TestScreen extends StatelessWidget {
  final TestData test;
  const _TestScreen({required this.test});

  @override
  Widget build(BuildContext context) {
    final isPro = test.isPro;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isPro ? const Color(0xFF1E1428) : const Color(0xFF111830),
            AppColors.background,
          ],
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (isPro ? AppColors.gold : AppColors.accent2).withValues(alpha: 0.1),
            ),
            child: Icon(test.icon, size: 40, color: isPro ? AppColors.gold : AppColors.accent2),
          ),
          const SizedBox(height: 32),
          Text(test.name, style: AppFonts.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            isPro ? 'Clinical Analysis' : 'Visual Screening', 
            style: AppFonts.bodySmall.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 48),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: isPro ? AppColors.goldGradient : AppColors.blueGradient,
            ),
            child: Center(
              child: Text(
                'START TEST', 
                style: AppFonts.bodySmall.copyWith(color: AppColors.background, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
