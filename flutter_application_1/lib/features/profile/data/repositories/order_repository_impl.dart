import '../../domain/repositories/order_repository.dart';
import '../../models/order.dart';
import '../remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.remoteDataSource);

  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<List<OrderModel>> getOrders({String? token}) async {
    try {
      return await remoteDataSource.getOrders(token: token);
    } catch (_) {
      return OrderModel.mockOrders();
    }
  }
}
