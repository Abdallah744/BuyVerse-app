import 'package:dartz/dartz.dart';
import 'package:easy_shop_profile/core/models/errors/failer_models.dart';
import 'package:easy_shop_profile/core/params/login_params.dart';
import 'package:easy_shop_profile/core/params/otp_resend_params.dart';
import 'package:easy_shop_profile/core/params/otp_verify_params.dart';
import 'package:easy_shop_profile/core/params/register_param.dart';
import 'package:easy_shop_profile/features/auth/domain/entities/user_entites.dart';

abstract class AuthRepo {
  Future<Either<FailerModels, UserEntites>> registerUser({
    required RegisterParam params,
  });
  Future<Either<FailerModels, UserEntites>> logIN({
    required LoginParams params,
  });
  Future<Either<FailerModels, UserEntites>> verifyOTP({
    required OtpVerifyParams params,
  });
  Future<Either<FailerModels, bool>> resendOTP({
    required OtpResendParams params,
  });
  void logOut() {}
}
