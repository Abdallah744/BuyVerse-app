import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/state/cart_controller.dart';
import 'core/state/cart_scope.dart';
import 'core/theme/app_theme.dart';

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

  @override
  void dispose() {
    _cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cartController,
      child: MaterialApp(
        //The banner disappears  of the depuging
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        // Show the splash first, then continue to login.
        initialRoute: AppRoutes.splash,
        // from here we will navegete to the other pages we can see it when we click ctrl + click
        routes: AppRoutes.table,
      ),
    );
  }
}
