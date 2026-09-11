import 'package:dio/dio.dart';

import '../../../../core_layer/user/core/network/api_config.dart';

class LogoutRemoteDataSource {
  LogoutRemoteDataSource({Dio? dio}) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;

  Future<bool> logout({required String token}) async {
    final response = await dioClient.post(
      '${ApiConfig.baseUrl}/client/logout',
      options: Options(
        headers: {
          'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
        },
      ),
    );

    return response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300;
  }
}
