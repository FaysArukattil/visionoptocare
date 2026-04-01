import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class StorySection extends StatefulWidget {
  const StorySection({super.key});
  @override
  State<StorySection> createState() => _StorySectionState();
}

class _StorySectionState extends State<StorySection> with SingleTickerProviderStateMixin {
  double _dividerPos = 0.5;
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 120),
        child: Column(
          children: [
            Text(
              'EXPERIENCE THE DIFFERENCE',
              style: AppFonts.caption.copyWith(color: AppColors.accent1, letterSpacing: 3, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Eye Clinic.\nNow in Your Pocket.',
              style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.2),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 56),
            // Before / After slider
            Padding(
              padding: Responsive.padding(context),
              child: Container(
                height: isMob ? 350 : 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent2.withValues(alpha: 0.1),
                      blurRadius: 100,
                      spreadRadius: -20,
                    )
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dividerPos = (details.localPosition.dx / constraints.maxWidth).clamp(0.01, 0.99);
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Stack(
                          children: [
                            // "After" panel (full color, right)
                            Positioned.fill(
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFF0D1425), Color(0xFF050A18)],
                                  ),
                                ),
                                child: _buildAfterPanel(constraints),
                              ),
                            ),
                            // "Before" panel (grayscale, left)
                            Positioned(
                              left: 0, top: 0, bottom: 0,
                              width: constraints.maxWidth * _dividerPos,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1A1F30),
                                  border: Border(right: BorderSide(color: AppColors.accent2, width: 2)),
                                ),
                                child: _buildBeforePanel(constraints),
                              ),
                            ),
                            // Divider handle
                            Positioned(
                              left: constraints.maxWidth * _dividerPos - 25,
                              top: 0, bottom: 0,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _pulseCtrl,
                                      builder: (_, child) => Container(
                                        width: 50, height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.accent2,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.accent2.withValues(alpha: 0.4), 
                                              blurRadius: 15 + (_pulseCtrl.value * 10),
                                              spreadRadius: _pulseCtrl.value * 5,
                                            )
                                          ],
                                        ),
                                        child: child,
                                      ),
                                      child: const Icon(Icons.compare_arrows, color: AppColors.background, size: 28),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeforePanel(BoxConstraints constraints) {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
      child: Stack(
        children: [
          Center(
            child: Opacity(
              opacity: 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.history_toggle_off, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  Text('TRADITIONAL CARE', style: AppFonts.bodyLarge.copyWith(color: Colors.white70, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Long waits • Travel time • Inconvenient', style: AppFonts.bodySmall.copyWith(color: Colors.white38)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 24, left: 24,
            child: _Badge(label: 'BEFORE', color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterPanel(BoxConstraints constraints) {
    return Stack(
      children: [
        // Grid pattern for "After"
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(color: AppColors.accent2.withValues(alpha: 0.03)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.accent1.withValues(alpha: 0.3), blurRadius: 30)
                  ],
                ),
                child: const Icon(Icons.bolt, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 24),
              Text('VISIAXX DIGITAL', style: AppFonts.bodyLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Instant access • Clinical grade • 24/7', style: AppFonts.bodySmall.copyWith(color: AppColors.accent1)),
            ],
          ),
        ),
        Positioned(
          top: 24, right: 24,
          child: _Badge(label: 'AFTER', color: AppColors.accent2),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: AppFonts.caption.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    const step = 40.0;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
