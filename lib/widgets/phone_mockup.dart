import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PhoneMockup extends StatelessWidget {
  final Widget screen;
  final double width;
  final double height;

  const PhoneMockup({
    super.key,
    required this.screen,
    this.width = 280,
    this.height = 560,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44), // Slightly less rounded for a taller look
        color: const Color(0xFF020617),
        boxShadow: [
          // Outer Glow
          BoxShadow(
            color: AppColors.accent2.withValues(alpha: 0.08),
            blurRadius: 60,
            spreadRadius: 10,
          ),
          // Sharp Shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 40,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0), // Consistent thin bezel
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(37),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: Stack(
              children: [
                // Screen content
                Positioned.fill(
                  child: Container(
                    color: AppColors.backgroundLight,
                    child: screen,
                  ),
                ),

                // Glass Reflection Sweep (Refined)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.white.withValues(alpha: 0.03),
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.01),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Indicator Bar
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
