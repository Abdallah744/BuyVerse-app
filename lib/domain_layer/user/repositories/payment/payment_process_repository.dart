import '../../../../data_layer/user/user_models/payment_process_model.dart';

abstract class PaymentProcessRepository {
  Future<PaymentProcessModel> processPayment({
    required Map<String, dynamic> paymentPayload,
    String? token,
  });
}
