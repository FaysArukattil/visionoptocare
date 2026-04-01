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

class _TherapySectionState extends State<TherapySection> with SingleTickerProviderStateMixin {
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
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 120),
        child: Column(
          children: [
            Padding(
              padding: Responsive.padding(context),
              child: Column(
                children: [
                  Text(
                    'REHABILITATION & GAMING',
                    style: AppFonts.caption.copyWith(color: AppColors.accent2, letterSpacing: 4, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Train Your Eyes\nLike an Athlete',
                    style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.1),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            // Game cards scroll
            SizedBox(
              height: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: Responsive.padding(context),
                itemCount: _games.length,
                itemBuilder: (ctx, i) {
                  final g = _games[i];
                  return Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: SizedBox(
                      width: isMob ? 260 : 300,
                      child: TiltCard(
                        glowColor: AppColors.accent2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1E263E), Color(0xFF0F1425)],
                            ),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64, height: 64,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: AppColors.tealGradient,
                                  boxShadow: [
                                    BoxShadow(color: AppColors.accent2.withValues(alpha: 0.3), blurRadius: 20)
                                  ],
                                ),
                                child: Icon(g.icon, color: AppColors.background, size: 32),
                              ),
                              const SizedBox(height: 32),
                              Text(g.name, style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(
                                g.desc,
                                style: AppFonts.bodyMedium.copyWith(color: AppColors.muted, height: 1.5),
                              ),
                              const Spacer(),
                              GradientButton(
                                text: 'Play Game',
                                gradient: AppColors.blueGradient,
                                height: 44,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
            // Music / Vinyl Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _vinylCtrl,
                    builder: (context, _) => Transform.rotate(
                      angle: _vinylCtrl.value * 2 * pi,
                      child: Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF000000),
                          border: Border.all(color: const Color(0xFF1A1A1A), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent2.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 14, height: 14,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0F1A30),
                            ),
                            child: Center(
                              child: Container(
                                width: 4, height: 4,
                                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.accent2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '37 CURATED TRACKS',
                        style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Therapeutic background music library.',
                        style: AppFonts.bodySmall.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
