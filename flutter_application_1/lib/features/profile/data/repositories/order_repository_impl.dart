import 'package:easy_shop_profile/features/profile/data/remote/order_remote_data_source.dart';
import 'package:easy_shop_profile/features/profile/domain/repositories/order_repository.dart';
import 'package:easy_shop_profile/features/profile/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
