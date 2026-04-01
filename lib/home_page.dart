import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/eye_scroll_section.dart';
import 'sections/story_section.dart';
import 'sections/tests_section.dart';
import 'sections/therapy_section.dart';
import 'sections/consult_section.dart';
import 'sections/language_section.dart';
import 'sections/b2b_section.dart';
import 'sections/reels_section.dart';
import 'sections/download_section.dart';
import 'sections/footer_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  double _heroProgress = 0.0;
  double _eyeProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 50;
    if (scrolled != _isScrolled) {
      if (mounted) setState(() => _isScrolled = scrolled);
    }
    
    final screenH = MediaQuery.of(context).size.height;
    
    // 1. Hero Progress (0 -> 1.0 over 1 screen height = brand to dashboard)
    final hProgress = (_scrollController.offset / screenH).clamp(0.0, 1.0);
    if (mounted) setState(() => _heroProgress = hProgress);

    // 2. Eye Progress (Section 2 - Scroll driven video)
    final eyeStart = screenH * 1.0;
    final eyeEnd = screenH * 2.5;
    final progress = (_scrollController.offset - eyeStart) / (eyeEnd - eyeStart);
    if (progress >= -1.0 && progress <= 2.0) {
      if (mounted) {
        setState(() => _eyeProgress = progress.clamp(0.0, 1.0));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 1. Hero (3D Scroll Animation)
              SliverToBoxAdapter(
                child: HeroSection(scrollProgress: _heroProgress),
              ),
              
              // New: Eye Scroll Section (controlled playback)
              SliverToBoxAdapter(child: EyeScrollSection(scrollProgress: _eyeProgress)),

              // 3. Story Transition
              const SliverToBoxAdapter(child: StorySection()),

              // 4. 12 Tests (sticky scroll)
              SliverPersistentHeader(
                pinned: true,
                delegate: TestsSectionDelegate(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),

              // 5. Eye Therapy
              const SliverToBoxAdapter(child: TherapySection()),

              // 6. Consultations
              const SliverToBoxAdapter(child: ConsultSection()),

              // 7. Languages (Globe)
              const SliverToBoxAdapter(child: LanguageSection()),

              // 8. B2B Pro
              const SliverToBoxAdapter(child: B2BSection()),

              // 9. Reels & Articles
              const SliverToBoxAdapter(child: ReelsSection()),

              // 10. Download App
              const SliverToBoxAdapter(child: DownloadSection()),

              // 11. Footer
              const SliverToBoxAdapter(child: FooterSection()),
            ],
          ),
          
          // Navbar (Overlay)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavbarSection(isScrolled: _isScrolled),
          ),
        ],
      ),
    );
  }
}
