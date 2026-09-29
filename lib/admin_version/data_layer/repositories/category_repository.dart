import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';

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
    required String slug,
  }) async {
    print('DEBUG: Repository deleteCategory called with slug: $slug');
    print('DEBUG: Full URL: /admin/categories/destroy/$slug');
    return await DioHelper.deleteData(
      url: '/admin/categories/destroy/$slug',
    );
  }
}
