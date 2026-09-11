import '../../../../data_layer/user/user_models/order.dart';

abstract class OrderDetailsRepository {
  Future<OrderModel> getOrderDetails({required int orderId, String? token});
}
