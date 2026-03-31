import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/stats_section.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = _scrollController.offset > 50;
    if (scrolled != _isScrolled) {
      setState(() => _isScrolled = scrolled);
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
              // Section 2: Hero
              SliverToBoxAdapter(child: HeroSection()),
              // Section 3: Stats
              SliverToBoxAdapter(child: StatsSection()),
              // Section 4: Story
              SliverToBoxAdapter(child: StorySection()),
              // Section 5: 12 Tests (sticky scroll)
              SliverPersistentHeader(
                pinned: true,
                delegate: TestsSectionDelegate(
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              ),
              // Section 6: Therapy
              SliverToBoxAdapter(child: TherapySection()),
              // Section 7: Consultation
              SliverToBoxAdapter(child: ConsultSection()),
              // Section 8: Languages
              SliverToBoxAdapter(child: LanguageSection()),
              // Section 9: B2B
              SliverToBoxAdapter(child: B2BSection()),
              // Section 10: Reels & Articles
              SliverToBoxAdapter(child: ReelsSection()),
              // Section 11: Download CTA
              SliverToBoxAdapter(child: DownloadSection()),
              // Section 12: Footer
              SliverToBoxAdapter(child: FooterSection()),
            ],
          ),
          // Section 1: Navbar (overlay)
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
