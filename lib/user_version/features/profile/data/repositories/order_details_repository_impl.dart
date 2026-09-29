import '../../domain/repositories/order_repository.dart';
import '../../models/order.dart';
import '../remote/order_details_remote_data_source.dart';

class OrderDetailsRepositoryImpl implements OrderRepository {
  const OrderDetailsRepositoryImpl(this.remoteDataSource);

  final OrderDetailsRemoteDataSource remoteDataSource;

  @override
  Future<List<OrderModel>> getOrders({String? token}) async {
    return const [];
  }

  Future<OrderModel> getOrderDetails(
      {required int orderId, String? token}) async {
    try {
      return await remoteDataSource.getOrderDetails(
          orderId: orderId, token: token);
    } catch (_) {
      return OrderModel.mockOrders().first;
    }
  }
}
