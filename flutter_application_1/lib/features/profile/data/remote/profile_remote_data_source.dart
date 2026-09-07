import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../../auth/data/models/user_models.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({Dio? dio})
      : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;

  Future<UserModels> getProfile({required String token}) async {
    final response = await dioClient.get(
      '${ApiConfig.baseUrl}/client/profile',
      options: Options(
        headers: {
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
            ? (response.data['message'] ?? 'Failed to load profile')
            : 'Failed to load profile',
      );
    }

    final payload = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    final data = payload['data'] is Map<String, dynamic>
        ? payload['data'] as Map<String, dynamic>
        : payload;
    final user = data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : data;

    return UserModels.fromJson(user);
  }
}
