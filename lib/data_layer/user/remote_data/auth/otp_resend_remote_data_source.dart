import 'package:dio/dio.dart';

import '../../../../core_layer/user/core/network/api_config.dart';
import '../../../../core_layer/user/core/params/otp_resend_params.dart';

class OtpResendRemoteDataSource {
  OtpResendRemoteDataSource({Dio? dio, this.baseUrl = ApiConfig.baseUrl})
    : dioClient = dio ?? ApiConfig.createDio();

  final Dio dioClient;
  final String baseUrl;

  Future<bool> resendOtp({required OtpResendParams params}) async {
    final response = await dioClient.post(
      '$baseUrl/client/otp/resend',
      data: {'email': params.email.trim()},
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
      throw DioException(
        requestOptions: response.requestOptions,
        error: response.data is Map<String, dynamic>
            ? (response.data['message'] ?? 'Resend OTP failed')
            : 'Resend OTP failed',
      );
    }

    return true;
  }
}
