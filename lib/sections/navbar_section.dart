import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../utils/responsive.dart';

class NavbarSection extends StatefulWidget {
  final bool isScrolled;
  const NavbarSection({super.key, required this.isScrolled});

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
            sigmaX: isGlass ? 32 : 0,
            sigmaY: isGlass ? 32 : 0,
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
                    horizontal: isMob ? 16 : 32,
                  ),
                  child: Row(
                    children: [
                      // ── Logo (Left) ──
                      _buildLogo(isMob),
                      const Spacer(),
                      // ── Nav Links (Desktop) ──
                      if (!isMob) ...[
                        for (final link in ['Home', 'Services', 'About Us'])
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _NavLink(label: link),
                          ),
                        const SizedBox(width: 16),
                        _buildExploreButton(),
                      ],
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
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: Column(
                        children: [
                          Divider(
                            color: AppColors.white.withValues(alpha: 0.1),
                            thickness: 1,
                          ),
                          const SizedBox(height: 24),
                          for (final link in ['Home', 'Services', 'About Us'])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _NavLink(label: link),
                            ),
                          const SizedBox(height: 12),
                          _buildExploreButton(),
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

  // ── Explore CTA Button ──
  Widget _buildExploreButton() {
    return _GlowButton(
      label: 'Explore',
      onTap: () {},
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
  const _NavLink({required this.label});
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
    );
    _underlineWidth = Tween<double>(begin: 0, end: 28).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _colorLerp = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
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
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final textColor = Color.lerp(
            AppColors.white.withValues(alpha: 0.7),
            AppColors.accent2,
            _colorLerp.value,
          )!;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppFonts.body(
                  fontSize: 14.5,
                  fontWeight:
                      _hovered ? FontWeight.w600 : FontWeight.w400,
                  color: textColor,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: _underlineWidth.value,
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
                      color:
                          AppColors.accent2.withValues(alpha: 0.4 * _colorLerp.value),
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
    );
  }
}

// ══════════════════════════════════════════════
//  Glowing "Explore" Button
// ══════════════════════════════════════════════
class _GlowButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.onTap});

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
              child: Text(
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
            );
          },
        ),
      ),
    );
  }
}
