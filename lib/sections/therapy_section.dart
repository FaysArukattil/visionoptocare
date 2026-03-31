import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/tilt_card.dart';
import '../widgets/gradient_button.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class _GameData {
  final String name, desc;
  final IconData icon;
  const _GameData(this.name, this.desc, this.icon);
}

const _games = [
  _GameData('Brick Ball', 'Reaction and focus training', Icons.sports_esports),
  _GameData('Color Rush', 'Color recognition speed', Icons.color_lens),
  _GameData('Ocular Snake', 'Saccadic eye movement', Icons.swap_calls),
  _GameData('Word Puzzle', 'Visual search training', Icons.abc),
];

class TherapySection extends StatefulWidget {
  const TherapySection({super.key});
  @override
  State<TherapySection> createState() => _TherapySectionState();
}

class _TherapySectionState extends State<TherapySection>
    with SingleTickerProviderStateMixin {
  late AnimationController _vinylCtrl;

  @override
  void initState() {
    super.initState();
    _vinylCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _vinylCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
        child: Column(
          children: [
            Padding(
              padding: Responsive.padding(context),
              child: Text('Train Your Eyes\nLike an Athlete', style: AppFonts.h2.copyWith(color: AppColors.white), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 60),
            // Game cards scroll
            SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: Responsive.padding(context),
                itemCount: _games.length,
                itemBuilder: (ctx, i) {
                  final g = _games[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: SizedBox(
                      width: isMob ? 240 : 280,
                      child: TiltCard(
                        glowColor: AppColors.accent2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.surfaceLight, AppColors.surface],
                            ),
                          ),
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 56, height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: AppColors.tealGradient,
                                ),
                                child: Icon(g.icon, color: AppColors.background, size: 28),
                              ),
                              const SizedBox(height: 24),
                              Text(g.name, style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: 22)),
                              const SizedBox(height: 8),
                              Text(g.desc, style: AppFonts.bodyMedium),
                              const Spacer(),
                              GradientButton(text: 'Play', gradient: AppColors.tealGradient, height: 40, onTap: () {}),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            // Vinyl animation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _vinylCtrl,
                  builder: (_, __) => Transform.rotate(
                    angle: _vinylCtrl.value * 2 * pi,
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceLight,
                        border: Border.all(color: AppColors.muted.withOpacity(0.3), width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 12, height: 12,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.accent2),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text('37 curated tracks in our Music Library', style: AppFonts.bodyMedium.copyWith(color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
