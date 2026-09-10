import 'package:flutter/material.dart';

import 'app_text_styles.dart';

/// Builds the single [ThemeData] used across the app.
abstract final class Apptheme2 {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      fontFamily: AppTextStyles.bodyRegular.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFFF6900),
        primary: const Color(0xFFFF6900),
        brightness: Brightness.dark,
        surface: const Color(0xFF1E1E1E),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        surfaceTintColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black,
        thickness: 1,
        space: 1,
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
