import 'dart:ui_web' as ui_web;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'home_page.dart';

void main() {
  // Registering video elements for Hero Section
  _registerHeroVideo('clinic_video', 'assets/videos/clinic.mp4');
  _registerHeroVideo('couch_video', 'assets/videos/couch.mp4');
  
  runApp(const VisiaxxApp());
}

void _registerHeroVideo(String viewId, String videoSrc) {
  // ignore: undefined_prefixed_name
  ui_web.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
    return html.VideoElement()
      ..src = videoSrc
      ..autoplay = true
      ..muted = true
      ..loop = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover';
  });
}

class VisiaxxApp extends StatelessWidget {
  const VisiaxxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visiaxx — Vision Care, Reimagined',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
