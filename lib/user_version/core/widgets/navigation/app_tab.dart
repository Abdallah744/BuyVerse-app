import 'package:flutter/material.dart';

/// The five destinations in the app's bottom navigation bar.
enum AppTab {
  home(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
  favorites(
    label: 'Faves',
    icon: Icons.favorite_border,
    activeIcon: Icons.favorite,
  ),
  cart(
    label: 'Cart',
    icon: Icons.shopping_cart_outlined,
    activeIcon: Icons.shopping_cart,
  ),
  orders(
    label: 'Orders',
    icon: Icons.inventory_2_outlined,
    activeIcon: Icons.inventory_2,
  ),
  profile(
    label: 'Profile',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
  );

  const AppTab({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
