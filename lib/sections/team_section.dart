import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';

/// Page 8: The Team — CTO and Software Engineer with portrait images
class TeamSection extends StatefulWidget {
  final bool isActive;
  const TeamSection({super.key, this.isActive = false});

  @override
  State<TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<TeamSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isActive) _start();
  }

  @override
  void didUpdateWidget(covariant TeamSection old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_hasStarted) _start();
  }

  void _start() async {
    _hasStarted = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t =
            CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic).value;
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - t)),
            child: Container(
              width: size.width,
              height: size.height,
              color: AppColors.background,
              child: Column(
                children: [
                  SizedBox(height: isMob ? 90 : 110),
                  Padding(
                    padding: Responsive.padding(context),
                    child: Column(
                      children: [
                        Text(
                          'THE TEAM',
                          style: AppFonts.caption.copyWith(
                            color: AppColors.accent2,
                            letterSpacing: 4,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Engineering\nExcellence',
                          style: AppFonts.h2.copyWith(
                            color: AppColors.white,
                            fontSize: isMob ? 28 : 52,
                            height: 1.1,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isMob ? 24 : 48),
                  Expanded(
                    child: Padding(
                      padding: Responsive.padding(context),
                      child: isMob
                          ? _buildMobileLayout()
                          : _buildDesktopLayout(),
                    ),
                  ),
                  SizedBox(height: isMob ? 16 : 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _TeamPortraitCard(
                name: 'Sherly Mary Daniel',
                role: 'CHIEF TECHNOLOGY OFFICER',
                imagePath: 'assets/images/Team_members/Cto.jpeg',
                credential: 'B.Tech ECE',
                experience: '9 Years in IT',
                accentColor: const Color(0xFF9D4EDD),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _TeamPortraitCard(
                name: 'Fays Arukattil',
                role: 'SOFTWARE ENGINEER — PRODUCT & R&D',
                imagePath: 'assets/images/Team_members/Lead_Dev.jpeg',
                credential: 'B.Tech CS',
                experience: 'Flutter · HealthTech · Full-Stack',
                accentColor: const Color(0xFFF5C842),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          _TeamPortraitCard(
            name: 'Sherly Mary Daniel',
            role: 'CHIEF TECHNOLOGY OFFICER',
            imagePath: 'assets/images/Team_members/Cto.jpeg',
            credential: 'B.Tech ECE',
            experience: '9 Years in IT',
            accentColor: const Color(0xFF9D4EDD),
            isMobile: true,
          ),
          const SizedBox(height: 16),
          _TeamPortraitCard(
            name: 'Fays Arukattil',
            role: 'SOFTWARE ENGINEER — PRODUCT & R&D',
            imagePath: 'assets/images/Team_members/Lead_Dev.jpeg',
            credential: 'B.Tech CS',
            experience: 'Flutter · HealthTech · Full-Stack',
            accentColor: const Color(0xFFF5C842),
            isMobile: true,
          ),
        ],
      ),
    );
  }
}

// ── Portrait Card (same style as Leadership section) ──
class _TeamPortraitCard extends StatefulWidget {
  final String name, role, imagePath, credential, experience;
  final Color accentColor;
  final bool isMobile;

  const _TeamPortraitCard({
    required this.name,
    required this.role,
    required this.imagePath,
    required this.credential,
    required this.experience,
    required this.accentColor,
    this.isMobile = false,
  });

  @override
  State<_TeamPortraitCard> createState() => _TeamPortraitCardState();
}

class _TeamPortraitCardState extends State<_TeamPortraitCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final isMob = widget.isMobile;
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.0, end: _hov ? 1.0 : 0.0),
        builder: (context, v, _) => Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.04 + 0.04 * v),
            borderRadius: BorderRadius.circular(isMob ? 24 : 32),
            border: Border.all(
              color: Color.lerp(
                AppColors.white.withValues(alpha: 0.06),
                widget.accentColor.withValues(alpha: 0.35),
                v,
              )!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    widget.accentColor.withValues(alpha: 0.05 + 0.08 * v),
                blurRadius: 40,
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(isMob ? 24 : 32),
            child: Column(
              children: [
                // ── Large Portrait ──
                Expanded(
                  flex: isMob ? 4 : 6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color:
                              widget.accentColor.withValues(alpha: 0.1),
                          child: Icon(Icons.person,
                              color: widget.accentColor, size: 80),
                        ),
                      ),
                      // Bottom gradient
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppColors.background
                                    .withValues(alpha: 0.95),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Experience badge
                      Positioned(
                        top: isMob ? 12 : 20,
                        right: isMob ? 12 : 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMob ? 10 : 14,
                            vertical: isMob ? 5 : 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background
                                .withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.accentColor
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            widget.experience,
                            style: AppFonts.caption.copyWith(
                              color: widget.accentColor,
                              fontSize: isMob ? 8 : 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Info ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMob ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Role pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              widget.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.accentColor
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        child: Text(
                          widget.role,
                          style: AppFonts.caption.copyWith(
                            color: widget.accentColor,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            fontSize: isMob ? 7 : 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: isMob ? 8 : 12),
                      // Name
                      Text(
                        widget.name,
                        style: AppFonts.h4.copyWith(
                          color: AppColors.white,
                          fontSize: isMob ? 18 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isMob ? 4 : 6),
                      // Credential
                      Text(
                        widget.credential,
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.muted,
                          fontSize: isMob ? 11 : 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
