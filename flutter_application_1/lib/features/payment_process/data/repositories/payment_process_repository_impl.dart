import '../../domain/repositories/payment_process_repository.dart';
import '../../models/payment_process_model.dart';
import '../remote/payment_process_remote_data_source.dart';

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
