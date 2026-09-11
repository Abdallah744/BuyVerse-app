import 'package:dartz/dartz.dart';
import 'package:buy_verse_app/core_layer/user/core/models/errors/failer_models.dart';
import 'package:buy_verse_app/core_layer/user/core/params/login_params.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/domain_layer/user/repo/auth_repo.dart';

class SignInUsecase {
  final AuthRepo reposatory;

  SignInUsecase({required this.reposatory});

  Future<Either<FailerModels, UserEntites>> call({
    required LoginParams params,
  }) async {
    return await reposatory.logIN(params: params);
  }
}
