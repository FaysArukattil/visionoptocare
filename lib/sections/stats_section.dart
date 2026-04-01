import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/animated_counter.dart';
import '../utils/responsive.dart';

class StatsSection extends StatelessWidget {
  final double scrollProgress;
  const StatsSection({super.key, required this.scrollProgress});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    // Logic: Entry begins at p=0.85 and completes at p=1.0
    final entryP = ((scrollProgress - 0.85) / 0.15).clamp(0.0, 1.0);
    
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isMob ? 40 : 60, horizontal: 24),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: [
            _StatCard(
              p: entryP,
              delay: 0.1,
              child: AnimatedCounter(target: 12, label: 'CLINICAL TESTS', forceStart: entryP > 0.5),
            ),
            _StatCard(
              p: entryP,
              delay: 0.2,
              child: AnimatedCounter(target: 13, label: 'LOCAL LANGUAGES', forceStart: entryP > 0.6),
            ),
            _StatCard(
              p: entryP,
              delay: 0.3,
              child: AnimatedCounter(target: 100, showPlus: true, label: 'EYE CARE TIPS', forceStart: entryP > 0.7),
            ),
            _StatCard(
              p: entryP,
              delay: 0.4,
              highlight: true,
              child: const _OnlineConsultStat(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget child;
  final bool highlight;
  final double p; // Entry progress (0 to 1)
  final double delay;

  const _StatCard({
    required this.child, 
    this.highlight = false, 
    this.p = 1.0,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final cardP = (p - delay * 0.5).clamp(0.0, 1.0);
    
    return IgnorePointer(
      ignoring: cardP < 0.2,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateX(0.15 * (1 - cardP)) // Tilt back during entry
          ..scale(0.95 + 0.05 * cardP) // Scale up slightly
          ..setTranslationRaw(0.0, 50 * (1 - cardP), -100 * (1 - cardP)), // Float in from Z
        alignment: Alignment.center,
        child: Opacity(
          opacity: cardP,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 240,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: highlight 
                        ? AppColors.accent2.withValues(alpha: 0.4) 
                        : AppColors.white.withValues(alpha: 0.08),
                    width: 1.2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnlineConsultStat extends StatefulWidget {
  const _OnlineConsultStat();

  @override
  State<_OnlineConsultStat> createState() => _OnlineConsultStatState();
}

class _OnlineConsultStatState extends State<_OnlineConsultStat> with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: Tween(begin: 1.0, end: 1.4).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut)),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent2.withValues(alpha: 0.2),
                ),
              ),
            ),
            const Icon(Icons.videocam_rounded, color: AppColors.accent2, size: 36),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'ONLINE',
          style: AppFonts.heading(
            fontSize: 22,
            color: AppColors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        Text(
          'CONSULTATION',
          style: AppFonts.heading(
            fontSize: 18,
            color: AppColors.accent2,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'CONNECT ANYWHERE',
          style: AppFonts.caption.copyWith(
            color: AppColors.muted,
            letterSpacing: 2,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

