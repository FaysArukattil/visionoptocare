import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../widgets/eye_loader.dart';
import '../widgets/eye_logo.dart';
import '../widgets/phone_mockup.dart';


class VisiaxxIntroSection extends StatefulWidget {
  final bool isActive;
  final ValueNotifier<double>? scrollProgress;

  const VisiaxxIntroSection({super.key, required this.isActive, this.scrollProgress});

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
            child: Builder(
              builder: (context) {
                Widget phoneObj = PhoneMockup(
                  width: 260,
                  height: 500,
                  tiltX: 0.0,
                  tiltY: 0.0,
                  screen: _buildPhoneScreen(h: 500),
                );

                if (widget.scrollProgress != null) {
                  return ValueListenableBuilder<double>(
                    valueListenable: widget.scrollProgress!,
                    builder: (context, scrollVal, child) {
                      final width = MediaQuery.of(context).size.width;
                      final t01 = (1.0 - scrollVal).clamp(0.0, 1.0);
                      final t12 = (scrollVal - 1.0).clamp(0.0, 1.0);
                      
                      // Moves from Center of Left Half (0.25w) to Left-of-Center Column (0.80w approx)
                      // Exact Target: (w * 0.805 - 24.4) - (0.25w) = 0.555w - 24.4
                      // Final sub-pixel balance: 18.8 (Perfect center between 18.0 and 19.5)
                      final distanceX = width * 0.55 - 18.8;
                      final translateX = -800.0 * Curves.easeIn.transform(t01) + distanceX * t12;
                      final translateY = MediaQuery.of(context).size.height * t12;
                      
                      return Transform.translate(
                        offset: Offset(translateX, translateY),
                        child: child,
                      );
                    },
                    child: phoneObj,
                  );
                }

                return phoneObj;
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
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          AnimatedBuilder(
            animation: _phoneCtrl,
            builder: (_, _) {
              final t = CurvedAnimation(
                parent: _phoneCtrl,
                curve: Curves.easeOutBack,
              ).value.clamp(0.0, 1.0);

              Widget phoneObj = Opacity(
                opacity: t,
                child: PhoneMockup(
                  width: 110,
                  height: 220,
                  tiltX: 0.0, // Phone rendered straight
                  tiltY: 0.0,
                  screen: _buildPhoneScreen(h: 220, isMini: true),
                ),
              );

              if (widget.scrollProgress != null) {
                return ValueListenableBuilder<double>(
                  valueListenable: widget.scrollProgress!,
                  builder: (context, scrollVal, child) {
                    final t01 = (1.0 - scrollVal).clamp(0.0, 1.0);
                    final t12 = (scrollVal - 1.0).clamp(0.0, 1.0);

                    final translateX = -500.0 * Curves.easeIn.transform(t01);
                    final translateY = MediaQuery.of(context).size.height * t12;

                    return Transform.translate(
                      offset: Offset(translateX, translateY),
                      child: child,
                    );
                  },
                  child: phoneObj,
                );
              }

              return phoneObj;
            },
          ),
          const SizedBox(height: 20),
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

  Widget _buildPhoneScreen({required double h, bool isMini = false}) {
    // Proportional calibration matched to the official Visiaxx App design
    // Standardizing on ratios to ensure consistency across any mockup height
    final double logoSize = h * 0.32; // Scaling logo size to visual weight
    final double taglineBottom = h * 0.22; // Lowered from 0.30 for better centering
    final double loaderBottom = h * 0.07; // Proportional bottom offset

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
          // 1. Centered Logo (Positioned slightly higher for better app-screen framing)
          Positioned(
            top: h * 0.18,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: logoSize,
                height: logoSize,
                child: Image.asset(
                  'lib/assets/images/app_logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      EyeLogo(size: logoSize * 0.5),
                ),
              ),
            ),
          ),

          // 2. Tagline (Positioned at proportional anchor)
          Positioned(
            left: 0,
            right: 0,
            bottom: taglineBottom,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMini ? 12 : 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Your Vision,\nOur Priority',
                    style: TextStyle(
                      fontSize: isMini ? 14 : 18, // Reduced for mobile
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pioneering Digital Optometry',
                    style: TextStyle(
                      fontSize: isMini ? 8.0 : 11, // Further reduced for mobile
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // 3. Loading Indicator (Positioned at proportional anchor)
          Positioned(
            left: 0,
            right: 0,
            bottom: loaderBottom,
            child: Center(
              child: EyeLoader.adaptive(size: isMini ? 24 : 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroText(bool isMob) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: isMob ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          if (!isMob) ...[
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
                fontSize: 11,
              ),
              textAlign: TextAlign.start,
            ),
          ],
          SizedBox(height: isMob ? 10 : 24),
          Text(
            isMob ? 'Pioneering Digital Optometry.' : 'Pioneering Digital\nOptometry.',
            style: AppFonts.h2.copyWith(
              color: AppColors.white,
              fontSize: isMob ? 26 : 52,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
            textAlign: isMob ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: isMob ? 12 : 20),
          Text(
            isMob 
              ? 'Clinical-grade vision screening and AI diagnostics, transformed for your smartphone.'
              : 'We merge clinical-grade screening with AI-driven analytics to transform your smartphone into a powerful diagnostic tool. Vision Optocare empowers patients and practitioners with accessible, high-precision ocular health tracking.',
            style: AppFonts.bodyLarge.copyWith(
              color: AppColors.muted,
              height: 1.6,
              fontSize: isMob ? 14 : 18, 
            ),
            textAlign: isMob ? TextAlign.center : TextAlign.start,
          ),
          SizedBox(height: isMob ? 24 : 36),
          // Feature chips
          if (isMob)
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: _FeatureChip(
                          icon: Icons.biotech, label: '12 Tests'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FeatureChip(
                          icon: Icons.language, label: '13 Languages'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: _FeatureChip(
                          icon: Icons.video_call, label: 'Consultation'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _FeatureChip(
                          icon: Icons.picture_as_pdf, label: 'PDF Reports'),
                    ),
                  ],
                ),
              ],
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: const [
                _FeatureChip(icon: Icons.biotech, label: '12 Clinical Tests'),
                _FeatureChip(icon: Icons.language, label: '13 Languages'),
                _FeatureChip(icon: Icons.video_call, label: 'Hybrid Consults'),
                _FeatureChip(icon: Icons.picture_as_pdf, label: 'PDF Reports'),
              ],
            ),
          SizedBox(height: isMob ? 10 : 20),
          // Store Buttons (Row for one-line behavior)
          FittedBox(
            child: Row(
              mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                _StoreButton(
                  storeName: 'Google Play',
                  label: 'GET IT ON',
                  icon: Icons.play_arrow_rounded,
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(width: 16),
                _StoreButton(
                  storeName: 'App Store',
                  label: 'DOWNLOAD ON THE',
                  icon: Icons.apple,
                  onTap: () => _showComingSoon(context),
                ),
              ],
            ),
          ),
        ],
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
    final isMob = Responsive.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMob ? 10 : 14, vertical: isMob ? 6 : 8), // Tightened for mobile
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.white.withValues(alpha: 0.04),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: isMob ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment:
            isMob ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.accent2, size: isMob ? 12 : 14),
          const SizedBox(width: 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown, // Ensures text fits without ellipsis
              child: Text(
                label,
                style: AppFonts.caption.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                  fontSize: isMob ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
