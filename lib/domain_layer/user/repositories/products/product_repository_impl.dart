import 'product_repository.dart';
import '../../../../data_layer/user/user_models/product_model.dart';
import '../../../../data_layer/user/user_models/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this.remoteDataSource);

  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<List<ProductModel>> getProducts({String? token}) async {
    try {
      return await remoteDataSource.getProducts(token: token);
    } catch (_) {
      return const [];
    }
  }
}
