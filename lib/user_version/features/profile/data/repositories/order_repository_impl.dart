import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/order_repository.dart';
import '../../models/order.dart';
import '../remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl(this.remoteDataSource);

  final OrderRemoteDataSource remoteDataSource;

  @override
  Future<List<OrderModel>> getOrders({String? token}) async {
    final prefs = await SharedPreferences.getInstance();

    // إذا لم يأتِ التوكن كـ parameter، نقرأه من التخزين المحلي
    final activeToken = token ?? prefs.getString('auth_token');

    // نمرر التوكن الفعلي للـ remote data source
    return remoteDataSource.getOrders(token: activeToken);
  }
}
