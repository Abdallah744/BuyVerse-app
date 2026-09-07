import 'package:flutter/material.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/otp_verify_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/cart/pages/cart_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/home/widgets/shop_bottom_navigation.dart';
import '../../features/products/pages/product_details_page.dart';
import '../../features/profile/pages/orders_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/splash/pages/splash_page.dart';
import '../models/product.dart';

abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String otpVerify = '/auth/otp-verify';
  static const String welcome = '/auth/welcome';
  static const String home = '/shop/home';
  static const String home2 = '/shop/home-2';
  static const String productDetail = '/shop/product';
  static const String cart = '/shop/cart';
  static const String checkout = '/shop/checkout';
  static const String orderSuccess = '/shop/order-success';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String orders = '/profile/orders';
  static const String favorites = '/profile/favorites';

  static Map<String, WidgetBuilder> get table => {
        splash: (_) => const SplashPage(),
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
        otpVerify: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return OtpVerifyPage(email: args is String ? args : null);
        },
        welcome: (_) => const _RoutePage(title: 'Welcome'),
        home: (_) => const HomePage(),
        home2: (_) => const Home2Page(),
        productDetail: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is! Product) {
            throw ArgumentError(
              'AppRoutes.productDetail requires a Product passed as arguments.',
            );
          }
          return ProductDetailsPage(slug: args.id);
        },
        cart: (_) => const CartPage(),
        checkout: (_) => const CheckoutPage(),
        orderSuccess: (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          return _RoutePage(title: 'Order ${args is String ? args : '#ORDER'}');
        },
        profile: (_) => const ProfilePage(),
        editProfile: (_) => const _RoutePage(title: 'Edit profile'),
        orders: (_) => const OrdersPage(),
        favorites: (_) => const _RoutePage(
              title: 'Favorites',
              currentIndex: 1,
            ),
      };
}

class _RoutePage extends StatelessWidget {
  const _RoutePage({required this.title, this.currentIndex});

  final String title;
  final int? currentIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
      bottomNavigationBar: currentIndex == null
          ? null
          : ShopBottomNavigation(currentIndex: currentIndex!),
    );
  }
}
