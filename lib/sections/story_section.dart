import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});
  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> {
  double _dividerPos = 0.5;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
        child: Column(
          children: [
            // Before / After slider
            Padding(
              padding: Responsive.padding(context),
              child: SizedBox(
                height: isMob ? 300 : 450,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dividerPos = (details.localPosition.dx / constraints.maxWidth).clamp(0.05, 0.95);
                        });
                      },
                      child: Stack(
                        children: [
                          // "After" panel (full color, right)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1A2540), Color(0xFF0F1A30)],
                                ),
                              ),
                              child: _buildAfterPanel(constraints),
                            ),
                          ),
                          // "Before" panel (grayscale, left)
                          Positioned(
                            left: 0, top: 0, bottom: 0,
                            width: constraints.maxWidth * _dividerPos,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                              child: Container(
                                color: const Color(0xFF15192A),
                                child: _buildBeforePanel(constraints),
                              ),
                            ),
                          ),
                          // Divider handle
                          Positioned(
                            left: constraints.maxWidth * _dividerPos - 20,
                            top: 0, bottom: 0,
                            child: Center(
                              child: Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.accent2,
                                  boxShadow: [BoxShadow(color: AppColors.accent2.withOpacity(0.4), blurRadius: 15)],
                                ),
                                child: const Icon(Icons.swap_horiz, color: AppColors.background, size: 22),
                              ),
                            ),
                          ),
                          // Divider line
                          Positioned(
                            left: constraints.maxWidth * _dividerPos - 1,
                            top: 0, bottom: 0,
                            child: Container(width: 2, color: AppColors.accent2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Your eye clinic. Now in your pocket.',
              style: AppFonts.h3.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeforePanel(BoxConstraints constraints) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital, size: 64, color: AppColors.muted.withOpacity(0.5)),
                const SizedBox(height: 16),
                Text('Crowded Clinic', style: AppFonts.bodyLarge.copyWith(color: AppColors.muted)),
                Text('Long waits. Limited access.', style: AppFonts.bodySmall.copyWith(color: AppColors.muted.withOpacity(0.6))),
              ],
            ),
          ),
          Positioned(
            top: 16, left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.muted.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('BEFORE', style: AppFonts.caption.copyWith(color: AppColors.muted)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterPanel(BoxConstraints constraints) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 64, color: AppColors.accent2.withOpacity(0.8)),
              const SizedBox(height: 16),
              Text('Your Couch', style: AppFonts.bodyLarge.copyWith(color: AppColors.white)),
              Text('12 tests. Instant results.', style: AppFonts.bodySmall.copyWith(color: AppColors.accent2)),
            ],
          ),
        ),
        Positioned(
          top: 16, right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent2.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('AFTER', style: AppFonts.caption.copyWith(color: AppColors.accent2)),
          ),
        ),
      ],
    );
  }
}
