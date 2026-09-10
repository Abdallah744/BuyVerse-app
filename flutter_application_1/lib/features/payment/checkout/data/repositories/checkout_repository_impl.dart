import '../../domain/repositories/checkout_repository.dart';
import '../../models/checkout_model.dart';
import '../remote/checkout_remote_data_source.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this.remoteDataSource);

  final CheckoutRemoteDataSource remoteDataSource;

  @override
  Future<CheckoutModel> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
    String? token,
  }) async {
    return remoteDataSource.createOrder(
      productIds: productIds,
      quantities: quantities,
      prices: prices,
      address: address,
      latitude: latitude,
      longitude: longitude,
      paymentMethod: paymentMethod,
      token: token,
    );
  }
}
