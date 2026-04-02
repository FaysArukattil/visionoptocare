import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../widgets/eye_loader.dart';


/// ── Cinematic 3D Hero Animation Engine ──
/// Orchestrates the 3-phase transformation from Traditional to Digital.
class HeroAnimationEngine extends StatelessWidget {
  final double p; // Overall scroll progress (0.0 to 1.0)
  final bool isMob;

  const HeroAnimationEngine({
    super.key,
    required this.p,
    this.isMob = false,
  });

  @override
  Widget build(BuildContext context) {
    // Stage Transitions (Internal Engine P: 0.0 to 1.0)
    // Phase 1: 0.0 -> 0.35 (Chart & Shatter)
    // Phase 2: 0.30 -> 0.70 (Iris Hologram)
    // Phase 3: 0.60 -> 1.0 (Smartphone Scanner)

    return Stack(
      alignment: Alignment.center,
      children: [
        // ── Phase 1: Traditional Shatter Stage ──
        if (p < 0.45) ...[
          Opacity(
            opacity: _calculateOpacity(p, 0.0, 0.40),
            child: _TraditionalShatterStage(p: p),
          ),
        ],

        // ── Phase 2: Pulsing Iris Hologram ──
        if (p > 0.25 && p < 0.75) ...[
          Opacity(
            opacity: _calculateOpacity(p, 0.25, 0.70, fadeInOut: true),
            child: _IrisHologram(p: p),
          ),
        ],

        // ── Phase 3: Smartphone Scanner ──
        if (p > 0.55) ...[
          Opacity(
            opacity: _calculateOpacity(p, 0.60, 1.0),
            child: _SmartphoneScanner(p: p, isMob: isMob),
          ),
        ],
      ],
    );
  }

  double _calculateOpacity(double p, double start, double end, {bool fadeInOut = false}) {
    if (p < start) {
      return 0.0;
    }
    if (p > end) {
      return fadeInOut ? 0.0 : 1.0;
    }
    
    if (fadeInOut) {
      final mid = (start + end) / 2;
      if (p < mid) {
        return (p - start) / (mid - start);
      }
      return 1.0 - (p - mid) / (end - mid);
    }
    
    return (p - start) / (end - start);
  }
}

/// ── THE ORIGIN: 3D Snellen Chart & Shatter Logic ──
class _TraditionalShatterStage extends StatefulWidget {
  final double p;
  const _TraditionalShatterStage({required this.p});

  @override
  State<_TraditionalShatterStage> createState() => _TraditionalShatterStageState();
}

class _TraditionalShatterStageState extends State<_TraditionalShatterStage> with SingleTickerProviderStateMixin {
  late AnimationController _bobCtrl;
  final List<_ShardData> _shards = _generateShards();

  @override
  void initState() {
    super.initState();
    _bobCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shatterP = (widget.p - 0.15).clamp(0.0, 1.0) * 3; // Fast shatter after 0.15

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _bobCtrl,
        builder: (context, _) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(0.05 * math.sin(_bobCtrl.value * math.pi * 2))
              ..rotateX(-0.1)
              ..setTranslationRaw(0.0, 10 * math.sin(_bobCtrl.value * math.pi * 2), 0.0),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft Neon Glow Shadow
                Container(
                  width: 280,
                  height: 400,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent2.withValues(alpha: 0.15 * (1 - shatterP).clamp(0.0, 1.0)),
                        blurRadius: 100,
                        offset: const Offset(0, 50),
                      ),
                    ],
                  ),
                ),
                
                // The Chart (or shards)
                RepaintBoundary(
                  child: CustomPaint(
                    size: const Size(300, 420),
                    painter: _ShardPainter(shards: _shards, p: shatterP, scrollP: widget.p),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static List<_ShardData> _generateShards() {
    final random = math.Random(42);
    return List.generate(10, (i) {
      return _ShardData(
        points: _generateShatterPoints(i, 10),
        trajectory: Offset(random.nextDouble() * 400 - 200, random.nextDouble() * 400 - 200),
        rotationMax: random.nextDouble() * math.pi,
        color: i % 2 == 0 ? Colors.white : AppColors.accent2.withValues(alpha: 0.2),
      );
    });
  }

  static List<Offset> _generateShatterPoints(int index, int total) {
    // Hardcoded pseudo-Voronoi shard shapes
    double w = 300; double h = 420;
    double stepW = w / 3; double stepH = h / 4;
    double x = (index % 3) * stepW;
    double y = (index ~/ 3) * stepH;
    return [
      Offset(x, y),
      Offset(x + stepW, y),
      Offset(x + stepW * 0.8, y + stepH * 1.2),
      Offset(x - stepW * 0.2, y + stepH * 0.8),
    ];
  }
}

class _ShardData {
  final List<Offset> points;
  final Offset trajectory;
  final double rotationMax;
  final Color color;
  _ShardData({required this.points, required this.trajectory, required this.rotationMax, required this.color});
}

class _ShardPainter extends CustomPainter {
  final List<_ShardData> shards;
  final double p; // Shatter progress
  final double scrollP; // Global scroll progress for scanline effects

  _ShardPainter({required this.shards, required this.p, required this.scrollP});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // Draw Shards
    for (var shard in shards) {
      canvas.save();
      
      // Interpolate position and rotation
      final offset = shard.trajectory * p;
      final rot = shard.rotationMax * p;
      final opacity = (1.0 - p * 1.5).clamp(0.0, 1.0);
      
      canvas.translate(size.width / 2 + offset.dx, size.height / 2 + offset.dy);
      canvas.rotate(rot);
      canvas.translate(-size.width / 2, -size.height / 2);

      final path = Path()..addPolygon(shard.points, true);
      paint.color = shard.color.withValues(alpha: shard.color.a * opacity);
      canvas.drawPath(path, paint);

      // Add "Traditional" content if not shattered yet
      if (p < 0.1) {
        _drawSnellenContent(canvas, size, opacity);
      }
      
      canvas.restore();
    }

    // Lens Flare Sweep (Phase 2 trigger)
    if (scrollP > 0.35 && scrollP < 0.55) {
      _drawLensFlare(canvas, size, (scrollP - 0.35) / 0.2);
    }
  }

  void _drawSnellenContent(Canvas canvas, Size size, double opacity) {
    final tp = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    void drawRow(String text, double fontSize, double y) {
      // Illuminating effect
      final illumination = (scrollP * 10 - (y/50)).clamp(0.0, 1.0);
      tp.text = TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black.withValues(alpha: opacity * illumination),
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'monospace',
          letterSpacing: fontSize * 0.4,
        ),
      );
      tp.layout(maxWidth: size.width);
      tp.paint(canvas, Offset(0, y));
    }
    drawRow('E', 80, 40);
    drawRow('F P', 45, 135);
    drawRow('T O Z', 30, 200);
    drawRow('L P E D', 22, 250);
  }

  void _drawLensFlare(Canvas canvas, Size size, double flareP) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.transparent, Colors.white.withValues(alpha: 0.4), Colors.transparent],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.save();
    canvas.translate(size.width * 2 * (flareP - 0.5), 0);
    canvas.rotate(math.pi / 6);
    canvas.drawRect(Rect.fromLTWH(-50, -size.height, 100, size.height * 3), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShardPainter oldDelegate) => true;
}

