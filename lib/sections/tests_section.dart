import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
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
  final ValueNotifier<double>? scrollProgress;
  const TestsSection({super.key, required this.isActive, this.scrollProgress});

  @override
  State<TestsSection> createState() => _TestsSectionState();
}

class _TestsSectionState extends State<TestsSection> with TickerProviderStateMixin {
  late AnimationController _scrollCtrl;
  final ValueNotifier<double> _scrollPos = ValueNotifier<double>(0.0);
  final FocusNode _focusNode = FocusNode();
  
  Ticker? _ticker;
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

    // Use a Ticker for buttery smooth per-frame constant motion
    _ticker = createTicker((elapsed) {
      if (!mounted || _userIntervened) {
        _stopAutoCycle();
        return;
      }
      // constant smooth increment (0.6 units per second approx)
      _scrollCtrl.value += 0.008; 
    });
    _ticker!.start();
  }

  void _stopAutoCycle() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
  }

  void _resumeAfterDelay() {
    _userIntervened = false;
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && !_userIntervened) _startAutoCycle();
    });
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

    _scrollCtrl.animateTo(_scrollPos.value + diff, curve: Curves.easeOutBack, duration: const Duration(milliseconds: 600));
    _resumeAfterDelay();
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
      _resumeAfterDelay();
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

    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _userIntervened = true;
          _stopAutoCycle();
          _scrollCtrl.value += event.scrollDelta.dy / 1000.0;
          _resumeAfterDelay();
        }
      },
      child: KeyboardListener(
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

              return isMob 
                  ? _buildMobileLayout(test, themeColor, sIdx, pos) 
                  : _buildDesktopLayout(test, themeColor, sIdx, pos);
            },
          ),
        ],
        ),
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
    Widget phoneObj = _buildFloatingPhone(test, themeColor);
    
    if (widget.scrollProgress != null) {
      phoneObj = ValueListenableBuilder<double>(
        valueListenable: widget.scrollProgress!,
        builder: (context, v, child) {
          final t12 = (v - 1.0).clamp(0.0, 1.0);
          final distanceX = (MediaQuery.of(context).size.width / 2) - 20;
          final translateX = -distanceX * (1.0 - t12);
          final translateY = -(1.0 - t12) * MediaQuery.of(context).size.height;
          return Transform.translate(
            offset: Offset(translateX, translateY),
            child: child,
          );
        },
        child: phoneObj,
      );
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 20), // Essential for scroll track visibility
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            // ── Left: Elevated Data Card & HUD ──
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100), // Clears the navbar completely
                  // Header
                  Text(
                    'VISION TEST SUITE',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.accent2,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '12 Clinical-Grade\nDiagnostics',
                    style: AppFonts.h2.copyWith(
                      color: AppColors.white,
                      fontSize: 38,
                      height: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // HUD Indicator & HUD Stack
                  Expanded(
                    child: Stack(
                      children: [
                        // The Tactical HUD
                        _buildTacticalHUD(false, scrollPos),

                        // Scroll Indicator Track (Fixed Progress Bar)
                        _buildVerticalScrollIndicator(scrollPos, themeColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 80),

            // ── Right: Interactive 3D Phone ──
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  phoneObj, // phoneObj is a RepaintBoundary wrapping PhoneMockup
                ],
              ),
            ),
          ],
        ),
      ),

        // 🟢 Top-Layer Detail Card: Absolute Positioned
        Positioned(
          left: 40, 
          bottom: 40,
          child: _buildDetailCard(test, themeColor, false),
        ),
      ],
    );
  }

  Widget _buildVerticalScrollIndicator(double scrollPos, Color themeColor) {
    return Positioned(
      left: 0, top: 40, bottom: 40,
      width: 4,
      child: Container(
        decoration: BoxDecoration(
          color: themeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final h = constraints.maxHeight;
            // Modulo it for the periodic list logic
            final progress = (scrollPos % _tests.length) / _tests.length;
            return Stack(
              children: [
                Positioned(
                  top: progress * h,
                  left: 0,
                  child: Container(
                    width: 4, height: h / _tests.length,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [BoxShadow(color: themeColor.withValues(alpha: 0.5), blurRadius: 10)],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(TestData test, Color themeColor, int selectedIndex, double scrollPos) {
    Widget phoneObj = _buildFloatingPhone(test, themeColor, isMob: true);

    if (widget.scrollProgress != null) {
      phoneObj = ValueListenableBuilder<double>(
        valueListenable: widget.scrollProgress!,
        builder: (context, v, child) {
          final t12 = (v - 1.0).clamp(0.0, 1.0);
          final translateY = -(1.0 - t12) * MediaQuery.of(context).size.height;
          return Transform.translate(
            offset: Offset(0, translateY),
            child: child,
          );
        },
        child: phoneObj,
      );
    }

    return GestureDetector(
      onHorizontalDragUpdate: (d) {
        _userIntervened = true;
        _stopAutoCycle();
        _scrollCtrl.value -= d.delta.dx / 50;
      },
      onHorizontalDragEnd: (_) => _snapToNearest(),
      child: Column(
        children: [
          const SizedBox(height: 20),
          phoneObj,
          const SizedBox(height: 40),
          // Header
          Text(
            'VISION TEST SUITE',
            style: AppFonts.caption.copyWith(
              color: AppColors.accent2,
              letterSpacing: 3,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '12 Clinical-Grade Diagnostics',
            style: AppFonts.h2.copyWith(
              color: AppColors.white,
              fontSize: 32,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: _buildTacticalHUD(true, scrollPos),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDetailCard(test, themeColor, true),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTacticalHUD(bool isMob, double scrollPos) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          _userIntervened = true;
          _stopAutoCycle();
          _scrollCtrl.value += event.scrollDelta.dy / 1000.0;
          _resumeAfterDelay();
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final centerY = constraints.maxHeight / 2;
          
        return Stack(
          alignment: Alignment.center,
          children: (_tests.asMap().entries.map((entry) {
            final int i = entry.key;
            double diff = i - scrollPos;
            while (diff > 6.0) { diff -= 12.0; }
            while (diff < -6.0) { diff += 12.0; }
  
            final absDiff = diff.abs();
            final isSelected = absDiff < 0.5;
            
            // 3D Perspective Mapping
            final double z = absDiff * 80; // Depth
            final double y = diff * 110; // Vertical spread
            final double scale = (1.0 - (absDiff * 0.15)).clamp(0.5, 1.0);
            final double opacity = (1.0 - (absDiff * 0.25)).clamp(0.0, 1.0);
  
            return MapEntry(
              absDiff,
              Positioned(
                top: centerY + y - 40,
                width: isMob ? 180 : 260,
                child: Opacity(
                  opacity: opacity < 0.1 ? 0.0 : 1.0,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..setTranslationRaw(0.0, 0.0, -z),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.0, 1.0),
                        child: GestureDetector(
                          onTap: () => _onTapItem(i),
                          behavior: HitTestBehavior.opaque,
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
                ),
              ),
            );
          }).toList()
            ..sort((a, b) => b.key.compareTo(a.key)))
            .map((e) => e.value).toList(),
        );
        },
      ),
    );
  }

  Widget _buildFloatingPhone(TestData test, Color themeColor, {bool isMob = false}) {
    // Only animate float when active to save GPU cycles
    return RepaintBoundary(
      child: PhoneMockup(
        width: isMob ? 230 : 260,
        height: isMob ? 450 : 500,
        tiltX: 0.0,
        tiltY: 0.0,
        screen: _TestSimulationEngine(test: test, themeColor: themeColor),
      ),
    );
  }

  Widget _buildDetailCard(TestData test, Color themeColor, bool isMob) {
    return Container(
      width: isMob ? double.infinity : 340,
      padding: EdgeInsets.all(isMob ? 14 : 28),
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
      width: isMob ? 180 : 260,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isSelected ? themeColor.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? themeColor : Colors.white10, width: isSelected ? 2 : 1),
        boxShadow: isSelected ? [BoxShadow(color: themeColor.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2)] : [],
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
  
  // Amsler Grid Mock State
  String _amslerMarkingMode = 'distortion';
  bool? _amslerAllLinesStraight;
  bool? _amslerHasMissingAreas;
  bool? _amslerHasDistortions;

  // Pelli-Robson Mock State
  int _pelliScreenIndex = 0;
  int _pelliTripletIndex = 0;

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

        ],
      ),
    );
  }

  Widget _buildSimulation(String testNum) {
    switch (testNum) {
      case '01': // Visual Acuity
        return _buildVisualAcuityReal();
      case '02': // Reading Test
        return _buildReadingSimulation();
      case '03': // Color Vision
        return _buildColorSimulationReal();
      case '04': // Amsler Grid
        return _buildAmslerSimulationReal();
      case '05': // Pelli-Robson
        return _buildPelliRobsonSimulation();
      case '06': // Refractometry
        return _buildRefractionSimulation();
      case '07': // Eye Hydration
        return _buildHydrationSimulation();
      case '08': // Shadow Test
        return _buildShadowTestSimulation();
      case '09': // Stereopsis
        return _buildStereoSimulation();
      case '10': // Visual Field
        return _buildVisualFieldSimulation();
      case '11': // Cover Test
        return _buildCoverTestSimulation();
      case '12': // Torchlight Exam
        return _buildTorchSimulation();
      default:
        // Generic telemetry fallback
        return AnimatedBuilder(
          animation: _anim,
          builder: (context, _) => CustomPaint(
            painter: _SystemTelemetryPainter(animValue: _anim.value, color: widget.themeColor),
            size: const Size(double.infinity, double.infinity),
          ),
        );
    }
  }

  Widget _buildVisualAcuityReal() {
    return Container(
      color: AppColors.background.withValues(alpha: 0.9),
      child: Column(
        children: [
          // Simulated App Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.surface,
            child: Row(
              children: [
                Icon(Icons.close, color: widget.themeColor, size: 20),
                const SizedBox(width: 16),
                Text(
                  'VISUAL ACUITY - RIGHT',
                  style: AppFonts.bodyLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: widget.themeColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Header Data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: widget.themeColor.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('6/6', style: TextStyle(fontWeight: FontWeight.w900, color: widget.themeColor, fontSize: 11)),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.themeColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('LEVEL 7/7', style: TextStyle(color: widget.themeColor, fontWeight: FontWeight.w900, fontSize: 8)),
                      const SizedBox(width: 8),
                      Container(width: 1, height: 10, color: widget.themeColor.withValues(alpha: 0.2)),
                      const SizedBox(width: 8),
                      const Icon(Icons.check_circle_outline, size: 10, color: Colors.greenAccent),
                      const SizedBox(width: 4),
                      const Text('5/5', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.w900, fontSize: 8)),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(Icons.timer_outlined, size: 12, color: widget.themeColor),
                const SizedBox(width: 4),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) {
                    int seconds = 7 - ((_anim.value * 14).floor() % 7);
                    return Text('${seconds}s', style: TextStyle(fontWeight: FontWeight.w900, color: widget.themeColor, fontSize: 12));
                  }
                ),
              ],
            ),
          ),

          // Central E Display
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _anim,
                          builder: (context, _) {
                            int phase = (_anim.value * 8).floor();
                            double angle = phase * math.pi / 2;
                            return Transform.rotate(
                              angle: angle,
                              child: const Text('E', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black, height: 1.0)),
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Which way is the E facing?', style: TextStyle(color: AppColors.muted, fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Use buttons to indicate direction', style: TextStyle(color: AppColors.white.withValues(alpha: 0.5), fontSize: 9)),
                ],
              ),
            ),
          ),

          // Control Pad
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildVaBtn(Icons.arrow_upward),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildVaBtn(Icons.arrow_back),
                    const SizedBox(width: 40),
                    _buildVaBtn(Icons.arrow_forward),
                  ],
                ),
                const SizedBox(height: 8),
                _buildVaBtn(Icons.arrow_downward),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: widget.themeColor.withValues(alpha: 0.5), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: widget.themeColor.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_off_rounded, size: 14, color: widget.themeColor),
                        const SizedBox(width: 6),
                        Text("Blurry / Can't see clearly", style: TextStyle(color: widget.themeColor, fontWeight: FontWeight.w700, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _buildVaBtn(IconData icon) {
    return Container(
      width: 45, height: 45,
      decoration: BoxDecoration(
        color: widget.themeColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: widget.themeColor.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  // End legacy Contrast simulation
  
  Widget _buildReadingSimulation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('READING TEST', 'Near Vision Clarity'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: const Text(
                      'The quick brown fox jumps over the lazy dog. This sentence contains every letter of the English alphabet exactly once. Clinical reading tests often use specialized paragraphs to assess near vision acuity at standard reading distances (40cm).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'serif',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'READ THE SENTENCE ALOUD',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Buttons (MATCHING CLINICAL SCREEN)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSimulationSolidActionButton(
                    label: 'CAN READ',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSimulationSolidActionButton(
                    label: 'CANNOT READ',
                    icon: Icons.highlight_off_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildSimulationActionButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimulationSolidActionButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPelliRobsonSimulation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('CONTRAST SENSITIVITY', 'Pelli-Robson Triplet'),
          
          // Info Indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.03),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                _buildSimulationIndicator('SCREEN ${_pelliScreenIndex + 1}/8', Icons.grid_view_rounded, Colors.blue),
                const SizedBox(width: 8),
                _buildSimulationIndicator('RIGHT EYE', Icons.remove_red_eye_rounded, Colors.indigo),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSloanTriplet('V R S', 1.0, isCurrent: _pelliTripletIndex == 0),
                  const SizedBox(height: 10),
                  _buildSloanTriplet('K H Z', 0.45, isCurrent: _pelliTripletIndex == 1),
                  const SizedBox(height: 10),
                  _buildSloanTriplet('N O C', 0.15, isCurrent: _pelliTripletIndex == 2),
                  const SizedBox(height: 12),
                  const Text('READ THE LETTERS ALOUD', style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          
          // Large Clinical Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSimulationSolidActionButton(
                    label: 'VISIBLE',
                    icon: Icons.visibility_rounded,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSimulationSolidActionButton(
                    label: 'NOT VISIBLE',
                    icon: Icons.visibility_off_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildSimulationIndicator(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildRefractionSimulation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('MOBILE REFRACTOMETRY', 'Adjusting Focus'),
          
          // Info Indicators
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                _buildSimulationIndicator('LEVEL 4/12', Icons.layers_rounded, Colors.blue),
                const SizedBox(width: 8),
                _buildSimulationIndicator('RELIABILITY: 94%', Icons.verified_user_rounded, Colors.green),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 160, // Significantly reduced height to ensure button visibility
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                          animation: _anim,
                          builder: (context, _) {
                            // Reduced blur max sigma for better visibility
                            final blur = (math.sin(_anim.value * math.pi * 2) * 2.2).abs() + 0.3;
                            final rotation = (_anim.value * 4).floor() * (math.pi / 2); 
                            return ImageFiltered(
                              imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                              child: Transform.rotate(
                                angle: rotation,
                                child: const Text(
                                  'E', 
                                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.black, height: 1.0)
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                      
                      // Detailed Analysis Card (Bottom Left)
                      Positioned(
                        left: 12,
                        bottom: 6,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _RefractionMetric('SPH', '-1.25', Colors.blue),
                              SizedBox(height: 2),
                              _RefractionMetric('CYL', '-0.50', Colors.cyan),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Clinical D-Pad
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildRefractionDpadBtn(Icons.keyboard_arrow_up),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildRefractionDpadBtn(Icons.keyboard_arrow_left),
                            const SizedBox(width: 30),
                            _buildRefractionDpadBtn(Icons.keyboard_arrow_right),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildRefractionDpadBtn(Icons.keyboard_arrow_down),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 56, // Enforced height for visibility
                          child: _buildSimulationSolidActionButton(
                            label: "BLURRY / CAN'T SEE",
                            icon: Icons.visibility_off_rounded,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildRefractionDpadBtn(IconData icon) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }

  Widget _buildShadowTestSimulation() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Camera feed placeholder (Dark Eye)
          Center(
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.grey[900]!, Colors.black],
                ),
                border: Border.all(color: Colors.white10, width: 2),
              ),
              child: Center(
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
          // Flashlight beam animation
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              final x = math.cos(_anim.value * math.pi * 2) * 40;
              final y = math.sin(_anim.value * math.pi * 2) * 40;
              return Center(
                child: Transform.translate(
                  offset: Offset(x, y),
                  child: Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.yellow.withValues(alpha: 0.3 + (math.sin(_anim.value * 10) * 0.1)), blurRadius: 20, spreadRadius: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Column(
            children: [
              _buildSimulationAppBar('SHADOW TEST', 'Cataract Screening'),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.yellow.withValues(alpha: 0.1),
                child: const Text('ANALYZING SHADOW PATTERN...', textAlign: TextAlign.center, style: TextStyle(color: Colors.yellow, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ),
              _buildSimulationFooter(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSloanTriplet(String letters, double opacity, {bool isCurrent = false}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.blue.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1.5) : null,
      ),
      child: Opacity(
        opacity: opacity,
        child: Text(
          letters, 
          style: const TextStyle(
            fontSize: 40, 
            fontWeight: FontWeight.w900, 
            color: Colors.black, 
            letterSpacing: 10, 
            fontFamily: 'serif'
          )
        ),
      ),
    );
  }

  Widget _buildHydrationSimulation() {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          _buildSimulationAppBar('EYE HYDRATION', 'Blink Rate Monitoring'),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Animation Header (EyeLoader Integration)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 2),
                      boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.1), blurRadius: 10)],
                    ),
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _anim,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _PremiumEyePainter(
                              progress: _anim.value,
                              color: Colors.blue,
                              scleraColor: Colors.white,
                              pupilColor: const Color(0xFF000510),
                            ),
                            size: const Size(60, 60),
                          );
                        }
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  // Blink Counter
                  _buildHydrationCounter('BLINKS DETECTED', '7', Colors.blue),
                  
                  // Detection Warning
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedBuilder(
                      animation: _anim,
                      builder: (context, child) {
                        return Opacity(
                          opacity: (math.sin(_anim.value * 10) + 1) / 2,
                          child: const Text(
                            'MONITORING BLINKS...',
                            style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1),
                          ),
                        );
                      },
                    ),
                  ),

                  // Reading Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Digital Eye Strain Assessment',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Reading from digital screens significantly reduces our natural blink rate, often by over 60%. This leads to increased tear evaporation and ocular surface dryness. Clinical monitoring helps assess individual susceptibility to digital eye strain.',
                          style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.6, fontFamily: 'serif'),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'The Blink Rate test monitors your ocular surface hydration during focused reading. This non-invasive assessment tracks your natural blink pattern to provide specialized wellness recommendations.',
                          style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.6, fontFamily: 'serif'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Action Button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: _buildSimulationSolidActionButton(
                label: 'FINISH READING',
                icon: Icons.check_circle_rounded,
                color: Colors.blue,
              ),
            ),
          ),
          
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildHydrationCounter(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: color, height: 1.1)),
        Text(label, style: TextStyle(fontSize: 8, letterSpacing: 1.2, fontWeight: FontWeight.w800, color: Colors.grey.withValues(alpha: 0.7))),
      ],
    );
  }

  Widget _buildStereoSimulation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('STEREOPSIS', 'Depth Perception'),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildStereoShape(const Offset(-20, -20), Colors.red.withValues(alpha: 0.5)),
                  _buildStereoShape(const Offset(20, 20), Colors.blue.withValues(alpha: 0.5)),
                  const Text('Identify the floating shape', style: TextStyle(fontSize: 8, color: Colors.grey)),
                ],
              ),
            ),
          ),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildStereoShape(Offset offset, Color color) {
    return Transform.translate(
      offset: offset,
      child: Container(width: 60, height: 60, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }

  Widget _buildVisualFieldSimulation() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          _buildSimulationAppBar('VISUAL FIELD', 'Perimetry Grid'),
          Expanded(
            child: Center(
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(border: Border.all(color: Colors.white10)),
                child: Stack(
                  children: [
                    const Center(child: Icon(Icons.add, color: Colors.white24, size: 20)),
                    Positioned(
                      left: 40, top: 100,
                      child: AnimatedBuilder(
                        animation: _anim,
                        builder: (context, _) {
                          final show = (_anim.value * 10).floor() % 3 == 0;
                          return Opacity(
                            opacity: show ? 1.0 : 0.0,
                            child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text('TAP WHEN YOU SEE A DOT', style: TextStyle(fontSize: 8, color: Colors.white54, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildCoverTestSimulation() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('COVER TEST', 'Muscle Alignment'),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEyeMockup(true),
              const SizedBox(width: 40),
              _buildEyeMockup(false),
            ],
          ),
          const Spacer(),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildEyeMockup(bool isCovered) {
    return Container(
      width: 60, height: 40,
      decoration: BoxDecoration(
        color: isCovered ? Colors.black87 : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: isCovered ? null : Center(child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle))),
    );
  }

  Widget _buildTorchSimulation() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          _buildSimulationAppBar('TORCHLIGHT EXAM', 'Pupillary Reflex'),
          const Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(width: 80, height: 80, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle)),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) {
                    final size = 40.0 - (math.sin(_anim.value * math.pi * 2).abs() * 20);
                    return Container(width: size, height: size, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle));
                  }
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildColorSimulationReal() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('COLOR VISION', 'Plate 08/14'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ishihara Plate Mockup
                  Container(
                    width: 140, height: 140,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/e/e0/Ishihara_9.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Premium Buttons Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.2,
                      physics: const NeverScrollableScrollPhysics(),
                      children: ['12', '74', '06', 'Nothing'].map((opt) => _buildPremiumButton(opt, opt == '74')).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildAmslerSimulationReal() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildSimulationAppBar('AMSLER GRID', 'Mark Grid Area'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                children: [
                  // Instruction
                  const Text(
                    'MARK THE DISTORTED AREAS',
                    style: TextStyle(fontSize: 8, color: Colors.blue, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 8),

                  // The Grid mockup
                  Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                    ),
                    child: CustomPaint(
                      painter: _AmslerDistortionPainter(color: Colors.black.withValues(alpha: 0.15)),
                      child: Stack(
                        children: [
                          Center(child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle))),
                          // Sample marks based on current mode
                          if (_amslerMarkingMode == 'distortion')
                            Positioned(
                              left: 30, top: 40,
                              child: Container(
                                width: 30, height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.red, width: 2),
                                  color: Colors.red.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Mode Chips
                  Row(
                    children: [
                      Expanded(child: _buildAmslerModeChip('distortion', 'WAVY', Icons.waves, Colors.red)),
                      const SizedBox(width: 4),
                      Expanded(child: _buildAmslerModeChip('missing', 'MISSING', Icons.visibility_off, Colors.orange)),
                      const SizedBox(width: 4),
                      Expanded(child: _buildAmslerModeChip('blurry', 'BLURRY', Icons.blur_on, Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Questions
                  _buildAmslerQuestionBlock(
                    'Are all lines straight?',
                    _amslerAllLinesStraight,
                    (val) => setState(() => _amslerAllLinesStraight = val),
                  ),
                  const SizedBox(height: 8),
                  _buildAmslerQuestionBlock(
                    'Any missing areas?',
                    _amslerHasMissingAreas,
                    (val) => setState(() => _amslerHasMissingAreas = val),
                  ),
                  const SizedBox(height: 8),
                  _buildAmslerQuestionBlock(
                    'Any wavy lines?',
                    _amslerHasDistortions,
                    (val) => setState(() => _amslerHasDistortions = val),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Controls
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                _buildAmslerIconBtn(Icons.undo_rounded, Colors.blue),
                const SizedBox(width: 8),
                _buildAmslerIconBtn(Icons.delete_outline_rounded, Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSimulationActionButton(
                    label: 'CONTINUE',
                    icon: Icons.arrow_forward_rounded,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          _buildSimulationFooter(),
        ],
      ),
    );
  }

  Widget _buildAmslerModeChip(String mode, String label, IconData icon, Color color) {
    final bool isSelected = _amslerMarkingMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _amslerMarkingMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? color : color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 10, color: isSelected ? Colors.white : color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : color)),
          ],
        ),
      ),
    );
  }

  Widget _buildAmslerQuestionBlock(String question, bool? value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(question, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87))),
          Row(
            children: [
              _buildSmallYesNo('NO', value == false, () => onChanged(false), Colors.red),
              const SizedBox(width: 6),
              _buildSmallYesNo('YES', value == true, () => onChanged(true), Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallYesNo(String label, bool isSelected, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? color : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : color)),
      ),
    );
  }

  Widget _buildAmslerIconBtn(IconData icon, Color color) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildSimulationAppBar(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text(subtitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, size: 10, color: Colors.red),
                const SizedBox(width: 2),
                AnimatedBuilder(
                  animation: _anim,
                  builder: (context, _) {
                    int seconds = 9 - ((_anim.value * 18).floor() % 9);
                    return Text('${seconds}s', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red));
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFooterIcon(Icons.mic, 'Speak'),
          _buildFooterIcon(Icons.help_outline, 'Help'),
          _buildFooterIcon(Icons.exit_to_app, 'Exit'),
        ],
      ),
    );
  }

  Widget _buildFooterIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        Text(label, style: const TextStyle(fontSize: 6, color: Colors.grey)),
      ],
    );
  }

  Widget _buildPremiumButton(String label, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey.withValues(alpha: 0.3), width: 1.5),
        boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withValues(alpha: 0.2), blurRadius: 4)] : [],
      ),
      child: Center(
        child: Text(label, style: TextStyle(
          fontSize: 14, 
          fontWeight: FontWeight.w900, 
          color: isSelected ? Colors.blue : Colors.black87,
        )),
      ),
    );
  }

} // End of _TestSimulationEngineState



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
    // Moving scan ray removed!
  }

  @override
  bool shouldRepaint(covariant _SystemTelemetryPainter oldDelegate) =>
      (oldDelegate.animValue - animValue).abs() > 0.5 || oldDelegate.color != color;
}

