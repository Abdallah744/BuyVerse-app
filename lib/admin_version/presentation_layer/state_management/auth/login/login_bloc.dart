// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:buy_verse_app/admin_version/core_layer/helpers/cache_helper.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/auth/auth_usecases.dart';
import 'package:buy_verse_app/admin_version/domain_layer/usecases/base_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

String _parseError(dynamic errorResponse) {
  if (errorResponse is Map) {
    if (errorResponse['errors'] != null && errorResponse['errors'] is Map) {
      var errors = errorResponse['errors'] as Map;
      if (errors.isNotEmpty) {
        var firstKey = errors.keys.first;
        var firstError = errors[firstKey];
        if (firstError is List && firstError.isNotEmpty) {
          return "$firstKey: ${firstError[0]}";
        }
        return "$firstKey: $firstError";
      }
    }
    if (errorResponse['message'] != null) {
      return errorResponse['message'].toString();
    }
  }
  return errorResponse?.toString() ?? 'Operation failed';
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      print('DEBUG: LoginRequested for email: ${event.email}');
      emit(AuthLoading());
      try {
        final response = await loginUseCase(
          LoginParams(email: event.email, password: event.password),
        );

        final responseData = response.data;
        print('DEBUG: Login Full Response: $responseData');

        if (response.statusCode == 200) {
          if (responseData != null &&
              responseData['message'] != null &&
              responseData['message'].toString().toLowerCase().contains(
                'otp',
              )) {
            print('DEBUG: Login requires OTP verification');
            await CacheHelper.saveData(key: 'isVerified', value: false);
            emit(const AuthError('VERIFICATION_REQUIRED'));
          } else if (responseData != null) {
            final token =
                responseData['token']?.toString() ??
                responseData['data']?['token']?.toString();
            final data = responseData['data'];
            final uId = data != null
                ? data['id']?.toString()
                : responseData['id']?.toString();

            if (token != null && uId != null) {
              print('DEBUG: Login Success. Saving token: $token');
              DioHelper.token = token; // Update static token in memory
              await CacheHelper.saveData(key: 'token', value: token);
              await CacheHelper.saveData(key: 'uId', value: uId);
              await CacheHelper.saveData(key: 'isVerified', value: true);
              await CacheHelper.saveData(
                key: 'verified_${event.email}',
                value: true,
              );

              emit(Authenticated(uId));
            } else {
              print(
                'DEBUG: Login 200 but token or uId is null. Token: $token, uId: $uId',
              );
              emit(AuthError('Invalid user data received from server'));
            }
          } else {
            print('DEBUG: Login 200 but data is null');
            emit(AuthError('Server error: Data is missing'));
          }
        } else {
          print('DEBUG: Login failed status: ${response.statusCode}');
          emit(AuthError(_parseError(responseData)));
        }
      } catch (e) {
        print('DEBUG: Login Exception: $e');
        if (e is DioException) {
          emit(AuthError(_parseError(e.response?.data)));
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<RegisterRequested>((event, emit) async {
      print('DEBUG: RegisterRequested');
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

        final response = await registerUseCase(formData);
        final responseData = response.data;
        print('DEBUG: Register Full Response: $responseData');

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (responseData != null) {
            final token =
                responseData['token']?.toString() ??
                responseData['data']?['token']?.toString();
            final data = responseData['data'];
            final uId = data != null
                ? data['id']?.toString()
                : responseData['id']?.toString();

            if (token != null && uId != null) {
              DioHelper.token = token; // Update static token in memory
              await CacheHelper.saveData(key: 'token', value: token);
              await CacheHelper.saveData(key: 'uId', value: uId);
              await CacheHelper.saveData(
                key: 'verified_${event.profile.email}',
                value: true,
              );
              emit(Authenticated(uId));
            } else {
              emit(AuthError('Registration success, please login'));
            }
          } else {
            emit(AuthError('Registration success, please login'));
          }
        } else {
          emit(AuthError(_parseError(responseData)));
        }
      } catch (e) {
        if (e is DioException) {
          emit(AuthError(_parseError(e.response?.data)));
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<LogoutRequested>((event, emit) async {
      try {
        await logoutUseCase(NoParams());
      } finally {
        await CacheHelper.removeData(key: 'token');
        await CacheHelper.removeData(key: 'uId');
        await CacheHelper.removeData(key: 'role'); // Clear role
        DioHelper.token = null; // Clear static token
        emit(Unauthenticated());
      }
    });

    on<VerifyOtpRequested>((event, emit) async {
      print('DEBUG: VerifyOtpRequested for: ${event.email}');
      emit(AuthLoading());
      try {
        final response = await verifyOtpUseCase(
          OtpParams(email: event.email, otp: event.otp),
        );

        final responseData = response.data;
        print('DEBUG: OTP Verify Full Response: $responseData');

        if (response.statusCode == 200) {
          if (responseData != null) {
            final token =
                responseData['token']?.toString() ??
                responseData['data']?['token']?.toString();
            final data = responseData['data'];
            final uId = data != null
                ? data['id']?.toString()
                : responseData['id']?.toString();

            if (token != null) {
              print('DEBUG: OTP Success. Saving token to memory: $token');
              DioHelper.token =
                  token; // CRITICAL FIX: Save to memory immediately
              await CacheHelper.saveData(key: 'token', value: token);
              if (uId != null) {
                await CacheHelper.saveData(key: 'uId', value: uId);
              }
              await CacheHelper.saveData(
                key: 'verified_${event.email}',
                value: true,
              );
              await CacheHelper.saveData(key: 'isVerified', value: true);

              emit(OtpVerified());
            } else {
              print(
                'DEBUG: OTP Success but no token in response. Token: $token',
              );
              await CacheHelper.saveData(
                key: 'verified_${event.email}',
                value: true,
              );
              await CacheHelper.saveData(key: 'isVerified', value: true);
              emit(OtpVerified());
            }
          } else {
            print('DEBUG: OTP Verified but response data is null');
            await CacheHelper.saveData(
              key: 'verified_${event.email}',
              value: true,
            );
            await CacheHelper.saveData(key: 'isVerified', value: true);
            emit(OtpVerified());
          }
        } else {
          emit(AuthError(_parseError(responseData)));
        }
      } catch (e) {
        print('DEBUG: OTP Verify Exception: $e');
        if (e is DioException) {
          emit(AuthError(_parseError(e.response?.data)));
        } else {
          emit(AuthError(e.toString()));
        }
      }
    });

    on<ResendOtpRequested>((event, emit) async {
      try {
        await DioHelper.postData(
          url: '/admin/otp/resend',
          data: {'email': event.email},
        );
        emit(OtpResent());
      } catch (e) {
        // Log or handle
      }
    });
  }
}
