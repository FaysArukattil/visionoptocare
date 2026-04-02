import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/visiaxx_intro_section.dart';
import 'sections/clinical_tests_page.dart';
import 'sections/reports_wellness_page.dart';
import 'sections/philosophy_section.dart';
import 'sections/founders_section.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const int _totalPages = 8;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = size.width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main Page View ──
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const _SnapPagePhysics(),
            children: [
              // Page 0: Hero — Typewriter
              HeroSection(
                isActive: _currentPage == 0,
                onScrollDown: () => _goToPage(1),
              ),

              // Page 1: What is Visiaxx?
              VisiaxxIntroSection(
                isActive: _currentPage == 1,
              ),

              // Page 2: 12 Clinical Tests
              ClinicalTestsPage(
                isActive: _currentPage == 2,
              ),

              // Page 3: PDF + Reels + Ocular Wellness
              ReportsWellnessPage(
                isActive: _currentPage == 3,
              ),

              // Page 4: Hybrid Consultations + Languages
              ConsultationLanguagesPage(
                isActive: _currentPage == 4,
              ),

              // Page 5: Philosophy
              PhilosophySection(
                isActive: _currentPage == 5,
              ),

              // Page 6: Founders
              FoundersSection(
                isActive: _currentPage == 6,
              ),

              // Page 7: Footer
              FooterSection(),
            ],
          ),

          // ── Navbar (always on top) ──
          Positioned(
            top: 0, left: 0, right: 0,
            child: NavbarSection(
              isScrolled: _currentPage > 0,
              currentPage: _currentPage,
              onNavTap: _goToPage,
            ),
          ),

          // ── Page Indicator (desktop only) ──
          if (!isMob)
            Positioned(
              right: 24,
              top: 0,
              bottom: 0,
              child: Center(
                child: _PageIndicator(
                  total: _totalPages,
                  current: _currentPage,
                  onTap: _goToPage,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Snap Physics — locks each page cleanly
// ─────────────────────────────────────────────
class _SnapPagePhysics extends ScrollPhysics {
  const _SnapPagePhysics({super.parent});

  @override
  _SnapPagePhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
}

// ─────────────────────────────────────────────
// Dot Page Indicator
// ─────────────────────────────────────────────
class _PageIndicator extends StatelessWidget {
  final int total;
  final int current;
  final void Function(int) onTap;

  const _PageIndicator({
    required this.total,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return GestureDetector(
          onTap: () => onTap(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: isActive ? 8 : 5,
            height: isActive ? 24 : 5,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.accent2
                  : AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
