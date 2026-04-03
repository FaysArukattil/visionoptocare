import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/globe_painter.dart';
import '../widgets/animated_counter.dart';

// ─────────────────────────────────────────────
// Page 3: Education Reels + PDF Reports + Ocular Wellness
// ─────────────────────────────────────────────
class ReportsWellnessPage extends StatefulWidget {
  final bool isActive;
  const ReportsWellnessPage({super.key, required this.isActive});

  @override
  State<ReportsWellnessPage> createState() => _ReportsWellnessPageState();
}

class _ReportsWellnessPageState extends State<ReportsWellnessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant ReportsWellnessPage old) {
    super.didUpdateWidget(old);
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
        final t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)
            .value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - t)),
            child: Container(
              width: size.width,
              height: size.height,
              color: AppColors.background,
              child: Column(
                children: [
                  SizedBox(height: isMob ? 100 : 120),
                  Padding(
                    padding: Responsive.padding(context),
                    child: Column(
                      children: [
                        Text(
                          'INSIGHT ENGINE',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.accent2,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Smart Reports, Eye Education & Wellness',
                          style: AppFonts.h2.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 20 : 38,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: Responsive.padding(context).copyWith(top: 0),
                      child: isMob
                          ? _buildMobileLayout()
                          : _buildDesktopLayout(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Left: Education Reels (phone mockup) ──
        Expanded(
          flex: 3,
          child: _BentoCard(
            title: 'Education Reels',
            subtitle:
                'Watch and learn with short, TikTok-style eye care video tips — curated to educate patients on vision health.',
            icon: Icons.play_circle_outline,
            color: const Color(0xFF4F6AFF),
            child:
                const _AnimatedReelsFeed(color: Color(0xFF4F6AFF)),
          ),
        ),
        const SizedBox(width: 20),
        // ── Right: PDF Reports + Ocular Wellness stacked ──
        Expanded(
          flex: 4,
          child: Column(
            children: [
              Expanded(
                child: _BentoCard(
                  title: 'Smart Clinical PDF Reports',
                  subtitle:
                      'Auto-generate comprehensive, shareable PDF reports featuring detailed diagnostic breakdowns, prescription data, and clinical risk analysis.',
                  icon: Icons.picture_as_pdf_outlined,
                  color: const Color(0xFF00D4C8),
                  child: const _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _BentoCard(
                  title: 'Ocular Wellness',
                  subtitle:
                      'Interactive eye therapy games with AI-generated therapeutic music for relaxation and rehabilitation.',
                  icon: Icons.headphones_outlined,
                  color: const Color(0xFF9D4EDD),
                  child: const _AnimatedOcularWellness(
                      color: Color(0xFF9D4EDD)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: _BentoCard(
              title: 'Education Reels',
              subtitle: 'Eye care video tips in a TikTok-style feed.',
              icon: Icons.play_circle_outline,
              color: const Color(0xFF4F6AFF),
              child: const SizedBox(
                height: 160,
                child: _AnimatedReelsFeed(color: Color(0xFF4F6AFF)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: _BentoCard(
              title: 'Smart Clinical PDF Reports',
              subtitle: 'Auto-generate comprehensive, shareable PDF reports.',
              icon: Icons.picture_as_pdf_outlined,
              color: const Color(0xFF00D4C8),
              child: const SizedBox(
                height: 120,
                child: _AnimatedPdfGenerator(color: Color(0xFF00D4C8)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: _BentoCard(
              title: 'Ocular Wellness',
              subtitle:
                  'Interactive eye therapy games with AI-generated music.',
              icon: Icons.headphones_outlined,
              color: const Color(0xFF9D4EDD),
              child: const SizedBox(
                height: 100,
                child: _AnimatedOcularWellness(color: Color(0xFF9D4EDD)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page 4: Hybrid Consultations + 13 Languages
// ─────────────────────────────────────────────
class ConsultationLanguagesPage extends StatefulWidget {
  final bool isActive;
  const ConsultationLanguagesPage({super.key, required this.isActive});

  @override
  State<ConsultationLanguagesPage> createState() =>
      _ConsultationLanguagesPageState();
}

class _ConsultationLanguagesPageState extends State<ConsultationLanguagesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant ConsultationLanguagesPage old) {
    super.didUpdateWidget(old);
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
        final t = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)
            .value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - t)),
            child: Container(
              width: size.width,
              height: size.height,
              color: AppColors.background,
              child: Column(
                children: [
                  SizedBox(height: isMob ? 100 : 120),
                  Padding(
                    padding: Responsive.padding(context),
                    child: Column(
                      children: [
                        Text(
                          'CONNECTED CARE',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.accent2,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Hybrid Consultations & Global Languages',
                          style: AppFonts.h2.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 20 : 38,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: Responsive.padding(context).copyWith(top: 0),
                      child: isMob
                          ? _buildMobileLayout()
                          : _buildDesktopLayout(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _BentoCard(
            title: 'Hybrid Consultations',
            subtitle:
                'Connect with experts seamlessly. Book an online video consultation directly via the app, or request a convenient offline home visit from an optometrist.',
            icon: Icons.video_call_outlined,
            color: const Color(0xFFF5C842),
            child: const _AnimatedConsultationNetwork(
                color: Color(0xFFF5C842)),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _BentoCard(
            title: '13 Local Languages',
            subtitle:
                'Eye health without borders. The App natively supports 13 major languages to bring digital primary optometry to patients worldwide.',
            icon: Icons.public,
            color: const Color(0xFFFF5252),
            child:
                const _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: _BentoCard(
              title: 'Hybrid Consultations',
              subtitle:
                  'Book online video consults or request offline home visits.',
              icon: Icons.video_call_outlined,
              color: const Color(0xFFF5C842),
              child: const SizedBox(
                height: 140,
                child: _AnimatedConsultationNetwork(
                    color: Color(0xFFF5C842)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 340,
            child: _BentoCard(
              title: '13 Local Languages',
              subtitle: 'Natively localized into 13 major languages.',
              icon: Icons.public,
              color: const Color(0xFFFF5252),
              child: const SizedBox(
                height: 200,
                child: _AnimatedLanguageGlobe(color: Color(0xFFFF5252)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared Bento Card
// ─────────────────────────────────────────────
class _BentoCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final Widget? child;

  const _BentoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.child,
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
        builder: (context, v, _) => Container(
          padding: EdgeInsets.all(isMob ? 20 : 32),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(isMob ? 24 : 32),
            border: Border.all(
              color: Color.lerp(
                AppColors.white.withValues(alpha: 0.06),
                widget.color.withValues(alpha: 0.4),
                v,
              )!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.08 * v),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMob ? 8 : 10),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon,
                        color: widget.color, size: isMob ? 20 : 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: AppFonts.h4.copyWith(
                        color: AppColors.white,
                        fontSize: isMob ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.subtitle,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted,
                  fontSize: isMob ? 12 : 13,
                  height: 1.6,
                ),
                maxLines: isMob ? 2 : 4,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.child != null) ...[
                const SizedBox(height: 12),
                Expanded(child: widget.child!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated: PDF Report Pipeline
// ─────────────────────────────────────────────
class _AnimatedPdfGenerator extends StatefulWidget {
  final Color color;
  const _AnimatedPdfGenerator({required this.color});
  @override
  State<_AnimatedPdfGenerator> createState() => _AnimatedPdfGeneratorState();
}

class _AnimatedPdfGeneratorState extends State<_AnimatedPdfGenerator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
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
          final p = _ctrl.value;
          // Phase 1: 0-0.3 (scanning), Phase 2: 0.3-0.6 (processing), Phase 3: 0.6-1.0 (complete)
          final phase1 = (p / 0.3).clamp(0.0, 1.0);
          final phase2 = ((p - 0.3) / 0.3).clamp(0.0, 1.0);
          final phase3 = ((p - 0.6) / 0.2).clamp(0.0, 1.0);
          final isComplete = p > 0.8;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left: Data metrics
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _metricRow('Visual Acuity', phase1, widget.color, isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _metricRow('Color Vision', (phase1 * 0.8).clamp(0.0, 1.0), const Color(0xFF4F6AFF), isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _metricRow('Astigmatism', phase2, const Color(0xFF9D4EDD), isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _metricRow('Contrast', (phase2 * 0.7).clamp(0.0, 1.0), const Color(0xFFF5C842), isMob),
                    ],
                  ),
                ),
              ),
              SizedBox(width: isMob ? 12 : 24),
              // Center: Document with progress
              SizedBox(
                width: isMob ? 70 : 100,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: isMob ? 70 : 100,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Document icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isMob ? 50 : 70,
                          height: isMob ? 60 : 85,
                          decoration: BoxDecoration(
                            color: isComplete
                                ? widget.color.withValues(alpha: 0.15)
                                : AppColors.background.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isComplete
                                  ? widget.color.withValues(alpha: 0.6)
                                  : widget.color.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withValues(alpha: isComplete ? 0.3 : 0.1),
                                blurRadius: isComplete ? 20 : 10,
                                spreadRadius: isComplete ? 2 : 0,
                              ),
                            ],
                          ),
                          child: isComplete
                              ? Center(
                                  child: Icon(Icons.check_circle_rounded,
                                      color: widget.color, size: isMob ? 22 : 30),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(isMob ? 6 : 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(width: isMob ? 20 : 28, height: 3, color: widget.color.withValues(alpha: 0.4)),
                                      SizedBox(height: isMob ? 4 : 6),
                                      Container(width: double.infinity, height: 2, color: widget.color.withValues(alpha: 0.15)),
                                      SizedBox(height: isMob ? 3 : 4),
                                      Container(width: double.infinity, height: 2, color: widget.color.withValues(alpha: 0.15)),
                                      SizedBox(height: isMob ? 3 : 4),
                                      Container(width: isMob ? 15 : 20, height: 2, color: widget.color.withValues(alpha: 0.15)),
                                    ],
                                  ),
                                ),
                        ),
                        SizedBox(height: isMob ? 6 : 10),
                        // Status label
                        Text(
                          isComplete ? 'READY' : p < 0.3 ? 'SCANNING...' : 'ANALYZING...',
                          style: TextStyle(
                            color: isComplete ? widget.color : widget.color.withValues(alpha: 0.6),
                            fontSize: isMob ? 7 : 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: isMob ? 4 : 6),
                        // Progress bar
                        Container(
                          width: isMob ? 40 : 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: widget.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: p.clamp(0.0, 1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.color,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(color: widget.color.withValues(alpha: 0.5), blurRadius: 4),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: isMob ? 12 : 24),
              // Right: Result scores
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _scoreChip('6/6', phase3, widget.color, isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _scoreChip('Normal', (phase3 * 0.9).clamp(0.0, 1.0), const Color(0xFF4F6AFF), isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _scoreChip('0.25D', (phase3 * 0.7).clamp(0.0, 1.0), const Color(0xFF9D4EDD), isMob),
                      SizedBox(height: isMob ? 6 : 10),
                      _scoreChip('High', (phase3 * 0.85).clamp(0.0, 1.0), const Color(0xFFF5C842), isMob),
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

  Widget _metricRow(String label, double progress, Color color, bool isMob) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: isMob ? 7 : 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: isMob ? 4 : 8),
        SizedBox(
          width: isMob ? 30 : 50,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.1),
              color: color.withValues(alpha: 0.7),
              minHeight: 3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _scoreChip(String label, double opacity, Color color, bool isMob) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isMob ? 6 : 10, vertical: isMob ? 2 : 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: isMob ? 7 : 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated: Reels Feed — Distinct thumbnails per reel
// ─────────────────────────────────────────────
class _AnimatedReelsFeed extends StatefulWidget {
  final Color color;
  const _AnimatedReelsFeed({required this.color});
  @override
  State<_AnimatedReelsFeed> createState() => _AnimatedReelsFeedState();
}

class _AnimatedReelsFeedState extends State<_AnimatedReelsFeed>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _reelTitles = [
    'How Blinking Protects Your Eyes',
    'Understanding Color Vision',
    'Digital Eye Strain Tips',
    'Foods for Healthy Eyes',
    'When to See Your Optometrist',
  ];

  static const _reelIcons = [
    Icons.remove_red_eye,
    Icons.palette,
    Icons.phone_android,
    Icons.restaurant,
    Icons.medical_services,
  ];

  // Distinct gradient color pairs for each thumbnail
  static const _reelGradients = [
    [Color(0xFF1A237E), Color(0xFF4F6AFF)],  // Deep blue → Indigo
    [Color(0xFF880E4F), Color(0xFFE91E63)],  // Berry → Pink
    [Color(0xFF004D40), Color(0xFF00BFA5)],  // Teal dark → Teal bright
    [Color(0xFFE65100), Color(0xFFFFB74D)],  // Orange → Amber
    [Color(0xFF4A148C), Color(0xFFAB47BC)],  // Deep purple → Lilac
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 12))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final phoneW = isMob ? 110.0 : 150.0;
    final phoneH = isMob ? 220.0 : 310.0;

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: PhoneMockup(
          width: phoneW,
          height: phoneH,
          tiltX: -0.02,
          tiltY: 0.03,
          showNotch: false,
        showHomeBar: false,
        screen: ClipRect(
          child: RepaintBoundary(
            child: Container(
              color: Colors.black,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  final reelH = phoneH * 0.85;
                  final gap = 4.0;
                  final totalContentH =
                      reelH * _reelTitles.length +
                          gap * (_reelTitles.length - 1);
                  final dy = -(_ctrl.value * (totalContentH - phoneH))
                      .clamp(0.0, totalContentH);

                  return SizedBox(
                    width: double.infinity,
                    height: phoneH,
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          top: dy,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(_reelTitles.length,
                                (i) {
                              final gradColors = _reelGradients[i];
                              return Container(
                                width: double.infinity,
                                height: reelH,
                                margin: EdgeInsets.only(bottom: gap),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      gradColors[0],
                                      gradColors[1].withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    // Large background icon for visual variety
                                    Positioned(
                                      right: -10,
                                      top: -10,
                                      child: Icon(
                                        _reelIcons[i],
                                        size: isMob ? 60 : 80,
                                        color: Colors.white.withValues(alpha: 0.08),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            isMob ? 8 : 12),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.45),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.3)),
                                        ),
                                        child: Icon(
                                            Icons
                                                .play_arrow_rounded,
                                            color: Colors.white,
                                            size: isMob ? 18 : 26),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(_reelIcons[i],
                                                  color: Colors.white
                                                      .withValues(
                                                          alpha: 0.9),
                                                  size: isMob
                                                      ? 9
                                                      : 12),
                                              const SizedBox(
                                                  width: 4),
                                              Expanded(
                                                child: Text(
                                                  _reelTitles[i],
                                                  style: TextStyle(
                                                    color: Colors.white
                                                        .withValues(
                                                            alpha:
                                                                0.95),
                                                    fontSize: isMob
                                                        ? 7
                                                        : 9,
                                                    fontWeight:
                                                        FontWeight
                                                            .w600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Container(
                                            height: 2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(1),
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 6,
                                      child: Column(
                                        children: [
                                          Icon(
                                              Icons.favorite_border,
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.7),
                                              size: isMob ? 10 : 14),
                                          SizedBox(
                                              height:
                                                  isMob ? 4 : 8),
                                          Icon(
                                              Icons.share_outlined,
                                              color: Colors.white
                                                  .withValues(
                                                      alpha: 0.7),
                                              size: isMob ? 10 : 14),
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
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated: Ocular Wellness — gentler motion
// ─────────────────────────────────────────────
class _AnimatedOcularWellness extends StatefulWidget {
  final Color color;
  const _AnimatedOcularWellness({required this.color});
  @override
  State<_AnimatedOcularWellness> createState() =>
      _AnimatedOcularWellnessState();
}

class _AnimatedOcularWellnessState extends State<_AnimatedOcularWellness>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    // Slowed from 1s to 2.5s for calmer feel
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500))
      ..repeat(reverse: true);
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
        builder: (context, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(5, (i) {
                  final h = 15.0 +
                      (math
                              .sin((_ctrl.value * math.pi) + i * 0.5)
                              .abs() *
                          30.0);
                  return Container(
                    width: 7,
                    height: h,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                            color:
                                widget.color.withValues(alpha: 0.4),
                            blurRadius: 6)
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 24),
            // Gentler bounce: 0.5px instead of 1px
            Transform.translate(
              offset:
                  Offset(0, math.sin(_ctrl.value * math.pi) * 0.5),
              child: Icon(Icons.sports_esports,
                  color: widget.color, size: 52),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated: Consultation Network — enhanced
// ─────────────────────────────────────────────
class _AnimatedConsultationNetwork extends StatefulWidget {
  final Color color;
  const _AnimatedConsultationNetwork({required this.color});
  @override
  State<_AnimatedConsultationNetwork> createState() =>
      _AnimatedConsultationNetworkState();
}

class _AnimatedConsultationNetworkState
    extends State<_AnimatedConsultationNetwork>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3500))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _syncNode(IconData icon, Color color, String label, double pulse) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(color: color.withValues(alpha: 0.4 + pulse * 0.2)),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15 * pulse),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w600)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final val = _ctrl.value;
          final dotX = val;
          final pulse = math.sin(val * math.pi * 2).abs();
          // Mode alternates: first half = online, second half = home visit
          final isOnline = val < 0.5;
          
          return Center(
            child: SizedBox(
              width: isMob ? 280 : 400,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Connecting line
                  Positioned(
                    left: isMob ? 55 : 75,
                    right: isMob ? 55 : 75,
                    top: 30,
                    child: Container(
                      height: 1.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withValues(alpha: 0.1),
                            widget.color.withValues(alpha: 0.4),
                            widget.color.withValues(alpha: 0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Doctor node
                  Positioned(
                      left: isMob ? 10 : 20,
                      child:
                          _syncNode(Icons.person, widget.color, 'DOCTOR', pulse)),
                  // Patient node
                  Positioned(
                      right: isMob ? 10 : 20,
                      child: _syncNode(
                          Icons.face, Colors.white70, 'PATIENT', pulse)),
                  // Moving data packet
                  Positioned(
                    left: (isMob ? 55 : 75) + dotX * (isMob ? 160 : 240),
                    top: 24,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: widget.color.withValues(alpha: 0.6),
                              blurRadius: 12,
                              spreadRadius: 2)
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          isOnline ? Icons.videocam : Icons.home,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    ),
                  ),
                  // Mode badge
                  Positioned(
                    bottom: 0,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: Container(
                        key: ValueKey(isOnline),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: widget.color.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOnline ? Icons.videocam : Icons.home_work,
                              color: widget.color,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOnline ? 'ONLINE CONSULT' : 'HOME VISIT',
                              style: TextStyle(
                                color: widget.color,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated: Language Globe — slower rotation
// ─────────────────────────────────────────────
class _AnimatedLanguageGlobe extends StatefulWidget {
  final Color color;
  const _AnimatedLanguageGlobe({required this.color});
  @override
  State<_AnimatedLanguageGlobe> createState() =>
      _AnimatedLanguageGlobeState();
}

class _AnimatedLanguageGlobeState extends State<_AnimatedLanguageGlobe>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final langs = [
    'English', 'Hindi', 'Marathi', 'Malayalam', 'Tamil', 'Telugu',
    'Kannada', 'Bengali', 'Gujarati', 'Punjabi', 'Odia', 'Urdu',
    'Assamese'
  ];

  @override
  void initState() {
    super.initState();
    // Slowed from 15s to 25s for calmer feel
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 25))
      ..repeat();
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
      builder: (context, _) => Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
              child: RepaintBoundary(
            child: CustomPaint(
                painter: GlobePainter(
                    rotation: _ctrl.value * math.pi * 2,
                    gridColor: widget.color)),
          )),
          ...langs.asMap().entries.map((e) {
            final isMob = Responsive.isMobile(context);
            final isOuter = e.key % 2 == 0;
            final dir = isOuter ? 1 : -1;
            final angle = (e.key / langs.length) * math.pi * 2 +
                (_ctrl.value * math.pi * 2 * dir);
            final xR = isMob
                ? (isOuter ? 120.0 : 65.0)
                : (isOuter ? 240.0 : 110.0);
            final yR = isMob
                ? (isOuter ? 25.0 : 15.0)
                : (isOuter ? 55.0 : 28.0);
            final x = math.cos(angle) * xR;
            final y = math.sin(angle) * yR;
            final z = math.sin(angle);
            final scale = (isOuter ? 0.85 : 0.65) + (z * 0.25);
            final opacity = 0.4 + ((z + 1) / 2) * 0.6;
            return Transform.translate(
              offset: Offset(x, y),
              child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMob ? 8 : 14,
                          vertical: isMob ? 4 : 8),
                      decoration: BoxDecoration(
                        color: AppColors.background
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color:
                                widget.color.withValues(alpha: 0.5),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                              color: widget.color
                                  .withValues(alpha: 0.2),
                              blurRadius: 12)
                        ],
                      ),
                      child: Text(e.value.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: isMob ? 8 : 13,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700)),
                    ),
                  )),
            );
          }),
          Center(
              child:
                  AnimatedCounter(target: 13, forceStart: true)),
        ],
      ),
    );
  }
}
