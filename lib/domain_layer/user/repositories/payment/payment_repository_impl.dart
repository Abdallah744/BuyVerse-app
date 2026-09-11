import '../../../../data_layer/user/remote_data/payment_remote_data_source.dart';
import '../../../../data_layer/user/user_models/payment_model.dart';
import 'payment_repository.dart';

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
