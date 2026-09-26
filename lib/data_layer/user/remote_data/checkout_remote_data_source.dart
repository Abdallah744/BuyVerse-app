import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';
import '../user_models/checkout_model.dart';

class CheckoutRemoteDataSource {
  CheckoutRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Options _options(String? token) => Options(
    headers: {
      if (token != null && token.isNotEmpty)
        'Authorization': ApiConfig.authorizationHeader(token),
      'Accept': 'application/json',
    },
  );

  Future<CheckoutModel> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
    String? token,
  }) async {
    print('Creating order with data:');
    print('Product IDs: $productIds');
    print('Quantities: $quantities');
    print('Prices: $prices');
    print('Address: $address');
    print('Payment method: $paymentMethod');
    
    final response = await dioClient.post(
      '$baseUrl/client/orders/store',
      data: {
        'product_id': productIds,
        'quantity': quantities,
        'price': prices,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'payment_method': paymentMethod,
        'update_stock': true, // Request stock update
      },
      options: _options(token),
    );
    
    print('Order creation response status: ${response.statusCode}');
    print('Order creation response data: ${response.data}');
    
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? 'Failed to create order')
            : 'Failed to create order',
      );
    }
    dynamic payload = response.data;
    if (payload is Map<String, dynamic>) {
      final nested = payload['data'] ?? payload['order'] ?? payload['result'];
      if (nested is Map<String, dynamic>) payload = nested;
    }
    if (payload is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Unexpected order response format',
      );
    }
    final checkout = CheckoutModel.fromJson(payload);
    
    // Log for debugging
    print('Created order with ID: ${checkout.id}');
    
    return checkout;
  }
}
