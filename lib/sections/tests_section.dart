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
  TestData('01', 'Visual Acuity', 'Measures how clearly you can see at a distance. It reveals the sharpness of your far vision for each eye individually, rated on a standard scale (like 6/6 being perfect sight).', TestTier.quick, Icons.visibility),
  TestData('02', 'Reading Test', 'Assesses how well you can read and see up close. It reveals your near vision clarity, reading accuracy, and whether you struggle with text at arm\'s length.', TestTier.quick, Icons.menu_book),
  TestData('03', 'Color Vision', 'Checks whether you can correctly distinguish colors. It reveals if you have any color deficiency (such as red-green issues) in each eye, and how severe it is.', TestTier.quick, Icons.palette),
  TestData('04', 'Amsler Grid', 'Tests the central portion of your vision. It reveals whether you perceive any distortions, missing spots, or blurry patches in your central visual field.', TestTier.quick, Icons.grid_on),
  TestData('05', 'Contrast Sensitivity', 'Evaluates how well you can distinguish objects from their background. It reveals whether your vision degrades in low-contrast or foggy conditions.', TestTier.full, Icons.contrast),
  TestData('06', 'Mobile Refractometry', 'Estimates your eye\'s refractive error. It reveals whether you are nearsighted, farsighted, or have astigmatism, providing estimated lens prescription values.', TestTier.full, Icons.camera_alt),
  TestData('07', 'Eye Hydration', 'Monitors your blink rate over a timed period. It reveals whether your eyes show signs of dryness or insufficient lubrication based on natural blink frequency.', TestTier.personal, Icons.water_drop),
  TestData('08', 'Shadow Test', 'Examines internal structures using light reflection. It reveals the health of eye structures and assesses indicators like glaucoma-related changes.', TestTier.pro, Icons.dark_mode),
  TestData('09', 'Stereopsis', 'Tests depth perception and 3D vision. It reveals how well both eyes work together to merge images into a single 3D view.', TestTier.pro, Icons.view_in_ar),
  TestData('10', 'Visual Field', 'Maps what you can see without moving your eyes. It reveals blind spots or peripheral vision loss, broken down by quadrant.', TestTier.pro, Icons.radar),
  TestData('11', 'Cover Test', 'Checks for eye alignment and muscle balance. It reveals whether eyes deviate inward, outward, up, or down, indicating muscle imbalance.', TestTier.pro, Icons.flip),
  TestData('12', 'Torchlight Exam', 'A clinical examination using a light source. It reveals pupil reflexes and muscle movement, helping detect nerve or muscle abnormalities.', TestTier.pro, Icons.flashlight_on),
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
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % _tests.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + _tests.length) % _tests.length;
        });
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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

            // Dashboard Content
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
        // SIDEBAR: Categorized List
        Expanded(
          flex: 4,
          child: _buildSidebar(themeColor),
        ),

        const SizedBox(width: 80),

        // CENTER/RIGHT: The Phone Hero
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Perspective Phone
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-0.15)
                  ..rotateX(0.05),
                alignment: Alignment.center,
                child: PhoneMockup(
                  width: 280, // Better aspect ratio
                  height: 580,
                  screen: _TestScreenContent(test: test, themeColor: themeColor),
                ),
              ),

              // Floating Detailed Card
              Positioned(
                right: 0,
                bottom: 60,
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
        // Compact List Header
        SizedBox(
          height: 120,
          child: _buildSidebar(themeColor, isMob: true),
        ),
        const SizedBox(height: 20),
        // Phone
        Expanded(
          child: Center(
            child: PhoneMockup(
              width: 220,
              height: 480,
              screen: _TestScreenContent(test: test, themeColor: themeColor),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Detail
        _buildDetailCard(test, themeColor, isMob: true),
      ],
    );
  }

  Widget _buildSidebar(Color themeColor, {bool isMob = false}) {
    // Grouping by Tier
    final Map<TestTier, List<int>> groups = {};
    for (int i = 0; i < _tests.length; i++) {
      groups.putIfAbsent(_tests[i].tier, () => []).add(i);
    }

    if (isMob) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tests.length,
        itemBuilder: (context, i) => _buildSidebarItem(i, themeColor, isMob: true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DIAGNOSTIC HUB',
          style: AppFonts.heading(fontSize: 14, color: AppColors.accent2, letterSpacing: 4),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: groups.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      entry.key.name.toUpperCase() + ' TESTS',
                      style: AppFonts.caption.copyWith(color: Colors.white24, fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                  ),
                  ...entry.value.map((idx) => _buildSidebarItem(idx, themeColor)),
                  const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(int idx, Color themeColor, {bool isMob = false}) {
    final isSelected = _selectedIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: isMob ? 0 : 12, right: isMob ? 16 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? themeColor.withValues(alpha: 0.3) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: isMob ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (!isMob) ...[
              Text(
                _tests[idx].number,
                style: AppFonts.caption.copyWith(
                  color: isSelected ? themeColor : Colors.white24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
            ],
            Text(
              _tests[idx].name.toUpperCase(),
              style: AppFonts.heading(
                fontSize: isMob ? 14 : 18,
                color: isSelected ? Colors.white : Colors.white38,
                letterSpacing: 2,
              ),
            ),
            if (isSelected && !isMob) ...[
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 12, color: themeColor),
            ],
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
          width: isMob ? double.infinity : 350,
          padding: const EdgeInsets.all(32),
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
                style: AppFonts.heading(fontSize: 22, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                test.desc,
                style: AppFonts.bodyLarge.copyWith(color: AppColors.muted, height: 1.6, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStatBadge('ACCURACY', '99.8%', themeColor),
                  const SizedBox(width: 20),
                  _buildStatBadge('DURATION', '2m', themeColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.caption.copyWith(color: Colors.white38, fontSize: 10, letterSpacing: 1)),
        Text(value, style: AppFonts.heading(fontSize: 16, color: themeColor)),
      ],
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
      decoration: const BoxDecoration(
        color: Color(0xFF0F1218),
      ),
      child: Stack(
        children: [
          // Grid & Laser
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
                Icon(widget.test.icon, size: 80, color: widget.themeColor),
                const SizedBox(height: 32),
                Text('SYSTEM READY', style: AppFonts.caption.copyWith(color: widget.themeColor, fontWeight: FontWeight.w900, letterSpacing: 3)),
                const SizedBox(height: 8),
                Text('TAP TO START SCAN', style: AppFonts.caption.copyWith(color: Colors.white24, fontSize: 10)),
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
