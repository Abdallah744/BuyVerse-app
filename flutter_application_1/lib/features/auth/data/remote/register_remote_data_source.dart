import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/params/register_param.dart';
import '../../data/models/user_models.dart';

class RegisterRemoteDataSource {
  RegisterRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<UserModels> register({required RegisterParam params}) async {
    final response = await dioClient.post(
      '$baseUrl/client/register',
      data: FormData.fromMap({
        'name': params.name,
        'email': params.email,
        'phone': params.phone,
        'password': params.password,
        if ((params.confirmPassword ?? '').isNotEmpty)
          'password_confirmation': params.confirmPassword,
        if ((params.address ?? '').isNotEmpty) 'address': params.address,
        if ((params.pic ?? '').isNotEmpty) 'picture': params.pic,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      final message = response.data is Map<String, dynamic>
          ? (response.data['message'] ?? 'Registration failed')
          : 'Registration failed';
      throw DioException(
        requestOptions: response.requestOptions,
        error: message,
      );
    }

    return _buildUserFromResponse(response.data);
  }

  Future<UserModels> login({required LoginParams params}) async {
    final response = await dioClient.post(
      '$baseUrl/client/login',
      data: {
        'email': params.email.trim(),
        'password': params.password,
      },
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      final message = response.data is Map<String, dynamic>
          ? (response.data['message'] ?? 'Login failed')
          : 'Login failed';
      throw DioException(
        requestOptions: response.requestOptions,
        error: message,
      );
    }

    return _buildUserFromResponse(response.data);
  }

  UserModels _buildUserFromResponse(dynamic payload) {
    final payloadMap =
        payload is Map<String, dynamic> ? payload : <String, dynamic>{};

    final nestedData = payloadMap['data'] is Map<String, dynamic>
        ? payloadMap['data'] as Map<String, dynamic>
        : payloadMap;
    final userMap = payloadMap['user'] is Map<String, dynamic>
        ? payloadMap['user'] as Map<String, dynamic>
        : nestedData;

    final token = (payloadMap['token'] ??
            payloadMap['access_token'] ??
            nestedData['token'] ??
            nestedData['access_token'] ??
            '')
        .toString();

    return UserModels.fromJson({
      ...userMap,
      if (token.isNotEmpty) 'token': token,
      if (payloadMap['token'] != null) 'token': payloadMap['token'],
      if (payloadMap['access_token'] != null)
        'token': payloadMap['access_token'],
    });
  }
}
