import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/phone_mockup.dart';
import '../utils/responsive.dart';

enum TestTier { quick, full, personal, pro }

class TestData {
  final String number, name, desc;
  final TestTier tier;
  final IconData icon;
  const TestData(this.number, this.name, this.desc, this.tier, this.icon);
}

const _tests = [
  TestData('01', 'Visual Acuity', 'Measures how clearly you can see at a distance. It reveals the sharpness of your far vision for each eye individually.', TestTier.quick, Icons.visibility),
  TestData('02', 'Reading Test', 'Assesses how well you can read and see up close. It reveals your near vision clarity and reading accuracy.', TestTier.quick, Icons.menu_book),
  TestData('03', 'Color Vision', 'Checks whether you can correctly distinguish colors. It reveals if you have any color deficiency.', TestTier.quick, Icons.palette),
  TestData('04', 'Amsler Grid', 'Tests the central portion of your vision. It reveals whether you perceive any distortions or blurry patches.', TestTier.quick, Icons.grid_on),
  TestData('05', 'Contrast Sensitivity', 'Evaluates how well you can distinguish objects from their background. It reveals whether your vision degrades in low-contrast conditions.', TestTier.full, Icons.contrast),
  TestData('06', 'Mobile Refractometry', 'Estimates your eye\'s refractive error. It reveals whether you are nearsighted, farsighted, or have astigmatism.', TestTier.full, Icons.qr_code_scanner),
  TestData('07', 'Eye Hydration', 'Monitors your blink rate. It reveals whether your eyes show signs of dryness or insufficient lubrication.', TestTier.personal, Icons.water_drop),
  TestData('08', 'Shadow Test', 'Examines internal structures using light reflection. It reveals the health of eye structures like the lens and retina.', TestTier.pro, Icons.dark_mode),
  TestData('09', 'Stereopsis', 'Tests depth perception and 3D vision. It reveals how well both eyes work together to merge images.', TestTier.pro, Icons.view_in_ar),
  TestData('10', 'Visual Field', 'Maps what you can see without moving your eyes. It reveals blind spots or peripheral vision loss.', TestTier.pro, Icons.radar),
  TestData('11', 'Cover Test', 'Checks for eye alignment and muscle balance. It reveals whether eyes deviate inward, outward, up, or down.', TestTier.pro, Icons.flip),
  TestData('12', 'Torchlight Exam', 'A clinical examination using light. It reveals pupil reflexes and muscle movement, helping detect nerve abnormalities.', TestTier.pro, Icons.flashlight_on),
];

class TestsSection extends StatefulWidget {
  final bool isActive;
  const TestsSection({super.key, required this.isActive});

  @override
  State<TestsSection> createState() => _TestsSectionState();
}

class _TestsSectionState extends State<TestsSection> with TickerProviderStateMixin {
  late AnimationController _scrollCtrl;
  final ValueNotifier<double> _scrollPos = ValueNotifier<double>(0.0);
  final FocusNode _focusNode = FocusNode();
  
  Timer? _autoTimer;
  bool _userIntervened = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl = AnimationController(
      vsync: this, 
      value: 0.0,
      duration: const Duration(milliseconds: 300),
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
    _scrollCtrl.addListener(() {
      _scrollPos.value = _scrollCtrl.value;
    });
    
    if (widget.isActive) _startAutoCycle();
  }

