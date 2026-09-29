import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/product_repository.dart';
import '../base_usecase.dart';

class GetProductsUseCase extends UseCase<Response, int> {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);
  @override
  Future<Response> call(int page) async => await repository.getProducts(page: page);
}

class AddProductUseCase extends UseCase<Response, FormData> {
  final ProductRepository repository;
  AddProductUseCase(this.repository);
  @override
  Future<Response> call(FormData params) async => await repository.addProduct(formData: params);
}

class EditProductUseCase extends UseCase<Response, EditProductParams> {
  final ProductRepository repository;
  EditProductUseCase(this.repository);
  @override
  Future<Response> call(EditProductParams params) async => await repository.editProduct(id: params.id, formData: params.formData);
}

class DeleteProductUseCase extends UseCase<Response, String> {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);
  @override
  Future<Response> call(String id) async => await repository.deleteProduct(id: id);
}

class EditProductParams {
  final String id;
  final FormData formData;
  EditProductParams({required this.id, required this.formData});
}
