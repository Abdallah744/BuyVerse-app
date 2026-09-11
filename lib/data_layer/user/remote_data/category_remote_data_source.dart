import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';
import '../user_models/category_model.dart';

class CategoryRemoteDataSource {
  CategoryRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<List<CategoryModel>> getCategories({String? token}) async {
    final response = await dioClient.get(
      '$baseUrl/client/categories',
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
            ? (response.data['message'] ?? 'Failed to load categories')
            : 'Failed to load categories',
      );
    }

    return CategoryModel.fromList(response.data);
  }
}
