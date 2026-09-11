import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/user/repositories/products/product_repository_impl.dart';
import '../../../../data_layer/user/user_models/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  ProductLoaded(this.products);

  final List<ProductModel> products;
}

class ProductEmpty extends ProductState {}

class ProductError extends ProductState {
  ProductError(this.message);

  final String message;
}

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(this.repository) : super(ProductInitial());

  final ProductRepositoryImpl repository;

  Future<void> fetchProducts({String? token}) async {
    emit(ProductLoading());

    try {
      final products = await repository.getProducts(token: token);
      if (products.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(products));
      }
    } catch (error) {
      emit(ProductError(error.toString()));
    }
  }
}
