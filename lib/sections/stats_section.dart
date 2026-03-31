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
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.accent2, width: 2)),
        ),
        padding: EdgeInsets.symmetric(vertical: isMob ? 40 : 48, horizontal: 20),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 40,
          runSpacing: 30,
          children: const [
            AnimatedCounter(target: 12, suffix: '+', label: 'Eye Tests'),
            AnimatedCounter(target: 13, label: 'Languages'),
            AnimatedCounter(target: 37, label: 'Music Tracks'),
            AnimatedCounter(target: 2, label: 'Care Tiers'),
          ],
        ),
      ),
    );
  }
}
