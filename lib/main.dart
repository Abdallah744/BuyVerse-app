import 'package:buy_verse_app/firebase_options.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/pages/admin_HomeScreen.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/login/login_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/localization/localization_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/notification/notification_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/order/order_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/presentation_layer/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core_layer/admin/helpers/app_localization.dart';
import 'core_layer/admin/helpers/cache_helper.dart';
import 'core_layer/admin/helpers/dio_helper.dart';
import 'core_layer/admin/helpers/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();

  // إبقاء فايربيز فقط لخدمة الإشعارات المنبثقة (FCM)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationHelper.init();
  } catch (e) {
    print('Notification Service bypass: $e');
  }

  String? uId = CacheHelper.getData(key: 'uId');
  Widget startWidget;

  if (uId != null) {
    startWidget = const AdminHomeScreen();
  } else {
    startWidget = SplashScreen();
  }

  runApp(MyApp(startWidget: startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({super.key, required this.startWidget});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LayoutBloc()),
        BlocProvider(
          create: (context) => LocalizationBloc()..add(LoadLanguage()),
        ),
        BlocProvider(create: (context) => CategoryBloc()..add(GetCategories())),
        BlocProvider(create: (context) => ProductBloc()..add(GetProducts())),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => OrderBloc()..add(GetOrders())),
        BlocProvider(
          create: (context) => NotificationBloc()..add(GetNotifications()),
        ),
        BlocProvider(create: (context) => ProfileBloc()..add(GetProfile())),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: startWidget,
            locale: state.locale,
            supportedLocales: const [Locale('en'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}
