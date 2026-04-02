import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class PhilosophySection extends StatelessWidget {
  const PhilosophySection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return ScrollRevealWidget(
      child: Container(
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
                    'OUR PHILOSOPHY',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.accent2, 
                      letterSpacing: 4, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'The Vision Behind\nVision Optocare',
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

            // Narrative Steps
            Padding(
              padding: Responsive.padding(context),
              child: _buildPhilosophyFlow(context, isMob),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhilosophyFlow(BuildContext context, bool isMob) {
    final steps = [
      _PhilosophyStep(
        number: '01',
        title: 'Our Vision',
        subtitle: 'A world where clinical-grade optometry is not a luxury, but a fundamental right accessible to everyone through mobile technology.',
        icon: Icons.visibility,
        color: AppColors.accent2,
      ),
      _PhilosophyStep(
        number: '02',
        title: 'Our Mission',
        subtitle: 'To decentralize global eye care by delivering an AI-driven, highly accurate diagnostic ecosystem directly to your smartphone.',
        icon: Icons.rocket_launch,
        color: const Color(0xFF00D4C8),
      ),
      _PhilosophyStep(
        number: '03',
        title: 'Our Innovation',
        subtitle: 'Fusing medical science with digital convenience. We integrate AI precision, hybrid care, and therapeutic engagement in one platform.',
        icon: Icons.lightbulb_outline,
        color: const Color(0xFFF5C842),
      ),
    ];

    if (isMob) {
      return Column(
        children: steps.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _PhilosophyCard(step: s),
        )).toList(),
      );
    }

    return Row(
      children: steps.map((s) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _PhilosophyCard(step: s),
        ),
      )).toList(),
    );
  }
}

class _PhilosophyStep {
  final String number, title, subtitle;
  final IconData icon;
  final Color color;

  const _PhilosophyStep({
    required this.number, 
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.color,
  });
}

class _PhilosophyCard extends StatelessWidget {
  final _PhilosophyStep step;
  const _PhilosophyCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                step.number,
                style: AppFonts.h1.copyWith(
                  color: step.color.withValues(alpha: 0.2),
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -2,
                ),
              ),
              Icon(step.icon, color: step.color, size: 40),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            step.subtitle,
            style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 15, height: 1.6),
          ),
        ],
      ),
    );
  }
}
