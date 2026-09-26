import '../../../../data_layer/user/user_models/order.dart';

abstract class OrderDetailsRepository {
  Future<OrderModel> getOrderDetails({required dynamic orderId, String? token});
}