class _AmslerDistortionPainter extends CustomPainter {
  final Color color;
  _AmslerDistortionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    // Draw vertical lines with slight "warp" center-left
    for (double x = 0; x <= size.width; x += 16) {
      final path = Path();
      path.moveTo(x, 0);
      for (double y = 0; y <= size.height; y += 2) {
        final dist = math.sqrt(math.pow(x - 50, 2) + math.pow(y - 70, 2));
        final warp = math.exp(-dist / 30) * 10; 
        path.lineTo(x + warp * math.sin(y / 10), y);
      }
      canvas.drawPath(path, paint);
    }

    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += 16) {
      final path = Path();
      path.moveTo(0, y);
      for (double x = 0; x <= size.width; x += 2) {
        final dist = math.sqrt(math.pow(x - 50, 2) + math.pow(y - 70, 2));
        final warp = math.exp(-dist / 30) * 10;
        path.lineTo(x, y + warp * math.cos(x / 10));
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AmslerDistortionPainter oldDelegate) => false;
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
  bool shouldRepaint(covariant _DiagnosticGridPainter oldDelegate) => false;
}

class _RefractionMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _RefractionMetric(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 8, fontWeight: FontWeight.w900)),
        const SizedBox(width: 8),
        Text(value, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _PremiumEyePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color scleraColor;
  final Color pupilColor;

  _PremiumEyePainter({
    required this.progress,
    required this.color,
    required this.scleraColor,
    required this.pupilColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eyeWidth = size.width * 0.95;
    final baseEyeHeight = size.height * 0.52;

    // ── 1. ANIMATION PHASES ──
    // a) Iris movement (look-around)
    double irisXOffset = 0;
    const lookCurve = Curves.easeInOutCubic;
    if (progress < 0.15) {
      irisXOffset = 0;
    } else if (progress < 0.35) {
      double t = lookCurve.transform((progress - 0.15) / 0.2);
      irisXOffset = -t * (eyeWidth * 0.28);
    } else if (progress < 0.65) {
      double t = lookCurve.transform((progress - 0.35) / 0.3);
      irisXOffset = -(eyeWidth * 0.28) + (t * eyeWidth * 0.56);
    } else if (progress < 0.85) {
      double t = lookCurve.transform((progress - 0.65) / 0.2);
      irisXOffset = (eyeWidth * 0.28) - (t * eyeWidth * 0.28);
    }

    // b) Pupil pulse (breathing)
    double pulseScale = 1.0;
    if (progress < 0.15) {
      final t = progress / 0.15;
      pulseScale = 1.8 - (Curves.easeOutExpo.transform(t) * 0.8);
    } else {
      pulseScale = 1.0 + 0.1 * math.sin(progress * 2 * math.pi);
    }

    // c) Periodic blinks
    double blinkFactor = 1.0;
    final blinkMarkers = [0.2, 0.5, 0.8];
    const blinkWindow = 0.07;
    for (final marker in blinkMarkers) {
      if (progress > marker - blinkWindow && progress < marker + blinkWindow) {
        final t = (progress - (marker - blinkWindow)) / (blinkWindow * 2);
        blinkFactor = 1.0 - math.sin(t * math.pi);
        break;
      }
    }

    // ── 2. PAINTING ──
    final currentHeight = baseEyeHeight * blinkFactor;
    final scleraCenter = center + Offset(irisXOffset * 0.15, 0);

    // Eye shape path
    final eyePath = Path();
    eyePath.moveTo(scleraCenter.dx - eyeWidth / 2, scleraCenter.dy);
    eyePath.quadraticBezierTo(
        scleraCenter.dx, scleraCenter.dy - currentHeight,
        scleraCenter.dx + eyeWidth / 2, scleraCenter.dy);
    eyePath.quadraticBezierTo(
        scleraCenter.dx, scleraCenter.dy + currentHeight,
        scleraCenter.dx - eyeWidth / 2, scleraCenter.dy);
    eyePath.close();

    // 2.1 Draw Sclera
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = scleraColor
        ..style = PaintingStyle.fill,
    );

    // 2.2 Draw Subtle Glow/Shadow Stroke
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = color.withValues(alpha: 0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 2.3 Draw Internal Content (Iris & Pupil)
    if (blinkFactor > 0.05) {
      canvas.save();
      canvas.clipPath(eyePath);

      final irisCenter = center + Offset(irisXOffset, 0);
      final irisRadius = (size.width / 2) * 0.52;

      // Iris with Radial Gradient (for depth)
      final irisPaint = Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: 1.0), color.withValues(alpha: 0.7)],
        ).createShader(Rect.fromCircle(center: irisCenter, radius: irisRadius));
      canvas.drawCircle(irisCenter, irisRadius, irisPaint);

      // Pupil with responsive dilation
      canvas.drawCircle(
        irisCenter,
        irisRadius * 0.42 * pulseScale,
        Paint()..color = pupilColor,
      );

      // High-quality reflections
      final reflectPaint = Paint()..color = Colors.white.withValues(alpha: 0.45);
      canvas.drawCircle(
        irisCenter + Offset(irisRadius * 0.3, -irisRadius * 0.3),
        irisRadius * 0.16,
        reflectPaint,
      );
      canvas.drawCircle(
        irisCenter + Offset(-irisRadius * 0.2, irisRadius * 0.2),
        irisRadius * 0.08,
        Paint()..color = Colors.white.withValues(alpha: 0.2),
      );

      canvas.restore();
    }

    // 2.4 Eyelashes (detailed when closing)
    if (blinkFactor < 0.4) {
      final lashPaint = Paint()
        ..color = color.withValues(alpha: 0.8 * (1.0 - blinkFactor))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      final lashRect = Rect.fromCenter(
        center: center,
        width: eyeWidth * 0.8,
        height: size.height * 0.08,
      );
      canvas.drawArc(lashRect, 0.1, math.pi - 0.2, false, lashPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PremiumEyePainter old) =>
      old.progress != progress || old.color != color;
}
