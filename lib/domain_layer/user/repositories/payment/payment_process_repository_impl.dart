import '../../../../data_layer/user/remote_data/payment_process_remote_data_source.dart';
import '../../../../data_layer/user/user_models/payment_process_model.dart';
import 'payment_process_repository.dart';

class PaymentProcessRepositoryImpl implements PaymentProcessRepository {
  const PaymentProcessRepositoryImpl(this.remoteDataSource);

  final PaymentProcessRemoteDataSource remoteDataSource;

  @override
  Future<PaymentProcessModel> processPayment({
    required Map<String, dynamic> paymentPayload,
    String? token,
  }) async {
    return remoteDataSource.processPayment(
      paymentPayload: paymentPayload,
      token: token,
    );
  }
}
