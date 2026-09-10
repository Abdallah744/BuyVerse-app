import 'package:dio/dio.dart';
import '../../../../core_layer/admin/helpers/dio_helper.dart';

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
