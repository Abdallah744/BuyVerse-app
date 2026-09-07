import 'package:easy_shop_profile/core/params/login_params.dart';
import 'package:easy_shop_profile/core/params/otp_resend_params.dart';
import 'package:easy_shop_profile/core/params/otp_verify_params.dart';
import 'package:easy_shop_profile/core/params/register_param.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/user_repo_impelement.dart';
import '../../domain/entities/user_entites.dart';

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
  AuthCubit({UserRepoImpelement? repository})
      : repository = repository ?? UserRepoImpelement(),
        super(AuthInitial());

  final UserRepoImpelement repository;

  Future<void> register({required RegisterParam params}) async {
    emit(AuthLoading());

    try {
      final result = await repository.registerUser(params: params);
      result.fold(
        (_) => emit(AuthError('Registration failed. Please try again.')),
        (user) => emit(AuthSuccess(user)),
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
        (_) => emit(AuthError('Login failed. Please check your credentials.')),
        (user) => emit(AuthSuccess(user)),
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
        (_) => emit(AuthError('OTP verification failed. Please try again.')),
        (user) => emit(AuthSuccess(user)),
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
        (_) => emit(AuthError('Failed to resend OTP. Please try again.')),
        (_) => emit(AuthInitial()),
      );
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