  @override
  void didUpdateWidget(covariant TestsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _userIntervened = false;
      _startAutoCycle();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAutoCycle();
    }
  }

  void _startAutoCycle() {
    _stopAutoCycle();
    if (_userIntervened) return;

    // Continuous smooth scroll through all 12 tests
    // ~1.5 seconds per test = 18 seconds total
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted || _userIntervened) return;
      _scrollCtrl.animateTo(
        11.0,
        duration: const Duration(seconds: 18),
        curve: Curves.linear,
      );
    });
  }

  void _stopAutoCycle() {
    _autoTimer?.cancel();
    _autoTimer = null;
    _scrollCtrl.stop();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    _userIntervened = true;
    _stopAutoCycle();

    // Vertical drag scrolls the 3D HUD
    _scrollCtrl.value -= d.delta.dy / (Responsive.isMobile(context) ? 50 : 100); 
  }

  void _onPanEnd(DragEndDetails d) {
    _snapToNearest();
  }

  void _snapToNearest() {
    _userIntervened = true;
    _stopAutoCycle();

    final target = _scrollPos.value.roundToDouble();
    _scrollCtrl.value = _scrollPos.value;
    _scrollCtrl.animateTo(target, curve: Curves.easeOutCubic);
  }

  void _onTapItem(int index) {
    _userIntervened = true;
    _stopAutoCycle();

    // Shortest path logic for infinite loop
    double current = _scrollPos.value;
    double target = index.toDouble();
    
    double diff = target - (current % _tests.length);
    if (diff > _tests.length / 2) diff -= _tests.length;
    if (diff < -_tests.length / 2) diff += _tests.length;

    _scrollCtrl.value = _scrollPos.value;
    _scrollCtrl.animateTo(_scrollPos.value + diff, curve: Curves.easeOutBack, duration: const Duration(milliseconds: 600));
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      _userIntervened = true;
      _stopAutoCycle();

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _scrollCtrl.animateTo((_scrollPos.value + 1).roundToDouble(), curve: Curves.easeOutBack);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _scrollCtrl.animateTo((_scrollPos.value - 1).roundToDouble(), curve: Curves.easeOutBack);
      }
    }
  }

  @override
  void dispose() { 
    _stopAutoCycle();
    _scrollCtrl.dispose(); 
    _scrollPos.dispose();
    _focusNode.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Stack(
        children: [
          // 1. Dynamic 'Neural' Background 
          Positioned.fill(
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollPos,
              builder: (context, pos, _) {
                if (!pos.isFinite) return const SizedBox.shrink();
                final test = _tests[(pos.round() % _tests.length).abs() % _tests.length];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.5,
                        colors: [
                          _getTierColor(test.tier).withValues(alpha: 0.05),
                          AppColors.background.withValues(alpha: 0.1),
                          AppColors.background,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _SystemTelemetryPainter(
                        animValue: pos,
                        color: _getTierColor(test.tier),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Main 3D Experience
          ValueListenableBuilder<double>(
            valueListenable: _scrollPos,
            builder: (context, pos, child) {
              if (!pos.isFinite) return const SizedBox.shrink();
              
              int sIdx = (pos.round() % _tests.length);
              if (sIdx < 0) sIdx += _tests.length;

              final test = _tests[sIdx];
              final themeColor = _getTierColor(test.tier);

              return GestureDetector(
                onVerticalDragUpdate: _onPanUpdate,
                onVerticalDragEnd: _onPanEnd,
                behavior: HitTestBehavior.translucent,
                child: isMob 
                    ? _buildMobileLayout(test, themeColor, sIdx, pos) 
                    : _buildDesktopLayout(test, themeColor, sIdx, pos),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getTierColor(TestTier tier) {
    switch (tier) {
      case TestTier.pro: return const Color(0xFFFFCC00);
      case TestTier.personal: return const Color(0xFF00FFCC);
      case TestTier.full: return const Color(0xFF6366F1);
      default: return AppColors.accent2;
    }
  }

  Widget _buildDesktopLayout(TestData test, Color themeColor, int selectedIndex, double scrollPos) {
    return Stack(
      children: [
        // ── Left: Interactive 3D HUD ──
        Positioned(
          left: 60,
          top: 0,
          bottom: 0,
          width: 500,
          child: _buildTacticalHUD(false, scrollPos),
        ),

        // ── Center: Floating Phone Simulation ──
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 100), // Offset from HUD
            child: _buildFloatingPhone(test, themeColor),
          ),
        ),

        // ── Right: Elevated Data Card ──
        Positioned(
          right: 60,
          bottom: 60,
          child: _buildDetailCard(test, themeColor, false),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(TestData test, Color themeColor, int selectedIndex, double scrollPos) {
    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        _userIntervened = true;
        _stopAutoCycle();
        _scrollCtrl.value -= d.delta.dx / 50;
      },
      onHorizontalDragEnd: (_) => _snapToNearest(),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: _buildTacticalHUD(true, scrollPos),
          ),
          Expanded(
            flex: 5,
            child: _buildFloatingPhone(test, themeColor, isMob: true),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDetailCard(test, themeColor, true),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildTacticalHUD(bool isMob, double scrollPos) {
    return Stack(
      alignment: Alignment.center,
      children: List.generate(_tests.length, (i) {
        double diff = i - scrollPos;
        while (diff > 6.0) { diff -= 12.0; }
        while (diff < -6.0) { diff += 12.0; }

        final absDiff = diff.abs();
        final isSelected = absDiff < 0.5;
        
        // 3D Perspective Mapping
        final double z = absDiff * 100; // Depth
        final double y = diff * 120; // Vertical spread
        final double scale = (1.0 - (absDiff * 0.15)).clamp(0.5, 1.0);
        final double opacity = (1.0 - (absDiff * 0.25)).clamp(0.0, 1.0);

        if (opacity < 0.1) return const SizedBox.shrink();

        return Positioned(
          top: (isMob ? 80 : 250) + y,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..translateByDouble(0.0, 0.0, -z, 1.0),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: GestureDetector(
                  onTap: () => _onTapItem(i),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: _HUDItem(
                      test: _tests[i],
                      isSelected: isSelected,
                      themeColor: _getTierColor(_tests[i].tier),
                      isMob: isMob,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFloatingPhone(TestData test, Color themeColor, {bool isMob = false}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(seconds: 12),
      curve: Curves.easeInOut,
      builder: (context, val, child) {
        final floatY = math.sin(val * math.pi * 2) * 0.4;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: PhoneMockup(
            width: isMob ? 200 : 260,
            height: isMob ? 420 : 560,
            tiltX: 0.0,
            tiltY: 0.0,
            screen: _TestSimulationEngine(test: test, themeColor: themeColor),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(TestData test, Color themeColor, bool isMob) {
    return Container(
      width: isMob ? double.infinity : 380,
      padding: EdgeInsets.all(isMob ? 16 : 32),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(isMob ? 16 : 24),
        border: Border.all(color: themeColor.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 8, height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: themeColor),
              ),
              const SizedBox(width: 10),
              Text(
                test.tier.name.toUpperCase(),
                style: AppFonts.caption.copyWith(
                  color: themeColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: isMob ? 9 : 12,
                ),
              ),
            ],
          ),
          SizedBox(height: isMob ? 8 : 16),
          Text(test.name, style: AppFonts.h3.copyWith(color: Colors.white, fontSize: isMob ? 18 : 24)),
          SizedBox(height: isMob ? 6 : 12),
          Text(
            test.desc,
            style: AppFonts.bodyLarge.copyWith(
              color: AppColors.muted,
              height: 1.5,
              fontSize: isMob ? 12 : 16,
            ),
            maxLines: isMob ? 2 : 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HUDItem extends StatelessWidget {
  final TestData test;
  final bool isSelected;
  final Color themeColor;
  final bool isMob;

  const _HUDItem({required this.test, required this.isSelected, required this.themeColor, required this.isMob});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isMob ? 200 : 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? themeColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? themeColor : Colors.white10),
      ),
      child: Row(
        children: [
          Icon(test.icon, color: isSelected ? themeColor : Colors.white24, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              test.name.toUpperCase(),
              style: AppFonts.heading(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.white24,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestSimulationEngine extends StatefulWidget {
  final TestData test;
  final Color themeColor;
  const _TestSimulationEngine({required this.test, required this.themeColor});

  @override
  State<_TestSimulationEngine> createState() => _TestSimulationEngineState();
}

class _TestSimulationEngineState extends State<_TestSimulationEngine> with TickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Basic grid background
          Positioned.fill(
            child: CustomPaint(painter: _DiagnosticGridPainter(color: widget.themeColor.withValues(alpha: 0.1))),
          ),
          
          Center(
            child: _buildSimulation(widget.test.number),
          ),

          // Scanning Line
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) => Positioned(
              top: _anim.value * 600,
              left: 0, right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: widget.themeColor,
                  boxShadow: [BoxShadow(color: widget.themeColor, blurRadius: 10)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulation(String testNum) {
    switch (testNum) {
      case '01': // Visual Acuity
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('E', style: TextStyle(color: Colors.white, fontSize: 80 * (1 - _anim.value * 0.5), fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('F P', style: TextStyle(color: Colors.white, fontSize: 40 * (1 - _anim.value * 0.5))),
              const SizedBox(height: 5),
              Text('T O Z', style: TextStyle(color: Colors.white, fontSize: 20 * (1 - _anim.value * 0.5))),
            ],
          ),
        );
      case '02': // Reading Test
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) {
            final text = "Reading clarity is essential for daily life. Optometry advanced analytics.";
            final visibleChars = (text.length * _anim.value).toInt();
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                text.substring(0, visibleChars),
                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      case '03': // Color Vision
        return CustomPaint(
          size: const Size(180, 180),
          painter: _IshiharaPainter(anim: _anim, color: widget.themeColor),
        );
      case '04': // Amsler Grid
        return CustomPaint(
          size: const Size(160, 160),
          painter: _AmslerPainter(anim: _anim, color: widget.themeColor),
        );
      case '05': // Contrast Sensitivity
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => Opacity(
            opacity: 0.1 + (_anim.value * 0.8),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('CONTRAST', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                Text('LEVEL 12', style: TextStyle(color: Colors.white12, fontSize: 10, letterSpacing: 4)),
              ],
            ),
          ),
        );
      case '06': // Refractometry
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: widget.themeColor, width: 2))),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) => Transform.rotate(
                    angle: _anim.value * math.pi * 2,
                    child: Container(width: 120, height: 2, color: widget.themeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('REFRACTING...', style: TextStyle(color: widget.themeColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        );
      case '07': // Eye Hydration
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, size: 60, color: widget.themeColor.withValues(alpha: 0.5 + math.sin(_anim.value * math.pi) * 0.5)),
              const SizedBox(height: 10),
              Text('HYDRATION: ${(70 + _anim.value * 20).toInt()}%', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      case '09': // Stereopsis
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: List.generate(4, (i) {
              final angle = (_anim.value * math.pi * 2) + (i * math.pi / 2);
              return Transform.translate(
                offset: Offset(math.cos(angle) * 40, math.sin(angle) * 40),
                child: Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.themeColor)),
              );
            }),
          ),
        );
      case '10': // Visual Field (Sonar)
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: widget.themeColor.withValues(alpha: 0.2)),
                ),
              ),
              // Radar sweep
              Transform.rotate(
                angle: _anim.value * math.pi * 2,
                child: Container(
                  width: 140, height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [widget.themeColor.withValues(alpha: 0.5), Colors.transparent],
                      stops: const [0.1, 0.2],
                    ),
                  ),
                ),
              ),
              if (_anim.value > 0.7)
                Positioned(top: 40, left: 30, child: Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.themeColor))),
            ],
          ),
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.test.icon, size: 80, color: widget.themeColor),
            const SizedBox(height: 20),
            Text('ACTIVE SENSOR', style: TextStyle(color: widget.themeColor, fontSize: 10, letterSpacing: 2)),
          ],
        );
    }
  }
}

class _AmslerPainter extends CustomPainter {
  final Animation<double> anim;
  final Color color;
  _AmslerPainter({required this.anim, required this.color}) : super(repaint: anim);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.2)..strokeWidth = 1;
    final w = size.width;
    final h = size.height;
    
    for (double i = 0; i <= w; i += 20) {
      final path = Path();
      path.moveTo(i, 0);
      for (double j = 0; j <= h; j += 5) {
        final warp = math.sin((anim.value * math.pi * 2) + (j * 0.05)) * 2;
        path.lineTo(i + (isSelectedPoint(i, j) ? warp : 0), j);
      }
      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
    for (double j = 0; j <= h; j += 20) {
      final path = Path();
      path.moveTo(0, j);
      for (double i = 0; i <= w; i += 5) {
        final warp = math.cos((anim.value * math.pi * 2) + (i * 0.05)) * 10;
        path.lineTo(i, j + (isSelectedPoint(i, j) ? warp : 0));
      }
      canvas.drawPath(path, paint..style = PaintingStyle.stroke);
    }
    
    // Central dot
    canvas.drawCircle(Offset(w/2, h/2), 4, Paint()..color = color);
  }

  bool isSelectedPoint(double x, double y) => (x - 80).abs() < 40 && (y - 80).abs() < 40;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _IshiharaPainter extends CustomPainter {
  final Animation<double> anim;
  final Color color;
  _IshiharaPainter({required this.anim, required this.color}) : super(repaint: anim);

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(42);
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 50; i++) {
        final dist = rand.nextDouble() * size.width / 2;
        final angle = rand.nextDouble() * math.pi * 2;
        final pos = center + Offset(math.cos(angle) * dist, math.sin(angle) * dist);
        final dotColor = Color.lerp(color, Colors.red, math.sin(anim.value * math.pi + i) * 0.5 + 0.5)!;
        canvas.drawCircle(pos, rand.nextDouble() * 5 + 2, Paint()..color = dotColor);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SystemTelemetryPainter extends CustomPainter {
  final double animValue;
  final Color color;
  _SystemTelemetryPainter({required this.animValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.1)..strokeWidth = 1;
    
    // Static Grid points
    for (double x = 0; x < size.width; x += 100) {
      for (double y = 0; y < size.height; y += 100) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }

    // Moving scan rays
    final rayX = (animValue * 50) % size.width;
    canvas.drawLine(Offset(rayX, 0), Offset(rayX, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _DiagnosticGridPainter extends CustomPainter {
  final Color color;
  _DiagnosticGridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 20) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
