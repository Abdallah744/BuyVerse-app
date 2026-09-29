import 'package:equatable/equatable.dart';

import 'package:buy_verse_app/admin_version/data_layer/admin_models/profile.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final UserProfile profile;
  final String password;
  final String? profileImagePath;
  final String? commercialRegisterPath;
  final String? taxCardPath;

  const RegisterRequested({
    required this.profile,
    required this.password,
    this.profileImagePath,
    this.commercialRegisterPath,
    this.taxCardPath,
  });

  @override
  List<Object?> get props => [
    profile,
    password,
    profileImagePath,
    commercialRegisterPath,
    taxCardPath,
  ];
}

class LogoutRequested extends AuthEvent {}

class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String otp;
  const VerifyOtpRequested({required this.email, required this.otp});

  @override
  List<Object> get props => [email, otp];
}

class ResendOtpRequested extends AuthEvent {
  final String email;
  const ResendOtpRequested(this.email);

  @override
  List<Object> get props => [email];
}
