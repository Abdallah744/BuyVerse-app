import 'package:dio/dio.dart';
import '../../../../core_layer/admin/helpers/dio_helper.dart';

class OrderRepository {
  Future<Response> getOrders() async {
    return await DioHelper.getData(url: '/admin/orders');
  }
}
