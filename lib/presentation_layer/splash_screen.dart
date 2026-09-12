import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:buy_verse_app/core_layer/admin/helpers/cache_helper.dart';
import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/admin_HomeScreen.dart';
import 'package:buy_verse_app/presentation_layer/role_acsess.dart';
import 'package:buy_verse_app/presentation_layer/user_version/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

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
    await SharedPreferencesService.init();

    // Check for saved user auth token
    final userToken = await SharedPreferencesService.instance.getAuthToken();
    if (userToken != null && userToken.isNotEmpty) {
      // User is logged in, go to user home page
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomePage(authToken: userToken)),
        );
      }
      return;
    }

    // Check for admin auth
    final adminUid = CacheHelper.getData(key: 'uId');
    if (adminUid != null) {
      // Admin is logged in, go to admin home screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
        );
      }
      return;
    }

    // No auth, go to role selection
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
