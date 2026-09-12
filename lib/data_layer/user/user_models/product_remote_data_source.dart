import 'package:buy_verse_app/data_layer/user/user_models/product_model.dart';
import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<List<ProductModel>> getProducts({String? token, int? categoryId}) async {
    String url = '$baseUrl/client/products';
    if (categoryId != null) {
      url = '$baseUrl/client/products?category_id=$categoryId';
    }
    
    final response = await dioClient.get(
      url,
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
            ? (response.data['message'] ?? 'Failed to load products')
            : 'Failed to load products',
      );
    }

    return ProductModel.fromList(response.data);
  }
}
