import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_layer/admin/helpers/dio_helper.dart';
import '../../../../data_layer/admin/admin_models/profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final response = await DioHelper.getData(url: '/admin/profile');
        if (response.statusCode == 200 && response.data['data'] != null) {
          final data = response.data['data'];
          emit(
            ProfileLoaded(
              UserProfile(
                uId: data['id']?.toString() ?? '',
                fullName: data['name'] ?? '',
                email: data['email'] ?? '',
                phone: data['phone'] ?? '',
                nationalId: data['national_id'] ?? '',
                businessName: data['business_name'] ?? '',
                businessAddress: data['address'] ?? '',
                storeLocation:
                    '${data['latitude'] ?? ''}, ${data['longitude'] ?? ''}',
                profileImage: data['picture'] ?? '',
                commercialRegisterUrl: data['commercial_register'] ?? '',
                taxCardUrl: data['tax_card'] ?? '',
              ),
            ),
          );
        } else {
          emit(const ProfileError('Failed to fetch profile: data missing'));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            ProfileError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Failed to fetch profile',
            ),
          );
        } else {
          emit(ProfileError(e.toString()));
        }
      }
    });

    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        FormData formData = FormData.fromMap({
          'name': event.profile.fullName,
          'email': event.profile.email,
          'phone': event.profile.phone,
          'national_id': event.profile.nationalId,
          'business_name': event.profile.businessName,
          'address': event.profile.businessAddress,
          'latitude': '30.0',
          'longitude': '31.0',
        });

        if (event.profileImagePath != null) {
          formData.files.add(
            MapEntry(
              'picture',
              await MultipartFile.fromFile(
                event.profileImagePath!,
                filename: 'profile.png',
              ),
            ),
          );
        }

        if (event.commercialRegisterPath != null) {
          formData.files.add(
            MapEntry(
              'commercial_register',
              await MultipartFile.fromFile(
                event.commercialRegisterPath!,
                filename: 'commercial.pdf',
              ),
            ),
          );
        }

        if (event.taxCardPath != null) {
          formData.files.add(
            MapEntry(
              'tax_card',
              await MultipartFile.fromFile(
                event.taxCardPath!,
                filename: 'tax.pdf',
              ),
            ),
          );
        }

        final response = await DioHelper.postData(
          url: '/admin/profile/update',
          data: formData,
        );

        if (response.statusCode == 200) {
          add(GetProfile());
        } else {
          emit(const ProfileError('Failed to update profile'));
        }
      } catch (e) {
        if (e is DioException) {
          emit(
            ProfileError(
              e.response?.data['message']?.toString() ??
                  e.message ??
                  'Failed to update profile',
            ),
          );
        } else {
          emit(ProfileError(e.toString()));
        }
      }
    });
  }
}
