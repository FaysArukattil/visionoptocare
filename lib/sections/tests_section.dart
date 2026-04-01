import 'dart:ui';
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
  TestData('06', 'Mobile Refractometry', 'Estimates your eye\'s refractive error. It reveals whether you are nearsighted, farsighted, or have astigmatism.', TestTier.full, Icons.camera_alt),
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
      // Loop or clamp? Let's loop for a wheel feel.
    });
  }

  void _onPanEnd(DragEndDetails d) {
    // Magnetic Snap
    final target = _scrollPos.roundToDouble();
    _scrollCtrl.value = _scrollPos;
    _scrollCtrl.animateTo(target, curve: Curves.easeOutCubic);
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

  @override
  Widget build(BuildContext context) {
    // Map scrollPos to index (with loop support)
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
      child: GestureDetector(
        onVerticalDragUpdate: _onPanUpdate,
        onVerticalDragEnd: _onPanEnd,
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: AppColors.background,
          child: Stack(
            children: [
              // Background Particles
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
        // FIXED CENTER INDICATOR AREA (WHEEL)
        Expanded(
          flex: 4,
          child: _buildCircularWheel(isMob: false),
        ),

        const SizedBox(width: 40),

        // PHONE & DESCRIPTION
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Perspective Phone
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.1)
                  ..rotateX(0.02),
                alignment: Alignment.center,
                child: PhoneMockup(
                  width: 260,
                  height: 560,
                  screen: _TestScreenContent(test: test, themeColor: themeColor),
                ),
              ),

              // floating Description
              Positioned(
                right: 0,
                bottom: 40,
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
        Expanded(flex: 3, child: _buildCircularWheel(isMob: true)),
        const SizedBox(height: 20),
        Expanded(
          flex: 4,
          child: Center(
            child: PhoneMockup(
              width: 200, height: 420,
              screen: _TestScreenContent(test: test, themeColor: themeColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildDetailCard(test, themeColor, isMob: true),
      ],
    );
  }

  Widget _buildCircularWheel({required bool isMob}) {
    return Stack(
      children: [
        // Selection Frame Indicator (The "thingy")
        Center(
          child: Container(
            width: isMob ? 200 : 350,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(color: AppColors.accent2.withValues(alpha: 0.05), blurRadius: 20),
              ],
            ),
          ),
        ),

        // The Curved List
        ClipRect(
          child: Center(
            child: SizedBox(
              height: 500,
              width: isMob ? 300 : 400,
              child: Stack(
                children: List.generate(_tests.length, (i) {
                  // Calculate distance from scrollPos
                  double diff = i - _scrollPos;
                  
                  // Wrap diff for looping feel (assuming 12 items)
                  while (diff > 6) {
                    diff -= 12;
                  }
                  while (diff < -6) {
                    diff += 12;
                  }

                  if (diff.abs() > 3) {
                    return const SizedBox.shrink(); // Hide far items
                  }

                  final absDiff = diff.abs();
                  final opacity = (1.0 - (absDiff / 3.0)).clamp(0.0, 1.0);
                  final scale = (1.0 - (absDiff * 0.1)).clamp(0.5, 1.0);
                  final translateY = diff * 110; // Vertical spacing
                  final translateX = absDiff * 30; // The "Curve" factor
                  
                  final isSelected = absDiff < 0.5;
                  final themeColor = _getTierColor(_tests[i].tier);

                  return Positioned(
                    top: 250 - 40 + translateY, // Center point - half text height + offset
                    left: 20 + translateX,
                    right: 20 + translateX,
                    child: Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Row(
                            mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 44, height: 44,
                                decoration: BoxDecoration(
                                  color: isSelected ? themeColor : Colors.white.withValues(alpha: 0.05),
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected ? [
                                    BoxShadow(color: themeColor.withValues(alpha: 0.4), blurRadius: 15)
                                  ] : null,
                                ),
                                child: Icon(_tests[i].icon, size: 20, color: isSelected ? Colors.black : Colors.white24),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tests[i].name.toUpperCase(),
                                      style: AppFonts.heading(
                                        fontSize: isSelected ? 20 : 16,
                                        color: isSelected ? Colors.white : Colors.white38,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    if (isSelected && !isMob)
                                      Text(
                                        '${_tests[i].tier.name.toUpperCase()} TEST',
                                        style: AppFonts.caption.copyWith(color: themeColor, fontSize: 10, letterSpacing: 2),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
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
          width: isMob ? double.infinity : 340,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Category Badge (Replaced Status)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  '${test.tier.name.toUpperCase()} TEST',
                  style: AppFonts.caption.copyWith(
                    color: themeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                test.name.toUpperCase(),
                style: AppFonts.heading(fontSize: 24, color: Colors.white, height: 1.1),
              ),
              const SizedBox(height: 16),
              Text(
                test.desc,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted, 
                  height: 1.6, 
                  fontSize: 14,
                ),
              ),
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
                Icon(widget.test.icon, size: 70, color: widget.themeColor),
                const SizedBox(height: 24),
                Text('SYSTEM READY', style: AppFonts.caption.copyWith(color: widget.themeColor, fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 10)),
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
