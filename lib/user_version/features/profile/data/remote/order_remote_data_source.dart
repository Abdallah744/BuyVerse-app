// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/api_config.dart';
import '../../models/order.dart';

class OrderRemoteDataSource {
  OrderRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
    this.authToken,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;
  final String? authToken;

  Future<List<OrderModel>> getOrders({String? token}) async {
    final bearerToken = token ?? authToken;
    final prefs = await SharedPreferences.getInstance();
    final response = await dioClient.get(
      '$baseUrl/client/orders',
      options: Options(
        headers: {
          'Accept': 'application/json',
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
        error: 'Failed to load orders',
      );
    }
    return OrderModel.fromList(response.data);
  }
}
