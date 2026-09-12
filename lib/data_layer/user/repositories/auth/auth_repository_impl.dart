import 'package:buy_verse_app/core_layer/user/core/models/errors/failer_models.dart';
import 'package:buy_verse_app/core_layer/user/core/params/login_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_resend_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_verify_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/register_param.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/auth/otp_resend_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/auth/otp_verify_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/remote_data/auth/register_remote_data_source.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/domain_layer/user/repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepo {
  AuthRepositoryImpl({
    RegisterRemoteDataSource? remoteDataSource,
    OtpVerifyRemoteDataSource? otpRemoteDataSource,
    OtpResendRemoteDataSource? otpResendRemoteDataSource,
  }) : remoteDataSource = remoteDataSource ?? RegisterRemoteDataSource(),
       otpRemoteDataSource = otpRemoteDataSource ?? OtpVerifyRemoteDataSource(),
       otpResendRemoteDataSource =
           otpResendRemoteDataSource ?? OtpResendRemoteDataSource();

  final RegisterRemoteDataSource remoteDataSource;
  final OtpVerifyRemoteDataSource otpRemoteDataSource;
  final OtpResendRemoteDataSource otpResendRemoteDataSource;

  @override
  Future<Either<FailerModels, UserEntites>> logIN({
    required LoginParams params,
  }) async {
    try {
      final user = await remoteDataSource.login(params: params);
      return Right(user);
    } on DioException catch (e) {
      return Left(FailerModels(message: e.error?.toString() ?? 'Login failed'));
    } catch (e) {
      return Left(FailerModels(message: e.toString()));
    }
  }

  @override
  void logOut() {}

  @override
  Future<Either<FailerModels, UserEntites>> registerUser({
    required RegisterParam params,
  }) async {
    try {
      final user = await remoteDataSource.register(params: params);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        FailerModels(message: e.error?.toString() ?? 'Registration failed'),
      );
    } catch (e) {
      return Left(FailerModels(message: e.toString()));
    }
  }

  @override
  Future<Either<FailerModels, UserEntites>> verifyOTP({
    required OtpVerifyParams params,
  }) async {
    try {
      final user = await otpRemoteDataSource.verifyOtp(params: params);
      return Right(user);
    } on DioException catch (e) {
      return Left(
        FailerModels(message: e.error?.toString() ?? 'OTP verification failed'),
      );
    } catch (e) {
      return Left(FailerModels(message: e.toString()));
    }
  }

  @override
  Future<Either<FailerModels, bool>> resendOTP({
    required OtpResendParams params,
  }) async {
    try {
      final success = await otpResendRemoteDataSource.resendOtp(params: params);
      return Right(success);
    } on DioException catch (e) {
      return Left(
        FailerModels(message: e.error?.toString() ?? 'Failed to resend OTP'),
      );
    } catch (e) {
      return Left(FailerModels(message: e.toString()));
    }
  }
}
