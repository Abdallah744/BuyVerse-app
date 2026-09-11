import 'package:dartz/dartz.dart';
import 'package:buy_verse_app/core_layer/user/core/models/errors/failer_models.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/core_layer/user/core/params/register_param.dart';
import 'package:buy_verse_app/core_layer/user/core/params/login_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_verify_params.dart';
import 'package:buy_verse_app/core_layer/user/core/params/otp_resend_params.dart';

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
