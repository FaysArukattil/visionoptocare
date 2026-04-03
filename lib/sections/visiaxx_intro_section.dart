import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../widgets/eye_loader.dart';
import '../widgets/eye_logo.dart';
import '../widgets/phone_mockup.dart';


class VisiaxxIntroSection extends StatefulWidget {
  final bool isActive;

  const VisiaxxIntroSection({super.key, required this.isActive});

  @override
  State<VisiaxxIntroSection> createState() => _VisiaxxIntroSectionState();
}

class _VisiaxxIntroSectionState extends State<VisiaxxIntroSection>
    with TickerProviderStateMixin {
  late AnimationController _phoneCtrl;
  late AnimationController _textCtrl;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();
    _phoneCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _textCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    if (widget.isActive) _startAnimation();
  }

  @override
  void didUpdateWidget(covariant VisiaxxIntroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_hasStarted) _startAnimation();
  }

  void _startAnimation() async {
    _hasStarted = true;
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _phoneCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _textCtrl.forward();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return Container(
      width: size.width,
      height: size.height,
      color: AppColors.background,
      child: Padding(
        padding: EdgeInsets.only(
          top: isMob ? 80 : 90, // Clear the navbar
          left: isMob ? 24 : 60,
          right: isMob ? 24 : 60,
          bottom: 24,
        ),
        child: isMob
            ? _buildMobileLayout()
            : _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Left: 3D iPhone ──
        Expanded(
          flex: 5,
          child: Center(
            child: AnimatedBuilder(
              animation: _phoneCtrl,
              builder: (context, _) {
                final t = CurvedAnimation(
                  parent: _phoneCtrl,
                  curve: Curves.easeOutBack,
                ).value.clamp(0.0, 1.0);
                return Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(0.15 * (1 - t)) // subtle swivel on entry
                      ..setTranslationRaw(0.0, 15.0 * (1 - t), 0.0),
                    alignment: Alignment.center,
                    child: PhoneMockup(
                      width: 260,
                      height: 500,
                      tiltX: 0.0,
                      tiltY: 0.0,
                      screen: _buildPhoneScreen(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(width: 80),

        // ── Right: Brand description ──
        Expanded(
          flex: 5,
          child: AnimatedBuilder(
            animation: _textCtrl,
            builder: (_, _) {
              final t = CurvedAnimation(
                parent: _textCtrl,
                curve: Curves.easeOutCubic,
              ).value.clamp(0.0, 1.0);
              return Opacity(
                opacity: t.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(30 * (1 - t), 0),
                  child: _buildIntroText(false),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _phoneCtrl,
            builder: (_, _) {
              final t = CurvedAnimation(
                parent: _phoneCtrl,
                curve: Curves.easeOutBack,
              ).value.clamp(0.0, 1.0);
              return Opacity(
                opacity: t,
                child: PhoneMockup(
                  width: 230,
                  height: 450,
                  tiltX: 0.0, // Phone rendered straight
                  tiltY: 0.0,
                  screen: _buildPhoneScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          AnimatedBuilder(
            animation: _textCtrl,
            builder: (_, _) {
              final t = CurvedAnimation(
                parent: _textCtrl,
                curve: Curves.easeOutCubic,
              ).value.clamp(0.0, 1.0);
              return Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, 15 * (1 - t)),
                  child: _buildIntroText(true),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneScreen() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF050A18), Color(0xFF0F172A)],
        ),
      ),
      child: Stack(
        children: [
          // Centered Logo
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Image.asset(
                'lib/assets/images/app_logo.png', // The available logo
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const EyeLogo(size: 80),
              ),
            ),
          ),

          // Tagline
          Positioned(
            left: 0,
            right: 0,
            bottom: 120, // Match the splash screen bottom offset proportionally
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Vision,\nOur Priority',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Premium Digital Eye Care',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white.withValues(alpha: 0.6),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Loading Indicator
          const Positioned(
            left: 0,
            right: 0,
            bottom: 40,
            child: Center(
              child: EyeLoader.adaptive(size: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText(bool isMob) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isMob ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.accent2.withValues(alpha: 0.1),
              border:
                  Border.all(color: AppColors.accent2.withValues(alpha: 0.3)),
            ),
            child: Text(
              'WHAT IS VISIAXX?',
              style: AppFonts.caption.copyWith(
                color: AppColors.accent2,
                letterSpacing: 3,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AN APP FOR STANDARDIZED VISION DISEASE DETECTION',
            style: AppFonts.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.5),
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              fontSize: isMob ? 9 : 11,
            ),
            textAlign: isMob ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 24),
          Text(
            'Pioneering Digital\nOptometry.',
            style: AppFonts.h2.copyWith(
              color: AppColors.white,
              fontSize: isMob ? 32 : 52, // Refined scaling
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
            textAlign: isMob ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 20),
          Text(
            'We merge clinical-grade screening with AI-driven analytics to transform your smartphone into a powerful diagnostic tool. Vision Optocare empowers patients and practitioners with accessible, high-precision ocular health tracking.',
            style: AppFonts.bodyLarge.copyWith(
              color: AppColors.muted,
              height: 1.7,
              fontSize: isMob ? 15 : 18, // Refined scaling
            ),
            textAlign: isMob ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 36),
          // Feature chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: isMob ? WrapAlignment.center : WrapAlignment.start,
            children: [
              _FeatureChip(icon: Icons.biotech, label: '12 Clinical Tests'),
              _FeatureChip(icon: Icons.language, label: '13 Languages'),
              _FeatureChip(icon: Icons.video_call, label: 'Hybrid Consults'),
              _FeatureChip(icon: Icons.picture_as_pdf, label: 'PDF Reports'),
            ],
          ),
          const SizedBox(height: 32),
          // Store Buttons
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: isMob ? WrapAlignment.center : WrapAlignment.start,
            children: [
              _StoreButton(
                storeName: 'Google Play',
                label: 'GET IT ON',
                icon: Icons.play_arrow_rounded,
                onTap: () => _showComingSoon(context),
              ),
              _StoreButton(
                storeName: 'App Store',
                label: 'DOWNLOAD ON THE',
                icon: Icons.apple,
                onTap: () => _showComingSoon(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
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
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent2, size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppFonts.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatefulWidget {
  final String storeName;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _StoreButton({
    required this.storeName,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_StoreButton> createState() => _StoreButtonState();
}

class _StoreButtonState extends State<_StoreButton> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hov
                ? AppColors.white.withValues(alpha: 0.1)
                : AppColors.white.withValues(alpha: 0.04),
            border: Border.all(
              color: _hov
                  ? AppColors.accent2.withValues(alpha: 0.5)
                  : AppColors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: _hov
                ? [
                    BoxShadow(
                      color: AppColors.accent2.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: AppColors.white, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: AppFonts.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.6),
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.storeName,
                      style: AppFonts.bodyLarge.copyWith(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
