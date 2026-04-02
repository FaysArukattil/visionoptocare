import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollRevealWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;
  final Curve curve;

  const ScrollRevealWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.slideOffset = 30.0,
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<ScrollRevealWidget> createState() => _ScrollRevealWidgetState();
}

class _ScrollRevealWidgetState extends State<ScrollRevealWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    _slideAnim = Tween<Offset>(
      begin: Offset(0, widget.slideOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibility(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.15) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('sr_${identityHashCode(widget)}'),
      onVisibilityChanged: _onVisibility,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return RepaintBoundary(
            child: Transform.translate(
              offset: _slideAnim.value,
              child: Opacity(opacity: _fadeAnim.value, child: child),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
