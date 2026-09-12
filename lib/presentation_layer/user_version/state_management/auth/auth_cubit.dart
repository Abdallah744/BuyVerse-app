import 'package:buy_verse_app/core_layer/user/core/params/login_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_resend_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_verify_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/register_param.dart';
import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/domain_layer/user/repo/auth_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess(this.user);

  final UserEntites user;
}

class AuthError extends AuthState {
  AuthError(this.message);

  final String message;
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.repository,
    SharedPreferencesService? sharedPreferencesService,
  })  : _sharedPreferencesService = sharedPreferencesService ?? SharedPreferencesService.instance,
        super(AuthInitial());

  final AuthRepo repository;
  final SharedPreferencesService _sharedPreferencesService;

  Future<void> register({required RegisterParam params}) async {
    emit(AuthLoading());

    try {
      final result = await repository.registerUser(params: params);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) async {
          if (user.token != null && user.token!.isNotEmpty) {
            await saveAuthToken(user.token!);
          }
          if (user.name != null && user.name!.isNotEmpty) {
            await saveAuthName(user.name!);
          }
          emit(AuthSuccess(user));
        },
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> login({required LoginParams params}) async {
    emit(AuthLoading());

    try {
      final result = await repository.logIN(params: params);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) async {
          if (user.token != null && user.token!.isNotEmpty) {
            await saveAuthToken(user.token!);
          }
          if (user.name != null && user.name!.isNotEmpty) {
            await saveAuthName(user.name!);
          }
          emit(AuthSuccess(user));
        },
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> verifyOtp({required OtpVerifyParams params}) async {
    emit(AuthLoading());

    try {
      final result = await repository.verifyOTP(params: params);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) async {
          if (user.token != null && user.token!.isNotEmpty) {
            await saveAuthToken(user.token!);
          }
          if (user.name != null && user.name!.isNotEmpty) {
            await saveAuthName(user.name!);
          }
          emit(AuthSuccess(user));
        },
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> resendOtp({required OtpResendParams params}) async {
    emit(AuthLoading());

    try {
      final result = await repository.resendOTP(params: params);
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (_) => emit(AuthInitial()),
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  Future<void> saveAuthToken(String token) async {
    await _sharedPreferencesService.setAuthToken(token);
  }

  Future<void> saveAuthName(String name) async {
    await _sharedPreferencesService.setAuthName(name);
  }

  Future<void> clearAuthData() async {
    await _sharedPreferencesService.clearAuthData();
  }

  Future<String?> getAuthToken() async {
    return await _sharedPreferencesService.getAuthToken();
  }
}
