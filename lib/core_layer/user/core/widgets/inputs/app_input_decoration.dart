import 'package:flutter/material.dart';

/// Builds the rounded, filled [InputDecoration] used by every text field
/// in the app. Centralizing it here means [LabeledTextField] and
/// [PasswordTextField] (and any future field) stay pixel-identical
/// without copy-pasting the border/radius/padding block.
abstract final class AppInputDecorations {
  static InputDecoration filled({
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, size: 18, color: Color(0xFF99A1AF)),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6900), width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFB2C36)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFB2C36), width: 1.4),
      ),
    );
  }
}
