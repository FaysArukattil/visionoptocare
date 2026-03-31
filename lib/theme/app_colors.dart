import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0F1E);
  static const Color backgroundLight = Color(0xFF111830);
  static const Color backgroundWarm = Color(0xFF1A1425);
  static const Color surface = Color(0xFF141B2E);
  static const Color surfaceLight = Color(0xFF1C2540);

  static const Color accent1 = Color(0xFF4F6AFF);
  static const Color accent2 = Color(0xFF00D4C8);
  static const Color gold = Color(0xFFF5C842);

  static const Color white = Color(0xFFF0F4FF);
  static const Color muted = Color(0xFF7B8AB4);

  static const LinearGradient tealGradient = LinearGradient(
    colors: [Color(0xFF00D4C8), Color(0xFF00A89E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF4F6AFF), Color(0xFF3A52CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF5C842), Color(0xFFE0A800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x400A0F1E),
      Color(0xCC0A0F1E),
      Color(0xFF0A0F1E),
    ],
    stops: [0.0, 0.4, 0.7, 1.0],
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFE8A838), Color(0xFFD4842A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
