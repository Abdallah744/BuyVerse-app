import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core_layer/admin/helpers/cache_helper.dart';
import '../../../../../core_layer/admin/helpers/dio_helper.dart';
import 'login_event.dart';
import 'login_state.dart';

String _parseError(dynamic errorResponse) {
  if (errorResponse is Map) {
    if (errorResponse['message'] != null) {
      if (errorResponse['message'] is Map) {
        Map<String, dynamic> errors = errorResponse['message'];
        if (errors.isNotEmpty) {
          var firstKey = errors.keys.first;
          var firstError = errors[firstKey];
          if (firstError is List && firstError.isNotEmpty) {
            return "$firstKey: ${firstError[0]}";
          }
          return "$firstKey: $firstError";
        }
      }
      return errorResponse['message'].toString();
    }
    if (errorResponse.isNotEmpty) {
      var firstKey = errorResponse.keys.first;
      var firstError = errorResponse[firstKey];
      if (firstError is List && firstError.isNotEmpty) {
        return "$firstKey: ${firstError[0]}";
      }
      return "$firstKey: $firstError";
    }
  }
  return errorResponse?.toString() ?? 'Operation failed';
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      print('DEBUG: LoginRequested for email: ${event.email}');
      emit(AuthLoading());
      try {
        final response = await DioHelper.postData(
          url: '/admin/login',
          data: {'email': event.email, 'password': event.password},
        );

        print('DEBUG: Response Status Code: ${response.statusCode}');
        print('DEBUG: Response Data: ${response.data}');

        if (response.statusCode == 200) {
          final responseData = response.data;
          if (responseData != null && responseData['data'] != null) {
            final data = responseData['data'];
            final token = data['token'];
            final uId = data['id'].toString();

            await CacheHelper.saveData(key: 'token', value: token);
            await CacheHelper.saveData(key: 'uId', value: uId);
            await CacheHelper.saveData(key: 'isVerified', value: true);

            emit(Authenticated(uId));
          } else if (responseData != null &&
              responseData['message'] != null &&
              responseData['message']
                  .toString()
                  .toLowerCase()
                  .contains('otp')) {
            await CacheHelper.saveData(key: 'isVerified', value: false);
            emit(const AuthError('VERIFICATION_REQUIRED'));
          } else {
            emit(AuthError('Invalid response format: "data" field missing'));
          }
        } else {
          print('DEBUG: Login Failed with status ${response.statusCode}');
          emit(AuthError(_parseError(response.data)));
        }
      } catch (e) {
        print('DEBUG: Login Exception: $e');
        if (e is DioException) {
          print('DEBUG: Dio Error Type: ${e.type}');
          print('DEBUG: Dio Error Response: ${e.response?.data}');
          emit(
            AuthError(
              _parseError(e.response?.data) ?? e.message ?? 'Login failed',
            ),
          );
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        FormData formData = FormData.fromMap({
          'name': event.profile.fullName,
          'email': event.profile.email,
          'phone': event.profile.phone.trim(),
          'password': event.password,
          'password_confirmation': event.password,
          'national_id': event.profile.nationalId,
          'business_name': event.profile.businessName,
          'address': event.profile.businessAddress,
          'latitude': '30.0',
          'longitude': '31.0',
        });

        if (event.profileImagePath != null) {
          formData.files.add(
            MapEntry(
              'picture',
              await MultipartFile.fromFile(
                event.profileImagePath!,
                filename: 'profile.png',
              ),
            ),
          );
        }

        if (event.commercialRegisterPath != null) {
          formData.files.add(
            MapEntry(
              'commercial_register',
              await MultipartFile.fromFile(
                event.commercialRegisterPath!,
                filename: 'commercial.pdf',
              ),
            ),
          );
        }

        if (event.taxCardPath != null) {
          formData.files.add(
            MapEntry(
              'tax_card',
              await MultipartFile.fromFile(
                event.taxCardPath!,
                filename: 'tax.pdf',
              ),
            ),
          );
        }

        final response = await DioHelper.postData(
          url: '/admin/register',
          data: formData,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = response.data;
          if (responseData != null && responseData['data'] != null) {
            final data = responseData['data'];
            final token = data['token'];
            final uId = data['id'].toString();

            await CacheHelper.saveData(key: 'token', value: token);
            await CacheHelper.saveData(key: 'uId', value: uId);

            emit(Authenticated(uId));
          } else {
            emit(AuthError('Invalid response format: "data" field missing'));
          }
        } else {
          emit(AuthError(_parseError(response.data)));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            AuthError(
              _parseError(e.response?.data) ??
                  e.message ??
                  'Registration failed',
            ),
          );
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await DioHelper.postData(url: '/admin/logout');
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'uId');
        emit(Unauthenticated());
      } catch (e) {
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'uId');
        emit(Unauthenticated());
      }
    });
  }
}
