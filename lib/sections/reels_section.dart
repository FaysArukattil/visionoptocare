import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../utils/responsive.dart';
import '../utils/scroll_helpers.dart';

class _ReelData {
  final String title;
  final IconData icon;
  final Color color;
  const _ReelData(this.title, this.icon, this.color);
}

class _ArticleData {
  final String category, title, readTime;
  const _ArticleData(this.category, this.title, this.readTime);
}

const _reels = [
  _ReelData('Eye Exercises', Icons.fitness_center, Color(0xFF4F6AFF)),
  _ReelData('Screen Time Tips', Icons.phone_android, Color(0xFF00D4C8)),
  _ReelData('Night Vision', Icons.nightlight, Color(0xFFF5C842)),
  _ReelData('Dry Eye Relief', Icons.water_drop, Color(0xFF4F6AFF)),
  _ReelData('Kids Eye Care', Icons.child_care, Color(0xFF00D4C8)),
  _ReelData('Nutrition Tips', Icons.restaurant, Color(0xFFF5C842)),
];

const _articles = [
  _ArticleData('Research', 'Understanding Digital Eye Strain in 2025', '5 min'),
  _ArticleData('Tips', '10 Foods That Improve Your Eyesight Naturally', '4 min'),
  _ArticleData('Guide', 'When to See an Ophthalmologist: Warning Signs', '6 min'),
];

class ReelsSection extends StatelessWidget {
  const ReelsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMob = Responsive.isMobile(context);
    return ScrollRevealWidget(
      child: Padding(
        padding: Responsive.padding(context).copyWith(top: isMob ? 60 : 100, bottom: isMob ? 60 : 100),
        child: Column(
          children: [
            Text('Learn. Practice. See Better.', style: AppFonts.h2.copyWith(color: AppColors.white), textAlign: TextAlign.center),
            const SizedBox(height: 60),
            isMob
                ? Column(children: [_reelsGrid(isMob), const SizedBox(height: 40), _articlesList()])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _reelsGrid(isMob)),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _articlesList()),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _reelsGrid(bool isMob) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Eye Care Reels', style: AppFonts.h4.copyWith(color: AppColors.white)),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMob ? 2 : 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7,
          ),
          itemCount: _reels.length,
          itemBuilder: (_, i) => _ReelCard(reel: _reels[i]),
        ),
      ],
    );
  }

  Widget _articlesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Expert Articles', style: AppFonts.h4.copyWith(color: AppColors.white)),
        const SizedBox(height: 20),
        ..._articles.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _ArticleCard(article: a),
            )),
      ],
    );
  }
}

class _ReelCard extends StatefulWidget {
  final _ReelData reel;
  const _ReelCard({required this.reel});
  @override
  State<_ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<_ReelCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform: Matrix4.identity()..scale(_hov ? 1.05 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [widget.reel.color.withOpacity(0.2), AppColors.surface],
          ),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.reel.icon, size: 36, color: widget.reel.color),
                  const SizedBox(height: 12),
                  Text(widget.reel.title, style: AppFonts.bodySmall.copyWith(color: AppColors.white), textAlign: TextAlign.center),
                ],
              ),
            ),
            Positioned(
              top: 8, right: 8,
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  final _ArticleData article;
  const _ArticleCard({required this.article});
  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _hov ? AppColors.surfaceLight : AppColors.surface,
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.accent1.withOpacity(0.15),
              ),
              child: Text(widget.article.category, style: AppFonts.caption.copyWith(color: AppColors.accent1, fontSize: 10)),
            ),
            const SizedBox(height: 12),
            Text(widget.article.title, style: AppFonts.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('${widget.article.readTime} read', style: AppFonts.bodySmall.copyWith(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
