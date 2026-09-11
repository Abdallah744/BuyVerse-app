import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:buy_verse_app/presentation_layer/role_acsess.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: LottieBuilder.asset(
        'assets/animations/Splash_Screen_Shopping App.json',
      ),
      splashTransition: SplashTransition.fadeTransition,
      duration: 4000,
      nextScreen: RoleAccessRestriction(),
      backgroundColor: HexColor('F5821F'),
      splashIconSize: 800,
    );
  }
}
