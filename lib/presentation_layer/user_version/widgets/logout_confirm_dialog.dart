import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data_layer/user/logout_repository_impl.dart';
import '../../../data_layer/user/remote_data/auth/logout_remote_data_source.dart';
import '../../../data_layer/user/services/shared_preferences_service.dart';
import '../../role_acsess.dart';

Future<void> showLogoutConfirmDialog(
  BuildContext context, {
  String? token,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) {
    return;
  }

  final prefs = await SharedPreferences.getInstance();
  final storedToken = token ?? prefs.getString('auth_token') ?? '';

  if (storedToken.isNotEmpty) {
    try {
      final repo = LogoutRepositoryImpl(
        remoteDataSource: LogoutRemoteDataSource(),
      );
      await repo.logout(token: storedToken);
    } catch (_) {
      // Ignore API failure and continue clearing local auth state.
    }
  }

  // Clear all auth data
  await SharedPreferencesService.instance.clearAuthData();

  if (context.mounted) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RoleAccessRestriction()),
      (route) => false,
    );
  }
}
