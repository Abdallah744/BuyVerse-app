import '../../models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategories({String? token});
}
