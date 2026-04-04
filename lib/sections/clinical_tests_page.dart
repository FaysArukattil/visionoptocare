import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/responsive.dart';
import 'tests_section.dart';

class ClinicalTestsPage extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;
  const ClinicalTestsPage({super.key, required this.isActive, this.scrollProgress});

  @override
  State<ClinicalTestsPage> createState() => _ClinicalTestsPageState();
}

class _ClinicalTestsPageState extends State<ClinicalTestsPage> {


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.background,
      child: Stack(
        children: [
          // ── Main Content ──
          Padding(
            padding: EdgeInsets.only(
              top: isMob ? 80 : 90, // Clear the navbar
              left: isMob ? 24 : 60,
              right: isMob ? 24 : 60,
              bottom: 24,
            ),
            child: TestsSection(
              isActive: widget.isActive, 
              scrollProgress: widget.scrollProgress
            ),
          ),
          
          // Subtle side grain or UI accents
          if (!isMob)
            Positioned(
              left: 20, top: 0, bottom: 0,
              child: Center(
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'DIAGNOSTIC PROTOCOL v2.0',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.05), fontSize: 10, letterSpacing: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
