import 'package:dio/dio.dart';

import '../../../../../core/network/api_config.dart';
import '../../models/cart_model.dart';

class CartRemoteDataSource {
  CartRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Options _options(String? token) => Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
        },
      );

  Future<List<CartModel>> getCart({String? token}) async {
    final response = await dioClient.get(
      '$baseUrl/client/carts',
      options: _options(token),
    );
    _ensureSuccess(response, 'Failed to load cart');
    return CartModel.fromList(response.data);
  }

  Future<CartModel> addToCart({
    required int productId,
    int quantity = 1,
    String? token,
  }) async {
    final response = await dioClient.post(
      '$baseUrl/client/carts/store',
      data: {'product_id': productId, 'quantity': quantity},
      options: _options(token),
    );
    _ensureSuccess(response, 'Failed to add to cart');
    return _cartFromResponse(response.data, productId, quantity);
  }

  Future<void> removeFromCart({
    required int productId,
    String? token,
  }) async {
    final response = await dioClient.delete(
      '$baseUrl/client/carts/destroy',
      data: {'product_id': productId},
      options: _options(token),
    );
    _ensureSuccess(response, 'Failed to remove cart item');
  }

  Future<CartModel> updateCartItem({
    required int productId,
    required int quantity,
    String? token,
  }) {
    return addToCart(
      productId: productId,
      quantity: quantity,
      token: token,
    );
  }

  CartModel _cartFromResponse(dynamic data, int productId, int quantity) {
    final payload = data is Map<String, dynamic>
        ? (data['data'] ?? data['cart'] ?? data['result'])
        : data;
    if (payload is Map<String, dynamic>) {
      return CartModel.fromJson(payload);
    }
    return CartModel(
      id: 0,
      productId: productId,
      productName: 'Product $productId',
      quantity: quantity,
    );
  }

  void _ensureSuccess(Response<dynamic> response, String message) {
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? message)
            : message,
      );
    }
  }
}
