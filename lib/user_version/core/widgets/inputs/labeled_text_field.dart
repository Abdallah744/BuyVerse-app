import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import 'app_input_decoration.dart';

/// A bold label above a rounded, filled text field — the "Field" +
/// "Text Input" pairing used throughout Edit Profile.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.inputLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            textInputAction: textInputAction,
            style: AppTextStyles.inputText,
            decoration: AppInputDecorations.filled(prefixIcon: prefixIcon),
          ),
        ],
      ),
    );
  }
}
