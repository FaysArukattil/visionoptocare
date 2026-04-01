// ignore: deprecated_member_use
import 'dart:ui_web' as ui_web;
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EyeScrollSection extends StatefulWidget {
  final double scrollProgress;
  const EyeScrollSection({super.key, required this.scrollProgress});

  @override
  State<EyeScrollSection> createState() => _EyeScrollSectionState();
}

class _EyeScrollSectionState extends State<EyeScrollSection> {
  html.VideoElement? _videoElement;
  final String _viewId = 'eye_scroll_video';

  @override
  void initState() {
    super.initState();
    _registerVideo();
  }

  void _registerVideo() {
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      _videoElement = html.VideoElement()
        ..src = 'assets/videos/clinic.mp4'
        ..autoplay = false
        ..muted = true
        ..loop = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.pointerEvents = 'none';
      return _videoElement!;
    });
  }

  @override
  void didUpdateWidget(EyeScrollSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_videoElement != null && _videoElement!.duration > 0) {
      // Control video playback based on scroll progress
      _videoElement!.currentTime = _videoElement!.duration * widget.scrollProgress.clamp(0.0, 0.99);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tValue = (1.0 - (widget.scrollProgress * 2.5)).clamp(0.0, 1.0);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: HtmlElementView(viewType: _viewId),
          ),
          // Gradient overlays for a premium look
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.background,
                    AppColors.background.withValues(alpha: 0.0),
                    AppColors.background.withValues(alpha: 0.0),
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.25, 0.75, 1.0],
                ),
              ),
            ),
          ),
          // Content Overlay
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: tValue,
                      child: Transform.translate(
                        // ignore: deprecated_member_use
                        offset: Offset(0, 50 * (1.0 - tValue)),
                        child: const SizedBox.shrink(), // Taglines removed as per user request
                    ),
                  ),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
