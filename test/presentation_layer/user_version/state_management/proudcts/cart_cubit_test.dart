import 'package:bloc_test/bloc_test.dart';
import 'package:buy_verse_app/data_layer/user/user_models/cart_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/products/cart_repository_impl.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/cart_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockCartRepositoryImpl extends Mock implements CartRepositoryImpl {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockCartRepositoryImpl mockRepository;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockRepository = MockCartRepositoryImpl();
    mockSharedPreferences = MockSharedPreferences();
  });

  group('CartCubit', () {
    final testCartItems = [
      CartModel(
        id: 1,
        productId: 1,
        productName: 'Product 1',
        productImage: 'image1.jpg',
        price: 100.0,
        quantity: 2,
      ),
      CartModel(
        id: 2,
        productId: 2,
        productName: 'Product 2',
        productImage: 'image2.jpg',
        price: 200.0,
        quantity: 1,
      ),
    ];

    test('initial state is CartInitial', () {
      final cubit = CartCubit(mockRepository);
      expect(cubit.state, isA<CartInitial>());
      cubit.close();
    });

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartLoaded] when cart is fetched successfully',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.getCart(token: any(named: 'token')))
            .thenAnswer((_) async => testCartItems);
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.fetchCart(),
      expect: () => [isA<CartLoading>(), isA<CartLoaded>()],
      verify: (_) {
        verify(() => mockRepository.getCart(token: 'test_token')).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartEmpty] when cart is empty',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.getCart(token: any(named: 'token')))
            .thenAnswer((_) async => <CartModel>[]);
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.fetchCart(),
      expect: () => [isA<CartLoading>(), isA<CartEmpty>()],
    );

    blocTest<CartCubit, CartState>(
      'emits [CartLoading, CartError] when fetching cart fails',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.getCart(token: any(named: 'token')))
            .thenThrow(Exception('Network error'));
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.fetchCart(),
      expect: () => [isA<CartLoading>(), isA<CartError>()],
    );

    blocTest<CartCubit, CartState>(
      'calls addToCart successfully',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.addToCart(
              productId: any(named: 'productId'),
              quantity: any(named: 'quantity'),
              token: any(named: 'token'),
            )).thenAnswer((_) async => testCartItems[0]);
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.addToCart(productId: 1, quantity: 2),
      verify: (_) {
        verify(() => mockRepository.addToCart(
              productId: 1,
              quantity: 2,
              token: 'test_token',
            )).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'calls removeFromCart successfully',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.removeFromCart(
              productId: any(named: 'productId'),
              token: any(named: 'token'),
            )).thenAnswer((_) async => Future.value());
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.removeFromCart(productId: 1),
      verify: (_) {
        verify(() => mockRepository.removeFromCart(
              productId: 1,
              token: 'test_token',
            )).called(1);
      },
    );

    blocTest<CartCubit, CartState>(
      'calls updateCartItem successfully',
      setUp: () {
        when(() => SharedPreferences.getInstance())
            .thenAnswer((_) async => mockSharedPreferences);
        when(() => mockSharedPreferences.getString('auth_token'))
            .thenReturn('test_token');
        when(() => mockRepository.updateCartItem(
              productId: any(named: 'productId'),
              quantity: any(named: 'quantity'),
              token: any(named: 'token'),
            )).thenAnswer((_) async => testCartItems[0]);
      },
      build: () => CartCubit(mockRepository),
      act: (cubit) => cubit.updateCartItem(productId: 1, quantity: 3),
      verify: (_) {
        verify(() => mockRepository.updateCartItem(
              productId: 1,
              quantity: 3,
              token: 'test_token',
            )).called(1);
      },
    );
  });
}
