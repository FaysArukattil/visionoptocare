import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/gradient_button.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class ConsultSection extends StatelessWidget {
  const ConsultSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Padding(
        padding: Responsive.padding(context).copyWith(top: isMob ? 60 : 100, bottom: isMob ? 60 : 100),
        child: Column(
          children: [
            Text('Expert Care, Your Way', style: AppFonts.h2.copyWith(color: AppColors.white), textAlign: TextAlign.center),
            const SizedBox(height: 60),
            isMob
                ? Column(children: [_onlineCard(), const SizedBox(height: 24), _homeCard()])
                : Row(children: [Expanded(child: _onlineCard()), const SizedBox(width: 24), Expanded(child: _homeCard())]),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: AppColors.muted, size: 18),
                const SizedBox(width: 8),
                Text('Secure patient records. Your full history in one place.', style: AppFonts.bodySmall.copyWith(color: AppColors.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _onlineCard() {
    return _ConsultCard(
      gradient: const LinearGradient(colors: [Color(0xFF1A2555), Color(0xFF0F1A40)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      icon: Icons.videocam,
      title: 'Consult an Ophthalmologist',
      subtitle: 'HD video. Instant prescription.\nFrom anywhere.',
      cta: 'Book Now',
      ctaGradient: AppColors.blueGradient,
    );
  }

  Widget _homeCard() {
    return _ConsultCard(
      gradient: const LinearGradient(colors: [Color(0xFF2A1F10), Color(0xFF1A1408)], begin: Alignment.topLeft, end: Alignment.bottomRight),
      icon: Icons.home,
      title: 'Optometrist at Your Door',
      subtitle: 'Uber-model home visits.\nOn-site refractometry.',
      cta: 'Request Visit',
      ctaGradient: AppColors.amberGradient,
    );
  }
}

class _ConsultCard extends StatefulWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String title, subtitle, cta;
  final LinearGradient ctaGradient;
  const _ConsultCard({required this.gradient, required this.icon, required this.title, required this.subtitle, required this.cta, required this.ctaGradient});

  @override
  State<_ConsultCard> createState() => _ConsultCardState();
}

class _ConsultCardState extends State<_ConsultCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.identity()..scale(_hov ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.surfaceLight),
          boxShadow: _hov
              ? [BoxShadow(color: widget.ctaGradient.colors.first.withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 10))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: widget.ctaGradient),
              child: Icon(widget.icon, color: AppColors.background, size: 28),
            ),
            const SizedBox(height: 24),
            Text(widget.title, style: AppFonts.h4.copyWith(color: AppColors.white)),
            const SizedBox(height: 12),
            Text(widget.subtitle, style: AppFonts.bodyMedium.copyWith(color: AppColors.muted, height: 1.6)),
            const SizedBox(height: 28),
            GradientButton(text: widget.cta, gradient: widget.ctaGradient, height: 46, onTap: () {}),
          ],
        ),
      ),
    );
  }
}
