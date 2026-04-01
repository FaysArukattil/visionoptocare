import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/phone_mockup.dart';
import '../widgets/particle_painter.dart';
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
  const TestsSection({super.key});

  @override
  State<TestsSection> createState() => _TestsSectionState();
}

class _TestsSectionState extends State<TestsSection> with TickerProviderStateMixin {
  late AnimationController _scrollCtrl;
  double _scrollPos = 0.0; // Index-based scroll position
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scrollCtrl = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 300),
      lowerBound: double.negativeInfinity,
      upperBound: double.infinity,
    );
    _scrollCtrl.addListener(() {
      setState(() => _scrollPos = _scrollCtrl.value);
    });
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _scrollPos -= d.delta.dy / 100; // Sensitivity
    });
  }

  void _onPanEnd(DragEndDetails d) {
    _snapToNearest();
  }

  void _snapToNearest() {
    final target = _scrollPos.roundToDouble();
    _scrollCtrl.value = _scrollPos;
    _scrollCtrl.animateTo(target, curve: Curves.easeOutCubic);
  }

  void _onTapItem(int index) {
    // Shortest path logic for infinite loop
    double current = _scrollPos;
    double target = index.toDouble();
    
    double diff = target - (current % _tests.length);
    if (diff > _tests.length / 2) diff -= _tests.length;
    if (diff < -_tests.length / 2) diff += _tests.length;

    _scrollCtrl.value = _scrollPos;
    _scrollCtrl.animateTo(_scrollPos + diff, curve: Curves.easeOutBack, duration: const Duration(milliseconds: 600));
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _scrollCtrl.animateTo((_scrollPos + 1).roundToDouble(), curve: Curves.easeOutBack);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _scrollCtrl.animateTo((_scrollPos - 1).roundToDouble(), curve: Curves.easeOutBack);
      }
    }
  }

  @override
  void dispose() { 
    _scrollCtrl.dispose(); 
    _focusNode.dispose(); 
    super.dispose(); 
  }

  double _getIndicatorHeight(String text, bool isMob, bool isSelected) {
    final textStyle = AppFonts.heading(
      fontSize: isSelected ? 26 : 18, 
      letterSpacing: 2,
    );
    
    final layoutWidth = (isMob ? 180.0 : 260.0);

    final textPainter = TextPainter(
      text: TextSpan(text: text.toUpperCase(), style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 2,
    )..layout(maxWidth: layoutWidth);

    // Tighten padding for non-selected items to prevent overlaps
    final padding = isSelected ? 80.0 : 40.0;
    return (textPainter.height + padding).clamp(isSelected ? 100.0 : 80.0, 180.0);
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = (_scrollPos.round() % _tests.length);
    if (selectedIndex < 0) {
      selectedIndex += _tests.length;
    }

    final test = _tests[selectedIndex];
    final isMob = Responsive.isMobile(context);
    final themeColor = _getTierColor(test.tier);

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.background,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(
                  animValue: _scrollPos * 0.1,
                  color: themeColor.withValues(alpha: 0.1),
                  count: 15,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMob ? 16 : 60, vertical: 40),
                child: isMob 
                    ? _buildMobileLayout(test, themeColor, selectedIndex) 
                    : _buildDesktopLayout(test, themeColor, selectedIndex),
              ),
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

  Widget _buildDesktopLayout(TestData test, Color themeColor, int selectedIndex) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: _buildSemiCircularWheel(isMob: false, selectedIndex: selectedIndex),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.1)
                  ..rotateX(0.02),
                alignment: Alignment.center,
                child: PhoneMockup(
                  width: 250,
                  height: 540,
                  screen: _TestScreenContent(test: test, themeColor: themeColor),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 20,
                child: _buildDetailCard(test, themeColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(TestData test, Color themeColor, int selectedIndex) {
    return Column(
      children: [
        Expanded(flex: 4, child: _buildSemiCircularWheel(isMob: true, selectedIndex: selectedIndex)),
        const SizedBox(height: 10),
        Expanded(
          flex: 4,
          child: Center(
            child: PhoneMockup(
              width: 180, height: 380,
              screen: _TestScreenContent(test: test, themeColor: themeColor),
            ),
          ),
        ),
        _buildDetailCard(test, themeColor, isMob: true),
      ],
    );
  }

  Widget _buildSemiCircularWheel({required bool isMob, required int selectedIndex}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double h = constraints.maxHeight;
        final double w = constraints.maxWidth;
        
        final dynHeight = _getIndicatorHeight(_tests[selectedIndex].name, isMob, true);
        final normPos = ((_scrollPos % _tests.length) + _tests.length) % _tests.length / _tests.length;
        
        // ARC GEOMETRY (Spread out to fit all 12 tests beautifully)
        final radius = isMob ? h * 0.4 : h * 0.55; 
        final centerX = isMob ? w * 0.5 : w * 0.35; 
        final centerY = h * 0.5;
        final angleRange = math.pi * 1.2; // 216 degrees spread for all 12 tests
        return GestureDetector(
          onVerticalDragUpdate: _onPanUpdate,
          onVerticalDragEnd: _onPanEnd,
          behavior: HitTestBehavior.translucent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 1. FIXED SELECTION PILLAR (The Apex of the C)
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: isMob ? 220.0 : 450.0, // Wider 'thingy' for large text
                  height: dynHeight,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    boxShadow: [
                      BoxShadow(color: AppColors.accent2.withValues(alpha: 0.05), blurRadius: 40),
                    ],
                  ),
                  child: _buildScrollIndicator(dynHeight, normPos),
                ),
              ),

              // 2. THE C-SHAPED LIST (Apex at centerX, curving RIGHT)
              Stack(
                children: List.generate(_tests.length, (i) {
                  double diff = i - _scrollPos;
                  while (diff > 6.0) { diff -= 12.0; }
                  while (diff < -6.0) { diff += 12.0; }

                  final absDiff = diff.abs();
                  final angle = diff * (angleRange / 6); 
                  
                  // Trigonometric Positioning (C-shape curving RIGHT)
                  // x is positive here, so items move to the right as they move up/down
                  // Corrected Trigonometric Curve (Apex at index intersection)
                  final double x = radius * (1 - math.cos(angle / 2.5)); 
                  final double y = radius * math.sin(angle / 2.5);
                  
                  final opacity = (1.0 - (absDiff / 6.5)).clamp(0.01, 1.0);
                  final scale = (1.0 - (absDiff * 0.15)).clamp(0.65, 1.0);
                  
                  final isSelected = absDiff < 0.5;
                  final themeColor = _getTierColor(_tests[i].tier);
                  final itemWidth = isMob ? 220.0 : 450.0;
                  final itemHeight = _getIndicatorHeight(_tests[i].name, isMob, isSelected);

                  return Positioned(
                    top: centerY - (itemHeight / 2) + y,
                    left: centerX - (itemWidth / 2) + x,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _onTapItem(i),
                        behavior: HitTestBehavior.opaque,
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child: Container(
                              width: itemWidth,
                              height: itemHeight,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // 1. THE ICON
                                  Container(
                                    width: isMob ? 32 : 44, 
                                    height: isMob ? 32 : 44,
                                    decoration: BoxDecoration(
                                      color: isSelected ? themeColor : Colors.white.withValues(alpha: 0.05),
                                      shape: BoxShape.circle,
                                      boxShadow: isSelected ? [
                                        BoxShadow(color: themeColor.withValues(alpha: 0.3), blurRadius: 15)
                                      ] : null,
                                    ),
                                    child: Icon(_tests[i].icon, size: isMob ? 16 : 22, color: isSelected ? Colors.black : Colors.white24),
                                  ),
                                  const SizedBox(width: 20),
                                  // 2. THE TEXT (Large Font Mode)
                                  Flexible(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tests[i].name.toUpperCase(),
                                          style: AppFonts.heading(
                                            fontSize: isSelected ? (isMob ? 18 : 28) : (isMob ? 14 : 18),
                                            color: isSelected ? Colors.white : Colors.white24,
                                            letterSpacing: 2,
                                          ),
                                          maxLines: 2,
                                        ),
                                        if (isSelected && !isMob)
                                          Text(
                                            '${_tests[i].tier.name.toUpperCase()} TEST',
                                            style: AppFonts.caption.copyWith(
                                              color: themeColor, 
                                              fontSize: 10, 
                                              letterSpacing: 3,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScrollIndicator(double dynHeight, double normPos) {
    const railMargin = 20.0;
    final railHeight = dynHeight - (railMargin * 2);
    const thumbHeight = 16.0;
    final thumbTop = normPos * (railHeight - thumbHeight);

    return Stack(
      children: [
        Positioned(
          right: 8, top: railMargin, bottom: railMargin,
          child: Container(
            width: 1,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
        Positioned(
          right: 7, 
          top: railMargin + thumbTop,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 3, height: thumbHeight,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 4)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(TestData test, Color themeColor, {bool isMob = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: isMob ? double.infinity : 320,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${test.tier.name.toUpperCase()} TEST',
                  style: AppFonts.caption.copyWith(color: themeColor, fontWeight: FontWeight.bold, fontSize: 9, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(test.name.toUpperCase(), style: AppFonts.heading(fontSize: 20, color: Colors.white, height: 1.1)),
              const SizedBox(height: 12),
              Text(test.desc, style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, height: 1.6, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestScreenContent extends StatefulWidget {
  final TestData test;
  final Color themeColor;
  const _TestScreenContent({required this.test, required this.themeColor});

  @override
  State<_TestScreenContent> createState() => _TestScreenContentState();
}

class _TestScreenContentState extends State<_TestScreenContent> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0C0E12),
      child: Stack(
        children: [
          Positioned.fill(child: Opacity(opacity: 0.1, child: CustomPaint(painter: _DiagnosticGridPainter(color: widget.themeColor)))),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) => Positioned(
              top: _ctrl.value * 600,
              left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: widget.themeColor.withValues(alpha: 0.6), blurRadius: 15)],
                  gradient: LinearGradient(colors: [Colors.transparent, widget.themeColor, Colors.transparent]),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.test.icon, size: 60, color: widget.themeColor),
                const SizedBox(height: 20),
                Text('SYSTEM READY', style: AppFonts.caption.copyWith(color: widget.themeColor, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagnosticGridPainter extends CustomPainter {
  final Color color;
  _DiagnosticGridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 30) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(_DiagnosticGridPainter old) => old.color != color;
}
