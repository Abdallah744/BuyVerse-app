import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core_layer/user/core/network/api_config.dart';
import '../user_models/user_models.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource({Dio? dio})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  // the function to get the profile data from the api
  Future<UserModels> getProfile({required String token}) async {
    final response = await dioClient.get(
      '${ApiConfig.baseUrl}/client/profile',
      options: Options(
        // the basics of the request
        headers: {
          'Authorization': ApiConfig.authorizationHeader(token),
          'Accept': 'application/json',
          'Content-Type': 'application/json',
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

  Future<UserModels> updateProfile({
    required String token,
    String? name,
    String? email,
    String? phone,
    File? picture,
  }) async {
    final formData = FormData.fromMap({
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (picture != null)
        'picture': await MultipartFile.fromFile(picture.path),
    });
    final response = await dioClient.post(
      '${ApiConfig.baseUrl}/client/profile/update',
      data: formData,
      options: Options(
        headers: {'Authorization': ApiConfig.authorizationHeader(token)},
      ),
    );
    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? 'Failed to update profile')
            : 'Failed to update profile',
      );
    }
    final payload = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};
    final data = payload['data'] is Map<String, dynamic>
        ? payload['data'] as Map<String, dynamic>
        : payload;
    return UserModels.fromJson(data);
  }
}
