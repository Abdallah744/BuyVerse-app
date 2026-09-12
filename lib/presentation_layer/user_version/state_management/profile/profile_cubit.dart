import 'package:buy_verse_app/data_layer/user/services/shared_preferences_service.dart';
import 'package:buy_verse_app/domain_layer/user/repo/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

export 'profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this.repository) : super(ProfileInitial());

  final UserProfileRepository repository;

  Future<void> fetchProfile({String? token}) async {
    emit(ProfileLoading());

    try {
      final activeToken =
          token ?? await SharedPreferencesService.instance.getAuthToken();
      if (activeToken == null || activeToken.isEmpty) {
        emit(ProfileError('No auth token found'));
        return;
      }

      final user = await repository.getProfile(token: activeToken);
      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
