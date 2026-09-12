import 'package:buy_verse_app/data_layer/user/remote_data/payment_remote_data_source.dart';
import 'package:buy_verse_app/data_layer/user/user_models/payment_model.dart';
import 'package:buy_verse_app/domain_layer/user/repositories/payment/payment_repository.dart';

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
