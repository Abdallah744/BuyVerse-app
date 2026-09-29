import 'package:dartz/dartz.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/models/errors/failer_models.dart';
import '../entities/user_entites.dart';
import '../repo/auth_repo.dart';

class SignInUsecase {
  final AuthRepo reposatory;

  SignInUsecase({required this.reposatory});

  Future<Either<FailerModels, UserEntites>> call({
    required LoginParams params,
  }) async {
    return await reposatory.logIN(params: params);
  }
}
