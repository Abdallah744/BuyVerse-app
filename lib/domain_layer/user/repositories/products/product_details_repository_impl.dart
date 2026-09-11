import 'product_details_repository.dart';
import '../../../../data_layer/user/user_models/product_model.dart';
import '../../../../data_layer/user/user_models/product_details_remote_data_source.dart';

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
