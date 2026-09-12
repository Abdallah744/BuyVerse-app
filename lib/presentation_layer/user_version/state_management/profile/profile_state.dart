import 'package:buy_verse_app/data_layer/user/user_models/user_models.dart';

abstract class UserProfileState {}

class ProfileInitial extends UserProfileState {}

class ProfileLoading extends UserProfileState {}

class ProfileLoaded extends UserProfileState {
  ProfileLoaded(this.user);
  final UserModels user;
}

class ProfileError extends UserProfileState {
  ProfileError(this.message);
  final String message;
}
