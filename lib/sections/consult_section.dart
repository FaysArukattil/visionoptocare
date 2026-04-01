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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _hov ? -10.0 : 0.0, 0.0, 1.0)
          ..scaleByDouble(_hov ? 1.02 : 1.0, _hov ? 1.02 : 1.0, 1.0, 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: _hov ? widget.ctaGradient.colors.first : AppColors.white.withValues(alpha: 0.1),
            width: _hov ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
            if (_hov)
              BoxShadow(
                color: widget.ctaGradient.colors.first.withValues(alpha: 0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: widget.ctaGradient,
                boxShadow: [
                  BoxShadow(
                    color: widget.ctaGradient.colors.first.withValues(alpha: 0.3),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Icon(widget.icon, color: AppColors.background, size: 32),
            ),
            const SizedBox(height: 32),
            Text(widget.title, style: AppFonts.h3.copyWith(color: AppColors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.subtitle, style: AppFonts.bodyMedium.copyWith(color: AppColors.muted, height: 1.8)),
            const SizedBox(height: 48),
            GradientButton(
              text: widget.cta,
              gradient: widget.ctaGradient,
              height: 52,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
