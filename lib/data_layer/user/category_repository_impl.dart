import '../../domain_layer/user/repositories/category_repository.dart';
import 'remote_data/category_remote_data_source.dart';
import 'user_models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this.remoteDataSource);

  final CategoryRemoteDataSource remoteDataSource;

  @override
  Future<List<CategoryModel>> getCategories({String? token}) async {
    try {
      return await remoteDataSource.getCategories(token: token);
    } catch (_) {
      return const [];
    }
  }
}
