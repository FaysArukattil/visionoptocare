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

class _StorySectionState extends State<StorySection> with TickerProviderStateMixin {
  double _dividerPos = 0.5;
  double _tiltX = 0.0;
  double _tiltY = 0.0;
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

  void _onHover(PointerEvent event, Size size) {
    if (Responsive.isMobile(context)) return;
    setState(() {
      _tiltX = (event.localPosition.dy / size.height - 0.5) * 0.12;
      _tiltY = (event.localPosition.dx / size.width - 0.5) * -0.12;
    });
  }

  void _onHoverExit(PointerEvent event) {
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    final size = MediaQuery.of(context).size;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMob ? 100 : 160),
      child: Column(
        children: [
          // 1. Evolutionary Header
          Column(
            children: [
              Text(
                'THE EVOLUTION OF CARE',
                style: AppFonts.caption.copyWith(
                  color: AppColors.accent2, 
                  letterSpacing: 4, 
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Traditional Barriers vs.\nVisiaxx Liberation',
                style: AppFonts.h1.copyWith(
                  color: AppColors.white, 
                  height: 1.1,
                  fontSize: isMob ? 36 : 60,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          
          const SizedBox(height: 80),
          
          // 2. 3D Global Comparison Stage
          Padding(
            padding: Responsive.padding(context),
            child: MouseRegion(
              onHover: (e) => _onHover(e, Size(size.width, isMob ? 400 : 550)),
              onExit: _onHoverExit,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: isMob ? 400 : 550,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_tiltX)
                  ..rotateY(_tiltY),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent2.withValues(alpha: 0.15),
                      blurRadius: 150,
                      spreadRadius: -40,
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
                        borderRadius: BorderRadius.circular(44),
                        child: Stack(
                          children: [
                            // "After" panel (Future: Visiaxx)
                            Positioned.fill(
                              child: _buildAfterPanel(constraints),
                            ),
                            
                            // "Before" panel (Past: Traditional)
                            Positioned(
                              left: 0, top: 0, bottom: 0,
                              width: constraints.maxWidth * _dividerPos,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F1218),
                                  border: Border(
                                    right: BorderSide(
                                      color: AppColors.accent2.withValues(alpha: 0.8), 
                                      width: 2.5,
                                    ),
                                  ),
                                ),
                                child: _buildBeforePanel(constraints),
                              ),
                            ),
                            
                            // Futuristic Laser Divider Handle
                            Positioned(
                              left: constraints.maxWidth * _dividerPos - 30,
                              top: 0, bottom: 0,
                              child: Center(
                                child: Container(
                                  width: 60, height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.background,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.accent2, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(color: AppColors.accent2.withValues(alpha: 0.5), blurRadius: 30)
                                    ],
                                  ),
                                  child: const Icon(Icons.compare_arrows_rounded, color: AppColors.accent2, size: 32),
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
          ),
          
          const SizedBox(height: 80),
          
          // 3. Value Props Grid (Desktop only)
          if (!isMob) const _StoryValueGrid(),
        ],
      ),
    );
  }

  Widget _buildBeforePanel(BoxConstraints constraints) {
    return Stack(
      children: [
        // Subtle Noise or Texture for 'Old' look
        Positioned.fill(
          child: Opacity(
            opacity: 0.05,
            child: CustomPaint(painter: _GridPainter(color: Colors.white, step: 20)),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white10),
                ),
                child: const Icon(Icons.history_toggle_off_rounded, size: 45, color: Colors.white38),
              ),
              const SizedBox(height: 28),
              Text(
                'TRADITIONAL CARE',
                style: AppFonts.bodyLarge.copyWith(
                  color: Colors.white70, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Physical travel • Static results\nManual record keeping',
                  style: AppFonts.bodySmall.copyWith(color: Colors.white24, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 32, left: 32,
          child: _Badge(label: 'LEGACY SYSTEM', color: Colors.white24),
        ),
      ],
    );
  }

  Widget _buildAfterPanel(BoxConstraints constraints) {
    return Stack(
      children: [
        // High-tech Blueprint Grid
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(color: AppColors.accent2.withValues(alpha: 0.08), step: 40),
          ),
        ),
        
        // Circular Glow
        Center(
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent2.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent2.withValues(alpha: 0.4), 
                      blurRadius: 40,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: const Icon(Icons.bolt_rounded, size: 55, color: Colors.white),
              ),
              const SizedBox(height: 28),
              Text(
                'VISIAXX LIBERATION',
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.white, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Instant access • Adaptive AI\nGlobal clinical precision',
                  style: AppFonts.bodySmall.copyWith(color: AppColors.accent2.withValues(alpha: 0.6), height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 32, right: 32,
          child: _Badge(label: 'VISIAXX HYBRID', color: AppColors.accent2),
        ),
      ],
    );
  }
}

class _StoryValueGrid extends StatelessWidget {
  const _StoryValueGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ValueItem(icon: Icons.timer_off_outlined, text: 'ZERO WAIT TIMES'),
        SizedBox(width: 60),
        _ValueItem(icon: Icons.public_rounded, text: 'GLOBAL REACH'),
        SizedBox(width: 60),
        _ValueItem(icon: Icons.psychology_outlined, text: 'AI PRECISION'),
      ],
    );
  }
}

class _ValueItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ValueItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent2, size: 24),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppFonts.caption.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
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
  final double step;
  _GridPainter({required this.color, this.step = 40.0});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 1;
    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(_GridPainter old) => old.color != color || old.step != step;
}
