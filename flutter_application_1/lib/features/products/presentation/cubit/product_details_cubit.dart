import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/product_details_repository_impl.dart';
import '../../models/product_model.dart';

abstract class ProductDetailsState {}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  ProductDetailsLoaded(this.product);

  final ProductModel product;
}

class ProductDetailsError extends ProductDetailsState {
  ProductDetailsError(this.message);

  final String message;
}

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this.repository) : super(ProductDetailsInitial());

  final ProductDetailsRepositoryImpl repository;

  Future<void> fetchProductBySlug({
    required String slug,
    String? token,
  }) async {
    emit(ProductDetailsLoading());

    try {
      final product = await repository.getProductBySlug(slug: slug, token: token);
      emit(ProductDetailsLoaded(product));
    } catch (error) {
      emit(ProductDetailsError(error.toString()));
    }
  }
}
