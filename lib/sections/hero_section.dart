import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/particle_painter.dart';
import '../utils/responsive.dart';

class HeroSection extends StatefulWidget {
  final bool isActive;
  final VoidCallback? onScrollDown;

  const HeroSection({
    super.key,
    required this.isActive,
    this.onScrollDown,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  // Particle background
  late AnimationController _particleCtrl;

  // Typewriter state
  static const String _fullText = 'VISION\nOPTOCARE';
  String _displayedText = '';
  int _charIndex = 0;
  Timer? _typeTimer;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  // Staggered fade-in controllers for content after typewriter
  late AnimationController _taglineCtrl;
  late AnimationController _quoteCtrl;
  late AnimationController _descCtrl;
  late AnimationController _ctaCtrl;

  bool _typewriterDone = false;
  bool _hasStarted = false;

  @override
  void initState() {
    super.initState();

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _taglineCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _quoteCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _descCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _ctaCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _startCursorBlink();

    if (widget.isActive) _startTypewriter();
  }

  @override
  void didUpdateWidget(covariant HeroSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_hasStarted) {
      _startTypewriter();
    }
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  void _startTypewriter() {
    _hasStarted = true;
    // Slight delay so page transition completes first
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _typeTimer = Timer.periodic(const Duration(milliseconds: 70), (_) {
        if (!mounted) return;
        if (_charIndex < _fullText.length) {
          setState(() {
            _displayedText += _fullText[_charIndex];
            _charIndex++;
          });
        } else {
          _typeTimer?.cancel();
          setState(() => _typewriterDone = true);
          _revealContent();
        }
      });
    });
  }

  void _revealContent() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    _taglineCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _quoteCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _descCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _ctaCtrl.forward();
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _taglineCtrl.dispose();
    _quoteCtrl.dispose();
    _descCtrl.dispose();
    _ctaCtrl.dispose();
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMob = Responsive.isMobile(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background Particles ──
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _particleCtrl,
              builder: (context, _) => CustomPaint(
                painter: ParticlePainter(
                  animValue: _particleCtrl.value,
                  color: AppColors.accent2.withValues(alpha: 0.06),
                  count: 20,
                ),
              ),
            ),
          ),

          // ── Radial glow centre ──
          Center(
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent2.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Main Content ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMob ? 24 : 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Typewriter Brand ──
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF0F4FF), Color(0xFFA0A8C8)],
                  ).createShader(bounds),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _displayedText,
                          style: AppFonts.heading(
                            fontSize: isMob ? 60 : 110,
                            fontWeight: FontWeight.w900,
                            height: 0.88,
                            letterSpacing: isMob ? 4 : 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // Blinking Cursor
                        if (!_typewriterDone)
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 50),
                            opacity: _cursorVisible ? 1.0 : 0.0,
                            child: Text(
                              '|',
                              style: AppFonts.heading(
                                fontSize: isMob ? 60 : 110,
                                fontWeight: FontWeight.w900,
                                height: 0.88,
                                color: AppColors.accent2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Tagline Pill ──
                _FadeSlide(
                  controller: _taglineCtrl,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent2.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.accent2.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'Transforming Eye Care through Innovation.',
                      style: AppFonts.bodyLarge.copyWith(
                        color: AppColors.accent2,
                        fontWeight: FontWeight.w600,
                        fontSize: isMob ? 14 : 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Quote ──
                _FadeSlide(
                  controller: _quoteCtrl,
                  child: Text(
                    '"Your Vision, Our Priority"',
                    style: AppFonts.bodyLarge.copyWith(
                      color: AppColors.white.withValues(alpha: 0.75),
                      fontStyle: FontStyle.italic,
                      fontSize: isMob ? 16 : 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 28),

                // ── Description ──
                _FadeSlide(
                  controller: _descCtrl,
                  child: SizedBox(
                    width: isMob ? double.infinity : 680,
                    child: Text(
                      'Vision Optocare is a forward-thinking digital health startup focused on reshaping how primary eye care is delivered. By merging optometric precision with mobile-first technology, we make vision care more accessible and data-driven across the globe.',
                      style: AppFonts.bodyLarge.copyWith(
                        color: AppColors.muted,
                        height: 1.8,
                        fontSize: isMob ? 15 : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // ── Scroll CTA ──
                _FadeSlide(
                  controller: _ctaCtrl,
                  child: GestureDetector(
                    onTap: widget.onScrollDown,
                    child: _PulsingScrollCta(isMob: isMob),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────
// Fade + Slide Up helper
// ──────────────────────────────────────────
class _FadeSlide extends StatelessWidget {
  final AnimationController controller;
  final Widget child;

  const _FadeSlide({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final v = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic).value;
        return Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - v)),
            child: child,
          ),
        );
      },
    );
  }
}

// ──────────────────────────────────────────
// Pulsing Scroll CTA
// ──────────────────────────────────────────
class _PulsingScrollCta extends StatefulWidget {
  final bool isMob;
  const _PulsingScrollCta({required this.isMob});

  @override
  State<_PulsingScrollCta> createState() => _PulsingScrollCtaState();
}

class _PulsingScrollCtaState extends State<_PulsingScrollCta>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final t = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut).value;
        return Column(
          children: [
            Opacity(
              opacity: 0.4 + t * 0.6,
              child: Text(
                'Scroll to Begin',
                style: AppFonts.caption.copyWith(
                  color: AppColors.accent2,
                  letterSpacing: 3,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Transform.translate(
              offset: Offset(0, 4 * t),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accent2.withValues(alpha: 0.6 + t * 0.4),
                size: widget.isMob ? 24 : 28,
              ),
            ),
          ],
        );
      },
    );
  }
}
