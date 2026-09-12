import 'package:buy_verse_app/data_layer/user/remote_data/payment_process_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/payment_process_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/payment/payment_process_repository.dart';

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
