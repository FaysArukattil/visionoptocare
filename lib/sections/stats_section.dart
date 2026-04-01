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
    // Stats reveal in the last 30% of hero scroll for a more gradual feel
    final entryP = ((scrollProgress - 0.70) / 0.30).clamp(0.0, 1.0);
    
    return RepaintBoundary(
      child: Opacity(
        opacity: entryP,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - entryP)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isMob ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              if (!isMob) ...[
                Text(
                  'SYSTEM DIAGNOSTICS',
                  style: AppFonts.caption.copyWith(
                    color: AppColors.accent2, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Dashboard Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _StatCard(
                        width: isMob ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                        delay: 0.0, p: entryP,
                        child: AnimatedCounter(
                          target: 12, 
                          label: 'CLINICAL TESTS', 
                          forceStart: entryP > 0.3,
                        ),
                      ),
                      _StatCard(
                        width: isMob ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                        delay: 0.1, p: entryP,
                        child: AnimatedCounter(
                          target: 13, 
                          label: 'LOCAL LANGUAGES', 
                          forceStart: entryP > 0.4,
                        ),
                      ),
                      _StatCard(
                        width: isMob ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                        delay: 0.2, p: entryP,
                        child: AnimatedCounter(
                          target: 100, 
                          showPlus: true, 
                          label: 'HEALTH TIPS', 
                          forceStart: entryP > 0.5,
                        ),
                      ),
                      _StatCard(
                        width: isMob ? constraints.maxWidth : (constraints.maxWidth - 16) / 2,
                        delay: 0.3, p: entryP,
                        highlight: true,
                        child: const _OnlineConsultStat(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget child;
  final bool highlight;
  final double p;
  final double delay;
  final double width;

  const _StatCard({
    required this.child, 
    this.highlight = false, 
    this.p = 1.0,
    this.delay = 0.0,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cardP = (p - delay).clamp(0.0, 1.0);

    return Opacity(
      opacity: cardP,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - cardP)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: (highlight ? AppColors.accent2 : AppColors.white).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: highlight 
                      ? AppColors.accent2.withValues(alpha: 0.4) 
                      : AppColors.white.withValues(alpha: 0.1),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: child,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, _) => Container(
                width: 44 + (_pulse.value * 12), 
                height: 44 + (_pulse.value * 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent2.withValues(alpha: 0.2 * _pulse.value),
                ),
              ),
            ),
            const Icon(Icons.videocam_rounded, color: AppColors.accent2, size: 32),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'ONLINE',
          style: AppFonts.heading(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        Text(
          'CONSULTATION',
          style: AppFonts.heading(
            fontSize: 14,
            color: AppColors.accent2,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent2.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'ACTIVE NOW',
            style: AppFonts.caption.copyWith(
              color: AppColors.accent2,
              letterSpacing: 2,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
