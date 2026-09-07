import '../../models/product_model.dart';

abstract class ProductDetailsRepository {
  Future<ProductModel> getProductBySlug({
    required String slug,
    String? token,
  });
}
