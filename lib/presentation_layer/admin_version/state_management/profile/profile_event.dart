part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class GetProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;
  final String? profileImagePath;
  final String? commercialRegisterPath;
  final String? taxCardPath;

  const UpdateProfile({
    required this.profile,
    this.profileImagePath,
    this.commercialRegisterPath,
    this.taxCardPath,
  });

  @override
  List<Object?> get props => [
    profile,
    profileImagePath,
    commercialRegisterPath,
    taxCardPath,
  ];
}
