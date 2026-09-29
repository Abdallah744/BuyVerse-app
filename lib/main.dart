import 'package:buy_verse_app/admin_version/core_layer/helpers/app_localization.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/app_theme.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/cache_helper.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/error_boundary.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/notification_helper.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/auth_repository.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/category_repository.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/order_repository.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/product_repository.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/profile_repository.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/auth/auth_usecases.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/category/category_usecases.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/order/order_usecases.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/product/product_usecases.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/profile/profile_usecases.dart';
import 'package:buy_verse_app/firebase_options.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/auth/login/login_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/category/category_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/layout/layout_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/localization/localization_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/notification/notification_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/order/order_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/product/product_bloc.dart';
import 'package:buy_verse_app/admin_version/presentation_layer/state_management/profile/profile_bloc.dart';
import 'package:buy_verse_app/splash_screen.dart';
import 'package:buy_verse_app/user_version/features/auth/data/repo/user_repo_impelement.dart';
import 'package:buy_verse_app/user_version/features/auth/presentation/cubit/auth_cubit.dart' as user_auth_cubit;
import 'package:buy_verse_app/user_version/features/home/categories/data/remote/category_remote_data_source.dart' as user_category_ds;
import 'package:buy_verse_app/user_version/features/home/categories/data/repositories/category_repository_impl.dart' as user_category_repo;
import 'package:buy_verse_app/user_version/features/home/categories/presentation/cubit/category_cubit.dart' as user_category_cubit;
import 'package:buy_verse_app/user_version/features/products/data/remote/product_remote_data_source.dart' as user_product_ds;
import 'package:buy_verse_app/user_version/features/products/data/repositories/product_repository_impl.dart' as user_product_repo;
import 'package:buy_verse_app/user_version/features/products/presentation/cubit/product_cubit.dart' as user_product_cubit;
import 'package:buy_verse_app/user_version/features/products/cart/data/remote/cart_remote_data_source.dart';
import 'package:buy_verse_app/user_version/features/products/cart/data/repositories/cart_repository_impl.dart';
import 'package:buy_verse_app/user_version/features/products/cart/presentation/cubit/cart_cubit.dart';
import 'package:buy_verse_app/user_version/features/payment/checkout/data/remote/checkout_remote_data_source.dart';
import 'package:buy_verse_app/user_version/features/payment/checkout/data/repositories/checkout_repository_impl.dart';
import 'package:buy_verse_app/user_version/features/payment/checkout/presentation/cubit/checkout_cubit.dart';
import 'package:buy_verse_app/user_version/features/payment/data/remote/payment_remote_data_source.dart';
import 'package:buy_verse_app/user_version/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:buy_verse_app/user_version/features/payment/presentation/cubit/payment_cubit.dart';
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
        // Admin:-
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => ProductRepository()),
        RepositoryProvider(create: (context) => CategoryRepository()),
        RepositoryProvider(create: (context) => ProfileRepository()),
        RepositoryProvider(create: (context) => OrderRepository()),
        // User:-
        RepositoryProvider(create: (context) => UserRepoImpelement()),
        RepositoryProvider(
          create: (context) => user_product_repo.ProductRepositoryImpl(
            user_product_ds.ProductRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => user_category_repo.CategoryRepositoryImpl(
            user_category_ds.CategoryRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => CartRepositoryImpl(CartRemoteDataSource()),
        ),
        RepositoryProvider(
          create: (context) =>
              CheckoutRepositoryImpl(CheckoutRemoteDataSource()),
        ),
        RepositoryProvider(
          create: (context) => PaymentRepositoryImpl(PaymentRemoteDataSource()),
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
        // Admin Cubits:-
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
        // User Cubits:-
        BlocProvider(
          create: (context) => user_auth_cubit.AuthCubit(
            repository: context.read<UserRepoImpelement>(),
          ),
        ),
        BlocProvider(
          create: (context) => user_product_cubit.ProductCubit(
            context.read<user_product_repo.ProductRepositoryImpl>(),
          )..fetchProducts(),
        ),
        BlocProvider(
          create: (context) => user_category_cubit.CategoryCubit(
            context.read<user_category_repo.CategoryRepositoryImpl>(),
          )..fetchCategories(),
        ),
        BlocProvider(
          create: (context) => CartCubit(
            context.read<CartRepositoryImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => CheckoutCubit(
            context.read<CheckoutRepositoryImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => PaymentCubit(
            context.read<PaymentRepositoryImpl>(),
          ),
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
