import 'package:dartz/dartz.dart';
import '../../../../core/models/errors/failer_models.dart';
import '../../../../core/params/register_param.dart';
import '../entities/user_entites.dart';
import '../repo/auth_repo.dart';

class SignUpUsecase {
  final AuthRepo reposatory;

  SignUpUsecase({required this.reposatory});
  Future<Either<FailerModels, UserEntites>> call({
    required RegisterParam params,
  }) async {
    return await reposatory.registerUser(params: params);
  }
}
