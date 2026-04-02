import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class FoundersSection extends StatelessWidget {
  const FoundersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    
    return RepaintBoundary(
      child: ScrollRevealWidget(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 160),
          decoration: BoxDecoration(
            color: AppColors.background,
          ),
          child: Column(
            children: [
              // Section Header
              Padding(
                padding: Responsive.padding(context),
                child: Column(
                  children: [
                    Text(
                      'THE LEADERSHIP',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.accent2, 
                        letterSpacing: 4, 
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Visionaries Behind\nVisiaxx',
                      style: AppFonts.h2.copyWith(
                        color: AppColors.white, 
                        fontSize: isMob ? 32 : 56, 
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
  
              // Founder Cards
              Padding(
                padding: Responsive.padding(context),
                child: _buildFoundersGrid(context, isMob),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoundersGrid(BuildContext context, bool isMob) {
    final founders = [
      _FounderData(
        name: 'John Doe',
        role: 'CEO & Founder',
        bio: 'Visionary leader with a decade of expertise in digital health transformation.',
        icon: Icons.person_outline,
      ),
      _FounderData(
        name: 'Jane Smith',
        role: 'CTO & Co-Founder',
        bio: 'Leading a team of world-class engineers to push the boundaries of AI optometry.',
        icon: Icons.code,
      ),
    ];

    if (isMob) {
      return Column(
        children: founders.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _FounderCard(founder: f),
        )).toList(),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: founders.map((f) => SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _FounderCard(founder: f),
        ),
      )).toList(),
    );
  }
}

class _FounderData {
  final String name, role, bio;
  final IconData icon;

  const _FounderData({
    required this.name, 
    required this.role, 
    required this.bio, 
    required this.icon,
  });
}

class _FounderCard extends StatefulWidget {
  final _FounderData founder;
  const _FounderCard({required this.founder});

  @override
  State<_FounderCard> createState() => _FounderCardState();
}

class _FounderCardState extends State<_FounderCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: _hov ? AppColors.accent2.withValues(alpha: 0.3) : AppColors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            if (_hov) BoxShadow(color: AppColors.accent2.withValues(alpha: 0.1), blurRadius: 40, spreadRadius: -5),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent2.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.accent2.withValues(alpha: 0.2)),
              ),
              child: Icon(widget.founder.icon, color: AppColors.accent2, size: 48),
            ),
            const SizedBox(height: 32),
            Text(
              widget.founder.name,
              style: AppFonts.h4.copyWith(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.founder.role,
              style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
            const SizedBox(height: 24),
            Text(
              widget.founder.bio,
              style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, fontSize: 16, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialIcon(icon: Icons.link),
                const SizedBox(width: 20),
                _SocialIcon(icon: Icons.alternate_email),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white.withValues(alpha: 0.05),
      ),
      child: Icon(icon, color: AppColors.white.withValues(alpha: 0.5), size: 20),
    );
  }
}
