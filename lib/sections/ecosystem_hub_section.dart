import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class EcosystemHubSection extends StatelessWidget {
  const EcosystemHubSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 120),
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
                    'THE ECOSYSTEM',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.accent2, 
                      letterSpacing: 4, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'A Comprehensive Hub\nfor Your Vision',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.white, 
                      fontSize: isMob ? 28 : 48, 
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),

            // The Unified Bento Grid
            Padding(
              padding: Responsive.padding(context),
              child: _buildBentoGrid(context, isMob),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context, bool isMob) {
    if (isMob) {
      return Column(
        children: [
          _FeatureBentoCard(
            title: 'Ocular Wellness',
            subtitle: 'Train your focus with AI therapy games.',
            icon: Icons.psychology_outlined,
            color: const Color(0xFF4F6AFF),
            child: _buildWellnessPreview(),
          ),
          const SizedBox(height: 24),
          _FeatureBentoCard(
            title: 'Education Hub',
            subtitle: 'Eye care reels and expert articles.',
            icon: Icons.play_circle_outline,
            color: const Color(0xFF00D4C8),
            child: _buildReelsPreview(),
          ),
          const SizedBox(height: 24),
          _FeatureBentoCard(
            title: 'Hybrid Consultations',
            subtitle: 'Secure HD video calls and home visits.',
            icon: Icons.video_call_outlined,
            color: const Color(0xFFF5C842),
            child: _buildConsultPreview(),
          ),
          const SizedBox(height: 24),
          _FeatureBentoCard(
            title: 'Digital Diagnostics',
            subtitle: '12 clinical-grade tests at your fingertips.',
            icon: Icons.app_registration,
            color: AppColors.accent2,
            child: _buildDiagnosticPreview(),
          ),
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                // 1. Wellness (Big Card)
                Expanded(
                  flex: 3,
                  child: _FeatureBentoCard(
                    title: 'Ocular Wellness',
                    subtitle: 'Train your focus with AI-powered therapy games and a curated 37-track therapeutic music library.',
                    icon: Icons.psychology_outlined,
                    color: const Color(0xFF4F6AFF),
                    child: _buildWellnessPreview(),
                  ),
                ),
                const SizedBox(width: 24),
                // 2. Education (Right Stack)
                Expanded(
                  flex: 2,
                  child: _FeatureBentoCard(
                    title: 'Education Hub',
                    subtitle: 'TikTok-style eye care reels and expert articles.',
                    icon: Icons.play_circle_outline,
                    color: const Color(0xFF00D4C8),
                    height: 600,
                    child: _buildReelsPreview(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // 3. Consultations (Bottom Left)
                Expanded(
                  child: _FeatureBentoCard(
                    title: 'Hybrid Consultations',
                    subtitle: 'Secure HD video calls with optometrists and "Uber-model" home visits.',
                    icon: Icons.video_call_outlined,
                    color: const Color(0xFFF5C842),
                    child: _buildConsultPreview(),
                  ),
                ),
                const SizedBox(width: 24),
                // 4. Diagnostic Point (Bottom Right)
                Expanded(
                  child: _FeatureBentoCard(
                    title: 'Diagnostic Deep-Dive',
                    subtitle: 'Instant clinical-grade reports with historical tracking and AI insights.',
                    icon: Icons.app_registration,
                    color: AppColors.accent2,
                    child: _buildDiagnosticPreview(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // --- PREVIEWS ---

  Widget _buildWellnessPreview() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) => Container(
            width: 60, height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white.withValues(alpha: 0.05),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
            ),
            child: Icon(
              [Icons.videogame_asset, Icons.music_note, Icons.spa, Icons.nightlight][i],
              color: const Color(0xFF4F6AFF),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildReelsPreview() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 140, height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.background.withValues(alpha: 0.5),
            border: Border.all(color: const Color(0xFF00D4C8).withValues(alpha: 0.2)),
          ),
          child: const Center(child: Icon(Icons.play_circle_fill, color: Color(0xFF00D4C8), size: 40)),
        ),
      ],
    );
  }

  Widget _buildConsultPreview() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CircleAvatar(radius: 24, backgroundColor: Color(0xFFF5C842), child: Icon(Icons.person, color: Colors.white)),
            Icon(Icons.sync, color: AppColors.white.withValues(alpha: 0.3)),
            const CircleAvatar(radius: 24, backgroundColor: Color(0xFF4F6AFF), child: Icon(Icons.videocam, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildDiagnosticPreview() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          '12 CLINICAL TESTS',
          style: AppFonts.h3.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Approved Scrutiny',
          style: AppFonts.bodySmall.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _FeatureBentoCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final double? height;
  final Widget? child;

  const _FeatureBentoCard({
    required this.title, 
    required this.subtitle, 
    required this.icon, 
    required this.color,
    this.height,
    this.child,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        height: widget.height,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: _hov ? widget.color.withValues(alpha: 0.4) : AppColors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            if (_hov) BoxShadow(color: widget.color.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: -5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(widget.icon, color: widget.color, size: 40),
            const SizedBox(height: 32),
            Text(
              widget.title, 
              style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.subtitle,
              style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 14, height: 1.5),
            ),
            if (widget.child != null) ...[
              if (widget.height != null) const Spacer() else const SizedBox(height: 32),
              widget.child!,
            ],
          ],
        ),
      ),
    );
  }
}
