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
    
    // Stats reveal in the last 20% of hero scroll
    final entryP = ((scrollProgress - 0.80) / 0.20).clamp(0.0, 1.0);
    
    return RepaintBoundary(
      child: Opacity(
        opacity: entryP,
        child: Transform.translate(
          offset: Offset(0, 30 * (1 - entryP)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMob ? 16 : 60),
            child: isMob ? _buildMobile(entryP) : _buildDesktop(entryP),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(double entryP) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatCard(
          delay: 0.0, p: entryP,
          child: AnimatedCounter(target: 12, label: 'CLINICAL TESTS', forceStart: entryP > 0.3),
        ),
        const SizedBox(width: 16),
        _StatCard(
          delay: 0.1, p: entryP,
          child: AnimatedCounter(target: 13, label: 'LOCAL LANGUAGES', forceStart: entryP > 0.4),
        ),
        const SizedBox(width: 16),
        _StatCard(
          delay: 0.2, p: entryP,
          child: AnimatedCounter(target: 100, showPlus: true, label: 'EYE CARE TIPS', forceStart: entryP > 0.5),
        ),
        const SizedBox(width: 16),
        _StatCard(
          delay: 0.3, p: entryP,
          highlight: true,
          child: const _OnlineConsultStat(),
        ),
      ],
    );
  }

  Widget _buildMobile(double entryP) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatCard(
          delay: 0.0, p: entryP,
          child: AnimatedCounter(target: 12, label: 'CLINICAL TESTS', forceStart: entryP > 0.3),
        ),
        _StatCard(
          delay: 0.1, p: entryP,
          child: AnimatedCounter(target: 13, label: 'LOCAL LANGUAGES', forceStart: entryP > 0.4),
        ),
        _StatCard(
          delay: 0.2, p: entryP,
          child: AnimatedCounter(target: 100, showPlus: true, label: 'EYE CARE TIPS', forceStart: entryP > 0.5),
        ),
        _StatCard(
          delay: 0.3, p: entryP,
          highlight: true,
          child: const _OnlineConsultStat(),
        ),
      ],
    );
  }
}

// ─── High-Performance Stat Card (NO BackdropFilter) ───
class _StatCard extends StatelessWidget {
  final Widget child;
  final bool highlight;
  final double p;
  final double delay;

  const _StatCard({
    required this.child, 
    this.highlight = false, 
    this.p = 1.0,
    this.delay = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final cardP = (p - delay).clamp(0.0, 1.0);
    final isMob = Responsive.isMobile(context);

    return IgnorePointer(
      ignoring: cardP < 0.2,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - cardP)),
        child: Opacity(
          opacity: cardP,
          child: Container(
            width: isMob ? 160 : 220,
            padding: EdgeInsets.symmetric(vertical: isMob ? 24 : 32, horizontal: isMob ? 14 : 20),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: highlight 
                    ? AppColors.accent2.withValues(alpha: 0.35) 
                    : AppColors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: child,
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
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Container(
                width: 36 + (_pulse.value * 8), 
                height: 36 + (_pulse.value * 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent2.withValues(alpha: 0.15 * _pulse.value),
                ),
              ),
            ),
            const Icon(Icons.videocam_rounded, color: AppColors.accent2, size: 30),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'ONLINE',
          style: AppFonts.heading(
            fontSize: 20,
            color: AppColors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        Text(
          'CONSULTATION',
          style: AppFonts.heading(
            fontSize: 15,
            color: AppColors.accent2,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'CONNECT ANYWHERE',
          style: AppFonts.caption.copyWith(
            color: AppColors.muted,
            letterSpacing: 2,
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
