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
        title: 'Accessibility',
        subtitle: 'Eye care shouldn\'t be a luxury. We are breaking geographical and economic barriers through mobile technology.',
        icon: Icons.public,
        color: AppColors.accent2,
      ),
      _PhilosophyStep(
        number: '02',
        title: 'Precision',
        subtitle: 'Our AI-driven algorithms provide clinical-grade screening, ensuring that your results are accurate and actionable.',
        icon: Icons.biotech,
        color: const Color(0xFF00D4C8),
      ),
      _PhilosophyStep(
        number: '03',
        title: 'Integrative Care',
        subtitle: 'From diagnostics to therapy and consultations, we offer a complete ecosystem for long-term ocular health.',
        icon: Icons.hub,
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
