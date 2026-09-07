import '../../models/order.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders({String? token});
}
