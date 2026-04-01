import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'sections/navbar_section.dart';
import 'sections/hero_section.dart';
import 'sections/tests_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  double _heroProgress = 0.0;

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
              // 1. Hero (3D Scroll Animation - height 2*screenH)
              SliverToBoxAdapter(
                child: HeroSection(scrollProgress: _heroProgress),
              ),

              // 2. Interactive Diagnostic Hub
              const SliverToBoxAdapter(
                child: TestsSection(),
              ),
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
