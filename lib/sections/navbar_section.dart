import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../widgets/gradient_button.dart';
import '../utils/responsive.dart';

class NavbarSection extends StatelessWidget {
  final bool isScrolled;
  const NavbarSection({super.key, required this.isScrolled});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 72,
      decoration: BoxDecoration(
        color: isScrolled ? AppColors.background.withOpacity(0.7) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: isScrolled ? AppColors.accent2.withOpacity(0.15) : Colors.transparent,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: isScrolled ? ImageFilter.blur(sigmaX: 20, sigmaY: 20) : ImageFilter.blur(),
          child: Padding(
            padding: Responsive.padding(context),
            child: Row(
              children: [
                // Logo
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const EyeLogo(size: 32),
                    const SizedBox(width: 10),
                    Text('Visiaxx', style: AppFonts.h5.copyWith(color: AppColors.white, letterSpacing: 1)),
                  ],
                ),
                const Spacer(),
                // Nav Links (desktop only)
                if (!isMob) ...[
                  for (final link in ['Tests', 'Therapy', 'Consult', 'Languages', 'B2B'])
                    _NavLink(label: link),
                  const SizedBox(width: 20),
                ],
                // CTA
                GradientButton(
                  text: isMob ? 'Download' : 'Download App',
                  gradient: AppColors.tealGradient,
                  height: 40,
                  onTap: () {},
                ),
                if (isMob) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.white),
                    onPressed: () {},
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  const _NavLink({required this.label});
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hov = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: AppFonts.bodySmall.copyWith(
            color: _hov ? AppColors.accent2 : AppColors.white,
            fontWeight: _hov ? FontWeight.w600 : FontWeight.w400,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
