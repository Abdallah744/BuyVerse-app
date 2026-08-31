import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Standard design dimensions (e.g., iPhone 11/13)
  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  double setWidth(double width) => (width / _designWidth) * screenWidth;

  double setHeight(double height) => (height / _designHeight) * screenHeight;

  double setSp(double fontSize) => (fontSize / _designWidth) * screenWidth;

  double get bottomPadding => MediaQuery.paddingOf(this).bottom;
  double get topPadding => MediaQuery.paddingOf(this).top;
}
