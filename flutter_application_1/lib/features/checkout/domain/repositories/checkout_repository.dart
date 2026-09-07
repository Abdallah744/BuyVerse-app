import '../../models/checkout_model.dart';

abstract class CheckoutRepository {
  Future<CheckoutModel> createOrder({
    required List<int> productIds,
    required List<int> quantities,
    required List<double> prices,
    required String address,
    required double latitude,
    required double longitude,
    required String paymentMethod,
    String? token,
  });
}
