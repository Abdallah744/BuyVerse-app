import 'package:buy_verse_app/data_layer/admin/repositories/auth_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/category_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/order_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/product_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/profile_repository.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/auth/auth_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/category/category_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/order/order_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/product/product_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/profile/profile_usecases.dart';
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
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/theme/theme_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/theme/theme_event.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/theme/theme_state.dart';
import 'package:buy_verse_app/presentation_layer/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core_layer/admin/helpers/app_localization.dart';
import 'core_layer/admin/helpers/app_theme.dart';
import 'core_layer/admin/helpers/cache_helper.dart';
import 'core_layer/admin/helpers/dio_helper.dart';
import 'core_layer/admin/helpers/notification_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await CacheHelper.init();
  await DioHelper.init();

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

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
      ],
      child: MyApp(startWidget: startWidget),
    ),
  );
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
        BlocProvider(create: (context) => ThemeBloc()..add(LoadTheme())),
        BlocProvider(
          create: (context) => CategoryBloc(
            getCategoriesUseCase: GetCategoriesUseCase(
              context.read<CategoryRepository>(),
            ),
            addCategoryUseCase: AddCategoryUseCase(
              context.read<CategoryRepository>(),
            ),
            editCategoryUseCase: EditCategoryUseCase(
              context.read<CategoryRepository>(),
            ),
            deleteCategoryUseCase: DeleteCategoryUseCase(
              context.read<CategoryRepository>(),
            ),
          )..add(GetCategories()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(
            getProductsUseCase: GetProductsUseCase(
              context.read<ProductRepository>(),
            ),
            addProductUseCase: AddProductUseCase(
              context.read<ProductRepository>(),
            ),
            editProductUseCase: EditProductUseCase(
              context.read<ProductRepository>(),
            ),
            deleteProductUseCase: DeleteProductUseCase(
              context.read<ProductRepository>(),
            ),
          )..add(const GetProducts()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: LoginUseCase(context.read<AuthRepository>()),
            registerUseCase: RegisterUseCase(context.read<AuthRepository>()),
            verifyOtpUseCase: VerifyOtpUseCase(context.read<AuthRepository>()),
            logoutUseCase: LogoutUseCase(context.read<AuthRepository>()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              OrderBloc(GetOrdersUseCase(context.read<OrderRepository>()))
                ..add(GetOrders()),
        ),
        BlocProvider(
          create: (context) => NotificationBloc()..add(GetNotifications()),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            getProfileUseCase: GetProfileUseCase(
              context.read<ProfileRepository>(),
            ),
            updateProfileUseCase: UpdateProfileUseCase(
              context.read<ProfileRepository>(),
            ),
          )..add(GetProfile()),
        ),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                home: startWidget,
                locale: localizationState.locale,
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
          );
        },
      ),
    );
  }
}
