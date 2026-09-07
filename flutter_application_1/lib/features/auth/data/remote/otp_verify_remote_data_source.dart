import 'package:dio/dio.dart';

import '../../../../core/network/api_config.dart';
import '../../../../core/params/otp_verify_params.dart';
import '../../data/models/user_models.dart';

class OtpVerifyRemoteDataSource {
  OtpVerifyRemoteDataSource({
    Dio? dio,
    this.baseUrl = ApiConfig.baseUrl,
  }) : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<UserModels> verifyOtp({required OtpVerifyParams params}) async {
    final response = await dioClient.post(
      '$baseUrl/client/otp/verify',
      data: {'email': params.email.trim(), 'otp_code': params.otpCode.trim()},
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      final message = response.data is Map<String, dynamic>
          ? (response.data['message'] ?? 'OTP verification failed')
          : 'OTP verification failed';
      throw DioException(
        requestOptions: response.requestOptions,
        error: message,
      );
    }

    final payloadMap = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final userMap = payloadMap['user'] is Map<String, dynamic>
        ? payloadMap['user'] as Map<String, dynamic>
        : payloadMap['data'] is Map<String, dynamic>
        ? payloadMap['data'] as Map<String, dynamic>
        : payloadMap;

    final token =
        (payloadMap['token'] ??
                payloadMap['access_token'] ??
                userMap['token'] ??
                userMap['access_token'] ??
                '')
            .toString();

    return UserModels.fromJson({
      ...userMap,
      if (token.isNotEmpty) 'token': token,
    });
  }
}
