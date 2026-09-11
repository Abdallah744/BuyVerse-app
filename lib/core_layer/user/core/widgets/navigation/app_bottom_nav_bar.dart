import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import 'app_tab.dart';

/// The bordered bottom nav shared across Home, Favorites, Cart, Orders and
/// Profile. Only [currentTab] is visually locked in as active; tapping any
/// other tab calls [onTabSelected] and lets the caller decide what to do
/// (navigate, or show a "coming soon" message for tabs not yet built).
///
/// Pass [badgeCounts] to show a small red count badge on a tab (e.g. the
/// number of items in the cart). Omit a tab from the map, or pass 0, for
/// no badge — this keeps every existing call site working unchanged.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    this.badgeCounts = const {},
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;
  final Map<AppTab, int> badgeCounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (final tab in AppTab.values)
              Expanded(
                child: _NavItem(
                  tab: tab,
                  isActive: tab == currentTab,
                  onTap: () => onTabSelected(tab),
                  badgeCount: badgeCounts[tab] ?? 0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  final AppTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color color =
        isActive ? const Color(0xFFFF6900) : const Color(0xFF99A1AF);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                if (isActive)
                  Positioned(
                    top: -8,
                    child: Container(
                      width: 32,
                      height: 2,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6900),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(999),
                        ),
                      ),
                    ),
                  ),
                Icon(isActive ? tab.activeIcon : tab.icon,
                    size: 21, color: color),
                if (badgeCount > 0)
                  Positioned(
                    top: -8,
                    right: -10,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 16),
                      height: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFB2C36),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount > 99 ? '99+' : '$badgeCount',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              tab.label,
              style: isActive
                  ? AppTextStyles.navLabelActive
                  : AppTextStyles.navLabel,
            ),
          ],
        ),
      ),
    );
  }
}
