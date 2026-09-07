import '../../domain/repositories/payment_repository.dart';
import '../../models/payment_model.dart';
import '../remote/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this.remoteDataSource);

  final PaymentRemoteDataSource remoteDataSource;

  @override
  Future<PaymentModel> payOrder({
    required int orderId,
    required Map<String, dynamic> paymentData,
    String? token,
  }) async {
    return remoteDataSource.payOrder(
      orderId: orderId,
      paymentData: paymentData,
      token: token,
    );
  }
}
