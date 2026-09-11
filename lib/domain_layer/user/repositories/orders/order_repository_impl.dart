import 'package:shared_preferences/shared_preferences.dart';
import 'order_repository.dart';
import '../../../../data_layer/user/remote_data/order_remote_data_source.dart';
import '../../../../data_layer/user/user_models/order.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.remoteDataSource);

  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<List<OrderModel>> getOrders({String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    final activeToken = token ?? prefs.getString('auth_token');
    return remoteDataSource.getOrders(token: activeToken);
  }
}
