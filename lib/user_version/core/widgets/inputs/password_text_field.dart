import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import 'app_input_decoration.dart';

/// A labeled password field with a built-in show/hide toggle.
///
/// Generic (lives in `core/widgets`, not a specific feature) since both
/// Create Account and — eventually — Login need identical behavior.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.textInputAction = TextInputAction.next,
  });

  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label, style: AppTextStyles.inputLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            obscureText: _obscure,
            textInputAction: widget.textInputAction,
            style: AppTextStyles.inputText,
            decoration: AppInputDecorations.filled(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: Color(0xFF99A1AF),
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
                tooltip: _obscure ? 'Show password' : 'Hide password',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
