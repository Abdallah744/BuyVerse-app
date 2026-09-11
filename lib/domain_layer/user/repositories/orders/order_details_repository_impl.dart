import 'package:buy_verse_app/data_layer/user/remote_data/order_details_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/order.dart';

import 'order_details_repository.dart';

class OrderDetailsRepositoryImpl implements OrderDetailsRepository {
  const OrderDetailsRepositoryImpl(this.remoteDataSource);

  final OrderDetailsRemoteDataSource remoteDataSource;

  @override
  Future<OrderModel> getOrderDetails({
    required int orderId,
    String? token,
  }) async {
    return remoteDataSource.getOrderDetails(orderId: orderId, token: token);
  }
}
