import 'package:flutter/material.dart';
//hi

class Responsive {
  static const double desktopBreak = 1024;
  static const double tabletBreak = 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > desktopBreak;
  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > tabletBreak && w <= desktopBreak;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= tabletBreak;

  static T value<T>({
    required BuildContext context,
    required T desktop,
    required T tablet,
    required T mobile,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width > desktopBreak) return desktop;
    if (width > tabletBreak) return tablet;
    return mobile;
  }

  static EdgeInsets padding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double horizontal;
    if (width > desktopBreak) {
      horizontal = ((width - 1200) / 2).clamp(40.0, double.infinity);
    } else if (width > tabletBreak) {
      horizontal = width * 0.05;
    } else {
      horizontal = 20;
    }
    return EdgeInsets.symmetric(horizontal: horizontal);
  }
}
