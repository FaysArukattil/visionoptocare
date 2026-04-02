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
  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final topSpacer = isMob ? 60.0 : 90.0;
    
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            // TOP INVISIBLE SPACER (For overlapping eye loader)
            SizedBox(height: topSpacer),
            
            Container(
              width: double.infinity,
              color: const Color(0xFF050A18), // Pure Space Midnight
              child: Column(
                children: [
                  // 1. MAIN CONTENT (GRID)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 120),
                    child: Padding(
                      padding: Responsive.padding(context),
                      child: Column(
                        children: [
                          // TOP BRANDING & SOCIALS
                          _buildBrandingHeader(context, isMob),
                          
                          const SizedBox(height: 80),

                          // DATA GRID
                          isMob ? _buildMobileGrid() : _buildDesktopGrid(),
                          
                          // PERMANENT LEGAL FRAMEWORK
                          Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: _buildLegalFramework(context, isMob),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. SIGNATURE BAR
                  _buildSignatureBar(context, isMob),
                ],
              ),
            ),
          ],
        ),

        // 0. TOP FLOATING EYE LOADER (Always on top and fully visible)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF050A18), // Match footer background
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent2.withValues(alpha: 0.1),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const EyeLoader(size: 150),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBrandingHeader(BuildContext context, bool isMob) {
    return Row(
      mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        // BRAND IDENTITY
        Row(
          children: [
            const EyeLogo(size: 100, showGlow: false), // Increased size
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'VISION OPTOCARE',
                  style: AppFonts.heading(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.white),
                ),
                Text(
                  'ADVOCACY ECOSYSTEM',
                  style: AppFonts.caption.copyWith(color: AppColors.white.withValues(alpha: 0.3), letterSpacing: 4, fontWeight: FontWeight.bold, fontSize: 10),
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
        const Expanded(
          child: _GridCluster(
            title: 'LEGAL & COMPLIANCE',
            items: ['Legal Terms and Service of Use'],
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
          items: ['Legal Terms and Service of Use'],
          isCentered: true,
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
            // Removed small eye loader from signature bar
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
              _LegalNode(title: 'NON-DIAGNOSTIC TOOL', content: 'Vision Optocare provides screening and supportive data. It is not a replacement for professional medical diagnosis or clinical eye examinations.'),
              _LegalNode(title: 'NO LIABILITY AGREEMENT', content: 'Vision Optocare, its developers, and partners are not liable for any decisions, health outcomes, or actions taken based on the results provided by this platform.'),
              _LegalNode(title: 'ADVOCACY & EDUCATION', content: 'Our mission is to advocate for better eye health through awareness. Always consult a qualified optometrist or ophthalmologist for formal clinical advice.'),
              _LegalNode(title: 'ACCURACY & RELIABILITY', content: 'Digital screenings are subject to environmental factors like lighting and screen quality. Results should be treated as indicative, not absolute.'),
              _LegalNode(title: 'USER RESPONSIBILITY', content: 'Users are responsible for ensuring they follow the testing instructions accurately for the most reliable screening data possible.'),
              _LegalNode(title: 'DATA PROTECTION', content: 'We prioritize your vision data security. Our platform adheres to best practices in data privacy and user confidentiality.'),
            ],
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
  const _GridCluster({required this.title, required this.items, this.isCentered = false});

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
          child: Text(
            item,
            textAlign: isCentered ? TextAlign.center : TextAlign.left,
            style: AppFonts.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.4), height: 1.6, fontSize: 13),
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
