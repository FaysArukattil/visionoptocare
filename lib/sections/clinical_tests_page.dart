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
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - t)),
            child: Container(
              width: size.width,
              height: size.height,
              color: AppColors.background,
              child: Column(
                children: [
                  SizedBox(height: isMob ? 80 : 90), // Navbar clearance
                  // Header
                  Padding(
                    padding: Responsive.padding(context),
                    child: Column(
                      children: [
                        Text(
                          'TECHNICAL EXCELLENCE & ECOSYSTEM',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.accent2,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '12 Clinical Tests',
                          style: AppFonts.h2.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 28 : 48,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Clinical-grade optometry directly on your smartphone, analyzing multiple dimensions of your ocular health using advanced computer vision and AI.',
                          style: AppFonts.bodyLarge.copyWith(
                            color: AppColors.muted,
                            fontSize: isMob ? 14 : 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tests carousel fills remaining height
                  Expanded(
                    child: Padding(
                      padding: Responsive.padding(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.accent2.withValues(alpha: 0.1),
                            ),
                          ),
                          child: const TestsSection(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
