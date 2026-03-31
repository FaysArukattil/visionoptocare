import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/gradient_button.dart';
import '../widgets/particle_painter.dart';
import '../widgets/phone_mockup.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class DownloadSection extends StatefulWidget {
  const DownloadSection({super.key});
  @override
  State<DownloadSection> createState() => _DownloadSectionState();
}

class _DownloadSectionState extends State<DownloadSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleCtrl;

  @override
  void initState() {
    super.initState();
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 25))..repeat();
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final screenH = MediaQuery.of(context).size.height;
    return ScrollRevealWidget(
      child: SizedBox(
        height: screenH * 0.9,
        child: Stack(
          children: [
            // Radial glow background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.8,
                    colors: [
                      AppColors.accent2.withOpacity(0.08),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
            // Particles
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleCtrl,
                builder: (_, __) => CustomPaint(
                  painter: ParticlePainter(
                    animValue: _particleCtrl.value,
                    color: AppColors.accent2,
                    count: 35,
                  ),
                ),
              ),
            ),
            // Content
            Center(
              child: Padding(
                padding: Responsive.padding(context),
                child: isMob ? _buildMobile() : _buildDesktop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTexts(),
          ),
        ),
        const SizedBox(width: 60),
        _buildPhoneFloat(),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhoneFloat(),
        const SizedBox(height: 40),
        ..._buildTexts(),
      ],
    );
  }

  List<Widget> _buildTexts() {
    return [
      Text('Your Eye Clinic.\nIn Your Pocket.', style: AppFonts.h2.copyWith(color: AppColors.white)),
      const SizedBox(height: 24),
      Text('Download now and take your first eye test for free.', style: AppFonts.bodyLarge.copyWith(color: AppColors.muted)),
      const SizedBox(height: 36),
      Wrap(
        spacing: 16,
        runSpacing: 12,
        children: [
          GradientButton(text: 'App Store', icon: Icons.apple, gradient: AppColors.blueGradient, onTap: () {}),
          GradientButton(text: 'Play Store', icon: Icons.shop, gradient: AppColors.tealGradient, onTap: () {}),
        ],
      ),
    ];
  }

  Widget _buildPhoneFloat() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutBack,
      builder: (_, v, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(0.08 * sin(v * pi))
            ..rotateX(-0.05),
          child: Opacity(opacity: v, child: child),
        );
      },
      child: PhoneMockup(
        width: 220,
        height: 440,
        screen: _DashboardScreen(),
      ),
    );
  }
}

class _DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111830), AppColors.background],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility, color: AppColors.accent2, size: 18),
              const SizedBox(width: 6),
              Text('Visiaxx', style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Good Morning!', style: AppFonts.heading(fontSize: 14, color: AppColors.white)),
          const SizedBox(height: 4),
          Text('Ready for your eye check?', style: AppFonts.bodySmall.copyWith(fontSize: 10)),
          const SizedBox(height: 16),
          // Mini test cards
          for (final t in ['Visual Acuity', 'Color Vision', 'Amsler Grid'])
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.surface,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.accent2.withOpacity(0.15)),
                    child: const Icon(Icons.visibility, size: 14, color: AppColors.accent2),
                  ),
                  const SizedBox(width: 10),
                  Text(t, style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontSize: 10)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.muted),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
