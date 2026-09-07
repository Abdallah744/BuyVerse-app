import '../../domain/repositories/product_repository.dart';
import '../../models/product_model.dart';
import '../remote/product_remote_data_source.dart';

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
