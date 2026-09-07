import '../../models/payment_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> payOrder({
    required int orderId,
    required Map<String, dynamic> paymentData,
    String? token,
  });
}
