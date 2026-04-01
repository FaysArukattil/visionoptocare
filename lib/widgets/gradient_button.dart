import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final LinearGradient? gradient;
  final bool isOutline;
  final VoidCallback? onTap;
  final IconData? icon;
  final double height;

  const GradientButton({
    super.key,
    required this.text,
    this.gradient,
    this.isOutline = false,
    this.onTap,
    this.icon,
    this.height = 52,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final grad = widget.gradient ?? AppColors.tealGradient;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          height: widget.height,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          transform: Matrix4.identity()
            ..scaleByDouble(_hovering ? 1.05 : 1.0, _hovering ? 1.05 : 1.0, 1.0, 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: widget.isOutline ? null : grad,
            borderRadius: BorderRadius.circular(30),
            border: widget.isOutline
                ? Border.all(color: AppColors.muted.withValues(alpha: 0.5), width: 1.5)
                : null,
            boxShadow: _hovering && !widget.isOutline
                ? [
                    BoxShadow(
                      color: grad.colors.first.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: AppColors.white, size: 20),
                const SizedBox(width: 10),
              ],
              Text(widget.text, style: AppFonts.button),
            ],
          ),
        ),
      ),
    );
  }
}
