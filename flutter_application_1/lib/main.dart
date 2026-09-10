import 'package:easy_shop_profile/core/models/product.dart';
import 'package:easy_shop_profile/features/auth/pages/login_page.dart';
import 'package:easy_shop_profile/features/auth/pages/otp_verify_page.dart';
import 'package:easy_shop_profile/features/auth/pages/register_page.dart';
import 'package:easy_shop_profile/features/products/cart/pages/cart_page.dart';
import 'package:easy_shop_profile/features/payment/checkout/pages/checkout_page.dart';
import 'package:easy_shop_profile/features/home/pages/home_page.dart';
import 'package:easy_shop_profile/features/home/widgets/shop_bottom_navigation.dart';
import 'package:easy_shop_profile/features/products/pages/product_details_page.dart';
import 'package:easy_shop_profile/features/profile/pages/orders_page.dart';
import 'package:easy_shop_profile/features/profile/pages/profile_page.dart';
import 'package:easy_shop_profile/features/home/pages/favorites_page.dart';
import 'package:easy_shop_profile/features/home/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/state/cart_controller.dart';
import 'core/state/cart_scope.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app theme2.dart';
import 'core/theme/theme_mode_scope.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  runApp(const EasyShopProfileApp());
}

class EasyShopProfileApp extends StatefulWidget {
  const EasyShopProfileApp({super.key});

  @override
  State<EasyShopProfileApp> createState() => _EasyShopProfileAppState();
}

class _EasyShopProfileAppState extends State<EasyShopProfileApp> {
  final CartController _cartController = CartController();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cartController,
      child: BlocProvider(
        create: (_) => AuthCubit(),
        child: ThemeModeScope(
          themeMode: _themeMode,
          onToggle: () => setState(() {
            _themeMode = _themeMode == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light;
          }),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: Apptheme2.dark(),
            themeMode: _themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.table,
          ),
        ),
      ),
    );
  }
}

// routes here
// makes easer to finds all pags in the project
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
        favorites: (_) => const FavoritesPage(),
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
