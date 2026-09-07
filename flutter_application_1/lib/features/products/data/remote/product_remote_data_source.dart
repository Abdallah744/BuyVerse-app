import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../models/product_model.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<List<ProductModel>> getProducts({String? token}) async {
    final response = await dioClient.get(
      '$baseUrl/client/products',
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
