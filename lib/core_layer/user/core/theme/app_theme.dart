import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// Builds the single [ThemeData] used across the app.
abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFFF9F5),
      fontFamily: AppTextStyles.bodyRegular.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6900),
        primary: const Color(0xFFFF6900),
        surface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2,
        iconTheme: const IconThemeData(color: Color(0xFF101828)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF9FAFB),
        thickness: 1,
        space: 1,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
