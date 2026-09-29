import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';

class AuthRepository {
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await DioHelper.postData(
      url: '/admin/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required FormData formData,
  }) async {
    return await DioHelper.postData(
      url: '/admin/register',
      data: formData,
    );
  }

  Future<Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await DioHelper.postData(
      url: '/admin/otp/verify',
      data: {'email': email, 'otp_code': otp},
    );
  }

  Future<Response> logout() async {
    return await DioHelper.postData(url: '/admin/logout');
  }
}
