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
    final progress = shrinkOffset / (maxExtent - minExtent);
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
    final bgColor = isPro ? AppColors.backgroundWarm : AppColors.background;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: bgColor,
      child: Stack(
        children: [
          // Particle bg
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(
                animValue: (currentIndex * 0.08 + progress * 0.08),
                color: isPro ? AppColors.gold.withOpacity(0.6) : AppColors.accent2.withOpacity(0.5),
                count: 30,
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
        const SizedBox(width: 60),
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
        const SizedBox(height: 30),
        SizedBox(height: 350, child: _buildPhone(test)),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isPro ? AppColors.gold.withOpacity(0.15) : AppColors.accent1.withOpacity(0.15),
            border: Border.all(color: isPro ? AppColors.gold.withOpacity(0.4) : AppColors.accent1.withOpacity(0.4)),
          ),
          child: Text(
            isPro ? 'PRACTITIONER TIER' : 'PERSONAL TIER',
            style: AppFonts.caption.copyWith(color: isPro ? AppColors.gold : AppColors.accent1, fontSize: 10),
          ),
        ),
        const SizedBox(height: 24),
        // Number
        Text(
          test.number,
          style: AppFonts.displayNumber.copyWith(
            color: isPro ? AppColors.gold.withOpacity(0.2) : AppColors.accent1.withOpacity(0.2),
            fontSize: 100,
          ),
        ),
        const SizedBox(height: 8),
        Text(test.name, style: AppFonts.h2.copyWith(color: AppColors.white)),
        const SizedBox(height: 16),
        Text(test.desc, style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, height: 1.8)),
      ],
    );
  }

  Widget _buildPhone(TestData test) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 600),
      key: ValueKey(currentIndex),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: PhoneMockup(
        width: 240,
        height: 480,
        screen: _TestScreen(test: test),
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
            isPro ? const Color(0xFF1A1425) : AppColors.backgroundLight,
            AppColors.background,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(test.icon, size: 64, color: isPro ? AppColors.gold : AppColors.accent2),
          const SizedBox(height: 20),
          Text(test.name, style: AppFonts.h5.copyWith(color: AppColors.white, fontSize: 16), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isPro ? AppColors.goldGradient : AppColors.tealGradient,
            ),
            child: Text('Start Test', style: AppFonts.bodySmall.copyWith(color: AppColors.background, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
