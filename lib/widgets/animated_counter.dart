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
          final val = _countAnim.value / widget.target;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                   // Subtle glow behind number
                  Opacity(
                    opacity: (0.3 * val).clamp(0.0, 1.0),
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                        BoxShadow(color: AppColors.accent2, blurRadius: 40, spreadRadius: 10),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${widget.prefix}${_countAnim.value.toInt()}${widget.suffix}',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 2, width: 30 * val,
                color: AppColors.accent2,
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.muted,
                  letterSpacing: 2.0,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
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
