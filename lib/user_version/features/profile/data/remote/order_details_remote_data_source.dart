import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../models/order.dart';

class OrderDetailsRemoteDataSource {
  OrderDetailsRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
    this.authToken,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;
  final String? authToken;

  Future<OrderModel> getOrderDetails({
    required int orderId,
    String? token,
  }) async {
    final bearerToken = token ?? authToken;
    final response = await dioClient.get(
      '$baseUrl/client/orders/show/$orderId',
      options: Options(
        headers: {
          if (bearerToken != null && bearerToken.isNotEmpty)
            'Authorization': ApiConfig.authorizationHeader(bearerToken),
        },
      ),
    );
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Failed to load order details',
      );
    }
    final payload = response.data;
    if (payload is Map && payload['data'] is Map) {
      return OrderModel.fromJson(payload['data'] as Map<String, dynamic>);
    }
    if (payload is Map<String, dynamic>) {
      return OrderModel.fromJson(payload);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      error: 'Unexpected order details response format',
    );
  }
}
