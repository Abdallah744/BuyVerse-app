import 'package:dartz/dartz.dart';
import 'package:easy_shop_profile/core/models/errors/failer_models.dart';
import 'package:easy_shop_profile/core/params/login_params.dart';
import 'package:easy_shop_profile/features/auth/domain/entities/user_entites.dart';
import 'package:easy_shop_profile/features/auth/domain/repo/auth_repo.dart';

class SignInUsecase {
  final AuthRepo reposatory;

  SignInUsecase({required this.reposatory});

  Future<Either<FailerModels, UserEntites>> call({
    required LoginParams params,
  }) async {
    return await reposatory.logIN(params: params);
  }
}
