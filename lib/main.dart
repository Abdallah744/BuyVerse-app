import 'package:buy_verse_app/presentation_layer/admin_version/pages/admin_HomeScreen.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/auth_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/order/order_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
// import 'package:buy_verse_app/presentation_layer/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutBloc()),
        BlocProvider(create: (context) => CategoryBloc()..add(GetCategories())),
        BlocProvider(create: (context) => ProductBloc()..add(GetProducts())),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => OrderBloc()..add(GetOrders())),
        BlocProvider(create: (context) => ProfileBloc()..add(GetProfile())),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AdminHomeScreen(),
      ),
    );
  }
}
