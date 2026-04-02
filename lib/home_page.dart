import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/ecosystem_hub_section.dart';
import 'sections/philosophy_section.dart';
import 'sections/founders_section.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isScrolled = ValueNotifier<bool>(false);
  final ValueNotifier<double> _heroProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _isScrolled.value = _scrollController.offset > 50;
    
    // Efficiently calculate progress without triggering full build
    final screenH = MediaQuery.sizeOf(context).height;
    _heroProgress.value = (_scrollController.offset / screenH).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isScrolled.dispose();
    _heroProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 1. Hero Spotlight (3D Scroll Animation)
              SliverToBoxAdapter(
                child: ValueListenableBuilder<double>(
                  valueListenable: _heroProgress,
                  builder: (context, progress, child) {
                    return HeroSection(scrollProgress: progress);
                  },
                ),
              ),

              // 2. The App Ecosystem (Features Page)
              const SliverToBoxAdapter(
                child: RepaintBoundary(child: EcosystemHubSection()),
              ),

              // 5. Philosophy (Mission / Vision)
              const SliverToBoxAdapter(
                child: RepaintBoundary(child: PhilosophySection()),
              ),

              // 6 & 8. Leadership & Footer (Combined to allow overlapping)
              const SliverToBoxAdapter(
                child: Column(
                  children: [
                    FoundersSection(),
                    FooterSection(),
                  ],
                ),
              ),
            ],
          ),
          
          // Navbar (Overlay) - Isolated from page rebuilds
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isScrolled,
              builder: (context, scrolled, child) {
                return NavbarSection(isScrolled: scrolled);
              },
            ),
          ),
        ],
      ),
    );
  }
}
