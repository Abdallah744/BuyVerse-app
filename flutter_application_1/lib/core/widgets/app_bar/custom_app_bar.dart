import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// The bordered white AppBar used on every screen in this flow.
///
/// Mirrors the Figma "AppBar" component: white background, a hairline
/// bottom border, and an optional back button on detail screens like
/// Edit Profile.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.trailing,
  });

  final String title;
  final bool showBackButton;
  final List<Widget>? actions;

  /// An optional widget shown after the title, before [actions] — e.g.
  /// the "1 item" count on the Cart page.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.surfaceBorder),
        ),
      ),
      child: AppBar(
        title: trailing == null
            ? Text(title)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(title), trailing!],
              ),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
              )
            : null,
        automaticallyImplyLeading: false,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
