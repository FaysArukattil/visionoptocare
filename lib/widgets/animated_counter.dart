import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

class AnimatedCounter extends StatefulWidget {
  final String prefix;
  final int target;
  final String suffix;
  final String label;
  final Duration duration;

  const AnimatedCounter({
    super.key,
    this.prefix = '',
    required this.target,
    this.suffix = '',
    required this.label,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _countAnim;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _countAnim = Tween<double>(begin: 0, end: widget.target.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('counter_${widget.label}'),
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.3) {
          _started = true;
          _ctrl.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _countAnim,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.prefix}${_countAnim.value.toInt()}${widget.suffix}',
                style: AppFonts.h2.copyWith(color: AppColors.accent2),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
