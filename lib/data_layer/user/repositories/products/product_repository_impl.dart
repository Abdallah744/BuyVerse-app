import 'package:buy_verse_app/domain_layer/user/repositories/products/product_repository.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_model.dart';
import 'package:buy_verse_app/data_layer/user/user_models/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this.remoteDataSource);

  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<List<ProductModel>> getProducts({String? token, int? categoryId}) async {
    try {
      return await remoteDataSource.getProducts(token: token, categoryId: categoryId);
    } catch (_) {
      return const [];
    }
  }
}
