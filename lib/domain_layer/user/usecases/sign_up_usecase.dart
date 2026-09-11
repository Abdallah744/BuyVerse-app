import 'package:dartz/dartz.dart';
import 'package:buy_verse_app/core_layer/user/core/models/errors/failer_models.dart';
import 'package:buy_verse_app/core_layer/user/core/params/register_param.dart';
import 'package:buy_verse_app/domain_layer/user/entities/user_entites.dart';
import 'package:buy_verse_app/domain_layer/user/repo/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo reposatory;

  SignUpUsecase({required this.reposatory});
  Future<Either<FailerModels, UserEntites>> call({
    required RegisterParam params,
  }) async {
    return await reposatory.registerUser(params: params);
  }
}
