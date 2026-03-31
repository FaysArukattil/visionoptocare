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
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: AppColors.surfaceLight, width: 3),
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.accent2.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: Column(
          children: [
            // Notch
            Container(
              height: 32,
              color: AppColors.background,
              child: Center(
                child: Container(
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            // Screen content
            Expanded(
              child: Container(
                color: AppColors.backgroundLight,
                child: screen,
              ),
            ),
            // Bottom bar
            Container(
              height: 20,
              color: AppColors.background,
              child: Center(
                child: Container(
                  width: 100,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
