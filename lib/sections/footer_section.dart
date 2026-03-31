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
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.accent2, width: 2)),
      ),
      padding: EdgeInsets.symmetric(vertical: isMob ? 40 : 60),
      child: Padding(
        padding: Responsive.padding(context),
        child: Column(
          children: [
            isMob ? _buildMobile() : _buildDesktop(),
            const SizedBox(height: 40),
            Divider(color: AppColors.surfaceLight, height: 1),
            const SizedBox(height: 24),
            Text(
              '© 2025 Visiaxx. A Vision Optocare Product. All rights reserved.',
              style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 12),
              textAlign: TextAlign.center,
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
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const EyeLogo(size: 28),
                  const SizedBox(width: 8),
                  Text('Visiaxx', style: AppFonts.h5.copyWith(color: AppColors.white)),
                ],
              ),
              const SizedBox(height: 12),
              Text('See Better. Live Better.', style: AppFonts.bodyMedium.copyWith(color: AppColors.muted)),
            ],
          ),
        ),
        // Links
        Expanded(
          flex: 4,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _linkColumn('Product', ['Tests', 'Therapy', 'Consult']),
              _linkColumn('Company', ['Languages', 'B2B', 'About']),
              _linkColumn('Legal', ['Privacy Policy', 'Terms']),
            ],
          ),
        ),
        // Social
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Follow Us', style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
      ],
    );
  }

  Widget _buildMobile() {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EyeLogo(size: 28),
            const SizedBox(width: 8),
            Text('Visiaxx', style: AppFonts.h5.copyWith(color: AppColors.white)),
          ],
        ),
        const SizedBox(height: 8),
        Text('See Better. Live Better.', style: AppFonts.bodyMedium.copyWith(color: AppColors.muted)),
        const SizedBox(height: 28),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: ['Tests', 'Therapy', 'Consult', 'Languages', 'B2B', 'Privacy Policy', 'Terms']
              .map((l) => Text(l, style: AppFonts.bodySmall.copyWith(color: AppColors.muted)))
              .toList(),
        ),
        const SizedBox(height: 24),
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
          Text(title, style: AppFonts.bodySmall.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...links.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(l, style: AppFonts.bodySmall.copyWith(color: AppColors.muted)),
              )),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceLight,
        ),
        child: Icon(icon, color: AppColors.muted, size: 16),
      ),
    );
  }
}
