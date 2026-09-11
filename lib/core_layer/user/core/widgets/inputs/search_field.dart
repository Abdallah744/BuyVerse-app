import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import 'app_input_decoration.dart';

/// A rounded search field with a leading search icon. Generic (lives in
/// `core/widgets`) since any future search screen can reuse it.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodySemibold.copyWith(fontWeight: FontWeight.w400),
      decoration: AppInputDecorations.filled(prefixIcon: Icons.search).copyWith(
        hintText: hintText,
        hintStyle: AppTextStyles.bodyRegular,
        isDense: true,
      ),
    );
  }
}
