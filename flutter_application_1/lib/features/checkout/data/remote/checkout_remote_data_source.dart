import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../models/checkout_model.dart';

class CheckoutRemoteDataSource {
  CheckoutRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

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
      },
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
        },
      ),
    );
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Failed to create order',
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
    return CheckoutModel.fromJson(payload);
  }
}
