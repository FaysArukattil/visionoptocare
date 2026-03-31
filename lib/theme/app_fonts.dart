import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  AppFonts._();

  static TextStyle heading({
    double fontSize = 48,
    FontWeight fontWeight = FontWeight.w700,
    Color color = const Color(0xFFF0F4FF),
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.syne(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle body({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = const Color(0xFF7B8AB4),
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.dmSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get h1 =>
      heading(fontSize: 72, fontWeight: FontWeight.w800, height: 1.1);
  static TextStyle get h2 =>
      heading(fontSize: 48, fontWeight: FontWeight.w700, height: 1.2);
  static TextStyle get h3 =>
      heading(fontSize: 36, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get h4 =>
      heading(fontSize: 28, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get h5 =>
      heading(fontSize: 22, fontWeight: FontWeight.w600, height: 1.4);

  static TextStyle get bodyLarge => body(fontSize: 20, height: 1.6);
  static TextStyle get bodyMedium => body(fontSize: 16, height: 1.6);
  static TextStyle get bodySmall => body(fontSize: 14, height: 1.5);

  static TextStyle get caption =>
      body(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 2.0);
  static TextStyle get button => body(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: const Color(0xFFF0F4FF));

  static TextStyle get displayLarge =>
      heading(fontSize: 96, fontWeight: FontWeight.w800, height: 1.0);
  static TextStyle get displayNumber => heading(
      fontSize: 120,
      fontWeight: FontWeight.w800,
      height: 0.9,
      letterSpacing: -2);
}
