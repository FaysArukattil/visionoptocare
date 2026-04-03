import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/visiaxx_intro_section.dart';
import 'sections/clinical_tests_page.dart';
import 'sections/reports_wellness_page.dart';
import 'sections/philosophy_section.dart';
import 'sections/leadership_section.dart';
import 'sections/team_section.dart';
import 'sections/b2b_page.dart';
import 'sections/footer_section.dart';
import 'sections/hero_animation_engine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;

  // Use ValueNotifiers instead of setState to avoid full-tree rebuilds
  // during scrolling — this is the key to smooth performance.
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0.0);

  static const int _totalPages = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final vh = _scrollController.position.viewportDimension;
    if (vh <= 0) return;

    final rawPage = offset / vh;
    _scrollProgress.value = rawPage;
    _currentPage.value = rawPage.round().clamp(0, _totalPages - 1);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _currentPage.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index < 0 || index >= _totalPages) return;
    if (!_scrollController.hasClients) return;
    final vh = _scrollController.position.viewportDimension;
    _scrollController.animateTo(
      index * vh,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = size.width < 768;

    // Build pages once — they don't depend on _currentPage anymore.
    // Section entry animations use their own internal visibility detection.
    final pages = <Widget>[
      HeroSection(isActive: true, onScrollDown: () => _goToPage(1)),
      const VisiaxxIntroSection(isActive: true),
      const ClinicalTestsPage(isActive: true),
      const ReportsWellnessPage(isActive: true),
      const ConsultationLanguagesPage(isActive: true),
      const PhilosophySection(isActive: true),
      const B2BPage(isActive: true),
      const LeadershipSection(isActive: true),
      const TeamSection(isActive: true),
      const FooterSection(),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Buttery smooth continuous scroll ──
          CustomScrollView(
            controller: _scrollController,
            // Default physics — let the platform decide (smooth on web)
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return RepaintBoundary(
                      child: SizedBox(
                        height: size.height,
                        child: pages[i],
                      ),
                    );
                  },
                  childCount: pages.length,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: false, // We add our own above
                ),
              ),
            ],
          ),

          // ── Hero Transition Overlay (Pages 0→1) ──
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

          // ── Navbar — rebuilds only when currentPage changes ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: _currentPage,
              builder: (context, page, _) => NavbarSection(
                isScrolled: page > 0,
                currentPage: page,
                onNavTap: _goToPage,
              ),
            ),
          ),

          // ── Page Indicator (desktop) ──
          if (!isMob)
            Positioned(
              right: 24,
              top: 0,
              bottom: 0,
              child: Center(
                child: ValueListenableBuilder<int>(
                  valueListenable: _currentPage,
                  builder: (context, page, _) => _PageIndicator(
                    total: _totalPages,
                    current: page,
                    onTap: _goToPage,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _bellCurveOpacity(
      double p, double start, double end, double maxOpacity) {
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
