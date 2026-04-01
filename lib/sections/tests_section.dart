import 'dart:ui';
import 'package:flutter/material.dart';
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

class TestsSectionDelegate extends SliverPersistentHeaderDelegate {
  final double screenHeight;
  final double screenWidth;
  TestsSectionDelegate({required this.screenHeight, required this.screenWidth});

  @override
  double get maxExtent => screenHeight * 13;
  @override
  double get minExtent => screenHeight;
  @override
  bool shouldRebuild(covariant TestsSectionDelegate old) =>
      old.screenHeight != screenHeight || old.screenWidth != screenWidth;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    // 12 items -> 11 intervals
    final wheelPos = progress * 11;
    final idx = wheelPos.round().clamp(0, 11);
    
    return Stack(
      children: [
        Positioned(
          top: 0, left: 0, right: 0,
          height: screenHeight,
          child: _TestsContent(currentIndex: idx, wheelPos: wheelPos, screenWidth: screenWidth),
        ),
      ],
    );
  }
}

class _TestsContent extends StatelessWidget {
  final int currentIndex;
  final double wheelPos; // 0.0 to 11.0
  final double screenWidth;
  const _TestsContent({required this.currentIndex, required this.wheelPos, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    final test = _tests[currentIndex];
    final isMob = Responsive.isMobile(context);
    final themeColor = test.tier == TestTier.pro ? const Color(0xFFFFCC00) : AppColors.accent2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: test.tier == TestTier.pro ? const Color(0xFF0A0A0F) : AppColors.background,
      child: Stack(
        children: [
          // 1. Particle Background
          _buildBackground(themeColor),

          // 2. Main Diagnostic Wheel Stage
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMob ? 16 : 60),
              child: isMob 
                  ? _buildMobileLayout(test, themeColor) 
                  : _buildDesktopLayout(test, themeColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(Color themeColor) {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlePainter(
          animValue: wheelPos * 0.05,
          color: themeColor.withValues(alpha: 0.2),
          count: 20,
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(TestData test, Color themeColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // LEFT: The Heading Wheel (The Selector)
        Expanded(
          flex: 4,
          child: _buildHeadingWheel(themeColor),
        ),

        const SizedBox(width: 40),

        // RIGHT: Holographic Phone & Description Card
        Expanded(
          flex: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Phone Mockup (Center-Right)
              Padding(
                padding: const EdgeInsets.only(left: 100),
                child: _buildPhoneHologram(test, themeColor),
              ),

              // Floating Description Card (Glassmorphic)
              Positioned(
                left: 0,
                child: _buildDescriptionPanel(test, themeColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(TestData test, Color themeColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selection wheel at top (compact)
        SizedBox(height: 180, child: _buildHeadingWheel(themeColor, isMob: true)),
        
        const SizedBox(height: 20),

        // Phone in middle
        Expanded(
          child: Center(
            child: _buildPhoneHologram(test, themeColor, isMob: true),
          ),
        ),

        // Description at bottom
        _buildDescriptionPanel(test, themeColor),
      ],
    );
  }

  Widget _buildHeadingWheel(Color themeColor, {bool isMob = false}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Selection Box (Curved Edges) - Wider
        Container(
          width: isMob ? 320 : 500,
          height: isMob ? 50 : 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: themeColor.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: themeColor.withValues(alpha: 0.05),
                blurRadius: 30,
              ),
            ],
          ),
        ),

        // The Wheel Items
        ClipRect(
          child: SizedBox(
            height: isMob ? 250 : 550,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(_tests.length, (i) {
                final dist = (i - wheelPos).abs();
                final isActive = dist < 0.5;
                final opacity = (1.0 - (dist * 0.35)).clamp(0.0, 1.0);
                final scale = (isActive ? 1.0 : 0.8);
                final offset = (i - wheelPos) * (isMob ? 60 : 100);

                return Transform.translate(
                  offset: Offset(0, offset),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 300),
                    child: Opacity(
                      opacity: opacity,
                      child: isActive 
                        ? Text(
                            _tests[i].name.toUpperCase(),
                            style: AppFonts.heading(
                              fontSize: isMob ? 14 : 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColor.withValues(alpha: 0.4),
                              boxShadow: [
                                BoxShadow(
                                  color: themeColor.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
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
      ],
    );
  }

  Widget _buildDescriptionPanel(TestData test, Color themeColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  test.tier.name.toUpperCase(),
                  style: AppFonts.caption.copyWith(
                    color: themeColor, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: 2,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                test.name.toUpperCase(),
                style: AppFonts.heading(fontSize: 18, color: Colors.white, letterSpacing: 1),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneHologram(TestData test, Color themeColor, {bool isMob = false}) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(isMob ? 0 : -0.2)
        ..rotateX(0.1),
      alignment: Alignment.center,
      child: PhoneMockup(
        width: isMob ? 220 : 260,
        height: isMob ? 440 : 540,
        screen: _TestScreenContent(test: test, themeColor: themeColor),
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
      decoration: BoxDecoration(
        color: const Color(0xFF0F1218),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        children: [
          // Grid & Laser
          Positioned.fill(child: Opacity(opacity: 0.1, child: CustomPaint(painter: _DiagnosticGridPainter(color: widget.themeColor)))),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) => Positioned(
              top: _ctrl.value * 500,
              left: 0, right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: widget.themeColor.withValues(alpha: 0.6), blurRadius: 10)],
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
                const SizedBox(height: 24),
                Text('ANALYZING...', style: AppFonts.caption.copyWith(color: widget.themeColor, fontWeight: FontWeight.w900, letterSpacing: 2)),
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
    for (double i = 0; i < size.width; i += 25) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 25) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }
  @override
  bool shouldRepaint(_DiagnosticGridPainter old) => old.color != color;
}
