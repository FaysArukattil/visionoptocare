import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TiltCard extends StatefulWidget {
  final Widget child;
  final double maxTilt;
  final BorderRadius? borderRadius;
  final Color? glowColor;

  const TiltCard({
    super.key,
    required this.child,
    this.maxTilt = 0.04,
    this.borderRadius,
    this.glowColor,
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _rotX = 0, _rotY = 0;
  bool _hovering = false;

  void _onHover(PointerEvent event, BoxConstraints constraints) {
    final dx = (event.localPosition.dx / constraints.maxWidth - 0.5) * 2;
    final dy = (event.localPosition.dy / constraints.maxHeight - 0.5) * 2;
    setState(() {
      _rotY = dx * widget.maxTilt;
      _rotX = -dy * widget.maxTilt;
      _hovering = true;
    });
  }

  void _onExit() {
    setState(() {
      _rotX = 0;
      _rotY = 0;
      _hovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final br = widget.borderRadius ?? BorderRadius.circular(20);
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _onHover(e, constraints),
          onExit: (_) => _onExit(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotX)
              ..rotateY(_rotY)
              ..scale(_hovering ? 1.03 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: br,
              boxShadow: _hovering
                  ? [
                      BoxShadow(
                        color: (widget.glowColor ?? AppColors.accent2)
                            .withOpacity(0.25),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ]
                  : [],
            ),
            child: ClipRRect(borderRadius: br, child: widget.child),
          ),
        );
      },
    );
  }
}
