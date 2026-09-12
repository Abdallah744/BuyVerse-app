import 'package:buy_verse_app/core_layer/admin/helpers/app_localization.dart';
import 'package:buy_verse_app/core_layer/admin/helpers/app_theme.dart';
import 'package:buy_verse_app/core_layer/admin/helpers/cache_helper.dart';
import 'package:buy_verse_app/core_layer/admin/helpers/dio_helper.dart';
import 'package:buy_verse_app/core_layer/admin/helpers/notification_helper.dart';
import 'package:buy_verse_app/core_layer/user/core/error_boundary.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/auth_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/category_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/order_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/product_repository.dart';
import 'package:buy_verse_app/data_layer/admin/repositories/profile_repository.dart';
import 'package:buy_verse_app/data_layer/user/category_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/cart_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/category_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/checkout_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/order_details_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/order_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/payment_process_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/payment_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/repositories/auth/auth_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/orders/order_details_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/orders/order_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/payment/checkout_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/payment/payment_process_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/payment/payment_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/products/cart_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/products/product_details_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/products/product_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/repositories/profile_repository_impl.dart';
import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_details_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_remote_data_source.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/auth/auth_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/category/category_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/order/order_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/product/product_usecases.dart';
import 'package:buy_verse_app/domain_layer/admin/usecases/profile/profile_usecases.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/profile_remote_data_source.dart';
import 'package:buy_verse_app/domain_layer/user/repo/auth_repo.dart';
import 'package:buy_verse_app/domain_layer/user/repo/profile_repository.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/profile/profile_cubit.dart';
import 'package:buy_verse_app/firebase_options.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/auth/login/login_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/localization/localization_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/notification/notification_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/order/order_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/presentation_layer/admin_version/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/presentation_layer/splash_screen.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/auth/auth_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/category_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/orders/order_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/orders/order_details_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/payment/checkout_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/payment/payment_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/payment/payment_process_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/cart_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/product_cubit.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/product_details_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();
  await CacheHelper.init();
  await DioHelper.init();
  await SharedPreferencesService.init();

  // إبقاء فايربيز فقط لخدمة الإشعارات المنبثقة (FCM)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await NotificationHelper.init();
  } catch (e) {
    debugPrint('Notification Service bypass: $e');
  }

  runApp(
    MultiRepositoryProvider(
      providers: [
        // Admin Repositories
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
        // User Repositories
        RepositoryProvider<AuthRepo>(create: (context) => AuthRepositoryImpl()),
        RepositoryProvider<UserProfileRepository>(
          create: (context) =>
              UserProfileRepositoryImpl(ProfileRemoteDataSource()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Admin Blocs
        BlocProvider(create: (context) => LayoutBloc()),
        BlocProvider(
          create: (context) => LocalizationBloc()..add(LoadLanguage()),
        ),
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
        // User Cubits
        BlocProvider(
          create: (context) => AuthCubit(repository: context.read<AuthRepo>()),
        ),
        BlocProvider(
          create: (context) =>
              UserProfileCubit(context.read<UserProfileRepository>()),
        ),
        BlocProvider(
          create: (context) =>
              CategoryCubit(CategoryRepositoryImpl(CategoryRemoteDataSource())),
        ),
        BlocProvider(
          create: (context) =>
              ProductCubit(ProductRepositoryImpl(ProductRemoteDataSource())),
        ),
        BlocProvider(
          create: (context) => ProductDetailsCubit(
            ProductDetailsRepositoryImpl(ProductDetailsRemoteDataSource()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CartCubit(CartRepositoryImpl(CartRemoteDataSource())),
        ),
        BlocProvider(
          create: (context) =>
              OrderCubit(OrderRepositoryImpl(OrderRemoteDataSource())),
        ),
        BlocProvider(
          create: (context) => OrderDetailsCubit(
            OrderDetailsRepositoryImpl(OrderDetailsRemoteDataSource()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              PaymentCubit(PaymentRepositoryImpl(PaymentRemoteDataSource())),
        ),
        BlocProvider(
          create: (context) => PaymentProcessCubit(
            PaymentProcessRepositoryImpl(PaymentProcessRemoteDataSource()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              CheckoutCubit(CheckoutRepositoryImpl(CheckoutRemoteDataSource())),
        ),
      ],
      child: BlocBuilder<LocalizationBloc, LocalizationState>(
        builder: (context, localizationState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
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
            builder: (context, child) {
              return ErrorBoundary(child: child!);
            },
          );
        },
      ),
    );
  }
}
