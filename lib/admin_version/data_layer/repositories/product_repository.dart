import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';

class ProductRepository {
  Future<Response> getProducts({int page = 1}) async {
    return await DioHelper.getData(
      url: '/admin/products',
      query: {'page': page},
    );
  }

  Future<Response> addProduct({
    required FormData formData,
  }) async {
    return await DioHelper.postData(
      url: '/admin/products/store',
      data: formData,
    );
  }

  Future<Response> editProduct({
    required String id,
    required FormData formData,
  }) async {
    return await DioHelper.postData(
      url: '/admin/products/update/$id',
      data: formData,
    );
  }

  Future<Response> deleteProduct({
    required String id,
  }) async {
    return await DioHelper.deleteData(
      url: '/admin/products/delete/$id',
    );
  }
}
