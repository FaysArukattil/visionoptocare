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
  final bool showPlus;
  final bool forceStart;
  final TextStyle? style;

  const AnimatedCounter({
    super.key,
    this.prefix = '',
    required this.target,
    this.suffix = '',
    this.label = '',
    this.duration = const Duration(milliseconds: 2000),
    this.showPlus = false,
    this.forceStart = false,
    this.style,
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
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutQuart));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_started && widget.forceStart) {
      _started = true;
      _ctrl.forward();
    }

    return VisibilityDetector(
      key: Key('counter_${widget.label}_${widget.target}'),
      onVisibilityChanged: (info) {
        if (!_started && info.visibleFraction > 0.45) {
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
                   // Glow
                  Opacity(
                    opacity: (0.5 * val).clamp(0.0, 1.0),
                    child: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent2.withValues(alpha: 0.8),
                            blurRadius: 30,
                            spreadRadius: 10 * val,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    '${widget.prefix}${_countAnim.value.toInt()}${widget.showPlus ? '+' : widget.suffix}',
                    style: widget.style ?? AppFonts.heading(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              if (widget.label.isNotEmpty) ...[
                const SizedBox(height: 16),
                // Dynamic Progress line
                Container(
                  height: 3, 
                  width: 40 * val,
                  decoration: BoxDecoration(
                    color: AppColors.accent2,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(color: AppColors.accent2.withValues(alpha: 0.5), blurRadius: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.label.toUpperCase(),
                  style: AppFonts.caption.copyWith(
                    color: AppColors.muted,
                    letterSpacing: 3.0,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
