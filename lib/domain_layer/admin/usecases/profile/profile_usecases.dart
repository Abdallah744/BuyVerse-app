import 'package:dio/dio.dart';
import '../../../../../data_layer/admin/repositories/profile_repository.dart';
import '../base_usecase.dart';

class GetProfileUseCase extends UseCase<Response, NoParams> {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);
  @override
  Future<Response> call(NoParams params) async => await repository.getProfile();
}

class UpdateProfileUseCase extends UseCase<Response, FormData> {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);
  @override
  Future<Response> call(FormData params) async => await repository.updateProfile(formData: params);
}
