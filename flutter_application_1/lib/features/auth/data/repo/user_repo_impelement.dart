import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/errors/failer_models.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/params/otp_resend_params.dart';
import '../../../../core/params/otp_verify_params.dart';
import '../../../../core/params/register_param.dart';
import '../remote/otp_resend_remote_data_source.dart';
import '../remote/otp_verify_remote_data_source.dart';
import '../remote/register_remote_data_source.dart';
import '../../domain/entities/user_entites.dart';
import '../../domain/repo/auth_repo.dart';

class UserRepoImpelement implements AuthRepo {
  UserRepoImpelement({
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
    } on DioException {
      return const Left(FailerModels());
    } catch (_) {
      return const Left(FailerModels());
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
    } on DioException {
      return const Left(FailerModels());
    } catch (_) {
      return const Left(FailerModels());
    }
  }

  @override
  Future<Either<FailerModels, UserEntites>> verifyOTP({
    required OtpVerifyParams params,
  }) async {
    try {
      final user = await otpRemoteDataSource.verifyOtp(params: params);
      return Right(user);
    } on DioException {
      return const Left(FailerModels());
    } catch (_) {
      return const Left(FailerModels());
    }
  }

  @override
  Future<Either<FailerModels, bool>> resendOTP({
    required OtpResendParams params,
  }) async {
    try {
      final success = await otpResendRemoteDataSource.resendOtp(params: params);
      return Right(success);
    } on DioException {
      return const Left(FailerModels());
    } catch (_) {
      return const Left(FailerModels());
    }
  }
}
