import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/globe_painter.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

const _languages = [
  'English', 'Hindi', 'Marathi', 'Malayalam', 'Tamil', 'Telugu',
  'Kannada', 'Bengali', 'Gujarati', 'Punjabi', 'Odia', 'Urdu', 'Assamese',
];

class LanguageSection extends StatefulWidget {
  const LanguageSection({super.key});
  @override
  State<LanguageSection> createState() => _LanguageSectionState();
}

class _LanguageSectionState extends State<LanguageSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _globeCtrl;
  int _selectedLang = -1;

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
    final globeSize = isMob ? 220.0 : 320.0;
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
        child: Column(
          children: [
            Text('Speaking Your Language', style: AppFonts.h2.copyWith(color: AppColors.white), textAlign: TextAlign.center),
            const SizedBox(height: 60),
            // Globe with orbiting pills
            SizedBox(
              width: isMob ? 340 : 600,
              height: isMob ? 340 : 600,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Globe
                  AnimatedBuilder(
                    animation: _globeCtrl,
                    builder: (_, __) => CustomPaint(
                      size: Size(globeSize, globeSize),
                      painter: GlobePainter(rotation: _globeCtrl.value * 2 * pi),
                    ),
                  ),
                  // Language pills orbiting
                  ..._buildLanguagePills(isMob ? 150.0 : 250.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLanguagePills(double radius) {
    return List.generate(_languages.length, (i) {
      final angle = (i / _languages.length) * 2 * pi;
      return AnimatedBuilder(
        animation: _globeCtrl,
        builder: (_, child) {
          final a = angle + _globeCtrl.value * 2 * pi * 0.3;
          final x = cos(a) * radius;
          final y = sin(a) * radius * 0.5; // Elliptical for 3D feel
          final z = sin(a); // depth
          final scale = 0.7 + 0.3 * ((z + 1) / 2);
          final opacity = 0.4 + 0.6 * ((z + 1) / 2);
          return Transform.translate(
            offset: Offset(x, y),
            child: Transform.scale(
              scale: scale,
              child: Opacity(opacity: opacity, child: child),
            ),
          );
        },
        child: GestureDetector(
          onTap: () => setState(() => _selectedLang = i),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _selectedLang == i
                    ? AppColors.accent2.withOpacity(0.3)
                    : AppColors.surface.withOpacity(0.8),
                border: Border.all(
                  color: _selectedLang == i ? AppColors.accent2 : AppColors.surfaceLight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _selectedLang == i
                        ? AppColors.accent2.withOpacity(0.3)
                        : Colors.transparent,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Text(
                _languages[i],
                style: AppFonts.bodySmall.copyWith(
                  color: _selectedLang == i ? AppColors.accent2 : AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
