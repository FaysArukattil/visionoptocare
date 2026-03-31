import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/gradient_button.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class B2BSection extends StatelessWidget {
  const B2BSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          image: DecorationImage(
            image: MemoryImage(_gridPattern()),
            repeat: ImageRepeat.repeat,
            opacity: 0.03,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
        child: Padding(
          padding: Responsive.padding(context),
          child: isMob ? _buildMobile() : _buildDesktop(),
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _buildInfo()),
        const SizedBox(width: 60),
        Expanded(flex: 4, child: _buildClinicIllustration()),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        _buildInfo(),
        const SizedBox(height: 40),
        SizedBox(height: 280, child: _buildClinicIllustration()),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Power Your Clinic\nwith Visiaxx Pro', style: AppFonts.h2.copyWith(color: AppColors.white)),
        const SizedBox(height: 32),
        _featurePoint(Icons.devices, '12 clinical-grade tests on any device'),
        const SizedBox(height: 16),
        _featurePoint(Icons.folder_shared, 'Digital patient records and history'),
        const SizedBox(height: 16),
        _featurePoint(Icons.campaign, 'Run mobile eye camps with B2B license'),
        const SizedBox(height: 40),
        GradientButton(text: 'Get Practitioner License', gradient: AppColors.goldGradient, icon: Icons.workspace_premium, onTap: () {}),
      ],
    );
  }

  Widget _featurePoint(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.gold.withOpacity(0.1),
          ),
          child: Icon(icon, color: AppColors.gold, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(text, style: AppFonts.bodyMedium.copyWith(color: AppColors.white))),
      ],
    );
  }

  Widget _buildClinicIllustration() {
    return CustomPaint(
      size: const Size(350, 280),
      painter: _ClinicPainter(),
    );
  }
}

class _ClinicPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Isometric floor
    final floorPaint = Paint()..color = AppColors.surfaceLight.withOpacity(0.5);
    final floorPath = Path()
      ..moveTo(cx, cy + 60)
      ..lineTo(cx + 120, cy + 30)
      ..lineTo(cx, cy)
      ..lineTo(cx - 120, cy + 30)
      ..close();
    canvas.drawPath(floorPath, floorPaint);

    // Desk
    final deskPaint = Paint()..color = AppColors.accent1.withOpacity(0.3);
    final desk = Path()
      ..moveTo(cx - 40, cy - 10)
      ..lineTo(cx + 40, cy - 30)
      ..lineTo(cx + 40, cy - 10)
      ..lineTo(cx - 40, cy + 10)
      ..close();
    canvas.drawPath(desk, deskPaint);

    // Tablet screen
    final tabletRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 50), width: 60, height: 80),
      const Radius.circular(6),
    );
    canvas.drawRRect(tabletRect, Paint()..color = AppColors.backgroundLight);
    canvas.drawRRect(tabletRect, Paint()..color = AppColors.accent2.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Visiaxx eye icon on tablet
    canvas.drawCircle(Offset(cx, cy - 50), 12, Paint()..color = AppColors.accent2.withOpacity(0.3));
    canvas.drawCircle(Offset(cx, cy - 50), 5, Paint()..color = AppColors.accent2);

    // Chart on wall
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx + 60, cy - 90), width: 40, height: 50),
      Paint()..color = AppColors.surfaceLight,
    );
    for (int i = 0; i < 4; i++) {
      canvas.drawLine(
        Offset(cx + 45, cy - 105 + i * 12.0),
        Offset(cx + 75, cy - 105 + i * 12.0),
        Paint()..color = AppColors.muted.withOpacity(0.3)..strokeWidth = 2,
      );
    }

    // Glow effect
    canvas.drawCircle(
      Offset(cx, cy - 50),
      80,
      Paint()..shader = RadialGradient(
        colors: [AppColors.gold.withOpacity(0.1), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy - 50), radius: 80)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper to generate a small grid pattern image
Uint8List _gridPattern() {
  // 8x8 pixel grid pattern as raw RGBA bytes, then encode as BMP
  // Using a simple approach: return a minimal transparent PNG-like pattern
  // For simplicity, return empty bytes and rely on the opacity being very low
  final size = 16;
  final bytes = Uint8List(size * size * 4);
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final idx = (y * size + x) * 4;
      if (x == 0 || y == 0) {
        bytes[idx] = 255;
        bytes[idx + 1] = 255;
        bytes[idx + 2] = 255;
        bytes[idx + 3] = 20;
      }
    }
  }
  return bytes;
}
