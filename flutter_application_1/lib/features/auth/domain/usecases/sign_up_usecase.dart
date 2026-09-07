import 'package:dartz/dartz.dart';
import 'package:easy_shop_profile/core/errors/failer_models.dart';
import 'package:easy_shop_profile/core/params/register_param.dart';
import 'package:easy_shop_profile/features/auth/domain/entities/user_entites.dart';
import 'package:easy_shop_profile/features/auth/domain/repo/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo reposatory;

  SignUpUsecase({required this.reposatory});
  Future<Either<FailerModels, UserEntites>> call({
    required RegisterParam params,
  }) async {
    return await reposatory.registerUser(params: params);
  }
}
