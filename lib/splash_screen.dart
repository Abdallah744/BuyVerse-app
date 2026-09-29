import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'admin_version/core_layer/helpers/cache_helper.dart';
import 'admin_version/presentation_layer/pages/admin_HomeScreen.dart';
import 'admin_version/presentation_layer/pages/login&register/login_screen.dart';
import 'role_acsess.dart';
import 'user_version/features/auth/pages/login_page.dart';
import 'user_version/features/home/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: LottieBuilder.asset(
        'assets/animations/Splash_Screen_Shopping App.json',
      ),
      splashTransition: SplashTransition.fadeTransition,
      duration: 4000,
      nextScreen: const _NextScreenWrapper(),
      backgroundColor: HexColor('F5821F'),
      splashIconSize: 800,
    );
  }
}

class _NextScreenWrapper extends StatefulWidget {
  const _NextScreenWrapper();

  @override
  State<_NextScreenWrapper> createState() => _NextScreenWrapperState();
}

class _NextScreenWrapperState extends State<_NextScreenWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final role = CacheHelper.getData(key: 'role');

    if (role == 'admin') {
      final adminUid = CacheHelper.getData(key: 'uId');
      if (adminUid != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
          );
        }
        return;
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
        return;
      }
    } else if (role == 'user') {
      final prefs = await SharedPreferences.getInstance();
      final userToken =
          prefs.getString('auth_token') ?? CacheHelper.getData(key: 'auth_token');
      if (userToken != null && userToken.toString().trim().isNotEmpty) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomePage(authToken: userToken.toString()),
            ),
          );
        }
        return;
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
        return;
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RoleAccessRestriction()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
