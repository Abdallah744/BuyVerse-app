import '../../../../data_layer/user/user_models/cart_model.dart';
import '../../../../data_layer/user/remote_data/cart_remote_data_source.dart';
import 'cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl(this.remoteDataSource);

  final CartRemoteDataSource remoteDataSource;

  @override
  Future<List<CartModel>> getCart({String? token}) async {
    return remoteDataSource.getCart(token: token);
  }

  @override
  Future<CartModel> addToCart({
    required int productId,
    int quantity = 1,
    String? token,
  }) async {
    return remoteDataSource.addToCart(
      productId: productId,
      quantity: quantity,
      token: token,
    );
  }

  @override
  Future<void> removeFromCart({required int productId, String? token}) async {
    await remoteDataSource.removeFromCart(productId: productId, token: token);
  }

  @override
  Future<CartModel> updateCartItem({
    required int productId,
    required int quantity,
    String? token,
  }) async {
    return remoteDataSource.updateCartItem(
      productId: productId,
      quantity: quantity,
      token: token,
    );
  }
}
