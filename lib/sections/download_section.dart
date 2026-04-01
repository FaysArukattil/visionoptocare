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
      child: Container(
        height: screenH * 0.9,
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
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
                      AppColors.accent2.withValues(alpha: 0.1),
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
                builder: (context, _) => CustomPaint(
                  painter: ParticlePainter(
                    animValue: _particleCtrl.value,
                    color: AppColors.accent2,
                    count: 40,
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
            children: _buildTexts(false),
          ),
        ),
        const SizedBox(width: 80),
        _buildPhoneFloat(),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPhoneFloat(),
        const SizedBox(height: 56),
        ..._buildTexts(true),
      ],
    );
  }

  List<Widget> _buildTexts(bool isCenter) {
    final tAlign = isCenter ? TextAlign.center : TextAlign.start;
    return [
      Text(
        'GET STARTED TODAY',
        style: AppFonts.caption.copyWith(color: AppColors.accent2, letterSpacing: 4, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 24),
      Text(
        'Your Eye Clinic.\nIn Your Pocket.',
        style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.1),
        textAlign: tAlign,
      ),
      const SizedBox(height: 24),
      Text(
        'Download Visiaxx now and experience the future of digital ophthalmic consultation.',
        style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, height: 1.6),
        textAlign: tAlign,
      ),
      const SizedBox(height: 48),
      Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: isCenter ? WrapAlignment.center : WrapAlignment.start,
        children: [
          GradientButton(
            text: 'App Store',
            icon: Icons.apple,
            gradient: AppColors.blueGradient,
            onTap: () {},
          ),
          GradientButton(
            text: 'Play Store',
            icon: Icons.shop,
            gradient: AppColors.tealGradient,
            onTap: () {},
          ),
        ],
      ),
    ];
  }

  Widget _buildPhoneFloat() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutQuart,
      builder: (_, v, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(0.1 * sin(v * pi))
            ..rotateX(-0.1 * v)
            ..translateByDouble(0.0, 10 * sin(v * pi * 2), 0.0, 1.0),
          child: Opacity(opacity: v.clamp(0.0, 1.0), child: child),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.accent2.withValues(alpha: 0.2),
              blurRadius: 100,
              spreadRadius: -20,
            )
          ],
        ),
        child: PhoneMockup(
          width: 240,
          height: 480,
          screen: _DashboardScreen(),
        ),
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
          colors: [Color(0xFF0F1425), Color(0xFF050A18)],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Visiaxx', style: AppFonts.bodySmall.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold, fontSize: 10)),
                  Text('Welcome, Faysal', style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ],
              ),
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person, color: AppColors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.accent1.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.accent1.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DAILY TIP', style: AppFonts.caption.copyWith(color: AppColors.accent1, fontSize: 10)),
                const SizedBox(height: 8),
                Text('The 20-20-20 rule helps reduce digital eye strain.', style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('CORE TESTS', style: AppFonts.caption.copyWith(color: AppColors.muted, fontSize: 10, letterSpacing: 1)),
          const SizedBox(height: 12),
          for (final t in ['Visual Acuity', 'Color Vision', 'Amsler Grid', 'Near Vision'])
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.surface,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.accent2.withValues(alpha: 0.1),
                    ),
                    child: const Icon(Icons.analytics, size: 16, color: AppColors.accent2),
                  ),
                  const SizedBox(width: 12),
                  Text(t, style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.muted),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
