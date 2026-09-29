import '../../domain/repositories/product_details_repository.dart';
import '../../models/product_model.dart';
import '../remote/product_details_remote_data_source.dart';

class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  const ProductDetailsRepositoryImpl(this.remoteDataSource);

  final ProductDetailsRemoteDataSource remoteDataSource;

  @override
  Future<ProductModel> getProductBySlug({
    required String slug,
    String? token,
  }) async {
    return remoteDataSource.getProductBySlug(slug: slug, token: token);
  }
}
