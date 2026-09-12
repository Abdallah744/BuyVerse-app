import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/admin/admin_models/profile.dart';
import '../../../../domain_layer/admin/usecases/base_usecase.dart';
import '../../../../domain_layer/admin/usecases/profile/profile_usecases.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfile>((event, emit) async {
      print('DEBUG: Fetching Profile...');
      emit(ProfileLoading());
      try {
        final response = await getProfileUseCase(NoParams());
        print('DEBUG: Profile Response Status: ${response.statusCode}');
        print('DEBUG: Profile Response Data: ${response.data}');

        if (response.statusCode == 200 && response.data['data'] != null) {
          final data = response.data['data'];

          String profileImg = data['picture_url'] ?? data['picture'] ?? '';
          if (profileImg.isNotEmpty && !profileImg.startsWith('http')) {
            profileImg = 'https://easylearn.devawy.com/$profileImg';
          }

          String commReg =
              data['commercial_register_url'] ??
              data['commercial_register'] ??
              '';
          if (commReg.isNotEmpty && !commReg.startsWith('http')) {
            commReg = 'https://easylearn.devawy.com/$commReg';
          }

          String taxCrd = data['tax_card_url'] ?? data['tax_card'] ?? '';
          if (taxCrd.isNotEmpty && !taxCrd.startsWith('http')) {
            taxCrd = 'https://easylearn.devawy.com/$taxCrd';
          }

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
                profileImage: profileImg,
                commercialRegisterUrl: commReg,
                taxCardUrl: taxCrd,
              ),
            ),
          );
        } else {
          emit(ProfileError(_parseError(response.data)));
        }
      } catch (e) {
        if (e is DioException) {
          emit(ProfileError(_parseError(e.response?.data)));
        } else {
          emit(ProfileError(e.toString()));
        }
      }
    });

    on<UpdateProfile>((event, emit) async {
      print('DEBUG: Updating Profile...');
      emit(ProfileLoading());
      try {
        // Extract lat/lng from storeLocation if available
        String? lat;
        String? lng;
        if (event.profile.storeLocation.contains(',')) {
          final parts = event.profile.storeLocation.split(',');
          if (parts.length >= 2) {
            lat = parts[0].trim();
            lng = parts[1].trim();
          }
        }

        FormData formData = FormData.fromMap({
          'name': event.profile.fullName,
          'email': event.profile.email,
          'phone': event.profile.phone,
          'national_id': event.profile.nationalId,
          'business_name': event.profile.businessName,
          'address': event.profile.businessAddress,
          if (lat != null) 'latitude': lat,
          if (lng != null) 'longitude': lng,
        });

        if (event.profileImagePath != null) {
          final profilePath = event.profileImagePath;
          if (profilePath != null) {
            formData.files.add(
              MapEntry(
                'picture',
                await MultipartFile.fromFile(
                  profilePath,
                  filename: 'profile.png',
                ),
              ),
            );
          }
        }

        if (event.commercialRegisterPath != null) {
          final commRegPath = event.commercialRegisterPath;
          if (commRegPath != null) {
            formData.files.add(
              MapEntry(
                'commercial_register',
                await MultipartFile.fromFile(
                  commRegPath,
                  filename: 'commercial.pdf',
                ),
              ),
            );
          }
        }

        if (event.taxCardPath != null) {
          final taxCardPath = event.taxCardPath;
          if (taxCardPath != null) {
            formData.files.add(
              MapEntry(
                'tax_card',
                await MultipartFile.fromFile(taxCardPath, filename: 'tax.pdf'),
              ),
            );
          }
        }

        final response = await updateProfileUseCase(formData);

        print('DEBUG: Update Profile Response: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          add(GetProfile());
        } else {
          emit(ProfileError(_parseError(response.data)));
        }
      } catch (e) {
        print('DEBUG: Update Profile Exception: $e');
        if (e is DioException) {
          emit(ProfileError(_parseError(e.response?.data)));
        } else {
          emit(ProfileError(e.toString()));
        }
      }
    });
  }

  String _parseError(dynamic errorResponse) {
    if (errorResponse is Map) {
      if (errorResponse['errors'] != null && errorResponse['errors'] is Map) {
        var errors = errorResponse['errors'] as Map;
        if (errors.isNotEmpty) {
          var firstKey = errors.keys.first;
          var firstError = errors[firstKey];
          if (firstError is List && firstError.isNotEmpty) {
            return "$firstKey: ${firstError[0]}";
          }
          return "$firstKey: $firstError";
        }
      }
      if (errorResponse['message'] != null) {
        return errorResponse['message'].toString();
      }
    }
    return errorResponse?.toString() ?? 'Operation failed';
  }
}
