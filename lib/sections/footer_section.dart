import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
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
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          // ── Divider Line ──
          Container(
            margin: Responsive.padding(context),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.accent2.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          // ── Footer Body ──
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF050A18),
              child: Padding(
                padding: Responsive.padding(context),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
                            _buildBrandingHeader(context, isMob),
                            SizedBox(height: isMob ? 20 : 32),
                            isMob ? _buildMobileGrid() : _buildDesktopGrid(),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.fastOutSlowIn,
                              child: _showLegal
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 24),
                                      child: _buildLegalFramework(context, isMob),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            SizedBox(height: isMob ? 16 : 32),
                            _buildSignatureBar(context, isMob),
                            SizedBox(height: isMob ? 8 : 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandingHeader(BuildContext context, bool isMob) {
    if (isMob) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const EyeLogo(size: 70, showGlow: false),
              const SizedBox(width: 16),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VISION OPTOCARE',
                      style: AppFonts.heading(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white),
                    ),
                    Text(
                      'ADVOCACY ECOSYSTEM',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.3),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }
    final size = MediaQuery.of(context).size;
    final useStack = size.width < 1100;

    return useStack
        ? Column(
            children: [
              _buildBranding(isMob: false),
              const SizedBox(height: 32),
              const _SocialCluster(),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBranding(isMob: false),
              const _SocialCluster(),
            ],
          );
  }

  Widget _buildBranding({required bool isMob}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        EyeLogo(size: isMob ? 80 : 100, showGlow: false),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VISION OPTOCARE',
              style: AppFonts.heading(
                  fontSize: isMob ? 22 : 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white),
            ),
            Text(
              'ADVOCACY ECOSYSTEM',
              style: AppFonts.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.3),
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: _GridCluster(
            title: 'MUMBAI HEADQUARTERS',
            items: ['B-19, Gokul Dham, Opp. Gokul Dham Medical Center, Goregaon(E), Mumbai-400063'],
          ),
        ),
        const SizedBox(width: 40),
        const Expanded(
          child: _GridCluster(
            title: 'DIRECT CONNECTIVITY',
            items: ['contact@visionoptocare.co.in', '+91-9819335775'],
          ),
        ),
        const SizedBox(width: 40),
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
        const SizedBox(height: 28),
        const _GridCluster(
          title: 'LOCATION',
          items: ['B-19, Gokul Dham, Mumbai-63'],
          isCentered: true,
        ),
        const SizedBox(height: 24),
        const _GridCluster(
          title: 'CONTACT',
          items: ['contact@visionoptocare.co.in', '+91-9819335775'],
          isCentered: true,
        ),
        const SizedBox(height: 24),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: Text(
        '© 2026 VISION OPTOCARE. ALL RIGHTS RESERVED.',
        style: AppFonts.caption.copyWith(
          color: AppColors.white.withValues(alpha: 0.2),
          fontSize: 10,
          letterSpacing: 1,
        ),
        textAlign: isMob ? TextAlign.center : TextAlign.left,
      ),
    );
  }

  Widget _buildLegalFramework(BuildContext context, bool isMob) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMob ? 20 : 32),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, color: AppColors.accent2, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'MEDICAL DISCLAIMER & TERMS OF USE',
                  style: AppFonts.caption.copyWith(
                    color: AppColors.accent2,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _showLegal = false),
                icon: Icon(Icons.close, color: AppColors.white.withValues(alpha: 0.3)),
                tooltip: 'Close Terms',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Important Notice: Vision Optocare provides screening and supportive data for educational and awareness purposes only. It is not a replacement for professional medical diagnosis or clinical eye examinations. All results should be treated as indicative, not absolute, as digital screenings are subject to environmental factors like lighting and screen quality. Vision Optocare, its developers, and partners are not liable for any decisions, health outcomes, or actions taken based on the results provided by this platform. By using this service, you acknowledge that you are responsible for following testing instructions accurately and maintaining your own formal clinical follow-ups. We prioritize your privacy and ensure vision data security adheres to best practices in confidentiality.',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.5),
              height: 1.8,
              fontSize: isMob ? 11 : 13,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'This notice will automatically hide after 30 seconds of visibility.',
            style: AppFonts.caption.copyWith(
              color: AppColors.accent2.withValues(alpha: 0.5),
              fontStyle: FontStyle.italic,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Grid Cluster
// ─────────────────────────────────────────────
class _GridCluster extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool isCentered;
  final Function(String)? onItemTap;

  const _GridCluster({
    required this.title,
    required this.items,
    this.isCentered = false,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: onItemTap != null ? () => onItemTap!(item) : null,
            child: Text(
              item,
              textAlign: isCentered ? TextAlign.center : TextAlign.left,
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.4),
                height: 1.6,
                fontSize: 14,
              ),
            ),
          ),
        )),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Social Cluster
// ─────────────────────────────────────────────
class _SocialCluster extends StatelessWidget {
  const _SocialCluster();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        _SocialNode(icon: Icons.close, label: 'X', baseColor: AppColors.white),
        _SocialNode(
            icon: Icons.email_outlined,
            label: 'GMAIL',
            baseColor: Colors.red.shade400),
        _SocialNode(
            icon: Icons.link,
            label: 'LINKEDIN',
            baseColor: Colors.blue.shade600),
        _SocialNode(
            icon: Icons.chat_bubble_outline,
            label: 'WHATSAPP',
            baseColor: Colors.green.shade400),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _hov ? widget.baseColor.withValues(alpha: 0.1) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: _hov ? widget.baseColor : AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          child: Icon(
            widget.icon,
            color: _hov ? widget.baseColor : AppColors.white.withValues(alpha: 0.3),
            size: 24,
          ),
        ),
      ),
    );
  }
}
