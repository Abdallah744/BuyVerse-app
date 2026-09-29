import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/data_layer/repositories/category_repository.dart';
import '../base_usecase.dart';

class GetCategoriesUseCase extends UseCase<Response, NoParams> {
  final CategoryRepository repository;
  GetCategoriesUseCase(this.repository);
  @override
  Future<Response> call(NoParams params) async => await repository.getCategories();
}

class AddCategoryUseCase extends UseCase<Response, CategoryParams> {
  final CategoryRepository repository;
  AddCategoryUseCase(this.repository);
  @override
  Future<Response> call(CategoryParams params) async => await repository.addCategory(name: params.name, description: params.description);
}

class EditCategoryUseCase extends UseCase<Response, EditCategoryParams> {
  final CategoryRepository repository;
  EditCategoryUseCase(this.repository);
  @override
  Future<Response> call(EditCategoryParams params) async => await repository.editCategory(id: params.id, name: params.name, description: params.description);
}

class DeleteCategoryUseCase extends UseCase<Response, String> {
  final CategoryRepository repository;
  DeleteCategoryUseCase(this.repository);
  @override
  Future<Response> call(String slug) async => await repository.deleteCategory(slug: slug);
}

class CategoryParams {
  final String name;
  final String description;
  CategoryParams({required this.name, required this.description});
}

class EditCategoryParams {
  final String id;
  final String name;
  final String description;
  EditCategoryParams({required this.id, required this.name, required this.description});
}
