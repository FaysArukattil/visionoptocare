import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';
import '../widgets/animated_counter.dart';
import '../widgets/globe_painter.dart';
import '../widgets/phone_mockup.dart';
import 'tests_section.dart';

class EcosystemHubSection extends StatelessWidget {
  const EcosystemHubSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 160),
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          children: [
            // Section Header
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
                  const SizedBox(height: 24),
                  Text(
                    'The Complete Vision\nTest Application',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.white, 
                      fontSize: isMob ? 32 : 56, 
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Everything you need from clinical screening to offline care booking, consolidated in one unified, easy-to-use platform.',
                    style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            // Bulletproof Layout Grid
            Padding(
              padding: Responsive.padding(context),
              child: isMob ? _buildMobileGrid() : _buildDesktopGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopGrid() {
    // We use explicit heights on Rows to prevent Expanded/RenderFlex crashes in scrolling parents
    return Column(
      children: [
        // Row 1: 12 Clinical Tests (Full Width)
        _FeatureBentoCard(
          title: '12 Clinical Tests',
          subtitle: 'Our platform brings clinical-grade optometry directly to your smartphone, analyzing multiple dimensions of your ocular health using advanced computer vision and AI.',
          icon: Icons.biotech,
          color: AppColors.accent2,
          child: const SizedBox(
            height: 700,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: TestsSection(),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Row 2: Smart Medical Reports (Full Width)
        _FeatureBentoCard(
          title: 'Smart Clinical PDF Reports',
          subtitle: 'Visiaxx auto-generates comprehensive, shareable PDF reports featuring detailed diagnostic breakdowns, grayscale maps, prescription data, and clinical risk analysis.',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFF00D4C8),
          child: const SizedBox(
            height: 220,
            width: double.infinity,
            child: _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
          ),
        ),
        const SizedBox(height: 24),

        // Row 3: Reels & Therapy
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: _FeatureBentoCard(
                title: 'Education Reels',
                subtitle: 'Read and watch valuable eye care video tips in a TikTok-style feed.',
                icon: Icons.play_circle_outline,
                color: const Color(0xFF4F6AFF),
                child: const SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: _AnimatedReelsFeed(color: Color(0xFF4F6AFF)),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: _FeatureBentoCard(
                title: 'Ocular Wellness',
                subtitle: 'Relax and rehabilitate with interactive eye therapy games accompanied by AI-generated Hindi eye care songs.',
                icon: Icons.headphones_outlined,
                color: const Color(0xFF9D4EDD),
                child: const SizedBox(
                  height: 280,
                  width: double.infinity,
                  child: _AnimatedOcularWellness(color: Color(0xFF9D4EDD)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Row 4: Consultations
        _FeatureBentoCard(
          title: 'Hybrid Consultations',
          subtitle: 'Connect with experts seamlessly. Book an online video consultation directly via the app, or request a convenient offline home visit from an optometrist or our dedicated salesperson.',
          icon: Icons.video_call_outlined,
          color: const Color(0xFFF5C842),
          child: const SizedBox(
            height: 200,
            width: double.infinity,
            child: _AnimatedConsultationNetwork(color: Color(0xFFF5C842)),
          ),
        ),
        const SizedBox(height: 24),

        // Row 5: 13 Local Languages
        _FeatureBentoCard(
          title: '13 Local Languages',
          subtitle: 'Eye health without borders. The App natively supports 13 major languages to bring digital primary optometry to patients worldwide.',
          icon: Icons.public,
          color: const Color(0xFFFF5252),
          child: const SizedBox(
            height: 350,
            width: double.infinity,
            child: _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileGrid() {
    return Column(
      children: [
        _FeatureBentoCard(
          title: '12 Clinical Tests',
          subtitle: 'Our vision test app brings clinical scrutiny directly to your smartphone, analyzing multiple dimensions of your ocular health.',
          icon: Icons.biotech,
          color: AppColors.accent2,
          isMobile: true,
          child: const SizedBox(
            height: 700,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: TestsSection(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Smart Clinical PDF Reports',
          subtitle: 'Instantly download and share your visual health reports as clean PDFs.',
          icon: Icons.picture_as_pdf_outlined,
          color: const Color(0xFF00D4C8),
          isMobile: true,
          child: const SizedBox(
            height: 150,
            width: double.infinity,
            child: _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Education Reels',
          subtitle: 'Read and watch valuable eye care video tips in a TikTok-style feed.',
          icon: Icons.play_circle_outline,
          color: const Color(0xFF4F6AFF),
          isMobile: true,
          child: const SizedBox(
            height: 250,
            width: double.infinity,
            child: _AnimatedReelsFeed(color: Color(0xFF4F6AFF)),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Ocular Wellness',
          subtitle: 'Eye therapy games accompanied by AI-generated therapeutic Hindi eye care songs.',
          icon: Icons.headphones_outlined,
          color: const Color(0xFF9D4EDD),
          isMobile: true,
          child: const SizedBox(
            height: 250,
            width: double.infinity,
            child: _AnimatedOcularWellness(color: Color(0xFF9D4EDD)),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: 'Hybrid Consultations',
          subtitle: 'Book online video consults or request offline home visits by an optometrist or our salesperson.',
          icon: Icons.video_call_outlined,
          color: const Color(0xFFF5C842),
          isMobile: true,
          child: const SizedBox(
             height: 200, 
             child: _AnimatedConsultationNetwork(color: Color(0xFFF5C842)),
          ),
        ),
        const SizedBox(height: 24),
        _FeatureBentoCard(
          title: '13 Local Languages',
          subtitle: 'The App is natively localized into 13 major languages.',
          icon: Icons.public,
          color: const Color(0xFFFF5252),
          isMobile: true,
          child: const SizedBox(
             height: 300, 
             child: _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
          ),
        ),
      ],
    );
  }




}

class _FeatureBentoCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget? child;
  final bool isMobile;

  const _FeatureBentoCard({
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.color,
    this.child,
    this.isMobile = false,
  });

  @override
  State<_FeatureBentoCard> createState() => _FeatureBentoCardState();
}

class _FeatureBentoCardState extends State<_FeatureBentoCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: RepaintBoundary(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
          builder: (context, v, _) {
            return Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Color.lerp(
                    AppColors.white.withValues(alpha: 0.05),
                    widget.color.withValues(alpha: 0.4),
                    v,
                  )!,
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1 * v),
                    blurRadius: 40,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(widget.icon, color: widget.color, size: 40),
                  const SizedBox(height: 32),
                  Text(
                    widget.title, 
                    style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: widget.isMobile ? 22 : 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.subtitle,
                    style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 15, height: 1.6),
                  ),
                  if (widget.child != null) ...[
                    const SizedBox(height: 32),
                    widget.child!,
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedLanguageGlobe extends StatefulWidget {
  final Color color;
  const _AnimatedLanguageGlobe({required this.color});
  @override
  State<_AnimatedLanguageGlobe> createState() => _AnimatedLanguageGlobeState();
}

class _AnimatedLanguageGlobeState extends State<_AnimatedLanguageGlobe> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final langs = ['English', 'Hindi', 'Marathi', 'Malayalam', 'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Gujarati', 'Punjabi', 'Odia', 'Urdu', 'Assamese'];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(painter: GlobePainter(rotation: _ctrl.value * math.pi * 2, gridColor: widget.color)),
              ),
            ),
            ...langs.asMap().entries.map((e) {
              final isMob = Responsive.isMobile(context);
              
              // Professional, elegant dual-ring system to prevent overlap
              final isOuter = e.key % 2 == 0;
              final direction = isOuter ? 1 : -1; // Rings rotate in opposite directions
              
              final angle = (e.key / langs.length) * math.pi * 2 + (_ctrl.value * math.pi * 2 * direction);
              
              final xRadius = isMob ? (isOuter ? 140.0 : 80.0) : (isOuter ? 340.0 : 160.0);
              final yRadius = isMob ? (isOuter ? 35.0 : 20.0) : (isOuter ? 80.0 : 40.0);

              final x = math.cos(angle) * xRadius;
              final y = math.sin(angle) * yRadius;
              
              final z = math.sin(angle); // depth projection
              final scale = (isOuter ? 0.85 : 0.65) + (z * 0.25); // Subtle scaling
              final opacity = 0.4 + ((z + 1) / 2) * 0.6; // Fade elements in the back
              
              return RepaintBoundary(
                child: Transform.translate(
                  offset: Offset(x, y),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: isMob ? 12 : 20, vertical: isMob ? 6 : 10),
                        decoration: BoxDecoration(
                          // Optimized Glass Look (removed BackdropFilter for performance)
                          color: AppColors.background.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: widget.color.withValues(alpha: 0.5), width: 1.5),
                          boxShadow: [
                            BoxShadow(color: widget.color.withValues(alpha: 0.2), blurRadius: 15),
                          ],
                        ),
                        child: Text(
                          e.value.toUpperCase(),
                          style: AppFonts.heading(color: Colors.white, fontSize: isMob ? 10 : 18, letterSpacing: 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Center(
               child: AnimatedCounter(target: 13, forceStart: true),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedPdfGenerator extends StatefulWidget {
  final Color color;
  const _AnimatedPdfGenerator({required this.color});

  @override
  State<_AnimatedPdfGenerator> createState() => _AnimatedPdfGeneratorState();
}

class _AnimatedPdfGeneratorState extends State<_AnimatedPdfGenerator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final progress = _ctrl.value;
          final isScanning = progress < 0.7;
          final scanPos = progress / 0.7;

          return Stack(
            alignment: Alignment.center,
            children: [
              // Floating background decor
              Positioned(
                left: 20,
                top: 20,
                child: Icon(Icons.picture_as_pdf, color: widget.color.withValues(alpha: 0.1), size: 100),
              ),
              
              // Central Document
              Container(
                width: 140,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: widget.color.withValues(alpha: 0.4), width: 2),
                  boxShadow: [
                    BoxShadow(color: widget.color.withValues(alpha: 0.2), blurRadius: 20, spreadRadius: 5),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    children: [
                      // Simulated Content lines
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 60, height: 8, color: widget.color.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Container(width: double.infinity, height: 4, color: widget.color.withValues(alpha: 0.1)),
                            const SizedBox(height: 8),
                            Container(width: double.infinity, height: 4, color: widget.color.withValues(alpha: 0.1)),
                            const SizedBox(height: 8),
                            Container(width: 80, height: 4, color: widget.color.withValues(alpha: 0.1)),
                            const SizedBox(height: 16),
                            // Simulated Data Grid
                            Row(
                              children: [
                                Container(width: 30, height: 30, decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.1), shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(width: 40, height: 4, color: widget.color.withValues(alpha: 0.1)),
                                      const SizedBox(height: 4),
                                      Container(width: 30, height: 4, color: widget.color.withValues(alpha: 0.1)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(width: double.infinity, height: 16, color: widget.color.withValues(alpha: progress > 0.8 ? 0.8 : 0.1)),
                          ],
                        ),
                      ),
                      
                      // Scanning laser effect
                      if (isScanning)
                        Positioned(
                          top: scanPos * 180,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: widget.color,
                              boxShadow: [
                                BoxShadow(color: widget.color, blurRadius: 8, spreadRadius: 2),
                              ],
                            ),
                          ),
                        ),
                        
                      // Processing overlay
                      if (!isScanning)
                        Positioned.fill(
                          child: Container(
                            color: AppColors.background.withValues(alpha: 0.8),
                            child: Center(
                              child: Icon(Icons.check_circle, color: widget.color, size: 40),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedReelsFeed extends StatefulWidget {
  final Color color;
  const _AnimatedReelsFeed({required this.color});
  @override
  State<_AnimatedReelsFeed> createState() => _AnimatedReelsFeedState();
}

class _AnimatedReelsFeedState extends State<_AnimatedReelsFeed> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }
  
  @override
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 0.7, 
        child: PhoneMockup(
          width: 160,
          height: 300,
          screen: ClipRect(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  final double itemHeight = 160.0;
                  final dy = -(_ctrl.value * itemHeight);
                  return SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Stack(
                      clipBehavior: Clip.none, 
                      children: [
                        Positioned(
                          top: dy,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(5, (index) {
                              return Container(
                                width: double.infinity, 
                                height: 150,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: widget.color.withValues(alpha: 0.2),
                                  image: const DecorationImage(
                                      image: NetworkImage('https://images.unsplash.com/photo-1551601651-2a8555f1a136?q=80&w=300&auto=format&fit=crop'),
                                    fit: BoxFit.cover,
                                    opacity: 0.5,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                        ),
                                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 30),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8, left: 8,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(width: 60, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2))),
                                          const SizedBox(height: 4),
                                          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(2))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedOcularWellness extends StatefulWidget {
  final Color color;
  const _AnimatedOcularWellness({required this.color});
  @override
  State<_AnimatedOcularWellness> createState() => _AnimatedOcularWellnessState();
}

class _AnimatedOcularWellnessState extends State<_AnimatedOcularWellness> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
  }
  
  @override
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(
                 height: 60,
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: List.generate(5, (i) {
                     final phase = i * 0.5;
                     final h = 20.0 + (math.sin((_ctrl.value * math.pi) + phase).abs() * 40.0);
                     return Container(
                       width: 8, height: h,
                       margin: const EdgeInsets.symmetric(horizontal: 4),
                       decoration: BoxDecoration(
                         color: widget.color.withValues(alpha: 0.8), 
                         borderRadius: BorderRadius.circular(4),
                         boxShadow: [
                           BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 8),
                         ],
                       ),
                     );
                   }),
                 ),
               ),
               const SizedBox(width: 32),
               Transform.translate(
                 offset: Offset(0, math.sin(_ctrl.value * math.pi) * 12),
                 child: Icon(Icons.sports_esports, color: widget.color, size: 64),
               ),
            ],
          );
        },
      ),
    );
  }
}

class _AnimatedConsultationNetwork extends StatefulWidget {
  final Color color;
  const _AnimatedConsultationNetwork({required this.color});
  @override
  State<_AnimatedConsultationNetwork> createState() => _AnimatedConsultationNetworkState();
}

class _AnimatedConsultationNetworkState extends State<_AnimatedConsultationNetwork> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }
  
  @override
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final val = _ctrl.value;
          return Center(
            child: SizedBox(
              width: isMob ? 300 : 500,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Doctor Profile (Left)
                  Positioned(
                    left: isMob ? 20 : 60,
                    child: _buildSyncNode(Icons.person, widget.color, 'DOCTOR'),
                  ),
                  
                  // 2. Patient Profile (Right)
                  Positioned(
                    right: isMob ? 20 : 60,
                    child: _buildSyncNode(Icons.face, Colors.white.withValues(alpha: 0.8), 'PATIENT'),
                  ),

                  // 3. Sync Beam (Connecting)
                  RepaintBoundary(
                    child: CustomPaint(
                      size: const Size(double.infinity, 50),
                      painter: _SyncLinkPainter(
                        progress: val,
                        color: widget.color,
                        isMob: isMob,
                      ),
                    ),
                  ),
                  
                  // 4. Traveling Data Packet (Pulse)
                  _buildSyncPulse(val, isMob),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSyncNode(IconData icon, Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 10),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppFonts.caption.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 8)),
      ],
    );
  }

  Widget _buildSyncPulse(double val, bool isMob) {
    final startX = isMob ? 60.0 : 100.0;
    final endX = isMob ? 240.0 : 400.0;
    final currentX = startX + (val * (endX - startX));

    return Positioned(
      left: currentX - 10,
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color,
          boxShadow: [
             BoxShadow(color: widget.color, blurRadius: 10, spreadRadius: 2),
          ],
        ),
      ),
    );
  }
}

class _SyncLinkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isMob;
  _SyncLinkPainter({required this.progress, required this.color, required this.isMob});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final startX = isMob ? 60.0 : 100.0;
    final endX = isMob ? 240.0 : 400.0;
    final y = size.height / 2;

    // Background Line
    canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);

    // Dynamic Wave (DNA-like or Data pulse)
    final path = Path();
    path.moveTo(startX, y);
    for (double i = startX; i <= endX; i += 2) {
      final wave = math.sin((i / 20) + (progress * math.pi * 2)) * 8;
      path.lineTo(i, y + wave);
    }
    canvas.drawPath(path, Paint()
      ..color = color.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(covariant _SyncLinkPainter old) => true;
}
