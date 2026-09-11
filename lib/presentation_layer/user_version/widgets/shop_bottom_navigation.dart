import 'package:flutter/material.dart';

class ShopBottomNavigation extends StatelessWidget {
  const ShopBottomNavigation({required this.currentIndex, super.key});

  final int currentIndex;

  void _open(BuildContext context, int index) {
    if (index == currentIndex) return;
    final routes = [
      AppRoutes.home,
      AppRoutes.favorites,
      AppRoutes.cart,
      AppRoutes.orders,
      AppRoutes.profile,
    ];
    Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _open(context, index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFFF6900),
      unselectedItemColor: const Color(0xFF98A2B3),
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 10,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Faves',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
