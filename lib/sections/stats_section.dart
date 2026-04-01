import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/animated_counter.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.8),
          border: const Border.symmetric(
            horizontal: BorderSide(color: AppColors.surfaceLight, width: 0.5),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.surface.withValues(alpha: 0.1),
              AppColors.background,
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100, horizontal: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: isMob ? 40 : 120,
          runSpacing: 40,
          children: const [
            AnimatedCounter(target: 12, suffix: '+', label: 'CLINICAL TESTS'),
            AnimatedCounter(target: 13, label: 'LOCAL LANGUAGES'),
            AnimatedCounter(target: 37, suffix: '+', label: 'THERAPY TRACKS'),
            AnimatedCounter(target: 2, label: 'CARE TIERS'),
          ],
        ),
      ),
    );
  }
}
