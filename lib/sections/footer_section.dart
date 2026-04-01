import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/eye_logo.dart';
import '../utils/responsive.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050A18),
        border: Border(top: BorderSide(color: AppColors.white.withValues(alpha: 0.05), width: 1)),
      ),
      padding: EdgeInsets.symmetric(vertical: isMob ? 60 : 100),
      child: Padding(
        padding: Responsive.padding(context),
        child: Column(
          children: [
            isMob ? _buildMobile() : _buildDesktop(),
            const SizedBox(height: 80),
            Container(
              height: 1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: isMob ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© 2026 Visiaxx. A Vision Optocare Product.',
                  style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 12),
                ),
                if (!isMob)
                  Row(
                    children: [
                      Text('Privacy Policy', style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 12)),
                      const SizedBox(width: 24),
                      Text('Terms of Service', style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo column
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EyeLogo(size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Visiaxx',
                    style: AppFonts.h4.copyWith(color: AppColors.white, letterSpacing: 1),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 300,
                child: Text(
                  'The world\'s most advanced digital eye care platform. Clinical grade diagnostics in the palm of your hand.',
                  style: AppFonts.bodyMedium.copyWith(color: AppColors.muted, height: 1.6),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _socialIcon(Icons.camera_alt),
                  _socialIcon(Icons.work),
                  _socialIcon(Icons.play_circle),
                  _socialIcon(Icons.close),
                ],
              ),
            ],
          ),
        ),
        // Links
        Expanded(
          flex: 6,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _linkColumn('Platform', ['Tests', 'Therapy', 'Music Library', 'Consultation']),
              _linkColumn('Solutions', ['Practitioners', 'B2B Licenses', 'Eye Camps']),
              _linkColumn('Resources', ['Help Center', 'Blog', 'Contact Us']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        const EyeLogo(size: 40),
        const SizedBox(height: 24),
        Text(
          'Visiaxx',
          style: AppFonts.h4.copyWith(color: AppColors.white, letterSpacing: 1),
        ),
        const SizedBox(height: 16),
        Text(
          'See Better. Live Better.',
          style: AppFonts.bodyMedium.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 48),
        Wrap(
          spacing: 32,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: ['Tests', 'Therapy', 'Consult', 'B2B', 'Contact']
              .map((l) => Text(
                    l,
                    style: AppFonts.bodySmall.copyWith(color: AppColors.white.withValues(alpha: 0.8), fontWeight: FontWeight.bold),
                  ))
              .toList(),
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialIcon(Icons.camera_alt),
            _socialIcon(Icons.work),
            _socialIcon(Icons.play_circle),
            _socialIcon(Icons.close),
          ],
        ),
      ],
    );
  }

  Widget _linkColumn(String title, List<String> links) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 24),
          ...links.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    l,
                    style: AppFonts.bodySmall.copyWith(color: AppColors.muted),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white.withValues(alpha: 0.03),
          border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
        ),
        child: Icon(icon, color: AppColors.white.withValues(alpha: 0.6), size: 18),
      ),
    );
  }
}
