import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
          color: AppColors.backgroundWarm.withValues(alpha: 0.1),
        ),
        child: Stack(
          children: [
            // Grid Pattern Background (3D Perspective feel)
            Positioned.fill(
              child: CustomPaint(
                painter: _GridPainter(color: AppColors.gold.withValues(alpha: 0.05 * 0.5)),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 140),
              child: Padding(
                padding: Responsive.padding(context),
                child: isMob ? _buildMobile() : _buildDesktop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 5, child: _buildInfo()),
        const SizedBox(width: 80),
        Expanded(
          flex: 4,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            curve: Curves.easeOutQuart,
            builder: (_, v, child) => Transform.translate(
              offset: Offset(0, 30 * (1 - v)),
              child: _buildClinicIllustration(v),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        _buildInfo(),
        const SizedBox(height: 60),
        SizedBox(height: 300, child: _buildClinicIllustration(1.0)),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          ),
          child: Text(
            'FOR PRACTITIONERS',
            style: AppFonts.caption.copyWith(color: AppColors.gold, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Power Your Clinic\nwith Visiaxx Pro',
          style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.1),
        ),
        const SizedBox(height: 48),
        _featurePoint(Icons.devices, '12 clinical-grade tests on any device'),
        const SizedBox(height: 24),
        _featurePoint(Icons.folder_shared, 'Digital patient records and history'),
        const SizedBox(height: 24),
        _featurePoint(Icons.campaign, 'Run mobile eye camps with B2B license'),
        const SizedBox(height: 56),
        GradientButton(
          text: 'Request Enterprise Access',
          gradient: AppColors.goldGradient,
          icon: Icons.business_center,
          onTap: () => _launchEnterpriseEmail(),
        ),
      ],
    );
  }

  static void _launchEnterpriseEmail() async {
    final subject = Uri.encodeComponent('Business Software License Inquiry — Visiaxx Pro');
    final body = Uri.encodeComponent(
      'Dear Visiaxx Team,\n\n'
      'I am interested in purchasing the Visiaxx Pro business software license.\n\n'
      'Full Name: [Your Full Name]\n'
      'Phone Number: [Your Phone Number]\n'
      'Clinic/Business Address: [Your Complete Address]\n'
      'Qualification/Designation: [e.g., Optometrist, Ophthalmologist, Clinic Owner]\n'
      'Workplace/Clinic Name: [Your Workplace Name]\n\n'
      'Additional Notes:\n'
      '[Any additional information or requirements]\n\n'
      'Looking forward to hearing from you.\n\n'
      'Best regards,\n'
      '[Your Name]',
    );
    final gmailUrl = 'https://mail.google.com/mail/?view=cm&fs=1&to=contact@visionoptocare.co.in&su=$subject&body=$body';
    final uri = Uri.parse(gmailUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _featurePoint(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.gold.withValues(alpha: 0.1),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: AppColors.gold, size: 22),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            text,
            style: AppFonts.bodyLarge.copyWith(color: AppColors.white.withValues(alpha: 0.9), fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicIllustration(double opacity) {
    return Center(
      child: CustomPaint(
        size: const Size(400, 320),
        painter: _ClinicPainter(opacity: opacity),
      ),
    );
  }
}

class _ClinicPainter extends CustomPainter {
  final double opacity;
  _ClinicPainter({this.opacity = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final op = opacity.clamp(0.0, 1.0);
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Isometric floor (Refined)
    final floorPaint = Paint()..color = AppColors.surfaceLight.withValues(alpha: 0.4 * op);
    final floorPath = Path()
      ..moveTo(cx, cy + 80)
      ..lineTo(cx + 160, cy + 40)
      ..lineTo(cx, cy)
      ..lineTo(cx - 160, cy + 40)
      ..close();
    canvas.drawPath(floorPath, floorPaint);

    // Desk (LIT style)
    final deskPaint = Paint()..color = AppColors.accent1.withValues(alpha: 0.25 * op);
    final desk = Path()
      ..moveTo(cx - 50, cy)
      ..lineTo(cx + 50, cy - 25)
      ..lineTo(cx + 50, cy)
      ..lineTo(cx - 50, cy + 25)
      ..close();
    canvas.drawPath(desk, deskPaint);

    // Monitor / Tablet (Floating effect)
    final tabletRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy - 60), width: 70, height: 90),
      const Radius.circular(8),
    );
    // Outer glow
    canvas.drawRRect(
      tabletRect,
      Paint()..color = AppColors.accent2.withValues(alpha: 0.1 * op)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    canvas.drawRRect(tabletRect, Paint()..color = const Color(0xFF000000));
    canvas.drawRRect(tabletRect, Paint()..color = AppColors.accent2.withValues(alpha: 0.5 * op)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Screen Content
    canvas.drawCircle(Offset(cx, cy - 60), 15, Paint()..color = AppColors.accent2.withValues(alpha: 0.2 * op));
    canvas.drawCircle(Offset(cx, cy - 60), 6, Paint()..color = AppColors.accent2);

    // Wall Chart (Glowing)
    final chartRect = Rect.fromCenter(center: Offset(cx + 80, cy - 100), width: 50, height: 60);
    canvas.drawRect(chartRect, Paint()..color = AppColors.surfaceLight.withValues(alpha: 0.8 * op));
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(cx + 65, cy - 118 + i * 10.0),
        Offset(cx + 95, cy - 118 + i * 10.0),
        Paint()..color = AppColors.accent2.withValues(alpha: 0.2 * op)..strokeWidth = 3,
      );
    }

    // Atmospheric Glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.gold.withValues(alpha: 0.15 * op), Colors.transparent],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy - 60), radius: 120));
    canvas.drawCircle(Offset(cx, cy - 60), 120, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
