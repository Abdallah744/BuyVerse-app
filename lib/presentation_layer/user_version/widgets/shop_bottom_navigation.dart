import 'package:flutter/material.dart';

import '../../../data_layer/user/services/shared_preferences_service.dart';
import '../pages/cart_page.dart';
import '../pages/favorites_page.dart';
import '../pages/home_page.dart';
import '../pages/orders_page.dart';
import '../pages/profile_page.dart';

class ShopBottomNavigation extends StatelessWidget {
  const ShopBottomNavigation({required this.currentIndex, super.key});

  final int currentIndex;

  void _open(BuildContext context, int index) async {
    if (index == currentIndex) return;
    
    final authToken = await SharedPreferencesService.instance.getAuthToken();
    
    if (!context.mounted) return;
    
    Widget page;
    switch (index) {
      case 0:
        page = HomePage(authToken: authToken);
        break;
      case 1:
        page = FavoritesPage(authToken: authToken);
        break;
      case 2:
        page = CartPage(authToken: authToken);
        break;
      case 3:
        page = OrdersPage(authToken: authToken);
        break;
      case 4:
        page = ProfilePage(authToken: authToken);
        break;
      default:
        return;
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
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
