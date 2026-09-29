import 'package:dio/dio.dart';
import 'package:buy_verse_app/admin_version/core_layer/helpers/dio_helper.dart';

class OrderRepository {
  Future<Response> getOrders() async {
    return await DioHelper.getData(url: '/admin/orders');
  }
}
