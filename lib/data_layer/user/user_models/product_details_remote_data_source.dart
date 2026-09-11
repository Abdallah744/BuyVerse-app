import 'package:buy_verse_app/data_layer/user/user_models/product_model.dart';
import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';

class ProductDetailsRemoteDataSource {
  ProductDetailsRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<ProductModel> getProductBySlug({
    required String slug,
    String? token,
  }) async {
    final response = await dioClient.get(
      '$baseUrl/client/products/show/$slug',
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
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? 'Failed to load product details')
            : 'Failed to load product details',
      );
    }

    dynamic payload = response.data;
    if (payload is Map<String, dynamic>) {
      final map = payload['data'] ?? payload['product'] ?? payload['result'];
      if (map is Map<String, dynamic>) {
        payload = map;
      }
    }

    if (payload is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: 'Unexpected product details response format',
      );
    }

    return ProductModel.fromJson(payload);
  }
}
