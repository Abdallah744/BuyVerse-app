import '../../../../data_layer/user/user_models/payment_model.dart';

abstract class PaymentRepository {
  Future<PaymentModel> payOrder({
    required dynamic orderId,
    required Map<String, dynamic> paymentData,
    String? token,
  });
}
