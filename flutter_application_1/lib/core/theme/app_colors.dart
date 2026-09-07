import 'package:flutter/material.dart';

/// Centralized color tokens lifted directly from the Figma design file.
///
/// Keeping every hex value in one place means the visual language (and any
/// future rebrand) only has to change here, never inside individual widgets.
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFFFFF9F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceBorder = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFF9FAFB);

  // Text
  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF6A7282);
  static const Color textTertiary = Color(0xFF99A1AF);
  static const Color textMenu = Color(0xFF364153);
  static const Color textInput = Color(0xFF1E2939);
  static const Color textLabel = Color(0xFF364153);

  // Brand / primary
  static const Color primary = Color(0xFFFF6900);
  static const Color primaryDisabled = Color(0x99FF6900); // primary @ 60% opacity
  static const Color primaryGradientStart = Color(0xFFFF8904);
  static const Color primaryGradientEnd = Color(0xFFF54900);

  // Success (e.g. "OTP resent successfully!")
  static const Color success = Color(0xFF00A63E);

  // Destructive / logout
  static const Color dangerBackground = Color(0xFFFEF2F2);
  static const Color dangerBackgroundPressed = Color(0xFFFEE2E2);
  static const Color danger = Color(0xFFFB2C36);
  static const Color dangerStrong = Color(0xFFE02424);

  // Inputs
  static const Color inputBackground = Color(0xFFF9FAFB);
  static const Color inputBorder = Color(0xFFE5E7EB);

  // Info banner (location prompt)
  static const Color bannerBackground = Color(0xFFFFF7ED);
  static const Color bannerBorder = Color(0xFFFFD6A8);
  static const Color bannerText = Color(0xFFCA3500);

  // Order status chips
  static const Color statusPendingBg = Color(0xFFFEF3C6);
  static const Color statusPendingText = Color(0xFFBB4D00);
  static const Color statusProcessingBg = Color(0xFFDBEAFE);
  static const Color statusProcessingText = Color(0xFF1D4ED8);
  static const Color statusShippedBg = Color(0xFFE0E7FF);
  static const Color statusShippedText = Color(0xFF4338CA);
  static const Color statusDeliveredBg = Color(0xFFDCFCE7);
  static const Color statusDeliveredText = Color(0xFF15803D);
  static const Color statusCancelledBg = Color(0xFFFFE2E2);
  static const Color statusCancelledText = Color(0xFFC10007);

  // Favorites thumbnail gradient (default, per-item override supported)
  static const Color favoriteGradientStart = Color(0xFF51A2FF);
  static const Color favoriteGradientEnd = Color(0xFF615FFF);

  static const List<Color> primaryGradient = [
    primaryGradientStart,
    primaryGradientEnd,
  ];

  static const List<Color> favoriteGradient = [
    favoriteGradientStart,
    favoriteGradientEnd,
  ];
}
