import 'package:flutter/material.dart';

import 'logout_confirm_dialog.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key, this.authToken, this.iconSize = 24});

  final String? authToken;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showLogoutConfirmDialog(context, token: authToken),
      tooltip: 'Logout',
      icon: Icon(
        Icons.logout_rounded,
        color: const Color(0xFF1B2334),
        size: iconSize,
      ),
    );
  }
}
