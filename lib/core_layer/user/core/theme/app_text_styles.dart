import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Text style tokens. The Figma file uses "Nunito" across every weight, so
/// every style below is built from the same [google_fonts] family with just
/// size / weight / color changing per role.
abstract final class AppTextStyles {
  static TextStyle _nunito({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Screen titles in the AppBar, e.g. "Profile", "My Orders".
  static TextStyle get heading2 => _nunito(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF101828),
  );

  /// Name on the profile header card.
  static TextStyle get nameTitle => _nunito(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    color: const Color(0xFF101828),
  );

  static TextStyle get bodyRegular => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF6A7282),
  );

  static TextStyle get bodySemibold => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF364153),
  );

  static TextStyle get bodyBold => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF101828),
  );

  static TextStyle get caption => _nunito(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF99A1AF),
  );

  static TextStyle get captionBold => _nunito(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFFF6900),
  );

  static TextStyle get navLabel => _nunito(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF99A1AF),
  );

  static TextStyle get navLabelActive =>
      navLabel.copyWith(color: const Color(0xFFFF6900));

  static TextStyle get inputText => _nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF1E2939),
  );

  static TextStyle get inputLabel => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF364153),
  );

  static TextStyle get buttonLabel =>
      _nunito(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white);

  static TextStyle get dangerButtonLabel => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFFB2C36),
  );

  static TextStyle get avatarInitials =>
      _nunito(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);

  static TextStyle get statusChip => _nunito(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFBB4D00),
  );

  static TextStyle get orderId => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color(0xFF101828),
    letterSpacing: 0.35,
  );

  static TextStyle get price => _nunito(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFFF6900),
  );
}
