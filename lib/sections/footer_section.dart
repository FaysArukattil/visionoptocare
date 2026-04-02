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
      width: double.infinity,
      color: const Color(0xFF050A18), // Pure Space Midnight
      child: Column(
        children: [
          // 1. MAIN CONTENT (GRID)
          Padding(
            padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
            child: Padding(
              padding: Responsive.padding(context),
              child: Column(
                children: [
                  // TOP BRANDING & SOCIALS
                  _buildBrandingHeader(context, isMob),
                  
                  const SizedBox(height: 80),

                  // DATA GRID
                  isMob ? _buildMobileGrid() : _buildDesktopGrid(),
                  
                  // ANIMATED LEGAL FRAMEWORK
                  AnimatedSize(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.fastOutSlowIn,
                    child: _showLegal 
                      ? Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: _buildLegalFramework(context, isMob),
                        )
                      : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // 2. SIGNATURE BAR
          _buildSignatureBar(context, isMob),
        ],
      ),
    );
  }

  Widget _buildBrandingHeader(BuildContext context, bool isMob) {
    return Row(
      mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        // BRAND IDENTITY
        Row(
          children: [
            const EyeLogo(size: 64, showGlow: false),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VISION OPTOCARE',
                  style: AppFonts.heading(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.white),
                ),
                Text(
                  'ADVOCACY ECOSYSTEM',
                  style: AppFonts.caption.copyWith(color: AppColors.white.withValues(alpha: 0.3), letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 9),
                ),
              ],
            ),
          ],
        ),

        // SOCIAL CLUSTER
        if (!isMob) const _SocialCluster(),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LOCATION
        const Expanded(
          child: _GridCluster(
            title: 'MUMBAI HEADQUARTERS',
            items: [
              'B-19, Gokul Dham, Opp. Gokul Dham Medical Center, Goregaon(E), Mumbai-400063',
            ],
          ),
        ),
        const SizedBox(width: 40),
        // CONTACT
        const Expanded(
          child: _GridCluster(
            title: 'DIRECT CONNECTIVITY',
            items: [
              'contact@visionoptocare.co.in',
              '+91-9819335775',
            ],
          ),
        ),
        const SizedBox(width: 40),
        // RESOURCES
        Expanded(
          child: _GridCluster(
            title: 'RESOURCES & LEGAL',
            items: ['PRIVACY POLICY', 'TERMS OF SERVICE', 'MEDICAL DISCLAIMER'],
            onItemTap: (item) {
              if (item == 'MEDICAL DISCLAIMER') setState(() => _showLegal = !_showLegal);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileGrid() {
    return Column(
      children: [
        const _SocialCluster(),
        const SizedBox(height: 60),
        const _GridCluster(
          title: 'LOCATION',
          items: ['B-19, Gokul Dham, Mumbai-63'],
          isCentered: true,
        ),
        const SizedBox(height: 48),
        const _GridCluster(
          title: 'CONTACT',
          items: ['contact@visionoptocare.co.in', '+91-9819335775'],
          isCentered: true,
        ),
        const SizedBox(height: 48),
        _GridCluster(
          title: 'RESOURCES',
          items: ['PRIVACY', 'TERMS', 'DISCLAIMER'],
          isCentered: true,
          onItemTap: (item) {
            if (item == 'DISCLAIMER') setState(() => _showLegal = !_showLegal);
          },
        ),
      ],
    );
  }

  Widget _buildSignatureBar(BuildContext context, bool isMob) {
    return Container(
      width: double.infinity,
      color: Colors.black.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Padding(
        padding: Responsive.padding(context),
        child: Row(
          mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '© 2026 VISION OPTOCARE. ALL RIGHTS RESERVED.',
              style: AppFonts.caption.copyWith(color: AppColors.white.withValues(alpha: 0.2), fontSize: 10, letterSpacing: 1),
            ),
            if (!isMob) const RepaintBoundary(child: EyeLoader.adaptive(size: 28)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalFramework(BuildContext context, bool isMob) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.01),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: const [
              _LegalNode(title: 'NON-DIAGNOSTIC TOOL', content: 'Supportive screening only. Not a medical replacement.'),
              _LegalNode(title: 'NO LIABILITY AGREEMENT', content: 'Vision Optocare is in no way responsible for decisions.'),
              _LegalNode(title: 'ADVOCACY MISSION', content: 'Contact qualified personnel for formal clinical advice.'),
            ],
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => setState(() => _showLegal = false),
            child: Text(
              'CLOSE DISCLAIMER',
              style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCluster extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isCentered;
  final Function(String)? onItemTap;
  const _GridCluster({required this.title, required this.items, this.isCentered = false, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.caption.copyWith(color: AppColors.white.withValues(alpha: 0.6), fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 11),
        ),
        const SizedBox(height: 24),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: onItemTap != null ? () => onItemTap!(item) : null,
            child: Text(
              item,
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              style: AppFonts.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.4), height: 1.6, fontSize: 13),
            ),
          ),
        )),
      ],
    );
  }
}

class _SocialCluster extends StatelessWidget {
  const _SocialCluster();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SocialNode(icon: Icons.close, label: 'X', baseColor: AppColors.white),
        const SizedBox(width: 24),
        _SocialNode(icon: Icons.email_outlined, label: 'GMAIL', baseColor: Colors.red.shade400),
        const SizedBox(width: 24),
        _SocialNode(icon: Icons.link, label: 'LINKEDIN', baseColor: Colors.blue.shade600),
        const SizedBox(width: 24),
        _SocialNode(icon: Icons.chat_bubble_outline, label: 'WHATSAPP', baseColor: Colors.green.shade400),
      ],
    );
  }
}

class _SocialNode extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color baseColor;
  const _SocialNode({required this.icon, required this.label, required this.baseColor});

  @override
  State<_SocialNode> createState() => _SocialNodeState();
}

class _SocialNodeState extends State<_SocialNode> {
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
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: _hov ? widget.baseColor.withValues(alpha: 0.1) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: _hov ? widget.baseColor : AppColors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(
            widget.icon, 
            color: _hov ? widget.baseColor : AppColors.white.withValues(alpha: 0.3), 
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _LegalNode extends StatelessWidget {
  final String title;
  final String content;
  const _LegalNode({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 10)),
          const SizedBox(height: 8),
          Text(content, style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 11)),
        ],
      ),
    );
  }
}
