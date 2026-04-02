import 'dart:async';
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
  Timer? _legalTimer;

  @override
  void dispose() {
    _legalTimer?.cancel();
    super.dispose();
  }

  void _toggleLegal() {
    _legalTimer?.cancel();
    setState(() => _showLegal = !_showLegal);
    
    if (_showLegal) {
      _legalTimer = Timer(const Duration(seconds: 30), () {
        if (mounted) setState(() => _showLegal = false);
      });
    }
  }

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
        Expanded(
          child: _GridCluster(
            title: 'LEGAL & COMPLIANCE',
            items: ['Legal Terms and Service of Use'],
            onItemTap: (item) {
              if (item == 'Legal Terms and Service of Use') _toggleLegal();
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
          items: ['Legal Terms and Service of Use'],
          isCentered: true,
          onItemTap: (item) {
            if (item == 'Legal Terms and Service of Use') _toggleLegal();
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
            // Removed small eye loader from signature bar
          ],
        ),
      ),
    );
  }

  Widget _buildLegalFramework(BuildContext context, bool isMob) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, color: AppColors.accent2, size: 24),
              const SizedBox(width: 16),
              Text(
                'MEDICAL DISCLAIMER & TERMS OF USE',
                style: AppFonts.caption.copyWith(color: AppColors.accent2, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => _showLegal = false),
                icon: Icon(Icons.close, color: AppColors.white.withValues(alpha: 0.3)),
                tooltip: 'Close Terms',
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Important Notice: Vision Optocare provides screening and supportive data for educational and awareness purposes only. It is not a replacement for professional medical diagnosis or clinical eye examinations. All results should be treated as indicative, not absolute, as digital screenings are subject to environmental factors like lighting and screen quality. Vision Optocare, its developers, and partners are not liable for any decisions, health outcomes, or actions taken based on the results provided by this platform. By using this service, you acknowledge that you are responsible for following testing instructions accurately and maintaining your own formal clinical follow-ups. We prioritize your privacy and ensure vision data security adheres to best practices in confidentiality.',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.5),
              height: 1.8,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'This notice will automatically hide after 30 seconds of visibility.',
            style: AppFonts.caption.copyWith(
              color: AppColors.accent2.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
              fontSize: 11,
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

