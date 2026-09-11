import '../../../../data_layer/user/user_models/product_model.dart';

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({String? token});
}
