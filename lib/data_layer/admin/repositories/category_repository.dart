import 'package:dio/dio.dart';
import '../../../../core_layer/admin/helpers/dio_helper.dart';

class CategoryRepository {
  Future<Response> getCategories() async {
    return await DioHelper.getData(url: '/admin/categories');
  }

  Future<Response> addCategory({
    required String name,
    required String description,
  }) async {
    return await DioHelper.postData(
      url: '/admin/categories/store',
      data: {
        'name': name,
        'description': description,
      },
    );
  }

  Future<Response> editCategory({
    required String id,
    required String name,
    required String description,
  }) async {
    return await DioHelper.putData(
      url: '/admin/categories/update/$id',
      data: {
        'name': name,
        'description': description,
      },
    );
  }

  Future<Response> deleteCategory({
    required String id,
  }) async {
    return await DioHelper.deleteData(
      url: '/admin/categories/destroy/$id',
    );
  }
}
