import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
      fillColor: AppColors.inputBackground,
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, size: 18, color: AppColors.textTertiary),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.4),
      ),
    );
  }
}
