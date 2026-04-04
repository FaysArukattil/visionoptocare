import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../utils/responsive.dart';

class NavbarSection extends StatefulWidget {
  final bool isScrolled;
  final int currentPage;
  final void Function(int)? onNavTap;

  const NavbarSection({
    super.key,
    required this.isScrolled,
    this.currentPage = 0,
    this.onNavTap,
  });

  @override
  State<NavbarSection> createState() => _NavbarSectionState();
}

class _NavbarSectionState extends State<NavbarSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void didUpdateWidget(covariant NavbarSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScrolled != oldWidget.isScrolled) {
      if (widget.isScrolled) {
        _animCtrl.forward();
      } else {
        _animCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final bool isGlass = widget.isScrolled || _menuOpen;
    
    return AnimatedPadding(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.fromLTRB(
        isMob ? (isGlass ? 12.0 : 0.0) : (isGlass ? 40.0 : 0.0),
        isMob ? (isGlass ? 10.0 : 0.0) : (isGlass ? 16.0 : 0.0),
        isMob ? (isGlass ? 12.0 : 0.0) : (isGlass ? 40.0 : 0.0),
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isMob ? 24 : (isGlass ? 40 : 0)),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: isGlass ? 12 : 0.001,
            sigmaY: isGlass ? 12 : 0.001,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(
                alpha: isGlass ? 0.65 : 0.0,
              ),
              borderRadius: BorderRadius.circular(isMob ? 24 : (isGlass ? 40 : 0)),
              border: Border.all(
                color: AppColors.white.withValues(
                  alpha: isGlass ? 0.12 : 0.0,
                ),
                width: 0.8,
              ),
              boxShadow: isGlass ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 35,
                  offset: const Offset(0, 15),
                ),
              ] : [],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Bar
                Container(
                  height: isMob ? 72 : 88,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMob ? 6 : 32,
                  ),
                  child: Row(
                    children: [
                      // ── Logo (Left) ──
                      GestureDetector(
                        onTap: () => widget.onNavTap?.call(0),
                        child: _buildLogo(isMob),
                      ),
                      const Spacer(),
                      // ── Nav Links (Desktop) ──
                      if (!isMob)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _NavLink(
                                label: 'Home',
                                isActive: widget.currentPage <= 1,
                                onTap: () => widget.onNavTap?.call(0),
                              ),
                              const SizedBox(width: 32),
                              _NavLink(
                                label: 'Services',
                                isActive: widget.currentPage >= 2 &&
                                    widget.currentPage <= 4,
                                onTap: () => widget.onNavTap?.call(2),
                              ),
                              const SizedBox(width: 32),
                              _NavLink(
                                label: 'About Us',
                                isActive: widget.currentPage >= 5,
                                onTap: () => widget.onNavTap?.call(6),
                              ),
                              const SizedBox(width: 24),
                              _buildDownloadButton(),
                            ],
                          ),
                        ),
                      // ── Hamburger (Mobile) ──
                      if (isMob) _buildMenuButton(),
                    ],
                  ),
                ),
                // ── Mobile Menu ──
                if (isMob && _menuOpen)
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.55,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: Column(
                        children: [
                          Divider(
                            color: AppColors.white.withValues(alpha: 0.1),
                            thickness: 1,
                          ),
                          const SizedBox(height: 24),
                          _NavLink(
                            label: 'Home',
                            isActive: widget.currentPage <= 1,
                            onTap: () { setState(() => _menuOpen = false); widget.onNavTap?.call(0); },
                          ),
                          const SizedBox(height: 24),
                          _NavLink(
                            label: 'Services',
                            isActive: widget.currentPage >= 2 && widget.currentPage <= 4,
                            onTap: () { setState(() => _menuOpen = false); widget.onNavTap?.call(2); },
                          ),
                          const SizedBox(height: 24),
                          _NavLink(
                            label: 'About Us',
                            isActive: widget.currentPage >= 5,
                            onTap: () { setState(() => _menuOpen = false); widget.onNavTap?.call(6); },
                          ),
                          const SizedBox(height: 12),
                          _buildDownloadButton(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Logo ──
  Widget _buildLogo(bool isMob) {
    // Authoritative permanent base size
    final size = isMob ? 140.0 : 160.0;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: EyeLogo(size: size),
    );
  }

  // ── Download App CTA Button ──
  Widget _buildDownloadButton() {
    return _GlowButton(
      label: 'Download',
      icon: Icons.download_rounded,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: EdgeInsets.symmetric(
              horizontal: Responsive.isMobile(context) ? 24 : 200,
              vertical: 20,
            ),
            duration: const Duration(seconds: 4),
            content: Row(
              children: [
                Icon(Icons.rocket_launch_rounded, color: AppColors.accent2, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Coming Soon! Our developers are working hard to bring the app to you as fast as possible. Stay tuned!',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Mobile Menu Button ──
  Widget _buildMenuButton() {
    return GestureDetector(
      onTap: () => setState(() => _menuOpen = !_menuOpen),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          color: AppColors.white.withValues(alpha: 0.05),
        ),
        child: Icon(
          _menuOpen ? Icons.close_rounded : Icons.menu_rounded,
          color: AppColors.white.withValues(alpha: 0.85),
          size: 20,
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  Nav Link with animated underline + glow
// ══════════════════════════════════════════════
class _NavLink extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const _NavLink({required this.label, this.isActive = false, this.onTap});
  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _underlineWidth;
  late Animation<double> _colorLerp;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: widget.isActive ? 1.0 : 0.0,
    );
    _underlineWidth = Tween<double>(begin: 0, end: 28).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _colorLerp = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant _NavLink oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _ctrl.forward();
    } else if (!widget.isActive && oldWidget.isActive && !_hovered) {
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        if (!widget.isActive) _ctrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final lerp = _colorLerp.value;
            final textColor = Color.lerp(
              AppColors.white.withValues(alpha: 0.7),
              AppColors.accent2,
              lerp,
            )!;
            final underline = _underlineWidth.value;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: AppFonts.body(
                    fontSize: 14.5,
                    fontWeight: (_hovered || widget.isActive) ? FontWeight.w600 : FontWeight.w400,
                    color: textColor,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 2,
                  width: underline,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent2.withValues(alpha: 0.9),
                        AppColors.accent1.withValues(alpha: 0.6),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent2.withValues(alpha: 0.4 * lerp),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════
//  Glowing "Explore" Button
// ══════════════════════════════════════════════
class _GlowButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  const _GlowButton({required this.label, this.icon, required this.onTap});

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final glowVal = _ctrl.value;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Color.lerp(
                    AppColors.white.withValues(alpha: 0.2),
                    AppColors.accent2.withValues(alpha: 0.7),
                    glowVal,
                  )!,
                  width: 1.2,
                ),
                color: AppColors.accent2.withValues(alpha: 0.06 + 0.08 * glowVal),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent2.withValues(alpha: 0.15 * glowVal),
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: Color.lerp(
                        AppColors.white.withValues(alpha: 0.85),
                        AppColors.accent2,
                        glowVal * 0.6,
                      )!,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: AppFonts.body(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.lerp(
                        AppColors.white.withValues(alpha: 0.85),
                        AppColors.accent2,
                        glowVal * 0.6,
                      )!,
                      letterSpacing: 0.6,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
