import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';

class ProfileRepository {
  Future<Response> getProfile() async {
    return await DioHelper.getData(url: '/admin/profile');
  }

  Future<Response> updateProfile({
    required FormData formData,
  }) async {
    return await DioHelper.postData(
      url: '/admin/profile/update?_method=PUT',
      data: formData,
    );
  }
}