/// ── THE RUPTURE: Pulsing Iris Geometry ──
class _IrisHologram extends StatelessWidget {
  final double p;
  const _IrisHologram({required this.p});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: const Size(400, 400),
        painter: _IrisPainter(p: p),
      ),
    );
  }
}

class _IrisPainter extends CustomPainter {
  final double p;
  _IrisPainter({required this.p});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..color = AppColors.accent2.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final breath = math.sin(DateTime.now().millisecondsSinceEpoch / 500) * 0.05 + 1.0;
    
    // Concentric Iris Arcs
    for (int i = 0; i < 5; i++) {
        final radius = (40 + i * 30) * breath;
        canvas.drawCircle(center, radius, paint..color = AppColors.accent2.withValues(alpha: 0.1 * (5 - i)));
        
        // Dynamic segments
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          p * math.pi * 2 + i,
          math.pi / 2,
          false,
          paint..strokeWidth = 2.0,
        );
    }

    // Radial Breathing Lines
    for (int i = 0; i < 36; i++) {
      final angle = i * 10 * math.pi / 180;
      final start = center + Offset(math.cos(angle) * 30, math.sin(angle) * 30);
      final end = center + Offset(math.cos(angle) * 160 * breath, math.sin(angle) * 160 * breath);
      canvas.drawLine(start, end, paint..color = AppColors.accent2.withValues(alpha: 0.05));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// ── THE FUTURE: Smartphone with Official Splash UI ──
class _SmartphoneScanner extends StatelessWidget {
  final double p;
  final bool isMob;
  const _SmartphoneScanner({required this.p, required this.isMob});

  @override
  Widget build(BuildContext context) {
    final entryP = (p - 0.55) / 0.45; // 0.0 to 1.0 between p=0.55 and 1.0
    
    return RepaintBoundary(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..setTranslationRaw(0.0, 300 * (1 - entryP.clamp(0.0, 1.0)), 0.0) 
          ..rotateX(0.4 * (1 - entryP.clamp(0.0, 1.0))) 
          ..rotateY(-0.35 * (1 - entryP.clamp(0.0, 1.0))),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Background Glass Cards
            _buildGlassCard(entryP, -140 * (isMob ? 0.7 : 1.0), -80, "Acuity: 20/20", 0.7),
            _buildGlassCard(entryP, 140 * (isMob ? 0.7 : 1.0), 100, "Scan Ready ✓", 0.8),
            
            // The Phone (Smartphone Mockup)
            Container(
              width: isMob ? 280 : 320,
              height: isMob ? 550 : 600,
              decoration: BoxDecoration(
                color: const Color(0xFF020617),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: AppColors.accent2.withValues(alpha: 0.3), width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent2.withValues(alpha: 0.4 * entryP.clamp(0.0, 1.0)),
                    blurRadius: 100,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(47),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF020617), Color(0xFF0F172A)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Official Splash Layout
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: isMob ? 90 : 120),
                            const EyeLogo(size: 110),
                            const SizedBox(height: 48),
                            Text(
                              'Your Vision, Our Priority',
                              style: AppFonts.bodyLarge.copyWith(
                                color: AppColors.white.withValues(alpha: 0.85),
                                fontSize: isMob ? 16 : 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Premium Digital eye care',
                              style: AppFonts.caption.copyWith(
                                color: AppColors.accent2.withValues(alpha: 0.7),
                                fontSize: isMob ? 11 : 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
  
                      // Official EyeLoader Footer
                      Positioned(
                        bottom: 45,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: RepaintBoundary(
                            child: Opacity(
                              opacity: entryP.clamp(0.0, 1.0),
                              child: const EyeLoader.adaptive(size: 50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard(double p, double dx, double dy, String text, double delay) {
    final cardP = (p - delay * 0.5).clamp(0.0, 1.0);
    return Transform.translate(
      offset: Offset(dx * cardP, dy * cardP),
      child: Opacity(
        opacity: cardP,
        child: RepaintBoundary(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20),
              ],
            ),
            child: Text(
              text,
              style: AppFonts.caption.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

