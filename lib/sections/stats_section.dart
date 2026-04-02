import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../widgets/globe_painter.dart';
import '../widgets/animated_counter.dart';

class StatsSection extends StatefulWidget {
  const StatsSection({super.key});

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> with SingleTickerProviderStateMixin {
  late AnimationController _globeCtrl;

  @override
  void initState() {
    super.initState();
    _globeCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
  }

  @override
  void dispose() {
    _globeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 160),
      decoration: BoxDecoration(
        color: AppColors.background,
      ),
      child: Column(
        children: [
          // Section Header
          Padding(
            padding: Responsive.padding(context),
            child: Column(
              children: [
                Text(
                  'TECHNICAL IDENTITY',
                  style: AppFonts.caption.copyWith(
                    color: AppColors.accent2, 
                    letterSpacing: 4, 
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Technical Excellence\nin Ocular Science',
                  style: AppFonts.h2.copyWith(
                    color: AppColors.white, 
                    fontSize: isMob ? 32 : 56, 
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),

          // Stats Dashboard
          Padding(
            padding: Responsive.padding(context),
            child: _buildStatsGrid(context, isMob),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, bool isMob) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMob) {
          return Column(
            children: [
              _StatCounterCard(target: 12, label: 'CLINICAL TESTS', showPlus: false),
              const SizedBox(height: 24),
              _StatCounterCard(target: 100, label: 'HEALTH TIPS', showPlus: true),
              const SizedBox(height: 24),
              _LanguageGlobeStatCard(controller: _globeCtrl, height: 300),
            ],
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCounterCard(target: 12, label: 'CLINICAL TESTS', showPlus: false),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _StatCounterCard(target: 100, label: 'HEALTH TIPS', showPlus: true),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Occupy most width with a detailed care summary or just the globe
                Expanded(
                  flex: 2,
                  child: _LanguageGlobeStatCard(controller: _globeCtrl, height: 350),
                ),
                const SizedBox(width: 24),
                const Expanded(
                  flex: 1,
                  child: _SmallActionCard(
                    title: 'Approved',
                    subtitle: 'Clinical standards',
                    icon: Icons.verified_user_outlined,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StatCounterCard extends StatelessWidget {
  final int target;
  final String label;
  final bool showPlus;

  const _StatCounterCard({required this.target, required this.label, this.showPlus = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Center(
        child: Column(
          children: [
            AnimatedCounter(
              target: target,
              showPlus: showPlus,
              style: AppFonts.h1.copyWith(
                color: AppColors.white,
                fontSize: 80,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: AppFonts.caption.copyWith(
                color: AppColors.accent2,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageGlobeStatCard extends StatelessWidget {
  final AnimationController controller;
  final double height;
  const _LanguageGlobeStatCard({required this.controller, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.accent2.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.accent2.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SPEAKING YOUR LANGUAGE',
                  style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  '13 Local\nLanguages',
                  style: AppFonts.h3.copyWith(color: AppColors.white, fontWeight: FontWeight.w800, height: 1.1),
                ),
                const SizedBox(height: 16),
                Text(
                  'Localized for Bharat. Accessible to everyone, everywhere.',
                  style: AppFonts.bodySmall.copyWith(color: AppColors.muted, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) => CustomPaint(
                painter: GlobePainter(rotation: controller.value * 2 * math.pi),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionCard extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  const _SmallActionCard({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.accent2, size: 48),
          const SizedBox(height: 24),
          Text(title, style: AppFonts.h4.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: AppFonts.bodySmall.copyWith(color: AppColors.muted)),
        ],
      ),
    );
  }
}
