import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import 'tests_section.dart';

class ClinicalTestsPage extends StatefulWidget {
  final bool isActive;
  const ClinicalTestsPage({super.key, required this.isActive});

  @override
  State<ClinicalTestsPage> createState() => _ClinicalTestsPageState();
}

class _ClinicalTestsPageState extends State<ClinicalTestsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant ClinicalTestsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_hasStarted) _start();
  }

  void _start() async {
    _hasStarted = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic).value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Container(
            width: size.width,
            height: size.height,
            color: AppColors.background,
            child: Stack(
              children: [
                // ── Main Content ──
                Column(
                  children: [
                    SizedBox(height: isMob ? 60 : 80), // Reduced header gap
                    
                    // Compact Header
                    Padding(
                      padding: Responsive.padding(context),
                      child: Column(
                        children: [
                          Text(
                            'TECHNICAL EXCELLENCE',
                            style: AppFonts.caption.copyWith(
                              color: AppColors.accent2,
                              letterSpacing: 4,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '12 Precision Diagnostics',
                            style: AppFonts.h2.copyWith(
                              color: AppColors.white,
                              fontSize: isMob ? 24 : 40,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    // ── The Suite (Full Expansion) ──
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: isMob ? 10 : 30),
                        child: TestsSection(isActive: widget.isActive),
                      ),
                    ),
                  ],
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
          ),
        );
      },
    );
  }
}
