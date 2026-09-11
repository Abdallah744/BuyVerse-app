import '../../../../data_layer/user/user_models/order.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders({String? token});
}
