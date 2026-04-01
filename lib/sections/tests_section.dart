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

class _TestsSectionState extends State<TestsSection> {
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowRight) {
        setState(() => _selectedIndex = (_selectedIndex + 1) % _tests.length);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        setState(() => _selectedIndex = (_selectedIndex - 1 + _tests.length) % _tests.length);
      }
    }
  }

  @override
  void dispose() { _focusNode.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final test = _tests[_selectedIndex];
    final isMob = Responsive.isMobile(context);
    final themeColor = test.tier == TestTier.pro ? const Color(0xFFFFCC00) : AppColors.accent2;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: AppColors.background,
        child: Stack(
          children: [
            // Background Particles
            Positioned.fill(
              child: CustomPaint(
                painter: ParticlePainter(
                  animValue: _selectedIndex * 0.1,
                  color: themeColor.withValues(alpha: 0.1),
                  count: 15,
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMob ? 16 : 60, vertical: 40),
                child: isMob 
                    ? _buildMobileLayout(test, themeColor) 
                    : _buildDesktopLayout(test, themeColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(TestData test, Color themeColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT: The Grid Selection
        Expanded(
          flex: 5,
          child: _buildTestsGrid(themeColor),
        ),

        const SizedBox(width: 60),

        // RIGHT: Phone + Details
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.1)
                  ..rotateX(0.05),
                alignment: Alignment.center,
                child: PhoneMockup(
                  width: 250,
                  height: 540,
                  screen: _TestScreenContent(test: test, themeColor: themeColor),
                ),
              ),

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

  Widget _buildMobileLayout(TestData test, Color themeColor) {
    return Column(
      children: [
        Expanded(flex: 3, child: _buildTestsGrid(themeColor, isMob: true)),
        const SizedBox(height: 20),
        Expanded(
          flex: 5,
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

  Widget _buildTestsGrid(Color themeColor, {bool isMob = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DIAGNOSTIC HUB',
          style: AppFonts.heading(fontSize: 14, color: AppColors.accent2, letterSpacing: 4),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMob ? 3 : 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _tests.length,
            itemBuilder: (context, i) => _buildTestGridItem(i, themeColor, isMob: isMob),
          ),
        ),
      ],
    );
  }

  Widget _buildTestGridItem(int idx, Color themeColor, {bool isMob = false}) {
    final isSelected = _selectedIndex == idx;
    final test = _tests[idx];
    final activeColor = test.tier == TestTier.pro ? const Color(0xFFFFCC00) : AppColors.accent2;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected 
                ? [activeColor.withValues(alpha: 0.15), activeColor.withValues(alpha: 0.05)]
                : [Colors.white.withValues(alpha: 0.05), Colors.white.withValues(alpha: 0.02)],
          ),
          border: Border.all(
            color: isSelected ? activeColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: activeColor.withValues(alpha: 0.1), blurRadius: 15, spreadRadius: 2)
          ] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              test.icon, 
              size: isMob ? 24 : 32, 
              color: isSelected ? activeColor : Colors.white38
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                test.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppFonts.heading(
                  fontSize: isMob ? 9 : 11,
                  color: isSelected ? Colors.white : Colors.white24,
                  letterSpacing: 1,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(TestData test, Color themeColor, {bool isMob = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: isMob ? double.infinity : 320,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                test.name.toUpperCase(),
                style: AppFonts.heading(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                test.desc,
                style: AppFonts.bodyLarge.copyWith(
                  color: AppColors.muted, 
                  height: 1.5, 
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              // Replaced stats with a simple Action/Status button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(test.icon, size: 14, color: themeColor),
                    const SizedBox(width: 8),
                    Text(
                      'READY TO SCAN',
                      style: AppFonts.caption.copyWith(
                        color: themeColor, 
                        fontWeight: FontWeight.bold, 
                        letterSpacing: 1,
                        fontSize: 10,
                      ),
                    ),
                  ],
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
      color: const Color(0xFF0F1218),
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
                Text('SYSTEM READY', style: AppFonts.caption.copyWith(color: widget.themeColor, fontWeight: FontWeight.w900, letterSpacing: 3)),
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
