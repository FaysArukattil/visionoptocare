import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../widgets/eye_loader.dart';
import '../utils/responsive.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({super.key});

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> {
  bool _showLegal = false;

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF020617), 
        border: Border(top: BorderSide(color: AppColors.white.withValues(alpha: 0.05), width: 1.0)),
      ),
      // Smaller footer vertical padding
      padding: EdgeInsets.symmetric(vertical: isMob ? 40 : 60),
      child: Column(
        children: [
          Padding(
            padding: Responsive.padding(context),
            child: isMob ? _buildMobile(context) : _buildDesktop(context),
          ),
          
          // ANIMATED LEGAL FRAMEWORK (Centered below main footer when expanded)
          AnimatedSize(
            duration: const Duration(milliseconds: 600),
            curve: Curves.fastOutSlowIn,
            child: _showLegal 
              ? Padding(
                  padding: Responsive.padding(context).copyWith(top: 40),
                  child: _buildLegalFramework(context, isMob),
                )
              : const SizedBox(height: 0, width: double.infinity),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT: MASSIVE LOGO (Unified, no text, no glow)
        EyeLogo(size: 240, showGlow: false),

        const Spacer(),

        // RIGHT: ALL OTHER CONTENT
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // SOCIALS
            const _SocialCluster(),
            
            const SizedBox(height: 24),

            // AGREEMENT
            SizedBox(
              width: 400,
              child: Text(
                'By using Visiaxx or this website, you acknowledge that you have read and agree to our Terms of Use and Privacy Policy.',
                textAlign: TextAlign.end,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.3), 
                  fontSize: 10,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // COPYRIGHT & LEGAL
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSubtleToggle(),
                const SizedBox(width: 24),
                Container(width: 1, height: 12, color: AppColors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 24),
                Text(
                  'Vision Advocacy Platform',
                  style: AppFonts.bodySmall.copyWith(color: AppColors.muted.withValues(alpha: 0.5), fontSize: 11),
                ),
                const SizedBox(width: 24),
                Container(width: 1, height: 12, color: AppColors.white.withValues(alpha: 0.1)),
                const SizedBox(width: 24),
                const RepaintBoundary(child: EyeLoader.adaptive(size: 24)),
                const SizedBox(width: 24),
                Text(
                  '© 2026 Vision Optocare',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.3), 
                    fontSize: 11,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [
        const EyeLogo(size: 160, showGlow: false),
        const SizedBox(height: 32),
        const _SocialCluster(),
        const SizedBox(height: 32),
        Text(
          'By using Visiaxx or this website, you acknowledge that you have read and agree to our Terms of Use and Privacy Policy.',
          textAlign: TextAlign.center,
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.muted.withValues(alpha: 0.3), 
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 32),
        const RepaintBoundary(child: EyeLoader.adaptive(size: 32)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSubtleToggle(),
            const SizedBox(width: 16),
            Text(
              '© 2026 Vision Optocare',
              style: AppFonts.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.3), fontSize: 11),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtleToggle() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => setState(() => _showLegal = !_showLegal),
        child: Text(
          'Legal notice',
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.3), 
            fontSize: 10,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildLegalFramework(BuildContext context, bool isMob) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: const [
              _LegalBlock(
                title: 'NON-DIAGNOSTIC TOOL',
                content: 'Visiaxx is designed as a preliminary vision screening tool for health tracking and advocacy. It does NOT provide clinical diagnoses or professional medical evaluations.',
              ),
              _LegalBlock(
                title: 'NO LIABILITY AGREEMENT',
                content: 'Vision Optocare is in no way responsible for decisions, outcomes, or misdiagnoses made based on this software. Users use these tools at their own risk.',
              ),
              _LegalBlock(
                title: 'MEDICAL REQUIREMENT',
                content: 'Results generated by Visiaxx can never replace formal clinical assessments by a qualified ophthalmologist or optometrist. Always seek professional advice.',
              ),
            ],
          ),
          const SizedBox(height: 32),
          IconButton(
            onPressed: () => setState(() => _showLegal = false),
            icon: const Icon(Icons.close, color: AppColors.muted, size: 20),
          ),
        ],
      ),
    );
  }
}

class _LegalBlock extends StatelessWidget {
  final String title;
  final String content;

  const _LegalBlock({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return Container(
      width: isMob ? double.infinity : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7), 
              fontWeight: FontWeight.w900, 
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.muted.withValues(alpha: 0.4), 
              fontSize: 11, 
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialCluster extends StatelessWidget {
  const _SocialCluster();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.end,
      children: [
        const _AnimatedSocialIcon(icon: Icons.close, label: 'X (Twitter)', baseColor: AppColors.white),
        _AnimatedSocialIcon(icon: Icons.email_outlined, label: 'Gmail', baseColor: Colors.red.shade400),
        _AnimatedSocialIcon(icon: Icons.link, label: 'LinkedIn', baseColor: Colors.blue.shade700),
        _AnimatedSocialIcon(icon: Icons.chat_bubble_outline, label: 'WhatsApp', baseColor: Colors.green.shade400),
      ],
    );
  }
}

class _AnimatedSocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color baseColor;
  const _AnimatedSocialIcon({required this.icon, required this.label, required this.baseColor});

  @override
  State<_AnimatedSocialIcon> createState() => _AnimatedSocialIconState();
}

class _AnimatedSocialIconState extends State<_AnimatedSocialIcon> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: Tooltip(
        message: widget.label,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 44, height: 44,
          decoration: BoxDecoration(
            color: _hov ? widget.baseColor.withOpacity(0.1) : AppColors.white.withOpacity(0.02),
            shape: BoxShape.circle,
            border: Border.all(
              color: _hov ? widget.baseColor.withOpacity(0.2) : AppColors.white.withOpacity(0.05),
              width: 1.0,
            ),
          ),
          child: Icon(
            widget.icon, 
            color: _hov ? widget.baseColor : AppColors.white.withOpacity(0.2), 
            size: 20,
          ),
        ),
      ),
    );
  }
}
