import '../../../../data_layer/user/user_models/cart_model.dart';

abstract class CartRepository {
  Future<List<CartModel>> getCart({String? token});
  Future<CartModel> addToCart({
    required int productId,
    int quantity = 1,
    String? token,
  });
  Future<void> removeFromCart({required int productId, String? token});
  Future<CartModel> updateCartItem({
    required int productId,
    required int quantity,
    String? token,
  });
}
