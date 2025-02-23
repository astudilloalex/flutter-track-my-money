import 'package:flutter/material.dart';

class ResponsiveUtil {
  const ResponsiveUtil._();

  static const double desktopChangePoint = 1200.0;
  static const double tabletChangePoint = 800.0;
  static const double watchChangePoint = 300.0;

  static bool isWatch(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width < watchChangePoint;
  }

  static bool isPhone(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width < tabletChangePoint && width >= watchChangePoint;
  }

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width >= tabletChangePoint && width < desktopChangePoint;
  }

  static bool isDesktop(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return width >= desktopChangePoint;
  }
}
