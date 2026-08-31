import 'package:buy_verse_app/presentation_layer/admin_version/state_management/admin_models/admin_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    const dummyProfile = UserProfile(
      fullName: 'Admin User',
      email: 'admin@buyverse.com',
      phone: '+1234567890',
      nationalId: '12345678901234',
      businessName: 'BuyVerse Admin Store',
      businessAddress: '123 Main St, Tech City',
      storeLocation: 'https://maps.google.com/?q=AdminStore',
    );

    on<GetProfile>((event, emit) {
      emit(ProfileLoading());
      emit(const ProfileLoaded(dummyProfile));
    });

    on<UpdateProfile>((event, emit) {
      emit(ProfileLoading());
      emit(ProfileLoaded(event.profile));
    });
  }
}
