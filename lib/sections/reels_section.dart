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
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isMob ? 80 : 120),
        decoration: BoxDecoration(
          color: AppColors.background,
        ),
        child: Column(
          children: [
            Padding(
              padding: Responsive.padding(context),
              child: Column(
                children: [
                   Text(
                    'PRACTICE & EDUCATION',
                    style: AppFonts.caption.copyWith(color: AppColors.accent1, letterSpacing: 4, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Learn. Practice.\nSee Better.',
                    style: AppFonts.h2.copyWith(color: AppColors.white, height: 1.1),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            isMob
                ? Column(
                    children: [
                      _reelsGrid(isMob, context),
                      const SizedBox(height: 60),
                      Padding(
                        padding: Responsive.padding(context),
                        child: _articlesList(),
                      ),
                    ],
                  )
                : Padding(
                    padding: Responsive.padding(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _reelsGrid(isMob, context)),
                        const SizedBox(width: 60),
                        Expanded(flex: 2, child: _articlesList()),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _reelsGrid(bool isMob, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isMob ? Responsive.padding(context) : EdgeInsets.zero,
          child: Text('EYE CARE REELS', style: AppFonts.h4.copyWith(color: AppColors.white, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          padding: isMob ? Responsive.padding(context) : EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMob ? 2 : 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.65,
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
        Text('EXPERT ARTICLES', style: AppFonts.h4.copyWith(color: AppColors.white, letterSpacing: 1.2, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        ..._articles.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
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
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translateByDouble(0.0, _hov ? -8.0 : 0.0, 0.0, 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.surface,
          border: Border.all(
            color: _hov ? widget.reel.color.withValues(alpha: 0.5) : AppColors.white.withValues(alpha: 0.05),
            width: _hov ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            if (_hov)
              BoxShadow(
                color: widget.reel.color.withValues(alpha: 0.2),
                blurRadius: 30,
              ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Backdrop pattern
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Icon(widget.reel.icon, size: 200, color: widget.reel.color),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.reel.color.withValues(alpha: 0.1),
                      border: Border.all(color: widget.reel.color.withValues(alpha: 0.2)),
                    ),
                    child: Icon(widget.reel.icon, size: 32, color: widget.reel.color),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.reel.title, 
                      style: AppFonts.bodyMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold), 
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Play overlay bottom
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_circle_fill, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('Watch Now', style: AppFonts.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
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
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: _hov ? AppColors.surfaceLight : AppColors.surface.withValues(alpha: 0.5),
          border: Border.all(
            color: _hov ? AppColors.accent1.withValues(alpha: 0.3) : AppColors.white.withValues(alpha: 0.05),
          ),
          boxShadow: [
             if (_hov)
              BoxShadow(
                color: AppColors.accent1.withValues(alpha: 0.1),
                blurRadius: 40,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.accent2.withValues(alpha: 0.1),
                  ),
                  child: Text(
                    widget.article.category.toUpperCase(), 
                    style: AppFonts.caption.copyWith(color: AppColors.accent2, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  widget.article.readTime, 
                  style: AppFonts.bodySmall.copyWith(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.article.title, 
              style: AppFonts.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold, height: 1.4),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Read Article', 
                  style: AppFonts.bodySmall.copyWith(color: AppColors.accent1, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right_alt, color: AppColors.accent1, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
