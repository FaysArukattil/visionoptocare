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
        borderRadius: BorderRadius.circular(54), // More rounded premium look
        color: const Color(0xFF020617),
        boxShadow: [
          // Outer Glow
          BoxShadow(
            color: AppColors.accent2.withValues(alpha: 0.1),
            blurRadius: 60,
            spreadRadius: 20,
          ),
          // Sharp Shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // The Bezel
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(46),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(44),
            child: Stack(
              children: [
                // Screen content
                Positioned.fill(
                  child: Container(
                    color: AppColors.backgroundLight,
                    child: screen,
                  ),
                ),

                // Premium Dynamic Island
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 90,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.05),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Small Lens circle
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E293B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                ),

                // Glass Reflection Sweep
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.02),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Indicator Bar
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
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
