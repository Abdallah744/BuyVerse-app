import 'package:bloc_test/bloc_test.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/products/product_repository_impl.dart';
import 'package:buy_verse_app/presentation_layer/user_version/state_management/proudcts/product_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepositoryImpl extends Mock implements ProductRepositoryImpl {}

void main() {
  late MockProductRepositoryImpl mockRepository;

  setUp(() {
    mockRepository = MockProductRepositoryImpl();
  });

  group('ProductCubit', () {
    final testProducts = [
      ProductModel(
        id: 1,
        name: 'Product 1',
        description: 'Description 1',
        image: 'image1.jpg',
        price: 100.0,
        slug: 'product-1',
        categoryId: 1,
      ),
      ProductModel(
        id: 2,
        name: 'Product 2',
        description: 'Description 2',
        image: 'image2.jpg',
        price: 200.0,
        slug: 'product-2',
        categoryId: 2,
      ),
    ];

    test('initial state is ProductInitial', () {
      final cubit = ProductCubit(mockRepository);
      expect(cubit.state, isA<ProductInitial>());
      cubit.close();
    });

    blocTest<ProductCubit, ProductState>(
      'emits [ProductLoading, ProductLoaded] when products are fetched successfully',
      setUp: () {
        when(() => mockRepository.getProducts(token: any(named: 'token')))
            .thenAnswer((_) async => testProducts);
      },
      build: () => ProductCubit(mockRepository),
      act: (cubit) => cubit.fetchProducts(token: 'test_token'),
      expect: () => [isA<ProductLoading>(), isA<ProductLoaded>()],
      verify: (_) {
        verify(() => mockRepository.getProducts(token: 'test_token')).called(1);
      },
    );

    blocTest<ProductCubit, ProductState>(
      'emits [ProductLoading, ProductEmpty] when no products are found',
      setUp: () {
        when(() => mockRepository.getProducts(token: any(named: 'token')))
            .thenAnswer((_) async => <ProductModel>[]);
      },
      build: () => ProductCubit(mockRepository),
      act: (cubit) => cubit.fetchProducts(token: 'test_token'),
      expect: () => [isA<ProductLoading>(), isA<ProductEmpty>()],
    );

    blocTest<ProductCubit, ProductState>(
      'emits [ProductLoading, ProductError] when fetching products fails',
      setUp: () {
        when(() => mockRepository.getProducts(token: any(named: 'token')))
            .thenThrow(Exception('Network error'));
      },
      build: () => ProductCubit(mockRepository),
      act: (cubit) => cubit.fetchProducts(token: 'test_token'),
      expect: () => [isA<ProductLoading>(), isA<ProductError>()],
    );

    blocTest<ProductCubit, ProductState>(
      'emits [ProductLoading, ProductLoaded] when products are fetched without token',
      setUp: () {
        when(() => mockRepository.getProducts(token: any(named: 'token')))
            .thenAnswer((_) async => testProducts);
      },
      build: () => ProductCubit(mockRepository),
      act: (cubit) => cubit.fetchProducts(),
      expect: () => [isA<ProductLoading>(), isA<ProductLoaded>()],
      verify: (_) {
        verify(() => mockRepository.getProducts(token: null)).called(1);
      },
    );
  });
}
