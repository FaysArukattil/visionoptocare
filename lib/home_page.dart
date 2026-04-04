import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/visiaxx_intro_section.dart';
import 'sections/clinical_tests_page.dart';
import 'sections/reports_wellness_page.dart';
import 'sections/philosophy_section.dart';
import 'sections/b2b_page.dart';
import 'sections/leadership_section.dart';
import 'sections/team_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_animation_engine.dart';
import 'widgets/section_transitions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;

  // Track page indices separately to avoid full-tree rebuilds.
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final ValueNotifier<double> _scrollProgress = ValueNotifier(0.0);
  // Track raw scroll for section transitions
  final ValueNotifier<double> _rawScrollProgress = ValueNotifier(0.0);

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

    // Feed raw scroll to transition overlay
    _rawScrollProgress.value = rawPage;

    // Hero iris transition (only pages 0→1)
    if (rawPage <= 1.2 || _scrollProgress.value <= 1.2) {
      _scrollProgress.value = rawPage;
    }

    final page = rawPage.round().clamp(0, _totalPages - 1);
    if (page != _currentPage.value) {
      _currentPage.value = page;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _currentPage.dispose();
    _scrollProgress.dispose();
    _rawScrollProgress.dispose();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Continuous Scroll with optimized Performance ──
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false, overscroll: false),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
              cacheExtent: size.height * 2,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return SizedBox(
                        height: size.height,
                        child: RepaintBoundary(
                          child: ValueListenableBuilder<int>(
                            valueListenable: _currentPage,
                            builder: (context, activeIdx, child) {
                              // Enable tickers for active page ± 1 for smooth transitions
                              final bool isNearActive = (activeIdx - i).abs() <= 1;
                              return TickerMode(
                                enabled: isNearActive,
                                child: _buildSection(i, activeIdx == i),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    childCount: _totalPages,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: true,
                  ),
                ),
              ],
            ),
          ),

          // ── Hero IRIS Transition (Pages 0→1) ──
          ValueListenableBuilder<double>(
            valueListenable: _scrollProgress,
            builder: (context, progress, _) {
              if (progress < -0.1 || progress > 1.1) {
                return const SizedBox.shrink();
              }

              final double t = progress.clamp(0.0, 1.0);
              if (t <= 0.01 || t >= 0.99) return const SizedBox.shrink();

              return Positioned.fill(
                child: IgnorePointer(
                  child: RepaintBoundary(
                    child: Opacity(
                      opacity: _bellCurveOpacity(t, 0.05, 0.95, 0.6),
                      child: HeroAnimationEngine(p: t, isMob: isMob),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Section Transition Overlays (Pages 1→9) ──
          ValueListenableBuilder<double>(
            valueListenable: _rawScrollProgress,
            builder: (context, raw, _) {
              if (raw < 0.9 || raw > _totalPages - 0.5) {
                return const SizedBox.shrink();
              }
              return SectionTransitionOverlay(
                scrollProgress: raw,
                totalPages: _totalPages,
              );
            },
          ),

          // ── Overlay UI (Navbar & Indicators) ──
          _buildOverlays(isMob),
        ],
      ),
    );
  }

  Widget _buildSection(int index, bool isActive) {
    switch (index) {
      case 0:
        return HeroSection(
          isActive: isActive,
          onScrollDown: () => _goToPage(1),
        );
      case 1:
        return VisiaxxIntroSection(isActive: isActive);
      case 2:
        return ClinicalTestsPage(isActive: isActive);
      case 3:
        return ReportsWellnessPage(isActive: isActive);
      case 4:
        return ConsultationLanguagesPage(isActive: isActive);
      case 5:
        return B2BPage(isActive: isActive); // ← B2B before Philosophy
      case 6:
        return PhilosophySection(isActive: isActive); // ← Philosophy after B2B
      case 7:
        return LeadershipSection(isActive: isActive);
      case 8:
        return TeamSection(isActive: isActive);
      case 9:
        return const FooterSection();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildOverlays(bool isMob) {
    return Stack(
      children: [
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
    );
  }

  double _bellCurveOpacity(
    double p,
    double start,
    double end,
    double maxOpacity,
  ) {
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
