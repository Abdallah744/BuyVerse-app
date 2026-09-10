import 'package:dio/dio.dart';
import '../../../../../data_layer/admin/repositories/auth_repository.dart';
import '../base_usecase.dart';

class LoginUseCase extends UseCase<Response, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);
  @override
  Future<Response> call(LoginParams params) async => await repository.login(email: params.email, password: params.password);
}

class RegisterUseCase extends UseCase<Response, FormData> {
  final AuthRepository repository;
  RegisterUseCase(this.repository);
  @override
  Future<Response> call(FormData params) async => await repository.register(formData: params);
}

class VerifyOtpUseCase extends UseCase<Response, OtpParams> {
  final AuthRepository repository;
  VerifyOtpUseCase(this.repository);
  @override
  Future<Response> call(OtpParams params) async => await repository.verifyOtp(email: params.email, otp: params.otp);
}

class LogoutUseCase extends UseCase<Response, NoParams> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);
  @override
  Future<Response> call(NoParams params) async => await repository.logout();
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}

class OtpParams {
  final String email;
  final String otp;
  OtpParams({required this.email, required this.otp});
}
