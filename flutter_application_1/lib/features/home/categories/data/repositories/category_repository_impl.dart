import '../../domain/repositories/category_repository.dart';
import '../../models/category_model.dart';
import '../remote/category_remote_data_source.dart';

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
