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
                    builder: (context, _) => CustomPaint(
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
          final y = sin(a) * radius * 0.4; // Elliptical for 3D feel
          final z = sin(a); // depth
          final scale = 0.8 + 0.2 * ((z + 1) / 2);
          final opacity = (0.3 + 0.7 * ((z + 1) / 2)).clamp(0.0, 1.0);
          
          return Transform.translate(
            offset: Offset(x, y),
            child: Transform.scale(
              scale: _selectedLang == i ? 1.2 : scale,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            ),
          );
        },
        child: GestureDetector(
          onTap: () => setState(() => _selectedLang = i),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _selectedLang == i
                    ? AppColors.gold.withValues(alpha: 0.2)
                    : AppColors.surface.withValues(alpha: 0.9),
                border: Border.all(
                  color: _selectedLang == i ? AppColors.gold : AppColors.white.withValues(alpha: 0.1),
                  width: _selectedLang == i ? 2 : 1,
                ),
                boxShadow: [
                  if (_selectedLang == i)
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: Text(
                _languages[i],
                style: AppFonts.bodySmall.copyWith(
                  color: _selectedLang == i ? AppColors.gold : AppColors.white.withValues(alpha: 0.8),
                  fontWeight: _selectedLang == i ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
