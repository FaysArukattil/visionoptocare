import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/visiaxx_intro_section.dart';
import 'sections/clinical_tests_page.dart';
import 'sections/reports_wellness_page.dart';
import 'sections/philosophy_section.dart';
import 'sections/founders_section.dart';
import 'sections/b2b_page.dart';
import 'sections/footer_section.dart';
import 'sections/hero_animation_engine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  int _currentPage = 0;
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0.0);

  static const int _totalPages = 9;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    final rawPage = _pageController.page ?? 0.0;
    _scrollProgress.value = rawPage;
    final page = rawPage.round();
    if (page != _currentPage && mounted) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _scrollProgress.dispose();
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

  /// Only enable tickers for the current page and its immediate neighbours.
  /// This automatically pauses ALL AnimationControllers in off-screen pages,
  /// eliminating the 20+ simultaneous repeat-animation jitter.
  bool _isTickerActive(int pageIndex) {
    return (_currentPage - pageIndex).abs() <= 1;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = size.width < 768;

    final pages = <Widget>[
      // Page 0: Hero — Typewriter
      HeroSection(
        isActive: _currentPage == 0,
        onScrollDown: () => _goToPage(1),
      ),
      // Page 1: What is Visiaxx?
      VisiaxxIntroSection(isActive: _currentPage == 1),
      // Page 2: 12 Clinical Tests
      ClinicalTestsPage(isActive: _currentPage == 2),
      // Page 3: PDF + Reels + Ocular Wellness
      ReportsWellnessPage(isActive: _currentPage == 3),
      // Page 4: Hybrid Consultations + Languages
      ConsultationLanguagesPage(isActive: _currentPage == 4),
      // Page 5: Philosophy
      PhilosophySection(isActive: _currentPage == 5),
      // Page 6: B2B — Practitioner Licensing
      B2BPage(isActive: _currentPage == 6),
      // Page 7: Founders
      FoundersSection(isActive: _currentPage == 7),
      // Page 8: Footer
      FooterSection(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Main Page View ──
          PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const _SnapPagePhysics(),
            children: List.generate(pages.length, (i) {
              return RepaintBoundary(
                child: TickerMode(
                  enabled: _isTickerActive(i),
                  child: pages[i],
                ),
              );
            }),
          ),

          // ── Snellen E → Iris Transition Overlay (Pages 0→1 only) ──
          ValueListenableBuilder<double>(
            valueListenable: _scrollProgress,
            builder: (context, progress, _) {
              if (progress <= 0.05 || progress >= 0.92) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: Opacity(
                      opacity: _bellCurveOpacity(progress, 0.05, 0.92, 0.65),
                      child: HeroAnimationEngine(
                        p: progress.clamp(0.0, 1.0),
                        isMob: isMob,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Navbar (always on top) ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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

  double _bellCurveOpacity(double p, double start, double end, double maxOpacity) {
    if (p <= start || p >= end) return 0.0;
    final mid = (start + end) / 2;
    if (p < mid) {
      final t = (p - start) / (mid - start);
      return maxOpacity * Curves.easeOutCubic.transform(t);
    } else {
      final t = (p - mid) / (end - mid);
      return maxOpacity * (1.0 - Curves.easeInCubic.transform(t));
    }
  }
}

// ─────────────────────────────────────────────
// Snap Physics — buttery smooth with higher damping
// ─────────────────────────────────────────────
class _SnapPagePhysics extends ScrollPhysics {
  const _SnapPagePhysics({super.parent});

  @override
  _SnapPagePhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapPagePhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 0.6,
        stiffness: 100,
        damping: 18,
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
