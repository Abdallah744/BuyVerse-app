import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    final List<Product> dummyProducts = [
      const Product(
        id: '1',
        name: 'Wireless Headphones',
        category: 'Electronics',
        price: '299',
        quantity: '45',
        description:
            'Experience high-quality sound with these wireless headphones. Featuring long battery life and comfortable ear cups for all-day use.',
        image:
            'https://img.freepik.com/free-photo/shiny-black-headphones-reflect-golden-luxury-generated-by-ai_188544-23030.jpg',
      ),
      const Product(
        id: '2',
        name: 'Cotton T-Shirt',
        category: 'Clothing',
        price: '89',
        quantity: '120',
        description: 'Comfortable cotton t-shirt for daily wear.',
        image:
            'https://img.freepik.com/free-photo/simple-white-t-shirt-men-s-apparel_53876-102021.jpg',
      ),
      const Product(
        id: '3',
        name: 'Organic Coffee',
        category: 'Food',
        price: '45',
        quantity: '200',
        description: 'Fresh organic coffee beans.',
        image:
            'https://img.freepik.com/free-photo/coffee-beans-bag_23-2148270542.jpg',
        isVisible: false,
      ),
    ];

    on<GetProducts>((event, emit) {
      emit(ProductLoading());
      emit(ProductLoaded(List.from(dummyProducts)));
    });

    on<AddProduct>((event, emit) {
      if (state is ProductLoaded) {
        final products = List<Product>.from((state as ProductLoaded).products)
          ..add(event.product);
        emit(ProductLoaded(products));
      }
    });

    on<EditProduct>((event, emit) {
      if (state is ProductLoaded) {
        final products = (state as ProductLoaded).products
            .map((p) => p.id == event.product.id ? event.product : p)
            .toList();
        emit(ProductLoaded(products));
      }
    });

    on<DeleteProduct>((event, emit) {
      if (state is ProductLoaded) {
        final products = (state as ProductLoaded).products
            .where((p) => p.id != event.id)
            .toList();
        emit(ProductLoaded(products));
      }
    });
  }
}
